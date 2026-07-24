#!/usr/bin/env python3
"""Scenario validation (#134): pre-flight config checks + result plausibility.

Two failure classes this script catches before they cost a dispatch cycle
(#121 budget) or a corrupted conclusion:
- a degenerate scenario config (partitioned field, overloaded channel,
  accidental single-hop, too-short sim) dispatched as if meaningful;
- an implausible or anchor-violating result trusted, compared, or quoted.

All arithmetic happens here; only the verdict lines reach LLM context.

Usage:
    scenario_check.py preflight [--nodes 50] [--areaX 1500] [--areaY 300]
                                [--range 300] [--time 300] [--pause 30]
                                [--speed 20] [--flows 20] [--pktBytes 64]
                                [--pktPerSec 1] [--rateMbps 2]
        # defaults = the paper base scenario; override what your dispatch
        # overrides. Exit 1 on any FAIL-level degeneracy.

    scenario_check.py results FILE [FILE ...] [--anchor single-hop|broch-low-mobility]
        # FILE = a saved ##BENCH## cell / results-table text, or a classified
        # campaign CSV (sniffed by header). --anchor additionally enforces
        # the ns3/tools/anchors.yml floor on AODV rows (#59, single source
        # of thresholds). Exit 1 on any FAIL.
"""
import argparse
import csv
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ANCHORS_YML = os.path.normpath(
    os.path.join(HERE, "..", "..", "..", "ns3", "tools", "anchors.yml"))
ANCHOR_KEY = {"single-hop": "single_hop_pdr_min",
              "broch-low-mobility": "broch_low_mobility_aodv_pdr_min"}

ROW = re.compile(r"^\s*(?:##BENCH##\s+)?([a-z][\w-]*)((?:\s+[-\d.]+|\s+inf)+)\s*$")

issues = []


def report(level, msg):
    issues.append(level)
    print(f"{level}: {msg}")


def anchor_floor(anchor):
    key = ANCHOR_KEY[anchor]
    with open(ANCHORS_YML) as fh:
        for line in fh:
            if line.split(":")[0].strip() == key:
                return float(line.split(":")[1].split("#")[0])
    sys.exit(f"FAIL: {key} not found in {ANCHORS_YML}")


def cmd_preflight(a):
    area = a.areaX * a.areaY
    # Mean node degree on a random geometric graph: n * (disk ∩ area) / area.
    # Cap the disk by the area's short edge (the 1500x300 field is a strip).
    disk = math.pi * a.range ** 2
    # In a strip narrower than the disk (the paper's 1500x300 field), a
    # node's in-range area is ~2r x short-edge, not the full disk.
    reach = min(disk, 2 * a.range * min(a.areaY, a.areaX), area)
    degree = (a.nodes - 1) * reach / area
    print(f"field {a.areaX}x{a.areaY} m, {a.nodes} nodes, range {a.range} m")
    print(f"  expected mean degree ~{degree:.1f} "
          f"(connectivity wants >~{math.log(max(a.nodes, 2)):.1f})")
    if a.range >= max(a.areaX, a.areaY):
        report("WARN", "range >= long edge — effectively single-hop "
                       "(fine only for an anchor scenario)")
    if degree < math.log(max(a.nodes, 2)):
        report("FAIL", "expected degree below ln(n) — field likely "
                       "partitioned; results will measure connectivity, "
                       "not routing")
    elif degree < 2 * math.log(max(a.nodes, 2)):
        report("WARN", "expected degree < 2·ln(n) — intermittent partitions "
                       "likely (sparse regime; intended for the paper field, "
                       "but don't read absolute PDR as protocol quality)")
    offered = a.flows * a.pktBytes * 8 * a.pktPerSec  # bps at the app layer
    frac = offered / (a.rateMbps * 1e6)
    print(f"  offered load {offered/1000:.1f} kbps = {frac*100:.1f}% of the "
          f"{a.rateMbps} Mbit/s channel (single collision domain)")
    if frac > 0.5:
        report("FAIL", "offered load >50% of channel rate — MAC saturation; "
                       "every protocol will collapse (#121: don't dispatch)")
    elif frac > 0.2:
        report("WARN", "offered load >20% of channel rate — contention-"
                       "dominated; deltas will mix routing with MAC effects")
    if a.time < 120:
        report("WARN", f"time={a.time}s — shorter than the convergence "
                       "horizon used for the quick CI preset; PDR includes "
                       "a large startup transient")
    if a.pause >= a.time:
        report("WARN", "pause >= sim time — the field is static; that is "
                       "the sparse-static regime (a known AntHocNet weak "
                       "spot), not the paper's mobile one")
    verdict()


def parse_results(path):
    """Yield dicts with proto/pdr/delay/delay99/nrl/jitter (+context) per row."""
    with open(path) as fh:
        text = fh.read()
    first = text.lstrip().splitlines()[0] if text.strip() else ""
    if first.startswith("kind,") or ",protocol," in first:
        for r in csv.DictReader(text.splitlines()):
            yield {"where": f"{r.get('group')}={r.get('x')}",
                   "proto": r.get("protocol"),
                   "pdr": r.get("pdr_pct"), "delay": r.get("delay_ms"),
                   "delay99": r.get("delay99_ms"), "nrl": r.get("nrl"),
                   "jitter": r.get("jitter_ms")}
        return
    for line in text.splitlines():
        m = ROW.match(line)
        if not m:
            continue
        proto, nums = m.group(1), m.group(2).split()
        if proto in ("protocol",) or len(nums) < 5:
            continue
        row = {"where": os.path.basename(path), "proto": proto,
               "pdr": nums[0], "delay": nums[1], "delay99": nums[2],
               "nrl": nums[4]}
        if len(nums) >= 6:
            row["jitter"] = nums[5]
        yield row


def cmd_results(a):
    floor = anchor_floor(a.anchor) if a.anchor else None
    n = 0
    for path in a.files:
        for r in parse_results(path):
            n += 1
            tag = f"{r['where']}/{r['proto']}"

            def num(k):
                try:
                    return float(r.get(k))
                except (TypeError, ValueError):
                    return None
            pdr, delay, d99 = num("pdr"), num("delay"), num("delay99")
            nrl, jit = num("nrl"), num("jitter")
            if pdr is None or not (0.0 <= pdr <= 100.0):
                report("FAIL", f"{tag}: PDR {r.get('pdr')} outside [0,100]")
            if delay is not None and d99 is not None and d99 < delay:
                report("FAIL", f"{tag}: delay99 {d99} < mean delay {delay}")
            for k, v in (("delay", delay), ("nrl", nrl), ("jitter", jit)):
                if v is not None and v < 0:
                    report("FAIL", f"{tag}: negative {k} ({v})")
            if pdr is not None and pdr == 0.0:
                report("WARN", f"{tag}: PDR 0 — dead scenario or harness "
                               "failure (#28 empty-table class)")
            if floor is not None and r["proto"] == "aodv" and pdr is not None:
                if pdr < floor:
                    report("FAIL", f"{tag}: anchor '{a.anchor}' floor "
                                   f"{floor} violated (AODV PDR {pdr}) — "
                                   "#51-class harness/channel regression; "
                                   "do not trust or publish these numbers")
                else:
                    print(f"ok: {tag}: anchor '{a.anchor}' floor {floor} "
                          f"met (AODV PDR {pdr})")
    if n == 0:
        report("FAIL", "no result rows parsed from the input")
    else:
        print(f"checked {n} rows")
    verdict()


def verdict():
    fails = issues.count("FAIL")
    print(f"verdict: {'FAIL' if fails else 'WARN' if issues else 'OK'} "
          f"({fails} fail, {issues.count('WARN')} warn)")
    sys.exit(1 if fails else 0)


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("preflight")
    p.add_argument("--nodes", type=int, default=50)
    p.add_argument("--areaX", type=float, default=1500)
    p.add_argument("--areaY", type=float, default=300)
    p.add_argument("--range", type=float, default=300)
    p.add_argument("--time", type=float, default=300)
    p.add_argument("--pause", type=float, default=30)
    p.add_argument("--speed", type=float, default=20)
    p.add_argument("--flows", type=int, default=20)
    p.add_argument("--pktBytes", type=int, default=64)
    p.add_argument("--pktPerSec", type=float, default=1)
    p.add_argument("--rateMbps", type=float, default=2)
    r = sub.add_parser("results")
    r.add_argument("files", nargs="+")
    r.add_argument("--anchor", choices=sorted(ANCHOR_KEY))
    args = ap.parse_args()
    (cmd_preflight if args.cmd == "preflight" else cmd_results)(args)


if __name__ == "__main__":
    main()
