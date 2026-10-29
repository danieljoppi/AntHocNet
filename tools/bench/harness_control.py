#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Byte-identical control for a harness change (#769, ADR-0027 §4).

A control plan (tools/bench/campaigns/v2.6.0-harness-control.yaml) re-runs a
cheap seed block of committed cells; each cell names the committed file it
must reproduce in its `source` key. This compares, for every seed the new
file holds, the rows the rule covers -- ##RUN##, ##ROUTE## and ##COMMON## --
against the committed file's rows for the same seeds and arms. Any difference
is a defect in the change, not noise: the runs are deterministic (#129) and
seed-pinned (#352).

    python3 tools/bench/harness_control.py PLAN [--cells DIR]

Prints one line per cell (PASS, FAIL with the first differing row, or MISSING
when the new file has not been collected yet) and exits non-zero on any FAIL
or MISSING. ##CONFIG## drift other than runs/firstRun is reported as a WARN:
the cell then re-runs something other than what was committed.
"""

import argparse
import os
import re
import sys

MARKERS = ("##RUN##", "##ROUTE##", "##COMMON##")


def rows(text, seeds=None):
    """{(marker, seed, arm): [row, ...]} for the rule's markers."""
    out = {}
    for line in text.splitlines():
        parts = line.split()
        if len(parts) < 3 or parts[0] not in MARKERS:
            continue
        if seeds is not None and parts[1] not in seeds:
            continue
        out.setdefault((parts[0], parts[1], parts[2]), []).append(line.rstrip())
    return out


def configs(text):
    """The ##CONFIG## scenario lines, without runs= and firstRun=."""
    out = set()
    for line in text.splitlines():
        if line.startswith("##CONFIG## scenario="):
            out.add(re.sub(r" (runs|firstRun)=\S+", "", line.rstrip()))
    return out


def compare(committed, new):
    """('PASS'|'FAIL', detail, warnings) for one cell's two texts."""
    got = rows(new)
    if not got:
        return "FAIL", "the new file has no ##RUN##/##ROUTE##/##COMMON## rows", []
    seeds = {seed for (_m, seed, _a) in got}
    want = rows(committed, seeds)
    warnings = []
    if configs(new) - configs(committed):
        warnings.append("##CONFIG## differs beyond runs/firstRun")
    for key in sorted(set(want) | set(got)):
        if want.get(key) != got.get(key):
            marker, seed, arm = key
            w = (want.get(key) or ["(absent)"])[0]
            g = (got.get(key) or ["(absent)"])[0]
            return "FAIL", f"{marker} seed {seed} {arm}: committed {w!r} / new {g!r}", warnings
    n = sum(len(v) for v in got.values())
    return "PASS", f"{n} row(s), seeds {','.join(sorted(seeds, key=int))}", warnings


def main(argv=None):
    import yaml
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("plan")
    ap.add_argument("--cells", default="results/cells")
    a = ap.parse_args(argv)
    with open(a.plan) as f:
        plan = yaml.safe_load(f)
    bad = 0
    for cell, spec in plan["cells"].items():
        src = spec.get("source")
        if not src:
            continue
        new_path = os.path.join(a.cells, f"{cell}-{plan['generation']}.txt")
        if not os.path.exists(new_path):
            print(f"MISSING {cell}: {new_path} not collected yet")
            bad += 1
            continue
        with open(os.path.join(a.cells, src)) as f:
            committed = f.read()
        with open(new_path) as f:
            new = f.read()
        verdict, detail, warnings = compare(committed, new)
        print(f"{verdict} {cell} vs {src}: {detail}")
        for w in warnings:
            print(f"WARN {cell}: {w}")
        bad += verdict != "PASS"
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
