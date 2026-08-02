# ADR-0018: The proactive emission gate compares virtual and regular pheromone per link, not best-vs-best

- **Status:** Accepted — the #180 re-derivation; shipped gate-off by default
- **Date:** 2026-08-02

## Context

The thesis conditions proactive-ant emission on diffusion having found
something worth checking: *"only if the best virtual pheromone is
significantly better (in our experiments: at least 10% better) than the best
regular pheromone, a proactive forward ant is sent out"* (Ducatelle 2007,
lines 4084–4088). PR #188 shipped that literal scalar form with the thesis's
0.10 margin and measured it harmful — pass rate 0 % (line) to 3.8 % (grid),
starved maintenance, +36–68 % NRL and −5 to −6.4 pp PDR — after which the
mechanism was kept but the default margin set to 0 (gate off), and #180 owned
re-deriving *what the thesis actually compares* before any non-zero margin
could be considered.

Two table-hygiene defects had to fall first, because both corrupted the very
quantities the gate compares:

- **#262** — virtual pheromone aged on an accidental per-hello clock
  (α^degree per second), depressing it degree-dependently (median v/r 0.49,
  ~4× monotone fall with degree). Fixed: both tables now age on the identical
  α^(Δt/interval) clock.
- **#279** — every reception re-seeded the 1-hop regular entry at the
  unitless constant 1.0, pinning it ~100× low and corrupting every 1-hop
  hello advert (the diffusion input). Fixed: receptions refresh at the
  metric's unloaded 1-hop value.

With both fixed, the uniformity probe (`core/tests/exp_uniformity_probe.cpp`,
PR #278) measured what remains — and what remains is **structural, not a
calibration error**:

- The matched **per-link** v/r ratio is centred 0.97–1.06, degree- and
  hop-independent, p75 1.20–1.32, p90 1.32–2.19.
- The **best-vs-best** ratio at gate sites has a hard ceiling
  τ(h−1)/τ(h) = (T̂+h·T_hop)/(T̂′+(h−1)·T_hop) ≈ **h/(h−1)**: the neighbour's
  advertised best path is one hop shorter than the node's own best path to the
  same destination, so the scalar ratio never exceeds the one-hop cost ratio.
  Measured byte-exact: grid 6-hop ceiling 1.2000, line 7-hop 1.1629.

The consequence: a fixed scalar margin m is satisfiable only for destinations
within **1 + 1/m hops**. m = 0.10 ⇒ h ≤ 11; m = 0.20 ⇒ h ≤ 6 (pass rate
measured falling from 35.6 % at k = 1.10 to 0.0 % at k = 1.20 on the 6-hop
grid). On the satellite regime — the gate's payoff surface per #248, since
MANET benchmark guidance is proactive-off — ISL paths routinely exceed that,
so a scalar gate silently disables proactive maintenance for exactly the far
destinations that need it most. No single k is right across path lengths:
**the re-derivation is a shape question.**

## Decision

`shouldSendProactive(dest)` passes iff **some neighbour n satisfies
`v(dest,n) ≥ (1+m) · r(dest,n)`**, where m is `proactiveVirtualMargin`, with
two qualifications:

1. A virtual hint on a link whose regular entry sits at/below `minPheromone`
   **passes trivially** — diffusion turned up a link the sampling never
   priced (unsampled or evicted), which is the genuine "good *new* virtual
   pheromone" case and the strongest reason to send an ant. The probe
   measured this tail reaching 3.5×10⁵ — it is real signal, not noise.
2. The boundary cases are unchanged from the scalar implementation: no
   regular route at all → always send (the session needs an ant most);
   margin ≤ 0 → gate off (the ablation); diffusion off → gate cannot be
   evaluated, unconditional emission (that ablation keeps meaning "proactive
   without guidance", not "no proactive").

Comparing v and r **on the same link** cancels the h/(h−1) systematic — both
estimators describe the same path, differing only by the diffusion bootstrap
and refresh phase — so the margin finally means what the thesis intended:
"the hint is materially better than what I already know", independent of how
far the destination is.

**The default stays 0 (gate off).** The re-derived shape makes a non-zero
margin *meaningful*; whether one becomes a default is a benchmark decision on
the satellite regime, made against the A/B record on #180. The probe's
distribution puts the useful range at m ≈ 0.2–0.5 (selecting the ~5–15 %
genuine-anomaly tail of link-checks).

## Alternatives considered

- **Retune the scalar margin.** No k works: every k is a hop cutoff, and the
  cliff is sharp (35.6 % → 0.0 % between k = 1.10 and 1.20 on a 6-hop grid).
  Rejected — this is the mistake #188's history warns against repeating.
- **Scalar with m ≤ 1/(h_max−1).** Keeps thesis literalism at the cost of a
  margin so small (~0.05 on a satellite grid) it mostly measures refresh
  phase, and it still couples the knob to the topology's diameter. Rejected
  as default; the scalar form remains reachable for fidelity experiments only
  by reverting this ADR's change, deliberately not by a runtime switch (a
  knob whose wrong setting silently re-introduces a measured pathology is the
  #206 anti-pattern).
- **Gate on the unsampled-link case only** (drop the margin entirely). Loses
  the thesis's efficiency reading — a same-link improvement above the γ-ramp
  band is real information worth checking too. Rejected.

## Consequences

- The gate's semantics change wherever `proactiveVirtualMargin > 0` is set;
  nothing changes at the shipped default (margin 0 short-circuits before the
  comparison — byte-identical behaviour).
- Core tests pin the new shape (`test_proactive.cpp` cases 10–11c: same-link
  block/pass at the margin, the unsampled-link trivial pass, and the
  hop-ceiling cancellation case the scalar form fails).
- The #180 A/B (satellite corridor field, gate m = 0.3 vs gate off vs the old
  scalar) is the empirical record for any future default change.
- `docs/fidelity.md` deviation 4b and `docs/configuration.md`'s
  `proactiveVirtualMargin` row updated: the mechanism is thesis, the shape is
  a measured correction, the default remains a repo choice.
- Wire format untouched (the gate is a local emission decision).

## References

[#180](https://github.com/danieljoppi/AntHocNet/issues/180) (the finding,
probe measurements and algebra), #188 (the scalar form's measured failure),
#262 / ADR-0012 update (clock commensurability), #279 (advert magnitude),
PR #278 (`exp_uniformity_probe`), #248 (regime scoping), #216 (the satellite
field the gate serves), `core/src/ant_router_logic.cpp`
(`shouldSendProactive`), Ducatelle 2007 §4 (lines 4084–4088).
