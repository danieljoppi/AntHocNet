#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for partition_scene.py (#62).

The bounded-control check is the regression gate for the #20/#45 storm class,
so it is tested on synthetic `# series` runs where the answer is known: a
plateau passes, a growing control rate fails, a crossing flow that delivers
while the field is split fails (the scene, not the protocol, is broken), and
--strict fails a crossing flow that never rejoins. The generator is checked
for the properties the checker relies on.

Run: python3 test_partition_scene.py     (no simulator, no network)
"""

import contextlib
import importlib.util
import io
import itertools
import os
import sys
import tempfile


def _load(name):
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), name + ".py")
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


ps = _load("partition_scene")
CASES = []


def case(name):
    def deco(fn):
        CASES.append((name, fn))
        return fn

    return deco


def expect(cond, tag, detail=""):
    if not cond:
        print(f"FAIL {tag}: {detail}")
        sys.exit(1)


def scene(d):
    ps.gen(d, 1)
    return os.path.join(d, "partition.flows")


def series(path, ctrl_rate, rx_rate, proto="anthocnet"):
    """Write a 900 s run: ctrl_rate(t) and rx_rate(t, flow) in per-second units."""
    _, cross = ps.read_scene(os.path.join(os.path.dirname(path), "partition.flows"))
    ctrl, rx = 0.0, [0] * 10
    with open(path, "w") as f:
        for t in range(1, 901):
            ctrl += ctrl_rate(t)
            for j in range(10):
                rx[j] += rx_rate(t, j, j in cross)
            f.write(
                f"# series {proto} seed=1 t={t} ctrl={int(ctrl)} ant=0,0,0,0,0 "
                f"rx={','.join(str(x) for x in rx)}\n"
            )


def split(t):
    return any(n == "split" and t0 < t <= t1 for n, t0, t1 in ps.phases())


def run_check(flows, res, strict=False):
    out = io.StringIO()
    with contextlib.redirect_stdout(out):
        rc = ps.check(flows, res, [], strict)
    return rc, out.getvalue()


def honest_rx(t, j, crossing):
    return 0 if crossing and split(t) else 4


@case("the generator: 43 nodes, 10 flows with distinct destinations, 5 crossing")
def _gen():
    with tempfile.TemporaryDirectory() as d:
        flows = scene(d)
        ph, cross = ps.read_scene(flows)
        expect([p[0] for p in ph] == ["merged", "split"] * 3, "phases", ph)
        with open(flows) as f:
            rows = [
                line.split() for line in f if line.strip() and not line.startswith("#")
            ]
        expect(len(rows) == 10, "flows", len(rows))
        expect(len({r[1] for r in rows}) == 10, "distinct-dst", rows)
        expect(len(cross) == 5, "cross", cross)
        team = ps.TEAM
        for j, r in enumerate(rows):
            s, dd = int(r[0]), int(r[1])
            expect(((s < team) != (dd < team)) == (j in cross), "cross-flag", (j, r))
            expect(s < 2 * team and dd < 2 * team, "no-bridge-endpoints", r)
        with open(os.path.join(d, "partition.ns2")) as f:
            ns2 = f.read()
        expect("$node_(42) set X_" in ns2 and "$node_(43)" not in ns2, "nodes", "")


@case("the geometry: no team link crosses the gap, and the merged chain links it")
def _geometry():
    r = 300.0
    expect(ps.BOX_B[0] - ps.BOX_A[1] > r, "gap", "")
    chain = [ps.BOX_A[1]] + [x for x, _ in ps.BRIDGE_MERGED] + [ps.BOX_B[0]]
    expect(all(b - a < r for a, b in itertools.pairwise(chain)), "chain", chain)
    for x, _ in ps.BRIDGE_SPLIT:
        expect(x - ps.BOX_A[1] > r and ps.BOX_B[0] - x > r, "withdrawn", x)


@case("a protocol whose control plateaus while split passes")
def _plateau():
    with tempfile.TemporaryDirectory() as d:
        flows = scene(d)
        res = os.path.join(d, "r.txt")
        series(res, lambda t: 20 if split(t) else 10, honest_rx)
        rc, out = run_check(flows, res, strict=True)
        expect(rc == 0 and "PASS" in out, "plateau", out)


@case("a storm (control rate growing through the split) fails")
def _storm():
    with tempfile.TemporaryDirectory() as d:
        flows = scene(d)
        res = os.path.join(d, "r.txt")
        # The #45 shape: a flood toward unreachable destinations that feeds
        # on itself, so the rate climbs for the whole partition.
        series(res, lambda t: (10 + (t % 150)) if split(t) else 10, honest_rx)
        rc, out = run_check(flows, res)
        expect(rc == 1 and "FAIL (grows)" in out, "storm", out)


@case("a crossing flow delivering while split fails as a broken scene")
def _leak():
    with tempfile.TemporaryDirectory() as d:
        flows = scene(d)
        res = os.path.join(d, "r.txt")
        series(res, lambda t: 10, lambda t, j, c: 4)
        rc, out = run_check(flows, res)
        expect(rc == 1 and "scene geometry broken" in out, "leak", out)


@case("--strict fails a crossing flow that never rejoins; the default reports it")
def _rejoin():
    with tempfile.TemporaryDirectory() as d:
        flows = scene(d)
        res = os.path.join(d, "r.txt")
        series(res, lambda t: 10, lambda t, j, c: 0 if c and t > 150 else 4)
        rc, out = run_check(flows, res)
        expect(rc == 0 and "never" in out, "rejoin-report", out)
        rc, out = run_check(flows, res, strict=True)
        expect(rc == 1 and "not delivering within" in out, "rejoin-strict", out)


@case("re-convergence is measured from the merge to the first delivery after it")
def _rejoin_time():
    with tempfile.TemporaryDirectory() as d:
        flows = scene(d)
        res = os.path.join(d, "r.txt")

        # Crossing flows come back 20 s after each merge.
        def rx(t, j, c):
            if not c:
                return 4
            if split(t):
                return 0
            return (
                0
                if any(
                    n == "merged" and t0 > 0 and t0 < t <= t0 + 20
                    for n, t0, _ in ps.phases()
                )
                else 4
            )

        series(res, lambda t: 10, rx)
        rc, out = run_check(flows, res, strict=True)
        expect(rc == 0 and "median 21 s, max 21 s" in out, "rejoin-time", out)


def main():
    for name, fn in CASES:
        fn()
        print(f"ok   {name}")
    print(f"\n{len(CASES)} cases passed")


if __name__ == "__main__":
    main()
