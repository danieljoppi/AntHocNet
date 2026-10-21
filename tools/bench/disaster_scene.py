#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""The disaster-area scene (#580): generate the trace, flows and buildings.

The structure follows the disaster-area mobility model of Aschenbruck,
Gerhards-Padilla & Martini (MSWiM 2007), as later applied to a shopping-mall
fire (Ben Arbia et al., arXiv:1711.10838). The incident area is split by
role:

- the **incident site**, two fire seats at opposite ends of one building,
  where firefighter teams work indoors;
- the **casualty treatment area** (CTA) outside, where medics bring the
  injured and treatment staff work;
- the **transport zone** (TZ), where ambulances load and leave;
- the **command post** (technical operational command), the one sink every
  team reports to.

Teams move inside their own zone, and carriers shuttle between zones, so
connectivity changes with the operation's phases rather than at random. The
mall's concourse is open; the two fire compartments are walled. Their walls
shadow everyone working inside: the scene runs on the urban channel, and the
building list given to `--buildings` (the two compartments) replaces the
street grid (Sommer et al. 2011, 9 dB per wall cut and 0.4 dB per metre
inside). A shell over the whole mall was tried and rejected: it cut every
indoor team off, so even the oracle delivered 42 % and the cell measured the
partition, not routing (docs/benchmarks/scenarios/disaster.md).

    disaster_scene.py gen --out DIR [--seed 1]
        DIR/disaster.ns2        ns-2 movement trace (--mobility=trace)
        DIR/disaster.flows      flows (--flowsFile)
        DIR/disaster.buildings  the --buildings value (one line)

Run it as:

    anthocnet-compare --scenario=disaster --traceFile=DIR/disaster.ns2 \\
        --flowsFile=DIR/disaster.flows --buildings="$(cat DIR/disaster.buildings)"

The values are recorded with their sources in
docs/benchmarks/scenarios/disaster.md.
"""

import argparse
import math
import os
import random
import sys

FIELD = (1000.0, 500.0)
SIM_TIME = 900.0
# The mall's footprint, and the two walled fire compartments inside it at its
# opposite ends (Ben Arbia et al.: "a fire in two opposite sides in the mall").
# Only the compartments are buildings for the channel; MALL places the gate
# and the police patrol.
MALL = (100.0, 150.0, 900.0, 350.0)
SEATS = [(120.0, 170.0, 320.0, 330.0), (680.0, 170.0, 880.0, 330.0)]
GATE = (500.0, 150.0)          # the main entrance, on the mall's south wall
GATE_IN = (500.0, 165.0)       # just inside it
COMMAND = (500.0, 60.0)        # the command post, outside the main gate
CTA = (280.0, 30.0, 440.0, 120.0)
TZ = (620.0, 30.0, 780.0, 100.0)
EXIT = (990.0, 20.0)           # where ambulances leave for the hospital

FIREFIGHTERS = 10              # per seat
MEDICS = 5                     # per seat
CTA_STAFF = 6
AMBULANCES = 4
POLICE = 6

WALK = (0.3, 1.5)              # m/s, firefighters indoors in smoke
CARRY = (0.8, 1.2)             # m/s, medics carrying a casualty
STAFF = (0.3, 1.0)
PATROL = (1.0, 2.0)
DRIVE = 10.0                   # m/s, ambulances on site
PKT_BPS = 512                  # 1 x 64 B per second (Ben Arbia et al.: 1 packet/s)


class Track:
    """One node's piecewise-linear course as ns-2 setdest commands."""

    def __init__(self, i, x, y):
        self.i, self.x, self.y, self.t = i, x, y, 0.0
        self.lines = [f"$node_({i}) set X_ {x:.3f}", f"$node_({i}) set Y_ {y:.3f}",
                      f"$node_({i}) set Z_ 0.000"]

    def go(self, x, y, v):
        if self.t >= SIM_TIME:
            return
        self.lines.append(f'$ns_ at {self.t:.3f} "$node_({self.i}) setdest {x:.3f} {y:.3f} {v:.3f}"')
        self.t += math.hypot(x - self.x, y - self.y) / v
        self.x, self.y = x, y

    def wait(self, s):
        self.t += s


def inside(rng, box, margin=2.0):
    x0, y0, x1, y1 = box
    return rng.uniform(x0 + margin, x1 - margin), rng.uniform(y0 + margin, y1 - margin)


def roam(rng, tr, box, speed, pause):
    while tr.t < SIM_TIME:
        tr.wait(rng.uniform(*pause))
        tr.go(*inside(rng, box), rng.uniform(*speed))


def gen(out_dir, seed):
    rng = random.Random(seed)
    tracks = []

    def node(x, y):
        tr = Track(len(tracks), x, y)
        tracks.append(tr)
        return tr

    node(*COMMAND)  # 0: the command post, static
    roles = {"command": [0], "firefighter": [], "medic": [], "cta": [], "ambulance": [],
             "police": []}
    for seat in SEATS:
        for _ in range(FIREFIGHTERS):
            tr = node(*inside(rng, seat))
            roles["firefighter"].append(tr.i)
            roam(rng, tr, seat, WALK, (0.0, 60.0))
    for seat in SEATS:
        for _ in range(MEDICS):
            tr = node(*inside(rng, CTA))
            roles["medic"].append(tr.i)
            tr.wait(rng.uniform(0.0, 120.0))  # squads do not leave in lockstep
            while tr.t < SIM_TIME:
                # In through the gate, to a casualty at the fire seat, back out
                # to the treatment area with them.
                tr.go(*GATE, rng.uniform(*CARRY))
                tr.go(*GATE_IN, rng.uniform(*CARRY))
                tr.go(*inside(rng, seat), rng.uniform(*CARRY))
                tr.wait(rng.uniform(30.0, 90.0))
                tr.go(*GATE_IN, rng.uniform(*CARRY))
                tr.go(*GATE, rng.uniform(*CARRY))
                tr.go(*inside(rng, CTA), rng.uniform(*CARRY))
                tr.wait(rng.uniform(60.0, 180.0))
    for _ in range(CTA_STAFF):
        tr = node(*inside(rng, CTA))
        roles["cta"].append(tr.i)
        roam(rng, tr, CTA, STAFF, (10.0, 90.0))
    for _ in range(AMBULANCES):
        tr = node(*inside(rng, TZ))
        roles["ambulance"].append(tr.i)
        tr.wait(rng.uniform(0.0, 200.0))
        while tr.t < SIM_TIME:
            # Load at the treatment area, stage in the transport zone, leave,
            # and come back empty.
            tr.go(CTA[2] - 5.0, rng.uniform(CTA[1] + 5.0, CTA[3] - 5.0), DRIVE)
            tr.wait(rng.uniform(60.0, 120.0))
            tr.go(*inside(rng, TZ), DRIVE)
            tr.wait(rng.uniform(20.0, 60.0))
            tr.go(*EXIT, DRIVE)
            tr.wait(rng.uniform(120.0, 240.0))
            tr.go(*inside(rng, TZ), DRIVE)
    corners = [(MALL[0] - 20.0, MALL[1] - 20.0), (MALL[2] + 20.0, MALL[1] - 20.0),
               (MALL[2] + 20.0, MALL[3] + 20.0), (MALL[0] - 20.0, MALL[3] + 20.0)]
    for k in range(POLICE):
        c = k % 4
        tr = node(*corners[c])
        roles["police"].append(tr.i)
        tr.wait(rng.uniform(0.0, 60.0))
        while tr.t < SIM_TIME:
            c = (c + 1) % 4
            tr.go(*corners[c], rng.uniform(*PATROL))
            tr.wait(rng.uniform(0.0, 30.0))

    # Traffic: every team reports to the command post (Ben Arbia et al.: all
    # rescuers send to one sink at the main gate), and the command post sends
    # orders back to one member of each team.
    ff, md = roles["firefighter"], roles["medic"]
    up = (rng.sample(ff[:FIREFIGHTERS], 4) + rng.sample(ff[FIREFIGHTERS:], 4)
          + rng.sample(md, 4) + rng.sample(roles["cta"], 2) + rng.sample(roles["police"], 2))
    down = [ff[0], ff[FIREFIGHTERS], md[0], roles["cta"][0]]
    flows = [(s, 0) for s in up] + [(0, d) for d in down]

    os.makedirs(out_dir, exist_ok=True)
    with open(os.path.join(out_dir, "disaster.ns2"), "w") as f:
        f.write("\n".join(line for tr in tracks for line in tr.lines) + "\n")
    with open(os.path.join(out_dir, "disaster.flows"), "w") as f:
        f.write(f"# disaster-area scene (#580), tools/bench/disaster_scene.py gen --seed {seed}\n")
        f.writelines(f"# role {role} {' '.join(str(i) for i in ids)}\n" for role, ids in roles.items())
        f.write("# src dst start stop cbrBps\n")
        f.writelines(f"{s} {d} {rng.uniform(0.0, 30.0):.3f} {SIM_TIME:g} {PKT_BPS}\n"
                     for s, d in flows)
    with open(os.path.join(out_dir, "disaster.buildings"), "w") as f:
        f.write(";".join(",".join(f"{v:g}" for v in seat) for seat in SEATS) + "\n")
    print(f"wrote {out_dir}/disaster.ns2 ({len(tracks)} nodes), disaster.flows "
          f"({len(flows)} flows) and disaster.buildings")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    g = sub.add_parser("gen")
    g.add_argument("--out", required=True)
    g.add_argument("--seed", type=int, default=1)
    a = ap.parse_args()
    gen(a.out, a.seed)
    return 0


if __name__ == "__main__":
    sys.exit(main())
