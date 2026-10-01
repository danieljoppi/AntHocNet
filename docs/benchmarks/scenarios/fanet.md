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

Pending: the first 20-seed measurement of both cells is in progress and will
be published here with the oracle control.
