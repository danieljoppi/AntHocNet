# 02 — Fix the backward-ant delay metric (units + per-hop accumulation)

- **Deviation:** D2
- **Priority:** P0
- **Effort:** M
- **Layer:** `core/` + codec + **both adapter headers** (this is a wire change)
- **Depends on:** nothing (but pairs naturally with 01)
- **Decision:** **slim the wire** per
  [ADR-0009](../adr/0009-backward-ants-carry-path-not-state.md) — a backward ant
  carries identity + the path only; `pheromone`/`hops`/`prevSINR`/`prevHop` come
  **off** the wire, time is a **per-hop delta**, and `kWireVersion` is bumped
  ([ADR-0006](../adr/0006-on-wire-protocol-version.md)). Coordinate the version
  number with item 12 (whichever lands first introduces `kWireVersion`).

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

Make the forward ant carry **per-hop deltas** in the existing `AntHop.time` slot,
accumulate the true path time on the way back, and keep everything in consistent
units (seconds internally; express `T_hop` in seconds too). No new wire field.

### 1. Store per-hop time delta, not cumulative

Change `stampForward` to record the delta since the previous hop. Keep a local
last-stamp time on the message (a working field, **not** serialized) or derive
the delta from the elapsed time since the previous stamp:

```cpp
void AntRouterLogic::stampForward(AntMessage& ant) const {
    if (ant.visited.size() >= config_.maxPathLength) return;
    const double now   = clock_.now();
    const double delta = now - ant.lastStamp;   // lastStamp init'd to timeStart at the source
    ant.lastStamp = now;
    ant.visited.push_back({address_, delta});    // per-hop delta (seconds)
}
```

`AntHop.time` now means **per-hop delta**, not cumulative-since-source — a
semantic change to an existing wire field, so `kWireVersion` is bumped (step 5).

### 2. Accumulate true path time on the backward pass

`T̂_d^i` is the sum of per-hop deltas from `i` to `d`. The back ant pops from `d`
toward the source, so accumulate the deltas it walks over (no `timeDest`, no
absolute times):

```cpp
NodeAddress AntRouterLogic::advanceBackAnt(AntMessage& ant) const {
    if (ant.visited.empty()) return kInvalidAddress;
    const AntHop current = ant.visited.back();   // node i, per-hop delta in .time

    // hops, prevHop, pheromone are LOCAL working fields (not on the wire, ADR-0009):
    const int    hops    = static_cast<int>(ant.history.size()) + 1;  // derived
    const double tHat    = (ant.pathTime += current.time);            // running sum of deltas
    const double hopCost = hops * config_.hopTimeSec;                 // seconds
    const double pheromone = std::pow((tHat + hopCost) / 2.0, -1.0);  // applied locally via reinforce()

    ant.history.push_back(current);
    ant.visited.pop_back();
    if (ant.visited.empty()) return kInvalidAddress;
    return ant.visited.back().node;
}
```

`pathTime` is a **local** accumulator (the renamed-and-de-serialized successor to
`prevSINR`); `hops`/`pheromone`/`prevHop` are likewise local and recomputed each
hop — none are serialized (step 5).

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

### 5. Slim the wire (ADR-0009) + bump `kWireVersion`

Confirmed: both adapters only *marshal* `prevSINR`/`pheromone`/`hops`/`prevHop`
(`ns2/src/ant_packet_ns2.cc`, `ns3/model/anthocnet-packet.cc`); nothing reads them
to decide, and the core recomputes them per hop. So **remove them from the wire**:

- Delete them from `serialize`/`deserialize`, the size constants, the NS-2 POD
  header (`ant_packet_ns2`), and the NS-3 `AntHeader`
  (`anthocnet-packet.cc`). In the `AntMessage` struct they become local working
  fields (or `prevSINR` → a private `pathTime` accumulator); they are no longer
  part of the serialized image.
- **Bump `kWireVersion`** for the combined change (slim + `AntHop.time` delta
  semantics). Don't hard-code the number — use `current + 1`, and coordinate with
  item 12 (whichever lands first introduces the constant).
- Update `core/tests/test_codec.cpp`: the round-trip no longer carries those
  fields, and a decoded backward ant leaves `pheromone`/`hops` at their defaults
  (the core fills them).

Target layout (with the version byte from item 12) is in
[`docs/wire-format.md`](../wire-format.md).

## Files to touch

- `core/include/anthocnet/core/config.h` (`hopTimeSec`)
- `core/include/anthocnet/core/ant_message.h` (`AntHop.time` = per-hop delta;
  demote `pheromone`/`hops`/`prevHop` to local working fields; `prevSINR` →
  private `pathTime` accumulator — all four leave the serialized image)
- `core/src/ant_router_logic.cpp` (`stampForward`, `createBackAnt`, `advanceBackAnt`)
- `core/src/ant_message_codec.cpp` + `ns2/src/ant_packet_ns2.*` +
  `ns3/model/anthocnet-packet.cc` + `core/tests/test_codec.cpp` (**wire change**:
  drop the four fields, bump `kWireVersion`)
- `docs/wire-format.md` (keep the byte table in sync)

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
4. **Wire slimmed (ADR-0009).** `serializedSize` of a backward ant drops by the
   four removed fields (−24 bytes); a round-trip through the codec carries
   `visited`/`history` but a freshly decoded message has `pheromone`/`hops` at
   defaults (the core fills them). `kWireVersion` is the previous value + 1.
5. `make test` green; `test_network_integration.cpp` still discovers the route.

## Risks / notes

- `FakeClock` in `core/tests/test_support.h` must allow advancing time between
  hops; check it supports `advance()`/settable now. Extend if needed.
- The wire slim is **one atomic change** across the struct + codec + both adapter
  headers + `test_codec.cpp` + `docs/wire-format.md` (golden rule #4 / ADR-0006).
  Coordinate the `kWireVersion` number with item 12 — don't hard-code it.
- Verify nothing *else* reads the four removed fields cross-hop before deleting
  (the adapters were checked; re-confirm if other call sites appeared).
- Keep the metric change isolated from 01 so each can be benchmarked independently.
