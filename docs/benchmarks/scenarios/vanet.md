---
# Try it in the game (#629): rendered as a rail above the page on the site.
try:
  - world: vanet
    seed: 1
    title: "Watch a route break at a street corner"
  - replay: vanet
    title: "Seed 1 of the main cell, as ns-3 ran it"
---

# Scenario: vanet

**Class:** VANET — vehicles on a street grid, corridor-shaped links, buildings that cut line of sight ([#301](https://github.com/danieljoppi/AntHocNet/issues/301), [#488](https://github.com/danieljoppi/AntHocNet/issues/488))

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

> **A separate family, not a variant of the MANET corpus.** Vehicles move on
> the 1-D streets of a 2-D grid, and the radio is shadowed by the buildings
> between the streets. Its cells are **not comparable** with the MANET pages:
> read them against each other and against the [VANET anchors](#anchors),
> never against the Broch floor, which is RWP-only.

**Re-measured for v2.2.0 (2026-10-16).** The [v2.2.0 campaign](../v2.2.0-campaign.md#results) re-ran every cell on this page as its control generation, at `a8a16991`, with the shipped defaults and the same 20 seeds. Every `##RUN##` row is byte-identical to the cells this page cites. No default moved, so the numbers here stand as v2.2.0's. The control cells are `results/cells/vanet-*-v220.txt`. What the campaign's four knobs do on this family is in [network-regimes.md §7](../../network-regimes.md#7-measured-the-v220-knobs-per-regime).

## What it stresses

Vehicular ad hoc networks in a city. Three things change against the open
MANET field:
- **mobility is street-shaped**: vehicles follow streets and turn at
  intersections (the Manhattan model), so relative motion is either
  head-on/same-direction along one street or across an intersection;
- **links are corridor-shaped**: buildings cut line of sight, so a vehicle
  hears its own street far further than the parallel one 200 m away;
- **links break at corners**: a vehicle that turns loses line of sight to its
  former street within metres, so route churn is driven by turns, not only by
  distance.

The preset is built so that the main cell measures **routing**, and a second
cell measures the **partition** regime deliberately.

## Configuration

`--scenario=vanet` (added in [#488](https://github.com/danieljoppi/AntHocNet/issues/488)).
The preset carries **scenario knobs only**
([ADR-0019](../../adr/0019-network-families-change-the-evaluation-not-the-protocol.md)):
no AntHocNet attribute is changed for this family. Every value below can be
overridden on the command line; an explicit flag always wins.

| cell | vehicles | field (m) | grid | mobility | speed (m/s) | flows | per-flow rate | time (s) | propagation |
|---|---|---|---|---|---|---|---|---|---|
| **`vanet`** (main) | **100** | 800 × 800 | 4 × 4 blocks of 200 m, 20 m streets | Manhattan | U(10, 20) | 20 | 4 × 64 B/s (2048 bps) | 900 | urban |
| `vanet` + `--nNodes=40` (sparse) | **40** | 800 × 800 | 4 × 4 blocks of 200 m, 20 m streets | Manhattan | U(10, 20) | 20 | 4 × 64 B/s (2048 bps) | 900 | urban |

Flows start uniformly in [0, 180] s, as in the `paper` preset. The oracle
control recomputes its graph every **100 ms** under this preset, as under
`fanet` (see [the oracle](#the-oracle-on-the-street-grid)).

### The mobility model (`--mobility=manhattan`)

The Manhattan model of Bai, Sadagopan & Helmy (IMPORTANT, INFOCOM 2003)¹, the
model BonnMotion's ManhattanGrid implements:
- streets are the block edges, border streets included;
- a vehicle starts at a uniform point of the street network (placement is
  length-weighted over all streets), heading either way along its street;
- at each intersection it goes straight with probability 0.5 and turns left
  or right with 0.25 each, the probabilities of the Camp, Boleng & Davies
  survey²; a choice that would leave the field is redrawn among the valid
  ones, and a dead end turns the vehicle back;
- each block-to-block leg is driven at a speed drawn U(speedMin, speed);
- there are no pauses, so `--pause` is inert and the preset sets it to 0.

It is built **in the harness**, as `WaypointMobilityModel` waypoints from one
pinned RNG stream, rather than imported as a BonnMotion trace (#488 scope 1
suggested the import). That needs no Java toolchain in CI and no committed
trace files, and a run stays a function of its seed alone (#352): every arm on
a seed sees the identical vehicle schedule.

**Two simplifications against BonnMotion**, recorded rather than hidden:
BonnMotion perturbs speed at every update interval, while this model draws one
speed per leg; and BonnMotion supports pauses, which this model omits.

### The channel (`--propagation=urban`)

The same two-ray ground path loss as the `tworay` arm (identical frequency and
antenna height, so `{tworay, urban}` isolates the buildings alone), plus the
deterministic building shadowing of Sommer, Eckhoff, German & Dressler
(WONS 2011)³, the obstacle model Veins ships:

    L_obs = 9 dB × (walls cut) + 0.4 dB/m × (metres inside buildings)

at Veins' shipped defaults. The buildings are the grid's blocks, inset by half
the street width from each street centre line.

## Provenance

Each value is either **sourced** (a published setup uses it or brackets it)
or **chosen** (a decision this repo made, with its reason). Nothing is left
unlabelled: unsourced constants were the root cause of #88, #169 and #173.

| knob | value | kind | where it comes from |
|---|---|---|---|
| mobility | Manhattan grid, turns 0.5 / 0.25 / 0.25 | sourced | Bai, Sadagopan & Helmy (2003)¹ introduce the Manhattan model for urban movement; the turn probabilities are the Camp, Boleng & Davies survey's². |
| field | 800 × 800 m | chosen, from the sourced setup | Bai & Helmy run their Manhattan patterns on 1000 × 1000 m¹. Under the urban channel that field needs ~145 vehicles to clear the 2·ln(n) connectivity line (#488 preflight), and per-seed cost grows faster than quadratically in nodes (`scale` sweep: 98.2 min/seed at 162 nodes). 800 × 800 m reaches the same line at 95–100 vehicles. |
| blocks | 4 × 4 of 200 m | **assumption** | Neither source fixes a block length. 200 m is a city-block order of magnitude, and it keeps the block shorter than the radio's line-of-sight reach (the two-ray decode radius, 423.3 m), so a street is one or two hops long. Recorded as an assumption, not a citation. |
| street width | 20 m | **assumption** | Sets the building footprint (180 × 180 m per block). Not from a source; recorded as an assumption. |
| vehicles | **100** main, **40** sparse | chosen for density | The #488 preflight's road-network degree (a fixed-seed Monte Carlo over street pairs, applying the two-ray margin against the building loss) is 9.6 at 100 vehicles, clearing 2·ln(100) = 9.2, so the main cell measures routing. At 40 vehicles — Bai & Helmy's count¹ — it is 3.8, right at ln(40) = 3.7, so that cell partitions and is kept as the deliberate sparse cell, like FANET's 250 m cell. The estimate matches the harness: the oracle's measured graph on the main preset averages degree 9.1. |
| speed | U(10, 20) m/s | chosen, inside the sourced envelope | 36–72 km/h, urban arterial speeds, inside the #298 urban envelope (10–40 m/s). Bai & Helmy sweep maxima of 1–60 m/s¹. The 10 m/s floor (`--speedMin`) keeps vehicles moving, since the model has no stops. |
| channel | two-ray + Sommer building shadowing | sourced | Sommer et al. (2011)³: 9 dB per wall, 0.4 dB/m inside, Veins' defaults. **Threat to validity:** those constants were fitted at 5.9 GHz (802.11p), and this harness keeps its 2.4 GHz 802.11b radio (ADR-0019: a family changes the scenario, not the stack). Lower frequency penetrates walls somewhat better, so the buildings here are, if anything, slightly too opaque. |
| traffic | 20 CBR flows, 4 × 64-byte packets/s | sourced | Bai & Helmy (2003)¹: 20 CBR sources, 4 packets/s, 64 bytes. The per-flow rate equals the AntHocNet thesis's (Ducatelle 2007 §5.1.3). Offered load is 41 kbps, about 2 % of the 2 Mbit/s channel, so the cell measures routing, not congestion. |
| time | 900 s | sourced | Bai & Helmy (2003)¹, and the `paper`/`thesis` horizon. |

1. F. Bai, N. Sadagopan, A. Helmy, "IMPORTANT: a framework to systematically
   analyze the Impact of Mobility on Performance of RouTing protocols for
   Adhoc NeTworks", *IEEE INFOCOM 2003*. The values above are read from the
   authors' extended chapter, F. Bai and A. Helmy, "A Survey of Mobility
   Models in Wireless Adhoc Networks", ch. 2
   ([PDF](https://www.cise.ufl.edu/~helmy/papers/IMPORTANT-Mobility-Chapter-2.pdf)),
   §3–§5: 40 nodes, 1000 × 1000 m, 900 s, 250 m range, 20 CBR sources at
   4 packets/s of 64 bytes, maximum speeds 1–60 m/s.
2. T. Camp, J. Boleng, V. Davies, "A survey of mobility models for ad hoc
   network research", *Wireless Communications and Mobile Computing* 2(5),
   483–502 (2002): the Manhattan model's 0.5 straight / 0.25 left / 0.25 right.
3. C. Sommer, D. Eckhoff, R. German, F. Dressler, "A computationally
   inexpensive empirical model of IEEE 802.11p radio shadowing in urban
   environments", *WONS 2011*; the defaults are those of Veins' obstacle
   configuration (`db-per-cut 9`, `db-per-meter 0.4`).

**Preflight** (#488): both cells pass with WARNs only. The family WARN says
the cell is its own family; the sparse cell (`--nodes 40`, degree 3.8 against
ln(40) = 3.7) additionally WARNs that partitions are likely, which is its
purpose.

```
python3 tools/bench/scenario_check.py preflight \
  --nodes 100 --areaX 800 --areaY 800 --blocksX 4 --blocksY 4 \
  --mobility manhattan --propagation urban --speed 20 --pause 0 \
  --flows 20 --cbrBps 2048 --time 900 --pathWindowS 2
```

The street-grid degree replaces the strip/disk rule, which is wrong for a
road network: nodes live on the 1-D edges of a 2-D grid, and a disk around a
vehicle mostly covers buildings. Link lifetime at 20 m/s over the 423 m
line-of-sight reach is about 10.6 hello periods, so `HelloInterval` is not a
concern by the #481 rule; corner turns break links sooner than that bound,
which the route-stability metrics measure directly.

## Anchors

The Broch AODV floor is RWP-only and does not transfer. The VANET family has
its own **analytic** anchors, gated in CI on the 3.42 leg
([`tools/checks/check-anchors.sh`](../../../tools/checks/check-anchors.sh), floors in
[`ns3/tools/anchors.yml`](../../../ns3/tools/anchors.yml)). Both run the preset
shrunk to a single 280 × 280 m block with 20 vehicles, and route only stock
AODV and the oracle control.

| anchor | field | expected (derived) | measured | what it checks |
|---|---|---|---|---|
| `vanet-single-hop` | one block, street width 279 m (a 1 m building) | the 396 m block diagonal is inside the 423.3 m two-ray decode radius and no line of sight is cut, so every flow is one hop: **PDR ≈ 100 %**, oracle **hopsMean ≈ 1.00** | AODV 99.5 %, oracle 99.9 %, hopsMean 1.00 | the street grid, mobility and channel deliver at all |
| `vanet-building` | one block, street width 100 m (a 180 × 180 m building) | vehicles on opposite streets lose line of sight and must relay around a corner: oracle **hopsMean > 1.2**; a channel that ignored the building reads the single-hop 1.00 | AODV 80.4 %, oracle 99.6 %, hopsMean 1.36 | the buildings are honoured end to end |
| `vanet-gpcr-vs-gpsr` ([#709](https://github.com/danieljoppi/AntHocNet/issues/709)) | the `vanet-building` block, `gpsr,gpcr,oracle` | GPCR's own paper trend (Lochert et al. 2005, §V): around a blocked corner the junction-aware arm **beats GPSR by ≥ 2 pp** on the same seeds; every arm ≥ 75 % | ns-3.42: GPCR 89.3 %, GPSR 84.4 % (+4.9 pp), oracle 99.6 % | the GPCR arm reproduces the trend its paper reports |

The harness's own CI smoke (`tools/checks/check-manhattan.sh`) adds the
invariants the anchors do not: every vehicle is on a street at t = 0 and
mid-run, every arm delivers on the urban field, the oracle keeps 66 edges
against 236 under plain two-ray on the same field, and a same-seed rerun is
byte-identical.

## The junction-aware comparator: GPCR (#709)

Under [ADR-0026](../../adr/0026-baselines-are-family-native.md) this family
is compared against VANET-native routing:
- GPSR, position-based;
- AODV, the VANET literature's standard reactive baseline;
- GPCR, added here as the street grid's own answer to GPSR's failure at
  corners.

OLSR, DSDV and AOMDV are MANET migrants. Their rows below stay as the dated
record of their campaigns, and they leave the plan from the v2.4.0 control
campaign.

`--protocols=gpcr` is Greedy Perimeter Coordinator Routing (Lochert, Mauve,
Füßler & Hartenstein, ACM MC2R 2005). It runs as a mode of the vendored GPSR
module, with the same beacons, headers and GOD positions. Its rules:

- nodes on a junction ("coordinators") are recognised from the correlation of
  their neighbours' positions;
- along a street, packets are forwarded toward the next junction and never
  across it;
- at a junction, the next street is chosen greedily;
- when greedy forwarding fails, the right-hand rule is applied at junctions
  only.

Two constants are not given by the paper. Both are attributes, recorded as
maintainer decisions:

- the junction threshold ε = 0.9 (the paper's digit is illegible);
- a ±30° street cone.

The fidelity sheet is in
[`ns3/baselines/gpsr/README.md`](../../../ns3/baselines/gpsr/README.md#gpcr-mode-709-fidelity-sheet).

**ε sensitivity, measured on the `vanet-building` block** (ns-3.48, 2 seeds,
before the #717 fix): GPCR delivers 90.1 / 90.0 / 90.0 % at ε = 0.8 / 0.9 / 0.95.
On the full 100-vehicle grid (1 seed, 120 s) it delivers 24.2 / 23.7 % at
ε = 0.8 / 0.95. The threshold moves delivery by under 1 pp on these fields.

**GPSR rows measured before #717.** The vendored GPSR drew its first hello
before the harness pinned its random stream
([#717](https://github.com/danieljoppi/AntHocNet/issues/717)), so each GPSR
row depended on the runs before it in the same process. For example, seed 2
on the delivery-smoke field read 27.9 % alone and 18.1 % after seed 1. The
GPSR rows on this page are one realisation of that order-dependent run. The
v2.4.0 control campaign re-measures them, and GPCR's 20-seed cell is
published with it.

## The oracle on the street grid

The oracle derives its graph per pair under this channel (`decode-los-approx`,
[ns3/baselines/oracle/README.md](../../../ns3/baselines/oracle/README.md)): inside the two-ray
decode disk, a pair is a link iff the deterministic two-ray + building chain
reaches the decode floor. Both models are deterministic, so the evaluation
draws no random numbers and every arm sees the same channel. It is flagged
`approx=1` for the same reason as `tworay`: decoding under load also depends
on interference, which no per-pair rule carries.

**Recompute cadence: 100 ms.** At the 1 s default the oracle lagged the
corner turns: on the `vanet-building` field with 10 vehicles it delivered
48.3 % against AODV's 50.5 %, so it was not a bound. At 100 ms it delivers
99.6 % there. The preset sets 100 ms as `fanet` does (#506); the oracle is the
measuring instrument, not a protocol under test, so this is not the
per-family protocol default ADR-0019 forbids.

## Restated at v2.4.0: family-native baselines (ADR-0026)

> **Current numbers: v2.4.0.** From v2.4.0 every family is compared against
> its own protocols plus its oracle
> ([ADR-0026](https://github.com/danieljoppi/AntHocNet/blob/main/docs/adr/0026-baselines-are-family-native.md)).
> These cells are the [v2.4.0 control campaign](../v2.4.0-campaign.md#results)
> at the shipped defaults (no default moved), 20 seeds, mean ± 95 % t-interval.
> AntHocNet's rows and every kept baseline row are byte-identical to v2.3.0's.
> The blocks below this one are the dated record of their campaigns; their
> migrant rows are **retired**, not deleted.

**Native set:** AntHocNet, AODV (the VANET literature's standard reactive baseline), GPSR, GPCR ([#709](https://github.com/danieljoppi/AntHocNet/issues/709)), the oracle. **Retired:** OLSR, DSDV, AOMDV. GPSR's rows differ from v2.3.0's: the [#717](https://github.com/danieljoppi/AntHocNet/issues/717) fix moved its first hello after stream pinning.

#### main (100 vehicles)

| protocol | PDR % ± 95 % CI | delay99 ms | NRL |
|---|---|---|---|
| **AntHocNet** | 42.09 ± 0.66 | 1849.3 | 73.61 |
| AODV | 42.26 ± 0.60 | 3748.5 | 60.45 |
| GPSR | 25.82 ± 0.50 | 790.6 | 5.42 |
| GPCR | 28.73 ± 0.52 | 673.6 | 4.87 |
| oracle | 81.70 ± 0.45 | 609.0 | 0.00 |

AntHocNet − oracle -39.61 [-40.20, -39.01] pp; against the best native baseline (aodv, 42.26 %): dPDR -0.16 [-0.59, +0.26] pp, d delay99 -1899.15 [-1949.00, -1852.55] ms, d NRL +13.16 [+11.40, +14.91] (PAIRED-MIXED).

#### sparse (40 vehicles)

| protocol | PDR % ± 95 % CI | delay99 ms | NRL |
|---|---|---|---|
| **AntHocNet** | 23.93 ± 0.59 | 649.5 | 27.19 |
| AODV | 23.79 ± 0.65 | 8583.1 | 7.06 |
| GPSR | 16.30 ± 0.52 | 1685.5 | 3.44 |
| GPCR | 16.90 ± 0.53 | 1686.8 | 3.33 |
| oracle | 30.79 ± 0.52 | 26.3 | 0.00 |

AntHocNet − oracle -6.85 [-7.02, -6.68] pp; against the best native baseline (aodv, 23.79 %): dPDR +0.15 [-0.18, +0.47] pp, d delay99 -7933.60 [-8041.95, -7829.40] ms, d NRL +20.13 [+19.35, +20.90] (PAIRED-MIXED).

AntHocNet ties AODV on delivery in both cells, with a far shorter tail at more overhead. GPCR beats GPSR on the same seeds in both cells (+2.91 pp on main, +0.59 pp on sparse, paired-improved), as its own paper predicts, but both geographic arms trail AODV by 7–16 pp on this street grid.

## Restated at v2.3.0 defaults (quiet mode on)

> **Dated record: v2.3.0 defaults** (superseded by the v2.4.0 block above). v2.3.0 turns quiet mode on by
> default ([#571](https://github.com/danieljoppi/AntHocNet/issues/571), the
> [v2.3.0 campaign](../v2.3.0-campaign.md#results)). AntHocNet's rows below are the
> campaign's `quiet` arm. Every baseline row is the campaign's `control`, and the
> attribution control found those identical to the v2.2.0 corpus. 20 seeds,
> paired per seed; a bold difference is one whose 95 % t-interval excludes zero.
>
> **Quiet mode's effect here**, paired against v2.2.0's AntHocNet: noise on PDR, delay99 and NRL in both cells: corner breaks reset the back-off.
>
> **Provenance.** The campaign's runs at `main`, `54cdfae7..cc230126`. Cells:
> `results/cells/<cell>-v230-published.txt`, composed by [`tools/bench/compose_cell.py`](https://github.com/danieljoppi/AntHocNet/blob/main/tools/bench/compose_cell.py) from the campaign's `<cell>-v230.txt` (control) and `<cell>-v230-quiet.txt`. Tables recomputed from the cells' `##RUN##` rows (t-intervals; delay99 by
> bootstrap).
>
> **main (100 vehicles)**
>
> | protocol | PDR % | delay99 (ms, bootstrap) | NRL |
> |---|---:|---:|---:|
> | **anthocnet** | **42.10 ± 0.66** | 1849.3 [1811.4, 1892.2] | 73.61 ± 1.94 |
> | aodv | 42.26 ± 0.60 | 3748.5 [3706.7, 3793.4] | 60.45 ± 1.27 |
> | aomdv | 18.87 ± 0.48 | 9028.1 [8982.8, 9073.8] | 73.60 ± 2.07 |
> | olsr | 9.19 ± 0.38 | 183.8 [72.4, 314.6] | 11.23 ± 0.52 |
> | dsdv | 11.81 ± 0.38 | 833.6 [796.5, 876.9] | 66.64 ± 2.48 |
> | gpsr | 25.95 ± 0.50 | 764.0 [727.0, 803.3] | 5.39 ± 0.13 |
> | oracle | 81.70 ± 0.45 | 609.0 [541.5, 669.6] | 0.00 ± 0.00 |
>
> | AntHocNet minus | ΔPDR (pp) | Δdelay99 (ms) | ΔNRL |
> |---|---:|---:|---:|
> | aodv | -0.16 [-0.59, +0.26] | **-1899.2 [-1951.8, -1846.5]** | **+13.16 [+11.40, +14.91]** |
> | aomdv | **+23.22 [+22.77, +23.67]** | **-7178.8 [-7250.0, -7107.5]** | +0.01 [-2.31, +2.33] |
> | olsr | **+32.90 [+32.47, +33.33]** | **+1665.6 [+1539.5, +1791.7]** | **+62.37 [+60.62, +64.13]** |
> | dsdv | **+30.28 [+29.83, +30.73]** | **+1015.8 [+940.6, +1090.9]** | **+6.97 [+4.59, +9.34]** |
> | gpsr | **+16.14 [+15.77, +16.51]** | **+1085.3 [+1023.2, +1147.5]** | **+68.21 [+66.33, +70.10]** |
>
> **sparse (40 vehicles)**
>
> | protocol | PDR % | delay99 (ms, bootstrap) | NRL |
> |---|---:|---:|---:|
> | **anthocnet** | **23.93 ± 0.59** | 649.5 [608.6, 690.1] | 27.19 ± 0.91 |
> | aodv | 23.79 ± 0.65 | 8583.1 [8490.3, 8674.6] | 7.06 ± 0.19 |
> | aomdv | 18.09 ± 0.52 | 9301.6 [9257.5, 9346.6] | 10.39 ± 0.30 |
> | olsr | 8.68 ± 0.39 | 15.6 [14.6, 16.6] | 4.19 ± 0.19 |
> | dsdv | 10.90 ± 0.45 | 69.4 [41.8, 119.2] | 8.71 ± 0.36 |
> | gpsr | 16.29 ± 0.46 | 1712.2 [1586.1, 1846.3] | 3.44 ± 0.10 |
> | oracle | 30.79 ± 0.52 | 26.3 [25.7, 26.9] | 0.00 ± 0.00 |
>
> | AntHocNet minus | ΔPDR (pp) | Δdelay99 (ms) | ΔNRL |
> |---|---:|---:|---:|
> | aodv | +0.15 [-0.18, +0.47] | **-7933.6 [-8050.3, -7816.9]** | **+20.13 [+19.35, +20.90]** |
> | aomdv | **+5.85 [+5.46, +6.23]** | **-8652.0 [-8717.7, -8586.4]** | **+16.80 [+16.11, +17.49]** |
> | olsr | **+15.25 [+14.86, +15.64]** | **+634.0 [+589.4, +678.6]** | **+23.00 [+22.23, +23.78]** |
> | dsdv | **+13.04 [+12.73, +13.35]** | **+580.1 [+521.3, +639.0]** | **+18.49 [+17.82, +19.15]** |
> | gpsr | **+7.64 [+7.36, +7.92]** | **-1062.7 [-1194.3, -931.1]** | **+23.75 [+22.92, +24.58]** |
>
> The blocks below are the dated v2.2.0 record (quiet mode off). Their baseline
> rows are unchanged; where AntHocNet's numbers disagree with this block, this
> block is current. Diagnostic tables below (drop causes, paths, handovers,
> churn) describe the v2.2.0 runs.

## Results

**Provenance.** `paper-benchmark.yml` at `main` @ `1a923576` (the #536
merge), image `3.42-opt`, 900 s, seven arms (anthocnet, aodv, olsr, dsdv,
aomdv, gpsr, oracle), seeds 1–20 per cell, `--scenario=vanet` with the
inputs `nNodes`, `areaX=800`, `areaY=800`, `pause=0`, `speed=20`,
`propagation=urban`, `mobility=manhattan`; seeds split with
`extraArgs=--firstRun=N`.

| cell | runs |
|---|---|
| main (100 vehicles, 4 seeds per job) | [37638802518](https://github.com/danieljoppi/AntHocNet/actions/runs/37638802518) (1–4), [37638813699](https://github.com/danieljoppi/AntHocNet/actions/runs/37638813699) (5–8), [37638825144](https://github.com/danieljoppi/AntHocNet/actions/runs/37638825144) (9–12), [37638836620](https://github.com/danieljoppi/AntHocNet/actions/runs/37638836620) (13–16), [37638847225](https://github.com/danieljoppi/AntHocNet/actions/runs/37638847225) (17–20) |
| sparse (40 vehicles, 10 seeds per job) | [37638857489](https://github.com/danieljoppi/AntHocNet/actions/runs/37638857489) (1–10), [37638868141](https://github.com/danieljoppi/AntHocNet/actions/runs/37638868141) (11–20) |

Cells: `results/cells/vanet-{main,sparse}.txt`, 140 `##RUN##` rows
each (20 seeds × 7 arms). A main-cell job took 3.5–4 h (about 50 min per
seed, seven arms); a sparse-cell job 1.2–2 h.

**`scenario_check.py results`:** WARN only, 0 FAIL, on both cells. The WARNs
are the oracle's `approx=1` and partition notes, the #230 path-diversity
caveat, and the matched-hop note below. One rule did FAIL on the first read
and is now scoped, with its evidence:

> **The oracle matched-hop check is not a bound on a moving street grid.**
> On the packets every arm delivered, the oracle took 2.1–3.0 hops against
> every arm's ~1.0–1.2 (sparse cell, 20/20 seeds). That is the #506
> mechanism #519 scoped off 3-D fields: the "same" packet is forwarded at
> different instants in each arm (AODV's matched `delay99` is 8.8 s), and
> the oracle re-routes per hop over a graph whose links flip at every
> corner. **Control:** the same cell nearly static (0.01–0.02 m/s, 3 seeds)
> gives oracle 2.400 against AntHocNet 2.400, AODV 2.405, OLSR 2.411 — no
> excess, so the per-pair building rule is not missing links.
> `scenario_check.py` now reports the excess once per file as a WARN when
> `##CONFIG##` names `mobility=manhattan` above 1 m/s; a near-static grid
> keeps the FAIL as its control.

![VANET main and sparse cells: AntHocNet and AODV tie on delivery, AntHocNet's delay99 is about half of AODV's (main) and far lower (sparse), and its NRL is the highest of the arms that deliver comparably; the oracle line sits far above every arm on delivery](../charts/family-vanet.png)

_Reproduce: `make reproduce FIG=family-vanet` re-renders it from the committed data and diffs the PNG; `MODE=rerun NS3DIR=…` re-measures a cell first ([#621](https://github.com/danieljoppi/AntHocNet/issues/621))._

_Bars: mean of 20 seeds per arm, AntHocNet highlighted; whiskers: 95 % CI (t for PDR and NRL, bootstrap for delay99). The vertical line is the oracle control (not drawn for NRL, where it is 0 by construction). Drawn by [`ns3/tools/family-charts.py`](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/tools/family-charts.py) from the committed cells `vanet-{main,sparse}-v230-published.txt`: the v2.3.0 generation, whose tables are in the block above. The tables below are the dated v2.2.0 record._

Means ± 95 % t-CI half-width over 20 seeds; paired deltas are per seed
(t-CI, Wilcoxon p). Energy is per delivered bit.

### Main cell (`vanet`, 100 vehicles)

| protocol | PDR % | mean delay (ms) | `delay99` (ms) | NRL | energy (mJ/bit) |
|---|---|---|---|---|---|
| **anthocnet** | **42.10 ± 0.66** | 166.5 ± 3.7 | 1848 ± 43 | 73.59 ± 1.94 | 5.52 ± 0.11 |
| aodv | **42.26 ± 0.60** | 318.9 ± 11.2 | 3749 ± 48 | 60.45 ± 1.27 | 5.43 ± 0.09 |
| gpsr | 25.95 ± 0.50 | 34.5 ± 1.4 | 764 ± 42 | 5.39 ± 0.13 | 8.80 ± 0.21 |
| aomdv | 18.87 ± 0.48 | 1060.4 ± 28.9 | 9028 ± 49 | 73.60 ± 2.07 | 11.97 ± 0.35 |
| dsdv | 11.81 ± 0.38 | 23.5 ± 1.3 | 834 ± 44 | 66.64 ± 2.48 | 19.22 ± 0.72 |
| olsr | 9.19 ± 0.38 | 15.4 ± 1.7 | 184 ± 134 | 11.23 ± 0.52 | 24.53 ± 1.14 |
| oracle (100 ms) | 81.70 ± 0.45 | 18.8 ± 1.1 | 609 ± 71 | 0.00 | 2.74 ± 0.03 |

| AntHocNet minus | ΔPDR (pp) | ΔNRL | Δ`delay99` (ms) | Δenergy (mJ/bit) |
|---|---|---|---|---|
| aodv | −0.16 [−0.58, +0.26], p = 0.34 | +13.14 [+11.39, +14.89] | **−1901** [−1953, −1849] | +0.092 [+0.033, +0.151] |
| gpsr | **+16.15** [+15.77, +16.52] | +68.19 [+66.31, +70.08] | +1084 [+1023, +1145] | **−3.277** [−3.401, −3.153] |
| aomdv | **+23.23** [+22.77, +23.68] | −0.01 [−2.32, +2.30], p = 0.99 | **−7180** [−7250, −7110] | **−6.444** [−6.712, −6.175] |
| dsdv | **+30.28** [+29.83, +30.74] | +6.95 [+4.58, +9.32] | +1014 [+939, +1089] | **−13.698** [−14.337, −13.059] |
| olsr | **+32.91** [+32.47, +33.34] | +62.35 [+60.60, +64.11] | +1664 [+1538, +1790] | **−19.003** [−20.051, −17.955] |
| oracle | −39.60 [−40.19, −39.01] | +73.59 | +1239 [+1151, +1326] | +2.780 [+2.688, +2.871] |

Every interval that excludes zero has Wilcoxon p ≤ 9.6 × 10⁻⁵.

### Sparse cell (`--nNodes=40`, the partition regime)

| protocol | PDR % | mean delay (ms) | `delay99` (ms) | NRL | energy (mJ/bit) |
|---|---|---|---|---|---|
| **anthocnet** | **23.90 ± 0.56** | 35.1 ± 1.2 | 632 ± 35 | 27.22 ± 0.93 | 3.79 ± 0.09 |
| aodv | **23.79 ± 0.65** | 906.0 ± 22.9 | 8583 ± 101 | 7.06 ± 0.19 | 3.78 ± 0.10 |
| aomdv | 18.09 ± 0.52 | 1162.5 ± 32.2 | 9302 ± 50 | 10.39 ± 0.30 | 4.95 ± 0.14 |
| gpsr | 16.29 ± 0.46 | 99.4 ± 6.8 | 1712 ± 143 | 3.44 ± 0.10 | 5.80 ± 0.16 |
| dsdv | 10.90 ± 0.45 | 13.4 ± 2.0 | 69 ± 49 | 8.71 ± 0.36 | 8.31 ± 0.34 |
| olsr | 8.68 ± 0.39 | 6.0 ± 1.3 | 16 ± 1 | 4.19 ± 0.19 | 10.38 ± 0.46 |
| oracle (100 ms) | 30.79 ± 0.52 | 6.1 ± 0.3 | 26 ± 1 | 0.00 | 2.90 ± 0.05 |

AntHocNet minus AODV: ΔPDR +0.11 [−0.20, +0.42] (p = 0.32), ΔNRL +20.16
[+19.36, +20.95], Δ`delay99` **−7951 ms** [−8058, −7844]. AntHocNet leads
AOMDV, GPSR, DSDV and OLSR by +5.81, +7.60, +13.01 and +15.21 pp (all
20/20 seeds). Even the oracle delivers only 30.8 %: 40 vehicles on this grid
are partitioned most of the time, which is the cell's purpose.

### What the numbers say

- **AntHocNet ties AODV on delivery in both cells**, and every other arm
  trails both. This is the first family where AntHocNet does not lead
  delivery outright (see the four-family statement below).
- **The tail is AntHocNet's clear win over AODV**: half of AODV's
  `delay99` in the main cell and a thirteenth of it in the sparse cell. AODV
  buffers packets for seconds during route discovery; AntHocNet delivers or
  drops them sooner.
- **Overhead is AntHocNet's cost.** Its NRL is the highest of the arms that
  deliver comparably: +13.1 over AODV in the main cell, 3.9× AODV's in the
  sparse cell. It ties AOMDV's in the main cell. Energy per delivered bit is
  level with AODV (+0.09 mJ/bit) and far below every other arm.
- **The gap to the oracle is the widest of any family: 39.6 pp.** The oracle
  delivers 81.7 % on the same field, so the network is connected most of the
  time; the protocols lose the difference.

**Where AntHocNet's losses go** (drop decomposition, % of offered, mean over
the jobs' compact blocks):

| main cell | route (reconv / repair) | queue | MAC | channel | TTL |
|---|---|---|---|---|---|
| anthocnet | **39.9** (36.2 / 3.9) | 0.0 | 7.1 | 10.3 | 0.7 |
| aodv | 13.2 | 5.6 | 21.4 | 16.7 | 0.7 |
| oracle | 7.5 (partition) | 0.0 | 6.1 | 4.7 | 0.0 |

AntHocNet loses **36 % of its traffic to reconvergence**: packets that
arrive while a route is being re-established and outlive the 200 ms
`ReconvHoldCap`. The route-stability metrics (`##ROUTE##`, #294) show why:

| main cell | median route setup (s) | `pathChg` | median path lifetime (s) | mean hops |
|---|---|---|---|---|
| anthocnet | 1.17 ± 0.18 | 0.38 | **0.75** | 4.83 |
| aodv | 1.76 ± 0.33 | 0.23 | 1.32 | 3.56 |
| oracle | 0.27 | 0.42 | 0.50 | 3.72 |

Read the single-path arms for churn: AntHocNet's `pathChg` and path
lifetime also count its deliberate multipath spreading
([metrics.md](../metrics.md#route-stability-route-294-item-4-ns-3-only-udp-only)). The oracle's
shortest path changes every **0.50 s** (median) and AODV's routes live
**1.32 s**: the topology turns over in about one hello period. Buildings cut
line of sight the moment a vehicle turns a corner, so links die far sooner
than distance alone predicts. The #488 preflight's link-lifetime rule
(range / 2·speed = 10.6 hello periods) reasons from distance and
**overestimates link life on this channel**: it passed a cell whose shortest
paths change twice per hello period. AntHocNet's routes are also longer than
AODV's (4.83 against 3.56 hops), so each crosses more of those breaks.

This is the knob-watchlist item #301 named (`HelloInterval` vs link
lifetime, hold caps under corridor-shaped reconvergence). ADR-0019 forbids
retuning per family before a measured A/B, so it is recorded as a follow-up,
[#537](https://github.com/danieljoppi/AntHocNet/issues/537), not changed here: a paired `HelloInterval` / `ReconvHoldCap` A/B on
this cell, and a corner-aware link-lifetime rule for the preflight. Both have
since landed: the preflight rule in v2.2.0's phase 0, and the A/B in the
v2.2.0 campaign (the next section).

### Tuning for urban VANET (v2.2.0 campaign)

The [v2.2.0 campaign](../v2.2.0-campaign.md#results) ran #537's A/B on this
page's two cells, together with the hold-cap and link-metric arms, on the
same 20 seeds as the control. Each knob below **helps on this regime**. None
became a default, because each costs delivery in another family (ADR-0019;
[network-regimes.md §7](../../network-regimes.md#7-measured-the-v220-knobs-per-regime)).
If you run urban vehicular networks, these are measured settings to start from:

| attribute | main cell (100 vehicles) | sparse cell (40) | costs elsewhere |
|---|---|---|---|
| `ReconvHoldCap=1s` | PDR **+5.3 pp**, delay99 +210 to +340 ms | PDR **+6.2 pp**, delay99 +360 ms, NRL −3 to −4 | grid on Nakagami: PDR −1.4 to −6.0 pp |
| `HelloInterval=500ms` | PDR **+1.9 pp**, delay99 −15 % | PDR +0.5 pp, delay99 −100 ms, NRL +1.7 | MANET grid: PDR −0.5 to −8 pp |
| `RepairHoldCap=200ms` | PDR **+1.1 pp**, delay99 **−1.1 s**, NRL −11 | PDR −0.2 pp, delay99 −340 ms | grid two-ray, sparse FANET: PDR −0.3 to −1.0 pp |
| `LinkMetric=sinr` | **avoid**: PDR −1.6 pp, delay99 +1 s, NRL +13 | PDR +0.4 pp, delay99 +1.5 s | — |

The ns-3 attribute prefix is `--ns3::anthocnet::RoutingProtocol::`.

**The knobs were measured one at a time, never combined.** The pre-registered
`combined` arm runs only when two defaults move, and none did. Their gains are
not known to add.

**None of them closes the reconvergence gap.** At best a knob claws back
5–6 pp of the 39.6 pp to the oracle. The loss is set by link lifetime at
corners (above), which no timer fixes. That is why v2.3.0's link-lifetime
mechanism ([#574](https://github.com/danieljoppi/AntHocNet/issues/574)) keeps its place.

### Threats to validity

- **Radio.** 802.11b at 2.4 GHz with Sommer constants fitted at 5.9 GHz
  (Provenance). Buildings here are, if anything, slightly too opaque.
- **Mobility.** One speed per block leg and no stops (traffic lights,
  queues): real urban traffic clusters at intersections, which this model
  does not.
- **The oracle.** `approx=1`, and its matched-hop numbers are not a bound on
  a moving grid (above). Its delivery is a bound here: it leads every arm on
  every seed in both cells.
- **No Veins confirmation.** The Veins/SUMO arm (#485) is deferred with the
  OMNeT++ adapter; these numbers are ns-3 only.
- **GPCR is a reimplementation.** No reference code was used. Its paper
  leaves two constants open (ε, the street cone); they are set here and
  disclosed [above](#the-junction-aware-comparator-gpcr-709). The
  neighbour-table junction test and the paper's proposed street-connectivity
  probing are not implemented.

## Ranking stability across six families

ADR-0019 keeps AntHocNet's configuration identical across families, so a
ranking that changes between them is a property of the network. From v2.4.0
the statement is read in two terms that need no migrated protocol
([#711](https://github.com/danieljoppi/AntHocNet/issues/711),
[ADR-0026](../../adr/0026-baselines-are-family-native.md)): AntHocNet's gap
to each cell's oracle, and AntHocNet against each cell's best native baseline
(highest mean PDR), both paired per seed. The numbers are the
[v2.4.0 control campaign](../v2.4.0-campaign.md#results), 20 seeds per cell.

![AntHocNet against each family's own yardsticks: its paired PDR gap to the oracle and to the best native baseline, in every cell of six families](../charts/families-native.png)

_Each dot is the mean over 20 paired seeds with its 95 % paired t-CI; filled = the CI excludes 0. Drawn by [`ns3/tools/family-charts.py`](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/tools/family-charts.py) from the committed v2.4.0 cells; the numbers come from [`tools/bench/native_view.py`](https://github.com/danieljoppi/AntHocNet/blob/main/tools/bench/native_view.py)._

| family | best native baseline | AntHocNet − best native, PDR | AntHocNet − oracle, PDR |
|---|---|---|---|
| MANET grid (6 cells) | OLSR (AODV on Gauss-Markov/two-ray) | **+5.8 … +11.3 pp**, every cell | +0.5 … +0.6 pp on two-ray; −4.2 … −8.0 pp on Nakagami |
| static mesh | OLSR | **−0.65 pp** | −0.60 pp |
| FANET | 3-D GPSR (main), AODV (sparse) | **+6.20 pp** (main), **+2.52 pp** (sparse) | −2.41 pp (main), −7.70 pp (sparse) |
| VANET | AODV | tie (−0.16 and +0.15 pp, CIs straddle 0) | **−39.6 pp** (main), −6.85 pp (sparse) |
| ISL grid (4 cells) | none measured (OPSPF deferred) | — | 0.00 pp, every cell |
| LEO shells (3) | OPSPF | **−6.17 pp** (walker16), **−17.48 / −16.94 pp** (Starlink S1, storm) | −5.62 pp (walker16), −15.9 pp (S1); the 1 s hop oracle is not a bound there (#720) |

**What holds across families:**
- **AntHocNet leads delivery on open mobile fields**: every MANET cell and
  both FANET cells, against each family's strongest native protocol.
- **Its tail is shorter than the best native baseline's wherever links break
  abruptly**: −1.3 to −1.6 s on the Nakagami grid cells, −1.9 and −7.9 s on
  VANET, −4.7 s on sparse FANET.

**What does not hold:**
- **On stable topologies, link state wins.** OLSR leads the static mesh and
  OPSPF leads every LEO shell. The OPSPF lead is large on Starlink S1
  (−17.5 pp), bought with 20× AntHocNet's control.
- **On the street grid nothing native beats AODV, and neither does
  AntHocNet.** It ties AODV, and the geographic comparators (GPSR, GPCR)
  trail both. VANET main's 39.6 pp gap to the oracle is still the largest in
  the corpus.
- **The overhead ordering is family-dependent.** AntHocNet sends less
  control than AODV on the MANET grid (−23.9 NRL on Gauss-Markov/two-ray)
  but more than OLSR in every family OLSR runs in, and more than AODV on
  VANET (+13.2 / +20.1).

### Dated record: AntHocNet − AODV across four families (v2.3.0)

The statement below is the v2.3.0 generation, read against AODV in every
family. AODV is no longer a baseline on the static mesh or the satellite
cells (ADR-0026), so this view is retired. Its numbers stand as measured;
the chart it read (`families-vs-aodv.png`) is replaced by the one above.

| | MANET grid (6 cells) | static mesh | FANET main | VANET main |
|---|---|---|---|---|
| delivery leader | **AntHocNet**, every cell | **OLSR** (+0.49 pp over AntHocNet), DSDV +0.32 | **AntHocNet** (+8.32 pp over AODV) | **AntHocNet = AODV** (−0.16 pp, p = 0.34) |
| AntHocNet vs AODV, PDR | +10.8 … +21.0 pp | +2.05 pp | +8.32 pp | tie |
| AntHocNet vs AODV, NRL | −23.9 … −28.0 | −13.0 | −0.36 | **+13.1** |
| AntHocNet vs AODV, `delay99` | −164 … −372 ms | −205 ms | −293 ms | −1901 ms |
| gap to the oracle (PDR) | AntHocNet above it on two-ray; 4.2–8.0 pp below on Nakagami | 0.6 pp | 2.45 pp | **39.6 pp** |
| OLSR | 78–89 % | **leads** | 47.9 % | 9.2 % (last) |

**What holds in every family:**
- **AntHocNet beats AODV on the tail.** `delay99` is lower in every cell of
  every family, from −164 ms (MANET) to −1901 ms (VANET).
- **AntHocNet delivers at least as much as AODV** everywhere, and strictly
  more everywhere except VANET.

**What does not hold:**
- **"AntHocNet delivers most" is a claim about open mobile fields.** It
  holds on every MANET cell and both FANET cells. It fails on the static mesh
  (OLSR and DSDV lead) and becomes a tie with AODV on the street grid.
- **AntHocNet's overhead advantage over AODV vanishes and reverses as links
  shorten.** −24 to −28 NRL on MANET, −13 on the static mesh, −0.4 on FANET,
  **+13.1 on VANET**: its proactive ants and repair keep sampling links that
  live under one hello period.
- **OLSR is the family-sensitive protocol.** It leads the static mesh,
  delivers 78–89 % on MANET, 47.9 % on FANET and 9.2 % on VANET: its
  topology tables hold next hops that a corner or a fast flight has already
  broken.
- **The distance to the oracle grows with how abruptly links break**: none
  on two-ray MANET, a few points on Nakagami and FANET, 39.6 pp when
  buildings cut links at every corner. VANET is where a better protocol has
  the most room, and where AntHocNet's reconvergence (36 % of its losses) is
  the measured place to look.

## Provenance of the numbers

Per-seed rows: `results/cells/vanet-{main,sparse}.txt`. Statistics
from `stats_util` (t-CI, Wilcoxon signed-rank). Drop decomposition from the
`# drops` compact blocks, `##ROUTE##` from the per-seed rows. Reproduce with
`paper-benchmark.yml` at `1a923576` and the inputs in the provenance block
above.
