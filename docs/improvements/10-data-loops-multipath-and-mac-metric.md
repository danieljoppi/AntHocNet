# 10 — Data-loop suppression, multipath safety, reactive broadcast cap, MAC-aware metric

- **Covers:** A1 (data loops / multipath), A3 (reactive max-broadcasts), A2 (MAC-aware per-hop cost)
- **Priority:** A1 **P1**, A3 **P2**, A2 **P2**
- **Effort:** M
- **Layer:** `core/` (+ small adapter hooks for A2)
- **Depends on:** 02 (A2 deepens it), 04/05 (share `broadcastBudget`)

## A1 — Data-packet loop suppression and multipath safety

- **Decision:** prev-hop exclusion is **always on**; per-flow stickiness is
  **config-gated, default off**, and lives in `core/` — see
  [ADR-0010](../adr/0010-data-forwarding-prevhop-excluded-stochastic.md).

### Problem

Data is forwarded by an independent stochastic draw at **every** hop, with no
exclusion of the hop the packet just came from, so transient routing loops are
possible and only the IP TTL stops them. Per-packet randomness also reorders a
single flow's packets across multiple paths.

### Spec basis

AntHocNet spreads data stochastically over a *mesh* of paths, but relies on the
pheromone gradient being effectively loop-free; real implementations additionally
avoid sending a packet back the way it came and damp per-packet flapping. The
paper notes a node "removes the wrong routing information" of the hop a packet
came from in some cases — i.e. the incoming neighbour is treated specially.

### Current behaviour

In-transit data re-enters the same stochastic path with no prev-hop exclusion:

```250:251:ns3/model/anthocnet-routing-protocol.cc
    // In-transit forwarding.
    NodeAddress next = m_logic->selectNextHop(ToCore(dst), /*proactive=*/false);
```

```176:184:core/src/ant_router_logic.cpp
std::vector<RouteDecision> AntRouterLogic::onDataPacket(NodeAddress dest) {
    NodeAddress next = table_.lookup(dest, rng_);
    if (next == kInvalidAddress) {
        ...
    }
    return {{RouteAction::Unicast, next, false, {}}};
}
```

`onDataPacket` takes only `dest`; it cannot exclude the previous hop because it
isn't told it. (NS-2 `handleData` is the same.)

### Required change

1. Give the core the incoming neighbour: `onDataPacket(dest, prevHop = kInvalidAddress)`
   and `PheromoneTable::lookup(dest, beta, rng, exclude = kInvalidAddress)`.
   In `nextNeighborNode`, skip the excluded neighbour when forming `phSum` and
   when selecting (don't route a packet back to the hop it arrived from, unless it
   is the *only* next hop).
2. Adapters pass the previous hop: NS-3 `RouteInput` knows `idev` → map to the
   sender; NS-2 `handleData` has `ch->prev_hop_`.
3. **Per-flow stickiness — config-gated, default off (ADR-0010).** Behind
   `Config::enableFlowStickiness` (default `false`), cache the chosen next hop per
   `(src,dst)` flow for a short window (`Config::flowStickyTtl`) so a burst follows
   one path; re-draw only when the cache expires or the path degrades. Keep it
   **bounded** (FIFO, like the dedup history) and in `core/` (routing policy,
   golden rule #2). This needs the packet **src**, so the data entry point becomes
   `onDataPacket(dest, prevHop, src)`; adapters pass it (NS-3 origin / NS-2
   `ih->saddr()`).
   - Default off because a high greedy `β_data` ([item 01](01-data-vs-ant-beta.md))
     already concentrates data on the best path (per-packet reordering is limited
     in the paper's regime), and pure per-packet stochastic is the paper-faithful
     baseline. Turn it on only for reorder-sensitive (TCP) traffic, and measure it
     as a benchmark ablation (item 08).

### Acceptance

- `test_data_routing.cpp`: a packet arriving from neighbour `n` is never
  forwarded back to `n` while another next hop with pheromone exists; if `n` is
  the only option it still forwards (no black hole).
- Loop regression: in a small ring topology with stochastic pheromone, injected
  data is delivered without TTL-expiry drops.
- **Stickiness gate (ADR-0010):** with `enableFlowStickiness = false` (default),
  a flow re-draws each packet; with it `true`, a burst on `(src,dst)` follows a
  single cached next hop until `flowStickyTtl` expires or the path degrades.

## A3 — Reactive forward-ant maximum broadcasts

### Spec basis

> "...it has a **maximum number of broadcasts (which we set to 2)** so that its
> proliferation is limited." — [1] §3.2/§3.5 (applies to reactive + repair ants)

### Current behaviour

A reactive forward ant with no route is re-broadcast at every node that lacks
pheromone, bounded only by `(src,seq)` dedup and IP TTL — there is no cap on how
many times *the ant* is broadcast end-to-end:

```151:155:core/src/ant_router_logic.cpp
        NodeAddress next = selectNextHop(ant.dst, proactive);
        if (next == kInvalidAddress) {
            return {{RouteAction::Broadcast, kInvalidAddress, true, ant}};
        }
```

### Required change

Use the shared `AntMessage::broadcastBudget` (introduced in items 04/05): decrement
on each broadcast; when it hits 0, `Drop` instead of `Broadcast`. Initialise
reactive ants to `config_.reactiveMaxBroadcasts` (default 2). This bounds the
flood independently of TTL/dedup.

### Acceptance

- A reactive ant traversing a region with no pheromone is broadcast at most
  `reactiveMaxBroadcasts` times, then dropped (unit test counts `Broadcast`
  decisions across a scripted chain).

## A2 — MAC-aware per-hop cost (deepens item 02)

### Spec basis

> Per-hop estimate is a running average of the measured MAC queue+transmit delay:
> `T̂_mac = α·T̂_mac + (1−α)·t_mac`. The forward ant sums these to form `T̂_d^i`. — [1] §3.2

### Current behaviour

Even after item 02 fixes units, the per-hop cost is wall-clock arrival delta, not
a smoothed MAC delay; it ignores local queue occupancy, so the metric doesn't
reflect congestion (no real load-balancing).

### Required change

1. Add an `ILinkDelay` (or extend an existing port) so the adapter supplies the
   node's current smoothed MAC delay estimate `T̂_mac`. NS-3: derive from the
   WifiMac queue + tx stats or a moving average of observed tx times. NS-2: from
   the ifq length × per-packet service time.
2. The forward ant accumulates `T̂_mac` per hop **into the existing per-hop scalar
   `AntHop.time`** (instead of, or blended with, the wall-clock delta from item
   02). This is a *measurement* change at `stampForward`, **not** a wire-schema
   change: the entry stays `{node, cost}` and no per-hop signal fields are added,
   so [ADR-0009](../adr/0009-backward-ants-carry-path-not-state.md)'s slim and the
   single-scalar invariant hold (no extra `kWireVersion` bump for MAC-awareness).
3. Keep it behind a config flag so the simpler item-02 metric remains the default
   until validated.

### Acceptance

- With a congested node (large `T̂_mac`), paths through it receive lower pheromone
  and data shifts to the alternate path (`test_mac_metric.cpp` with a scripted
  delay source).

## Files to touch

- `core/include/anthocnet/core/config.h` (`reactiveMaxBroadcasts`, MAC-metric flag,
  `enableFlowStickiness`, `flowStickyTtl`)
- `core/include/.../ant_router_logic.{h}` + `.cpp` (`onDataPacket(dest, prevHop, src)`,
  bounded `(src,dst)→hop` sticky cache, broadcast budget, MAC accumulation)
- `core/include/.../pheromone_table.{h,cpp}` (`lookup`/`nextNeighborNode` exclude)
- `core/include/.../ports.h` (`ILinkDelay` for A2)
- `ns3/model/anthocnet-routing-protocol.cc`, `ns2/src/ahn_router.cc` (pass prevHop;
  supply MAC delay)

## Risks / notes

- A1's prev-hop exclusion must keep the "only option" fallback or it creates black
  holes at leaf nodes.
- A2 needs a real MAC signal; if unavailable, ship A1+A3 and gate A2.
- `broadcastBudget` is one shared wire field across items 04/05/10 — add it once.
