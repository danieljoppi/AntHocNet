# Grid: mobility × channel

**Varies:** mobility model (`rwp`, `ssrwp`, `gaussmarkov`) × channel model
(`tworay`, `nakagami`) — six cells at the paper base scenario.

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md)

> **Provenance — measured at `dd171e5e`, the [#496](https://github.com/danieljoppi/AntHocNet/issues/496) timer
> fix in place (`TimerJitter = 0.05`, `ReconvHoldCap = 200 ms`).** This is the
> **#496 re-baseline**. [PR #497](https://github.com/danieljoppi/AntHocNet/pull/497) (`43dd2f96`) desynchronised the
> ns-3 adapter's hello and proactive timers. Before it, every node beaconed at
> the same instant every second, hidden terminals collided on those broadcasts,
> and two consecutive lost hellos evicted a live neighbour. That is a
> protocol-behaviour change, so it superseded the previous version of this page
> under the
> [provenance rule](methodology.md#provenance-which-version-a-number-was-measured-at).
> All six cells were re-measured on `main` at `dd171e5e`, which carries the
> #496 code plus documentation commits only. **The oracle now runs in the same
> dispatch** as the four protocols, so every column on this page comes from one
> run per cell.
>
> **The attribution control is the oracle, not the baselines.** The per-seed
> logs of the last pre-#496 grid (the [#431](https://github.com/danieljoppi/AntHocNet/issues/431#issuecomment-5339246820)
> re-measure at `4611bbb`) have expired, so a byte-level baseline comparison is
> no longer possible. What survives is #431's per-cell table. The oracle, which
> runs no AntHocNet code, reproduces it in **6 / 6 cells** (to the printed
> digit in five, 0.01 pp in the sixth). So no harness, seed or channel change
> separates the two corpora, and AntHocNet's movement is attributable to #496
> alone. See
> [the attribution control](#the-attribution-control-the-oracle-reproduces-431-in-66-cells).
>
> The two previous versions stay in git history and remain valid as evidence
> of their own operating points:
>
> - `a1daa7a` (v1.5.0 phase 1, 200 ms cap, unjittered timer):
>   `git show 0caa508d:docs/benchmarks/grid.md`;
> - `4cdfb96` (1 s cap): `git show v1.4.0:docs/benchmarks/grid.md`.
>
> The per-seed cells are committed as `cells/grid-<mobility>-<channel>.txt`.

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
sweep, this page has **no generated block**: the tables below are
hand-written, as on the [satellite suite](satellite/isl-grid.md) page. The
per-seed data behind them is committed next to this page as
`cells/grid-<mobility>-<channel>.txt` (`##RUN##`, `##BENCH##`, `##CONFIG##`,
`##PROV##`, `##ORACLE##`, `##COMMON##`, `##MATCH##`, `# drops`, `# stddev`).
Each cell's `##PROV##` line pins `commit=dd171e5e`, and its `##CONFIG##` pins
`TimerJitter=0.05` and `ReconvHoldCap=+2e+08ns`, so every block is
self-describing. The committed
`../benchmarks/campaign/pooled-grid-mobility-channel-20260808.csv` and its
per-run sibling remain the **1 s corpus**, superseded twice over.

## Results

The oracle column is a reference point rather than a competitor; how far each
of its columns may be read as a bound is settled in
[the quoting rule](#how-these-numbers-may-be-quoted-a-delivery-bound-everywhere-latency-and-hops-on-two-ray).

### Delivery — PDR %, mean ± 95 % CI

| mobility | channel | anthocnet | aodv | olsr | dsdv | oracle |
|---|---|---|---|---|---|---|
| rwp | tworay | 97.78 ± 0.22 | 85.48 ± 0.70 | 90.62 ± 0.44 | 84.64 ± 0.82 | 98.08 ± 0.16 |
| ssrwp | tworay | 97.97 ± 0.23 | 86.23 ± 0.41 | 91.34 ± 0.53 | 85.62 ± 0.84 | 98.20 ± 0.22 |
| gaussmarkov | tworay | 95.59 ± 0.34 | 84.17 ± 0.88 | 86.00 ± 0.83 | 78.64 ± 1.16 | 96.69 ± 0.31 |
| rwp | nakagami | 91.50 ± 0.90 | 73.57 ± 0.91 | 87.74 ± 0.57 | 72.57 ± 1.24 | 96.92 ± 0.39 |
| ssrwp | nakagami | 91.10 ± 0.86 | 72.69 ± 1.27 | 87.36 ± 0.48 | 71.92 ± 1.26 | 96.53 ± 0.59 |
| gaussmarkov | nakagami | 88.11 ± 0.71 | 66.65 ± 1.16 | 83.55 ± 0.69 | 63.89 ± 1.13 | 95.99 ± 0.35 |

### Overhead — NRL, mean ± 95 % CI

| mobility | channel | anthocnet | aodv | olsr | dsdv | oracle |
|---|---|---|---|---|---|---|
| rwp | tworay | 13.46 ± 0.25 | 66.22 ± 1.11 | 4.03 ± 0.03 | 23.17 ± 0.21 | 0.00 ± 0.00 |
| ssrwp | tworay | 12.97 ± 0.30 | 65.26 ± 0.94 | 3.97 ± 0.04 | 22.82 ± 0.25 | 0.00 ± 0.00 |
| gaussmarkov | tworay | 16.69 ± 0.47 | 64.41 ± 1.74 | 4.36 ± 0.06 | 25.09 ± 0.40 | 0.00 ± 0.00 |
| rwp | nakagami | 24.86 ± 0.58 | 78.10 ± 1.83 | 4.35 ± 0.06 | 27.57 ± 0.57 | 0.00 ± 0.00 |
| ssrwp | nakagami | 25.16 ± 0.84 | 79.13 ± 2.38 | 4.35 ± 0.05 | 27.76 ± 0.63 | 0.00 ± 0.00 |
| gaussmarkov | nakagami | 30.78 ± 0.70 | 87.69 ± 2.40 | 4.76 ± 0.06 | 31.73 ± 0.59 | 0.00 ± 0.00 |

### Tail — `delay99` ms, mean with bootstrap 95 % interval

| mobility | channel | anthocnet | aodv | olsr | dsdv | oracle |
|---|---|---|---|---|---|---|
| rwp | tworay | 203.7 [197.1, 210.7] | 605.5 [579.7, 631.0] | 24.4 [22.8, 26.9] | 618.4 [496.6, 748.8] | 19.8 [19.5, 20.1] |
| ssrwp | tworay | 195.3 [187.2, 204.2] | 593.5 [570.5, 617.5] | 22.9 [22.4, 23.7] | 561.5 [453.5, 685.6] | 19.4 [19.1, 19.8] |
| gaussmarkov | tworay | 302.5 [281.6, 324.0] | 578.9 [552.5, 607.2] | 58.2 [24.0, 125.2] | 618.8 [496.2, 747.5] | 21.4 [21.0, 21.7] |
| rwp | nakagami | 369.4 [335.0, 410.1] | 849.2 [814.0, 888.8] | 2442.9 [2255.6, 2634.9] | 2032.5 [2027.3, 2038.2] | 2170.6 [2073.3, 2297.8] |
| ssrwp | nakagami | 386.2 [345.3, 432.0] | 842.7 [802.5, 883.4] | 2646.7 [2464.3, 2820.8] | 2085.3 [2032.8, 2184.9] | 2236.2 [2090.2, 2416.4] |
| gaussmarkov | nakagami | 596.9 [539.0, 661.9] | 1059.5 [1014.6, 1111.5] | 2974.5 [2902.1, 3011.8] | 2384.8 [2215.6, 2562.4] | 3009.6 [3008.3, 3010.8] |

A `t`-interval on a per-run p99 is not defensible, so the tail uses a
percentile bootstrap ([policy](methodology.md#ci-method-per-metric)). The
oracle's fading-cell tail is **not** a bound and must not be read against the
other arms; see
[metrics.md](metrics.md#delay99-is-not-comparable-across-arms-with-materially-different-pdr-415).

### AntHocNet vs AODV — paired, per seed

Both protocols run on identical realisations *inside* a cell, so this is a
paired difference (t-CI for PDR/NRL, bootstrap for `delay99`, two-sided
Wilcoxon). This is the test of record; the per-arm intervals above are for
orientation.

| mobility | channel | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) |
|---|---|---|---|---|
| rwp | tworay | **+12.30 [+11.62, +12.98]** | **-52.76 [-53.89, -51.63]** | **-401.90 [-425.15, -377.55]** |
| ssrwp | tworay | **+11.74 [+11.33, +12.15]** | **-52.28 [-53.33, -51.24]** | **-398.15 [-421.15, -377.30]** |
| gaussmarkov | tworay | **+11.42 [+10.63, +12.21]** | **-47.71 [-49.19, -46.23]** | **-276.35 [-307.00, -245.75]** |
| rwp | nakagami | **+17.93 [+16.72, +19.13]** | **-53.24 [-54.95, -51.54]** | **-479.75 [-527.30, -430.30]** |
| ssrwp | nakagami | **+18.41 [+17.57, +19.25]** | **-53.97 [-55.93, -52.01]** | **-456.50 [-494.05, -420.65]** |
| gaussmarkov | nakagami | **+21.46 [+20.13, +22.80]** | **-56.91 [-59.37, -54.46]** | **-462.60 [-527.90, -404.30]** |

**AntHocNet beats AODV on all three metrics in all six cells**, every
interval excluding zero, every p ≤ 9.6 × 10⁻⁵ (18 comparisons; at α = 0.05
that is ~0.9 expected false positives, and the largest p here is about 500×
below α). That is new: before #496 the tail was the marginal column. AODV
held a paired edge of +81 / +73 ms (p = 0.012 / 0.033) in the rwp and ssrwp
fading cells, and gaussmarkov-nakagami was a tie (p = 0.7). Those edges now
read **−480 / −457 / −463 ms**.

### Old → new: what the #496 timer fix bought, per cell

AntHocNet only.

- **Pre-#496 PDR** is #431's per-cell table at `4611bbb`: the last grid before
  the fix, on the same harness, oracle and seeds.
- **Pre-#496 NRL and `delay99`** come from the previous version of this page at
  `a1daa7a`, because #431 did not republish them. `a1daa7a` predates the
  [#459](https://github.com/danieljoppi/AntHocNet/pull/459) flow-start fix,
  which moved AntHocNet's PDR by 0.1–0.5 pp (`a1daa7a` → `4611bbb` column).
  So the NRL and `delay99` deltas are #496 plus a small #459 share.

| mobility | channel | PDR `a1daa7a` | PDR `4611bbb` → now (Δpp) | NRL `a1daa7a` → now | `delay99` `a1daa7a` → now |
|---|---|---|---|---|---|
| rwp | tworay | 92.58 | 92.11 → 97.78 (**+5.67**) | 34.92 → 13.46 | 420.8 → 203.7 (−52 %) |
| ssrwp | tworay | 92.95 | 92.42 → 97.97 (**+5.55**) | 34.37 → 12.97 | 373.3 → 195.3 (−48 %) |
| gaussmarkov | tworay | 90.08 | 89.83 → 95.59 (**+5.76**) | 36.65 → 16.69 | 512.8 → 302.5 (−41 %) |
| rwp | nakagami | 89.78 | 89.64 → 91.50 (**+1.86**) | 46.89 → 24.86 | 920.0 → 369.4 (−60 %) |
| ssrwp | nakagami | 89.54 | 89.48 → 91.10 (**+1.62**) | 46.88 → 25.16 | 890.6 → 386.2 (−57 %) |
| gaussmarkov | nakagami | 85.87 | 85.58 → 88.11 (**+2.53**) | 52.44 → 30.78 | 1022.9 → 596.9 (−42 %) |

**The fix bought on every axis at once.** The 200 ms `ReconvHoldCap` flip
traded delivery for tail; #496 removes the spurious link breaks the hold was
covering for, so it does not trade at all:

- delivery rises +1.6 to +5.8 pp;
- overhead falls by roughly half (−20 to −22 NRL);
- the tail falls 41–60 %.

**Two-ray gains the most delivery:** AntHocNet now sits 0.23–1.09 pp below the
oracle there. **Fading gains the most tail.** Under Nakagami the channel
itself still costs 3–4 pp (oracle 96.0–96.9 %), and AntHocNet's remaining gap
to the oracle is 5.4–7.9 pp.

### The attribution control: the oracle reproduces #431 in 6/6 cells

The pre-#496 per-seed logs (#431's runs `32209168271` … `32209193038`) have
expired (HTTP 410) and left no artifacts, so the byte-identical baseline
comparison this page used to carry cannot be repeated. The control that
remains:

| cell | oracle PDR, #431 at `4611bbb` | oracle PDR, now |
|---|---|---|
| rwp / tworay | 98.08 | 98.08 |
| ssrwp / tworay | 98.20 | 98.20 |
| gaussmarkov / tworay | 96.69 | 96.69 |
| rwp / nakagami | 96.92 | 96.92 |
| ssrwp / nakagami | 96.53 | 96.53 |
| gaussmarkov / nakagami | 96.00 | 95.99 |

The last row differs by 0.01 pp (95.99 here against #431's 96.00); every other
row matches to the printed digit.

**Why this control works.** The oracle runs no AntHocNet code and evaluates
no propagation model. Its delivery depends only on:

- the mobility and fading realisations;
- the flow schedule;
- the PHY-derived radius.

Reproducing #431 in every cell therefore shows that none of those moved
between `4611bbb` and `dd171e5e`. The only routing-relevant code change in
that range is #497. This is weaker than a per-seed byte match: it is
aggregate-level, and it does not cover the three baselines directly. It is,
however, essentially exact on the one arm that cannot be influenced by
AntHocNet.

**Do not compare these baselines with the `a1daa7a` version of this page.**
The [#459](https://github.com/danieljoppi/AntHocNet/pull/459) flow-start fix
landed between the two and moved every arm by a few tenths of a point. For
example, aodv rwp-tworay reads 85.92 there and 85.48 here.

**The hop-bound FAILs are the known #431 class.** `scenario_check results`
FAILs only on the three Nakagami cells, all on the known #431 fading residual
(oracle identity-matched hops above dsdv's on the `##COMMON##` set), on 8, 15
and 17 of 20 seeds. #431 recorded 6, 13 and 15. The common set is the packets
*every* arm delivered, AntHocNet included, so a changed AntHocNet changes that
set; the residual itself is the oracle's median-radius approximation and is
unchanged in kind. The two-ray cells are WARN-only (the approximate-oracle
notes).

## The oracle control — how much of the shortfall is routing?

This is the question the four-arm grid above cannot answer and the reason
[phase 3](v1.5.0-campaign.md#phase-3-the-oracle-control) exists. Every table
so far compares protocols *to each other*; none of them says how much of the
distance to **perfect** is protocol overhead and how much is the channel. The
oracle — global-knowledge Dijkstra over the ground-truth topology, replayed as
an `Ipv4RoutingProtocol`, emitting no control traffic whatsoever
([#415](https://github.com/danieljoppi/AntHocNet/issues/415); framing in
[methodology.md](methodology.md#upper-bound-the-oracle-control-415)) — is the
arm that makes the split measurable.

> **Read this section as the v1.5.0 phase-3 record, measured before #496.**
> The analysis below (the composition argument, the per-cell oracle table, the
> gap decomposition and the caveat) was measured at `40b434d` / `4611bbb`. In
> that version the oracle was a separate dispatch beside the `a1daa7a`
> four-arm grid, and AntHocNet still had the unjittered timer. Its oracle-side
> findings still stand, because the oracle's own numbers are reproduced
> exactly above. Its AntHocNet-side figures do not: AntHocNet's routing gap to
> the oracle is now
>
> - **0.23–1.09 pp** on two-ray (it was 5.8–6.9 pp at `4611bbb`);
> - **5.4–7.9 pp** under Nakagami (it was 7.1–10.4 pp).
>
> The current oracle column is in the [Results](#results) tables, measured in
> the same dispatch as every other arm.

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
0/18 attribution control of the pre-#496 version of this page, applied to an added arm rather than to a changed default, and it is the
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
[quoting rule](#how-these-numbers-may-be-quoted-a-delivery-bound-everywhere-latency-and-hops-on-two-ray)
below is where that is settled, with its evidence. Note already that `hopsMean`
is **higher than every real arm's** in every cell, and that this is *not* the
defect it was once read as. `hopsMean` averages over each arm's **own** delivered
set, and the oracle delivers 6–33 pp more packets than the arms it bounds — the
extra ones being precisely the long-path, hard-to-route packets the others drop.
A shortest-path control that delivers the hard packets *should* read longer here.
The survivorship-free instrument is the identity-matched `##COMMON##` set below,
and on it the ordering reverses: the oracle is **below** every arm on two-ray
and below the reactive arms under fading. An earlier version of this page read
the `hopsMean` ordering as evidence that the adjacency graph was wrong; on the
matched set that reading does not hold, and the real approximation error is
measured in [the caveat section](#the-caveat-stated-with-the-numbers-rather-than-under-them).

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

> **This decomposition is pending a re-derivation, and the direction of the
> change is known.** The table above uses the v1.5.0 oracle, whose adjacency was
> the scenario's `--range` — a 300 m geometric disk. [#457](https://github.com/danieljoppi/AntHocNet/pull/457)
> replaced that with a radius derived from the installed PHY (423.3 m on
> two-ray, 373.4 m on Nakagami), and a wider graph routes over marginal links,
> so the oracle's own delivery falls. Re-measured at 20 seeds on the fixed
> harness, oracle PDR is **96.00–98.20 %** rather than 99.41–100.00 %, which
> moves the channel term to **1.80–4.00 pp** and the routing share to
> **67.0–88.4 %** (AntHocNet 67.0–76.2 %, AODV 79.1–88.4 %). The qualitative
> reading is unchanged — routing dominates the gap in every cell — but "the
> channel costs nothing at all on two-ray" and "under 0.6 pp" are specific to
> the 300 m disk and must not be quoted against the current oracle.
>
> The table is **not** silently restated here because which oracle belongs in
> this decomposition is a real analytical choice, not a transcription: the 300 m
> disk is the more conservative *delivery* reference (its links are solidly
> in range, so `100 − oracle_pdr` is a tighter floor on what no router could
> deliver), while the derived radius is the better *adjacency* model and is what
> makes the hop bound hold. Picking one for this table is tracked on
> [#460](https://github.com/danieljoppi/AntHocNet/issues/460) with the measured
> numbers for both.
>
> **A second, independent reason the same figures are overstated
> ([#464](https://github.com/danieljoppi/AntHocNet/issues/464)).** When the
> oracle's graph holds no path it refuses the send outright — `RouteOutput`
> returns `nullptr`, so the packet never reaches `Ipv4L3Protocol::Send` and
> FlowMonitor never counts it as transmitted. Until #464 those refusals were
> absent from the PDR denominator *and* from the drop book, so `oracle_pdr`
> was computed over the packets the control had a route for rather than over
> offered traffic — biasing it **upward** and the channel term downward, which
> is the same direction as the radius question above. The published v1.5.0
> grid ran under the 300 m disk and did carry refusals, so "the oracle
> delivers 100.00 % exactly" is optimistic on that account too. The effect is
> small — 3 of the 120 re-measured seeds carry any refusals at all (2, 2 and
> 30 lookups, all on fading cells), so under the derived radii it is worth
> hundredths of a point — but it is systematic rather than noise, and it must
> be corrected before the decomposition is re-derived rather than after.

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
[ΔPDR table](#anthocnet-vs-aodv-paired-per-seed) reports, now expressed
against an absolute reference instead of against AODV.

### The caveat, stated with the numbers rather than under them

**All six cells are approximate.** Every oracle row on this page is flagged
`approx=1`. A two-ray or Nakagami channel has no crisp adjacency — link
viability is a continuous function of distance, and under fading a random one —
so the control cannot derive the true graph. Since
[#457](https://github.com/danieljoppi/AntHocNet/pull/457) it is held to a
radius derived from the installed PHY rather than to the scenario's `--range`:
`mode=decode-approx` at **423.3 m** on two-ray (where the two-ray power crosses
the decode floor) and `mode=p50-approx` at **373.4 m** on Nakagami (the
closed-form Gamma law's P = ½ crossing at that same floor).
`scenario_check.py` says so once per seed: *"a fading or two-ray channel has no
crisp adjacency, so this arm is a reference point, not a proven upper bound."*
The exact (`approx=0`) rule exists only where the graph *is* the wiring — see
the [satellite ISL suite](satellite/isl-grid.md), which publishes the
`mode=wired approx=0` cell.

> **These numbers supersede the phase-3 matched-hop and matched-latency tables,
> which were measured on a broken instrument.** Phase 3 reported that the
> oracle used more hops than every real arm in all six cells (e.g. `rwp-tworay`
> oracle 1.90 against anthocnet 1.56) and that under fading it was 12–30 ms
> slower in the mean than AntHocNet. Both readings were artifacts. The harness
> drew flow start times from a cumulative RNG stream counter that the routing
> helpers had already advanced by a *protocol-dependent* amount, so every arm
> started every flow at a different instant and `##COMMON##`'s `(flow, seq)`
> keys named packets **sent at different times in each arm** — the identity
> match was by index, not by transmission
> ([#459](https://github.com/danieljoppi/AntHocNet/pull/459)). On the `paper`
> scenario's 180 s start window the expected separation between two arms' copies
> of the same key is `startWindow / 3` ≈ 60 s, which at 20 m/s is a different
> topology entirely. The tables below are the same six cells re-measured on the
> fixed harness at 20 seeds; the superseded values are kept in
> [#431](https://github.com/danieljoppi/AntHocNet/issues/431#issuecomment-5339246820)
> and the blast radius across the corpus in
> [#460](https://github.com/danieljoppi/AntHocNet/issues/460). Per the
> [#352](https://github.com/danieljoppi/AntHocNet/issues/352) rule, do not run
> `sweep_summary --vs` across that commit.

The approximation is not hypothetical, and it has now been measured twice — the
second time with an instrument that works. The instrument is the
identity-matched `##COMMON##` set
([#308](https://github.com/danieljoppi/AntHocNet/issues/308)) — the exact
`(flow, seq)` packets **all five arms delivered**, now genuinely the same
transmissions — so nothing below is survivorship:

| mobility | channel | anthocnet | aodv | olsr | dsdv | **oracle** | hop bound |
|---|---|---|---|---|---|---|---|
| rwp | tworay | 1.545 | 1.460 | 1.325 | 1.335 | **1.300** | **holds 20/20** |
| ssrwp | tworay | 1.516 | 1.441 | 1.309 | 1.317 | **1.285** | **holds 20/20** |
| gaussmarkov | tworay | 1.586 | 1.476 | 1.355 | 1.364 | **1.322** | **holds 20/20** |
| rwp | nakagami | 1.560 | 1.248 | 1.203 | 1.083 | **1.231** | fails vs olsr, dsdv |
| ssrwp | nakagami | 1.578 | 1.258 | 1.209 | 1.084 | **1.238** | fails vs olsr, dsdv |
| gaussmarkov | nakagami | 1.633 | 1.268 | 1.233 | 1.104 | **1.271** | fails vs olsr, dsdv |

**On the three two-ray cells the oracle is below every real arm in every one of
the 20 seeds.** That is the hop bound holding, un-suppressed, for the first time
on a wifi channel — and it is the acceptance bar #431 set for a replacement
adjacency rule.

**On the three fading cells it is not.** The failure is narrow, one-directional
and identical across all three: the oracle is above olsr by +0.028…+0.038 and
above dsdv by +0.149…+0.167 in **20 of 20 seeds**, while beating anthocnet 0/20
and aodv in all but the gaussmarkov cell. Because `common` is the intersection
over *all* arms, dsdv is routing **the same packets** in fewer hops than the
shortest-path control believes possible — which is only possible if the graph
is missing links the radios genuinely have. A **median** radius does exactly
that: every link Nakagami delivers on beyond 373.4 m is invisible to the solver,
and the arms with full topology knowledge are the ones that exploit them. That
is `approx=1` appearing directly in the data, at its measured size.

The latency comparison, on the same `##COMMON##` basis (anthocnet minus oracle):

| mobility | channel | meanC anthocnet | meanC oracle | Δ | p99C anthocnet | p99C oracle | Δ |
|---|---|---|---|---|---|---|---|
| rwp | tworay | 18.4 | 1.9 | **+16.5** | 302.2 | 14.6 | **+287.6** |
| ssrwp | tworay | 18.2 | 1.9 | **+16.3** | 289.1 | 14.4 | **+274.7** |
| gaussmarkov | tworay | 16.9 | 2.1 | **+14.8** | 280.1 | 15.3 | **+264.8** |
| rwp | nakagami | 39.3 | 30.9 | **+8.4** | 563.9 | 1015.9 | **−452.0** |
| ssrwp | nakagami | 40.6 | 32.4 | **+8.2** | 571.0 | 1024.1 | **−453.1** |
| gaussmarkov | nakagami | 43.4 | 40.4 | **+3.0** | 626.5 | 1272.2 | **−645.6** |

**The oracle is now faster in the mean in all six cells**, fading included — the
phase-3 mean inversion was the instrument. What survives is the **tail**
inversion under fading: the oracle's common-set p99 is 1.02–1.27 s against
AntHocNet's 0.56–0.63 s on identical packets. It is real, and at roughly half
the size phase 3 reported.

**The mechanism** is one graph mismatch with two signs, and the two signs now
separate cleanly by channel.

- **Missing links.** The derived radius is a threshold on a continuous law, so
  links beyond it that nonetheless deliver are invisible to the solver and the
  control routes around edges that work. This is the *only* sign active on
  two-ray, and there it is small enough that the bound still holds in 20/20
  seeds. Under fading, with a median radius, it is what produces the olsr/dsdv
  hop residual above.
- **Admitted links that are effectively absent.** A nominally in-range neighbour
  can be in a deep Nakagami fade, and the control, which evaluates no
  propagation model, routes over it anyway. The packet is not lost; it is
  retried until it arrives *very late*. That lands in the tail and not in the
  mean, which is exactly the shape of the surviving p99 inversion.

Under two-ray only the first sign is active and it is cheap: the oracle wins
latency by an order of magnitude in the mean and ~19× at the common-set tail, a
margin no plausible graph correction closes.

**The two acceptance constraints pull in opposite directions**, which is the
sharpest statement this page can make about the limit. Shrink the radius and the
oracle's hop count rises above its subjects — today's fading failure. Grow it and
the oracle's PDR falls *below* them: the refuted link-budget rule recorded in
[`ns3/oracle/README.md`](../../ns3/oracle/README.md) made 2440 of 2450 edges
adjacent and delivered 30.4 % PDR, a control its own subjects beat. Two-ray has a
radius in the feasible band between those failures. Whether a fading channel has
one at all is open, and if it does not, the answer is a probability-weighted
(ETX-shaped) graph or an accepted-and-scoped limit — not further radius tuning.

### How these numbers may be quoted: a delivery bound everywhere, latency and hops on two-ray

- **Delivery — robust in all six cells.** Re-verified on the fixed harness:
  oracle PDR 96.00–98.20 % against the best real arm's 85.58–92.42 % at
  `4611bbb`, with **zero violations in 120/120 seeds**. After #496 the best real
  arm (AntHocNet) reads 88.11–97.97 %, still below the oracle in every cell
  (by 0.23 pp at the tightest, ssrwp-tworay). A different-but-reasonable adjacency rule moves
  that by a fraction of a point and cannot move the margins, so the
  [gap decomposition](#gap-decomposition-the-headline) and every PDR conclusion
  on this page stand.
- **Latency — two-ray only.** The mean and tail advantages hold there with the
  graph error working *against* the oracle (missing links only, so the true
  optimum is faster still — the bound is conservative). On the fading cells the
  error is not signed and the surviving p99 inversion is direct evidence of
  that, so **no latency bound may be quoted from the three Nakagami cells** —
  neither for nor against AntHocNet. The mean figures there are reportable as a
  measurement but are not a bound.
- **Hop count — a bound on the two-ray cells, and not on the fading cells.**
  This is the change #457 and #459 bought: the assertion fires and passes at 20
  seeds on all three two-ray cells. On the fading cells it fires and fails, and
  the failure is the measured size of the median-radius approximation rather
  than a defect in any arm — quote it as that, not as "dsdv beats optimal
  routing".
- **`delay99` across arms is a separate trap**, and the oracle's fading tail is
  the clearest instance of it in the corpus. It is a general metric rule, not an
  oracle quirk — see
  [metrics.md](metrics.md#delay99-is-not-comparable-across-arms-with-materially-different-pdr-415).

## The ranking-stability statement

**Scoped, because the tail ranking depends on the channel.**

**Stable — delivery.** The delivery ordering is
`anthocnet > olsr > aodv > dsdv` in **all six** cells. The AntHocNet−OLSR
gap exceeds the summed per-arm CIs in every cell, and AntHocNet's paired lead
over both rivals is significant in every one (p ≤ 9.6 × 10⁻⁵). **The size of
the lead over OLSR grew with #496:**

- two-ray: **+6.62 … +9.59 pp**;
- Nakagami: **+3.74 … +4.56 pp**.

Before the fix it was +1.70 … +4.16 pp, with the tightest cell (ssrwp-tworay)
at +1.70 pp against a summed CI of 1.25. That cell is now +6.62 pp against
0.76.

**Stable — overhead, in a new order.** The overhead ordering is
`olsr < anthocnet < dsdv < aodv` in all six cells. Before #496 it was
`olsr < dsdv < anthocnet < aodv`: the fix halved AntHocNet's NRL
(12.97–30.78, from 34.37–52.44), taking it below DSDV everywhere. OLSR's
proactive flooding of a single link-state table stays cheapest by a factor of
3–7.

**Scoped — the tail.** OLSR is still the invariant part: best tail under
two-ray (22.9–58.2 ms) and **worst** under fading (2442.9–2974.5 ms). What
moved is AntHocNet:

| channel | `delay99` order at `dd171e5e` |
|---|---|
| two-ray | **olsr** (23–58 ms) → **anthocnet** (195–303 ms), second in all three cells → aodv / dsdv (561–619 ms, overlapping intervals). |
| Nakagami | **anthocnet first in all three cells** (369–597 ms) → aodv (843–1060 ms) → dsdv → **olsr worst**. The pre-#496 "aodv-or-tie wins the fading tail" claim is retired. |

**Consequence: a tail claim that does not name its channel is still
unsupported.** OLSR's inversion carries that on its own. What #496 retired is
every remaining AntHocNet tail deficit: it beats AODV's `delay99` by
276–480 ms in all six cells (paired, p ≤ 9.6 × 10⁻⁵), and the
[#21](https://github.com/danieljoppi/AntHocNet/issues/21) deficit against AODV no longer appears anywhere on this
grid.

**Mobility is the weaker axis.** Across the three mobility models at fixed
channel, the paired ΔPDR against AODV moves by:

- two-ray: ≤ 0.9 pp (+11.42 … +12.30);
- Nakagami: ≤ 3.5 pp (+17.93 … +21.46).

No ordering changes anywhere. Steady-state RWP stays on classic RWP: the
ssrwp − rwp difference in that delta is −0.56 pp on two-ray and +0.48 pp under
Nakagami, both inside either cell's paired interval. At this scenario the
speed-decay transient the steady-state model exists to remove is still not
what drives the result.

## Provenance

`main` @ `dd171e5e`, image `ghcr.io/danieljoppi/ns3:3.42-opt`, `runs=20`,
`time=900`, `areaX=1500`, `speed=20`, `range=300`,
`protocols=anthocnet,aodv,olsr,dsdv,oracle`, shipped defaults (no
`extraArgs`), so `TimerJitter=0.05` and `ReconvHoldCap=200 ms`.
`dd171e5e` is the #496 merge `43dd2f96` plus documentation-only commits
(#498 and two benchmark-page refreshes).

| mobility | channel | pause | run ID | cell |
|---|---|---|---|---|
| rwp | tworay | 30 | [`36810709154`](https://github.com/danieljoppi/AntHocNet/actions/runs/36810709154) | `cells/grid-rwp-tworay.txt` |
| ssrwp | tworay | 30 | [`36810711356`](https://github.com/danieljoppi/AntHocNet/actions/runs/36810711356) | `cells/grid-ssrwp-tworay.txt` |
| gaussmarkov | tworay | 0 | [`36810713478`](https://github.com/danieljoppi/AntHocNet/actions/runs/36810713478) | `cells/grid-gaussmarkov-tworay.txt` |
| rwp | nakagami | 30 | [`36810715413`](https://github.com/danieljoppi/AntHocNet/actions/runs/36810715413) | `cells/grid-rwp-nakagami.txt` |
| ssrwp | nakagami | 30 | [`36810717701`](https://github.com/danieljoppi/AntHocNet/actions/runs/36810717701) | `cells/grid-ssrwp-nakagami.txt` |
| gaussmarkov | nakagami | 0 | [`36810720076`](https://github.com/danieljoppi/AntHocNet/actions/runs/36810720076) | `cells/grid-gaussmarkov-nakagami.txt` |

Every cell self-identifies through its `##CONFIG##` row
([#369](https://github.com/danieljoppi/AntHocNet/issues/369)) — cell identity
is read from the data, not from dispatch order — and its `##PROV##` line pins
`commit=dd171e5e` ([#365](https://github.com/danieljoppi/AntHocNet/issues/365)).
`bench_parse` column-mapping self-checks passed (25 checks) on all six cells.
`scenario_check.py results`:

- the two-ray cells are WARN-only (the approximate-oracle notes);
- the three Nakagami cells FAIL only on the known #431 hop residual (8 / 15 / 17
  seeds), as explained under
  [the attribution control](#the-attribution-control-the-oracle-reproduces-431-in-66-cells).

The superseded versions:

- **`a1daa7a` four-arm grid** (runs `31618105814` … `31618118283`), with the
  `40b434d` oracle dispatch beside it (runs `31807666381` … `31807678924`):
  `git show 0caa508d:docs/benchmarks/grid.md`.
- **`4611bbb` #431 re-measure** (runs `32209168271` … `32209193038`): per-cell
  table on [#431](https://github.com/danieljoppi/AntHocNet/issues/431#issuecomment-5339246820);
  its run logs have expired.

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
