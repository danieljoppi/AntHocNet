# ADR-0020: Security ships as a default-off profile, not a fork

- **Status:** Accepted — governs
  [#302](https://github.com/danieljoppi/AntHocNet/issues/302), targeted at
  **v3.0.0**; no code yet (phase 0 of that epic is the threat-model ADR that
  will follow this one)
- **Date:** 2026-08-03

## Context

Trust- and security-aware ACO routing is the most common contemporary extension
of AntHocNet in the literature: blackhole/grayhole mitigation, trust-weighted
next-hop selection, fuzzy-trust hybrids. The 2026 roadmap research
([#298](https://github.com/danieljoppi/AntHocNet/issues/298)) initially recorded
security as a **non-goal**, on the grounds that a trust-aware AntHocNet is a new
protocol wearing the name: this repository's value is being the paper-faithful
reference implementation, and mechanisms absent from the 2004 paper and 2007
thesis put an asterisk on every fidelity claim.

The maintainer then asked for security support anyway — with the specific
framing that it be *our* implementation plus a configuration to enable or
disable it. That framing is what resolves the objection, so it is worth writing
down as a decision rather than leaving it in an epic description: the reason
security was a non-goal was never "security is uninteresting", it was
"unconditional protocol change dilutes fidelity". A conditional one does not.

The repo already has the pattern. `EnableMacMetric`, `EnableDirectedReactive`
([ADR-0016](0016-directed-reactive-discovery-is-gated-and-off.md)) and
`EnableMultipath` are all mechanisms that ship off or gated so the faithful
behaviour remains the default and the deviation stays runnable and measurable.
Security is the largest instance of that pattern, not an exception to it.

## Decision

**Security ships inside the same implementation, behind attributes, default
off — and the default path must remain byte-identical to the paper-faithful
protocol.**

Four binding constraints:

1. **One implementation, no fork.** All logic lives in `core/`
   ([ADR-0002](0002-one-core-two-adapters.md),
   [ADR-0003](0003-pure-core-returns-route-decisions.md)); adapters only expose
   knobs. No security branch, no second binary, no `#ifdef SECURE`.
2. **`EnableSecurity = false` by default, and provably inert when off.** Not
   "we believe it is off" — a determinism check in the style of
   [#129](https://github.com/danieljoppi/AntHocNet/issues/129) proves the OFF
   path produces bit-identical traces to the pre-feature build. If the default
   path moved, the change is wrong regardless of how well the ON path performs
   (the [#292](https://github.com/danieljoppi/AntHocNet/issues/292) verification
   pattern).
3. **Wire changes obey the existing rule.** Authenticated ants add fields, so
   `kWireVersion` bumps and the codec round-trip and fuzz coverage extend with
   them ([ADR-0006](0006-on-wire-protocol-version.md), golden rule 4). The
   authenticated layout is part of the documented wire format, not a private
   extension.
4. **Fidelity claims never cite a security-on run.** `docs/fidelity.md` marks
   the profile as an extension; the paper-faithful subject of every fidelity
   statement remains the default configuration.

The trust signal enters through the **`ILinkMetric` seam**
([`architecture.md`](../architecture.md)) wherever possible: that seam exists to
let a different notion of link goodness be plugged in without the core learning
about it, and a trust factor is exactly such a notion. This is a design
preference, not a constraint — the epic's phase-0 ADR will decide it against the
alternative of a trust term in the goodness composition, with the reasoning
recorded there.

## Why a new major version

v3.0.0, not a minor. Not because the default behaviour changes — by constraint 2
it must not — but because the release adds a protocol capability and on-wire
fields beyond the paper-faithful core. That is a different *kind* of change from
the v1.x evaluation-rigor line (statistics, metrics, realism, baselines) and the
v2.0.0 dynamic-satellite line, and the version number should say so.

## Alternatives considered

- **Keep it a non-goal.** Rejected by the maintainer; and the stated reason for
  the non-goal is fully addressed by constraints 1–4.
- **A separate `anthocnet-secure` fork or build target.** Rejected: it doubles
  the maintenance surface, guarantees drift, and makes the honest comparison
  (secure vs faithful on identical seeds) harder rather than easier — the same
  reasoning as ADR-0015.
- **Security on by default, with a switch to disable it.** Rejected: it inverts
  the repo's standing rule that a non-source mechanism ships off until measured,
  and it would silently make every future benchmark a benchmark of the secured
  protocol.
- **Compile-time flag instead of a runtime attribute.** Rejected: a runtime
  attribute is what makes the A/B on identical seeds possible in one binary,
  which is how every other mechanism here is evaluated
  ([#177](https://github.com/danieljoppi/AntHocNet/issues/177)).

## Consequences

- The vulnerability measurement comes first and stands alone: an attacker arm
  (blackhole/grayhole) run against **all four protocols** is publishable before
  any defense exists, and it is what makes a later defense delta meaningful.
- A new benchmark obligation: the trust layer must read **NOISE** in benign
  scenarios. A defense that costs delivery when no attacker is present is a
  regression, and the A/B discipline is what catches it.
- Ant authentication has a measurable, permanent overhead in `nrl_bytes`; that
  cost is a first-class result of the epic, not a footnote.
- [#263](https://github.com/danieljoppi/AntHocNet/issues/263) (adverts reflected
  back at their originator) is the *accidental* instance of the forgery class
  this profile addresses deliberately — fixing it remains independent of, and
  prior to, any security work.
- The mechanism × regime table ([`network-regimes.md`](../network-regimes.md)
  §6) gains a profile that is **orthogonal** to regime: trust evidence differs
  by medium (promiscuous overhear on Wi-Fi vs delivery feedback on
  point-to-point ISLs), which is a phase-2 design input, not a per-regime
  default ([ADR-0019](0019-network-families-change-the-evaluation-not-the-protocol.md)).
