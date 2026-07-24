#!/usr/bin/env python3
"""
run-scenarios.py NS3DIR [options]

Drive anthocnet-compare across a taxonomy of MANET scenarios *and* the canonical
AntHocNet paper's parameter sweeps, and write one tidy, classified CSV that
make-charts.py turns into figures.

Scenario design follows the paper's base scenario and its three sweeps
(Di Caro, Ducatelle, Gambardella, "AntHocNet: an ant-based hybrid routing
algorithm for MANETs", PPSN VIII 2004, §4):

  base: 50 nodes, 1500x300 m, random-waypoint 20 m/s / 30 s pause, 20 CBR
        sources of one 64-byte packet/s, 300 m range, 2 Mbit/s, 802.11 DCF.
  Fig.1 sweep "area"  : extend the long edge 1500 -> 2500 m (longer/sparser).
  Fig.2 sweep "pause" : pause time 0 (constant motion) -> 900 s (static).
  Fig.3 sweep "scale" : scale terrain by f and node count by f^2.

Unlike the paper (which compares only against AODV), this runs every baseline
the harness supports (AODV/OLSR/DSDV) on identical realisations, so the table
classifies all of them per scenario.

Output CSV columns:
  kind,group,x,scenario,class,protocol,runs,nNodes,areaX,speed,pause,flows,
  pdr_pct,delay_ms,delay99_ms,throughput_kbps,nrl

  kind   = "discrete" (named scenario) or "sweep" (one point of a sweep)
  group  = scenario name (discrete) or sweep name (area/pause/scale)
  x      = swept value for sweeps (numeric), empty for discrete
  class  = difficulty class label (density / mobility / load / scale)

The CSV is what make-charts.py reads; re-plotting never re-runs ns-3.
"""
import argparse
import csv
import io
import subprocess
import sys

# --- scenario taxonomy ------------------------------------------------------
# Each value is a set of anthocnet-compare flags. "scenario=paper" pulls in the
# paper base defaults (50 nodes, 1500x300, speed 20, pause 30, range 300,
# 20 flows); other keys override individual axes.

DISCRETE = {
    # name:           (class label,                 {compare flags})
    "dense-small":    ("dense / low-mobility",      {"nNodes": 16, "area": 250, "speed": 5,
                                                     "pause": 1, "flows": 4, "range": 0}),
    "paper-base":     ("sparse / mobile",           {"scenario": "paper"}),
    "sparse-static":  ("sparse / static",           {"scenario": "paper", "pause": 900}),
    "high-mobility":  ("sparse / high-mobility",     {"scenario": "paper", "pause": 0}),
    "heavy-load":     ("dense / heavy-load",        {"nNodes": 50, "areaX": 1500, "areaY": 300,
                                                     "speed": 20, "pause": 30, "range": 300,
                                                     "flows": 40, "cbrBps": 4096}),
    "large-scale":    ("large / mobile",            {"scenario": "paper", "nNodes": 100,
                                                     "areaX": 2100, "areaY": 700}),
}

# Paper sweeps: base flags + one varied axis. Each "values" entry is
# (x, {extra flags for this point}).
def _scale_points():
    pts = []
    for f, n, ax, ay in [(1.0, 50, 1500, 500), (1.4, 98, 2100, 700),
                         (1.8, 162, 2700, 900), (2.0, 200, 3000, 1000)]:
        pts.append((f, {"nNodes": n, "areaX": ax, "areaY": ay}))
    return pts

SWEEPS = {
    # name:   (xlabel, base flags, [(x, {point flags}), ...])
    "area":  ("area long edge (m)", {"scenario": "paper"},
              [(v, {"areaX": v}) for v in (1500, 1900, 2100, 2300, 2500)]),
    "pause": ("pause time (s)", {"scenario": "paper", "areaX": 2500},
              [(v, {"pause": v}) for v in (0, 100, 300, 600, 900)]),
    "scale": ("scale factor", {"scenario": "paper", "areaY": 500},
              _scale_points()),
}

# Columns of the per-run anthocnet-compare CSV we carry through (by header name).
# jitter/offered-load percentiles are the #57 paper-parity QoS metrics
# (delay_off*_ms: -1 encodes infinity); *_sd are the #28 across-run stddevs.
METRICS = ["pdr_pct", "delay_ms", "delay99_ms", "throughput_kbps", "nrl",
           "jitter_ms", "delay_off50_ms", "delay_off90_ms",
           "pdr_sd", "delay_sd", "delay99_sd", "nrl_sd"]
PARAMS = ["runs", "nNodes", "area", "speed", "flows"]
OUT_COLUMNS = (["kind", "group", "x", "scenario", "class", "protocol"]
               + ["runs", "nNodes", "areaX", "speed", "pause", "flows", "propagation"]
               + METRICS)


def build_args(flags, runs, time, protocols, propagation):
    """Turn a flags dict into an anthocnet-compare argument string."""
    merged = dict(flags)
    merged.setdefault("runs", runs)
    if time is not None:
        merged.setdefault("time", time)
    merged.setdefault("protocols", protocols)
    if propagation is not None:
        merged.setdefault("propagation", propagation)
    parts = ["--csv"]
    for k, v in merged.items():
        parts.append(f"--{k}={v}")
    return " ".join(parts)


def run_compare(ns3dir, arg_str, dry_run):
    """Run one anthocnet-compare invocation; return parsed CSV dict rows."""
    cmd = f'cd "{ns3dir}" && ./ns3 run "anthocnet-compare {arg_str}"'
    if dry_run:
        print(f"[dry-run] {cmd}", file=sys.stderr)
        return []
    print(f"[run] anthocnet-compare {arg_str}", file=sys.stderr)
    proc = subprocess.run(cmd, shell=True, capture_output=True, text=True,
                          check=False)
    if proc.returncode != 0:
        sys.stderr.write(proc.stdout)
        sys.stderr.write(proc.stderr)
        raise SystemExit(f"anthocnet-compare failed ({proc.returncode}) for: {arg_str}")
    # Keep only the CSV (header + protocol rows); drop ns-3 build/run chatter and
    # any '# diag' lines.
    keep = [ln for ln in proc.stdout.splitlines()
            if ln.startswith("protocol,")
            or ln.split(",", 1)[0] in ("anthocnet", "aodv", "olsr", "dsdv", "dsr")]
    if not keep or not keep[0].startswith("protocol,"):
        raise SystemExit(f"no CSV parsed from anthocnet-compare for: {arg_str}")
    return list(csv.DictReader(io.StringIO("\n".join(keep))))


def emit(writer, kind, group, x, scenario, klass, pause, propagation, rows):
    for r in rows:
        out = {
            "kind": kind, "group": group, "x": x, "scenario": scenario,
            "class": klass, "protocol": r["protocol"],
            "runs": r.get("runs", ""), "nNodes": r.get("nNodes", ""),
            "areaX": r.get("area", ""), "speed": r.get("speed", ""),
            "pause": pause, "flows": r.get("flows", ""),
            "propagation": propagation or "range",
        }
        for m in METRICS:
            out[m] = r.get(m, "")
        writer.writerow(out)


def main():
    ap = argparse.ArgumentParser(description="Run the AntHocNet scenario matrix + paper sweeps.")
    ap.add_argument("ns3dir", help="configured ns-3 tree with the anthocnet module")
    ap.add_argument("--out", default="scenarios.csv", help="output CSV path")
    ap.add_argument("--runs", type=int, default=5, help="RNG runs to average per point")
    ap.add_argument("--time", type=int, default=None,
                    help="sim time (s) override; default uses each scenario's own")
    ap.add_argument("--protocols", default="anthocnet,aodv,olsr,dsdv")
    ap.add_argument("--propagation", default=None,
                    help="override propagation model for every point: "
                         "range (disk) | tworay; default lets anthocnet-compare "
                         "use its own default (range)")
    ap.add_argument("--only", default="all",
                    help="all|discrete|sweeps|<discrete name>|<sweep name>")
    ap.add_argument("--point", default=None,
                    help="with --only <sweep name>, run just the one point whose "
                         "x value matches this (e.g. 1500 for area, 900 for pause, "
                         "1.4 for scale) instead of the whole sweep")
    ap.add_argument("--quick", action="store_true",
                    help="cheap CI preset: time=120, runs=2, 3 points/sweep")
    ap.add_argument("--dry-run", action="store_true", help="print commands, don't run")
    args = ap.parse_args()

    if args.point is not None and args.only not in SWEEPS:
        raise SystemExit("--point requires --only <sweep name> "
                          f"(one of {', '.join(SWEEPS)}), got --only={args.only!r}")

    runs, time = args.runs, args.time
    sweeps = SWEEPS
    if args.quick:
        runs, time = 2, 120
        sweeps = {k: (xl, base, pts[:: max(1, (len(pts) - 1) // 2)])
                  for k, (xl, base, pts) in SWEEPS.items()}

    want_discrete = args.only in ("all", "discrete") or args.only in DISCRETE
    want_sweeps = args.only in ("all", "sweeps") or args.only in SWEEPS

    with open(args.out, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=OUT_COLUMNS)
        w.writeheader()

        if want_discrete:
            for name, (klass, flags) in DISCRETE.items():
                if args.only in DISCRETE and args.only != name:
                    continue
                rows = run_compare(args.ns3dir,
                                   build_args(flags, runs, time, args.protocols,
                                              args.propagation),
                                   args.dry_run)
                emit(w, "discrete", name, "", name, klass, flags.get("pause", ""),
                     args.propagation, rows)
                f.flush()

        if want_sweeps:
            for name, (xlabel, base, points) in sweeps.items():
                if args.only in SWEEPS and args.only != name:
                    continue
                if args.point is not None:
                    matched = [(x, extra) for x, extra in points
                               if str(x) == args.point]
                    if not matched:
                        valid = ", ".join(str(x) for x, _ in points)
                        raise SystemExit(f"--point {args.point!r} not in sweep "
                                          f"{name!r} (valid: {valid})")
                    points = matched
                for x, extra in points:
                    flags = dict(base)
                    flags.update(extra)
                    rows = run_compare(args.ns3dir,
                                       build_args(flags, runs, time, args.protocols,
                                                  args.propagation),
                                       args.dry_run)
                    emit(w, "sweep", name, x, f"{name}={x}", xlabel,
                         flags.get("pause", ""), args.propagation, rows)
                    f.flush()

    if not args.dry_run:
        print(f"wrote {args.out}", file=sys.stderr)


if __name__ == "__main__":
    main()
