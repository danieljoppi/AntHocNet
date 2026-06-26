# 16 — Pluggable link-metric port (ILinkMetric)

- **Covers:** G1
- **Priority:** P3 (forward-looking; do after 01/02 land so the default metric is
  correct first)
- **Effort:** M
- **Layer:** `core/`
- **Depends on:** 01 (β), 02 (correct default metric), 10/A2 (MAC metric is the
  first alternative implementation)

## Summary

How a backward ant turns a path observation into a pheromone value (Eq.2) is
currently hard-coded in `advanceBackAnt`. The pure-core architecture makes this
the natural seam for a **strategy port**: extract "compute pheromone from
{hops, time, and adapter-supplied signals}" into an `ILinkMetric` interface. This
turns the project's main weakness-vs-peers (Sawchord ships a fuzzy-logic metric;
the literature has energy-/QoS-aware variants) into a strength: the *same* tested
core can host the canonical metric **and** pluggable research metrics, selected by
config, without touching the state machine.

## Rationale / positioning

- Sawchord's differentiator is a fuzzy inference metric; energy-aware and
  QoS-aware AntHocNet variants are common in the literature. Today, reproducing
  any of them here means editing core routing code.
- With an `ILinkMetric` port, a fuzzy/energy/QoS metric becomes a drop-in
  implementation behind the existing port pattern (`IClock`, `IRng`,
  `INeighborProvider`, `ITimerScheduler`) — consistent with ADR-0003 (pure core)
  and the hexagonal design.

## Current behaviour

The metric is inline in the back-ant advance:

```92:108:core/src/ant_router_logic.cpp
NodeAddress AntRouterLogic::advanceBackAnt(AntMessage& ant) const {
    ...
    const double simpleSINR = ant.prevSINR / 1000.0;
    ant.pheromone = std::pow((ant.hops * config_.hopTimeMs + simpleSINR) / 2.0, -1.0);
    ...
```

## Required change

### 1. Define the port

```cpp
// ports.h
struct LinkObservation {
    int    hops;          // hops from this node to destination along the path
    double pathTime;      // accumulated time estimate (seconds)  [item 02]
    double hopTime;       // config T_hop (seconds)
    // room to grow with NODE-LOCAL / PATH-AGGREGATE signals only — e.g. this
    // node's energyRemaining, a local snr/queueOccupancy reading, or another
    // path aggregate. NOT per-hop downstream vectors: the wire carries one
    // scalar cost per hop (ADR-0009), and that invariant holds. A metric that
    // genuinely needs per-hop downstream signals is a deliberate, ADR-gated wire
    // extension, not a default.
};

struct ILinkMetric {
    virtual ~ILinkMetric() = default;
    // Map an observation to a pheromone (goodness; higher = better).
    virtual double pheromone(const LinkObservation& obs) const = 0;
};
```

### 2. Provide the canonical implementation as the default

```cpp
// the Eq.2 metric, post-item-02:
struct ClassicMetric : ILinkMetric {
    double pheromone(const LinkObservation& o) const override {
        return std::pow((o.pathTime + o.hops * o.hopTime) / 2.0, -1.0);
    }
};
```

`AntRouterLogic` takes an `ILinkMetric&` (defaulting to a `ClassicMetric`
instance) and calls it from `advanceBackAnt` instead of the inline formula.

### 3. Wire selection through config/adapters

Adapters pick the metric (NS-3 attribute `Metric={classic|...}`, NS-2 bind);
the chosen `ILinkMetric` is injected at construction, exactly like `IClock`/`IRng`.

**Two orthogonal seams (don't conflate them):**
- **Per-hop cost measurement** (forward pass) — item 10/A2's `ILinkDelay` feeds a
  measured MAC cost into the single per-hop scalar `AntHop.time`. MAC-awareness
  lives here, and the default `ClassicMetric` already consumes it (it just sums
  per-hop costs). The wire stays `{node, cost}` (ADR-0009).
- **Pheromone metric** (backward pass) — *this* port. It combines path aggregates
  (`pathTime`, `hops`) + node-local signals into a goodness value. A
  `FuzzyMetric`/`EnergyMetric` that uses node-local/aggregate inputs can be added
  later in `ns3/` without core changes.

So "MAC-aware" is achieved by the measurement seam feeding the scalar, **not** by a
special `ILinkMetric`; a custom metric is only needed when the *combining function*
itself changes (fuzzy/energy/QoS), not merely the per-hop cost.

### 4. Keep determinism + purity

The metric must be pure (no I/O, no time/RNG reads except via what the
observation carries). Adapter-supplied signals (energy, SNR, queue) enter through
the `LinkObservation`, not by the metric calling the simulator.

## Files to touch

- `core/include/anthocnet/core/ports.h` (`ILinkMetric`, `LinkObservation`)
- `core/include/anthocnet/core/link_metric.h` (+ `ClassicMetric`,
  optional `MacAwareMetric`)
- `core/include/.../ant_router_logic.{h}` + `.cpp` (inject + call the metric)
- `ns3/model/anthocnet-routing-protocol.{h,cc}` (metric attribute + selection)
- `ns2/src/ahn_router.{h,cc}` (metric bind + selection)
- `core/tests/test_link_metric.cpp`

## Acceptance criteria

1. With the default `ClassicMetric`, behaviour is identical to the post-item-02
   inline formula (regression: existing back-ant tests unchanged).
2. Swapping in a stub metric (e.g. constant, or hops-only) changes pheromone
   deposits as expected, proving the seam works, with **no** edit to
   `AntRouterLogic` decision code.
3. MAC-awareness (item 10/A2) is achieved via the **measurement** seam
   (`ILinkDelay` feeding the per-hop scalar), with the default `ClassicMetric`
   unchanged — *not* by a bespoke `ILinkMetric`. A custom metric is exercised only
   for a changed combining function (e.g. a stub fuzzy/energy metric).
4. `make test` green; core stays free of simulator/fuzzy-lib dependencies (any
   such metric lives in an adapter).

## Risks / notes

- Don't build this before items 01/02 — extract the *correct* metric, not the
  current buggy one, or you cement the wrong formula behind an interface.
- Keep the default path allocation-free and inlinable (metric called once per
  back-ant hop).
- Scope guard: this is an extensibility enabler, not a new algorithm — ship the
  port + `ClassicMetric` (+ optionally `MacAwareMetric`); leave fuzzy/energy
  metrics as documented extension points unless explicitly requested.
