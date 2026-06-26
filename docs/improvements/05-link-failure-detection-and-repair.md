# 05 — Link-failure detection, failure notification, and bounded repair

- **Deviation:** D5, D6
- **Priority:** P1
- **Effort:** L
- **Layer:** `core/` (detection state, notification, repair bounding) + adapters
  (hello-timeout tick, NS-3 link-failure hook)
- **Depends on:** 02 (notification carries pheromone estimates), shares
  `broadcastBudget` field with 04

## Summary

AntHocNet's failure handling has three parts; the repo implements only a partial
version of one of them:

1. **Detection** — via failed unicast **or** missed hellos
   (`t_hello × allowed_hello_loss`). Today: NS-2 detects only failed unicast;
   **NS-3 detects nothing** (no link-failure hook, no hello-timeout). Stale
   neighbours/pheromone are never removed in NS-3.
2. **Link-failure notification** — broadcast a message listing destinations whose
   best path was lost + the new best estimate, which neighbours apply and
   propagate. **Not implemented at all.**
3. **Local repair** — a route-repair ant, **bounded to max 2 broadcasts** and a
   wait of ~5× the path delay, then discard buffered packets + notify. Today a
   repair ant is unbounded (`lifeAnt` carried but never enforced), floods like a
   reactive ant up to `networkDiameter` hops, and exists only in NS-2.

## Spec reference

> "Nodes can detect link failures ... when unicast transmissions fail, or when
> expected periodic pheromone diffusion messages were not received. ... The
> disappearance of a neighbour is assumed when such an event has not taken place
> for a certain amount of time, defined by **t_hello × allowed-hello-loss**." —
> [1] §3.5

> "When a node `i` discovers the disappearance of a neighbour `n`, it ... removes
> all associated entries from its pheromone table. Next, `i` **broadcasts a link
> failure notification message**. This message contains a list of the
> destinations to which `i` lost its best path, and the new best pheromone ...
> All its neighbours receive the message and update their pheromone table ... If
> they in turn lost their best or their only path ... they will pass the updated
> message on." — [1] §3.5

> "If `i` detected the link failure via the failed transmission of a data packet,
> and there is no other path available ... it will try to locally repair ... The
> node broadcasts a route repair ant that travels to the destination like a
> reactive forward ant ... One important difference is that it has a **maximum
> number of broadcasts (which we set to 2)** ... The node waits for a certain
> time (empirically set to **5 times the estimated end-to-end delay** of the lost
> path), and if no backward repair ant is received by then, ... packets ... are
> discarded, and the node sends a link failure notification." — [1] §3.5

## Current behaviour

NS-2 link-failure callback: removes neighbour, enqueues the packet, broadcasts an
unbounded repair ant — **no notification**, **no wait/discard logic**:

```286:304:ns2/src/ahn_router.cc
void AntHocNetAgent::linkFailed(Packet* p) {
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);
    const nsaddr_t broken = ch->next_hop_;

    if (logic_) logic_->loseNeighbor(broken);

    if (ch->ptype() != PT_ANT) {
        const nsaddr_t dest = ih->daddr();
        enqueue(p, dest);
        if (logic_) {
            AntMessage rrfa = logic_->createForwardAnt(AntType::Repair, dest);
            rrfa.lifeAnt = AHN_LIFE_ANT;          // <-- set but never checked
            sendAnt(rrfa, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
        }
    } else {
        Packet::free(p);
    }
}
```

`loseNeighbor` only cleans the local table:

```25:27:core/src/ant_router_logic.cpp
void AntRouterLogic::loseNeighbor(NodeAddress neighbor) {
    engine_.cleanNeighbor(table_, neighbor);
}
```

In the **core**, a `Repair` ant is treated exactly like a reactive forward ant
(`proactive = (ant.type == AntType::Proactive)` is false for `Repair`), and
`lifeAnt` is never read anywhere. **NS-3 has no link-failure path** — search
`anthocnet-routing-protocol.cc`: `loseNeighbor` is never called, and there is no
neighbour-expiry timer.

## Impact

- **NS-3 correctness gap:** neighbours that move away are never removed; pheromone
  for dead links persists and is selected, so data is sent into the void →
  delivery collapses (a likely contributor to the NS-3 benchmark numbers).
- No failure notification → upstream nodes keep stale best-paths, sending data
  toward a break until their own ants happen to correct it.
- Unbounded repair ants → network-wide floods on every break (overhead spike),
  and buffered packets are never deterministically released/discarded.

## Required change

This is the largest item; implement in four sub-steps. Sub-step A is the most
important (it fixes the NS-3 correctness gap).

### Detection model (ADR-0008)

Per [ADR-0008](../adr/0008-neighbour-liveness-two-detectors.md), neighbour loss is
found by **two complementary detectors that both call the same `loseNeighbor(n)`**:

- **A — hello-timeout (core timer): the portable coverage path, and primary.**
  Spec-faithful, simulator-agnostic, the *only* detector NS-3 has, and the one
  that covers idle neighbours. Mandatory.
- **D — MAC transmit-failure (adapter signal): a fast-path accelerator.** Reacts
  immediately on a failed unicast to an active next hop; never the sole detector.

`INeighborProvider` stays **advisory** ("who can I hello / who's a candidate"),
never authoritative for removal — its doc comment should say so. The pheromone
table is driven by reception + explicit loss events only.

### A. Hello-timeout detection — the portable coverage path (both adapters, driven by core state)

Track last-seen time per neighbour in the core and expire on a tick.

```cpp
// PheromoneTable / AntRouterLogic
void touchNeighbor(NodeAddress n, double now);          // on any reception from n
std::vector<NodeAddress> expiredNeighbors(double now,   // now - lastSeen > t_hello*allowedLoss
                                          double maxIdle) const;
```

- `learnNeighbor`/`onReceiveAnt` already learn from `prevHop` and hello `src`; add
  `touchNeighbor(n, clock_.now())` there.
- Add `Config::allowedHelloLoss = 2;` (so `maxIdle = helloInterval * allowedHelloLoss`).
- Add a core method `std::vector<RouteDecision> onMaintenanceTick()` that calls
  `expiredNeighbors`, runs `loseNeighbor` on each, and returns any link-failure
  **notification** broadcasts (sub-step B).
- **Adapters:** drive `onMaintenanceTick()` from the existing periodic timer
  (NS-3 `HelloTimerExpire`, NS-2 `AhnHelloTimer::handle`). For NS-3 this is the
  *only* way neighbour loss is detected, so it is mandatory.
- **Hellos run independently of diffusion.** The diffusion gate
  (`enableDiffusion`, [ADR-0007](../adr/0007-proactive-diffusion-gated.md)) only
  suppresses the hello *pheromone payload* — hello broadcasts and this
  liveness/maintenance tick must keep running even when proactive/diffusion is
  off, because neighbour-loss detection does not depend on them.

### B. Link-failure notification message

Add a new ant type and a payload of `(dest, newBestPheromone)` entries — reuse
the existing `helloDests` vector shape (it is already `(node, pheromone)`):

```cpp
enum class AntType : std::uint8_t {
    Hello     = 0x01,
    Reactive  = 0x02,
    Proactive = 0x04,
    Repair    = 0x08,
    LinkFail  = 0x10,   // NEW: link-failure notification
};
```

When `loseNeighbor(n)` removes the **best** next hop for one or more destinations:
- collect those destinations and the node's **new** best pheromone (0 if none
  left) into a `LinkFail` ant's `helloDests`;
- return a `Broadcast` `RouteDecision` for it.

On receiving a `LinkFail` ant in `onReceiveAnt`:
- for each `(dest, newBest)`: update/remove the regular pheromone via the
  reporting neighbour (`reinforce`/remove);
- if this node *itself* lost its best or only path to `dest` as a result,
  **re-broadcast** an updated `LinkFail` ant (propagation), bounded by the
  `broadcastBudget`/dedup so it can't loop.

(Dedup: `LinkFail` ants get a `(src,seq)` like any ant, so the existing
`AntHistoryTracker` stops loops.)

### C. Bound the repair ant + wait/discard

1. Add `int broadcastBudget` to `AntMessage` (shared with item 04). On each
   `RouteAction::Broadcast` of a forward ant, decrement; when it reaches 0,
   stop broadcasting (return `Drop` instead of `Broadcast`). Initialise repair
   ants to `config_.repairMaxBroadcasts = 2`.
2. Enforce `lifeAnt` (or reuse `broadcastBudget` + a hop cap): a repair ant should
   travel at most a few hops. At minimum, **read `lifeAnt`** and drop the repair
   ant once exceeded — today it is dead config.
3. Adapter-side wait/discard: when a repair is launched, schedule a timer for
   `~5 × estimatedDelay` (use a config default `repairWaitFactor = 5` × a delay
   estimate, or a flat `config_.repairTimeout` if no delay estimate is available
   yet). If no backward repair ant arrives by then, **discard** the buffered
   packets for that destination and emit a `LinkFail` notification. Implement in
   both adapters (they own the pending queue + timers).

### D. MAC transmit-failure — the fast-path accelerator (both adapters)

This is the *second* detector from ADR-0008, not a replacement for A. NS-2 already
has it (the `linkFailed` callback above); wire the NS-3 equivalent for parity.

NS-3 can detect transmit failures via the WiFi MAC `TxErrHeader`/drop traces or
an `ArpL3Protocol`/`Ipv4L3Protocol` tx-error callback. Hook one and, on failure
to a next hop, call the **same** `loseNeighbor` + repair path used by sub-steps
A/C (the two detectors converge on one code path). If a clean hook isn't readily
available, sub-step A (hello timeout) already gives NS-3 working detection —
document the limitation and leave a TODO. Because A is mandatory and authoritative,
D is a latency optimisation: it never changes *what* is detected, only *how fast*.

## Files to touch

- `core/include/anthocnet/core/ports.h` (clarify `INeighborProvider` doc comment:
  advisory adjacency, never authoritative for removal — ADR-0008)
- `core/include/anthocnet/core/ant_message.h` (`AntType::LinkFail`, `broadcastBudget`)
- `core/include/anthocnet/core/config.h` (`allowedHelloLoss`, `repairMaxBroadcasts`,
  `repairWaitFactor`/`repairTimeout`)
- `core/include/anthocnet/core/pheromone_table.{h,cpp}` (last-seen, `expiredNeighbors`)
- `core/include/anthocnet/core/ant_router_logic.{h,cpp}` (`touchNeighbor`,
  `onMaintenanceTick`, `LinkFail` handling, repair bounding)
- `core/src/pheromone_engine.cpp` (apply notification updates)
- `core/src/ant_message_codec.cpp` + `ns2/src/ant_packet_ns2.*` +
  `ns3/model/anthocnet-packet.cc` + `core/tests/test_codec.cpp` (new field
  `broadcastBudget`; `LinkFail` reuses `helloDests`)
- `ns3/model/anthocnet-routing-protocol.cc` (maintenance tick, tx-error hook,
  repair wait/discard)
- `ns2/src/ahn_router.cc` (maintenance tick, bounded repair, wait/discard)

## Acceptance criteria

Add `core/tests/test_link_failure.cpp`:

1. **Hello timeout expires a neighbour.** Learn neighbour `n`; advance `FakeClock`
   beyond `helloInterval × allowedHelloLoss` with no reception; `onMaintenanceTick()`
   removes `n` and its pheromone.
2. **Notification emitted on best-path loss.** When losing `n` drops the only path
   to `d`, `onMaintenanceTick()` (or `loseNeighbor`) returns a `Broadcast`
   `LinkFail` ant whose `helloDests` contains `d` with the new best (0).
3. **Notification applied + propagated.** A node receiving a `LinkFail` for `d`
   updates its table; if it loses its own best path it re-broadcasts (bounded),
   otherwise it does not.
4. **Repair bounded.** A `Repair` ant with `broadcastBudget = 2` is broadcast at
   most twice across nodes, then dropped (assert no `Broadcast` on the 3rd).
5. **NS-3 parity (build-level):** assert (in code review / a smoke run) that the
   NS-3 adapter calls `onMaintenanceTick()` on its timer.
6. `make test` green; codec round-trip still passes with the new field.

## Risks / notes

- This adds a wire field (`broadcastBudget`) and a new ant type — do the codec +
  both adapter headers + `test_codec.cpp` as one atomic change.
- Keep `LinkFail` propagation strictly dedup-guarded to avoid broadcast storms.
- The exact "5× end-to-end delay" wait needs a delay estimate; if item 02's delay
  metric isn't in yet, use a flat `repairTimeout` and TODO the adaptive version.
- Sub-step A alone is worth shipping first — it closes the NS-3 correctness gap
  with modest effort.
