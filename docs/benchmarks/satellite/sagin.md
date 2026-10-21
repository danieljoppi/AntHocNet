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
