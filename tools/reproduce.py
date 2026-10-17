#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""One command per published figure (#621), driven by results/figures.yml.

    tools/reproduce.py list
    tools/reproduce.py check                       # every PNG has an entry; its data exists
    tools/reproduce.py FIG [--from-data]           # re-render from committed data, diff the PNG
    tools/reproduce.py FIG --rerun --ns3dir DIR [--cell NAME] [--runs N] [--time S]
                                                   # re-measure, validate, render

--from-data (the default, seconds) renders with the figure's renderer into
a scratch directory and compares bytes with the committed image: the
renderers are deterministic, so anything but "identical" is a finding.

--rerun (hours at the published seeds) runs the harness for one of the
figure's cells inside an ns-3 tree that carries the module (the ns-3
image's /opt/ns-3, or a local tree after `make install-ns3`), checks the
output with scenario_check.py results, and renders the figure with the new
cell in place of the committed one. --runs/--time shorten a smoke run; the
figure then shows fewer seeds than the published one, and says nothing
about it.
"""
import argparse
import filecmp
import glob
import os
import shlex
import shutil
import subprocess
import sys
import tempfile

import yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MANIFEST = os.path.join(ROOT, "results", "figures.yml")


def load():
    with open(MANIFEST) as f:
        return yaml.safe_load(f)


def die(msg):
    print(f"reproduce: {msg}", file=sys.stderr)
    sys.exit(1)


def cmd_list(m):
    for name, fig in m["figures"].items():
        if fig.get("frozen"):
            how = "frozen"
        elif fig.get("render") == "none":
            how = "rerun only"
        else:
            how = "from data + rerun" if isinstance(fig.get("rerun"), list) else "from data"
        print(f"{name:24s} {how:18s} {fig['image']}")


def cmd_check(m):
    """CI: the manifest covers every published PNG, and its inputs exist."""
    bad = []
    listed = {f["image"] for f in m["figures"].values()}
    for png in sorted(glob.glob(os.path.join(ROOT, "docs", "benchmarks", "**", "*.png"), recursive=True)):
        rel = os.path.relpath(png, ROOT)
        if rel not in listed:
            bad.append(f"{rel}: no entry in results/figures.yml")
    for name, fig in m["figures"].items():
        if not os.path.exists(os.path.join(ROOT, fig["image"])):
            bad.append(f"{name}: image {fig['image']} does not exist")
        if fig.get("frozen"):
            continue
        r = fig.get("render")
        if r != "none" and r not in m["renderers"]:
            bad.append(f"{name}: unknown renderer {r}")
        for pat in fig.get("data", []):
            if not glob.glob(os.path.join(ROOT, pat)):
                bad.append(f"{name}: data {pat} matches nothing")
        for run in fig["rerun"] if isinstance(fig.get("rerun"), list) else []:
            if not os.path.exists(os.path.join(ROOT, run["cell"])):
                bad.append(f"{name}: rerun cell {run['cell']} does not exist")
    for b in bad:
        print(f"FAIL: {b}")
    if bad:
        sys.exit(1)
    print(f"ok: {len(m['figures'])} figures; every PNG under docs/benchmarks/ has an entry and its data")


def render(m, fig, cells, out):
    cmd = m["renderers"][fig["render"]].format(cells=cells, out=out)
    subprocess.run(cmd, shell=True, cwd=ROOT, check=True, stdout=subprocess.DEVNULL)
    return os.path.join(out, os.path.basename(fig["image"]))


def from_data(m, name, fig):
    if fig.get("frozen"):
        die(f"{name} is frozen: {fig['frozen']}")
    if fig.get("render") == "none":
        die(f"{name} has no committed data to render from; rerun: {fig['rerun']}")
    with tempfile.TemporaryDirectory() as out:
        png = render(m, fig, os.path.join(ROOT, "results", "cells"), out)
        same = filecmp.cmp(png, os.path.join(ROOT, fig["image"]), shallow=False)
    print(f"{'identical' if same else 'DIFFERENT'}: {fig['image']} re-rendered from {', '.join(fig['data'])}")
    sys.exit(0 if same else 1)


def config_args(cell):
    """anthocnet-compare flags from a cell's own ##CONFIG## lines."""
    args, attrs = None, []
    with open(cell) as f:
        for line in f:
            if line.startswith("##CONFIG## attr "):
                kv = line.split(" ", 2)[2].strip()
                if "::" not in kv and kv not in attrs:  # the module's own attributes
                    attrs.append(kv)
            elif line.startswith("##CONFIG## scenario=") and args is None:
                args = [f"--{kv}" for kv in line.split()[1:]]
    if args is None:
        die(f"{cell} has no ##CONFIG## line; give its args in results/figures.yml")
    return args + [f"--ns3::anthocnet::RoutingProtocol::{a}" for a in attrs]


def rerun(m, name, fig, a):
    runs = fig.get("rerun")
    if not isinstance(runs, list):
        die(f"{name} cannot be re-run here: {runs}")
    if a.cell:
        runs = [r for r in runs if os.path.basename(r["cell"]).startswith(a.cell)]
        if not runs:
            die(f"no rerun cell of {name} matches {a.cell}")
    run = runs[0]
    if run.get("from-config"):
        args = config_args(os.path.join(ROOT, run["cell"]))
    else:
        args = shlex.split(run["args"])
    for flag, val in (("runs", a.runs), ("time", a.time)):
        if val is not None:
            args = [x for x in args if not x.startswith(f"--{flag}=")] + [f"--{flag}={val}"]
    line = " ".join([run["harness"]] + args)
    print(f"running in {a.ns3dir}: ./ns3 run \"{line}\"", flush=True)
    work = tempfile.mkdtemp(prefix="reproduce-")
    cells = os.path.join(work, "cells")
    shutil.copytree(os.path.join(ROOT, "results", "cells"), cells)
    cell = os.path.join(cells, os.path.basename(run["cell"]))
    with open(cell, "w") as f:
        f.write(f"# re-run by tools/reproduce.py: {line}\n")
        f.flush()
        ns3 = ["./ns3", "run"] + (["--no-build"] if a.no_build else []) + [line]
        subprocess.run(ns3, cwd=a.ns3dir, stdout=f, check=True)
    subprocess.run([sys.executable, os.path.join(ROOT, "tools", "bench", "scenario_check.py"), "results", cell], check=True)
    out = os.path.join(work, "figures")
    os.makedirs(out)
    png = render(m, fig, cells, out)
    print(f"new cell:   {cell}\nnew figure: {png}\n(committed: {fig['image']})")


def main():
    m = load()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("what", help="list | check | a figure name")
    ap.add_argument("--from-data", action="store_true", help="re-render and diff (the default)")
    ap.add_argument("--rerun", action="store_true", help="re-measure one cell, then render")
    ap.add_argument("--ns3dir", default=os.environ.get("NS3DIR", "/opt/ns-3"))
    ap.add_argument("--cell", help="which rerun cell (a prefix of its file name)")
    ap.add_argument("--runs", type=int)
    ap.add_argument("--time", type=float)
    ap.add_argument("--no-build", action="store_true", help="pass --no-build to ./ns3 run")
    a = ap.parse_args()
    if a.what == "list":
        return cmd_list(m)
    if a.what == "check":
        return cmd_check(m)
    fig = m["figures"].get(a.what)
    if fig is None:
        die(f"unknown figure {a.what!r}; `tools/reproduce.py list` names them")
    if a.rerun:
        return rerun(m, a.what, fig, a)
    return from_data(m, a.what, fig)


if __name__ == "__main__":
    main()
