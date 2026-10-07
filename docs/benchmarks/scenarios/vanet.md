# Scenario: vanet

**Class:** VANET — vehicles on a street grid, corridor-shaped links, buildings that cut line of sight ([#301](https://github.com/danieljoppi/AntHocNet/issues/301), [#488](https://github.com/danieljoppi/AntHocNet/issues/488))

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

> **A separate family, not a variant of the MANET corpus.** Vehicles move on
> the 1-D streets of a 2-D grid, and the radio is shadowed by the buildings
> between the streets. Its cells are **not comparable** with the MANET pages:
> read them against each other and against the [VANET anchors](#anchors),
> never against the Broch floor, which is RWP-only.

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
python3 .claude/skills/benchmark-results/scenario_check.py preflight \
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
([`ns3/tools/check-anchors.sh`](../../../ns3/tools/check-anchors.sh), floors in
[`ns3/tools/anchors.yml`](../../../ns3/tools/anchors.yml)). Both run the preset
shrunk to a single 280 × 280 m block with 20 vehicles, and route only stock
AODV and the oracle control.

| anchor | field | expected (derived) | measured | what it checks |
|---|---|---|---|---|
| `vanet-single-hop` | one block, street width 279 m (a 1 m building) | the 396 m block diagonal is inside the 423.3 m two-ray decode radius and no line of sight is cut, so every flow is one hop: **PDR ≈ 100 %**, oracle **hopsMean ≈ 1.00** | AODV 99.5 %, oracle 99.9 %, hopsMean 1.00 | the street grid, mobility and channel deliver at all |
| `vanet-building` | one block, street width 100 m (a 180 × 180 m building) | vehicles on opposite streets lose line of sight and must relay around a corner: oracle **hopsMean > 1.2**; a channel that ignored the building reads the single-hop 1.00 | AODV 80.4 %, oracle 99.6 %, hopsMean 1.36 | the buildings are honoured end to end |

The harness's own CI smoke (`ns3/tools/check-manhattan.sh`) adds the
invariants the anchors do not: every vehicle is on a street at t = 0 and
mid-run, every arm delivers on the urban field, the oracle keeps 66 edges
against 236 under plain two-ray on the same field, and a same-seed rerun is
byte-identical.

## The oracle on the street grid

The oracle derives its graph per pair under this channel (`decode-los-approx`,
[ns3/oracle/README.md](../../../ns3/oracle/README.md)): inside the two-ray
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

## Results

The 20-seed campaign (every arm, both cells) is the next step of #488 and
lands on this page with the cross-family ranking-stability statement.
