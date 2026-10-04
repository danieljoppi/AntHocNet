# Scenario: fanet

**Class:** FANET — 3-D, smooth trajectories, fast link churn ([#300](https://github.com/danieljoppi/AntHocNet/issues/300))

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

> **A separate family, not a variant of the planar corpus.** Every other
> scenario page measures a planar field. This one places and moves nodes in a
> 3-D box (`--areaZ`, [#480](https://github.com/danieljoppi/AntHocNet/issues/480)),
> so its cells are **not comparable** with the MANET pages. Read them against
> each other and against the [FANET anchors](#anchors), never against the
> Broch floor, which is RWP-on-the-ground only.

## What it stresses

Flying ad hoc networks: a small swarm moving fast and smoothly in three
dimensions. Two things change against the ground field:
- links break more often and more abruptly, because closing speeds reach
  60 m/s;
- the third dimension spreads the same number of nodes over more volume, so
  density, not routing, is the first thing to get wrong.

The preset is built so that the main cell measures **routing**, and a second
cell measures the **partition** regime deliberately.

## Configuration

`--scenario=fanet` (added in [#482](https://github.com/danieljoppi/AntHocNet/issues/482)).
The preset carries **scenario knobs only**
([ADR-0019](../../adr/0019-network-families-change-the-evaluation-not-the-protocol.md)):
no AntHocNet attribute (`HelloInterval`, `QueueTimeout`, acceptance factors, …)
is changed for this family. Every value below can be overridden on the command
line; an explicit flag always wins.

| cell | nodes | field (m) | range (m) | mobility | speed (m/s) | flows | per-flow rate | time (s) | propagation |
|---|---|---|---|---|---|---|---|---|---|
| **`fanet`** (main) | 30 | 1000 × 1000 × 300 | **350** | Gauss-Markov | U(10, 30) | 10 | 4 × 64 B/s (2048 bps) | 900 | disk |
| `fanet` + `--range=250` (sparse) | 30 | 1000 × 1000 × 300 | **250** | Gauss-Markov | U(10, 30) | 10 | 4 × 64 B/s (2048 bps) | 900 | disk |

Flows start uniformly in [0, 180] s, as in the `paper` preset. Gauss-Markov
uses the harness's existing settings: α = 0.85, a 1 s time step, and a
uniform mean direction. `--pause` is inert under Gauss-Markov and the preset
sets it to 0.

## Provenance

Each value is either **sourced** (a published setup uses it or brackets it)
or **chosen** (a decision this repo made, with its reason). Nothing is left
unlabelled: unsourced constants were the root cause of #88, #169 and #173.

| knob | value | kind | where it comes from |
|---|---|---|---|
| mobility | Gauss-Markov, 3-D | sourced | The standard FANET entity model in the #298 survey. Used with a 3-D box in ns-3 by Makkar, Singh & Singh (2018)¹ and in 2-D by Yang et al. (2024)². Biomo et al. (2015)³ evaluate five entity models for UAV networks and conclude that the (enhanced) Gauss-Markov model is best suited to them. |
| field | 1000 × 1000 × 300 m | chosen, inside the sourced envelope | The #298 draft envelope (about 1000 × 1000 × 300 m). Published fields bracket it: 1500 × 1500 m² (2-D)² and a 1700 × 1700 × 1500 m cube¹. A 300 m altitude extent keeps the swarm flat-ish, like a survey swarm, rather than a cube. |
| nodes | 30 | chosen, inside the sourced envelope | The #298 envelope (20–40 UAVs); Yang et al.² sweep 40–140. Fixed at 30 so that the main cell's density clears the connectivity line (next row). |
| range | **350 m** main, **250 m** sparse | chosen for density | The #481 preflight measures the in-box pair probability (`box_in_range_prob`). At 30 nodes, a mean degree of 7.2 at 350 m clears 2·ln(30) = 6.8, so the main cell measures routing. 250 m (the #298 draft value) gives 3.5, right at ln(30) = 3.4, so that cell partitions and is kept as the deliberate sparse cell, like `sparse-static`. Published ranges bracket both: 200 m² to 1000 m³. Air-to-air links are line of sight, which makes a longer range than the ground cells' 250–300 m physically defensible. |
| speed | U(10, 30) m/s | chosen, inside the sourced envelope | The #298 envelope (10–30 m/s, small rotorcraft and slow fixed-wing). Yang et al.² use maximum speeds of 20–60 m/s; fixed-wing evaluations run faster still³. The floor of 10 m/s (`--speedMin`, new in #482) keeps the swarm from idling: the harness's historical U(1, max) would put many UAVs near hover. |
| pitch | mean U(−0.05, 0.05) rad; perturbation Normal(0, 0.02), bounded at 0.04 rad | **assumption** | No published FANET evaluation found states its Gauss-Markov pitch parameters. These are the harness's direction perturbation scaled down by ten (#480). Recorded here as an assumption, not a citation. |
| α (memory) | 0.85 | harness value | The harness's Gauss-Markov setting since #61, unchanged so the planar and 3-D arms share it. |
| traffic | 10 CBR flows, 4 × 64-byte packets/s | chosen | Low-rate telemetry. The per-flow rate is the AntHocNet thesis's (Ducatelle 2007 §5.1.3, "4 packets of 64 bytes per second"). 10 flows on 30 nodes keeps the paper's sources-to-nodes ratio (20/50) roughly constant. The offered load is 20 kbps, about 1 % of the 2 Mbit/s channel, so the cell measures routing, not congestion. |
| propagation | disk (`range`) | sourced constraint | Two-ray ground reflection and Nakagami (built on it) assume antennas over a ground plane, which is meaningless between aircraft; the harness refuses them with `--areaZ` (#480). A fading arm for 3-D needs a model that does not assume a ground plane and is out of scope here. |
| time | 900 s | chosen | The `paper`/`thesis` horizon, so a FANET cell has the same statistical weight per seed as a MANET one. |

1. S. Makkar, Y. Singh, R. Singh, "Performance Investigation of OLSR and AODV
   Routing Protocols for 3D FANET Environment using NS3", *Journal of
   Communication Engineering & Systems* 8(2), 2018. ns-3; Gauss-Markov in a
   1700 × 1700 × 1500 m cube.
2. S. Yang, S. Wang, T. Li, T. Hu, Z. Xu, R. He, B. Zhang, "Hybrid ant
   colony-based inter-cluster routing protocol for FANET", *Scientific Reports*
   14, 15632 (2024), [doi:10.1038/s41598-024-64454-1](https://doi.org/10.1038/s41598-024-64454-1).
   OMNeT++; 40–140 UAVs; 1500 × 1500 m²; Gauss-Markov; maximum speeds 20–60 m/s;
   200 m range; CBR.
3. J.-D. Medjo Me Biomo, T. Kunz, M. St-Hilaire, Y. Zhou, "Unmanned Aerial ad
   Hoc Networks: Simulation-Based Evaluation of Entity Mobility Models' Impact
   on Routing Performance", *Aerospace* 2(3), 392–422 (2015),
   [doi:10.3390/aerospace2030392](https://doi.org/10.3390/aerospace2030392).
   Cited here for its conclusions as stated in the abstract. Its parameter
   table could not be retrieved for this page (the publisher blocks automated
   access), so no value above rests on it alone.

**Preflight** (#481): both cells pass with WARNs only.

```
python3 .claude/skills/benchmark-results/scenario_check.py preflight \
  --nodes 30 --areaX 1000 --areaY 1000 --areaZ 300 --range 350 \
  --speed 30 --pause 0 --mobility gaussmarkov --flows 10 --cbrBps 2048 \
  --pathWindowS 2
```

The 3-D WARN says the cell is its own family. The sparse cell (`--range 250`)
additionally WARNs that partitions are likely, which is its purpose. Link
lifetime at 30 m/s is about 5.8 hello periods at 350 m and 4.2 at 250 m,
above the 3-period WARN line, so `HelloInterval` is not a concern
(ADR-0019 forbids retuning it per family anyway).

## Anchors

The Broch AODV floor is RWP on the ground and does not transfer. The FANET
family has its own **analytic** anchors, gated in CI on the 3.42 leg
([`ns3/tools/check-anchors.sh`](../../../ns3/tools/check-anchors.sh), floors in
[`ns3/tools/anchors.yml`](../../../ns3/tools/anchors.yml)). Both run the preset
with only the field shrunk, and route only stock AODV and the oracle control.

| anchor | field | expected (derived) | measured | what it checks |
|---|---|---|---|---|
| `fanet-single-hop-3d` | 10 nodes, 100 m cube, 350 m | the 173 m diagonal keeps every pair in range, so every flow is one hop: **PDR ≈ 100 %** and oracle **hopsMean = 1.00** exactly | AODV 100.0 %, oracle 100.0 %, hopsMean 1.00 | 3-D placement, mobility and channel deliver at all |
| `fanet-vertical-3d` | 10 nodes, 10 × 10 × 1000 m column, 350 m | planar distances are all < 15 m, so a field flattened to 2-D reads hopsMean = 1.00; with altitude honoured, pairs > 350 m apart need relays: **hopsMean > 1.2** | AODV 98.9 %, oracle 98.9 % (98.6 % at the pre-#506 1 s recompute), hopsMean 1.90 | the third dimension is real end to end |

## Results

20 seeds per cell, 900 s, image `3.42-opt`. **Six arms** run on identical
realisations:

- the four classical protocols (AntHocNet, AODV, OLSR, DSDV);
- **AOMDV**, the multipath baseline (#296);
- the oracle control.

Means carry t 95 % CI half-widths. `delay99` is a mean with a
percentile-bootstrap interval. Provenance and run IDs are
[below](#provenance-of-the-numbers).

**GPSR is not in the arm set, and no geographic protocol is.** The harness
refuses `gpsr` whenever `--areaZ > 0`
([#480](https://github.com/danieljoppi/AntHocNet/issues/480)), because the
vendored GPSR's headers and planarization are 2-D: it would route on projected
positions and measure an artifact of the projection. This is a threat to
validity for the family. Geographic forwarding is a major FANET design point,
and this page has no arm for it.

**The oracle column uses a 100 ms `RecomputeInterval`, not the 1 s default.**
At the default it is not a bound on this family
([#506](https://github.com/danieljoppi/AntHocNet/issues/506)); see
[the oracle at FANET speeds](#the-oracle-at-fanet-speeds) below. Since
[#506](https://github.com/danieljoppi/AntHocNet/issues/506), `--scenario=fanet` sets the 100 ms itself and records
it on the `##CONFIG##` row. The published cells passed it explicitly, with
byte-identical effect. An explicit `RecomputeInterval` on the command line
still wins.

**The OLSR column is offered-based
([#510](https://github.com/danieljoppi/AntHocNet/issues/510)).** Before #510,
stock OLSR's PDR left out the sends its source refused for want of a route, so
it read **3.80 pp high here and 23.53 pp high in the sparse cell**. The OLSR
column below comes from a re-run with the fix. Its other columns are
byte-identical to the six-arm dispatch. Only PDR, the offered-load percentiles
and the drop book changed.

Energy is **energy per delivered application bit** (mJ/bit, `##ENERGY##`,
[#508](https://github.com/danieljoppi/AntHocNet/pull/508)). The radio's idle
draw dominates the total, which is near-identical across arms on a seed. This
column is therefore an efficiency restatement of delivery
([metrics.md](../metrics.md#per-seed-energy-294-item-3-483)). It is quoted
because its ordering agrees with the PDR ordering in both cells, not as
independent evidence.

### Restated on CBR sources (#521)

> **Both cells were re-measured on constant-bit-rate sources.** Until
> [#521](https://github.com/danieljoppi/AntHocNet/issues/521) the sources ran ns-3's default 1 s on / 1 s off,
> so each FANET flow was offered 2 pkt/s in bursts of four, not the
> configured 4 pkt/s. The cell offered 10 kbps, not the 20 kbps in the
> configuration table.
>
> **Provenance.** Six arms, 20 seeds, 900 s, `3.42-opt`, at `main` @
> `d26ae640`. The knobs are identical to the published dispatch, and the
> oracle's 100 ms recompute is the preset default.
> Main cell: [37172235137](https://github.com/danieljoppi/AntHocNet/actions/runs/37172235137).
> Sparse cell: [37172236293](https://github.com/danieljoppi/AntHocNet/actions/runs/37172236293).
> Cells: `docs/benchmarks/cells/fanet-{main,sparse}-cbr521.txt`.
> `scenario_check.py results`: 0 FAIL; the WARNs are the expected oracle
> no-path partitions and the 3-D hop-check note. `bench_parse` column
> mapping is OK (30 checks) on both. OLSR's PDR is offered-based (#510).
>
> **Main cell:**
>
> | metric | anthocnet | aodv | olsr | dsdv | aomdv | oracle (100 ms) |
> |---|---|---|---|---|---|---|
> | PDR % | **94.43 ± 0.55** | 86.11 ± 1.01 | 47.86 ± 1.05 | 42.40 ± 0.95 | 46.23 ± 0.97 | 96.88 ± 0.42 |
> | `delay99` (ms) | 207.9 [203.4, 213.1] | 500.8 [352.4, 667.4] | 31.1 [28.8, 33.9] | 45.0 [41.4, 48.7] | 7981.4 [7878.5, 8081.5] | 16.0 [15.4, 16.6] |
> | NRL | 3.71 ± 0.10 | 4.07 ± 0.09 | 1.35 ± 0.03 | 3.63 ± 0.10 | 6.63 ± 0.23 | 0.00 |
> | energy (mJ/bit) | **1.438 ± 0.015** | 1.573 ± 0.026 | 2.826 ± 0.060 | 3.197 ± 0.081 | 2.924 ± 0.064 | 1.389 ± 0.014 |
>
> | comparison | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) | Δenergy (mJ/bit) |
> |---|---|---|---|---|
> | anthocnet − aodv | **+8.32** [+7.41, +9.23] | **−0.36** [−0.44, −0.29] | **−293** [−465, −121] | **−0.135** [−0.152, −0.118] |
> | anthocnet − olsr | **+46.56** [+45.70, +47.43] | +2.35 [+2.27, +2.44] | +177 [+171, +182] | **−1.388** [−1.443, −1.333] |
> | anthocnet − dsdv | **+52.02** [+51.10, +52.95] | +0.07 [−0.04, +0.19], p = 0.29 | +163 [+157, +169] | **−1.759** [−1.833, −1.685] |
> | anthocnet − aomdv | **+48.20** [+47.18, +49.22] | **−2.93** [−3.14, −2.72] | **−7774** [−7884, −7663] | **−1.487** [−1.548, −1.425] |
>
> **Verdicts, main cell:**
> - AntHocNet still leads every protocol. It is **2.45 pp** below the
>   oracle (was 2.70).
> - It still beats AODV on all four metrics (p ≤ 7.1 × 10⁻⁴), by a smaller
>   delivery margin: **+8.32 pp** (was +11.48). AODV gains most from CBR,
>   82.92 → 86.11.
> - Two orderings change:
>   - AntHocNet's NRL edge over DSDV is now a tie (+0.07, p = 0.29).
>   - OLSR now separates from AOMDV: +1.64 pp [+0.76, +2.51], p = 0.0027,
>     15/20 seeds. It was a tie. The delivery order is
>     `anthocnet > aodv > olsr > aomdv > dsdv`.
> - The failure mechanisms are unchanged:
>   - OLSR fails at the MAC (`mac=36.87`) and refuses 8.62 % at the source.
>   - DSDV fails at the MAC (`mac=50.04`).
>   - AOMDV fails in routing (`route=46.45`).
>   - AntHocNet's loss is mostly reconvergence (`route=3.99 [reconv=3.69]`).
>
> **Sparse cell:**
>
> | metric | anthocnet | aodv | olsr | dsdv | aomdv | oracle (100 ms) |
> |---|---|---|---|---|---|---|
> | PDR % | **52.71 ± 1.73** | 50.05 ± 1.80 | 16.56 ± 0.77 | 17.79 ± 0.79 | 25.57 ± 0.82 | 60.27 ± 1.85 |
> | `delay99` (ms) | 293.9 [286.2, 302.4] | 4962.5 [4615.7, 5378.9] | 19.6 [17.6, 22.2] | 39.0 [35.2, 43.5] | 8666.4 [8573.5, 8757.7] | 21.3 [20.7, 21.9] |
> | NRL | 10.75 ± 0.48 | 4.60 ± 0.11 | 3.59 ± 0.16 | 6.33 ± 0.27 | 9.00 ± 0.29 | 0.00 |
> | energy (mJ/bit) | **2.582 ± 0.085** | 2.709 ± 0.101 | 8.194 ± 0.391 | 7.646 ± 0.330 | 5.286 ± 0.171 | 2.237 ± 0.069 |
>
> **Verdicts, sparse cell:**
> - The ordering is unchanged: `anthocnet > aodv > aomdv > dsdv > olsr`,
>   every adjacent gap significant. The narrowest is DSDV over OLSR,
>   +1.22 pp [+0.93, +1.51], 20/20 seeds.
> - AntHocNet over AODV: **+2.65 pp** [+1.91, +3.39] (was +3.87), with
>   `delay99` −4669 ms and energy per bit −0.127 mJ.
> - AntHocNet still pays in overhead: NRL 10.75 vs AODV's 4.60.
> - AntHocNet is 7.57 pp below the oracle (was 7.74). The oracle's book
>   still puts 38.24 points in "no path existed".
>
> The tables below are the dated pre-#521 record. Where they disagree with
> this block, this block is current.

### Main cell (`fanet`, 350 m)

| metric | anthocnet | aodv | olsr | dsdv | aomdv | oracle (100 ms) |
|---|---|---|---|---|---|---|
| PDR % | **94.41 ± 0.45** | 82.92 ± 0.81 | 47.85 ± 0.95 | 42.52 ± 1.02 | 46.77 ± 0.66 | 97.11 ± 0.37 |
| mean delay (ms) | 20.04 ± 0.50 | 30.51 ± 5.58 | 4.50 ± 0.61 | 7.04 ± 0.59 | 387.33 ± 18.67 | 4.27 ± 0.60 |
| `delay99` (ms) | 271.7 [268.2, 275.4] | 702.1 [512.6, 940.6] | 23.2 [21.1, 25.9] | 36.1 [33.1, 39.4] | 7806.2 [7715.7, 7888.0] | 18.8 [18.2, 19.4] |
| NRL | 6.66 ± 0.14 | 7.79 ± 0.13 | 2.71 ± 0.06 | 7.25 ± 0.19 | 12.56 ± 0.35 | 0.00 |
| energy (mJ/bit) | **2.872 ± 0.029** | 3.263 ± 0.049 | 5.645 ± 0.120 | 6.367 ± 0.165 | 5.778 ± 0.102 | 2.770 ± 0.030 |

Paired, per seed (t-CI for PDR, NRL and energy; bootstrap for `delay99`;
two-sided Wilcoxon):

| comparison | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) | Δenergy (mJ/bit) | verdict |
|---|---|---|---|---|---|
| anthocnet − aodv | **+11.48** [+10.73, +12.25] | **−1.14** [−1.26, −1.02] | **−430** [−669, −240] | **−0.391** [−0.422, −0.360] | better on all four (p ≤ 4.2 × 10⁻⁴) |
| anthocnet − olsr | **+46.56** [+45.74, +47.38] | +3.94 [+3.84, +4.05] | +249 [+245, +252] | **−2.773** [−2.881, −2.664] | delivery and energy, for overhead and tail |
| anthocnet − dsdv | **+51.88** [+50.85, +52.91] | **−0.59** [−0.75, −0.43] | +236 [+231, +240] | **−3.495** [−3.649, −3.340] | delivery, overhead and energy, for tail |
| anthocnet − aomdv | **+47.64** [+46.83, +48.45] | **−5.90** [−6.23, −5.58] | **−7535** [−7615, −7446] | **−2.905** [−2.996, −2.815] | better on all four (p ≤ 9.6 × 10⁻⁵) |

**AntHocNet delivers within 2.70 pp of the oracle.** The other protocols'
shortfalls from the oracle:

- AODV: 14.19 pp;
- OLSR: 49.26 pp;
- AOMDV: 50.34 pp;
- DSDV: 54.59 pp.

The trailing three are close. OLSR leads AOMDV by only +1.08 pp
[+0.11, +2.04], p = 0.044, on 13/20 seeds. Read that as a tie, not an
ordering. Both lead DSDV with p ≤ 1.4 × 10⁻⁴.

The trailing arms fail in different ways:

- **OLSR and DSDV fail on the MAC layer.** Their drop books read
  `mac=35.96` and `mac=49.01`. At 10–30 m/s their tables keep next hops that
  have already flown out of range, and each such packet burns its MAC retries
  before it is dropped. OLSR also refuses 8.20 % of offered sends at the
  source, for want of any route.
- **AOMDV fails in routing.** Its book reads `route=45.57`. Its multipath
  discovery cannot keep alternate paths alive at these speeds, and what it
  does deliver arrives late (`delay99` 7.8 s).
- **AntHocNet's loss is mostly reconvergence** (`route=4.40 [reconv=3.93]`).

**Do not read OLSR's or DSDV's tail as a win.** Their `delay99` is low because
they deliver only the short, easy half of the traffic. A tail measured over
≤ 48 % delivery is not comparable with one over 94 %
([metrics.md](../metrics.md#delay99-is-not-comparable-across-arms-with-materially-different-pdr-415)).
AODV delivers a comparable share, and against it AntHocNet's tail is 430 ms
shorter.

### Sparse cell (`--range=250`, the partition regime)

| metric | anthocnet | aodv | olsr | dsdv | aomdv | oracle (100 ms) |
|---|---|---|---|---|---|---|
| PDR % | **52.63 ± 1.65** | 48.76 ± 1.71 | 16.59 ± 0.75 | 17.91 ± 0.78 | 25.97 ± 0.97 | 60.37 ± 1.86 |
| mean delay (ms) | 32.21 ± 1.17 | 359.58 ± 27.49 | 4.60 ± 0.95 | 13.02 ± 4.71 | 704.35 ± 48.83 | 5.60 ± 0.49 |
| `delay99` (ms) | 505.0 [472.4, 538.5] | 5246.8 [4874.9, 5662.9] | 19.2 [18.4, 20.1] | 34.5 [31.0, 38.5] | 8588.0 [8383.9, 8785.9] | 24.9 [24.3, 25.6] |
| NRL | 16.32 ± 0.64 | 8.78 ± 0.21 | 7.18 ± 0.33 | 12.61 ± 0.51 | 17.04 ± 0.52 | 0.00 |
| energy (mJ/bit) | **5.161 ± 0.161** | 5.557 ± 0.194 | 16.352 ± 0.790 | 15.174 ± 0.650 | 10.433 ± 0.371 | 4.466 ± 0.138 |

| comparison | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) | Δenergy (mJ/bit) |
|---|---|---|---|---|
| anthocnet − aodv | **+3.87** [+3.17, +4.56] | +7.54 [+7.06, +8.01] | **−4742** [−5146, −4374] | **−0.396** [−0.475, −0.316] |
| anthocnet − olsr | **+36.04** [+34.82, +37.25] | +9.14 [+8.70, +9.59] | +486 [+454, +519] | **−11.191** [−11.863, −10.520] |
| anthocnet − dsdv | **+34.73** [+33.44, +36.01] | +3.72 [+3.19, +4.25] | +470 [+439, +503] | **−10.013** [−10.565, −9.462] |
| anthocnet − aomdv | **+26.66** [+25.44, +27.88] | −0.72 [−1.42, −0.01] | **−8083** [−8276, −7875] | **−5.272** [−5.555, −4.989] |

This cell is **partition-bound by design**, so its absolute PDR does not
measure protocol quality. Even the oracle delivers only 60.37 %, and its drop
book attributes 38.25 points to "no path existed", which no protocol can
recover. Within that ceiling the protocols separate cleanly:

`anthocnet > aodv > aomdv > dsdv > olsr`

Every adjacent gap is significant. The narrowest is DSDV over OLSR, +1.31 pp
[+0.97, +1.65], p = 1.1 × 10⁻⁴, 19/20 seeds.

AntHocNet sits 7.74 pp below the oracle. It pays for that lead in overhead:
nearly twice AODV's NRL (16.32 vs 8.78), as its ants keep searching a graph
that keeps splitting. AODV buffers packets for seconds waiting for a route that
does not exist, which is its 5.2 s `delay99`. OLSR refuses 60.35 % of offered
sends at the source. That refusal is the share the pre-#510 PDR left out.

### What this page does not measure

- **Route stability.** The issue asks for route lifetime, route changes and
  repair latency. That metric family (#294 item 4) does not exist in the
  harness yet, so no route-stability column is published. The drop book's
  AntHocNet `reconv`/`repair` split is the closest available signal.
- **A geographic arm** (see above).
- **Hop or latency bounds** (see the oracle section below).

### The oracle at FANET speeds

The oracle is a global-knowledge shortest-path control that re-derives the
graph every `RecomputeInterval`. Two of its properties do not survive this
family's speeds ([#506](https://github.com/danieljoppi/AntHocNet/issues/506)).

**Delivery: a bound only with a fast recompute.** At the default 1 s, nodes
closing at up to 60 m/s move up to 60 m between recomputes. A fewest-hops route
prefers the longest links, which break first, so the oracle sends over links
that no longer exist:

| cell | oracle PDR at 1 s | oracle MAC drops at 1 s | oracle PDR at 100 ms | MAC drops at 100 ms | AntHocNet |
|---|---|---|---|---|---|
| main | 88.89 (below AntHocNet on 20/20 seeds) | 7.89 % | **97.11** (above on 20/20) | 0.91 % | 94.41 |
| sparse | 51.09 (below on 19/20) | 9.23 % | **60.37** (above on 20/20) | 1.11 % | 52.63 |

At 100 ms the oracle is above every arm on every seed in both cells, so the
**delivery bound holds**, and it is the only oracle property quoted on this
page.

**Hops: not a bound on a moving field.** The identity-matched hop check
fails at 100 ms as well as at 1 s. Since #506, `scenario_check.py results`
reports this as one WARN per file on any 3-D cell instead of a FAIL per seed.
The planar corpus keeps the FAIL. The excesses it counts are:

- **Main cell:** 16 times on 10 seeds. Ten of those are against AOMDV, whose
  few delivered packets are its shortest. Against the other arms it fails
  only on seeds 7 and 12.
- **Sparse cell:** on every seed against every arm.

With AOMDV in the arm set, the common set shrinks to the packets every arm
delivered, and in the sparse cell the oracle's excess grows to 1.0–2.1 hops. Two effects break the
check's premise that the same packet crosses the same topology in every arm:

- **Delay skew.** AODV holds matched packets for about 2 s in its discovery
  buffer, so its copy crosses the field seconds after the oracle's.
- **Mid-flight re-routing.** The oracle looks the route up afresh at each hop,
  in a graph that changes under the packet. A delivered path is then a chain
  of several instants' shortest paths, which can be longer than any one
  instant's. A local control confirms that motion is the cause: the same
  sparse cell at walking speed (`--speed=1 --speedMin=0.5`, 2 seeds) has the
  oracle at or below DSDV's matched hops (3.16 vs 3.47, 2.15 vs 2.20). At
  10–30 m/s it is 0.6–0.7 hops above.

So **no hop or latency bound is quoted for the FANET family**; the oracle's
delay columns above are measurements, not bounds.

## Ranking stability: MANET vs FANET

ADR-0019 keeps the protocol configuration identical across families. A ranking
that changes between families is therefore a property of the network, not of
our tuning.

**Comparators.** The comparison uses every mobile MANET cell measured on the
current code, with OLSR offered-based (#510) everywhere:

- the six [grid](../grid.md) cells, two-ray or Nakagami;
- the disk-propagation paper cell (`cells/paper-mobile-jitter*.txt`, RWP,
  pause 0, from [#494](https://github.com/danieljoppi/AntHocNet/issues/494)).

The paper cell is the channel-matched comparator, because FANET also runs on
the disk model.

| ordering | MANET grid (6 cells) | MANET paper, disk | FANET main | FANET sparse |
|---|---|---|---|---|
| delivery | `anthocnet > olsr > aodv > dsdv` (5 cells); `anthocnet > aodv > olsr > dsdv` (gaussmarkov-tworay) | `anthocnet > aodv > olsr > dsdv` | `anthocnet > aodv > olsr > dsdv` | `anthocnet > aodv > dsdv > olsr` |
| overhead (NRL) | `olsr < anthocnet < dsdv < aodv` | same | same | `olsr < aodv < dsdv < anthocnet` |
| tail (`delay99`) | two-ray: OLSR best, AntHocNet second; Nakagami: AntHocNet best, OLSR worst | OLSR best, AntHocNet second | OLSR, DSDV, then AntHocNet (survivorship: they deliver ≤ 48 %) | same as main |

**Stable across every mobile cell: AntHocNet delivers most.** That holds in
all six grid cells, the disk paper cell and both FANET cells, each paired and
significant. AntHocNet's lead over the best classical rival grows with the
family:

- grid: +6.1 … +11.4 pp over the best classical rival (OLSR, or AODV in
  gaussmarkov-tworay);
- paper disk cell: +13.1 pp over AODV;
- FANET main cell: +11.5 pp over AODV;
- FANET sparse cell: +3.9 pp over AODV, inside a 60 % oracle ceiling.

It is *not* stable on a static field. On the
[static mesh](../static-mesh.md), OLSR and DSDV deliver more (100.00 and 99.68
against 99.28). So "AntHocNet delivers most" is a claim about **mobile**
networks.

**Not stable: the order of the classical protocols.** A claim about it that
does not name its family, and on MANET its channel, is unsupported:

- **AODV vs OLSR flips with the cell.**
  - OLSR leads in five grid cells (+2.9 … +12.3 pp).
  - AODV leads in gaussmarkov-tworay (+1.9 pp) and in the disk paper cell
    (+8.8 pp).
  - In FANET, AODV leads by **+35.1 pp (main) and +32.2 pp (sparse)**, an
    order of magnitude wider than anything on MANET.
- **OLSR is family-sensitive, not merely channel-sensitive.**
  - It delivers 74–89 % on every MANET cell, but **47.85 %** at FANET speeds.
  - Its MAC drop rate rises from 15 % (paper cell) to 36 %, because its tables
    keep next hops that have flown out of range.
  - In the partition-bound sparse cell it refuses 60 % of sends at the source
    and falls to last.
- **DSDV is last on every MANET cell but not in sparse FANET.** There, OLSR
  falls below it, by 1.31 pp [0.97, 1.65], 19/20 seeds.

**Overhead is stable where the network is connected.**
`olsr < anthocnet < dsdv < aodv` holds in all seven MANET cells and in the
main FANET cell. It breaks only in the sparse cell, where AntHocNet's ants
keep searching a graph that keeps splitting. AntHocNet's NRL there is 16.32,
the highest of the four.

**The tail ordering does not transfer at all.** In FANET the two
lowest-`delay99` arms are those that deliver less than half the traffic.
Their tails are survivorship and not comparable
([metrics.md](../metrics.md#delay99-is-not-comparable-across-arms-with-materially-different-pdr-415)).

**Hello interval vs link lifetime.** This is the knob-watchlist item from #300.
The #481 preflight puts the link lifetime at 30 m/s at about **5.8 hello
periods** (350 m) and **4.2** (250 m), above its 3-period line. The campaign
gives no reason to open a tuning ticket: AntHocNet's loss in the main cell is
3.93 pp of reconvergence and 0.42 pp of MAC drops. The hold caps and the
multipath parameters likewise show no measured cost here. AntHocNet's tail is
the lowest among the arms that deliver comparably. ADR-0019 forbids per-family
defaults in any case. A knob becomes a ticket only on a measured delta.

## Provenance of the numbers

**The published tables** come from the six-arm dispatches plus the #510 OLSR
re-runs:

| cell | arms | run | commit | cell file |
|---|---|---|---|---|
| main, 350 m | anthocnet, aodv, olsr, dsdv, aomdv, oracle (100 ms), `##ENERGY##` | [36957200584](https://github.com/danieljoppi/AntHocNet/actions/runs/36957200584) | `77098cfe` | `cells/fanet-main-6arm.txt` |
| sparse, 250 m | same | [36957203615](https://github.com/danieljoppi/AntHocNet/actions/runs/36957203615) | `77098cfe` | `cells/fanet-sparse-6arm.txt` |
| main, 350 m | olsr, #510 offered-based PDR | [36962716872](https://github.com/danieljoppi/AntHocNet/actions/runs/36962716872) | `bd1f4e49` | `cells/fanet-main-olsr510.txt` |
| sparse, 250 m | olsr, #510 offered-based PDR | [36962719693](https://github.com/danieljoppi/AntHocNet/actions/runs/36962719693) | `bd1f4e49` | `cells/fanet-sparse-olsr510.txt` |

`77098cfe` is the #508 branch head; its code is what merged as `a412ab0f`.
`bd1f4e49` is the #511 branch head; its code is what merged as `f480d0ae`.

**Controls:**

- **The six-arm dispatches.** All 100 per-seed `##RUN##` rows of the five arms
  measured before are byte-identical to the `0197fe66` dispatches below. Adding
  AOMDV and `##ENERGY##` changed nothing else.
- **The OLSR re-runs.** Every OLSR `##RUN##` column except PDR and the
  offered-load percentiles (`off50`/`off90`, offered-based by construction) is
  byte-identical to the six-arm dispatch. The new PDR matches #510's
  delivered-bytes estimate to ≤ 0.08 pp on every seed.

**The superseded first measurement (#482)** had four protocols plus the oracle,
and OLSR's pre-#510 denominator:

| cell | arms | run | commit | cell file |
|---|---|---|---|---|
| main, 350 m | anthocnet, aodv, olsr, dsdv (+ oracle at 1 s) | [36932609311](https://github.com/danieljoppi/AntHocNet/actions/runs/36932609311) | `54886e2a` | `cells/fanet-main.txt` |
| sparse, 250 m | anthocnet, aodv, olsr, dsdv (+ oracle at 1 s) | [36932612649](https://github.com/danieljoppi/AntHocNet/actions/runs/36932612649) | `54886e2a` | `cells/fanet-sparse.txt` |
| main, 350 m | oracle at 100 ms (all five arms re-run) | [36936966493](https://github.com/danieljoppi/AntHocNet/actions/runs/36936966493) | `0197fe66` | `cells/fanet-main-oracle100ms.txt` |
| sparse, 250 m | oracle at 100 ms (all five arms re-run) | [36936970028](https://github.com/danieljoppi/AntHocNet/actions/runs/36936970028) | `0197fe66` | `cells/fanet-sparse-oracle100ms.txt` |

**Dispatch:** `paper-benchmark.yml` with

```
scenario=fanet version=3.42-opt nNodes=30 time=900 runs=20
areaX=1000 areaY=1000 pause=0 speed=30 range=350   # or range=250
propagation=range mobility=gaussmarkov
protocols=anthocnet,aodv,olsr,dsdv,aomdv,oracle
extraArgs=--ns3::oracle::Topology::RecomputeInterval=100ms
```

Since #506 the `extraArgs` line is the preset's default and may be omitted;
the result is byte-identical. The OLSR re-runs use `protocols=olsr`. `areaZ`,
`speedMin`, flows and rate come from the preset.

**`scenario_check.py results`:** the oracle no-path WARNs are expected on a
field that partitions. The hop-check class explained above is the only other
finding. It was a FAIL when these cells were published; since #506 it is one
WARN per file.
`bench_parse` column mapping is OK on every cell.
