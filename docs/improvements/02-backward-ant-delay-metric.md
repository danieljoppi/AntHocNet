# 02 — Fix the backward-ant delay metric (units + per-hop accumulation)

- **Deviation:** D2
- **Priority:** P0
- **Effort:** M
- **Layer:** `core/`
- **Depends on:** nothing (but pairs naturally with 01)

## Summary

The pheromone a backward ant deposits is supposed to blend a **time estimate**
`T̂_d^i` with a **hop-count estimate** `h·T_hop` (Eq.2). In the current code two
problems make the *time* term effectively vanish, so pheromone ≈ a function of
hop count alone. That throws away the delay/congestion awareness that is the
whole point of AntHocNet's quality metric.

## Spec reference

> Eq.2: `τ_d^i = ( (T̂_d^i + h·T_hop) / 2 )^{-1}`
> where `T̂_d^i` is the estimated **time** for a data packet to travel from `i`
> to `d` along path `P`, computed incrementally as the sum of per-hop local time
> estimates `T̂_{j,j+1}`, and `h` is the number of hops from `i` to `d`. — [1] §3.2

> The per-hop local estimate is a running average of the measured MAC
> queue+transmit time: `T̂_mac = α·T̂_mac + (1−α)·t_mac`. — [1] §3.2

Key point: `T̂_d^i` and `h·T_hop` must be in the **same units** and **comparable
in magnitude**, so the average `(T̂ + h·T_hop)/2` genuinely blends *time* and
*hops*. `T_hop` is "the time to take one hop in unloaded conditions" — i.e. tens
of milliseconds, the same order as a real per-hop delay.

## Current behaviour

Forward ants store, at each hop, the **cumulative** time since the ant was
created (not a per-hop delta):

```86:90:core/src/ant_router_logic.cpp
void AntRouterLogic::stampForward(AntMessage& ant) const {
    if (ant.visited.size() >= config_.maxPathLength) return;
    const double trip = clock_.now() - ant.timeStart;
    ant.visited.push_back({address_, trip});
}
```

The backward ant then **sums those cumulative stamps** and divides by 1000:

```92:108:core/src/ant_router_logic.cpp
NodeAddress AntRouterLogic::advanceBackAnt(AntMessage& ant) const {
    if (ant.visited.empty()) return kInvalidAddress;

    const AntHop current = ant.visited.back();  // this node
    ant.prevHop = current.node;
    ant.hops += 1;
    ant.prevSINR += current.time;

    const double simpleSINR = ant.prevSINR / 1000.0;
    ant.pheromone = std::pow((ant.hops * config_.hopTimeMs + simpleSINR) / 2.0, -1.0);

    ant.history.push_back(current);
    ant.visited.pop_back();
    ...
```

Two defects:

1. **Wrong accumulation.** `visited[k].time` is *time-since-source* (cumulative),
   so summing them across hops (`prevSINR += current.time`) is not the path time
   `T̂_d^i`; it over-counts (roughly a triangular sum of cumulative stamps).
2. **Unit mismatch / scaling.** `clock_.now()` is in **seconds**, `hopTimeMs` is
   in **milliseconds** (default 50), and the code further divides the time term
   by 1000. With per-hop delays ~0.01 s, `simpleSINR` ends up ~1e-4 while
   `hops·hopTimeMs` is 50–150. The time term is ~6 orders of magnitude too small,
   so `τ ≈ (h·hopTimeMs/2)^{-1}` — **pure inverse hop count.**

Net effect: the protocol behaves like stochastic shortest-hop routing; delay and
congestion never influence pheromone.

## Impact

- Loses load-balancing and congestion-avoidance (a core AntHocNet advantage).
- Makes the `hopTimeMs` "blend" meaningless and the metric non-physical.
- Interacts with 01: even with a greedy β, "greedy" currently means "fewest hops"
  rather than "lowest delay".

## Required change

Make the forward ant carry **per-hop deltas**, accumulate the true path time on
the way back, and keep everything in consistent units (seconds internally;
express `T_hop` in seconds too).

### 1. Store per-hop time, not cumulative

Change `stampForward` to record the delta since the previous hop. Add a small
field to `AntMessage` to remember the last stamp time, or compute the delta from
the previous `visited` entry's absolute time. Cleanest: store **absolute arrival
time** per hop and difference on the backward pass.

Proposed: store absolute time at each hop:

```cpp
void AntRouterLogic::stampForward(AntMessage& ant) const {
    if (ant.visited.size() >= config_.maxPathLength) return;
    ant.visited.push_back({address_, clock_.now()});  // absolute arrival time
}
```

### 2. Accumulate true path time on the backward pass

`T̂_d^i` = (time the ant arrived at `d`) − (time it arrived at `i`). Since the
back ant pops from `d` toward the source, track the destination's arrival time
once and subtract the current hop's arrival time:

```cpp
NodeAddress AntRouterLogic::advanceBackAnt(AntMessage& ant) const {
    if (ant.visited.empty()) return kInvalidAddress;
    const AntHop current = ant.visited.back();  // node i, absolute arrival time

    ant.prevHop = current.node;
    ant.hops   += 1;

    // ant.timeDest is the absolute time the forward ant reached the destination
    // (set once in createBackAnt). Path time from i to d:
    const double tHat = ant.timeDest - current.time;          // seconds
    const double hopCost = ant.hops * config_.hopTimeSec;     // seconds
    ant.pheromone = std::pow((tHat + hopCost) / 2.0, -1.0);

    ant.history.push_back(current);
    ant.visited.pop_back();
    if (ant.visited.empty()) return kInvalidAddress;
    return ant.visited.back().node;
}
```

`createBackAnt` sets `b.timeDest = clock_.now()` (the moment the forward ant
reached the destination), and `visited` is copied from the forward ant.

### 3. Config: T_hop in seconds

In `config.h`, replace `int hopTimeMs = 50;` with `double hopTimeSec = 0.05;`
(50 ms expressed in seconds, matching `clock_.now()`), and update the comment.
Remove the stray `/1000.0`.

### 4. (Recommended) real per-hop MAC estimate — optional, behind a flag

The fully faithful version replaces the wall-clock delta with a smoothed local
MAC delay `T̂_mac = α·T̂_mac + (1−α)·t_mac` measured by each node, carried as the
per-hop cost. This needs the adapter to feed a measured/queue+tx time into the
core (a new port or a value passed on `stampForward`). If you do not have a MAC
delay signal available in the simulator yet, implement steps 1–3 (correct
wall-clock path time) and leave a `// TODO(D2): smoothed MAC estimate` note. Step
1–3 already restore a meaningful, correctly-scaled time term.

### 5. Rename the misnomer

`AntMessage::prevSINR` is not SINR; it is accumulated time. If you keep an
accumulator field, rename to `pathTime`. Update the codec
(`core/src/ant_message_codec.cpp`) and both adapter headers + `test_codec.cpp` if
the set of serialized fields changes. (Note: `prevSINR`/`pathTime`, `hops`,
`pheromone`, `prevHop` are transient back-ant working fields — confirm whether
they actually need to be on the wire at all; if a backward ant is only ever
processed hop-by-hop locally, these can be recomputed and need **not** be
serialized, which simplifies the wire format. Verify against both adapters before
removing.)

## Files to touch

- `core/include/anthocnet/core/config.h` (`hopTimeSec`)
- `core/include/anthocnet/core/ant_message.h` (`timeDest`; rename `prevSINR`)
- `core/src/ant_router_logic.cpp` (`stampForward`, `createBackAnt`, `advanceBackAnt`)
- `core/src/ant_message_codec.cpp` + `ns2/src/ant_packet_ns2.*` +
  `ns3/model/anthocnet-packet.cc` + `core/tests/test_codec.cpp` (only if the wire
  field set changes)

## Acceptance criteria

Add `core/tests/test_backant_metric.cpp`:

1. **Time influences pheromone.** Construct two paths to the same destination
   with equal hop count but different per-hop times (drive `FakeClock` so one
   path accrues more time). Assert the faster path yields a **strictly higher**
   pheromone after `advanceBackAnt`/`reinforce`. (Today they'd be equal.)
2. **Units sane.** For a 3-hop path with ~50 ms/hop and `hopTimeSec=0.05`, assert
   `τ` is within a plausible band (e.g. `τ⁻¹` between `0.05` and `0.5` s), proving
   the time term is no longer ~1e-4.
3. **Hop term still present.** With near-zero measured time, `τ ≈ (h·hopTimeSec/2)⁻¹`.
4. `make test` green; `test_network_integration.cpp` still discovers the route.

## Risks / notes

- `FakeClock` in `core/tests/test_support.h` must allow advancing time between
  hops; check it supports `advance()`/settable now. Extend if needed.
- If you remove transient fields from the wire format, do it as one atomic change
  across codec + both adapters + `test_codec.cpp` (see README "Definition of
  done").
- Keep the change isolated from 01 so each can be benchmarked independently.
