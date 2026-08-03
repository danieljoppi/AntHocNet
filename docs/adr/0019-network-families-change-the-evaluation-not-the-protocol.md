# ADR-0019: Network families change the evaluation, not the protocol

- **Status:** Accepted — codifies existing practice; governs the family epics
  [#300](https://github.com/danieljoppi/AntHocNet/issues/300) (FANET),
  [#301](https://github.com/danieljoppi/AntHocNet/issues/301) (VANET) and the
  realism epic [#295](https://github.com/danieljoppi/AntHocNet/issues/295)
- **Date:** 2026-08-03

## Context

The 2026 roadmap research ([#298](https://github.com/danieljoppi/AntHocNet/issues/298))
put four more network families in scope — FANET, VANET, static Wi-Fi mesh, and
(further out) underwater and space–air–ground integrated networks — on top of
the two regimes we already run. The obvious way to support a family is to give
it its own profile: a preset that sets protocol attributes to values suited to
that family's mobility and density.

That instinct is wrong here, and the repo already has the evidence. Two prior
decisions bound it:

- [ADR-0015](0015-satellite-substrate-lives-in-the-image.md) refused a separate
  satellite build for the *most* different regime we support. If a constellation
  does not justify a second binary, a faster random-waypoint field certainly
  does not justify a second attribute profile.
- The A/B discipline ([`configuration.md`](../configuration.md) §5,
  [#177](https://github.com/danieljoppi/AntHocNet/issues/177)) exists because
  every default in this repo must trace to a source or a measurement. A
  per-family profile is a bulk edit of defaults with no measurement behind any
  of them — precisely the thing the discipline forbids, wearing a scenario's
  clothes.

There is also a fidelity cost. `docs/fidelity.md` makes claims about *the*
protocol. A protocol whose constants depend on which preset you selected has no
single fidelity story, and every claim would need a "which profile?" qualifier.

## Decision

**A network family is a scenario concern, not a protocol concern. Adding
family support means adding mobility models, presets, preflight rules,
anchors and metrics — never a family-specific set of protocol attribute
defaults.**

Concretely, adding a family may add:

- a mobility model (`GaussMarkov`, Manhattan/SUMO trace import, …) and, if the
  family needs it, harness plumbing such as the z-axis for 3D;
- a `--scenario=<family>` preset fixing *scenario* knobs — node count, field,
  speed, pause, traffic — with recorded provenance, exactly as `paper` and
  `thesis` do;
- `scenario_check.py` preflight coherence rules for the knobs it introduces;
- its own `anchors.yml` entry (a floor from another family does not transfer);
- metrics the family's literature expects.

It may **not** add: a different `HelloInterval`, `QueueTimeout`, acceptance
factor, or any other protocol default selected by family.

When a run suggests a protocol constant is mis-sized for a family, that is a
finding, not a preset: it opens an issue, gets an A/B on identical seeds, and —
if the delta holds — changes the value **for everyone**, or becomes a gated
mechanism with its own default-off switch. The satellite regime already works
this way: the propagation-dominated timing mismatch is
[#205](https://github.com/danieljoppi/AntHocNet/issues/205), an open ticket with
measurements pending, not a `--scenario=satellite` block that quietly retunes
`HopTime`.

## What this does *not* claim

It does not claim the protocol performs equally well everywhere, or that no
constant will ever need to vary. It claims that **variation must be earned by
measurement and expressed as a gated mechanism**, so that one binary with one
set of defaults remains the thing being evaluated. The mechanism × regime table
in [`network-regimes.md`](../network-regimes.md) §6 is the honest ledger of what
that costs: on an ISL link, hello beacons are redundant and two Wi-Fi-coupled
mechanisms are inert, and we report that rather than papering over it with a
satellite profile.

## Alternatives considered

- **Per-family attribute profiles.** Rejected above: unmeasured bulk default
  changes, and it dissolves the single fidelity story.
- **A per-family build (or fork per family).** Rejected for the same reason
  ADR-0015 rejected a satellite build, plus a combinatorial explosion:
  families × regimes × metric arms.
- **Auto-tuning constants from scenario parameters** (e.g. derive
  `HelloInterval` from speed and range). Attractive and possibly correct, but it
  is a *protocol mechanism* — an adaptive hello timer — and must be proposed,
  gated, and measured as one. It is not a licence to hard-code per-family
  numbers, and nothing here forecloses it.

## Consequences

- Family epics are scoped as harness work. #300 and #301 both carry a "knob
  watchlist → A/B follow-ups, not pre-tuning" clause enforcing this ADR.
- Cross-family comparisons stay meaningful: because every family runs the same
  protocol configuration, a ranking change between families is a property of the
  network, not of our tuning. That is what makes the ranking-stability statement
  in #295/#300 worth publishing.
- The mechanism × regime table becomes a maintained artifact: each new family
  adds a column, and "live / redundant / inert" is the honest answer where a
  profile would have hidden the question.
- Baselines get the same treatment: AODV/OLSR/DSDV run at stock defaults in
  every family, so a family-specific weakness in them is visible rather than
  tuned away.
