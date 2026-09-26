# Static Wi-Fi mesh: the family where nothing moves

**Varies:** mobility, switched off. This is the paper base field (50 nodes,
1500 × 300 m, 20 CBR flows, 900 s) with `pause = 900`, so every node holds its
t = 0 position for the whole run. It is the community-network / Freifunk-class
**static Wi-Fi mesh** family, one of the four families of the family axis
([#484](https://github.com/danieljoppi/AntHocNet/issues/484),
[roadmap](../roadmap.md)).

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md) · [Regimes](../network-regimes.md)

> **Provenance: measured at `4fffedcc` (default arm) and `0c524697` (1 s arm),
> after `v1.6.0`.** The two commits differ only in docs and the Python
> preflight, not in the simulator. The four baselines are byte-identical
> across the two runs, which is the control that proves it. Like the
> [grid](grid.md) and [TCP](tcp.md) pages, these numbers are **not** comparable
> with the `v1.3.0`-pinned sweep pages. The raw per-seed cells are committed
> next to this page, so the numbers survive the CI logs expiring:
> [`cells/static-mesh-cap200ms.txt`](cells/static-mesh-cap200ms.txt) and
> [`cells/static-mesh-cap1s.txt`](cells/static-mesh-cap1s.txt). Run IDs are in
> [Provenance](#provenance) below.

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

Both AntHocNet rows are the same field, the same seeds and the same binary. The
only difference is `ReconvHoldCap`: **200 ms**, the shipped default since
[#371](https://github.com/danieljoppi/AntHocNet/issues/371), and **1 s**, the
v1.3.0–v1.4.0 value.

| protocol | PDR % | mean delay (ms) | delay99 (ms, bootstrap) | NRL |
|---|---:|---:|---:|---:|
| **anthocnet**, 200 ms (default) | 88.00 ± 2.24 | 12.06 ± 1.70 | 153.6 [130.1, 177.3] | 31.20 ± 1.46 |
| **anthocnet**, 1 s | **97.97 ± 0.33** | 26.70 ± 3.43 | 588.8 [510.1, 661.0] | 29.68 ± 1.14 |
| aodv | 95.98 ± 0.44 | 23.47 ± 2.54 | 266.7 [239.8, 297.1] | 39.39 ± 1.95 |
| dsdv | 99.68 ± 0.08 | 8.54 ± 1.19 | 125.3 [112.0, 138.2] | 17.04 ± 0.35 |
| olsr | 100.00 ± 0.00 | 2.54 ± 0.23 | 6.7 [5.8, 7.6] | 3.56 ± 0.07 |
| oracle (exact) | 100.00 ± 0.00 | 2.67 ± 0.30 | 11.3 [10.8, 11.8] | 0.00 |

Paired AntHocNet, 1 s vs 200 ms (`bench_parse --ab`, n = 20):

| metric | change | 95 % CI | Wilcoxon p |
|---|---|---|---|
| dPDR | **+9.97 pp** | [+7.87, +12.06] | 9.5 × 10⁻⁵ |
| delay99 | **+435 ms** | [+358, +506] | 1.9 × 10⁻⁶ |
| NRL | −1.52 | [−2.15, −0.89] | 8.2 × 10⁻⁵ |

The dPDR is positive on **20 / 20 seeds**, so the verdict is **PAIRED-MIXED**:
more delivery, a much longer tail.

**Where the packets go.** The AntHocNet drop book is
`route=11.52 [reconv=11.51]` at 200 ms and `route=1.34 [reconv=1.33]` at 1 s.
Almost the whole 200 ms shortfall is packets held for a route to re-form and
then discarded. That happens on a field where the oracle proves every flow is
deliverable and nothing moves.

## What the family says

1. **The ranking depends on the operating point, and the default sits at the
   unflattering end here.**

   | operating point | PDR vs AODV | tail vs AODV |
   |---|---|---|
   | 200 ms (default) | **8 pp worse** (88.0 vs 96.0, disjoint CIs) | better (154 vs 267 ms) |
   | 1 s | **2 pp better** (98.0 vs 96.0, disjoint CIs) | 2.2× worse |

   Neither point beats the proactive protocols. On a static mesh, OLSR and
   DSDV sit at or near the oracle on every metric. That is the expected
   outcome for a network whose topology never changes, and it is exactly the
   Babel / BATMAN-adv home turf discussed below.
2. **This is the [#308](https://github.com/danieljoppi/AntHocNet/issues/308)
   mechanism on a new family.** A held packet is either delivered late or
   dropped. So the tail and the delivery lead are one knob, and #371's choice
   of 200 ms was measured on the **mobile** cells. #371's headline, that
   200 ms "beats AODV on every published metric", **does not hold for the
   static family**. That finding is tracked as
   [#494](https://github.com/danieljoppi/AntHocNet/issues/494).
3. **The open question is why a static network reconverges at all.** 11.5 % of
   packets waited on a route to re-form while no node moved. Candidates are
   MAC-level link-failure detections under contention, and a still-valid route
   evaporating. Removing that trigger would recover these packets at either
   cap. That is the next measurement on #494.

A claim about AntHocNet on a static mesh that does not name its
`ReconvHoldCap` is unsupported.

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
| default (`ReconvHoldCap` 200 ms) | [36261077793](https://github.com/danieljoppi/AntHocNet/actions/runs/36261077793) | `4fffedcc` | `ns3:3.42-opt` | 1–20 |
| `ReconvHoldCap=1s` | [36269605435](https://github.com/danieljoppi/AntHocNet/actions/runs/36269605435) | `0c524697` | `ns3:3.42-opt` | 1–20 |

Both cells:

- `scenario_check.py results`: WARN only, 0 FAIL;
- `bench_parse` column mapping: OK (25 checks each);
- baselines (aodv, olsr, dsdv, oracle): byte-identical per-seed rows across
  the two arms.

Reproduce with `paper-benchmark.yml` using `nNodes=50 time=900 runs=20
areaX=1500 pause=900 speed=20 range=300 propagation=range
protocols=anthocnet,aodv,olsr,dsdv,oracle version=3.42-opt`. For the second
arm, add `extraArgs=--ns3::anthocnet::RoutingProtocol::ReconvHoldCap=1s`.
