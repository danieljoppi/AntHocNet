#!/usr/bin/env python3
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""The partition/merge stress scene (#62): generate it, and check a run of it.

Two teams of nodes move inside their own boxes, 800 m apart, out of radio
range of each other. A chain of bridge nodes joins them, then withdraws to
the middle of the gap, where it reaches neither team, and comes back: the
field alternates merged and partitioned phases. Some flows stay inside a
team; the others cross the gap, so during a partition their destinations are
unreachable. That is the case where failure-recovery machinery either backs
off or storms (#20, #45).

    partition_scene.py gen   --out DIR [--seed 1]
        DIR/partition.ns2    ns-2 movement trace (anthocnet-compare --mobility=trace)
        DIR/partition.flows  flows (--flowsFile); its '#' header records the
                             phases and which flows cross, for `check`
    partition_scene.py check FLOWS RESULTS [--proto anthocnet] [--strict]

`check` reads the `# series` lines of a run made with `--diag
--seriesEvery=1` and reports, per protocol and seed:

- **bounded control while split:** in each partitioned phase, after a settle
  window, the routing-control rate of the second half against the first. A
  storm grows; a bounded protocol plateaus. FAIL when the second half
  exceeds the first by more than RATE_GROWTH_MAX (plus a 1 pkt/s floor, so a
  near-silent phase cannot fail on noise).
- **the split is real:** a crossing flow delivers nothing once the bridges
  have withdrawn. Otherwise the scene is broken, not the protocol.
- **re-convergence:** the time from each merge to each crossing flow's first
  delivery after it. With --strict, FAIL when a crossing flow does not
  deliver within REJOIN_MAX_S of a merge.

Exit status 1 on any FAIL.
"""

import argparse
import os
import random
import re
import sys

# Geometry (m). The teams' boxes are 800 m apart at 300 m range, so no link
# crosses the gap. Merged, the bridges sit 240 m apart from 720 to 1200 m:
# the chain links both boxes' facing edges. Withdrawn, they gather at
# x = 1000, 400 m from either box.
BOX_A = (0.0, 600.0)
BOX_B = (1400.0, 2000.0)
HEIGHT = 300.0
BRIDGE_MERGED = [(720.0, 150.0), (960.0, 150.0), (1200.0, 150.0)]
BRIDGE_SPLIT = [(1000.0, 60.0), (1000.0, 150.0), (1000.0, 240.0)]
BRIDGE_SPEED = 20.0
TEAM = 20
SIM_TIME = 900.0
PHASE_S = 150.0  # merged, split, merged, split, merged, split
TEAM_SPEED = (1.0, 5.0)  # m/s: responders on foot inside their area
TEAM_PAUSE = (0.0, 30.0)
CBR_BPS = 2048  # 4 x 64 B/s, the thesis's per-flow rate

SETTLE_S = 30.0  # bridges move for 12-15 s; let the field and timers settle
RATE_GROWTH_MAX = 1.5
REJOIN_MAX_S = 60.0


def phases():
    out, t, merged = [], 0.0, True
    while t < SIM_TIME - 1e-9:
        out.append(("merged" if merged else "split", t, min(t + PHASE_S, SIM_TIME)))
        t += PHASE_S
        merged = not merged
    return out


def gen(out_dir, seed):
    rng = random.Random(seed)
    lines = []
    n = 2 * TEAM + len(BRIDGE_MERGED)

    def place(i, x, y):
        lines.append(f"$node_({i}) set X_ {x:.3f}")
        lines.append(f"$node_({i}) set Y_ {y:.3f}")
        lines.append(f"$node_({i}) set Z_ 0.000")

    def setdest(t, i, x, y, v):
        lines.append(f'$ns_ at {t:.3f} "$node_({i}) setdest {x:.3f} {y:.3f} {v:.3f}"')

    # Teams: random waypoint inside their own box.
    for i in range(2 * TEAM):
        x0, x1 = BOX_A if i < TEAM else BOX_B
        x, y = rng.uniform(x0, x1), rng.uniform(0.0, HEIGHT)
        place(i, x, y)
        t = 0.0
        while t < SIM_TIME:
            t += rng.uniform(*TEAM_PAUSE)
            if t >= SIM_TIME:
                break
            nx, ny = rng.uniform(x0, x1), rng.uniform(0.0, HEIGHT)
            v = rng.uniform(*TEAM_SPEED)
            setdest(t, i, nx, ny, v)
            t += ((nx - x) ** 2 + (ny - y) ** 2) ** 0.5 / v
            x, y = nx, ny
    # Bridges: in the chain while merged, withdrawn while split.
    for k in range(len(BRIDGE_MERGED)):
        i = 2 * TEAM + k
        place(i, *BRIDGE_MERGED[k])
        for name, t0, _ in phases():
            if t0 == 0.0:
                continue
            x, y = (BRIDGE_MERGED if name == "merged" else BRIDGE_SPLIT)[k]
            setdest(t0, i, x, y, BRIDGE_SPEED)

    # Flows, each to its own destination (so each gets its own sink and the
    # per-flow books). Three inside A, two inside B, three A -> B, two B -> A.
    a = rng.sample(range(TEAM), 10)
    b = rng.sample(range(TEAM, 2 * TEAM), 10)
    pairs = [
        (a[0], a[1]),
        (a[2], a[3]),
        (a[4], a[5]),
        (b[0], b[1]),
        (b[2], b[3]),
        (a[6], b[4]),
        (a[7], b[5]),
        (a[8], b[6]),
        (b[7], a[9]),
        (b[8], a[0]),
    ]
    assert len({d for _, d in pairs}) == len(pairs)
    cross = [j for j, (s, d) in enumerate(pairs) if (s < TEAM) != (d < TEAM)]

    os.makedirs(out_dir, exist_ok=True)
    with open(os.path.join(out_dir, "partition.ns2"), "w") as f:
        f.write("\n".join(lines) + "\n")
    with open(os.path.join(out_dir, "partition.flows"), "w") as f:
        f.write(
            f"# partition/merge scene (#62), tools/bench/partition_scene.py gen --seed {seed}\n"
        )
        f.write(
            f"# nodes {n} (team A 0-{TEAM - 1}, team B {TEAM}-{2 * TEAM - 1}, "
            f"bridges {2 * TEAM}-{n - 1})\n"
        )
        for name, t0, t1 in phases():
            f.write(f"# phase {name} {t0:g} {t1:g}\n")
        f.write("# cross " + " ".join(str(j) for j in cross) + "\n")
        f.write("# src dst start stop cbrBps\n")
        f.writelines(
            f"{s} {d} {rng.uniform(0.0, 10.0):.3f} {SIM_TIME:g} {CBR_BPS}\n"
            for s, d in pairs
        )
    print(
        f"wrote {out_dir}/partition.ns2 ({n} nodes) and partition.flows "
        f"({len(pairs)} flows, {len(cross)} crossing)"
    )


def read_scene(flows_path):
    ph, cross = [], []
    with open(flows_path) as f:
        for line in f:
            m = re.match(r"#\s*phase\s+(\w+)\s+([\d.]+)\s+([\d.]+)", line)
            if m:
                ph.append((m.group(1), float(m.group(2)), float(m.group(3))))
            m = re.match(r"#\s*cross\s+(.*)", line)
            if m:
                cross = [int(x) for x in m.group(1).split()]
    if not ph or not cross:
        sys.exit(
            f"{flows_path}: no '# phase' / '# cross' header (not a partition scene?)"
        )
    return ph, cross


SERIES = re.compile(
    r"^# series (\S+) seed=(\d+) t=([\d.]+) ctrl=(\d+) ant=([\d,]+) rx=([\d,]*)"
)


def read_series(path):
    runs = {}
    with open(path) as f:
        for line in f:
            m = SERIES.match(line)
            if not m:
                continue
            key = (m.group(1), int(m.group(2)))
            rx = [int(x) for x in m.group(6).split(",")] if m.group(6) else []
            runs.setdefault(key, []).append((float(m.group(3)), int(m.group(4)), rx))
    return runs


def rate(samples, t0, t1):
    """Control packets per second over [t0, t1], from cumulative samples."""
    inside = [s for s in samples if t0 - 1e-9 <= s[0] <= t1 + 1e-9]
    if len(inside) < 2:
        return None
    return (inside[-1][1] - inside[0][1]) / (inside[-1][0] - inside[0][0])


def check(flows_path, results_path, protos, strict):
    ph, cross = read_scene(flows_path)
    runs = read_series(results_path)
    if not runs:
        sys.exit(
            f"{results_path}: no '# series' lines (run with --diag --seriesEvery=1)"
        )
    fails = 0
    for (proto, seed), s in sorted(runs.items()):
        if protos and proto not in protos:
            continue
        s.sort()
        out = []
        for name, t0, t1 in ph:
            if name != "split":
                continue
            a0 = t0 + SETTLE_S
            mid = (a0 + t1) / 2
            r1, r2 = rate(s, a0, mid), rate(s, mid, t1)
            if r1 is None or r2 is None:
                continue
            grow = r2 > RATE_GROWTH_MAX * r1 + 1.0
            fails += grow
            out.append(
                f"split@{t0:g}: ctrl {r1:.1f} -> {r2:.1f} pkt/s"
                + (" FAIL (grows)" if grow else "")
            )
            # The split is real: no crossing flow delivers after the settle.
            before = next(x for x in s if x[0] >= a0 - 1e-9)[2]
            after = (
                s[-1][2]
                if t1 >= s[-1][0]
                else next(x for x in s if x[0] >= t1 - 1e-9)[2]
            )
            leaked = [j for j in cross if j < len(after) and after[j] > before[j]]
            if leaked:
                fails += 1
                out.append(
                    f"split@{t0:g}: FAIL crossing flows {leaked} delivered "
                    "while split (scene geometry broken)"
                )
        rejoin = []
        for name, t0, t1 in ph:
            if name != "merged" or t0 == 0.0:
                continue
            base = next(x for x in s if x[0] >= t0 - 1e-9)[2]
            for j in cross:
                first = next(
                    (
                        x[0]
                        for x in s
                        if x[0] > t0
                        and x[0] <= t1 + 1e-9
                        and j < len(x[2])
                        and x[2][j] > base[j]
                    ),
                    None,
                )
                rejoin.append(first - t0 if first is not None else None)
        got = sorted(r for r in rejoin if r is not None)
        never = sum(r is None for r in rejoin)
        late = never + sum(r > REJOIN_MAX_S for r in got)
        if got:
            out.append(
                f"rejoin: median {got[len(got) // 2]:.0f} s, max {got[-1]:.0f} s"
                f" over {len(rejoin)} (merge, crossing flow) pairs; {never} never"
            )
        else:
            out.append(
                f"rejoin: none of {len(rejoin)} (merge, crossing flow) pairs delivered; "
                f"{never} never"
            )
        if strict and late:
            fails += 1
            out.append(
                f"FAIL: {late} pair(s) not delivering within {REJOIN_MAX_S:g} s of a merge"
            )
        print(f"{proto} seed={seed}: " + "; ".join(out))
    print("verdict:", "FAIL" if fails else "PASS")
    return 1 if fails else 0


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    g = sub.add_parser("gen")
    g.add_argument("--out", required=True)
    g.add_argument("--seed", type=int, default=1)
    c = sub.add_parser("check")
    c.add_argument("flows")
    c.add_argument("results")
    c.add_argument("--proto", action="append", default=[])
    c.add_argument(
        "--strict",
        action="store_true",
        help=f"also FAIL a crossing flow silent {REJOIN_MAX_S:g} s after a merge",
    )
    a = ap.parse_args()
    if a.cmd == "gen":
        gen(a.out, a.seed)
        return 0
    return check(a.flows, a.results, a.proto, a.strict)


if __name__ == "__main__":
    sys.exit(main())
