# The ant types

AntHocNet's control plane is five ant types travelling in two directions. This
page is the reference: what triggers each ant, how it moves, what it changes,
and which switch turns it off. The *idea* behind them is in
[`ant-colony-routing.md`](ant-colony-routing.md); where they sit in the software
is [`software-layers.md`](software-layers.md); which ones are live in each
network regime is [`network-regimes.md`](network-regimes.md) §6.

Types and directions are declared in
[`core/include/anthocnet/core/ant_message.h`](../core/include/anthocnet/core/ant_message.h)
and all handling lives in one pure function —
`AntRouterLogic::onReceiveAnt()` in
[`core/src/ant_router_logic.cpp`](../core/src/ant_router_logic.cpp).

## 1. Taxonomy: five types, two directions

The wire values match the legacy `ANTTYPE*` bit flags so old traces stay
comparable. **Direction is orthogonal to type**: three types make a round trip
(forward out, backward home), two are one-way notifications that are never
answered.

```mermaid
flowchart TB
    ANT["<b>AntMessage</b><br/>type · direction · src · dst · seqNum<br/>visited[] · history[] · helloDests[]<br/>broadcastBudget · lifeAnt"]

    ANT --> RT["<b>Round-trip ants</b><br/>Up → destination, Down → source"]
    ANT --> OW["<b>One-way ants</b><br/>Up only, never answered"]

    RT --> RE["<b>Reactive</b> 0x02<br/>find an unknown route"]
    RT --> PR["<b>Proactive</b> 0x04<br/>maintain / improve a known route"]
    RT --> RP["<b>Repair</b> 0x08<br/>rebuild a route that just broke"]

    OW --> HE["<b>Hello</b> 0x01<br/>neighbour liveness + diffusion adverts"]
    OW --> LF["<b>LinkFail</b> 0x10<br/>tell neighbours a route died"]

    RE -.->|"at dst: flips"| BK["<b>direction = Down</b><br/>backward ant — the only<br/>thing that deposits pheromone"]
    PR -.->|"at dst: flips"| BK
    RP -.->|"at dst: flips"| BK

    style RE fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style PR fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style RP fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style HE fill:#eef,stroke:#5b4fc4,stroke-width:2px
    style LF fill:#f6dede,stroke:#c0392b,stroke-width:2px
    style BK fill:#fff3d4,stroke:#c48f00,stroke-width:2px
```

The single most important row of the next table: **only a backward ant writes
regular pheromone.** Forward ants gather evidence; hello adverts write the
*virtual* table; LinkFail removes or discounts entries. Nothing else reinforces.

## 2. Comparison table

| | **Hello** | **Reactive** | **Proactive** | **Repair** | **LinkFail** |
|---|---|---|---|---|---|
| Wire value | `0x01` | `0x02` | `0x04` | `0x08` | `0x10` |
| Purpose | neighbour liveness; carry diffusion adverts | discover a route nobody has | maintain and improve an in-use route | rebuild a route that just broke | announce that a route died |
| Trigger | timer, every `HelloInterval` (1 s) | data packet with no route (≤1 per dest per `ReactiveRetryInterval` 0.25 s) | maintenance tick per active session (`ProactiveInterval` 10 s, session `SessionTtl` 5 s) | link/tx failure with no surviving route to that dest | neighbour loss, or repair deadline expiring |
| Direction | Up only | Up, then Down | Up, then Down | Up, then Down | Up only |
| Transport | broadcast, one hop | broadcast flood (unicast if `EnableDirectedReactive`) | unicast along pheromone; broadcast with prob `ProactiveBroadcastProb` 0.1 per hop to explore | broadcast | broadcast, hop by hop |
| Flood bound | none — one hop, consumed locally | **not** per-ant (`broadcastBudget = -1`); bounded per (node, generation) by `reactiveMaxBroadcasts` (#169/#173) | `proactiveMaxBroadcasts` per path (#45) | `repairMaxBroadcasts` per path; plus `lifeAnt` lifetime | `repairMaxBroadcasts`; absorbed early if an alternate survives (#96) |
| Payload | `helloDests[]` = (dest, best regular pheromone) adverts | `visited[]` path stack | `visited[]` path stack | `visited[]` + `lifeAnt` | `helloDests[]` = (dest, new best) — `0` means *no path left* |
| Writes | **virtual** pheromone + neighbour set | nothing on the way out | nothing on the way out | nothing on the way out | removes/discounts **regular** pheromone at each receiver |
| Answered by | — (consumed locally, never re-forwarded) | backward ant | backward ant | backward ant (which also cancels the repair deadline) | — |
| Gate | `HelloInterval`; adverts need `EnableProactive` + `EnableDiffusion` | `EnableReactive` | `EnableProactive` | `EnableRepair` | `EnableLinkFail` (propagation only — the local pheromone update still applies) |
| Hop ceiling | 1 | `maxPathLength` | `maxPathLength` | `maxPathLength` | — |

And the direction that does the writing:

| | **Backward ant** (`direction = Down`) |
|---|---|
| Created | at the destination of any Reactive / Proactive / Repair forward ant |
| Transport | unicast, retracing `history[]` hop by hop |
| Writes | **regular** pheromone at every node it passes — `computeBackAntState()` rebuilds the deposit from the carried path, `reinforceFromBackAnt()` applies it |
| Deposit value | from `ILinkMetric` (default `ClassicMetric`, the paper's Eq. 2 over path time and hop count) |
| Side effects | cancels a pending repair deadline for that destination; at the origin, returns `deliver()` so the adapter flushes queued data |

## 3. Lifecycle: reactive route setup

The core loop — a data packet with no route, and what it costs to get one.

```mermaid
sequenceDiagram
    autonumber
    participant App as App @ S
    participant S as Source S
    participant I as Intermediate nodes
    participant D as Destination D

    App->>S: data packet, no route
    Note over S: queue the packet (RouteAction::Queue)<br/>≤1 ant per dest per ReactiveRetryInterval
    S->>I: Reactive forward ant (broadcast)
    Note over I: no pheromone for D →<br/>rebroadcast (bounded per node+generation)<br/>each hop appends to visited[]
    I->>D: Reactive forward ant
    Note over D: stamp own contribution<br/>createBackAnt(): direction = Down<br/>history[] = the path taken
    D-->>I: Backward ant (unicast, retracing)
    Note over I: computeBackAntState → reinforceFromBackAnt<br/><b>regular pheromone written here</b>
    I-->>S: Backward ant
    Note over S: deliver() → flush the queued data
    S->>D: data now routed stochastically (BetaData = 20)
```

Multipath (`EnableMultipath`, on by default) is what makes step 6 happen more
than once: later same-generation ants are admitted through the acceptance band
(a1 = 0.9, a2 = 2.0 for a *new first hop*), so several backward ants deposit
along several paths.

That band is the protocol's headline claim, so it is worth seeing the copies
compete rather than taking it on trust. One flood, one generation `(src, seq)`,
three copies arriving at the destination:

```mermaid
sequenceDiagram
    autonumber
    participant S as source S
    participant P1 as path via A<br/>(first hop A)
    participant P2 as path via B<br/>(first hop B)
    participant D as destination D

    S->>P1: reactive ant, generation (S, seq)
    S->>P2: same generation, different first hop

    P1->>D: copy 1 — 3 hops, 40 ms
    Note over D: first arrival sets the<br/>generation's best: hops 3, time 40 ms
    D-->>S: backward ant → deposits path A

    P2->>D: copy 2 — first hop <b>B is new</b>
    Note over D: new first hop ⇒ a2 = 2.0 applies<br/>4 hops ≤ 3×2.0 and 70 ms ≤ 40×2.0 → <b>admit</b>
    D-->>S: backward ant → deposits path B<br/><i>this is the disjoint path</i>

    P1->>D: copy 3 — first hop A already seen
    Note over D: same first hop ⇒ a1 = 0.9 applies<br/>5 hops > 3×0.9 → <b>reject</b>
    Note over D: no backward ant — the flood<br/>does not become a deposit storm

    Note over S: S now holds pheromone for D via<br/>BOTH A and B — data is spread over them
```

Two asymmetries in that band do the work, and both are thesis values
([#177](https://github.com/danieljoppi/AntHocNet/issues/177)):

- **a1 = 0.9 is *below* 1.0**, so for an already-seen first hop the band
  *suppresses* rather than admits — only ants better than the best so far get
  through. (The 2004 paper says 1.5; the 2007 thesis reports its authors ran
  0.9, "in order to only allow the best ants through", and the thesis
  supersedes.)
- **a2 = 2.0 is deliberately permissive**, applied only when the first hop is
  one no accepted ant of this generation used. That is the mechanism actively
  *rewarding* disjointness rather than merely tolerating it — which is why
  a2 must stay ≥ a1, or the mechanism penalises exactly what it exists to
  create.

## 4. Lifecycle: proactive maintenance and diffusion

Two mechanisms that only exist while a flow is active. Hello adverts build the
*virtual* table; proactive ants turn a promising virtual entry into a real,
measured one.

```mermaid
flowchart LR
    subgraph DIFF["Diffusion — every 1 s, one hop"]
        H1["Node advertises its best<br/>regular pheromone per dest"] -->|Hello ant| H2["Neighbour writes the<br/><b>virtual</b> table (bootstrapped,<br/>discounted one hop)"]
    end

    subgraph PROA["Proactive — every 10 s, per active session"]
        P1{"virtual ≥ regular<br/>× (1 + ProactiveVirtualMargin)?"}
        P1 -->|"yes (margin 0 ⇒ always)"| P2["Proactive forward ant"]
        P1 -->|no| P3["skip this tick"]
        P2 --> P4{"per hop"}
        P4 -->|"prob 0.9"| P5["unicast along pheromone"]
        P4 -->|"prob 0.1<br/>ProactiveBroadcastProb"| P6["broadcast — explore"]
        P5 & P6 --> P7["reaches dest → backward ant<br/><b>virtual guess becomes<br/>measured regular pheromone</b>"]
    end

    H2 -.->|"the gradient<br/>proactive ants test"| P1

    style H2 fill:#eef,stroke:#5b4fc4
    style P7 fill:#fff3d4,stroke:#c48f00
```

`ProactiveVirtualMargin` defaults to **0** (send every tick) — the thesis's 10 %
gate was measured harmful in
[#180](https://github.com/danieljoppi/AntHocNet/issues/180): it compares a
bootstrapped estimate against a measured one, which suppressed nearly all
maintenance and tripled reactive rediscovery.

## 5. Lifecycle: failure, repair, and the death notice

The only path where an ant *removes* pheromone rather than adding it.

```mermaid
flowchart TB
    F["Link to next hop breaks<br/>(detector A: hello timeout ·<br/>detector D: Wi-Fi MAC tx failures)"]
    F --> Q{"does a route to that dest<br/>survive via another neighbour?"}

    Q -->|yes| ABS["absorb — prune the dead entry,<br/>keep forwarding<br/>(multipath, #96)"]
    Q -->|no| RA["<b>Repair ant</b> (broadcast, lifeAnt budget)<br/>+ arm the repair deadline<br/>(RepairWaitFactor × lost path delay,<br/>else RepairTimeout)"]

    RA --> W{"backward ant returns<br/>before the deadline?"}
    W -->|yes| OK["route restored —<br/>deadline cancelled,<br/>queued data flushed"]
    W -->|no| LFN["<b>LinkFail note</b> (broadcast)<br/>helloDests = (dest, 0.0)<br/>= no path left"]

    LFN --> NB["each receiver:<br/>remove or discount its entry via<br/>the reporter, then re-propagate<br/>— unless its own best survives"]

    style ABS fill:#e2f0ed,stroke:#0f7f70
    style OK fill:#e2f0ed,stroke:#0f7f70
    style LFN fill:#f6dede,stroke:#c0392b
    style RA fill:#fff3d4,stroke:#c48f00
```

A LinkFail note carries the reporter's *new best* pheromone per destination, not
just "dead": a non-zero value lets receivers re-bootstrap a discounted entry
instead of dropping the destination entirely. `LinkfailNotifyInterval` (5 s)
rate-limits notes about the same destination so one flapping link cannot storm
the network ([#20](https://github.com/danieljoppi/AntHocNet/issues/20)).

## 6. How to see them at runtime

The types are not just a design abstraction — they are counted and traceable:

- **`--diag`** on `anthocnet-compare` / `isl-grid` prints per-type Tx/Rx tallies
  (`hello`, `reactive`, `proactive`, `repair`, `linkfail`, each split
  forward/backward), plus first-delivery time, per-flow route-setup latency
  ([#23](https://github.com/danieljoppi/AntHocNet/issues/23)), link-failure
  origin/propagation/suppression counters
  ([#20](https://github.com/danieljoppi/AntHocNet/issues/20)) and pheromone-table
  gauges ([#133](https://github.com/danieljoppi/AntHocNet/issues/133)).
- **ns-3 trace sources** `Tx` and `Rx` on
  `ns3::anthocnet::RoutingProtocol` carry `(type, direction, broadcast)` per ant,
  so an experiment can histogram the control plane without patching the core.
- **`nrl` / `nrl_bytes`** aggregate all of it into the overhead the benchmark
  tables report — control packets (and bytes) per delivered data packet.

The planned ant-type **ablation matrix**
([#244](https://github.com/danieljoppi/AntHocNet/issues/244)) turns the gate
column of §2 into an experiment: disable one type at a time and measure what
each actually buys.

## See also

- [`ant-colony-routing.md`](ant-colony-routing.md) — the concepts: stigmergy, ACO, AntNet, and how AntHocNet's mechanisms follow from them.
- [`software-layers.md`](software-layers.md) — where ants sit in the stack, and the switch that gates each mechanism.
- [`network-regimes.md`](network-regimes.md) §6 — which ant types are live, redundant, or inert on MANET vs satellite ISL.
- [`configuration.md`](configuration.md) — every attribute named above, with its default and provenance.
- [`wire-format.md`](wire-format.md) — the canonical on-wire ant layout and version byte.
