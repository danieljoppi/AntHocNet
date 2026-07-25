# Sweep: scale

**Varies:** scale factor f — terrain ×f, nodes ×f² (50 → 200 nodes).

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

## What it varies

Reproduces **Fig. 3** of the AntHocNet paper (Di Caro/Ducatelle/Gambardella,
PPSN VIII 2004, §4): terrain is scaled by f and node count by f², holding node
density roughly constant while the network grows. Unlike the paper (AODV only),
every baseline is run on identical realisations.

Defined as `SWEEPS["scale"]` in
[`ns3/tools/run-scenarios.py`](../../../ns3/tools/run-scenarios.py) — the points
are f = 1.0 (50 nodes, 1500×500 m), 1.4 (98, 2100×700), 1.8 (162, 2700×900) and
2.0 (200, 3000×1000).

## How it is produced

Sweeps are **too heavy for the per-merge `benchmarks` workflow**, which runs
only the discrete scenarios. They come from the manual **Scenario matrix +
charts** workflow (`scenario-matrix.yml`), which renders `sweep-scale.png` into
[`docs/benchmarks/`](../) and uploads the classified CSV; the table below is
filled in by pointing `update-benchmarks.py` at that CSV.

Raw sweep data rescued from expired artifacts lives in
[`../campaign/`](../campaign/) and is summarizable with the `benchmark-results`
skill's `sweep_summary.py`.

## Results

> **Caveat — sweep numbers predate the #88 / #169 fixes.** Unlike the scenario
> pages, the sweeps are produced by the *manual* campaign workflow and have not
> been re-run since `T_hop` went to 3 ms
> ([#88](https://github.com/danieljoppi/AntHocNet/issues/88), PR #167) and the
> reactive hop cap was removed
> ([#169](https://github.com/danieljoppi/AntHocNet/issues/169), PR #170). Both
> change results. See [docs/fidelity.md](../../fidelity.md).

<!-- BENCHMARK-TABLE-START -->
<!-- BENCHMARK-TABLE-END -->
