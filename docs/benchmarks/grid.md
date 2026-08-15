# Grid: mobility × channel

**Varies:** mobility model (`rwp`, `ssrwp`, `gaussmarkov`) × channel model
(`tworay`, `nakagami`) — six cells at the paper base scenario.

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md)

> **Provenance — measured at `a1daa7a`, `ReconvHoldCap = 200 ms`.** This is the
> **v1.5.0 phase-1 re-baseline** ([campaign plan](v1.5.0-campaign.md),
> [#371](https://github.com/danieljoppi/AntHocNet/issues/371)): the
> [#411](https://github.com/danieljoppi/AntHocNet/pull/411) merge flipped the
> shipped `ReconvHoldCap` default 1 s → 200 ms — a protocol-behaviour change
> that superseded the `v1.4.0` corpus under the
> [provenance rule](methodology.md#provenance-which-version-a-number-was-measured-at)
> — and all six cells were re-measured on `main` at that merge commit. The
> baselines are **byte-identical** to the `v1.4.0` grid (0/18 rows moved — see
> the attribution control below), so every AntHocNet delta on this page is
> attributable to the flip alone. The previous version of this page (measured
> at `4cdfb96`, 1 s) remains in git history — `git show
> v1.4.0:docs/benchmarks/grid.md` — and its numbers stay valid as historical
> evidence of the 1 s operating point. Reproduce this page at commit `a1daa7a`.
>
> **The fifth arm — the oracle — was measured separately, at `40b434d`.**
> [Campaign phase 3](v1.5.0-campaign.md#phase-3--the-oracle-control)
> ([#415](https://github.com/danieljoppi/AntHocNet/issues/415),
> [#296](https://github.com/danieljoppi/AntHocNet/issues/296)) re-ran the same
> six cells with `--protocols=…,oracle` on `main` @ `40b434d`, the commit that
> added the arm. Those cells are a *different dispatch at a different commit*,
> so they would normally not be quotable in the same table — except that their
> **480 baseline `##RUN##` rows are byte-identical** to the phase-1 corpus
> (6 cells × 4 protocols × 20 seeds, AntHocNet included). That control is what
> makes the composition legitimate; it is stated in full in
> [Why the oracle columns compose](#why-the-oracle-columns-compose-with-the-tables-above)
> below, together with the caveat that travels with every oracle number on
> this page.

## What it varies

The [v1.4.0 exit criteria](../roadmap.md) ask for a headline grid under **≥2
mobility models × ≥2 channel models with a ranking-stability statement**. This
is that grid, re-established at the v1.5.0 default.

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
cell. Phase 3 repeated the same six dispatches with the oracle control added as
a fifth arm — same scenario, same 20 seeds, same
[#352](https://github.com/danieljoppi/AntHocNet/issues/352)-pinned RNG streams
(the oracle evaluates no propagation model, so it draws from none of them).

Because the cells come from independent dispatches rather than one classified
sweep, this page has **no generated block** — the tables below are
hand-written, as on the [satellite suite](satellite/isl-grid.md) page. The
per-run data behind them lives in the six Actions run logs (IDs in the
provenance table below; each cell's `##PROV##` line pins `commit=a1daa7a` and
its `##CONFIG##` pins `ReconvHoldCap=+2e+08ns`, so every block is
self-describing). The committed
`../benchmarks/campaign/pooled-grid-mobility-channel-20260808.csv` and its
per-run sibling remain the **1 s corpus**: their aodv/olsr/dsdv rows match
this page to the last digit (deterministic baselines, identical
[#352](https://github.com/danieljoppi/AntHocNet/issues/352)-pinned seeds), and
their anthocnet rows are the superseded 1 s measurement.

## Results

### Delivery — PDR %, mean ± 95 % CI

| mobility | channel | anthocnet | aodv | olsr | dsdv |
|---|---|---|---|---|---|
| rwp | tworay | **92.58 ± 0.63** | 85.92 ± 0.55 | 90.59 ± 0.46 | 84.99 ± 0.63 |
| ssrwp | tworay | **92.95 ± 0.63** | 86.56 ± 0.63 | 91.25 ± 0.62 | 85.74 ± 0.72 |
| gaussmarkov | tworay | **90.08 ± 0.63** | 83.90 ± 0.81 | 85.92 ± 0.90 | 78.70 ± 1.02 |
| rwp | nakagami | **89.78 ± 0.86** | 73.49 ± 1.08 | 87.78 ± 0.38 | 71.86 ± 1.03 |
| ssrwp | nakagami | **89.54 ± 0.88** | 73.02 ± 0.71 | 87.64 ± 0.47 | 72.37 ± 1.14 |
| gaussmarkov | nakagami | **85.87 ± 1.11** | 67.23 ± 1.26 | 83.46 ± 0.78 | 63.99 ± 1.17 |

### Overhead — NRL, mean ± 95 % CI

| mobility | channel | anthocnet | aodv | olsr | dsdv |
|---|---|---|---|---|---|
| rwp | tworay | 34.92 ± 0.63 | 64.64 ± 1.41 | 4.02 ± 0.04 | 23.01 ± 0.21 |
| ssrwp | tworay | 34.37 ± 0.70 | 64.37 ± 2.09 | 3.96 ± 0.04 | 22.74 ± 0.28 |
| gaussmarkov | tworay | 36.65 ± 1.05 | 63.73 ± 1.81 | 4.34 ± 0.07 | 24.90 ± 0.37 |
| rwp | nakagami | 46.89 ± 1.09 | 77.98 ± 1.79 | 4.35 ± 0.04 | 27.83 ± 0.41 |
| ssrwp | nakagami | 46.88 ± 1.44 | 76.80 ± 1.53 | 4.31 ± 0.05 | 27.41 ± 0.54 |
| gaussmarkov | nakagami | 52.44 ± 1.69 | 85.05 ± 2.40 | 4.73 ± 0.06 | 31.43 ± 0.55 |

### Tail — `delay99` ms, mean with bootstrap 95 % interval

| mobility | channel | anthocnet | aodv | olsr | dsdv |
|---|---|---|---|---|---|
| rwp | tworay | 420.8 [385.4, 454.6] | 584.6 [560.2, 609.2] | **23.2 [22.3, 24.2]** | 419.8 [374.1, 485.7] |
| ssrwp | tworay | 373.3 [331.7, 415.9] | 583.5 [558.2, 611.1] | **22.2 [21.6, 22.9]** | 499.1 [411.1, 600.2] |
| gaussmarkov | tworay | 512.8 [463.9, 563.9] | 575.5 [551.5, 600.8] | **68.7 [24.4, 144.7]** | 545.9 [421.7, 677.5] |
| rwp | nakagami | 920.0 [868.4, 964.2] | **839.1 [807.3, 871.4]** | 2714.1 [2530.0, 2880.5] | 2036.0 [2027.9, 2044.7] |
| ssrwp | nakagami | 890.6 [824.1, 952.6] | **817.6 [780.5, 857.5]** | 2685.2 [2516.3, 2846.7] | 2034.0 [2026.5, 2041.8] |
| gaussmarkov | nakagami | **1022.9 [987.5, 1055.6]** | 1027.5 [958.0, 1103.3] | 2961.0 [2867.6, 3009.2] | 2271.4 [2137.7, 2428.9] |

Bold marks the *nominal* best in each row, and three of the six rows are now
ties rather than wins: rwp-tworay's anthocnet vs dsdv intervals overlap
almost completely, gaussmarkov-nakagami's anthocnet-vs-aodv paired difference
is −4.65 ms [−83.20, +69.55] (p = 0.7 — a clean statistical tie with
anthocnet nominally first), and in the rwp/ssrwp fading cells aodv's paired
edge (+80.95 / +72.95 ms, p = 0.012 / 0.033) is marginal against the
multiple-comparison expectation below. A `t`-interval on a per-run p99 is not
defensible, so the tail uses a percentile bootstrap
([policy](methodology.md#ci-method-per-metric)).

### AntHocNet vs AODV — paired, per seed

Both protocols run on identical realisations *inside* a cell, so this is a
paired difference (t-CI for PDR/NRL, bootstrap for `delay99`, two-sided
Wilcoxon). This is the test of record; the per-arm intervals above are for
orientation.

| mobility | channel | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) |
|---|---|---|---|---|
| rwp | tworay | **+6.66** [+5.94, +7.39] | **−29.73** [−31.36, −28.09] | **−163.85** [−208.10, −119.90] |
| ssrwp | tworay | **+6.40** [+5.53, +7.26] | **−30.00** [−32.27, −27.74] | **−210.20** [−264.25, −157.50] |
| gaussmarkov | tworay | **+6.17** [+5.29, +7.06] | **−27.08** [−28.74, −25.42] | −62.65 [−118.50, −8.90] |
| rwp | nakagami | **+16.28** [+15.00, +17.57] | **−31.08** [−32.75, −29.42] | +80.95 [+23.50, +134.60] |
| ssrwp | nakagami | **+16.53** [+15.70, +17.36] | **−29.93** [−31.56, −28.30] | +72.95 [+10.70, +134.80] |
| gaussmarkov | nakagami | **+18.63** [+17.63, +19.64] | **−32.61** [−34.54, −30.68] | −4.65 [−83.20, +69.55] |

Every PDR and NRL comparison has p ≤ 9.6 × 10⁻⁵; the smallest of those
effects is 7 interval half-widths from zero, so none is marginal. The
`delay99` column is different in kind from the 1 s corpus, where AntHocNet
paid +137…+335 ms against AODV in **every** cell: at 200 ms the sign flips
negative in four of six cells, and the remaining tail comparisons are the
marginal ones (p = 0.012–0.7; eighteen comparisons at α = 0.05 expect ~0.9
false positives, so treat the rwp/ssrwp-nakagami values as an
aodv-leaning-or-tie, not a settled ordering).

### Old → new: what the 200 ms flip cost and bought, per cell

The [#411](https://github.com/danieljoppi/AntHocNet/pull/411) flip's
grid-wide price and benefit, AntHocNet only (the baselines did not move —
next section). Old = `4cdfb96` at 1 s, new = `a1daa7a` at 200 ms:

| mobility | channel | PDR (Δpp) | `delay99` (Δ%) | NRL Δ |
|---|---|---|---|---|
| rwp | tworay | 97.43 → 92.58 (−4.85) | 787.5 → 420.8 (−46.6 %) | −0.22 |
| ssrwp | tworay | 97.55 → 92.95 (−4.60) | 720.8 → 373.3 (−48.2 %) | +0.10 |
| gaussmarkov | tworay | 96.97 → 90.08 (−6.89) | 832.3 → 512.8 (−38.4 %) | +0.48 |
| rwp | nakagami | 92.03 → 89.78 (−2.25) | 1155.2 → 920.0 (−20.4 %) | −2.89 |
| ssrwp | nakagami | 92.08 → 89.54 (−2.54) | 1152.4 → 890.6 (−22.7 %) | −3.02 |
| gaussmarkov | nakagami | 89.33 → 85.87 (−3.46) | 1343.2 → 1022.9 (−23.8 %) | −4.66 |

The trade is clean and grid-wide: tail −20 % to −48 %, delivery −2.3 to
−6.9 pp, overhead flat-to-down (the fading cells shed 2.9–4.7 NRL). The
[#411 pre-merge A/B](https://github.com/danieljoppi/AntHocNet/pull/411)'s
−4.38 pp at paper-base/disk sits inside this envelope; the two-ray cells pay
more delivery than the fading cells, with the maximum at gaussmarkov-tworay
(−6.89 pp). This is the [#308
ablation](https://github.com/danieljoppi/AntHocNet/issues/308#issuecomment-5211529535)'s
mechanism at grid scale: the reconvergence hold converts would-be drops into
late deliveries, and the cap trades those deliveries back for the tail.

### The attribution control — 0/18 baseline rows moved

Every aodv/olsr/dsdv `pdr`/`delay99`/`nrl` value matches the `v1.4.0` grid
(`4cdfb96` corpus) **to the last printed digit** — deterministic baselines on
identical [#352](https://github.com/danieljoppi/AntHocNet/issues/352)-pinned
seeds, no harness drift between the corpora. Every AntHocNet delta above is
therefore attributable to the `ReconvHoldCap` flip alone. This is the same
control the [#308 ablation](https://github.com/danieljoppi/AntHocNet/issues/308#issuecomment-5211529535)
ran (byte-identical AODV blocks across cap arms), now confirmed across a
commit gap and all six cells.

## The oracle control — how much of the shortfall is routing?

This is the question the four-arm grid above cannot answer and the reason
[phase 3](v1.5.0-campaign.md#phase-3--the-oracle-control) exists. Every table
so far compares protocols *to each other*; none of them says how much of the
distance to **perfect** is protocol overhead and how much is the channel. The
oracle — global-knowledge Dijkstra over the ground-truth topology, replayed as
an `Ipv4RoutingProtocol`, emitting no control traffic whatsoever
([#415](https://github.com/danieljoppi/AntHocNet/issues/415); framing in
[methodology.md](methodology.md#upper-bound--the-oracle-control-415)) — is the
arm that makes the split measurable.

### Why the oracle columns compose with the tables above

The oracle cells are a **different dispatch at a different commit** (`40b434d`,
which adds `contrib/oracle`) from the four-arm tables (`a1daa7a`). Quoting a
column measured at one commit inside a table measured at another is exactly the
[provenance-rule](methodology.md#provenance-which-version-a-number-was-measured-at)
violation this repo re-baselines corpora to avoid — so the composition needs a
control, and it has one:

**480 `##RUN##` rows byte-identical.** Every per-seed row of all four original
arms — 6 cells × 4 protocols × 20 seeds — is byte-for-byte identical between
the phase-1 and phase-3 blocks, as are the `##BENCH##`, `# stddev`, `# paths`,
`# drops` and `# energy` lines. **AntHocNet included**: the subject under test
did not move by a single printed digit when the fifth arm was added. Adding the
oracle therefore perturbed nothing measurable — same seeds, same realisations,
same scheduler order for the arms that were already there — and the oracle
column is a measurement *of the same six cells*, not of a neighbouring
configuration. This is the same class of control as the
[0/18 attribution control](#the-attribution-control--018-baseline-rows-moved)
above, applied to an added arm rather than to a changed default, and it is the
reason the rest of this section is legitimate rather than merely convenient.

Two structural facts back it up: the oracle module is off unless `--protocols`
names it, and it evaluates **no propagation model at all**, so it takes no draw
from the channel's [#352](https://github.com/danieljoppi/AntHocNet/issues/352)-pinned
RNG stream and every other arm sees the identical fading realisation it saw in
phase 1.

### The oracle arm, per cell

Same layout as the tables above — PDR and mean delay with t 95 % CI
half-widths, `delay99` with a percentile-bootstrap interval, NRL, and the
`# paths` mean hop count. `n = 20` seeds.

| mobility | channel | PDR % | delay ms | `delay99` ms | NRL | hopsMean |
|---|---|---|---|---|---|---|
| rwp | tworay | **100.00 ± 0.00** | 5.16 ± 0.51 | 23.4 [22.9, 23.7] | 0.00 | 2.12 |
| ssrwp | tworay | **100.00 ± 0.00** | 4.88 ± 0.67 | 23.1 [22.7, 23.6] | 0.00 | 2.07 |
| gaussmarkov | tworay | **100.00 ± 0.00** | 6.53 ± 0.63 | 26.1 [25.8, 26.6] | 0.00 | 2.43 |
| rwp | nakagami | 99.54 ± 0.13 | 81.06 ± 3.27 | 2010.5 [2009.2, 2011.8] | 0.00 | 2.04 |
| ssrwp | nakagami | 99.55 ± 0.17 | 80.36 ± 2.69 | 2010.8 [2009.8, 2011.8] | 0.00 | 2.06 |
| gaussmarkov | nakagami | 99.41 ± 0.14 | 110.52 ± 2.59 | 2019.5 [2018.0, 2021.0] | 0.00 | 2.41 |

**PDR ≥ every arm in all six cells**, by margins of **+7.05 to +35.42 pp**
(smallest: anthocnet at ssrwp-tworay; largest: dsdv at gaussmarkov-nakagami).
**NRL is 0.00 in all six** — and not merely as a rounded mean: all 120 per-seed
oracle rows have `nrl` min = max = 0.00 and `nrl_bytes` max = 0.0000. That zero
is an *asserted invariant* (`NS_ABORT` in-harness plus a `scenario_check` rule),
not a measurement that happened to come out at zero.

**These columns are not all readable the same way.** PDR is a bound in all six
cells; `delay`/`delay99` are a bound only on the three two-ray cells; NRL is an
assertion rather than a measurement; and `hopsMean` is not a bound anywhere on
this page. The
[quoting rule](#how-these-numbers-may-be-quoted-a-delivery-bound-everywhere-a-latency-bound-only-on-two-ray)
below is where that is settled, with its evidence. Note already that `hopsMean` is
**higher than every real arm's** in every cell — the opposite of what a
shortest-path control is supposed to do, and the tell that the whole section
rests on an approximate adjacency graph.

### Gap decomposition — the headline

With an arm whose routing overhead is exactly zero, the shortfall to 100 %
splits without modelling assumptions:

```
channel = 100 − oracle_pdr        (what no routing protocol could have delivered)
routing = oracle_pdr − arm_pdr    (what this protocol lost that perfect routing did not)
total   = 100 − arm_pdr           = channel + routing
```

| mobility | channel | arm | total gap (pp) | channel (pp) | routing (pp) | **routing share** |
|---|---|---|---|---|---|---|
| rwp | tworay | anthocnet | 7.42 | 0.00 | 7.42 | **100.0 %** |
| rwp | tworay | aodv | 14.08 | 0.00 | 14.08 | **100.0 %** |
| ssrwp | tworay | anthocnet | 7.05 | 0.00 | 7.05 | **100.0 %** |
| ssrwp | tworay | aodv | 13.44 | 0.00 | 13.44 | **100.0 %** |
| gaussmarkov | tworay | anthocnet | 9.92 | 0.00 | 9.92 | **100.0 %** |
| gaussmarkov | tworay | aodv | 16.10 | 0.00 | 16.10 | **100.0 %** |
| rwp | nakagami | anthocnet | 10.22 | 0.46 | 9.76 | **95.5 %** |
| rwp | nakagami | aodv | 26.51 | 0.46 | 26.05 | **98.3 %** |
| ssrwp | nakagami | anthocnet | 10.46 | 0.45 | 10.01 | **95.7 %** |
| ssrwp | nakagami | aodv | 26.98 | 0.45 | 26.54 | **98.3 %** |
| gaussmarkov | nakagami | anthocnet | 14.13 | 0.59 | 13.54 | **95.8 %** |
| gaussmarkov | nakagami | aodv | 32.77 | 0.59 | 32.18 | **98.2 %** |

Each term is rounded independently from the full-precision per-seed means, so
one row's printed components differ from its printed total by 0.01 pp
(ssrwp-nakagami/aodv: 0.45 + 26.54 vs 26.98). The values are quoted as the
analysis emitted them rather than re-derived to make the row add up.

**On two-ray the channel costs nothing at all.** The oracle delivers 100.00 %
exactly, so *every* point of AntHocNet's 7.0–9.9 pp shortfall — and of AODV's
13.4–16.1 pp — is protocol overhead: discovery floods, reconvergence holds,
stale next hops, packets dropped waiting for a route. Under Nakagami the
channel finally costs something, and it costs **half a point**: 0.45–0.59 pp,
leaving **95.5–95.8 %** of AntHocNet's gap and **98.2–98.3 %** of AODV's on the
routing side.

The reading that matters is the one this grid could not previously support:
**the headroom above AntHocNet is almost entirely addressable in the protocol**.
A fading channel that intuition blames for a 10–14 pp delivery gap turns out to
account for under 0.6 pp of it. What the decomposition does *not* do is split
the routing term further — into discovery cost, suboptimal path choice and
reconvergence loss — so it bounds the addressable headroom rather than
itemising it.

Note the shape of the two columns: the channel term is a property of the
*cell*, identical for every arm in it, while the routing term is what
distinguishes the arms. AntHocNet's routing loss is **2.4× to 2.7× smaller than
AODV's** on the fading cells (9.76 vs 26.05; 10.01 vs 26.54; 13.54 vs 32.18),
which is the same ranking the paired
[ΔPDR table](#anthocnet-vs-aodv--paired-per-seed) reports, now expressed
against an absolute reference instead of against AODV.

### The caveat, stated with the numbers rather than under them

**All six cells are approximate.** Every oracle row on this page reads
`##ORACLE## … mode=disk-approx approx=1 range=300.0`. A two-ray or Nakagami
channel has no crisp adjacency — link viability is a continuous function of
distance, and under fading a random one — so the control cannot derive the
true graph and is held instead to the scenario's `--range`, a **300 m
geometric disk**. `scenario_check.py` says so once per seed: *"a fading or
two-ray channel has no crisp adjacency, so this arm is a reference point, not a
proven upper bound."* The exact (`approx=0`) rule exists only where the graph
*is* the wiring — see the [satellite ISL suite](satellite/isl-grid.md), which
publishes the `mode=wired approx=0` cell.

The approximation is not hypothetical, and phase 3 measured its size. The
instrument is the identity-matched `##COMMON##` set
([#308](https://github.com/danieljoppi/AntHocNet/issues/308)) — the exact
`(flow, seq)` packets **all five arms delivered** — so nothing below is
survivorship:

| mobility | channel | metric | anthocnet | aodv | **oracle** |
|---|---|---|---|---|---|
| rwp | tworay | hopsC | 1.56 | 1.47 | **1.90** |
| ssrwp | tworay | hopsC | 1.53 | 1.44 | **1.87** |
| gaussmarkov | tworay | hopsC | 1.60 | 1.48 | **2.13** |
| rwp | nakagami | hopsC | 1.56 | 1.25 | **1.73** |
| ssrwp | nakagami | hopsC | 1.58 | 1.26 | **1.75** |
| gaussmarkov | nakagami | hopsC | 1.62 | 1.26 | **2.00** |

**On every cell — two-ray included — the oracle uses more hops than every real
arm on identical packets.** A shortest-path control that routes *longer* than
its subjects is measuring a different graph than the one the radios have. That
is `approx=1` appearing directly in the data.

The latency consequence follows the same line, and inverts between channels
(same `##COMMON##` basis, anthocnet minus oracle):

| mobility | channel | meanC anthocnet | meanC oracle | Δ | p99C anthocnet | p99C oracle | Δ |
|---|---|---|---|---|---|---|---|
| rwp | tworay | 20.1 | 4.3 | **+15.7** | 308.2 | 21.9 | **+286.3** |
| ssrwp | tworay | 16.5 | 4.2 | **+12.3** | 273.1 | 21.8 | **+251.3** |
| gaussmarkov | tworay | 18.1 | 5.3 | **+12.8** | 298.0 | 23.9 | **+274.1** |
| rwp | nakagami | 41.2 | 53.2 | **−12.1** | 586.8 | 1469.1 | **−882.4** |
| ssrwp | nakagami | 39.5 | 53.3 | **−13.8** | 571.8 | 1487.5 | **−915.7** |
| gaussmarkov | nakagami | 45.6 | 76.0 | **−30.3** | 665.9 | 1893.4 | **−1227.5** |

Under fading the oracle is **12.1–30.3 ms slower in the mean and 882–1228 ms
worse at p99 than AntHocNet**, on identical packets. That is not AntHocNet
beating perfect routing.

**The mechanism** is one graph mismatch with two signs. A 300 m disk both

- **misses links the radios actually have** — two-ray reaches past 300 m in
  favourable geometry, so the control routes around edges that work, which is
  why its hop counts are the highest on the page; and
- **admits links the radios effectively do not have** — a nominally in-range
  neighbour can be in a deep Nakagami fade, and the control, which evaluates no
  propagation model, routes over it anyway. The packet is not lost; it is
  retried until it arrives *very late*. Under fading that turns into the
  1.47–1.89 s common-set p99 above — against AntHocNet's 0.57–0.67 s on the
  same packets.

Under two-ray only the first sign is active and it is cheap: the oracle still
wins latency by **5.0–8.6× in the mean and 16.1–25.2× at `delay99`** over the
whole population, a margin no plausible graph correction closes. Under Nakagami
the second sign dominates and the comparison reverses.

### How these numbers may be quoted: a delivery bound everywhere, a latency bound only on two-ray

**Quote the oracle as a delivery bound in all six cells, and as a latency bound
only on the two-ray cells.** This is the shipped rule, and it is what the
evidence above supports, no more:

- **Delivery — robust in all six cells.** The oracle delivers 99.41–100.00 %
  regardless of graph detail. A different-but-reasonable adjacency rule would
  move that by a fraction of a point and cannot move the 7.05–35.42 pp
  margins, so the [gap decomposition](#gap-decomposition--the-headline) and
  every PDR conclusion on this page stand.
- **Latency — two-ray only.** The 5–8× mean and 16–25× tail advantages hold
  there with the graph error working *against* the oracle (missing links only,
  so the true optimum is faster still — the bound is conservative). On the
  fading cells the direction of the error is not signed and the measured
  inversion is direct evidence of that, so **no latency bound may be quoted
  from the three Nakagami cells at all** — neither for nor against AntHocNet.
- **Hop count — not a bound anywhere on this page.** The
  [#419](https://github.com/danieljoppi/AntHocNet/pull/419) assertion is
  survivorship-guarded and therefore *vacuous* in all six cells (no arm ties
  the oracle's PDR, so the rule never fires); the guard is also the only reason
  it did not fire falsely — see
  [the campaign record](v1.5.0-campaign.md#phase-3--the-oracle-control).
- **`delay99` across arms is a separate trap**, and the oracle's pinned
  ~2.01 s fading tail is the clearest instance of it in the corpus. It is a
  general metric rule, not an oracle quirk — see
  [metrics.md](metrics.md#delay99-is-not-comparable-across-arms-with-materially-different-pdr-415).

## The ranking-stability statement

**Scoped, because one ranking is stable and another is not — and the
re-baseline moved the boundary.**

**Stable — delivery and overhead.** The delivery ordering is
`anthocnet > olsr > aodv > dsdv` in **all six** cells, with the first-vs-second
gap exceeding the summed per-arm CIs in every cell, and AntHocNet's paired
lead over AODV significant in every one. The overhead ordering
(`olsr < dsdv < anthocnet < aodv`) likewise holds in all six. Neither claim
depends on the mobility model or the channel. **But the magnitude changed:**
the paired AntHocNet−OLSR delivery lead narrowed from +4.25…+11.06 pp at 1 s
to **+1.70…+4.16 pp** at 200 ms (all still significant, max p = 9.5 × 10⁻⁴;
tightest cell ssrwp-tworay at +1.70 pp against a summed per-arm CI of 1.25).
The stability statement survives the flip; a claim quoting its old size does
not.

**Not stable — the tail.** At 1 s this section reported a clean inversion:
OLSR → dsdv → aodv → anthocnet under two-ray, aodv → anthocnet → dsdv → olsr
under fading. At 200 ms **the invariant part is OLSR**: best tail under
two-ray (22–69 ms, a factor of ~25 ahead) and **worst** under fading
(2685–2961 ms). Its jitter moves the same way (9.6–12.6 ms → 164–189 ms), so
the two are one effect rather than two. AntHocNet's position, by channel:

| channel | `delay99` at 200 ms |
|---|---|
| two-ray | **olsr** (22–69 ms) → **anthocnet 2nd** (ssrwp, gaussmarkov; tied with dsdv in rwp) → dsdv → aodv. The 1 s "…anthocnet last" ordering is obsolete. |
| Nakagami | **aodv-or-tie first**: aodv nominally ahead in rwp/ssrwp (paired +81/+73 ms, p = 0.012/0.033 — marginal), anthocnet nominally first in gaussmarkov (paired p = 0.7 — a tie) → dsdv → **olsr worst**. The 1 s "aodv wins the fading tail" claim degrades to aodv-or-tie. |

**Consequence: a tail claim that does not name its channel is unsupported.**
That survives the re-baseline unchanged — OLSR's factor-of-~25 inversion
carries it on its own. What the re-baseline retired is the claim that
AntHocNet's tail is *last* anywhere: at 200 ms the
[#21](https://github.com/danieljoppi/AntHocNet/issues/21) deficit against
AODV persists only as a marginal edge in two fading cells, and under two-ray
AntHocNet's tail now beats AODV's outright.

**Mobility is the weaker axis.** Across the three mobility models at fixed
channel, the paired ΔPDR (vs AODV) moves by ≤ 2.4 pp and no ordering changes
anywhere. Steady-state RWP lands essentially on classic RWP (+0.37 pp two-ray
/ −0.24 pp Nakagami, p = 0.68 / 0.72 — not significant), which is a useful
negative: at this scenario the speed-decay transient the steady-state model
exists to remove is not what drives the result.

## Provenance

`main` @ `a1daa7a` (the [#411](https://github.com/danieljoppi/AntHocNet/pull/411)
merge commit), image `ghcr.io/danieljoppi/ns3:3.42-opt`, `runs=20`,
`time=900`, `areaX=1500`, `speed=20`, `protocols=anthocnet,aodv,olsr,dsdv`,
`ReconvHoldCap=200 ms` (the shipped default — no `extraArgs` override).

| mobility | channel | pause | run ID |
|---|---|---|---|
| rwp | tworay | 30 | [`31618105814`](https://github.com/danieljoppi/AntHocNet/actions/runs/31618105814) |
| ssrwp | tworay | 30 | [`31618110426`](https://github.com/danieljoppi/AntHocNet/actions/runs/31618110426) |
| gaussmarkov | tworay | 0 | [`31618116286`](https://github.com/danieljoppi/AntHocNet/actions/runs/31618116286) |
| rwp | nakagami | 30 | [`31618108070`](https://github.com/danieljoppi/AntHocNet/actions/runs/31618108070) |
| ssrwp | nakagami | 30 | [`31618114426`](https://github.com/danieljoppi/AntHocNet/actions/runs/31618114426) |
| gaussmarkov | nakagami | 0 | [`31618118283`](https://github.com/danieljoppi/AntHocNet/actions/runs/31618118283) |

**The oracle arm** ([phase 3](v1.5.0-campaign.md#phase-3--the-oracle-control))
was measured on `main` @ `40b434d` — the
[#419](https://github.com/danieljoppi/AntHocNet/pull/419) merge commit that adds
`contrib/oracle` — with the same image, `runs=20`, `time=900`, `areaX=1500`,
`speed=20`, `gaussmarkov` at `pause=0`, and `protocols=anthocnet,aodv,olsr,dsdv,oracle`:

| mobility | channel | run ID |
|---|---|---|
| rwp | tworay | [`31807666381`](https://github.com/danieljoppi/AntHocNet/actions/runs/31807666381) |
| ssrwp | tworay | [`31807668353`](https://github.com/danieljoppi/AntHocNet/actions/runs/31807668353) |
| gaussmarkov | tworay | [`31807670848`](https://github.com/danieljoppi/AntHocNet/actions/runs/31807670848) |
| rwp | nakagami | [`31807672820`](https://github.com/danieljoppi/AntHocNet/actions/runs/31807672820) |
| ssrwp | nakagami | [`31807676290`](https://github.com/danieljoppi/AntHocNet/actions/runs/31807676290) |
| gaussmarkov | nakagami | [`31807678924`](https://github.com/danieljoppi/AntHocNet/actions/runs/31807678924) |

All six `scenario_check.py results` runs exit 0 with **zero FAILs**, 25 checks
per cell, and the oracle's positional `##RUN##` column mapping was validated
against the harness's own `# stddev oracle` line. The four baseline arms in
these six blocks are byte-identical to the six phase-1 blocks above, which is
what licenses reading the two dispatches as one table — see
[Why the oracle columns compose](#why-the-oracle-columns-compose-with-the-tables-above).
Full readout, including the assertion record and the anomalies:
[#415 (comment)](https://github.com/danieljoppi/AntHocNet/issues/415#issuecomment-5297098438).

Every cell self-identifies through its `##CONFIG##` row
([#369](https://github.com/danieljoppi/AntHocNet/issues/369)) — cell identity
is read from the data, not from dispatch order — and its `##PROV##` line pins
`commit=a1daa7a` ([#365](https://github.com/danieljoppi/AntHocNet/issues/365)).
`bench_parse` column-mapping self-checks passed (20 checks) on all six cells.
`scenario_check.py results` found nothing outside the known classes: the
standing 3-per-cell [#230](https://github.com/danieljoppi/AntHocNet/issues/230)
path-diversity instrumentation FAILs (aodv/olsr/dsdv, non-blocking), scattered
[#386](https://github.com/danieljoppi/AntHocNet/issues/386) ICMP-re-injection
WARNs (one seed each in four cells), and end-of-run-queue drop-cause
overshoots ≤ +2.26 pp (WARN class). No anchor, energy, reordering-bounds, or
route-quality failures.

## What is deliberately not published here

Two metric families are omitted from every table above, because they are known
to be unreadable in these cells. The columns are left **empty** rather than
filled with wrong values — the same rule `##HOLD##`/`##AIR##` follow.

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
