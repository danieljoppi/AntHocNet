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
  --speed 30 --pause 0 --mobility gaussmarkov --flows 10 --pktPerSec 4 \
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
| `fanet-vertical-3d` | 10 nodes, 10 × 10 × 1000 m column, 350 m | planar distances are all < 15 m, so a field flattened to 2-D reads hopsMean = 1.00; with altitude honoured, pairs > 350 m apart need relays: **hopsMean > 1.2** | AODV 98.9 %, oracle 98.6 %, hopsMean 1.90 | the third dimension is real end to end |

## Results

20 seeds per cell, 900 s, image `3.42-opt`, five arms on identical
realisations. Means with t 95 % CI half-widths; `delay99` is a mean with a
percentile-bootstrap interval. Provenance and run IDs are [below](#provenance-of-the-numbers).

**The oracle column uses a 100 ms `RecomputeInterval`, not the 1 s default.**
At the default it is not a bound on this family
([#506](https://github.com/danieljoppi/AntHocNet/issues/506)); see
[the oracle at FANET speeds](#the-oracle-at-fanet-speeds) below. The four
protocol columns are byte-identical between the two oracle settings, because
the oracle draws on no shared random stream.

### Main cell (`fanet`, 350 m)

| metric | anthocnet | aodv | olsr | dsdv | oracle (100 ms) |
|---|---|---|---|---|---|
| PDR % | **94.41 ± 0.45** | 82.92 ± 0.81 | 51.65 ± 0.93 | 42.52 ± 1.02 | 97.11 ± 0.37 |
| mean delay (ms) | 20.04 ± 0.50 | 30.50 ± 5.58 | 4.50 ± 0.61 | 7.04 ± 0.59 | 4.27 ± 0.60 |
| `delay99` (ms) | 271.7 [268.2, 275.4] | 702.1 [513.8, 938.5] | 23.2 [21.1, 25.9] | 36.1 [33.1, 39.4] | 18.8 [18.2, 19.4] |
| NRL | 6.66 ± 0.14 | 7.79 ± 0.13 | 2.71 ± 0.06 | 7.25 ± 0.19 | 0.00 |

Paired, per seed (t-CI for PDR/NRL, bootstrap for `delay99`, two-sided
Wilcoxon):

| comparison | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) | verdict |
|---|---|---|---|---|
| anthocnet − aodv | **+11.48** [+10.72, +12.25] | **−1.14** [−1.26, −1.02] | **−430** [−669, −240] | improved on all three (p ≤ 4.2 × 10⁻⁴) |
| anthocnet − olsr | **+42.76** [+41.80, +43.71] | +3.94 [+3.84, +4.04] | +249 [+245, +252] | delivery for overhead and tail |

**AntHocNet delivers within 2.70 pp of the oracle**; AODV is 14.19 pp short,
OLSR 45.46 and DSDV 54.59. The proactive baselines collapse on the MAC layer,
not on routing: their drop books read `mac=38.80` (OLSR) and `mac=49.01`
(DSDV). At 10–30 m/s their tables keep next hops that have already flown out
of range, and each such packet burns its MAC retries before it is dropped.
AntHocNet's loss is mostly reconvergence (`route=4.40 [reconv=3.93]`).

**Do not read OLSR's or DSDV's tail as a win.** Their `delay99` is low because
they deliver only the short, easy half of the traffic. A tail measured over 52
% delivery is not comparable with one over 94 %
([metrics.md](../metrics.md#delay99-is-not-comparable-across-arms-with-materially-different-pdr-415)).
Against AODV, which delivers a comparable share, AntHocNet's tail is 430 ms
shorter.

### Sparse cell (`--range=250`, the partition regime)

| metric | anthocnet | aodv | olsr | dsdv | oracle (100 ms) |
|---|---|---|---|---|---|
| PDR % | **52.63 ± 1.65** | 48.76 ± 1.71 | 40.12 ± 1.11 | 17.91 ± 0.78 | 60.37 ± 1.86 |
| mean delay (ms) | 32.21 ± 1.17 | 359.58 ± 27.49 | 4.60 ± 0.95 | 13.02 ± 4.71 | 5.60 ± 0.49 |
| `delay99` (ms) | 505.0 [472.4, 538.5] | 5246.8 [4874.9, 5662.9] | 19.2 [18.4, 20.1] | 34.5 [31.0, 38.5] | 24.9 [24.3, 25.6] |
| NRL | 16.32 ± 0.64 | 8.78 ± 0.21 | 7.18 ± 0.33 | 12.61 ± 0.51 | 0.00 |

| comparison | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) |
|---|---|---|---|
| anthocnet − aodv | **+3.87** [+3.17, +4.56] | +7.54 [+7.06, +8.01] | **−4742** [−5146, −4374] |
| anthocnet − olsr | **+12.51** [+10.44, +14.58] | +9.14 [+8.70, +9.59] | +486 [+454, +519] |

This cell is **partition-bound by design**, so its absolute PDR is not a
measure of protocol quality. Even the oracle delivers only 60.37 %, and its
drop book attributes 38.25 points to "no path existed", which no protocol can
recover. Within that ceiling AntHocNet still leads every protocol (7.74 pp
below the oracle; AODV 11.61, OLSR 20.25, DSDV 42.47). It pays for it in
overhead: nearly twice AODV's NRL (16.32 vs 8.78), as its ants keep searching a graph that keeps
splitting. AODV buffers packets for seconds waiting for a route that does not
exist, which is its 5.2 s `delay99`.

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

**Hops: not a bound on a moving field.** `scenario_check.py results` FAILs the
identity-matched hop check: once in the main cell, and in the sparse cell on
every seed against every arm, at 100 ms as well as 1 s. Two effects break the
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

## Provenance of the numbers

| cell | arms | run | commit | cell file |
|---|---|---|---|---|
| main, 350 m | anthocnet, aodv, olsr, dsdv (+ oracle at 1 s) | [36932609311](https://github.com/danieljoppi/AntHocNet/actions/runs/36932609311) | `54886e2a` | `cells/fanet-main.txt` |
| sparse, 250 m | anthocnet, aodv, olsr, dsdv (+ oracle at 1 s) | [36932612649](https://github.com/danieljoppi/AntHocNet/actions/runs/36932612649) | `54886e2a` | `cells/fanet-sparse.txt` |
| main, 350 m | oracle at 100 ms (all five arms re-run) | [36936966493](https://github.com/danieljoppi/AntHocNet/actions/runs/36936966493) | `0197fe66` | `cells/fanet-main-oracle100ms.txt` |
| sparse, 250 m | oracle at 100 ms (all five arms re-run) | [36936970028](https://github.com/danieljoppi/AntHocNet/actions/runs/36936970028) | `0197fe66` | `cells/fanet-sparse-oracle100ms.txt` |

`0197fe66` differs from `54886e2a` by documentation and cell files only. The
control: all 80 per-seed `##RUN##` rows of the four protocols (4 × 20 seeds)
are byte-identical between the two dispatches of each cell.

Dispatch: `paper-benchmark.yml` with `scenario=fanet version=3.42-opt nNodes=30
time=900 runs=20 areaX=1000 areaY=1000 pause=0 speed=30 range=350` (or `250`)
`propagation=range mobility=gaussmarkov
protocols=anthocnet,aodv,olsr,dsdv,oracle`. The 100 ms runs add
`extraArgs=--ns3::oracle::Topology::RecomputeInterval=100ms`. `areaZ`,
`speedMin`, flows and rate come from the preset.

`scenario_check.py results`: the oracle no-path WARNs are expected on a field
that partitions, and the only FAILs are the hop-check class explained above.
`bench_parse` column mapping is OK on all four cells.
