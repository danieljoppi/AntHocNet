# ADR-0012: Evaporation is a secondary, time-proportional safety net

- **Status:** Accepted — implementation tracked in
  item 06
- **Date:** 2026-06-25

## Context

The codebase ages regular pheromone with a multiplicative `evaporate(v) = α·v`
that fires only as a side effect of `updateRegular` — i.e. on **backward-ant
arrival**. So a path that stops being sampled never decays, and the decay rate is
tied to traffic, not time. This same "age the other links while reinforcing one"
loop is what produced the original D2 evaporation bug.

It is tempting to "fix" this by making evaporation periodic and time-proportional
(classic Ant System: `τ ← (1−ρ)τ` every iteration) and call that spec-faithful.
But the canonical AntHocNet description ([1] Di Caro, Ducatelle & Gambardella,
ETT 2005) **has no evaporation term at all** — the word never appears. AntHocNet
deliberately *replaces* classic ACO evaporation with two other mechanisms:

> "the pheromone value ... represents a running average ... `Tᵢ_nd = γ·Tᵢ_nd +
> (1−γ)·τᵢ_d`" — [1] §3.3

1. **A running weighted average on backward-ant arrival** (the `(1−γ)` term is
   the "forgetting"; this is the spec's adaptation engine — our `reinforce`).
2. **Explicit obsolete-route removal** on neighbour loss (hello-timeout
   `t_hello × allowed-hello-loss`, or failed unicast), which *deletes* entries
   outright rather than decaying them — this is [ADR-0008](0008-neighbour-liveness-two-detectors.md)
   / item 05.

So the real question is not "event-driven vs time-based evaporation" but **what
role evaporation plays at all**, given the spec assigns adaptation elsewhere.

## Decision

Keep evaporation, but demote it to an explicit **secondary safety net**, and make
the form correct:

1. **Primary forgetting stays the spec's two mechanisms** — the running-average
   `reinforce` (γ) and explicit link-failure / hello-timeout removal (ADR-0008).
   Evaporation only reaps entries those two miss: e.g. a neighbour that is still
   *alive* (so liveness never removes it) but whose downstream route to `d`
   silently died and stopped being sampled (so reinforcement never refreshes it).
2. **Time-proportional decay.** Replace the per-arrival `α·v` with
   `factor = α^(Δt / evaporationInterval)`, with `Δt` taken from **`IClock`**
   (never wall-clock — golden rule #3; this is what keeps NS-2/NS-3 reproducible
   and cross-validatable). This decouples decay dynamics from how often the tick
   fires.
3. **Single source of aging.** `updateRegular` only *reinforces the travelled
   link*; **all** aging moves into a new `PheromoneEngine::evaporateAll(table, Δt)`.
   This structurally removes the reinforce-and-age coupling that caused the D2
   bug — a correctness win, not just tidiness.
4. **One tick owns it.** `evaporateAll` runs from the single core
   `onMaintenanceTick()` already introduced for neighbour liveness (ADR-0008).
   Because (2) scales by actual `Δt`, the same tick can serve both liveness and
   evaporation regardless of cadence — no separate evaporation timer.
5. **Config-gated, default ON.** `Config::enableEvaporation = true`. Turning it
   off yields the paper-faithful "running-average + explicit-removal only" mode,
   which item 08 runs as
   an ablation variant so the benchmark — not intuition — justifies keeping it on.

Virtual pheromone already evaporates on **hello reception** (in `updateVirtual`),
and hellos are periodic, so that path is effectively periodic and roughly matches
the Bellman-Ford-style diffusion refresh; it may be aligned onto the same tick for
consistency but is not the deviation this ADR fixes.

## Alternatives considered

- **Event-driven on reinforcement (status quo).** Indefensible on any reading:
  decay rate is a function of traffic, and quiet paths never age. Rejected — this
  is the bug.
- **First-class, tunable time-proportional decay** (treat `α` as a real adaptation
  knob). Over-weights a mechanism the spec does not have, and invites tuning
  evaporation to do the job the running average already does. Rejected as default.
- **Paper-faithful: remove regular evaporation entirely** (rely solely on
  running-average + link-failure removal). Closest to the letter of the spec, but
  leaves no backstop for silently-stale regular entries (the live-neighbour /
  dead-downstream case above). Kept as the *gate-off ablation*, not the default.

## Consequences

- `α`'s meaning changes: it is now a **per-`evaporationInterval`** retention factor
  applied in proportion to elapsed time, not a per-event multiplier. `α` and the
  new `Config::evaporationInterval` must be re-tuned against item 07/08 benchmarks,
  and on the paper-scale scenario, not the unit-test toy.
- The reinforce/evaporate split makes `updateRegular` simpler and removes the last
  remnant of the D2 coupling.
- A new wire-independent config flag (`enableEvaporation`) and interval; no wire
  change (consistent with [ADR-0009](0009-backward-ants-carry-path-not-state.md)).
- Documentation must stop calling time-proportional evaporation "the spec"; it is a
  deliberate, ablatable extension. `CONTEXT.md` and item 06 are updated to say so.
