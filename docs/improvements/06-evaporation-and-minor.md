# 06 — Time-based evaporation + minor deviations

- **Deviation:** D7 (+ small clean-ups)
- **Priority:** P2
- **Effort:** S
- **Layer:** `core/` (+ adapter tick wiring)
- **Depends on:** ideally after 05 (shares the maintenance tick)

## Summary

A grab-bag of lower-impact fidelity items. The main one: **evaporation is
event-driven, not time-based.** It only runs as a side effect of reinforcing a
link (on backward-ant arrival or neighbour learning), so a quiet path neither
decays nor ages on schedule. The remaining items are small correctness/clarity
fixes.

## Items

### 6.1 — Evaporation as a time-proportional safety net (ADR-0012)

- **Decision:** [ADR-0012](../adr/0012-evaporation-is-a-secondary-safety-net.md)
  — evaporation is a **secondary** mechanism, made **time-proportional**, with
  **all aging single-sourced** into a periodic `evaporateAll` on the one IClock
  maintenance tick, **config-gated** (`enableEvaporation`, default ON).

**Spec reality (read this first):** the canonical AntHocNet description ([1])
**has no evaporation term** — adaptation is the running-average `reinforce`
(`Tᵢ_nd = γ·Tᵢ_nd + (1−γ)·τᵢ_d`, the `(1−γ)` term *is* the forgetting) plus
**explicit removal** of entries on neighbour loss (item 05 / ADR-0008).
Time-proportional decay is the *classic Ant System* answer, not the AntHocNet
one. So evaporation here is a deliberate, ablatable **safety net** for entries the
spec's two mechanisms miss — e.g. a still-alive neighbour whose downstream route
to `d` silently died and stopped being sampled — **not** the adaptation engine.
Do **not** tune `alpha` to make decay do the running average's job.

**Current:** `evaporate` only runs inside `updateRegular`'s loop, which is only
called from `reinforceFromBackAnt` and `learnNeighbor`:

```9:11:core/src/pheromone_engine.cpp
double PheromoneEngine::evaporate(double phValue) const {
    return phValue - (1.0 - config_.alpha) * phValue;
}
```

So a destination that stops receiving backward ants is never aged; its competing
links freeze at their last values, and the decay rate is a function of *traffic*,
not time.

**Change (per ADR-0012):**

1. Add `PheromoneEngine::evaporateAll(PheromoneTable&, double dtSeconds)` that ages
   **every** regular entry once with a **time-proportional** factor
   `alpha^(dtSeconds / evaporationInterval)`, pruning entries below `minPheromone`.
   `dtSeconds` is `clock_.now()` minus the last evaporation time (from `IClock` —
   never wall-clock, golden rule #3).
2. **Single-source the aging:** make `updateRegular` *only reinforce the travelled
   link*; delete the "age the other links" branch (lines 44–54). All aging now
   lives in `evaporateAll`. This also removes the reinforce-and-age coupling that
   caused the original D2 bug.
3. Call `evaporateAll` from the single core maintenance tick (`onMaintenanceTick`,
   item 05 / ADR-0008) — because the factor scales by actual `Δt`, the same tick
   that expires neighbours can evaporate, with **no separate timer**.
4. Gate it behind `Config::enableEvaporation` (default `true`). Off ⇒ paper-faithful
   "running-average + explicit-removal only" mode, which item 08 runs as an
   ablation variant.

Virtual pheromone already evaporates on hello reception (in `updateVirtual`); hellos
are periodic so that path is effectively periodic and matches diffusion's refresh —
align it onto the tick for consistency if convenient, but it is not the deviation
this item fixes.

**Acceptance:** `test_pheromone_engine.cpp` — with `enableEvaporation = true`,
after advancing `FakeClock` by N·`evaporationInterval` with no reinforcement an
entry decays geometrically (`≈ alpha^N` of its start value) and is pruned below
`minPheromone`; a reinforced entry does not decay within the same tick; aging never
happens inside `updateRegular`; and with `enableEvaporation = false` an
un-reinforced entry retains its value across ticks (only link-failure removal can
clear it).

### 6.2 — `networkDiameter` / expanding-ring TTL

**Spec:** reactive forward ants are bounded by a max hop count; the paper notes
this max is "quite high" and suggests an expanding-ring search or using diffusion
to bound it.

**Current:** `Config::networkDiameter = 30`, applied as an IP TTL in NS-2
(`AHN_NETWORK_DIAMETER`) and as the `maxPathLength` guard in `stampForward`. NS-3
does not appear to apply an equivalent hop cap to broadcast ants.

**Change (small):** ensure **both** adapters cap ant hop count (NS-3 should set
the ant packet TTL / decrement and drop). Optionally implement a simple
expanding-ring retry for reactive setup (start TTL small, grow on failure) —
mark as optional/stretch.

**Acceptance:** an ant exceeding the hop cap is dropped in a core/unit test
(`maxPathLength` already bounds `visited`; add a TTL/hops check in `onReceiveAnt`
that returns `Drop` past the cap), and NS-3 broadcast ants don't propagate beyond
the cap in a smoke run.

### 6.3 — Reactive-ant retry interval

**Spec:** §4.2 of [1] notes the retry interval for reactive forward ants on a
failed setup is "rather low," causing overhead when a destination is unreachable;
suggests backing off.

**Current:** the data path re-launches a reactive ant whenever a packet has no
route (`onDataPacket`), with no per-destination backoff — a stream of packets to
an unreachable destination floods ants.

**Change:** add a per-destination "reactive ant in flight / last sent" guard in
the core (or adapter) so at most one reactive setup is outstanding per
destination, with exponential backoff on repeated failure. Drop buffered packets
after a max number of failed setups.

**Acceptance:** `test_core_paths.cpp` — multiple `onDataPacket(d)` calls in quick
succession with no route emit **one** reactive ant (not one per packet) until the
backoff elapses.

### 6.4 — Naming / clarity (no behaviour change)

- Rename `AntMessage::prevSINR` → `pathTime` (it is accumulated time, not SINR).
  (Folds into item 02.)
- The `kBeta` constant is removed by item 01; ensure no stragglers remain.
- `selectNextHop`'s `proactive` bool would read better as an enum
  `Exponent{Ant, Data}` once item 01 lands, but keep changes minimal.

### 6.5 — Hello advertises a random subset via `rng_.uniform() > 0.5`

**Current:** `createHelloAnt` includes each destination with prob 0.5 (capped at
`maxAdverts`). Combined with item 03 (advertise active destinations only), prefer
advertising **active** destinations deterministically and filling remaining slots
by best pheromone, rather than a coin flip. Minor.

## Files to touch

- `core/src/pheromone_engine.cpp`, `core/include/.../pheromone_engine.h`
  (`evaporateAll`)
- `core/include/anthocnet/core/config.h` (`evaporationInterval`,
  `enableEvaporation` (default `true`), reactive backoff knobs)
- `core/src/ant_router_logic.cpp` (tick calls evaporate; reactive backoff guard;
  hop cap drop)
- `ns3/model/anthocnet-routing-protocol.cc` (ant TTL/hop cap)
- tests as named per item

## Acceptance criteria (summary)

- Periodic evaporation decays unused entries; no double decay.
- One reactive ant per destination per backoff window.
- Ant hop cap enforced in both adapters.
- `make test` green.

## Risks / notes

- 6.1 changes pheromone dynamics **and `alpha`'s meaning** (now a per-`evaporationInterval`
  retention factor scaled by elapsed time, not a per-event multiplier). Re-tune
  `alpha`/`evaporationInterval` against item 07/08 on the paper-scale scenario, not
  the unit-test toy. Land it **after** 01/02 so you measure on a correct metric.
- Evaporation is a deliberate extension beyond the spec, not "the spec" — see
  [ADR-0012](../adr/0012-evaporation-is-a-secondary-safety-net.md). Keep it
  secondary to the running average + link-failure removal (item 05).
- Keep each sub-item a separate commit; they're independent.
