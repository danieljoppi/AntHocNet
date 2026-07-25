# Sweep: area

**Varies:** area long edge (m) — 1500 → 2500 m, in five points.

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

## What it varies

Reproduces **Fig. 1** of the AntHocNet paper (Di Caro/Ducatelle/Gambardella,
PPSN VIII 2004, §4): the base scenario's long edge is extended from 1500 m to
2500 m while node count and traffic stay fixed, so paths get longer and the
network gets sparser. Unlike the paper (AODV only), every baseline
(AODV/OLSR/DSDV) is run on identical realisations.

Defined as `SWEEPS["area"]` in
[`ns3/tools/run-scenarios.py`](../../../ns3/tools/run-scenarios.py)
(`scenario=paper`, `areaX` ∈ {1500, 1900, 2100, 2300, 2500}).

## How it is produced

Sweeps are **too heavy for the per-merge `benchmarks` workflow**, which runs
only the discrete scenarios. They come from the manual **Scenario matrix +
charts** workflow (`scenario-matrix.yml`), which renders `sweep-area.png` into
[`docs/benchmarks/`](../) and uploads the classified CSV; the table below is
filled in by pointing `update-benchmarks.py` at that CSV.

Raw sweep data rescued from expired artifacts lives in
[`../campaign/`](../campaign/) — e.g.
[`30031902395-area-disk.csv`](../campaign/30031902395-area-disk.csv) — and is
summarizable with the `benchmark-results` skill's `sweep_summary.py`.

## Results

> **Caveat — published numbers predate the `T_hop` fix.** Anything measured with
> the provisional `T_hop = 50 ms` needs re-measuring after
> [#88](https://github.com/danieljoppi/AntHocNet/issues/88) (PR #167, in flight;
> 50 ms → 3 ms). See [docs/fidelity.md](../../fidelity.md).

<!-- BENCHMARK-TABLE-START -->
<!-- BENCHMARK-TABLE-END -->
