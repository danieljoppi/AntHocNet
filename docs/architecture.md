# Architecture

AntHocNet is implemented as one simulator-agnostic algorithm core with a thin
adapter per simulator. The core never includes an NS-2 or NS-3 header; the
adapters never reimplement routing logic.

```
                +-------------------------------------------+
                |                  core/                    |
                |  (simulator-agnostic C++, no sim deps)    |
                |                                           |
                |  PheromoneTable      AntMessage (POD)     |
                |  PheromoneEngine     VisitedPath (vector) |
                |  AntHistoryTracker   AntRouterLogic       |
                |                       -> RouteDecision     |
                |  Ports: IClock IRng INeighborProvider     |
                |         ITimerScheduler                   |
                +----------------+--------------------------+
                                 |
              implements ports   |   returns RouteDecisions
                                 |
        +------------------------+------------------------+
        |                                                 |
+-------v---------+                             +---------v---------+
|     ns2/        |                             |       ns3/        |
| AntHocNetAgent  |                             | RoutingProtocol : |
|  : Agent        |                             | Ipv4RoutingProtocol|
| AntPacketHeader |                             | AntHeader:ns3::Hdr |
| Ns2Clock/Ns2Rng |                             | Ns3Clock/Ns3Rng   |
| + source patch  |                             | + contrib module  |
+-----------------+                             +-------------------+
```

## The core

### Value types

- **`AntMessage`** — a plain, copyable description of an ant: type, direction,
  src/dst, `seqNum` (32-bit), timing, `broadcastBudget`, the visited/history
  stacks, and hello adverts. The back-ant deposit state (prevHop/hops/pathTime/
  pheromone) is transient — recomputed from `history`, not carried (ADR-0009).
  This replaces the original header-resident `AntTimeEntry**` malloc'd arrays.
- **`VisitedPath`** — `std::vector<AntHop>`; `AntHop` is `{node, time}`.
- **`AntMessageCodec`** — canonical little-endian wire format, reused by both
  adapters and round-trip tested.

### Stateful components

- **`PheromoneTable`** — regular/virtual pheromone maps keyed by
  `(neighbor, destination)`, the neighbour set, and per-table destination sets.
  Stochastic next-hop selection takes its randomness from an injected `IRng`.
- **`PheromoneEngine`** — the evaporation/reinforcement math
  (`evaporate`, `reinforce`, `updateRegular`, `updateVirtual`, `cleanNeighbor`).
- **`AntHistoryTracker`** — `(src, seqNum)` duplicate detection, FIFO-capped.
- **`AntRouterLogic`** — owns the above plus the node address and sequence
  counter. It is pure: `onReceiveAnt()` / `onDataPacket()` return
  `RouteDecision`s; they never touch a simulator.

### Ports

The adapters implement these so the core stays I/O-free:

| Port | NS-2 | NS-3 |
|------|------|------|
| `IClock` | `Scheduler::instance().clock()` | `Simulator::Now()` |
| `IRng` | `Random` | `UniformRandomVariable` |
| `INeighborProvider` | pheromone-table view | pheromone-table view |
| `ITimerScheduler` | `Scheduler::schedule` | `Simulator::Schedule` |

## Decision flow

```
incoming ant  ->  AntRouterLogic::onReceiveAnt(msg, prevHop)
                    - reactive forward ant (enableMultipath, default on): per-
                      generation acceptance band ([1] §3.1, #96) — a later
                      (src,seq) copy within antAcceptanceFactor (1.5) of the
                      best seen on BOTH hops and travel time is admitted, so
                      several good paths get laid down; all other ants (and
                      everything when the gate is off): strict (src,seq)
                      dedup -> Drop on duplicate
                    - learn prevHop as neighbour
                    - hello: update virtual table, consume
                    - forward ant: stamp self; if dst==self spawn back ant;
                      else select next hop (Unicast) or Broadcast
                    - back ant: reinforce travelled link; if dst==self Deliver
                      (flush queue); else advance one hop (Unicast)
                  -> vector<RouteDecision>

local data    ->  AntRouterLogic::onDataPacket(dst)
                    - route known -> Unicast
                    - no route    -> Queue + reactive forward ant (Broadcast)
```

`RouteDecision { action, nextHop, message }` with
`action ∈ {Unicast, Broadcast, Queue, Deliver, Drop, None}`. The adapter maps
each action onto its simulator (schedule a send, enqueue, deliver to the local
transport, or drop).

## Adapter responsibilities

The adapters do only what is intrinsically simulator-specific:

- convert packet headers ⇄ `AntMessage`;
- carry out `RouteDecision`s (send/queue/deliver/drop);
- own the periodic timers (hello, proactive, maintenance);
- hold the pending-packet queue and, for NS-2, the link-failure callback.
