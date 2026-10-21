# Scenario: disaster

**Class:** disaster / emergency response: first-responder teams in a partly
walled incident area, moving by role ([#580](https://github.com/danieljoppi/AntHocNet/issues/580), family axis III)

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

> **A separate family, not a variant of the MANET corpus.** Nodes move by
> role between the zones of a disaster site, and walls shadow the teams
> working indoors. Its cells are **not comparable** with the MANET pages:
> read them against each other and against this page's
> [gate](#the-gate), never against the Broch floor, which is RWP-only.

## What it stresses

MANET comparisons under disaster-area mobility find that connectivity
"varies widely enough to be hard for current routing protocols"
(Raffelsberger & Hellwagner, WISES 2012). No other family here has the two
things that cause it:

- **Structured, role-driven motion.** Firefighters stay inside the fire
  compartments. Medics shuttle casualties from there to the treatment area.
  Ambulances run between the treatment area, the transport zone and the
  hospital. Who is connected to whom follows the operation's rhythm, not a
  random walk.
- **Indoor/outdoor shadowing.** Every link out of a fire compartment crosses
  its walls. A team inside may hold only a chain of links back to the door,
  and that chain breaks when a carrier walks away.

The partition and re-merge machinery that
[partition-merge](partition-merge.md) gates in isolation (#62) is exercised
here under realistic motion.

## The scene

The structure is the disaster-area mobility model of **Aschenbruck,
Gerhards-Padilla & Martini** ("Modelling mobility in disaster area
scenarios", MSWiM 2007). It is laid out as Ben Arbia et al. apply it to a
shopping-mall fire ("Behavior of wireless body-to-body networks routing
strategies for public protection and disaster relief", arXiv:1711.10838):
two fire seats at opposite ends of the mall, rescuers in role groups, and
every team reporting to one command post at the main gate. The scene is
generated, not built in: `tools/bench/disaster_scene.py gen --seed 1`. That
seed is committed as `ns3/tools/fixtures/disaster/`, and CI checks the
committed files against the generator.

| zone (Aschenbruck et al.) | here | who is there, and how they move |
|---|---|---|
| incident site | two walled fire compartments, 200 × 160 m each, at the mall's west and east ends (x 120–320 and 680–880, y 170–330) | 10 firefighters per compartment, random waypoint inside it at 0.3–1.5 m/s (in smoke), pauses 0–60 s |
| (route between them) | the open mall concourse and the main gate at (500, 150) | 5 medics per compartment, shuttling compartment → gate → treatment area at 0.8–1.2 m/s (carrying), 30–90 s at the casualty, 60–180 s at the treatment area |
| casualty treatment area | 160 × 90 m outside the gate (x 280–440, y 30–120) | 6 treatment staff, random waypoint inside it at 0.3–1.0 m/s, pauses 10–90 s |
| transport zone | 160 × 70 m (x 620–780, y 30–100) | 4 ambulances: load at the treatment area (60–120 s), stage (20–60 s), leave for the hospital at the field's corner and return after 120–240 s, at 10 m/s |
| technical operational command | the command post at (500, 60), static | node 0, the sink |
| (perimeter) | 20 m outside the mall's corners | 6 police / civil-defence officers patrolling at 1–2 m/s |

47 nodes on a 1000 × 500 m field, 900 s.

**Traffic.** Every team reports to the command post, and the command post
sends orders back (Ben Arbia et al.: all rescuers send to one sink at the
main gate, at one packet per second). There are 16 uplink flows: 8
firefighters (4 per compartment), 4 medics, 2 treatment staff and 2 police.
There are 4 downlink flows, to one firefighter per compartment, one medic and
one treatment-staff member. Each flow is CBR at 1 × 64 B/s (512 bit/s) and
starts in [0, 30] s.

**Channel.** The urban channel (`--propagation=urban`): VANET's two-ray path
loss at 2.4 GHz, plus the obstacle shadowing of Sommer et al. 2011 (9 dB per
wall cut, 0.4 dB per metre inside). Here it runs over an explicit building
list, `--buildings=120,170,320,330;680,170,880,330`: the two fire
compartments, in place of the street grid's blocks. The radio is the
corpus's 802.11b at 2 Mbit/s (ADR-0019: a family changes the scenario, not
the stack).

**One layout was rejected before any comparison.** A shell over the whole
mall (100–900 × 150–350 m) cut every indoor team off from the gate: even the
oracle delivered 42 % (seed 1, 300 s), and AODV 41.7 %. That cell measures
the partition, not routing. The mall is open-plan, so only the burning
compartments are walled.

**The preset.** `--scenario=disaster` replays the scene: it requires
`--traceFile`, `--flowsFile` and `--buildings`, defaults to the urban
channel and 900 s, and sets the oracle's recompute cadence to 100 ms. Links
open and close at the compartment walls as people walk through the doors,
the VANET corner case on foot (#506 rule).

## Native baselines (ADR-0026)

Declared on #580 before the first campaign (maintainer decision 2026-10-20):

- **AODV and OLSR.** The disaster/emergency-MANET literature uses both as
  its standard baselines.
- **The oracle**, as the bound.
- **No store-carry-forward (DTN) arm yet.** It is conditional, per #580's
  acceptance criterion: if the oracle also loses packets to the partition,
  a DTN arm is filed as follow-up work with that data.

## The gate

`tools/checks/check-disaster.sh` runs on the ns-3.42 CI leg, 300 s and 2
seeds, with thresholds in `ns3/tools/anchors.yml`. Measured locally:

| check | threshold | measured |
|---|---|---|
| the committed scene is what the generator writes | byte-identical | yes |
| the oracle with the walls' loss zeroed (the field's ceiling) | ≥ 90 % | 100.0 % |
| what the walls cost the oracle | ≥ 8 pp | 25.9 pp |
| AntHocNet / AODV / OLSR route on the walled scene (#439) | ≥ 50 % each | 71.7 / 68.7 / 63.1 % |

A channel that ignored `--buildings` would read the same with and without
walls. A scene that left nobody indoors would cost nothing.
`scenario_check.py preflight --buildings …` checks the buildings against the
field. It reports how many nodes start indoors (20 of 47 here), and it WARNs
when none do.

## Measured while building it

These are 2 seeds of the full 900 s scene, not the published cell:

| protocol | PDR % | NRL |
|---|---|---|
| oracle | 81.4 / 81.5 | 0 |
| AntHocNet | 77.1 / 78.6 | 10.0 / 9.7 |
| AODV | 77.0 / 77.8 | 9.0 / 8.4 |
| OLSR | 65.9 / 67.0 | 2.5 / 2.5 |
| oracle, walls' loss zeroed | 99.4 (seed 2) | 0 |

**The oracle loses about 19 % to the partition.** It routes on the true
graph, so these packets have no path when they are sent. That is the
condition #580 names for the store-carry-forward follow-up. It is filed as
[#727](https://github.com/danieljoppi/AntHocNet/issues/727) with these
numbers, and the campaign below measures it at 20 seeds.

## Pre-registered campaign

The plan is
[`tools/bench/campaigns/v2.4.0-disaster.yaml`](https://github.com/danieljoppi/AntHocNet/blob/main/tools/bench/campaigns/v2.4.0-disaster.yaml).
It is merged before its first dispatch, as every campaign here is:

- **one cell,** `disaster-main`: the committed scene, 900 s, harness seeds
  1–20 in two 10-seed blocks;
- **protocols:** AntHocNet, AODV, OLSR and the oracle, at the shipped
  defaults, on `ns3:3.42-opt`.

**The readings**, fixed now, are v2.4.0's:

- AntHocNet − oracle;
- AntHocNet − the best native baseline (highest mean PDR, ties by delay99),
  paired per seed (`tools/bench/native_view.py`).

The family joins the cross-family view (#711) with that cell, so the
statement on the [VANET page](vanet.md#ranking-stability-across-six-families)
then reads seven families. One scene seed is a disclosed threat (below).

## The tactical narrowband cell: deferred

#580 also asks for one tactical narrowband cell (9.6–64 kbit/s radios), where
control overhead is the binding cost. Stock ns-3 has no substrate for it:

- Wi-Fi bottoms out at 1 Mbit/s (802.11b DSSS), about 60× a 16 kbit/s
  radio, so overhead would never bind.
- The narrowband devices (LR-WPAN, LTE) do not carry the harness's IPv4
  routing.

The maintainer moved it to v2.5.0 (decision 2026-10-20).
[#726](https://github.com/danieljoppi/AntHocNet/issues/726) tracks the
narrowband channel it needs.

## Threats to validity

- **One scene seed.** The 20 harness seeds vary the MAC, the protocols and
  the traffic starts, not the motion. A second scene seed is a cheap
  follow-up; it is not in this campaign.
- **The layout is a recorded assumption.** Zone sizes, positions and team
  sizes are chosen to follow the model's roles at an affordable node count
  (47, against Ben Arbia et al.'s 100). They are not a measured incident.
- **The walls are Sommer et al.'s,** fitted for buildings at 5.9 GHz and
  used here at 2.4 GHz, as on VANET. A fire compartment's real walls are
  heavier, and smoke is not modelled.
- **No DTN arm** ([#727](https://github.com/danieljoppi/AntHocNet/issues/727)), see above.
