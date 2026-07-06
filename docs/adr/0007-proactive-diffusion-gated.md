# ADR-0007: Keep virtual pheromone / proactive diffusion, but gate it

- **Status:** Accepted — implementation tracked in
  item 03,
  item 04, measured by
  item 07 /
  item 08
- **Date:** 2026-06-25

## Context

AntHocNet is a *hybrid* protocol: reactive route setup (forward + backward ants
lay **regular** pheromone that data follows) plus proactive maintenance, in which
hello messages **diffuse** pheromone to build a **virtual** pheromone table that
guides **proactive ants** ([1] §3.1, §3.3 — see the glossary in
[`CONTEXT.md`](../../CONTEXT.md)). Virtual pheromone is never used by data.

Reviewing the current core, virtual pheromone is **half-wired and partly
self-defeating**:

- Hellos advertise a **constant `1.0`**, so virtual pheromone is a reachability
  bit, not a goodness gradient (item 03).
- It is read by **one consumer** — proactive-ant next-hop selection
  (`sumMaxProbability`, `isProactiveAnt == true`); data/reactive paths never read
  it.
- `nextNeighborNode` bails unless the destination is in the **regular**
  destination set, so a destination known *only* via diffusion is unroutable even
  for a proactive ant — defeating diffusion's stated purpose (reach destinations
  not yet sampled by ants).
- Proactive ants themselves target a **random** destination on a fixed timer
  rather than active sessions (item 04).

So "do we need virtual pheromone?" reduces to "do we want informed proactive
exploration?" — the two stand or fall together, and neither is load-bearing for
basic correctness (data routes on regular pheromone alone).

## Decision

**Keep** virtual pheromone, pheromone diffusion, and proactive exploration — they
are the mechanisms that distinguish AntHocNet from a reactive ant/AODV hybrid and
underpin the "canonical AntHocNet" positioning
(item 09) — **but make the
whole proactive subsystem config-gated and let benchmarks justify the default:**

- Add `Config::enableProactive` (default `true`), the master switch for proactive
  ant generation + per-hop exploratory broadcast. Optionally
  `Config::enableDiffusion` (default `true`, only effective when proactive is on)
  to gate the hello pheromone payload + virtual-table build + virtual blending,
  enabling a finer ablation.
- When disabled: the proactive timer emits nothing, hellos carry **no** pheromone
  adverts (neighbour-discovery/liveness still runs — see
  item 05), the virtual
  table stays empty, and selection never blends virtual pheromone.
- Make diffusion actually work when enabled: real bootstrapped advert values
  (item 03), proactive ants for **active sessions** (item 04), and **relax the
  `nextNeighborNode` reach guard** so proactive selection may route to a
  destination present in the regular **or** virtual set (data still requires
  regular). Without that relaxation, diffusion can never extend reach and the
  feature is pointless.
- The benchmark harness (items 07/08) runs the ablation — **AntHocNet-full**
  (both on) vs **AntHocNet-reactive** (proactive off), optionally **proactive-blind**
  (proactive on, diffusion off) — and the measured PDR/delay/overhead decides
  whether the shipped default stays on.

## Alternatives considered

- **Cut it entirely.** Remove the virtual table, diffusion, and proactive ants;
  hellos shrink to neighbour discovery/liveness; drop the `helloDests` pheromone
  payload from the wire. Simpler and smaller — but it is no longer full
  AntHocNet, and the item 09 "canonical implementation" claim would have to be
  downgraded to "reactive AntHocNet variant." Rejected: cutting a *defining*
  mechanism based on the current half-wired state (not on evidence) throws away
  the project's identity and the paper-comparison story.
- **Commit unconditionally (no flag).** Implement 03 + 04 + guard fix, always on.
  Faithful, but bakes in a mechanism whose benefit in *our* topologies is
  unproven and gives no ablation for the benchmark write-up. Rejected in favour
  of a flag that costs almost nothing and yields a free A/B.

## Consequences

- The project stays a faithful AntHocNet by default, with an evidence-based exit:
  if items 07/08 show diffusion doesn't move the metrics in our scenarios, ship
  `enableProactive = false` (or `enableDiffusion = false`) by default and
  document the finding — without deleting code or changing the wire format.
- One ablation axis is added to the benchmark matrix (items 07/08), which also
  strengthens the comparison story (we can show AntHocNet-full vs -reactive).
- The reach-guard relaxation is a behavioural change to proactive selection;
  it is covered by item 03's acceptance tests (data still ignores virtual).
- No wire-format change: `HelloDest{node, pheromone}` already carries a double;
  when diffusion is off, the adverts list is simply empty (no `kWireVersion`
  bump — the layout is unchanged; see [ADR-0006](0006-on-wire-protocol-version.md)).
