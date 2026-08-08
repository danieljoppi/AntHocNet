# Grid: mobility × channel

**Varies:** mobility model (`rwp`, `ssrwp`, `gaussmarkov`) × channel model
(`tworay`, `nakagami`) — six cells at the paper base scenario.

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md)

> **Provenance — measured at `4cdfb96`, *after* `v1.3.0`.** This page does
> **not** follow the [`v1.3.0` pin](methodology.md#provenance-which-version-a-number-was-measured-at)
> the sweep pages carry. It is the **first published campaign that describes
> the current default branch**: it was measured after
> [#327](https://github.com/danieljoppi/AntHocNet/issues/327) (`betaAnts`/
> `betaData` 2.0 → 20) and
> [#352](https://github.com/danieljoppi/AntHocNet/issues/352) (per-seed RNG
> stream assignment), the two merges that superseded the `v1.3.0` corpus
> ([#365](https://github.com/danieljoppi/AntHocNet/issues/365)). **Its numbers
> are therefore not comparable cell-for-cell with the sweep or headline pages**,
> which predate both. Reproduce at commit `4cdfb96`.

## What it varies

The [v1.4.0 exit criteria](../roadmap.md) ask for a headline grid under **≥2
mobility models × ≥2 channel models with a ranking-stability statement**. This
is that grid.

The axes are deliberately built as *controlled contrasts* rather than as a
collection of unrelated models:

- **Mobility** ([#61](https://github.com/danieljoppi/AntHocNet/issues/61)) —
  `rwp` is the original evaluation's Random Waypoint; `ssrwp` is the same model
  started from its stationary distribution, so `rwp` vs `ssrwp` isolates the
  speed-decay transient alone; `gaussmarkov` is the qualitatively different
  model (smooth correlated tracks). `pause` is inert under Gauss-Markov and is
  set to 0 there — preflight FAILs any other value.
- **Channel** ([#60](https://github.com/danieljoppi/AntHocNet/issues/60)) —
  `nakagami` stacks Nakagami-*m* fading on **the same two-ray path loss** used
  by the `tworay` arm, so the pair isolates fading alone. The `range` disk
  model is deliberately *not* one of the two: it is a propagation abstraction
  with no fading and no distance-dependent loss curve, so counting it would
  satisfy the criterion's letter while leaving its motivation untouched.

## How it is produced

Six manual `paper-benchmark.yml` dispatches, one per cell — **not** the
per-merge `benchmarks` workflow and not `scenario-matrix.yml`. Each cell runs
the paper base scenario (50 nodes, 1500 × 300 m, 900 s, 20 CBR flows) at
**20 seeds**, with all four protocols on identical realisations inside that
cell.

Because the cells come from independent dispatches rather than one classified
sweep, this page has **no generated block** — the tables below are
hand-written, as on the [satellite suite](satellite/isl-grid.md) page. The
underlying data is committed so the tables can be re-derived:
`../benchmarks/campaign/pooled-grid-mobility-channel-20260808.csv` and its
per-run sibling (480 rows: 6 cells × 4 protocols × 20 seeds).

## Results

### Delivery — PDR %, mean ± 95 % CI

| mobility | channel | anthocnet | aodv | olsr | dsdv |
|---|---|---|---|---|---|
| rwp | tworay | **97.43 ± 0.22** | 85.92 ± 0.55 | 90.59 ± 0.46 | 84.99 ± 0.63 |
| ssrwp | tworay | **97.55 ± 0.30** | 86.56 ± 0.63 | 91.25 ± 0.62 | 85.74 ± 0.72 |
| gaussmarkov | tworay | **96.97 ± 0.31** | 83.90 ± 0.81 | 85.92 ± 0.90 | 78.70 ± 1.02 |
| rwp | nakagami | **92.03 ± 0.59** | 73.49 ± 1.08 | 87.78 ± 0.38 | 71.86 ± 1.03 |
| ssrwp | nakagami | **92.08 ± 1.01** | 73.02 ± 0.71 | 87.64 ± 0.47 | 72.37 ± 1.14 |
| gaussmarkov | nakagami | **89.33 ± 1.06** | 67.23 ± 1.26 | 83.46 ± 0.78 | 63.99 ± 1.17 |

### Overhead — NRL, mean ± 95 % CI

| mobility | channel | anthocnet | aodv | olsr | dsdv |
|---|---|---|---|---|---|
| rwp | tworay | 35.14 ± 0.64 | 64.64 ± 1.41 | 4.02 ± 0.04 | 23.01 ± 0.21 |
| ssrwp | tworay | 34.27 ± 0.69 | 64.37 ± 2.09 | 3.96 ± 0.04 | 22.74 ± 0.28 |
| gaussmarkov | tworay | 36.17 ± 0.86 | 63.73 ± 1.81 | 4.34 ± 0.07 | 24.90 ± 0.37 |
| rwp | nakagami | 49.78 ± 1.06 | 77.98 ± 1.79 | 4.35 ± 0.04 | 27.83 ± 0.41 |
| ssrwp | nakagami | 49.90 ± 1.79 | 76.80 ± 1.53 | 4.31 ± 0.05 | 27.41 ± 0.54 |
| gaussmarkov | nakagami | 57.10 ± 2.27 | 85.05 ± 2.40 | 4.73 ± 0.06 | 31.43 ± 0.55 |

### Tail — `delay99` ms, mean with bootstrap 95 % interval

| mobility | channel | anthocnet | aodv | olsr | dsdv |
|---|---|---|---|---|---|
| rwp | tworay | 787.5 [748.9, 826.0] | 584.6 [560.2, 609.2] | **23.2 [22.3, 24.2]** | 419.8 [374.1, 485.7] |
| ssrwp | tworay | 720.8 [682.3, 758.6] | 583.5 [558.2, 611.1] | **22.2 [21.6, 22.9]** | 499.1 [411.1, 600.2] |
| gaussmarkov | tworay | 832.3 [798.9, 866.4] | 575.5 [551.5, 600.8] | **68.7 [24.4, 144.7]** | 545.9 [421.7, 677.5] |
| rwp | nakagami | 1155.2 [1125.0, 1186.5] | **839.1 [807.3, 871.4]** | 2714.1 [2530.0, 2880.5] | 2036.0 [2027.9, 2044.7] |
| ssrwp | nakagami | 1152.4 [1111.7, 1194.2] | **817.6 [780.5, 857.5]** | 2685.2 [2516.3, 2846.7] | 2034.0 [2026.5, 2041.8] |
| gaussmarkov | nakagami | 1343.2 [1266.2, 1418.8] | **1027.5 [958.0, 1103.3]** | 2961.0 [2867.6, 3009.2] | 2271.4 [2137.7, 2428.9] |

Bold marks the best cell in each row. A `t`-interval on a per-run p99 is not
defensible, so the tail uses a percentile bootstrap
([policy](methodology.md#ci-method-per-metric)).

### AntHocNet vs AODV — paired, per seed

Both protocols run on identical realisations *inside* a cell, so this is a
paired difference (t-CI for PDR/NRL, bootstrap for `delay99`, two-sided
Wilcoxon). This is the test of record; the per-arm intervals above are for
orientation.

| mobility | channel | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) |
|---|---|---|---|---|
| rwp | tworay | **+11.51** [+10.97, +12.06] | **−29.50** [−31.03, −27.98] | +202.90 [+152.97, +252.83] |
| ssrwp | tworay | **+11.00** [+10.43, +11.57] | **−30.10** [−32.35, −27.86] | +137.25 [+86.86, +187.64] |
| gaussmarkov | tworay | **+13.07** [+12.33, +13.82] | **−27.56** [−29.22, −25.89] | +256.85 [+219.77, +293.93] |
| rwp | nakagami | **+18.54** [+17.36, +19.71] | **−28.20** [−29.91, −26.49] | +316.05 [+265.59, +366.51] |
| ssrwp | nakagami | **+19.07** [+18.03, +20.10] | **−26.90** [−28.86, −24.95] | +334.75 [+272.16, +397.34] |
| gaussmarkov | nakagami | **+22.09** [+21.13, +23.05] | **−27.95** [−30.33, −25.57] | +315.65 [+220.68, +410.62] |

Every p ≤ 9.6 × 10⁻⁵. Twelve comparisons at α = 0.05 expect ~0.6 false
positives; the smallest effect here is 19 interval half-widths from zero, so
none of these is marginal.

## The ranking-stability statement

**Scoped, because one ranking is stable and another is not.**

**Stable — delivery and overhead.** The delivery ordering is
`anthocnet > olsr > aodv > dsdv` in **all six** cells, and AntHocNet's lead
over AODV is significant in every one. The overhead ordering
(`olsr < dsdv < anthocnet < aodv`) likewise holds in all six. Neither claim
depends on the mobility model or the channel.

**Not stable — the tail.** The `delay99` ordering inverts with the channel:

| channel | `delay99` best → worst |
|---|---|
| two-ray | **olsr** (22–69 ms) → dsdv → aodv → **anthocnet** (721–832 ms) |
| Nakagami | **aodv** (818–1028 ms) → **anthocnet** (1152–1343 ms) → dsdv → **olsr** (2685–2961 ms) |

OLSR holds the best tail by a factor of ~25 under two-ray and the **worst**
under fading; AntHocNet moves from 4th to 2nd. Its jitter moves the same way
(9.6–12.6 ms → 164–189 ms), so the two are one effect rather than two.

**Consequence: a tail claim that does not name its channel is unsupported.**
That includes this project's own two-ray tail numbers — they characterise
AntHocNet's tail *under two-ray*, not in general. The
[#21](https://github.com/danieljoppi/AntHocNet/issues/21) deficit is real in
every cell measured here, but its *size relative to the other protocols* is a
property of the channel.

**Mobility is the weaker axis.** Across the three mobility models at fixed
channel, ΔPDR moves by ≤ 3.6 pp and no ordering changes anywhere. Steady-state
RWP lands essentially on classic RWP (+0.12 pp, p = 0.42 — not significant),
which is a useful negative: at this scenario the speed-decay transient the
steady-state model exists to remove is not what drives the result.

## Provenance

`main` @ `4cdfb96`, image `ghcr.io/danieljoppi/ns3:3.42-opt`, `runs=20`,
`time=900`, `areaX=1500`, `speed=20`, `protocols=anthocnet,aodv,olsr,dsdv`.

| mobility | channel | pause | run ID | wall clock |
|---|---|---|---|---|
| rwp | tworay | 30 | `31239953345` | 3 h 35 m |
| ssrwp | tworay | 30 | `31239962932` | 3 h 45 m |
| gaussmarkov | tworay | 0 | `31239973590` | 3 h 32 m |
| rwp | nakagami | 30 | `31239958344` | 4 h 25 m |
| ssrwp | nakagami | 30 | `31239968258` | 4 h 52 m |
| gaussmarkov | nakagami | 0 | `31239979624` | 4 h 08 m |

Every cell self-identifies through its `##CONFIG##` row
([#369](https://github.com/danieljoppi/AntHocNet/issues/369)), so the mapping
above is read from the data rather than from dispatch order. Fading costs
~30 % more wall clock; all six fit the 6 h ceiling, so no
[#126](https://github.com/danieljoppi/AntHocNet/issues/126) seed-splitting was
needed.

## What is deliberately not published here

Two metric families are omitted from the committed CSV and from every table
above, because they are known to be unreadable in these cells. The columns are
left **empty** rather than filled with wrong values — the same rule
`##HOLD##`/`##AIR##` follow, and `scenario_check.py results` reports
`OK (0 fail, 0 warn)` on the CSV precisely because the unreadable columns are
absent rather than present-and-wrong.

- **`drop_*` — broken on the fading cells.**
  [#377](https://github.com/danieljoppi/AntHocNet/issues/377): `drop_chan_pct`
  is a *residual*, not a measurement, and it goes to −13.77 with ~20 pp
  unaccounted on every Nakagami cell and every protocol. The two-ray cells are
  clean, but publishing the family for half a grid would invite exactly the
  cross-cell comparison that is invalid.
- **`path_div_*` / `path_entropy_bits` — the standing
  [#230](https://github.com/danieljoppi/AntHocNet/issues/230) limit.**
  `pathWindowS` outlives the route, so route *replacement* reads as concurrent
  multipath. Diversity remains readable only from the dedicated cell.

Neither affects the numbers on this page: PDR, delay, `delay99`, throughput
and NRL come from FlowMonitor and never touch the drop counters.
