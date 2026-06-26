# 07 — Validation harness + paper-faithful benchmark scenario

- **Deviation:** — (methodology, not a protocol bug)
- **Priority:** P2 (run continuously while doing 01–06)
- **Effort:** M
- **Layer:** `ns3/` tooling + `core/tests/`
- **Depends on:** nothing; most useful once 01–02 land

## Summary

The repo's benchmark shows AntHocNet under-performing AODV/OLSR — partly because
of the protocol deviations (items 01–06) and partly because the **benchmark
scenario is the one regime the papers say AntHocNet is *not* good at** (small,
dense, low-mobility). This item sets up (a) per-change unit/behaviour validation
and (b) a benchmark scenario faithful to the papers, so progress on 01–06 is
measurable and not masked by an unfavorable scenario.

## Why the current benchmark is misleading

Current scenario (`docs/benchmarks.md`): 16 nodes, 250 m area, max speed 5 m/s,
4 flows.

> "...with high interference and very short paths, it is clear that the advantages
> of maintaining multiple paths, stochastically spreading data, using local
> repair, etc., do not outweigh their costs. A simple, reactive approach as AODV
> is expected to be much more effective. ... as the environment became more
> difficult (more mobility, more sparseness, longer paths), the characteristics
> of AntHocNet became an advantage over those of AODV." — [1] §4.2

A 250 m area with 16 nodes is dense and short-path: exactly where AntHocNet is
*expected* to lose. The papers' base scenario is **100 nodes, 3000×1000 m, speeds
0–20 m/s, 30 s pause, ~20 CBR flows, 900 s** — large, sparse, mobile, long paths.

## Part A — protocol behaviour validation (cheap, in CI)

These run without a simulator and pin protocol behaviour the way each item
requires. Add as `core/tests/` and keep green.

1. **Metric monotonicity (item 02):** lower-delay / fewer-hop path ⇒ higher
   pheromone.
2. **Greediness (item 01):** higher `betaData` ⇒ more concentrated next-hop
   distribution (statistical test over a scripted RNG sweep).
3. **Diffusion gradient (item 03):** better advertised path ⇒ higher virtual
   pheromone; data never uses virtual pheromone.
4. **Active-session proactivity (item 04):** proactive ants only for active
   destinations; per-hop exploratory broadcast fires at ~`proactiveBroadcastProb`.
5. **Failure handling (item 05):** hello-timeout expiry; notification emit +
   propagate; bounded repair.
6. **Evaporation (item 06):** periodic decay of unused entries; single reactive
   ant per backoff window.

Add a tiny **multi-hop in-memory scenario** harness (extend
`core/tests/test_network_integration.cpp`) that measures, with a deterministic
RNG and `FakeClock`:
- delivery ratio of N injected data packets,
- average hop count of delivered packets,
- control-ant count (overhead proxy).

Assert sane invariants (e.g. delivery ratio == 1.0 in a static connected line/grid
once a route is set up; overhead doesn't grow super-linearly with packets after
item 06.3). This catches regressions long before a full NS-3 run.

## Part B — faithful NS-3 benchmark scenario

Extend the existing harness rather than replacing it. The comparison driver is
`ns3/examples/anthocnet-compare.cc` with wrappers
`ns3/tools/run-comparison.sh` and `ns3/tools/cross-check.sh`.

1. **Add scenario presets** to `anthocnet-compare` (CLI flags already take
   nNodes/area/time/flows). Provide named presets:
   - `dense-small` (current: 16 nodes / 250 m / 5 m/s / 4 flows) — keep for
     regression continuity.
   - `paper-base` (≈100 nodes / 3000×1000 m / 0–20 m/s / 30 s pause / 20 flows /
     900 s) — the regime AntHocNet targets.
   - `sweep-mobility` and `sweep-size` — vary one axis (speed; node count/area)
     to reproduce the papers' trend plots.
2. **Average over ≥10 seeds** (current default 5; the docs already note single
   seeds are noisy). Make seed count a preset default.
3. **Report overhead.** The papers weigh AntHocNet's PDR/delay advantage against
   its higher routing overhead. Add a **routing-overhead** column (control bytes
   or control packets / delivered data packet) to the FlowMonitor output and to
   `docs/benchmarks.md`'s table + `ns3/tools/update-benchmarks.py`.
4. **Keep the auto-generated table**, but add a second table for `paper-base` so
   the README shows both the (honest) hard case and the regime where AntHocNet is
   meant to win.

## Part C — measure each item's effect

For each of items 01–06, record a before/after row on `paper-base` (10+ seeds):

| item | PDR % | delay ms | throughput kbps | overhead | notes |
|------|------:|---------:|----------------:|---------:|-------|

Expected directional effects (hypotheses to confirm, not guarantees):
- **01 (greedy data β):** PDR ↑, delay ↓ (data stops using bad paths).
- **02 (delay metric):** delay ↓, better path selection under load.
- **03+04 (diffusion + active proactivity):** PDR ↑ on mobility, overhead ↓ vs
  blind proactive broadcast.
- **05 (failure handling):** PDR ↑ substantially on the mobile/sparse presets,
  especially in **NS-3** (closes the no-detection gap).
- **06 (evaporation/backoff):** overhead ↓, stability ↑.

## Files to touch

- `core/tests/test_network_integration.cpp` (metrics harness) + new tests per item
- `ns3/examples/anthocnet-compare.cc` (scenario presets, overhead metric)
- `ns3/tools/run-comparison.sh`, `ns3/tools/update-benchmarks.py`
- `docs/benchmarks.md` (second table + overhead column)
- `.github/workflows/benchmarks.yml` (optional: add a `paper-base` job, likely
  manual-dispatch given runtime)

## Acceptance criteria

1. `make test` runs the new behaviour tests in CI (no simulator needed).
2. `anthocnet-compare --preset=paper-base` runs and emits PDR/delay/throughput
   **and overhead**, averaged over the preset's seed count.
3. `docs/benchmarks.md` shows both `dense-small` and `paper-base` tables,
   auto-regenerated.
4. A short results note (this file or a sibling) records the before/after table
   from Part C as items land.

## Risks / notes

- `paper-base` (100 nodes, 900 s, 10 seeds) is **heavy** — gate it behind manual
  workflow dispatch, not every merge.
- NS-2 vs NS-3 absolute numbers won't match (`docs/cross-validation.md`); compare
  each simulator against *itself* before/after a change, and protocols against
  each other within one simulator.
- Don't tune `alpha`/`beta`/intervals to the small scenario; tune on `paper-base`.
