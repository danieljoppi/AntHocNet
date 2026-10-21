# Satellite suite: space-air-ground (SAGIN)

**Regime:** three link layers with very different delays and lifetimes. The
ground stations reach a moving LEO shell only through a layer of
high-altitude platforms (HAPS) ([#581](https://github.com/danieljoppi/AntHocNet/issues/581), family axis III).

[← Benchmark index](../../benchmarks.md) · [The moving constellation](leo-walker.md) ·
[Metrics](../metrics.md) · [Methodology](../methodology.md)

## What it stresses

Routing across vertically heterogeneous layers is an open problem (the
SAGIN surveys arXiv:2002.08811 and arXiv:2510.19731). The
[leo-walker](leo-walker.md) cells give each station one access link to the
shell. Here a station has several ways up, through any of its city's HAPS,
and each HAPS hands over between satellites on its own schedule. The routes a
protocol must find now cross three layers:

| layer | links | delay | lifetime |
|---|---|---|---|
| ground → air | station ↔ each of its city's HAPS, 152 km | 0.5 ms | fixed |
| air ↔ air | each HAPS ↔ its ring neighbours, 261 km | 0.9 ms | fixed |
| air → space | each HAPS ↔ its serving satellite, elevation ≥ 25° | 4–9 ms | until the next handover (15 s clock) |
| space ↔ space | the +grid ISLs of [leo-walker](leo-walker.md#the-cells) | 5–10 ms | moving; 1 % failure overlay |

## The scene

`leo-walker --sagin` builds on the moving-constellation harness and keeps
its shells, cities, flows, handover clock and failure overlay. Each city
gets `--haps` HAPS (default 3) at `--hapsAltitude` km (default 20, the
stratospheric layer). They sit on a ring of `--hapsRing` km (default 150)
around the city, at bearings 0°, 120° and 240°.

**Links.** Each station is linked to all three of its HAPS, and each HAPS
to its two ring neighbours, by fixed point-to-point links at the access rate
(10 Mbit/s) and the propagation delay of their length. The ring links clear
the Earth's limb: 261 km, against 1010 km for two platforms at 20 km. The
harness checks this and prints it as `# anchor sagin`.

**Access.** The platforms, not the stations, hold the space segment. Each
HAPS has the elevation-gated, clock-driven access segment a station holds in
the plain cells, so the ground reaches space only through the air layer.

**Arms.** Every arm routes end to end over all three layers (maintainer
decision 2026-10-20). geo-greedy's location service also names, per station
and HAPS, the neighbour that leads up (`g_uplink`).

## Native baselines (ADR-0026)

Declared on #581 before the first campaign (maintainer decision 2026-10-20).
AODV and OLSR are not arms in this family.

- **OPSPF** ([#707](https://github.com/danieljoppi/AntHocNet/issues/707))
  and **geo-greedy**, for the space layer.
- **gpsr3d** ([#710](https://github.com/danieljoppi/AntHocNet/issues/710)),
  for the air layer. This is the vendored GPSR's ThreeD mode, with two
  disclosed changes so it runs here (`ns3/baselines/gpsr/README.md`):
  - it forwards on every interface, not only interface 1;
  - it reads each node's position on one common sphere, latitude and
    longitude only. On raw Earth-centred positions it delivered 0 %, because
    the chord between two cities runs through the Earth.
- **The hop and delay oracles**, as the bounds. The hop oracle is not a
  delivery bound on cells with unpredicted failures
  ([#720](https://github.com/danieljoppi/AntHocNet/issues/720)).

## The gate

Step 10 of `tools/checks/check-leo-walker.sh` (ns-3.48 CI leg), on walker16
with the air layer:

- `# anchor sagin` is present;
- every HAPS sees the shell;
- oracle-delay delivers ≥ 95 %, AntHocNet ≥ 80 %, OPSPF ≥ 95 % and
  gpsr3d ≥ 5 % (measured 99.7, 89.4, 99.9 and 16.9 % on 60 s, seed 1);
- with no unpredicted failure, OPSPF's rows equal the hop oracle's. Its
  predicted knowledge covers the fixed air links.

The rest of the smoke covers the shell itself (geometry, handovers,
determinism, order independence).

## Measured while building it

walker16 with the air layer, 300 s, `--islDown=0.01`, 2 seeds. This is
not the published cell:

| arm | PDR % | delay99 ms | NRL |
|---|---|---|---|
| oracle-delay | 99.87 / 99.75 | 98 | 0 |
| OPSPF | 99.94 / 99.98 | 124 | 556 / 541 |
| hop oracle | 98.80 / 98.82 | 124 | 0 |
| AntHocNet | 93.51 / 93.60 | 114 / 132 | 114 / 125 |
| gpsr3d | 40.67 / 41.13 | 85 | 198 / 197 |
| geo-greedy | 39.51 / 39.97 | 84 | 0 |

Against the plain walker16 cell (v2.4.0, 20 seeds), AntHocNet goes from
92.74 % without the air layer to about 93.5 % with it, so the extra ways up
do not cost it. OPSPF stays ahead. Both geographic arms are about 40 %, the
structural greedy dead ends of a +grid shell.

## Pre-registered campaign

The plan is
[`tools/bench/campaigns/v2.4.0-sagin.yaml`](https://github.com/danieljoppi/AntHocNet/blob/main/tools/bench/campaigns/v2.4.0-sagin.yaml),
merged before its first dispatch:

- **cells:** the three LEO shells with `--sagin` (walker16, Starlink S1,
  the S1 storm);
- **arms:** AntHocNet, OPSPF, gpsr3d, geo-greedy, the hop oracle and the
  delay oracle;
- **runs:** 20 seeds each, one job per (shell, protocol), 18 jobs, on
  `ns3:3.48`.

**The readings** are v2.4.0's: AntHocNet − oracle, and AntHocNet − the best
native baseline, paired per seed (`tools/bench/native_view.py`). The family
joins the cross-family view (#711) with these cells.

## Results (v2.4.0)

The pre-registered campaign, as planned: the three shells with `--sagin`, 20
seeds each, six arms, on `ns3:3.48`. The two Starlink gpsr3d cells ran in
2-seed blocks. Their first 20-seed job needed about 55 min a seed and hit
the 6 h runner limit
([#738](https://github.com/danieljoppi/AntHocNet/pull/738)); only the job
split changed. The cells are `results/cells/sagin-*-v240.txt`.
`scenario_check.py results`: OK, 0 FAIL, 0 WARN, per file and per cell.

Mean over 20 seeds, PDR with its 95 % t-interval:

| arm | walker16 PDR % | delay99 ms | NRL | Starlink S1 PDR % | delay99 ms | NRL | S1 storm PDR % | delay99 ms | NRL |
|---|---|---|---|---|---|---|---|---|---|
| **AntHocNet** | 93.11 ± 0.36 | 116.9 | 122 | 82.07 ± 0.61 | 181.4 | 1221 | 80.57 ± 1.01 | 193.9 | 1369 |
| OPSPF | 99.05 ± 1.43 | 124.0 | 549 | 99.18 ± 0.58 | 109.0 | 19240 | 98.31 ± 1.04 | 125.2 | 16240 |
| gpsr3d | 40.26 ± 0.33 | 86.0 | 201 | 5.04 ± 0.13 | 51.0 | 8662 | 4.94 ± 0.75 | 62.9 | 11155 |
| geo-greedy | 39.51 ± 0.25 | 84.2 | 0 | 1.22 ± 0.06 | 110.6 | 0 | 0.74 ± 0.79 | 28.6 | 0 |
| hop oracle | 98.72 ± 0.12 | 124.0 | 0 | 97.01 ± 0.23 | 109.0 | 0 | 96.84 ± 0.22 | 123.0 | 0 |
| delay oracle | 99.82 ± 0.02 | 98.0 | 0 | 96.66 ± 0.19 | 103.1 | 0 | 96.67 ± 0.21 | 107.7 | 0 |

**The readings**, paired per seed (`tools/bench/native_view.py`):

| shell | AntHocNet − hop oracle (pp) | AntHocNet − OPSPF, the best native (pp) | d delay99 (ms) | d NRL | verdict |
|---|---|---|---|---|---|
| walker16 | −5.61 [−6.00, −5.23] | −5.95 [−7.42, −4.47] | −7.10 [−11.25, −2.85] | −427 [−441, −414] | PAIRED-MIXED |
| Starlink S1 | −14.94 [−15.61, −14.27] | −17.11 [−17.83, −16.40] | +72.35 [+64.95, +79.50] | −18019 [−18195, −17844] | PAIRED-MIXED |
| S1 storm | −16.27 [−17.26, −15.28] | −17.74 [−19.14, −16.35] | +68.65 [+55.80, +80.60] | −14871 [−15185, −14557] | PAIRED-MIXED |

What they say:

- **OPSPF leads every shell, as on the plain LEO cells.** It delivers 6–18 pp
  more than AntHocNet, at 4.5× (walker16) to 16× (Starlink) its control.
  OPSPF also sits above both 1 s oracles on the Starlink shells. Neither is
  a delivery bound with unpredicted failures
  ([#720](https://github.com/danieljoppi/AntHocNet/issues/720)), which
  holds for the delay oracle here as for the hop oracle on the LEO page.
- **AntHocNet is far ahead of the geographic arms.** It leads gpsr3d by
  +52.9 pp on walker16 and +77.0 / +75.6 pp on Starlink. On the 1584-satellite
  shell, greedy forwarding collapses: gpsr3d delivers 5 % and geo-greedy
  1 %. On walker16 they reach about 40 %, the structural dead ends of a
  +grid shell. gpsr3d's control also grows to 8662–11155 NRL on Starlink,
  7–8× AntHocNet's.
- **The air layer helps every routing arm a little.** On the same shells
  without it (the [LEO page](leo-walker.md), v2.4.0), AntHocNet delivers
  92.74 / 79.34 / 79.17 % and OPSPF 98.90 / 96.82 / 96.12 %. With the HAPS
  layer, AntHocNet delivers 93.11 / 82.07 / 80.57 % and OPSPF 99.05 / 99.18 /
  98.31 %. These are different scenarios on the same seeds, so they are
  compared by their means, not paired.

The family joins the cross-family view
([VANET page](../scenarios/vanet.md#ranking-stability-across-the-families))
as the eighth family.

## Threats to validity

- **HAPS only, no UAV relays.** The layer is stratospheric platforms on
  fixed links. A UAV swarm under each HAPS, as an 802.11 access network, was
  considered and set aside (maintainer decision 2026-10-20): it needs a
  mixed-device harness and per-layer protocols.
- **The air layer never fails.** Only the ISL overlay and the storm's mass
  failure are unpredicted. Weather outages on the air-to-space links are not
  modelled.
- **The geometry is a recorded assumption:** three platforms per city on a
  150 km ring at 20 km.
- **gpsr3d is adapted** (above). Its numbers measure greedy-geographic
  routing on this geometry, not GPSR as published.
- **OPSPF's LSA floods are accounted, not transmitted** (the LEO page's
  [opspf section](leo-walker.md#opspf-the-link-state-incumbent-707)), as on
  the plain shells.
