#!/usr/bin/env python3
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for bench_parse.py's --get field query (#791).

The CI gates in tools/checks/ used to read marker fields by position with awk.
They now call ``bench_parse.py --get``, so this checks two things:

1. Equivalence: on every committed cell in results/cells/, the query returns
   exactly what the awk it replaced printed (##RUN## pdr, summary-table pdr,
   '# paths' hopsMean). A gate converted to the query gives the same verdict.
2. Behaviour the awk could not offer: --csv columns are read by the header's
   name (a reordered header still yields the right column), and a missing
   protocol yields nothing with exit 0, so a gate under `set -e` still prints
   its own "no result" message.

Run: python3 test_bench_parse_query.py   (no pytest; exits non-zero on the
                                          first failure)
"""

import glob
import importlib.util
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))


def _load(name):
    """Load a sibling module from source (same pattern as test_stats.py)."""
    path = os.path.join(HERE, name + ".py")
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.path.insert(0, HERE)
    try:
        spec.loader.exec_module(module)
    finally:
        sys.path.pop(0)
    return module


bp = _load("bench_parse")


def awk(prog, text, **var):
    args = ["awk"]
    for k, v in var.items():
        args += ["-v", f"{k}={v}"]
    out = subprocess.run(args + [prog], input=text, capture_output=True,
                         text=True, check=True).stdout
    return [ln for ln in out.splitlines() if ln != ""]


def check(cond, msg):
    if not cond:
        print("FAIL:", msg)
        sys.exit(1)


# The awk expressions the gates used before #791, verbatim.
AWK_RUN_PDR = '$1 == "##RUN##" && $3 == p { v = $4 } END { print v }'
AWK_TABLE_PDR = '$1 == p && $2 ~ /^[0-9.]+$/ { v = $2 } END { print v }'
AWK_PATHS_HOPS = ('$1 == "#" && $2 == "paths" && $3 == p { for (i = 4; i <= NF; i++) '
                  'if ($i ~ /^hopsMean=/) { sub(/^hopsMean=/, "", $i); v = $i } } '
                  'END { print v }')


def test_equivalence_on_committed_cells():
    cells = sorted(glob.glob(os.path.join(ROOT, "results", "cells", "*.txt")))
    check(len(cells) > 100, f"expected the committed cells, found {len(cells)}")
    n_run = n_table = n_paths = 0
    for path in cells:
        with open(path) as fh:
            text = fh.read()
        protos = set(bp.parse_runs(text)) | set(bp.parse_cell(text))
        for p in sorted(protos):
            want = awk(AWK_RUN_PDR, text, p=p)
            got = bp.query(text, p, "pdr", "run")
            check(got == want, f"{path} {p} ##RUN## pdr: query {got} != awk {want}")
            n_run += bool(want)
            want = awk(AWK_TABLE_PDR, text, p=p)
            got = bp.query(text, p, "pdr", "table")
            check(got == want, f"{path} {p} table pdr: query {got} != awk {want}")
            n_table += bool(want)
            want = awk(AWK_PATHS_HOPS, text, p=p)
            got = bp.query(text, p, "hopsMean", "paths")
            check(got == want, f"{path} {p} paths hopsMean: query {got} != awk {want}")
            n_paths += bool(want)
    # The comparison must have compared something in each source.
    check(n_run > 100 and n_table > 100 and n_paths > 10,
          f"too few non-empty comparisons: run={n_run} table={n_table} paths={n_paths}")
    print(f"ok: query == awk on {len(cells)} committed cells "
          f"({n_run} run, {n_table} table, {n_paths} paths values)")


def test_run_rows():
    text = ("##RUN## 1 oracle 99.0 10.0 20.0 30.0 1.00 2.0 inf inf 0.1\n"
            "##RUN## 1 opspf 99.0 10.0 20.0 30.0 1.00 2.0 inf inf 0.1\n"
            "##RUN## 2 oracle 98.0 11.0 21.0 31.0 1.10 2.1 inf inf 0.2\n"
            "##RUN## 2 opspf 97.0 11.0 21.0 31.0 1.10 2.1 inf inf 0.2\n")
    o = bp.query(text, "oracle", "row", "run")
    s = bp.query(text, "opspf", "row", "run")
    check(o == ["1 99.0 10.0 20.0 30.0 1.00 2.0 inf inf 0.1",
                "2 98.0 11.0 21.0 31.0 1.10 2.1 inf inf 0.2"], f"oracle rows {o}")
    check(o[0] == s[0] and o[1] != s[1], "row comparison must see seed 2 differ")
    check(bp.query(text, "oracle", "delay99", "run") == ["21.0"], "last row wins")
    print("ok: --get row prints each ##RUN## row without the protocol")


# Header lines as the harnesses print them (routing-bench-harness.cc, isl-grid.cc).
ROUTING_CSV = (
    "protocol,runs,nNodes,area,speed,flows,pdr_pct,delay_ms,throughput_kbps,"
    "delay99_ms,nrl,jitter_ms\n"
    "anthocnet,2,50,1500x300,20.0,10,91.3,45.2,120.4,300.1,3.21,12.0\n"
    "aodv,2,50,1500x300,20.0,10,88.0,30.1,118.0,250.0,4.10,9.5\n")
ISL_CSV = (
    "protocol,runs,rows,cols,nodes,links,isl_delay_ms,flows,pdr_pct,delay_ms,"
    "delay99_ms,throughput_kbps,nrl,nrl_bytes,jitter_ms\n"
    "dsdv,1,4,4,16,32,2.0,4,100.0,8.1,9.0,40.0,0.5,0.01,0.1\n")


def test_csv_by_name():
    check(bp.query(ROUTING_CSV, "aodv", "pdr", "csv") == ["88.0"], "routing csv pdr")
    check(awk('BEGIN { FS = "," } $1 == a { print $7 }', ROUTING_CSV, a="aodv") == ["88.0"],
          "fixture must match the gates' old $7")
    check(bp.query(ISL_CSV, "dsdv", "pdr", "csv") == ["100.0"], "isl csv pdr")
    check(bp.query(ISL_CSV, "dsdv", "delay", "csv") == ["8.1"], "isl csv delay")
    check(bp.query(ISL_CSV, "dsdv", "pdr_pct", "csv") == ["100.0"], "raw column name")
    # A reordered header: named lookup still finds PDR; the old $7 would not.
    cols = ROUTING_CSV.splitlines()[0].split(",")
    order = [0, 6] + [i for i in range(1, len(cols)) if i != 6]
    moved = "\n".join(",".join(line.split(",")[i] for i in order)
                      for line in ROUTING_CSV.splitlines()) + "\n"
    check(bp.query(moved, "aodv", "pdr", "csv") == ["88.0"], "reordered header")
    check(awk('BEGIN { FS = "," } $1 == a { print $7 }', moved, a="aodv") != ["88.0"],
          "the positional read must break on the reordered header (else this proves nothing)")
    print("ok: --from csv reads columns by header name, aliases included")


# manet-baselines' table prints four numbers per arm (no throughput column):
# the #829 CI failure. The single-hop anchor reads its PDR.
BASELINES_TABLE = (
    "protocol        PDR%  delay(ms)  delay99(ms)     NRL\n"
    "--------------------------------------------------------\n"
    "  [diag aodv seed=1] flow 10.1.0.1:49153 -> 10.1.0.2:9 tx=862 rx=862 lost=0\n"
    "aodv            100.0        0.8          0.5     1.14\n"
    "dsdv            100.0        0.8          0.5     1.02\n")


def test_four_column_table():
    for p in ("aodv", "dsdv"):
        want = awk(AWK_TABLE_PDR, BASELINES_TABLE, p=p)
        got = bp.query(BASELINES_TABLE, p, "pdr", "table")
        check(got == want == ["100.0"], f"manet-baselines {p}: query {got}, awk {want}")
    print("ok: --from table reads PDR from manet-baselines' four-number rows")


def test_last_empty_clears():
    # awk's `{ v = $n } END { print v }` takes the LAST matching line even when
    # its field is empty; a stale earlier value must not leak through.
    csv = ROUTING_CSV + "aodv,2,50,1500x300,20.0,10,,,,,,\n"
    check(bp.query(csv, "aodv", "pdr", "csv") == [], "csv: empty last row clears")
    paths = "# paths x hopsMean=2.0\n# paths x hopsMean=\n"
    check(bp.query(paths, "x", "hopsMean", "paths") == [], "paths: empty last value clears")
    check(awk(AWK_PATHS_HOPS, paths, p="x") == [], "awk agrees on paths")
    run = "##RUN## 1 x 50.0 1 2 3 4\n##RUN## 2 x 49.0\n"
    check(bp.query(run, "x", "delay99", "run") == [], "run: short last row clears")
    check(bp.query(run, "x", "pdr", "run") == ["49.0"], "run: present field still read")
    print("ok: an empty or missing field in the last matching row clears the value")


def test_missing_is_empty_exit_0():
    for src, field in (("run", "pdr"), ("table", "pdr"), ("csv", "pdr"), ("paths", "hopsMean")):
        check(bp.query(ROUTING_CSV, "nosuch", field, src) == [], f"{src} missing proto")
    proc = subprocess.run(
        [sys.executable, os.path.join(HERE, "bench_parse.py"), "--get", "pdr",
         "--from", "csv", "--proto", "nosuch", "-"],
        input=ROUTING_CSV, capture_output=True, text=True, check=False)
    check(proc.returncode == 0 and proc.stdout == "", f"CLI missing: {proc}")
    proc = subprocess.run(
        [sys.executable, os.path.join(HERE, "bench_parse.py"), "--get", "pdr",
         "--from", "csv", "--proto", "aodv", "-"],
        input=ROUTING_CSV, capture_output=True, text=True, check=False)
    check(proc.returncode == 0 and proc.stdout == "88.0\n", f"CLI value: {proc}")
    print("ok: a missing value prints nothing and exits 0; the CLI prints the raw token")


if __name__ == "__main__":
    test_equivalence_on_committed_cells()
    test_run_rows()
    test_csv_by_name()
    test_four_column_table()
    test_last_empty_clears()
    test_missing_is_empty_exit_0()
    print("all bench_parse --get tests passed")
