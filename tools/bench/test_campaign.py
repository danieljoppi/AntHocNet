#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for campaign.py (#662).

The dispatcher spends runner hours and the collector writes the files a
results page is built on, so each piece gets a case with no network: GitHub is
replaced by a fake `gh` that records dispatches and reports a configurable
number of active runs.

Run: python3 test_campaign.py     (no pytest dependency; exits non-zero on the
                                   first failure)
"""

import argparse
import contextlib
import importlib.util
import io
import json
import os
import sys
import tempfile


def _load(name):
    """Load a sibling module from source (see test_scenario_check.py)."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), name + ".py")
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


cp = _load("campaign")
HERE = os.path.dirname(os.path.abspath(__file__))

CASES = []


def case(name):
    def deco(fn):
        CASES.append((name, fn))
        return fn
    return deco


def expect(cond, name, detail):
    if not cond:
        print(f"FAIL {name}: {detail}")
        sys.exit(1)


PLAN = {
    "generation": "vtest", "ref": "main", "cap": 2, "control": "control",
    "arms": {"control": "", "quiet": "--Quiet=true"},
    "cells": {
        "grid": {"workflow": "paper-benchmark.yml",
                 "inputs": {"scenario": "paper", "runs": 20}},
        "sat": {"workflow": "satellite-benchmark.yml",
                "inputs": {"harness": "isl-grid", "extraArgs": "--breakAt=450"},
                "armArgs": {"quiet": "--Range=5000"}},
        "vanet": {"workflow": "paper-benchmark.yml",
                  "inputs": {"scenario": "vanet", "runs": 4}, "blocks": [1, 5]},
    },
    "jobs": [
        {"arms": ["control"], "cells": "*", "inputs": {"protocols": "anthocnet,aodv"}},
        {"arms": ["quiet"], "cells": ["sat", "vanet"]},
    ],
}


class FakeGh:
    """Stands in for campaign.gh: answers the few endpoints the tool calls."""

    def __init__(self, active=0):
        self.active = active
        self.dispatched = []
        self.next_id = 100

    def __call__(self, *args, stdin=None, binary=False):
        url = args[0] if args[0] != "-X" else args[2]
        if "status=" in url:
            # All active runs count once, as benchmark-cell's queued runs.
            hit = "benchmark-cell" in url and "status=queued" in url
            return f"{self.active if hit else 0}\n"
        if url.endswith("/dispatches"):
            self.dispatched.append(stdin)
            self.active += 1
            self.next_id += 1
            return ""
        if "event=workflow_dispatch" in url:
            return f"{self.next_id}\n"
        raise AssertionError(f"unexpected gh call {args}")


def dispatch(log, fake, cap=None):
    cp.gh = fake
    cp.time.sleep = lambda _s: None
    a = argparse.Namespace(log=log, cap=cap, wait=False)
    with contextlib.redirect_stderr(io.StringIO()) as err, \
            contextlib.redirect_stdout(io.StringIO()):
        cp.cmd_dispatch(PLAN, a)
    return err.getvalue()


@case("jobs: labels, seed blocks, input overrides and arm attributes")
def _jobs():
    js = {label: (wf, inp) for label, _c, _a, wf, inp in cp.jobs(PLAN)}
    expect(list(js) == ["control/grid", "control/sat", "control/vanet-s1",
                        "control/vanet-s5", "quiet/sat", "quiet/vanet-s1",
                        "quiet/vanet-s5"], "jobs-labels", list(js))
    expect(js["control/grid"][1] == {"scenario": "paper", "runs": "20",
                                     "protocols": "anthocnet,aodv"},
           "jobs-override", js["control/grid"])
    expect("extraArgs" not in js["control/grid"][1], "jobs-no-empty-extra",
           js["control/grid"])
    expect(js["quiet/sat"][1]["extraArgs"] == "--breakAt=450 --Quiet=true --Range=5000",
           "jobs-arm-appended", js["quiet/sat"])
    expect("--Range" not in js["control/sat"][1]["extraArgs"], "jobs-armargs-scoped",
           js["control/sat"])
    expect(js["quiet/vanet-s5"][1]["extraArgs"] == "--firstRun=5 --Quiet=true",
           "jobs-block", js["quiet/vanet-s5"])
    expect(js["quiet/sat"][0] == "satellite-benchmark.yml", "jobs-workflow",
           js["quiet/sat"])


@case("jobs: an unknown arm or cell is refused")
def _jobs_unknown():
    for bad in ({"arms": ["nope"], "cells": "*"}, {"arms": ["quiet"], "cells": ["nope"]}):
        try:
            cp.jobs(dict(PLAN, jobs=[bad]))
        except SystemExit:
            continue
        expect(False, "jobs-unknown", f"{bad} was accepted")


@case("dispatch: stops at the cap, then resumes where the log ends")
def _dispatch_cap():
    with tempfile.TemporaryDirectory() as d:
        log = os.path.join(d, "runs.tsv")
        fake = FakeGh(active=0)
        err = dispatch(log, fake)
        expect(len(fake.dispatched) == 2 and "cap 2 reached" in err,
               "dispatch-cap", f"{len(fake.dispatched)} dispatched\n{err}")
        # Two runs finish: the next call sends two more, none twice.
        fake.active = 0
        dispatch(log, fake)
        with open(log) as f:
            text = f.read()
        labels = [ln.split("\t")[0] for ln in text.splitlines()]
        expect(labels == ["control/grid", "control/sat", "control/vanet-s1",
                          "control/vanet-s5"], "dispatch-resume", labels)
        expect(len(set(text.split())) == 8, "dispatch-run-ids", text)


@case("dispatch: the plan's ref and the job's inputs reach the API")
def _dispatch_body():
    import json
    with tempfile.TemporaryDirectory() as d:
        fake = FakeGh()
        dispatch(os.path.join(d, "runs.tsv"), fake, cap=1)
        body = json.loads(fake.dispatched[0])
        expect(body == {"ref": "main", "inputs": {
            "harness": "anthocnet-compare", "version": "3.42",
            "args": "--scenario=paper --runs=20 --nNodes=50 --time=300 "
                    "--areaX=1500 --pause=30 --speed=20 --propagation=range "
                    "--range=300 --diag --mobility=rwp --transport=udp "
                    "--protocols=anthocnet,aodv"}},
            "dispatch-body", body)


@case("legacy cells: the retired workflows' command lines, flag for flag")
def _legacy():
    # paper-benchmark.yml's shell: common flags, areaY if set, extraArgs,
    # then --diag --mobility --transport --protocols.
    h, a, v = cp.legacy_command("paper-benchmark.yml", {
        "scenario": "paper", "version": "3.42-opt", "nNodes": "500",
        "time": "300", "runs": "2", "areaX": "4743", "areaY": "1581",
        "pause": "30", "speed": "20", "protocols": "anthocnet,aodv",
        "propagation": "range", "mobility": "rwp", "transport": "udp",
        "range": "300", "harness": "compare", "extraArgs": "--firstRun=3"})
    expect((h, v) == ("anthocnet-compare", "3.42-opt") and a ==
           "--scenario=paper --runs=2 --nNodes=500 --time=300 --areaX=4743 "
           "--pause=30 --speed=20 --propagation=range --range=300 --areaY=1581 "
           "--firstRun=3 --diag --mobility=rwp --transport=udp "
           "--protocols=anthocnet,aodv", "legacy-paper", a)
    h, a, v = cp.legacy_command("satellite-benchmark.yml", {
        "harness": "isl-grid", "version": "3.42-opt", "time": "900",
        "runs": "20", "cbrBps": "4096", "protocols": "anthocnet",
        "extraArgs": "--breakAt=450"})
    expect(h == "isl-grid" and a ==
           "--rows=4 --cols=4 --torus=true --islDelayMs=5 --islRate=10Mbps "
           "--time=900 --runs=20 --flows=8 --cbrBps=4096 --diag "
           "--protocols=anthocnet --breakAt=450", "legacy-isl", a)
    h, a, v = cp.legacy_command("satellite-benchmark.yml", {
        "harness": "leo-walker", "version": "3.48", "flows": "4",
        "cbrBps": "2048", "protocols": "anthocnet", "extraArgs": "--shell=s1"})
    expect((h, v) == ("leo-walker", "3.48") and a ==
           "--time=300 --runs=3 --flows=4 --cbrBps=2048 --islRate=10Mbps "
           "--protocols=anthocnet --shell=s1", "legacy-leo", a)
    h, a, v = cp.legacy_command("benchmark-cell.yml", {
        "harness": "isl-grid", "args": "--rows=8", "extraArgs": "--firstRun=5"})
    expect((h, a, v) == ("isl-grid", "--rows=8 --firstRun=5", "3.42-opt"),
           "native-cell", (h, a, v))
    for wf, inp in (("paper-benchmark.yml", {"harness": "baselines"}),
                    ("scenario-matrix.yml", {})):
        try:
            cp.legacy_command(wf, inp)
        except SystemExit:
            continue
        expect(False, "legacy-refused", f"{wf} {inp} was accepted")


@case("every committed plan translates to benchmark-cell inputs")
def _plans_translate():
    import glob
    for path in sorted(glob.glob(os.path.join(HERE, "campaigns", "*.yaml"))):
        for _l, _c, _a, wf, inp in cp.jobs(cp.load_plan(path)):
            h, a, _v = cp.legacy_command(wf, inp)
            expect(h in ("anthocnet-compare", "isl-grid", "leo-walker") and a,
                   "plans-translate", f"{path}: {h} {a}")


def collect(log, src, out):
    a = argparse.Namespace(log=log, out=out, src=src, cache=None)
    with contextlib.redirect_stderr(io.StringIO()) as err:
        cp.cmd_collect(PLAN, a)
    return err.getvalue()


def write_run(src, label, text, name="paper-results.txt"):
    os.makedirs(os.path.join(src, label), exist_ok=True)
    with open(os.path.join(src, label, name), "w") as f:
        f.write(text)


@case("collect: seed blocks concatenate into one file per cell and arm")
def _collect():
    with tempfile.TemporaryDirectory() as d:
        src, out, log = (os.path.join(d, x) for x in ("src", "out", "runs.tsv"))
        with open(log, "w") as f:
            f.write("quiet/vanet-s1\t11\nquiet/vanet-s5\t12\nquiet/sat\t13\n")
        write_run(src, "quiet/vanet-s1", "##RUN## 1 anthocnet 40\n##PROV## commit=a\n")
        write_run(src, "quiet/vanet-s5", "##RUN## 5 anthocnet 41\n##PROV## commit=b\n")
        write_run(src, "quiet/sat", "##RUN## 1 anthocnet 99\n", "satellite-results.txt")
        err = collect(log, src, out)
        files = sorted(os.listdir(out))
        expect(files == ["sat-vtest-quiet.txt", "vanet-vtest-quiet.txt"],
               "collect-names", files)
        with open(os.path.join(out, "vanet-vtest-quiet.txt")) as f:
            text = f.read()
        expect(text.startswith("# vtest campaign vanet-vtest-quiet: 2 run(s): "
                               "11 (quiet/vanet-s1) / 12 (quiet/vanet-s5)"),
               "collect-header", text)
        expect(text.count("##PROV##") == 2 and "##RUN## 5" in text,
               "collect-body", text)
        expect("quiet/sat: no ##PROV## line" in err, "collect-prov-warn", err)
        expect("SKIP grid-vtest.txt: 0 of 1" in err, "collect-skip", err)


@case("status --brief: only the labels not yet successful, counts on stderr")
def _status_brief():
    def fake(*args, **_k):
        rid = args[0].rsplit("/", 1)[1]
        done = rid == "11"
        return json.dumps({"conclusion": "success" if done else None,
                           "status": "completed" if done else "in_progress"})
    cp.gh = fake
    with tempfile.TemporaryDirectory() as d:
        log = os.path.join(d, "runs.tsv")
        with open(log, "w") as f:
            f.write("quiet/vanet-s1\t11\nquiet/vanet-s5\t12\n")
        a = argparse.Namespace(log=log, brief=True)
        with contextlib.redirect_stderr(io.StringIO()) as err, \
                contextlib.redirect_stdout(io.StringIO()) as out:
            cp.cmd_status(PLAN, a)
    lines = out.getvalue().splitlines()
    expect("quiet/vanet-s1\t11\tsuccess" not in lines
           and "quiet/vanet-s5\t12\tin_progress" in lines
           and "control/grid\t-\tnot-dispatched" in lines, "status-brief", lines)
    expect("1 success" in err.getvalue(), "status-brief-counts", err.getvalue())


@case("collect: a timed-out run's stub artifact is a missing run")
def _collect_stub():
    with tempfile.TemporaryDirectory() as d:
        src, out, log = (os.path.join(d, x) for x in ("src", "out", "runs.tsv"))
        with open(log, "w") as f:
            f.write("quiet/vanet-s1\t11\nquiet/vanet-s5\t12\n")
        write_run(src, "quiet/vanet-s1", "##RUN## 1 anthocnet 40\n##PROV## commit=a\n")
        write_run(src, "quiet/vanet-s5", "##PROV## commit=a\n")
        err = collect(log, src, out)
        expect(not os.path.exists(os.path.join(out, "vanet-vtest-quiet.txt")),
               "collect-stub", os.listdir(out))
        expect("quiet/vanet-s5: artifact has no result rows" in err
               and "SKIP vanet-vtest-quiet.txt: 1 of 2" in err, "collect-stub", err)


@case("collect: a cell with a block still running is not written")
def _collect_partial():
    with tempfile.TemporaryDirectory() as d:
        src, out, log = (os.path.join(d, x) for x in ("src", "out", "runs.tsv"))
        with open(log, "w") as f:
            f.write("quiet/vanet-s1\t11\nquiet/vanet-s5\t12\n")
        write_run(src, "quiet/vanet-s1", "##RUN## 1 anthocnet 40\n")
        err = collect(log, src, out)
        expect(not os.path.exists(os.path.join(out, "vanet-vtest-quiet.txt")),
               "collect-partial", os.listdir(out))
        expect("SKIP vanet-vtest-quiet.txt: 1 of 2" in err, "collect-partial", err)


@case("the committed v2.2.0 phase-2 plan expands to its 99 jobs")
def _v220_plan():
    plan = cp.load_plan(os.path.join(HERE, "campaigns", "v2.2.0-phase2.yaml"))
    js = cp.jobs(plan)
    expect(len(js) == 99, "v220-count", len(js))
    arms = {}
    for _l, _c, arm, _w, _i in js:
        arms[arm] = arms.get(arm, 0) + 1
    expect(arms == {"recheck": 1, "attrib-repair200": 6, "repair200": 23,
                    "sinr": 23, "hello500": 23, "reconv1s": 23},
           "v220-arms", arms)


def main():
    for name, fn in CASES:
        fn()
        print(f"ok   {name}")
    print(f"\n{len(CASES)} cases passed")


if __name__ == "__main__":
    main()
