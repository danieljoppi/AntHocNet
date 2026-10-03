# Static Wi-Fi mesh: the family where nothing moves

**Varies:** mobility, switched off. This is the paper base field (50 nodes,
1500 × 300 m, 20 CBR flows, 900 s) with `pause = 900`, so every node holds its
t = 0 position for the whole run. It is the community-network / Freifunk-class
**static Wi-Fi mesh** family, one of the four families of the family axis
([#484](https://github.com/danieljoppi/AntHocNet/issues/484),
[roadmap](../roadmap.md)).

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md) · [Regimes](../network-regimes.md)

> **Provenance: measured at `ce81eefe`, the [#496](https://github.com/danieljoppi/AntHocNet/issues/496)
> timer-jitter fix, after `v1.6.0`.** Every AntHocNet row on this page before
> #496 was measured with the ns-3 adapter's hello timer phase-locked across all
> nodes. That artifact is kept below as the dated **pre-#496** record, and it is
> reproducible with `--ns3::anthocnet::RoutingProtocol::TimerJitter=0`. The
> four baselines are byte-identical across all three runs, which is the control
> that proves only AntHocNet moved. Like the [grid](grid.md) and [TCP](tcp.md)
> pages, these numbers are **not** comparable with the `v1.3.0`-pinned sweep
> pages. The raw per-seed cells are committed next to this page:
> [`cells/static-mesh-jitter.txt`](cells/static-mesh-jitter.txt) (current),
> [`cells/static-mesh-cap200ms.txt`](cells/static-mesh-cap200ms.txt) and
> [`cells/static-mesh-cap1s.txt`](cells/static-mesh-cap1s.txt) (pre-#496).
> The #494 cap re-measure arms are
> [`cells/static-mesh-jitter-cap1s.txt`](cells/static-mesh-jitter-cap1s.txt) and
> [`cells/paper-mobile-jitter-cap1s.txt`](cells/paper-mobile-jitter-cap1s.txt).
> Run IDs are in [Provenance](#provenance) below.

## Why this family, and why it is framed rather than built

The [#298](https://github.com/danieljoppi/AntHocNet/issues/298) family scan
put the static mesh first on the list because it costs nothing: the
[`sparse-static`](scenarios/sparse-static.md) cell of the taxonomy **is** this
network. This page adds no harness work. What it adds:

- 20 seeds at current defaults, because the per-merge scenario page runs at
  the 10-run floor with 120 s runs;
- the exact oracle as an upper bound (on the disk channel it is `approx=0`, a
  proven bound);
- the family's reading of the results.

With nothing moving, the regime removes everything AntHocNet was designed
around ([network-regimes.md](../network-regimes.md)):

- no link churn to track;
- no route to repair;
- proactive maintenance that pays for a topology that never changes.

Whatever AntHocNet loses here, it loses to its own machinery.

## Results (20 seeds, 95 % CIs)

Current defaults (`TimerJitter = 0.05`, `ReconvHoldCap = 200 ms`):

| protocol | PDR % | mean delay (ms) | delay99 (ms, bootstrap) | NRL |
|---|---:|---:|---:|---:|
| **anthocnet** | **99.28 ± 0.25** | 3.70 ± 0.33 | 10.5 [9.3, 11.8] | 8.84 ± 0.27 |
| aodv | 95.98 ± 0.44 | 23.47 ± 2.54 | 266.7 [239.8, 297.1] | 39.39 ± 1.95 |
| dsdv | 99.68 ± 0.08 | 8.54 ± 1.19 | 125.3 [112.0, 138.2] | 17.04 ± 0.35 |
| olsr | 100.00 ± 0.00 | 2.54 ± 0.23 | 6.7 [5.8, 7.6] | 3.56 ± 0.07 |
| oracle (exact) | 100.00 ± 0.00 | 2.67 ± 0.30 | 11.3 [10.8, 11.8] | 0.00 |

The AntHocNet drop book is `route=0.44 [reconv=0.36]`, with `chan=0.27`.

### What #496 changed

Before #496, the ns-3 adapter started every node's hello timer at t ≈ 0 with no
jitter, so all 50 nodes beaconed at exactly t = 1, 2, 3 … s. Hidden terminals
collided on the same broadcasts every second. Two lost hellos in a row evict a
live neighbour, so the field tore down every link about every 15 s while no
node moved: about 93k spurious evictions per run. Each eviction pruned routes,
flooded LinkFail notes, and held data as `HOLD_RECONV`. The NS-2 adapter has
always jittered this timer; the ns-3 port lost it.

Paired AntHocNet, fixed timer vs the old one, same seeds and same 200 ms cap
(`bench_parse --ab`, n = 20):

| metric | change | 95 % CI | Wilcoxon p |
|---|---|---|---|
| dPDR | **+11.28 pp** | [+9.10, +13.45] | 1.9 × 10⁻⁶ |
| delay99 | **−143 ms** | [−167, −120] | 1.9 × 10⁻⁶ |
| NRL | **−22.37** | [−23.61, −21.12] | 1.9 × 10⁻⁶ |

The dPDR is positive on **20 / 20 seeds**: **PAIRED-IMPROVED** on every metric.

### The cap, re-measured on the fixed timer (#494)

With the timer fixed, `ReconvHoldCap = 1 s` against the 200 ms default, paired
on the same seeds (`bench_parse --ab`, n = 20). The mobile paper cell
(`pause = 0`) is included because #371 picked the cap on mobile cells.

| cell | PDR 200 ms → 1 s | dPDR [95 % CI] | delay99 200 ms → 1 s | NRL change |
|---|---|---|---|---|
| static mesh | 99.28 → 99.55 | +0.26 [+0.04, +0.49] pp, p = 0.011; 11 / 20 seeds up, 3 down | 10.5 → 10.4 ms (p = 0.57) | −0.01 (p = 0.90) |
| paper mobile | 96.19 → 97.50 | +1.31 [+1.06, +1.55] pp, 20 / 20 seeds | **345.6 → 555.0 ms** (+209 [+172, +249]) | +0.42 [+0.27, +0.57] |

On the static field the cap is now close to irrelevant: `reconv` is 0.36 % at
200 ms. On mobile, 1 s buys 1.3 pp by holding packets longer, and pushes the
tail above AODV's 510.9 ms. That is the trade #371 priced, so **200 ms stays**.

### Pre-#496 record (`TimerJitter = 0`)

Kept because #494 and the first version of this page were measured here, and
because it is the evidence for #496. Both rows are the same field, seeds and
binary, differing only in `ReconvHoldCap`.

| protocol | PDR % | mean delay (ms) | delay99 (ms, bootstrap) | NRL |
|---|---:|---:|---:|---:|
| anthocnet, 200 ms | 88.00 ± 2.24 | 12.06 ± 1.70 | 153.6 [130.1, 177.3] | 31.20 ± 1.46 |
| anthocnet, 1 s | 97.97 ± 0.33 | 26.70 ± 3.43 | 588.8 [510.1, 661.0] | 29.68 ± 1.14 |

The drop books were `route=11.52 [reconv=11.51]` at 200 ms and
`route=1.34 [reconv=1.33]` at 1 s. The 1 s cap recovered most of the lost
packets by holding them long enough to outlast the spurious break, at a
588 ms tail. The fixed timer removes the break instead, and beats both rows on
every metric.

## What the family says

1. **With the timer fixed, AntHocNet beats AODV on every metric here.** It
   delivers 99.28 % vs 95.98 % (disjoint CIs). Its delay99 is 10.5 ms vs
   266.7 ms, and its NRL is 8.84 vs 39.39. Its tail is also below DSDV's
   (125.3 ms) and within the oracle's interval (11.3 ms [10.8, 11.8]).
2. **OLSR still wins the static mesh**, as expected on a topology that never
   changes: 100 % delivery at 3.56 NRL. That is the Babel / BATMAN-adv home
   turf discussed below. AntHocNet's 0.7 pp gap to OLSR is `route=0.44` +
   `chan=0.27`.
   OLSR's 100 % predates [#510](https://github.com/danieljoppi/AntHocNet/issues/510), which counts the sends stock
   OLSR refuses at the source. The offered-based estimate from this cell's own
   throughput is 99.95 %, so the ordering and the gap are unchanged.
3. **The first version of this page measured a timer bug, not the family.** Its
   headline, that the 200 ms `ReconvHoldCap` costs about 10 pp here and that
   #371's "beats AODV on every metric" does not hold for static meshes
   ([#494](https://github.com/danieljoppi/AntHocNet/issues/494)), was the #496
   artifact. Re-measured on the fixed timer, 1 s adds only +0.26 pp here and
   costs 209 ms of mobile tail, so the 200 ms default stands (see
   [above](#the-cap-re-measured-on-the-fixed-timer-494)).

## Threats to validity

- **Missing baselines.** The protocols a real community mesh runs are
  Babel (RFC 8966) and BATMAN-adv. Neither has a maintained ns-3 port; see
  the dated [modern-baseline survey](modern-baseline-survey.md) for the
  evidence and the decision. OLSR is the closest ns-3-available stand-in, and
  it is already at the oracle here.
- **Channel.** The disk channel at 300 m is idealised: a link either exists
  perfectly or not at all. Real meshes are shaped by interference and fading.
  The [grid](grid.md) shows the tail ordering inverting under Nakagami fading,
  so a fading arm of this family is the natural follow-up.
- **One field.** This is the paper base field with mobility removed. It is not
  a measured community-network topology.

## Provenance

| arm | run | commit | image | seeds |
|---|---|---|---|---|
| current (`TimerJitter` 0.05, cap 200 ms) | [36595249953](https://github.com/danieljoppi/AntHocNet/actions/runs/36595249953) | `ce81eefe` | `ns3:3.42-opt` | 1–20 |
| pre-#496, cap 200 ms | [36261077793](https://github.com/danieljoppi/AntHocNet/actions/runs/36261077793) | `4fffedcc` | `ns3:3.42-opt` | 1–20 |
| pre-#496, cap 1 s | [36269605435](https://github.com/danieljoppi/AntHocNet/actions/runs/36269605435) | `0c524697` | `ns3:3.42-opt` | 1–20 |
| #494 re-measure: cap 1 s, fixed timer | [36767457453](https://github.com/danieljoppi/AntHocNet/actions/runs/36767457453) | `4c8482fd` | `ns3:3.42-opt` | 1–20 |
| #494 re-measure: paper mobile, cap 1 s | [36767461455](https://github.com/danieljoppi/AntHocNet/actions/runs/36767461455) | `4c8482fd` | `ns3:3.42-opt` | 1–20 |
| control: `ce81eefe` at `TimerJitter=0` | [36595255598](https://github.com/danieljoppi/AntHocNet/actions/runs/36595255598) | `ce81eefe` | `ns3:3.42-opt` | 1–20 |

All cells:

- `scenario_check.py results`: WARN only, 0 FAIL;
- `bench_parse` column mapping: OK (25 checks each);
- baselines (aodv, olsr, dsdv, oracle): byte-identical per-seed rows across
  every arm;
- the control run reproduces the pre-#496 200 ms AntHocNet rows byte for
  byte, so `TimerJitter=0` is exactly the old timer.

Reproduce with `paper-benchmark.yml` using `nNodes=50 time=900 runs=20
areaX=1500 pause=900 speed=20 range=300 propagation=range
protocols=anthocnet,aodv,olsr,dsdv,oracle version=3.42-opt`. For the pre-#496
arms, add `extraArgs=--ns3::anthocnet::RoutingProtocol::TimerJitter=0`, plus
`--ns3::anthocnet::RoutingProtocol::ReconvHoldCap=1s` for the 1 s row.
The #494 arms add only `ReconvHoldCap=1s` and run `protocols=anthocnet`
(`pause=0` for the mobile one); their 200 ms partners are
`cells/static-mesh-jitter.txt` and `cells/paper-mobile-jitter.txt`. `4c8482fd`
carries the same code as `ce81eefe` (it differs only by a docs refresh).
