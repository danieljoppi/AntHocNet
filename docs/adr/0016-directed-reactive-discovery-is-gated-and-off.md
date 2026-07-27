# ADR-0016: Reactive ants may follow the diffusion gradient, gated and default-off

- **Status:** Accepted — mechanism shipped in
  [#243](https://github.com/danieljoppi/AntHocNet/pull/243), measured by
  [#244](https://github.com/danieljoppi/AntHocNet/issues/244)
- **Date:** 2026-07-27

## Context

[ADR-0007](0007-proactive-diffusion-gated.md) kept virtual pheromone and stated
its consumer boundary explicitly: virtual pheromone is read by **one** consumer,
proactive-ant next-hop selection, and "data/reactive paths never read it."

That boundary has a cost that ADR-0007 did not weigh. [1] §3.1 broadcasts a
reactive forward ant whenever the current node has no pheromone for the
destination — full stop, no exceptions. But "no pheromone" there means no
**regular** pheromone. A node can simultaneously hold a perfectly usable
*virtual* gradient toward that destination, diffused to it through hello adverts,
and still flood, because `selectNextHop` blends the virtual table in only when
the ant is proactive.

So the protocol collects information and then declines to use it at the one
moment it is most expensive not to: route discovery, where the alternative is a
network-wide broadcast.

Two adjacent questions arrived at the same time and sharpened this one:

- **Satellites** ([#192](https://github.com/danieljoppi/AntHocNet/issues/192)).
  On a constellation the topology is knowable, so blind flooding looks
  obviously wrong. But knowing the topology is not the same as holding a next
  hop — see [`network-regimes.md`](../network-regimes.md) §5. What a node lacks
  is *direction*, and direction is exactly what a diffusion gradient is.
- **Ant-type ablation.** Asking "which ant types earn their keep?" required
  per-type gates anyway, and the same PR was the natural place for both.

## Decision

**Let a reactive forward ant consult the virtual table before falling back to
broadcast, behind `Config::enableDirectedReactive`, default `false`.**

When the regular table has no entry for the destination and the virtual table
does, the ant is **unicast** along that gradient instead of broadcast. Applied at
two sites: in-transit ants (`onReceiveAnt`) and the origin (`onDataPacket`) —
the origin being the more valuable of the two, since that broadcast is
generation 0, the one every downstream copy descends from.

**ADR-0007's load-bearing invariant is preserved: data still never reads virtual
pheromone.** What changes is narrower than "reactive paths never read it" — a
reactive *ant* may now be steered by it. Data forwarding
([ADR-0010](0010-data-forwarding-prevhop-excluded-stochastic.md)) is untouched.

Default `false` because this is a mechanism **not present in either source**, and
the repo's standing rule is that a non-source mechanism ships off until a
benchmark justifies the switch — the same treatment `enableMacMetric` gets, and
the inverse of `enableEvaporation` ([ADR-0012](0012-evaporation-is-a-secondary-safety-net.md)),
which ships on and is gated so the faithful ablation stays runnable. Here the
faithful behaviour *is* the default, so the gate exists to make the deviation
runnable rather than the fidelity.

Observable: `AntRouterLogic::directedSteers()`, surfaced as ns-3
`DirectedSteers()` and printed by `anthocnet-compare --diag`.

## Two properties that bound the claim

Both were established while implementing, and both constrain what a result from
[#244](https://github.com/danieljoppi/AntHocNet/issues/244) can say.

1. **It is not position-based.** Unlike LAR or GPSR, nothing here needs
   coordinates, a location service, or an orbital model — the "direction" is
   pheromone the node already received. This is why it is a MANET mechanism that
   *also* applies to a constellation, rather than a satellite special case. It
   is also why it degrades safely: with no gradient it floods exactly as before,
   rather than producing a wrong answer.

2. **It cannot help a cold start.** Diffusion advertises only destinations the
   advertiser already has regular pheromone for, so the first discovery in a
   fresh network has no gradient at all and the directed ant floods identically.
   This was found by the unit test asserting `steers > 0` and failing. Directed
   reactive discovery is therefore a **reconvergence / known-destination**
   optimisation — which is also the case where flooding is most wasteful, so the
   restriction is less damaging than it first sounds. Any scenario built to
   measure it must establish a gradient first, or it will measure nothing.

## Alternatives considered

- **Do it unconditionally, no flag.** Rejected on the same reasoning ADR-0007
  used for the inverse case: an unmeasured mechanism should not silently become
  the shipped protocol, and a flag costs almost nothing while yielding a free
  A/B.
- **Let data forwarding use virtual pheromone too.** Rejected — this is
  ADR-0007's actual invariant and the reason virtual pheromone can afford to be
  optimistic. An advert says "I can reach X", not "I have measured a good path
  to X"; steering an *ant* by that is a cheap probe, steering *data* by it is a
  delivery bet on unverified information.
- **Broadcast and unicast (steer as a hint, keep the flood as insurance).**
  Rejected for now: it removes the entire overhead saving, which is the only
  reason to do this. But it is the natural mitigation if the hazard below turns
  out to bite — see
  [#245](https://github.com/danieljoppi/AntHocNet/issues/245).
- **Make it satellite-only.** Rejected: nothing in the mechanism is
  satellite-specific, and scoping it that way would have made it untestable on
  the scenarios we actually run.

## Consequences

- One ablation axis added to the benchmark matrix, and one new question for it
  to answer: does a directed walk find the destination as reliably as a flood?
- **Known hazard, tracked in
  [#245](https://github.com/danieljoppi/AntHocNet/issues/245):** the steer
  *replaces* the broadcast rather than supplementing it, so a stale gradient can
  send the single ant down a dead end where a flood would have found a path.
  Where the failure is local (dead next hop) detector D
  ([ADR-0008](0008-neighbour-liveness-two-detectors.md)) eventually prunes it;
  where the gradient is stale further downstream there is no local signal at
  all, and the origin will re-steer to the same place on each
  `reactiveRetryInterval`. This is the reason the default is off, and it is a
  correctness question that must be answered before the default could change.
- No wire-format change: the virtual table is local state and no new field
  travels ([ADR-0006](0006-on-wire-protocol-version.md)).
- ADR-0007's consumer list is now out of date as written; the invariant it was
  protecting (data never reads virtual pheromone) is intact.
