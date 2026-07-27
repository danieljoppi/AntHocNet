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
  pdr_pct,delay_ms,delay99_ms,throughput_kbps,nrl,...,energy_j,
  energy_per_pkt_j,energy_res_min_j,energy_res_mean_j,energy_res_sd_j,
  energy_init_j,first_death_s,reorder_ratio,reorder_ratio_max,
  reorder_extent_mean,reorder_extent_max,reorder_buf_max,
  drop_route_pct,drop_queue_pct,drop_mac_pct,
  drop_chan_pct,drop_ttl_pct,drop_setup_pct,drop_reconv_pct,drop_repair_pct,
  path_hops_mean,path_hops_max,path_div_used,
  path_div_max,path_entropy_bits,path_div_window_s,jain_pkts
                                (see METRICS below for the full, append-only
                                 list)

  kind   = "discrete" (named scenario) or "sweep" (one point of a sweep)
  group  = scenario name (discrete) or sweep name (area/pause/scale)
  x      = swept value for sweeps (numeric), empty for discrete
  class  = difficulty class label (density / mobility / load / scale)

The CSV is what make-charts.py reads; re-plotting never re-runs ns-3.
"""
import argparse
import csv
import io
import os
import subprocess
import sys
import tempfile
import time

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
# (delay_off*_ms: -1 encodes infinity); *_sd are the #28 across-run stddevs;
# nrl_bytes is the #132 byte-normalized routing load (empty for CSVs produced
# before it existed — emit() defaults absent columns to "").
# The energy_* / first_death_s columns are #209 (ns-3 only; NS-2 has no
# equivalent, see docs/cross-validation.md): total joules consumed summed over
# nodes, joules per delivered data packet, the residual-energy spread across
# nodes at end of run, the initial per-node energy the run was configured with
# (so residual <= initial is checkable downstream), and the first-node-death
# time with -1 meaning no node died.
# The reorder_* columns are #212 (ns-3 only): the RFC 4737 out-of-order delivery
# ratio pooled over the data flows, the same ratio for the worst single flow,
# the reordering extent (mean/max, in packets) and the reorder-buffer occupancy
# needed to restore order. Multipath reordering is expected AntHocNet behaviour;
# see docs/benchmarks/metrics.md for the exact definitions.
# The drop_*_pct columns are #215 (ns-3 only): why the packets PDR is missing
# went missing, each as a percentage of *offered* packets. The five
# protocol-agnostic causes (route / queue / mac / chan / ttl) are measured
# identically for all four protocols and sum with pdr_pct to ~100 — a
# discrepancy is a harness finding, and scenario_check.py results fails on it.
# The three AntHocNet-only causes (setup / reconv / repair) are a sub-breakdown
# of drop_route_pct and are deliberately **blank**, not 0, for protocols that
# have no such cause.
# The path_*/jain_* columns are #217 route quality (ns-3 only, all four
# protocols): mean and max hop count actually traversed by delivered packets;
# path_div_used = the mean number of distinct next hops that actually *carried*
# a data packet for a destination within one path_div_window_s window (used
# paths, not pheromone-available ones), path_div_max its maximum and
# path_entropy_bits the Shannon entropy of that split; jain_pkts = Jain's
# fairness index over per-flow delivered-packet counts. Baselines are expected
# to read path_div_used ~1 — that is the instrumentation's self-check.
# APPEND ONLY — downstream consumers (make-charts.py, sweep_summary.py,
# bench_parse.py, scenario_check.py) look these columns up by header name, so
# appending is safe and reordering is not.
METRICS = ["pdr_pct", "delay_ms", "delay99_ms", "throughput_kbps", "nrl",
           "jitter_ms", "delay_off50_ms", "delay_off90_ms",
           "pdr_sd", "delay_sd", "delay99_sd", "nrl_sd", "nrl_bytes",
           "energy_j", "energy_per_pkt_j", "energy_res_min_j",
           "energy_res_mean_j", "energy_res_sd_j", "energy_init_j",
           "first_death_s",
           "reorder_ratio", "reorder_ratio_max", "reorder_extent_mean",
           "reorder_extent_max", "reorder_buf_max",
           "drop_route_pct", "drop_queue_pct", "drop_mac_pct", "drop_chan_pct",
           "drop_ttl_pct", "drop_setup_pct", "drop_reconv_pct",
           "drop_repair_pct",
           "path_hops_mean", "path_hops_max", "path_div_used", "path_div_max",
           "path_entropy_bits", "path_div_window_s", "jain_pkts",
           # #89: the thesis's eq 5.1 jitter, a *different quantity* from
           # jitter_ms (arrival-gap change vs delay change) — both are carried
           # because paper-parity claims must cite this one. emit() copies only
           # the names in this list, so a column absent here is silently dropped
           # from every campaign CSV even though anthocnet-compare emits it.
           "jitter_eq51_ms"]
PARAMS = ["runs", "nNodes", "area", "speed", "flows"]
OUT_COLUMNS = (["kind", "group", "x", "scenario", "class", "protocol"]
               + ["runs", "nNodes", "areaX", "speed", "pause", "flows", "propagation"]
               + METRICS)


def build_args(flags, runs, time, protocols, propagation, extra_args=""):
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
    # #177: caller-supplied args, appended verbatim and LAST so they override
    # the taxonomy's own flags (ns-3's CommandLine takes the last occurrence).
    # Same contract as paper-benchmark.yml's extraArgs input: the string is
    # spliced into the `./ns3 run "anthocnet-compare ..."` command line and
    # word-split there, so it may carry several space-separated arguments.
    if extra_args:
        parts.append(extra_args)
    return " ".join(parts)


def run_compare(ns3dir, arg_str, dry_run, label=""):
    """Run one anthocnet-compare invocation; return parsed CSV dict rows."""
    cmd = f'cd "{ns3dir}" && ./ns3 run "anthocnet-compare {arg_str}"'
    if dry_run:
        print(f"[dry-run] {cmd}", file=sys.stderr)
        return []
    print(f"[run] anthocnet-compare {arg_str}", file=sys.stderr)
    # #131: sim cost per point — wall clock always; peak RSS via
    # `/usr/bin/time -v` into a temp file when available (getrusage's
    # RUSAGE_CHILDREN maxrss is a lifetime max, not per-child, so a delta is
    # unreliable). Without /usr/bin/time the RSS field falls back to "-".
    timefile = None
    if os.path.exists("/usr/bin/time"):
        fd, timefile = tempfile.mkstemp(prefix="time-v-", suffix=".log")
        os.close(fd)
        cmd = (f'cd "{ns3dir}" && /usr/bin/time -v -o "{timefile}" '
               f'./ns3 run "anthocnet-compare {arg_str}"')
    t0 = time.monotonic()
    proc = subprocess.run(cmd, shell=True, capture_output=True, text=True,
                          check=False)
    wall = time.monotonic() - t0
    maxrss = "-"
    if timefile is not None:
        try:
            with open(timefile) as fh:
                for ln in fh:
                    if "Maximum resident set size" in ln:
                        maxrss = ln.rsplit(" ", 1)[-1].strip()
        finally:
            os.unlink(timefile)
    if proc.returncode != 0:
        sys.stderr.write(proc.stdout)
        sys.stderr.write(proc.stderr)
        raise SystemExit(f"anthocnet-compare failed ({proc.returncode}) for: {arg_str}")
    # One process runs all protocols, hence proto field "all".
    print(f"##PERF## {label} all {wall:.1f} {maxrss}", flush=True)
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
    ap.add_argument("--extra-args", default="",
                    help="extra anthocnet-compare arguments, appended verbatim "
                         "to every point (pass the whole thing as ONE shell "
                         "argument). Mainly ns-3 attribute overrides, so a "
                         "protocol variant can be A/B'd from a workflow "
                         "dispatch instead of a throwaway branch (#177), e.g. "
                         "'--ns3::anthocnet::RoutingProtocol::BetaData=20 "
                         "--ns3::anthocnet::RoutingProtocol::EnableMultipath=false'")
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

    runs, sim_time = args.runs, args.time
    sweeps = SWEEPS
    if args.quick:
        runs, sim_time = 2, 120
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
                                   build_args(flags, runs, sim_time, args.protocols,
                                              args.propagation, args.extra_args),
                                   args.dry_run, label=name)
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
                                       build_args(flags, runs, sim_time, args.protocols,
                                                  args.propagation, args.extra_args),
                                       args.dry_run, label=f"{name}={x}")
                    emit(w, "sweep", name, x, f"{name}={x}", xlabel,
                         flags.get("pause", ""), args.propagation, rows)
                    f.flush()

    if not args.dry_run:
        print(f"wrote {args.out}", file=sys.stderr)


if __name__ == "__main__":
    main()
