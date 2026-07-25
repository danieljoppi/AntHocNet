# Sweep: pause

**Varies:** pause time (s) — 0 (constant motion) → 900 s (static).

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

## What it varies

Reproduces **Fig. 2** of the AntHocNet paper (Di Caro/Ducatelle/Gambardella,
PPSN VIII 2004, §4): the random-waypoint pause time is swept from 0 to 900 s,
taking the field from constant motion to effectively static. It is also the
shape checked by the **Broch pause-sweep** validation anchor — AODV PDR must
*rise* with pause, and DSDV must be worst under high mobility (see
[methodology.md](../methodology.md#validation-anchors-known-expected-results)).
Unlike the paper (AODV only), every baseline is run on identical realisations.

Defined as `SWEEPS["pause"]` in
[`ns3/tools/run-scenarios.py`](../../../ns3/tools/run-scenarios.py)
(`scenario=paper areaX=2500`, `pause` ∈ {0, 100, 300, 600, 900}).

## How it is produced

Sweeps are **too heavy for the per-merge `benchmarks` workflow**, which runs
only the discrete scenarios. They come from the manual **Scenario matrix +
charts** workflow (`scenario-matrix.yml`), which renders `sweep-pause.png` into
[`docs/benchmarks/`](../) and uploads the classified CSV; the table below is
filled in by pointing `update-benchmarks.py` at that CSV.

Raw sweep data rescued from expired artifacts lives in
[`../campaign/`](../campaign/) — e.g.
[`30031904151-pause-disk.csv`](../campaign/30031904151-pause-disk.csv) — and is
summarizable with the `benchmark-results` skill's `sweep_summary.py`.

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
