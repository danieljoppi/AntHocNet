# 03 — Real pheromone diffusion (bootstrapped pheromone in hello messages)

- **Deviation:** D3
- **Priority:** P1
- **Effort:** M
- **Layer:** `core/` (+ codec, both adapter headers)
- **Depends on:** 02 (so the advertised value is a real goodness estimate)

## Summary

AntHocNet's *pheromone diffusion* lets nodes learn about destinations they have
never reached by gossiping pheromone estimates in hello messages. Each hello
should carry the sender's **best (bootstrapped) pheromone** per advertised
destination; the receiver combines it with the cost to the sender to form a
*virtual / diffused* pheromone used to guide proactive ants. Today every hello
advertises a **constant `1.0`**, so virtual pheromone is just a reachability bit
with no goodness gradient — the diffusion mechanism is effectively absent.

## Spec reference

> "The proactive behaviour is supported by a lightweight information
> bootstrapping process. ... nodes include in the hello messages they send out
> routing information they have about active destinations." — [1] §3.3

> A node `n` receiving from neighbour `m` an advertised pheromone `T_md` computes
> a **bootstrapped pheromone** for going to `d` via `m`. In Bellman-Ford fashion
> it combines `m`'s estimate with the local cost to reach `m`. The diffused value
> is reliable enough to **guide proactive ants** exploring for new paths, but is
> **not** used directly by data (data uses regular pheromone only). — [2], diffusion section

So:
- Hello advertises **the sender's best pheromone** `max_n T_nd` per destination
  `d` (the goodness of the sender's best path to `d`), not a constant.
- Receiver forms virtual pheromone `T^virt_{m,d}` from that advert + the cost to
  `m` (1 hop), via the same bootstrapped average used for reinforcement.
- Virtual pheromone feeds proactive ant selection (already wired via
  `sumMaxProbability`) and never data (already correct).

## Current behaviour

Hello adverts are hard-coded to `1.0`:

```43:61:core/src/ant_router_logic.cpp
AntMessage AntRouterLogic::createHelloAnt(std::size_t maxAdverts) {
    AntMessage m;
    ...
    const auto& dests = table_.regularDestinations();
    for (NodeAddress dest : dests) {
        if (dests.size() <= maxAdverts ||
            (rng_.uniform() > 0.5 && m.helloDests.size() < maxAdverts)) {
            m.helloDests.push_back({dest, 1.0});   // <-- constant, no goodness
        }
        if (m.helloDests.size() >= maxAdverts) break;
    }
    return m;
}
```

The receiver reinforces virtual pheromone toward that advert value:

```95:100:core/src/pheromone_engine.cpp
    const NodeAddress neighbor = hello.src;
    for (const HelloDest& advert : hello.helloDests) {
        double phValue = table.getPheromoneVirtual(advert.node, neighbor);
        table.setPheromoneVirtual(advert.node, neighbor, reinforce(phValue, advert.pheromone));
    }
```

Because `advert.pheromone` is always `1.0`, all virtual links converge to `1.0` →
no ordering between alternatives.

Also: it advertises **all** regular destinations (random subset), not "active"
ones — minor, but it inflates hello size.

## Impact

- Proactive exploration can't be *guided* by diffusion (its stated purpose in the
  paper), so it falls back to blind broadcast — more overhead, fewer useful new
  paths.
- Nodes can't pre-position routing info toward soon-to-be-used destinations,
  losing one of AntHocNet's latency advantages on route setup.

## Required change

### 1. Advertise the sender's best real pheromone

Add a helper to `PheromoneTable`:

```cpp
double PheromoneTable::bestRegular(NodeAddress dest) const {
    double best = 0.0;
    for (NodeAddress n : neighborTable_) {
        best = std::max(best, getPheromoneRegular(dest, n));
    }
    return best;
}
```

In `createHelloAnt`, advertise that value (skip destinations with no usable
pheromone):

```cpp
for (NodeAddress dest : dests) {
    double best = table_.bestRegular(dest);
    if (best <= config_.minPheromone) continue;
    // (optional) bias toward active destinations — see item 04
    m.helloDests.push_back({dest, best});
    if (m.helloDests.size() >= maxAdverts) break;
}
```

### 2. Bootstrap the diffused value on receive

In `PheromoneEngine::updateVirtual`, form the virtual pheromone from the
advertised goodness **discounted by one hop** (the cost to reach the advertising
neighbour), instead of reinforcing toward the raw advert. A simple, spec-aligned
bootstrap: treat the advert as `T_md` (the neighbour's best path cost-inverse to
`d`), and the local one-hop step as adding `T_hop` to the underlying time. Since
pheromone is an inverse-cost, convert, add a hop, invert back:

```cpp
// advert.pheromone == neighbour m's best pheromone to d == 1 / cost_m
// diffused via m: cost = cost_m + T_hop  =>  bootstrapped = 1 / (1/advert + T_hop)
double bootstrapped = (advert.pheromone > 0.0)
    ? 1.0 / (1.0 / advert.pheromone + config_.hopTimeSec)
    : 0.0;
double phValue = table.getPheromoneVirtual(advert.node, neighbor);
table.setPheromoneVirtual(advert.node, neighbor, reinforce(phValue, bootstrapped));
```

This keeps diffused pheromone consistent in units with regular pheromone (item
02) and naturally makes farther/worse advertised paths produce smaller virtual
pheromone — a real gradient.

### 3. Keep data on regular pheromone only (already correct — add a guard test)

`nextNeighborNode` only consults virtual pheromone when `isProactiveAnt` is true:

```102:105:core/src/pheromone_table.cpp
        bool useR = itR != pheromoneRegular_.end();
        bool useV = (itV != pheromoneVirtual_.end()) && isProactiveAnt;
```

Do **not** change this; add a regression test (below) so a future edit can't leak
virtual pheromone into data routing.

## Files to touch

- `core/include/anthocnet/core/pheromone_table.h` / `.cpp` (`bestRegular`)
- `core/src/ant_router_logic.cpp` (`createHelloAnt`)
- `core/src/pheromone_engine.cpp` (`updateVirtual` bootstrap)
- (No wire-format change: `HelloDest{node, pheromone}` already carries a double.)

## Acceptance criteria

Extend `core/tests/test_pheromone_engine.cpp` / add `test_diffusion.cpp`:

1. **Adverts carry real goodness.** Give a node two destinations with different
   best regular pheromone; assert `createHelloAnt` advertises those distinct
   values (not `1.0`), and skips destinations with no pheromone.
2. **Diffusion produces a gradient.** Two neighbours advertise the same dest with
   different pheromones; after `updateVirtual`, the virtual pheromone via the
   better neighbour is strictly higher.
3. **One-hop discount.** A diffused (virtual) pheromone for `d` via `m` is
   strictly less than `m`'s advertised pheromone (cost increased by one hop).
4. **Data ignores virtual pheromone (regression for the guard).** With *only*
   virtual pheromone for a dest and no regular, `nextHopForData(dest)` returns
   `kInvalidAddress`, while a proactive `selectNextHop(dest, true)` returns a hop.
5. `make test` green.

## Risks / notes

- Depends on item 02's consistent units (`hopTimeSec`); if 02 isn't done yet, use
  the same constant the back-ant metric uses so diffused and regular pheromone
  remain comparable.
- Hello size: advertising real values doesn't change the field count, but if you
  later cap to active destinations (item 04) wire size shrinks.
