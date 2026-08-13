#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
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
        # FILE = a saved ##BENCH## cell / results-table text, a classified
        # campaign CSV (sniffed by header), or isl-grid output (#259): its
        # --csv schema (sniffed by the 'protocol,runs,rows,cols,...' header)
        # or the human satellite-results.txt ('+Grid' summary + ##RUN## rows
        # + table). --anchor additionally enforces the ns3/tools/anchors.yml
        # floor on AODV rows (#59, single source of thresholds); the
        # satellite floors fire automatically when the input identifies the
        # topology. Exit 1 on any FAIL.
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
              "broch-low-mobility": "broch_low_mobility_aodv_pdr_min",
              # #61/#60 grid arms. Regression floors from our own 20-seed
              # measurement, not literature values — see anchors.yml for why
              # there is nothing external to anchor these against.
              "grid-tworay": "grid_tworay_aodv_pdr_min",
              "grid-nakagami": "grid_nakagami_aodv_pdr_min"}

# #217: core Config::maxPathLength — the cap on the visited path an ant carries
# and therefore on any path the protocol can lay. A delivered data packet
# reported above it is an instrumentation error, not a long route.
MAX_PATH_LENGTH = 100
# #308 phase 2: a pending-queue hold is bounded by QueueTimeout (3 s default);
# 5 s leaves headroom for a raised attribute while still catching an accounting
# error, which is what this rule is for.
HOLD_CEILING_MS = 5000.0

# #230: the baselines all install exactly one route per destination at a time,
# so their path_div_used is 1.0 by construction. Anything materially above that
# is the diversity *window* counting route replacement as concurrent multipath —
# it calibrates the window, and it is the only external check on whether an
# AntHocNet diversity figure means anything.
#
# That excess is NOT correctable by moving this number, and the rule is
# deliberately no longer a FAIL. Two measured facts decide it:
#
#   - The floor is a function of the scenario knobs, not a constant. The #230
#     window sweep at 900 s (paper knobs, one binary, one seed) reads
#     olsr/aodv 1.000/1.000 at windowS=2, 1.116/1.109 at 4, 1.198/1.190 at 6,
#     1.322/1.311 at 10; the dedicated 8 pkt/s cell reads aodv 1.133 at
#     windowS=2. So it also rises with offered rate, and no absolute threshold
#     is simultaneously satisfiable (windowS<=2 pins every protocol, AntHocNet
#     included, at ~1.00 — the sample-starvation floor) and informative.
#   - The excess never invalidates a cell. divUsed is accumulated in its own
#     (node, dest, window) map off the WifiMac AckedMpdu trace
#     (anthocnet-compare.cc CountAckedDataHop / FlushDiversityWindow); PDR,
#     delay, delay99, throughput, NRL and jitter come from FlowMonitor and the
#     energy columns from the energy model. A churn-inflated divUsed cannot
#     move a single published number.
#
# So a contaminated floor makes exactly the diversity columns unquotable and is
# reported once per cell as a WARN naming the floor, not as three per-row FAILs
# that condemn the whole cell (14/14 campaign cells FAILed on nothing else, and
# every one was waved through — the cry-wolf failure SKILL.md warns about).
# The readable quantity is AntHocNet's EXCESS over the in-run floor, so that is
# what gets printed whether the cell is contaminated or clean.
SINGLE_PATH_PROTOS = ("aodv", "olsr", "dsdv")
MULTI_PATH_PROTO = "anthocnet"
SINGLE_PATH_DIV_MAX = 1.10
# The dedicated diversity-measurement cell (#230, run 30650903707): window
# <= DIV_CELL_WINDOW_S is the calibrated churn-free window, where a raised
# offered rate feeds the cells and the single-path baselines legitimately sit
# ABOVE 1.10 (a route break at 8 pkt/s lands packets on both routes within one
# short window — floor measured at aodv=1.133). In that cell diversity is read
# as EXCESS over the in-run single-path floor, so the absolute bound relaxes to
# a sanity ceiling: a baseline above DIV_CELL_SANITY_MAX means the window is
# not churn-free at this rate and the cell is unreadable.
DIV_CELL_WINDOW_S = 2.0
DIV_CELL_SANITY_MAX = 1.50

ROW = re.compile(r"^\s*(?:##BENCH##\s+)?([a-z][\w-]*)((?:\s+[-\d.]+|\s+inf)+)\s*$")

# #259: isl-grid human-mode output. The '+Grid' summary line carries the
# topology context the per-row rules need (node/link count identifies the
# single-ISL anchor topology; the ISL delay is the propagation floor), and its
# presence disambiguates the whole file — the isl-grid table shares ROW's shape
# but orders columns pdr/delay/delay99/thrput/nrl/nrlbytes/jitter, so the MANET
# mapping would silently bind jitter to nrl_bytes.
ISL_GRID = re.compile(r"^\+Grid \w+ \d+x\d+ = (\d+) satellites, (\d+) ISLs"
                      r".* @ ([\d.]+) ms", re.MULTILINE)
# Per-run line: '##RUN## <seed> <proto> <pdr> <delay> <delay99> <thrput> <nrl>
# <nrlBytes> <jitter>'.
ISL_RUN = re.compile(r"^\s*##RUN##\s+(\d+)\s+([a-z][\w-]*)"
                     r"((?:\s+[-\d.]+|\s+inf)+)\s*$")

# Diagnostic lines of a saved cell ('# paths anthocnet divUsed=1.104 ...').
# anthocnet-compare prints one per (family, protocol) after the table; they are
# structured key=value, so parse_results() folds them into the protocol's row
# and the CSV-born rules fire unchanged on text input (#230 finding 3 — the
# results gate returned OK on a cell whose diversity figures were out of band,
# because ROW can never match a '# ' line). '# stddev' is deliberately not a
# family here: no results-mode rule reads dispersion, so parsing it would be
# dead weight.
DIAG_LINE = re.compile(r"^\s*#\s+(paths|energy|drops|reorder)\s+([a-z][\w-]*)\s+(.+)$")
# #365: the workflow-emitted provenance line, last in the compact block.
#   ##PROV## commit=<sha> ref=.. run_id=.. attempt=.. image=.. profile=..
# Only the commit is matched here — it is the field whose absence makes a cell
# unreproducible, and the rest are context a human reads off the same line.
PROV_LINE = re.compile(r"^\s*##PROV##\s+commit=([0-9a-fA-F]{7,40})\b")
# #377: raw drop-identity counters, one row per (seed, protocol).
#   ##DROPID## <seed> <proto> hopTx=.. ... overlap=.. unackedRx=..
# Only the two derived fields are matched: `overlap > 0` is the defect
# condition, and `unackedRx` is what discriminates its cause.
DROPID_LINE = re.compile(
    r"^\s*##DROPID##\s+(\d+)\s+([a-z][\w-]*)\s+.*\boverlap=(-?\d+)\b"
    r".*\bunackedRx=(-?\d+)\b")
# #386: the same ##DROPID## row read for the re-injection cross-checks — the
# fields check_reinj needs (macDrops/reinjected for the events identity and the
# inclusion-exclusion floor). Separate from DROPID_LINE so the #377 rule's
# match groups stay untouched.
DROPID_REINJ_FIELDS = re.compile(
    r"^\s*##DROPID##\s+(\d+)\s+([a-z][\w-]*)\s+.*\bmacDrops=(\d+)\b"
    r".*\breinjected=(\d+)\b.*\bunackedRx=(-?\d+)\b")
# #386: re-injection identity/fate, one row per (seed, anthocnet) on UDP cells.
#   ##REINJ## <seed> <proto> events=.. parsed=.. unparsedIcmp=..
#     unparsedOther=.. ofDelivered=.. pkts=.. pktsDelivBefore=..
#     pktsDelivAfterOnly=.. pktsNever=.. pktsDupDeliv=.. dupRx=.. postTx=..
#     postRx=.. l3DropRoute=.. l3DropTtl=.. l3DropOther=..
#     skips=.. skipsPkts=.. skipsDelivBefore=.. skipsDelivAfterOnly=..
#     skipsNever=..
# Absent for the baselines and on TCP cells (absence encoding, #382); a
# detector-off anthocnet arm emits it with all fields zero. The unparsed*
# fields classify re-injections the (flow, seq) identity could not name — the
# invariance probe's non-data (ICMP) finding, #386 comment 5233656930. Only
# the fields the rules read are matched; the l3Drop* tail is the cuttable
# stage and is not. The #402 skips* tail (capped-skip events, distinct skipped
# keys and their fate partition) is optional so pre-#402 rows still parse;
# rows without it simply skip the #402 rules.
REINJ_LINE = re.compile(
    r"^\s*##REINJ##\s+(\d+)\s+([a-z][\w-]*)\s+events=(\d+)\s+parsed=(\d+)"
    r"\s+unparsedIcmp=(\d+)\s+unparsedOther=(\d+)"
    r"\s+ofDelivered=(\d+)\s+pkts=(\d+)\s+pktsDelivBefore=(\d+)"
    r"\s+pktsDelivAfterOnly=(\d+)\s+pktsNever=(\d+)\s+pktsDupDeliv=(\d+)\b"
    r"(?:.*\bskips=(\d+)\s+skipsPkts=(\d+)\s+skipsDelivBefore=(\d+)"
    r"\s+skipsDelivAfterOnly=(\d+)\s+skipsNever=(\d+)\b)?")
# #386: the knob the coherence rule reads. Preflight cannot see extraArgs (it
# takes numeric scenario args only), so detector-off coherence is enforced
# results-side from the ##CONFIG## attr dump of effective attribute values.
CONFIG_MACDET_OFF = re.compile(
    r"^\s*##CONFIG##\s+attr\s+EnableMacFailureDetector=(?:false|0)\s*$",
    re.MULTILINE)
# #402: the re-injection cap knob, from the same ##CONFIG## attr dump. Absent
# (pre-#369 or pre-#386 logs) and =0 both mean uncapped, where the adapter's
# MacReinjectSkip trace structurally never fires — so skips > 0 there is an
# instrumentation regression, never a measurement.
CONFIG_REINJ_CAP = re.compile(
    r"^\s*##CONFIG##\s+attr\s+MaxReinjectPerPacket=(\d+)\s*$", re.MULTILINE)
# #308 phase 2: the per-run common-set rows. Unlike the diagnostic lines above
# there is one per (run, protocol), so they are folded into the protocol's row
# as an extremum rather than merged field-by-field — the rules below ask "did
# ANY run produce an impossible hopsCommon", which is what a broken flow key or
# an unconnected TTL hook would show up as.
#   ##COMMON## <run> <proto> <nSelf> <nCommon> <p99C> <meanC> <p99S> [<hopsC> <hopsS>]
# The two hop fields are absent on inputs predating the instrumentation; those
# skip, exactly like an absent CSV column.
COMMON_LINE = re.compile(
    r"^\s*##COMMON##\s+\d+\s+([a-z][\w-]*)\s+\d+\s+(\d+)\s+\S+\s+\S+\s+\S+"
    r"(?:\s+(\S+)\s+\S+)?\s*$")
# #308 phase 2 step 3: per-run channel occupancy.
#   ##AIR## <run> <proto> <txS> <rxS> <ccaBusyS> <busyPct>
# Absent entirely when --energyJ=0 leaves the PHY State trace unconnected, which
# is why "row present but all-zero" is a failure rather than a configuration:
# the harness prints no row at all in that case (see docs/benchmarks/metrics.md).
# #308 phase 2 step 4: per-run pending-queue hold rows, AntHocNet only.
#   ##HOLD## <run> <proto> <setupN> <setupMean> <setupMax> <reconvN> ... <repairMax>
# Absent for every protocol without the instrumentation, deliberately: a zero row
# would assert "never held a packet" where the truth is "nobody looked".
HOLD_LINE = re.compile(
    r"^\s*##HOLD##\s+\d+\s+([a-z][\w-]*)((?:\s+[-\d.]+){9})\s*$")
AIR_LINE = re.compile(
    r"^\s*##AIR##\s+\d+\s+([a-z][\w-]*)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)"
    r"\s+([-\d.]+)\s*$")
DIAG_KEYS = {
    "paths":   {"hopsMean": "hops", "hopsMax": "hops_max", "divUsed": "div",
                "divMax": "div_max", "entropyBits": "entropy",
                "windowS": "div_window"},
    # energy(J)/J-per-pkt live at table positions 10/11, which the 9-number
    # ##BENCH## block does not carry; the '# energy' line adds the residual
    # bounds. 'pdr' on the '# drops' line is deliberately unmapped — the
    # table row's pdr is the authoritative one and must not be overwritten
    # by a rounded duplicate.
    "energy":  {"initJ": "energy_init", "resMinJ": "res_min",
                "resMeanJ": "res_mean"},
    "drops":   {"route": "drop_route", "queue": "drop_queue",
                "mac": "drop_mac", "chan": "drop_chan", "ttl": "drop_ttl",
                "setup": "drop_setup", "reconv": "drop_reconv",
                "repair": "drop_repair"},
    "reorder": {"ratio": "reorder_ratio", "ratioWorstFlow": "reorder_ratio_max",
                "extentMean": "reorder_extent_mean",
                "extentMax": "reorder_extent_max", "bufMax": "reorder_buf_max"},
}

issues = []


def report(level, msg):
    issues.append(level)
    print(f"{level}: {msg}")


def yml_floor(key):
    with open(ANCHORS_YML) as fh:
        for line in fh:
            if line.split(":")[0].strip() == key:
                return float(line.split(":")[1].split("#")[0])
    sys.exit(f"FAIL: {key} not found in {ANCHORS_YML}")


def anchor_floor(anchor):
    return yml_floor(ANCHOR_KEY[anchor])


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
    # #61 mobility-model coherence. Same shape as the #230 pathWindowS rule:
    # a knob that the selected model ignores costs nothing to check here and,
    # unchecked, produces a sweep that believes it varied something it did not.
    if a.mobility == "gaussmarkov" and a.pause != 0:
        report("FAIL", f"--pause={a.pause}s with --mobility=gaussmarkov: "
                       "Gauss-Markov nodes never stop, so pause is inert. A "
                       "pause sweep under this model would produce N identical "
                       "cells and read as 'pause has no effect' (#61); pass "
                       "--pause=0 to state that explicitly")
    if a.mobility == "ssrwp" and a.speed <= 0:
        report("FAIL", "--mobility=ssrwp needs a positive speed: the "
                       "steady-state distribution divides by speed and is "
                       "undefined at zero (#61)")
    # #60 channel-model coherence. The degree/connectivity arithmetic above is
    # a *disk-model* calculation: it treats `range` as a hard link cutoff. Under
    # tworay and nakagami there is no cutoff — links are governed by tx power
    # vs receiver sensitivity, and under nakagami by a random draw on top of
    # that — so `range` bounds nothing and the estimate is indicative only.
    # Pre-existing for tworay; stated now rather than left for the fading arm
    # to discover.
    if a.propagation != "range":
        report("WARN", f"--propagation={a.propagation}: --range is inert (no "
                       "hard cutoff), so the node-degree and connectivity "
                       "figures above are a disk-model estimate and do not "
                       "bound this channel's links (#24, #60)")
    # #63: a saturating TCP arm invalidates the offered-load arithmetic above.
    # BulkSend sends as fast as the window allows, so `cbrBps`, `pktPerSec` and
    # the channel-saturation check are all computed from a load the run does
    # not actually offer.
    if a.transport == "tcp":
        report("WARN", "--transport=tcp is a SATURATING arm: BulkSend ignores "
                       "cbrBps/pktPerSec, so the offered-load and "
                       "channel-saturation figures above do not describe this "
                       "run. It is its own regime, not a variant of the base "
                       "scenario — do not compare its cells to UDP ones, and "
                       "read ##GOODPUT## rather than pdr/thrput (#63)")
    if a.propagation == "nakagami":
        report("WARN", "nakagami is the harness's first stochastic channel: "
                       "link existence is a random draw, so per-seed "
                       "dispersion is higher than on the deterministic "
                       "channels and the #293 runs floor should be treated as "
                       "a minimum, not a target — check the interval widths "
                       "before quoting a tail metric (#60)")
    if a.mobility != "rwp":
        report("WARN", f"--mobility={a.mobility} is not the model the "
                       "published corpus was measured under (rwp), so its "
                       "results are not comparable to the published cells. "
                       "The Broch floor is RWP-specific and does not apply; "
                       "validate with --anchor grid-tworay / grid-nakagami "
                       "instead, which are regression floors from the v1.4.0 "
                       "grid rather than literature values (#59, #61, #60)")
    # #230: the diversity window must be short relative to how fast the
    # topology changes, or a route being *replaced* inside one window reads as
    # two concurrent paths and path_div_used stops meaning multipath. Two nodes
    # close at up to 2*speed, so a link survives on the order of
    # range/(2*speed); a multi-hop route breaks faster still, making this the
    # generous bound. Skipped on a static field, where nothing churns — which is
    # exactly why sparse-static was the only scenario whose baselines read ~1.
    #
    # This is the rule that would have caught #230 before spending a campaign:
    # at the paper-base defaults it fires on the shipped 10 s default.
    if a.pause < a.time and a.speed > 0:
        churn = a.range / (2 * a.speed)
        print(f"  path-diversity window {a.pathWindowS}s vs ~{churn:.1f}s "
              f"link lifetime at {a.speed} m/s over {a.range} m")
        if a.pathWindowS > churn:
            report("FAIL", f"pathWindowS={a.pathWindowS}s exceeds the ~"
                           f"{churn:.1f}s link lifetime — route replacement "
                           "will be counted as concurrent multipath and "
                           "path_div_* will not discriminate (#230); lower it "
                           "before dispatching")
        elif a.pathWindowS > churn / 2:
            report("WARN", f"pathWindowS={a.pathWindowS}s is over half the ~"
                           f"{churn:.1f}s link lifetime — path_div_* will be "
                           "inflated by route churn; verify the single-path "
                           "baselines read <=1.05 before quoting it")
        # #230: the other end of the same squeeze. A (node, destination,
        # window) cell can only report diversity > 1 if at least two packets
        # land in it, so shortening the window to escape churn eventually
        # forces every cell to exactly 1.0 — measured: at 0.5-2 s on paper-base
        # all four protocols read 1.000-1.002, AntHocNet included. Sampling is
        # per flow, so packets-per-cell is bounded above by pktPerSec*window.
        samples = a.pktPerSec * a.pathWindowS
        print(f"  ~{samples:.1f} packet(s) per diversity cell "
              f"({a.pktPerSec}/s x {a.pathWindowS}s)")
        if samples < 2.0:
            report("FAIL", f"pathWindowS={a.pathWindowS}s at {a.pktPerSec} "
                           f"pkt/s gives ~{samples:.1f} packets per cell — a "
                           "cell needs >=2 to report diversity above 1, so "
                           "path_div_used is pinned at 1.0 for every protocol "
                           "(#230)")
        elif samples < 4.0:
            # Measured, not guessed: paper-base at 1 pkt/s x 2 s (exactly the
            # 2-sample floor) reads anthocnet 1.002 and aodv 1.002 — the floor
            # is necessary but nowhere near sufficient, because a cell holding
            # two packets can only ever report 1.0 or 2.0.
            report("WARN", f"~{samples:.1f} packets per diversity cell is at "
                           "the floor — measured at paper-base, 2 packets/cell "
                           "gave anthocnet 1.002 vs aodv 1.002, i.e. no "
                           "separation. Treat path_div_* as underpowered here "
                           "(#230)")
        if a.pathWindowS > churn and samples < 4.0:
            report("FAIL", "no usable pathWindowS at these knobs: churn needs "
                           f"<={churn:.1f}s, adequate sampling needs "
                           f">={4.0 / a.pktPerSec:.1f}s. Raise pktPerSec or "
                           "measure diversity per-packet instead of "
                           "per-window (#230)")
    verdict()


def parse_results(path):
    """Yield dicts with proto/pdr/delay/delay99/nrl/jitter (+context) per row.

    Energy fields (#209) are present only for runs produced after energy
    instrumentation landed; older inputs simply omit them and the energy rules
    below are skipped. The results table carries the two headline energy
    columns (energy(J), J/pkt) at positions 10/11; the residual spread, the
    configured initial energy and the first-death time live in the CSV only
    (the human output puts them on a '# energy' line, which ROW does not match).

    Reordering (#212), drop-cause (#215) and route-quality (#217) fields ride
    the '# reorder' / '# drops' / '# paths' / '# energy' diagnostic lines of a
    saved cell rather than the fixed-width table, and until #230's second
    finding they were **not parsed at all** on text input — every rule below
    silently skipped, so `results` on a ##BENCH## cell certified only the four
    headline invariants while returning the same OK it returns for a fully
    checked CSV. That is exactly the input the skill's own order-of-operations
    recommends validating *before* a taxonomy sweep, so the cheap pre-sweep
    check was the one that could not see the defects the sweep would be full
    of. DIAG_LINE/DIAG_KEYS below close that: the diagnostic lines are
    structured key=value, so they parse into the same row dict the CSV branch
    yields and every existing rule fires unchanged on both input formats.

    Fields absent from an input (older runs predating an instrumentation, the
    energy table columns the 9-number ##BENCH## block does not carry, the
    AntHocNet-only drop causes printed as '-' for the other protocols) parse
    to None and their rules skip, exactly like an absent CSV column. If a file
    holds several tables for the same protocol, diagnostics attach to that
    protocol's last row — a saved single-point cell has one row per protocol,
    which is the intended input.
    """
    with open(path) as fh:
        text = fh.read()
    first = text.lstrip().splitlines()[0] if text.strip() else ""
    # #259: isl-grid --csv. One row per protocol; rows/cols/nodes/links/
    # isl_delay_ms are topology context the satellite rules read, mapped under
    # sat_*/isl_delay keys so they can never collide with a MANET column.
    if first.startswith("protocol,runs,rows,cols,"):
        for r in csv.DictReader(text.splitlines()):
            yield {"where": f"isl-grid {r.get('rows')}x{r.get('cols')}",
                   "proto": r.get("protocol"), "runs": r.get("runs"),
                   "pdr": r.get("pdr_pct"), "delay": r.get("delay_ms"),
                   "delay99": r.get("delay99_ms"), "nrl": r.get("nrl"),
                   "jitter": r.get("jitter_ms"),
                   "isl_delay": r.get("isl_delay_ms"),
                   "sat_nodes": r.get("nodes"), "sat_links": r.get("links")}
        return
    # #259: isl-grid human mode (the satellite-results.txt artifact). The
    # '+Grid' summary identifies the format and supplies the topology context;
    # ##RUN## per-seed rows and the aggregate table rows both map into the
    # standard row dict — note jitter sits at position 6 here (position 5 is
    # nrl_bytes), which is why this input must not fall through to the MANET
    # ROW mapping below. '# diag' ant-tally lines are deliberately not parsed:
    # no results-mode rule reads them.
    grid = ISL_GRID.search(text)
    if grid:
        ctx = {"isl_delay": grid.group(3), "sat_nodes": grid.group(1),
               "sat_links": grid.group(2)}
        base = os.path.basename(path)
        for line in text.splitlines():
            m = ISL_RUN.match(line)
            if m:
                seed, proto = m.group(1), m.group(2)
                nums = m.group(3).split()
                if len(nums) >= 7:
                    yield {"where": f"{base} run{seed}", "proto": proto,
                           "pdr": nums[0], "delay": nums[1],
                           "delay99": nums[2], "nrl": nums[4],
                           "jitter": nums[6], **ctx}
                continue
            m = ROW.match(line)
            if not m:
                continue
            proto, nums = m.group(1), m.group(2).split()
            if proto in ("protocol",) or len(nums) < 7:
                continue
            yield {"where": base, "proto": proto,
                   "pdr": nums[0], "delay": nums[1], "delay99": nums[2],
                   "nrl": nums[4], "jitter": nums[6], **ctx}
        return
    if first.startswith("kind,") or ",protocol," in first:
        for r in csv.DictReader(text.splitlines()):
            yield {"where": f"{r.get('group')}={r.get('x')}",
                   "proto": r.get("protocol"), "runs": r.get("runs"),
                   "pdr": r.get("pdr_pct"), "delay": r.get("delay_ms"),
                   "delay99": r.get("delay99_ms"), "nrl": r.get("nrl"),
                   "jitter": r.get("jitter_ms"),
                   "energy": r.get("energy_j"),
                   "energy_per_pkt": r.get("energy_per_pkt_j"),
                   "res_min": r.get("energy_res_min_j"),
                   "res_mean": r.get("energy_res_mean_j"),
                   "energy_init": r.get("energy_init_j"),
                   "reorder_ratio": r.get("reorder_ratio"),
                   "reorder_ratio_max": r.get("reorder_ratio_max"),
                   "reorder_extent_mean": r.get("reorder_extent_mean"),
                   "reorder_extent_max": r.get("reorder_extent_max"),
                   "reorder_buf_max": r.get("reorder_buf_max"),
                   "drop_route": r.get("drop_route_pct"),
                   "drop_queue": r.get("drop_queue_pct"),
                   "drop_mac": r.get("drop_mac_pct"),
                   "drop_chan": r.get("drop_chan_pct"),
                   "drop_ttl": r.get("drop_ttl_pct"),
                   "drop_setup": r.get("drop_setup_pct"),
                   "drop_reconv": r.get("drop_reconv_pct"),
                   "drop_repair": r.get("drop_repair_pct"),
                   "hops": r.get("path_hops_mean"),
                   "hops_max": r.get("path_hops_max"),
                   "div": r.get("path_div_used"),
                   "div_max": r.get("path_div_max"),
                   "div_window": r.get("path_div_window_s"),
                   "entropy": r.get("path_entropy_bits"),
                   "jain": r.get("jain_pkts")}
        return
    rows = []          # yielded in table order
    by_proto = {}      # diagnostics merge into the protocol's last row
    # #293 runs-floor: a saved cell's per-seed ##RUN## rows reveal the run
    # count the 9-number table/##BENCH## block does not carry.
    run_counts = {}
    for proto in re.findall(r"^##RUN##\s+\d+\s+([A-Za-z][\w-]*)", text,
                            re.MULTILINE):
        run_counts[proto] = run_counts.get(proto, 0) + 1
    for line in text.splitlines():
        m = ROW.match(line)
        if m:
            proto, nums = m.group(1), m.group(2).split()
            if proto in ("protocol",) or len(nums) < 5:
                continue
            row = {"where": os.path.basename(path), "proto": proto,
                   "pdr": nums[0], "delay": nums[1], "delay99": nums[2],
                   "nrl": nums[4], "runs": run_counts.get(proto)}
            if len(nums) >= 6:
                row["jitter"] = nums[5]
            if len(nums) >= 11:  # #209: ... nrlBytes, energy(J), J/pkt
                row["energy"] = nums[9]
                row["energy_per_pkt"] = nums[10]
            if len(nums) >= 13:  # #217: ... J/pkt, hops, jain
                row["hops"] = nums[11]
                row["jain"] = nums[12]
            rows.append(row)
            by_proto[proto] = row
            continue
        c = COMMON_LINE.match(line)
        if c:
            row = by_proto.get(c.group(1))
            if row is None:
                continue  # ##COMMON## with no table row above it
            n_common, hops_c = int(c.group(2)), c.group(3)
            if hops_c is None:
                continue  # predates the hop instrumentation
            if hops_c == "na" or float(hops_c) == 0.0:
                if n_common:
                    row["hops_common_missing"] = \
                        row.get("hops_common_missing", 0) + 1
                continue
            v = float(hops_c)
            row["hops_common_min"] = min(row.get("hops_common_min", v), v)
            row["hops_common_max"] = max(row.get("hops_common_max", v), v)
            continue
        h = HOLD_LINE.match(line)
        if h:
            row = by_proto.get(h.group(1))
            if row is None:
                continue
            f = [float(x) for x in h.group(2).split()]
            # (count, mean, max) x (setup, reconv, repair)
            if min(f) < 0.0:
                row["hold_negative"] = row.get("hold_negative", 0) + 1
            worst = max(f[2], f[5], f[8])          # the three max fields
            row["hold_max_ms"] = max(row.get("hold_max_ms", worst), worst)
            for base in (0, 3, 6):
                if f[base] == 0.0 and f[base + 1] > 0.0:
                    row["hold_mean_no_count"] = \
                        row.get("hold_mean_no_count", 0) + 1
            continue
        a = AIR_LINE.match(line)
        if a:
            row = by_proto.get(a.group(1))
            if row is None:
                continue  # ##AIR## with no table row above it
            tx, rx, cca = (float(a.group(2)), float(a.group(3)),
                           float(a.group(4)))
            busy_pct = float(a.group(5))
            if min(tx, rx, cca) < 0.0:
                row["air_negative"] = row.get("air_negative", 0) + 1
            if tx + rx + cca == 0.0:
                row["air_zero_runs"] = row.get("air_zero_runs", 0) + 1
            row["air_busy_max"] = max(row.get("air_busy_max", busy_pct),
                                      busy_pct)
            continue
        d = DIAG_LINE.match(line)
        if not d:
            continue
        family, proto = d.group(1), d.group(2)
        row = by_proto.get(proto)
        if row is None:
            continue  # diagnostic with no table row above it — nothing to bind to
        keys = DIAG_KEYS[family]
        for k, v in re.findall(r"([A-Za-z]\w*)=([-\w.]+)", d.group(3)):
            # '-' (an AntHocNet-only cause on a baseline row) and other
            # non-numeric junk are stored as-is; num() turns them into None,
            # so the rules skip them exactly like an absent CSV blank.
            if k in keys:
                row[keys[k]] = v
    yield from rows


def check_provenance(path):
    """#365: a saved log cell must say which commit produced it.

    Scoped to inputs carrying ##BENCH##/##RUN## rows — i.e. a fetched job-log
    tail. Campaign CSVs are deliberately exempt: their provenance is the run ID
    in the filename plus the ledger rule in methodology.md, not a line in the
    data, and warning on them would train the reader to ignore this warning.

    WARN rather than FAIL. A cell measured before the marker existed
    (everything up to `v1.3.0`) legitimately has no line, and those numbers are
    still readable — they are just pinned by release rather than by SHA. What
    the warning catches is the case that actually costs something: a *recent*
    run whose tail was cut above the line, or a workflow that stopped emitting
    it, where the reader would otherwise assume provenance was recorded.
    """
    with open(path) as fh:
        text = fh.read()
    if "##BENCH##" not in text and "##RUN##" not in text:
        return
    base = os.path.basename(path)
    for line in text.splitlines():
        m = PROV_LINE.match(line)
        if m:
            print(f"ok: {base}: measured at {m.group(1)[:7]}")
            return
    report("WARN", f"{base}: no ##PROV## line — this cell does not record the "
                   "commit it was measured at (#365). Expected last in the "
                   "compact block: either the run predates the marker "
                   "(<= v1.3.0, pinned by release instead) or the log tail was "
                   "cut above it. Do not publish a number whose version is "
                   "unknown.")


def check_drop_identity(path):
    """#377: the drop-cause books must not overlap.

    `drop_chan_pct` is a residual — hopLoss minus the counted causes — so it is
    only non-negative while those causes are a subset of hopLoss. `overlap > 0`
    on a ##DROPID## row means they are not, and every percentage in the
    `drop_*` family for that cell is then an attribution of packets to causes
    that double-count each other.

    Since the residual carves out `macLost` (retry-limit drops minus the
    delivered-but-ACK-lost ones) rather than the raw MAC-drop count, `overlap`
    can no longer go positive for the reason #377 reported — `macLost` is a
    subset of hopLoss by construction. The rule is kept anyway, and that is
    deliberate: a positive value now means the books have overlapped for some
    *other* reason, which is exactly the case nobody is watching for.

    The existing rule catches this from the other side (drop_chan_pct outside
    [0,100]), but only in aggregate and only once the percentages exist. Here
    it is per seed, in counts, and it also reports `unackedRx` — the
    delivered-but-ACK-lost count — because that is what says whether the
    overlap has the hypothesised cause or another one.

    WARN, not FAIL: the headline metrics (pdr/delay/delay99/thrput/nrl) come
    from FlowMonitor and never touch these counters, so a cell with an overlap
    is still readable for everything except the drop family. Failing it would
    block reads that are perfectly sound.
    """
    with open(path) as fh:
        text = fh.read()
    if "##DROPID##" not in text:
        return
    worst = {}
    for line in text.splitlines():
        m = DROPID_LINE.match(line)
        if not m:
            continue
        seed, proto, overlap, unacked = m.group(1), m.group(2), int(m.group(3)), int(m.group(4))
        if overlap <= 0:
            continue
        # Report the worst seed per protocol rather than one line per seed: a
        # 20-seed fading cell would otherwise emit 80 identical warnings and
        # bury every other finding in the run.
        if proto not in worst or overlap > worst[proto][1]:
            worst[proto] = (seed, overlap, unacked)
    base = os.path.basename(path)
    for proto, (seed, overlap, unacked) in sorted(worst.items()):
        report("WARN", f"{base}/{proto}: drop-cause books overlap by {overlap} "
                       f"packets at seed {seed} (unackedRx={unacked}) — "
                       "drop_chan_pct is a residual and goes negative here, so "
                       "the whole drop_* family is unreadable for this cell "
                       "(#377). pdr/delay/delay99/thrput/nrl are unaffected. "
                       "unackedRx of the same order supports the "
                       "delivered-but-ACK-lost mechanism; unackedRx near zero "
                       "refutes it and the cause is something else.")


def check_reinj(path):
    """#386: the re-injection identity/fate books must be internally coherent.

    ##REINJ## is the direct counter behind the #386 inclusion-exclusion floor
    (>=59% of re-injections are of already-delivered packets). Its trace fires
    at the SAME adapter site that increments MacReinjectedPackets(), so
    `events` and ##DROPID##'s `reinjected` are two readings of one increment —
    a mismatch is an instrumentation bug, never a protocol behaviour. The
    parse books must close the same way: parsed + unparsedIcmp + unparsedOther
    == events. A non-zero unparsed count itself is a FINDING, not an error —
    the invariance probe measured 2 events at seed 2 the SeqTs identity could
    not name (#386 comment 5233656930): the detector re-injects any non-ant IP
    payload, ICMP included — so it WARNs with the counts rather than FAILing.

    Controls (the #229/#230 rule, a-priori values):
      - baselines emit NO row at all (absence encoding, #382) — a row with a
        non-anthocnet protocol is a harness regression, FAIL;
      - an EnableMacFailureDetector=false arm emits the row with events=0 (a
        measured zero; the ##CONFIG## attr dump carries the effective knob
        value, so the coherence is checkable results-side — preflight cannot
        see extraArgs), FAIL otherwise.

    The floor comparison is WARN, not FAIL: ofDelivered counts sink deliveries
    strictly before re-injection time, while the ##DROPID## floor is built from
    next-hop arrivals (unackedRx), so the two sit on slightly different events
    and a small shortfall can be timing, not books. A large one means the
    direct counter and the bound disagree and #386's premise needs re-checking.

    Two further identities were promoted to FAILs after reading 2, per the
    amended pre-registration (#386 comment 5233754808): ofDelivered >=
    pktsDelivBefore (a key delivered before its first re-injection contributes
    at least one delivered-at-fire-time event) and pktsDupDeliv <=
    pktsDelivBefore + pktsDelivAfterOnly (a duplicate-delivered key is a
    delivered key). Both hold by construction of the (flow, seq) keying, so a
    violation means the keying itself is unsound.

    #402 capped-skip books (the skips* tail; absent on pre-#402 rows, which
    skip these rules). Under a MaxReinjectPerPacket cap a packet can
    accumulate re-injections — inflating the per-hop books — and THEN hit the
    cap, so its final MAC drop is terminal; the uncapped #388 attribution
    never saw "was re-injected" and "ended terminal" on the same packet and
    double-counted every capped-terminal drop of a delivered packet (+8.50 pp
    residue on the cap=1 probe cell, vs +3.32 uncapped). The harness now
    subtracts delivered-key skip events from the terminal-MAC numerator, so
    the drop-cause identity closes inside the existing tolerance on capped
    arms — which is why the identity rule itself needs no cap-aware special
    case. Checked here:
      - skips > 0 on an arm whose ##CONFIG## has MaxReinjectPerPacket=0 (or
        absent) is FAIL: the adapter's MacReinjectSkip trace fires only
        inside the cap != 0 branch, so an uncapped skip count is an
        instrumentation regression, never a measurement;
      - skipsDelivBefore + skipsDelivAfterOnly + skipsNever must equal
        skipsPkts (the partition is exact, same rule as the pkts partition),
        FAIL otherwise.
    """
    with open(path) as fh:
        text = fh.read()
    if "##REINJ##" not in text:
        return
    base = os.path.basename(path)
    detector_off = bool(CONFIG_MACDET_OFF.search(text))
    cap_m = CONFIG_REINJ_CAP.search(text)
    reinj_cap = int(cap_m.group(1)) if cap_m else 0
    # seed -> (macDrops, reinjected, unackedRx) from the anthocnet ##DROPID##
    # rows, for the cross-book identity and the floor.
    dropid = {}
    for line in text.splitlines():
        dm = DROPID_REINJ_FIELDS.match(line)
        if dm and dm.group(2) == "anthocnet":
            dropid[dm.group(1)] = (int(dm.group(3)), int(dm.group(4)),
                                   int(dm.group(5)))
    for line in text.splitlines():
        m = REINJ_LINE.match(line)
        if not m:
            continue
        seed, proto = m.group(1), m.group(2)
        events, parsed = int(m.group(3)), int(m.group(4))
        unp_icmp, unp_other = int(m.group(5)), int(m.group(6))
        of_deliv, pkts = int(m.group(7)), int(m.group(8))
        before, after_only, never = (int(m.group(9)), int(m.group(10)),
                                     int(m.group(11)))
        dup_deliv = int(m.group(12))
        # #402 skips* tail — None on pre-#402 rows (optional group).
        skips = int(m.group(13)) if m.group(13) is not None else None
        tag = f"{base}/{proto}"
        if proto != "anthocnet":
            report("FAIL", f"{tag}: ##REINJ## row for a protocol with no "
                           f"detector at seed {seed} — the baselines must stay "
                           "absent, not zero (#386 control); the harness "
                           "emission gate has regressed")
            continue
        if seed in dropid and events != dropid[seed][1]:
            report("FAIL", f"{tag}: events={events} != reinjected="
                           f"{dropid[seed][1]} at seed {seed} — one increment "
                           "site, two readings; the ##REINJ## trace or the "
                           "adapter counter is broken (#386)")
        if parsed + unp_icmp + unp_other != events:
            report("FAIL", f"{tag}: parsed={parsed} + unparsedIcmp={unp_icmp} "
                           f"+ unparsedOther={unp_other} != events={events} at "
                           f"seed {seed} — every re-injection is either named "
                           "by the (flow, seq) identity or classified "
                           "unparsed; a gap means the books are partial "
                           "(#386)")
        elif unp_icmp + unp_other > 0:
            report("WARN", f"{tag}: {unp_icmp + unp_other} non-data "
                           f"re-injection(s) at seed {seed} "
                           f"(unparsedIcmp={unp_icmp}, "
                           f"unparsedOther={unp_other}) — the detector's "
                           "books include re-injected traffic the SeqTs "
                           "identity cannot name (ICMP etc., #386 comment "
                           "5233656930). A finding about what NotifyTxError "
                           "re-injects, not an error; the fate buckets cover "
                           "only the parsed events")
        if of_deliv > events or before + after_only + never != pkts:
            report("FAIL", f"{tag}: fate buckets incoherent at seed {seed} "
                           f"(ofDelivered={of_deliv}/events={events}, "
                           f"{before}+{after_only}+{never} != pkts={pkts}) — "
                           "the partition must be exact (#386)")
        # #386 reading-2 promotions (comment 5233754808): two identities the
        # event and packet views must satisfy by construction; a violation is
        # unsound keying, not noise.
        if of_deliv < before:
            report("FAIL", f"{tag}: ofDelivered={of_deliv} < "
                           f"pktsDelivBefore={before} at seed {seed} — every "
                           "already-delivered key contributes at least one "
                           "delivered-at-fire-time event; the (flow,seq) "
                           "keying is unsound (#386)")
        if dup_deliv > before + after_only:
            report("FAIL", f"{tag}: pktsDupDeliv={dup_deliv} > "
                           f"pktsDelivBefore={before} + "
                           f"pktsDelivAfterOnly={after_only} at seed {seed} — "
                           "a duplicate-delivered key must be a delivered key "
                           "(#386)")
        if detector_off and events > 0:
            report("FAIL", f"{tag}: events={events} at seed {seed} with "
                           "EnableMacFailureDetector=false in ##CONFIG## — "
                           "the detector-off control must read 0; either the "
                           "gate or the config dump is wrong (#386)")
        # #402 capped-skip rules (see docstring); rows without the skips*
        # tail are pre-#402 and skip both.
        if skips is not None:
            skips_pkts = int(m.group(14))
            s_before, s_after, s_never = (int(m.group(15)), int(m.group(16)),
                                          int(m.group(17)))
            if skips > 0 and reinj_cap == 0:
                report("FAIL", f"{tag}: skips={skips} at seed {seed} on an "
                               "uncapped arm (MaxReinjectPerPacket=0 or "
                               "absent in ##CONFIG##) — the MacReinjectSkip "
                               "trace fires only under a non-zero cap, so an "
                               "uncapped skip count is an instrumentation "
                               "regression (#402)")
            if s_before + s_after + s_never != skips_pkts:
                report("FAIL", f"{tag}: skip fate buckets incoherent at seed "
                               f"{seed} ({s_before}+{s_after}+{s_never} != "
                               f"skipsPkts={skips_pkts}) — the partition must "
                               "be exact (#402)")
        if seed in dropid:
            mac_drops, reinjected, unacked = dropid[seed]
            floor = reinjected + unacked - mac_drops
            if floor > 0 and of_deliv < floor:
                report("WARN", f"{tag}: ofDelivered={of_deliv} below the "
                               f"inclusion-exclusion floor {floor} "
                               f"(reinjected={reinjected}+unackedRx={unacked}"
                               f"-macDrops={mac_drops}) at seed {seed} — the "
                               "direct counter sits under the bound it was "
                               "built to confirm. A small shortfall can be "
                               "sink-vs-next-hop timing; a large one says the "
                               "#386 books disagree (#386)")


def _fnum(row, key):
    try:
        return float(row.get(key))
    except (TypeError, ValueError):
        return None


def check_path_diversity(rows):
    """#230: read path diversity as excess over the in-run single-path floor.

    `path_div_used` counts distinct next hops that carried data for a
    destination inside one `pathWindowS` window. A protocol that installs one
    route per destination can only exceed 1.0 by having that route *replaced*
    inside the window, so whatever the baselines read above 1.0 is the churn
    floor of that scenario — measured, in-run, by three protocols at once. The
    only claim the metric can support is AntHocNet's excess over that floor,
    and that is what this prints; the absolute value is uninterpretable on its
    own (see the sweep in the SINGLE_PATH_DIV_MAX comment).

    One report per cell, not per row. Contamination is a property of the
    window, so three baselines breaching one threshold is one finding stated
    three times, and it was the whole content of 14/14 campaign FAILs.

    Rows are grouped by `where` — one saved cell is one group; a campaign CSV
    groups per scenario, which is the level the floor is a constant at.
    Inputs without diversity columns, and cells with no single-path row to
    measure a floor against, produce nothing.
    """
    groups = {}
    for r in rows:
        div = _fnum(r, "div")
        if div is None:
            continue
        groups.setdefault(r["where"], []).append((r["proto"], div, r))
    for where, grp in groups.items():
        floors = [(d, p) for p, d, _ in grp if p in SINGLE_PATH_PROTOS]
        if not floors:
            continue
        floor, floor_proto = max(floors)
        multi = next((d for p, d, _ in grp if p == MULTI_PATH_PROTO), None)
        windows = [w for w in (_fnum(r, "div_window") for _, _, r in grp)
                   if w is not None]
        window = max(windows) if windows else None
        churn_free = window is not None and window <= DIV_CELL_WINDOW_S
        excess = None if multi is None else multi - floor
        reading = ("no anthocnet row in this cell" if excess is None else
                   f"anthocnet {multi} = {excess:+.3f} vs the floor")
        wtxt = "unknown" if window is None else f"{window:g}"
        if not churn_free and floor > SINGLE_PATH_DIV_MAX:
            report("WARN", f"{where}: path diversity is churn-dominated — the "
                           f"single-path floor is {floor} ({floor_proto}) at "
                           f"windowS={wtxt}, i.e. route replacement inside the "
                           f"window is being counted as concurrent multipath; "
                           f"{reading}. Do not quote path_div_*/"
                           f"path_entropy_bits from this cell. Nothing else is "
                           f"affected: PDR/delay/NRL/jitter come from "
                           f"FlowMonitor, not from the diversity window (#230)")
        elif excess is None:
            print(f"ok: {where}: single-path diversity floor {floor} "
                  f"({floor_proto}) at windowS={wtxt} — churn-free")
        elif excess > 0.0:
            print(f"ok: {where}: path diversity readable — anthocnet {multi} "
                  f"vs single-path floor {floor} ({floor_proto}) at "
                  f"windowS={wtxt}: excess {excess:+.3f}")
        else:
            report("WARN", f"{where}: anthocnet path diversity {multi} does "
                           f"not exceed the single-path floor {floor} "
                           f"({floor_proto}) at windowS={wtxt} (excess "
                           f"{excess:+.3f}) — the multipath protocol shows no "
                           f"concurrent spreading the baselines do not also "
                           f"show, in a cell where the floor is clean enough "
                           f"to say so (#230)")


def cmd_results(a):
    floor = anchor_floor(a.anchor) if a.anchor else None
    n = 0
    for path in a.files:
        check_provenance(path)
        check_drop_identity(path)
        check_reinj(path)
        rows = list(parse_results(path))
        check_path_diversity(rows)
        for r in rows:
            n += 1
            tag = f"{r['where']}/{r['proto']}"

            # `row=r` binds the current row rather than closing over the loop
            # variable (ruff B023). Every call happens inside this iteration so
            # the behaviour is unchanged, but the late-binding footgun is gone.
            def num(k, row=r):
                try:
                    return float(row.get(k))
                except (TypeError, ValueError):
                    return None
            pdr, delay, d99 = num("pdr"), num("delay"), num("delay99")
            nrl, jit = num("nrl"), num("jitter")
            # #293 runs-floor: published points need >=10 runs (tail-quantile
            # claims 20 — see docs/benchmarks/methodology.md "Statistical
            # policy"). WARN, not FAIL: low-run cells are legitimate cheap
            # probes, they just must not be published or quoted. Rows without
            # a run count (a bare table with no ##RUN## rows) skip the rule.
            runs = num("runs")
            if runs is not None and runs < 10:
                report("WARN", f"{tag}: {int(runs)} run(s) — below the #293 "
                               f"published-point floor (>=10; tail quantiles "
                               f"need 20). Diagnostic only, do not publish.")
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
            # #209 energy plausibility. Every radio is powered for the whole
            # run, so consumption is strictly positive and residual energy can
            # never exceed what the source started with; a violation is a
            # harness regression (energy models not installed, read after
            # Simulator::Destroy, wrong container indexing), not a protocol
            # result — hence FAIL, like the rules above.
            energy, epp = num("energy"), num("energy_per_pkt")
            init = num("energy_init")
            if energy is not None and not (math.isfinite(energy) and energy > 0.0):
                report("FAIL", f"{tag}: total energy {r.get('energy')} is "
                               "not a positive finite number — energy "
                               "model not installed or not read")
            if epp is not None:
                if not math.isfinite(epp) or epp < 0.0:
                    report("FAIL", f"{tag}: energy per delivered packet "
                                   f"{r.get('energy_per_pkt')} is not finite "
                                   "and non-negative")
                elif epp == 0.0 and pdr:
                    report("FAIL", f"{tag}: energy per delivered packet 0 with "
                                   f"PDR {pdr} — packets delivered but no "
                                   "energy attributed")
            if init is not None:
                for k in ("res_min", "res_mean"):
                    v = num(k)
                    if v is None:
                        continue
                    if v > init:
                        report("FAIL", f"{tag}: residual energy {k}={v} J "
                                       f"exceeds initial {init} J")
                    if v < 0.0:
                        report("FAIL", f"{tag}: negative residual energy "
                                       f"{k}={v} J")
            # #212 reordering plausibility. These are definitional bounds, not
            # protocol expectations: the ratios are fractions of received
            # packets, and extents/occupancies are counts of packets. A
            # violation means the sequence tracking at the sink is broken (flows
            # merged under one key, sequence numbers not carried, aggregation
            # divided by the wrong denominator), so it is a harness regression —
            # hence FAIL. A *high* but in-range reordering figure for AntHocNet
            # is expected multipath behaviour and is deliberately not flagged.
            for k in ("reorder_ratio", "reorder_ratio_max"):
                v = num(k)
                if v is not None and not (math.isfinite(v) and 0.0 <= v <= 1.0):
                    report("FAIL", f"{tag}: {k} {r.get(k)} outside [0,1] — "
                                   "reordering instrumentation broken")
            for k in ("reorder_extent_mean", "reorder_extent_max",
                      "reorder_buf_max"):
                v = num(k)
                if v is not None and not (math.isfinite(v) and v >= 0.0):
                    report("FAIL", f"{tag}: {k} {r.get(k)} is not a finite "
                                   "non-negative packet count")
            # #230: mean extent above the reorder-buffer high-water mark is
            # legal but diagnostic. RFC 4737 tags *every* lower-sequence arrival
            # behind one early packet, so a single forward route switch produces
            # a run of "reordered" packets with growing extents while the buffer
            # depth actually needed stays small. When the mean exceeds the
            # high-water mark, the extent figure is measuring route flapping,
            # not sustained multipath disorder — the reading that made AODV
            # score 8x AntHocNet at dense-small (extent 45.80 vs buf_max 22.6).
            ext_mean, buf_max = num("reorder_extent_mean"), num("reorder_buf_max")
            if (ext_mean is not None and buf_max is not None
                    and ext_mean > buf_max):
                report("WARN", f"{tag}: reorder_extent_mean {ext_mean} exceeds "
                               f"reorder_buf_max {buf_max} — the extent here is "
                               "route flapping (few displacements tagging long "
                               "runs), not sustained reordering; do not read it "
                               "as a multipath signal")
            # #215 drop-cause breakdown. The five protocol-agnostic causes are
            # measured from three independent books — FlowMonitor's per-flow
            # drop reasons, the Ipv4L3Protocol Tx/Rx hop tallies and the WifiMac
            # retry-limit verdicts — so nothing forces them to add up. They must
            # account, together with the delivered packets, for every offered
            # packet:
            #
            #     pdr + route + queue + mac + chan + ttl  ==  100
            #
            # TOLERANCE. The one legitimate shortfall is data still sitting in a
            # routing protocol's pending queue when the run stops; a packet can
            # wait there at most QueueTimeout (3 s), so the residual is bounded
            # by 3 s of offered traffic — 0.3 % of a 900 s paper run, ~2.5 % of
            # the 120 s --quick preset. Hence WARN past 1 pp and FAIL past 5 pp,
            # which still leaves the check able to see a #173-scale
            # misattribution (tens of pp) without firing on run length.
            #
            # A FAIL here is a finding in its own right, not a formality: it
            # means one of the three books is wrong (a drop path that fires no
            # error callback, a trace hook not connected, a cause counted
            # twice), and every conclusion drawn from the breakdown is unsafe
            # until it is fixed.
            causes = {k: num(f"drop_{k}")
                      for k in ("route", "queue", "mac", "chan", "ttl")}
            for k, v in causes.items():
                if v is None:
                    continue
                if not math.isfinite(v) or not (0.0 <= v <= 100.0):
                    report("FAIL", f"{tag}: drop_{k}_pct {r.get('drop_' + k)} "
                                   "outside [0,100] — drop attribution broken "
                                   "(a negative share means causes overlap)")
            if pdr is not None and all(v is not None for v in causes.values()):
                total = pdr + sum(causes.values())
                gap = total - 100.0
                detail = (f"pdr {pdr:.1f} + " +
                          " + ".join(f"{k} {causes[k]:.2f}"
                                     for k in ("route", "queue", "mac",
                                               "chan", "ttl")) +
                          f" = {total:.2f}")
                if abs(gap) > 5.0:
                    report("FAIL", f"{tag}: drop causes do not account for the "
                                   f"offered packets ({detail}, off by "
                                   f"{gap:+.2f} pp) — attribution is wrong, do "
                                   "not read the breakdown")
                elif abs(gap) > 1.0:
                    report("WARN", f"{tag}: drop causes off by {gap:+.2f} pp "
                                   f"({detail}) — expected only from packets "
                                   "still queued at end of run")
                # #229: name the usual cause of a shortfall instead of leaving
                # it as arithmetic. A protocol that buffers packets awaiting a
                # route sheds them from its *own* queue, and only AntHocNet
                # routes those discards through the L3 error callback that
                # Ipv4FlowProbe's DROP_QUEUE / DROP_QUEUE_DISC reasons observe
                # (those see the interface and qdisc queues, nothing else).
                # ns-3's dsdv::PacketQueue sheds on MaxQueueLen / MaxQueueTime
                # silently, so its packets are offered, never delivered, and
                # attributed nowhere — the 11.46 pp shortfall at dense-small
                # (−21.8 pp post-#388, once honest MAC accounting stopped
                # masking part of the hole).
                # Since the #229 fix, anthocnet-compare.cc measures those
                # sheds itself (the PqTrackTx pending-queue conservation hook,
                # dsdv/aodv arms) and folds them into drop_queue_pct, so a
                # closing identity with a non-zero dsdv queue column is the
                # expected reading. This rule stays as the regression
                # tripwire: zero queue + a shortfall on dsdv/aodv now means
                # the hook did not connect or parse on that ns-3 release.
                # Gated on a real shortfall: AntHocNet and AODV also report
                # queue 0.00 there, but their identities close, so a bare
                # "queue is zero" heuristic would fire on protocols that are
                # accounting correctly.
                if gap < -1.0 and causes["queue"] == 0.0:
                    report("WARN", f"{tag}: drop_queue_pct is exactly 0 while "
                                   f"{-gap:.2f} pp is unaccounted — the likely "
                                   "cause is a routing-layer pending queue that "
                                   "sheds without an L3 error callback and so "
                                   "is invisible to the drop probes; since the "
                                   "#229 fix those sheds are measured by the "
                                   "harness's pending-queue conservation hook, "
                                   "so on dsdv/aodv this reading means the "
                                   "hook did not connect or parse (#229)")
            # The AntHocNet-only causes are a *sub-breakdown* of drop_route_pct
            # (all three end in the same L3 error callback), never causes on top
            # of it. A mismatch means one pending-queue exit path is unaccounted
            # for; WARN rather than FAIL, since the identity above is the rule
            # that decides whether the numbers are usable.
            sub = [num(f"drop_{k}") for k in ("setup", "reconv", "repair")]
            route = causes["route"]
            if (route is not None and all(v is not None for v in sub)
                    and abs(sum(sub) - route) > 1.0):
                report("WARN", f"{tag}: setup+reconv+repair {sum(sub):.2f} != "
                               f"drop_route_pct {route:.2f} — a pending-queue "
                               "exit path is not attributed")
            # #217 route-quality plausibility. Absent columns (inputs predating
            # the instrumentation) simply skip, as the energy rules do. A 0 is
            # the "empty denominator" convention shared with nrl/J-per-packet:
            # legitimate only when nothing was delivered, and a harness failure
            # (trace not connected on this ns-3 release, hook never fired)
            # whenever PDR is non-zero.
            hops, hops_max = num("hops"), num("hops_max")
            div, div_max = num("div"), num("div_max")
            div_window = num("div_window")
            entropy, jain = num("entropy"), num("jain")
            if hops is not None:
                if hops < 0.0:
                    report("FAIL", f"{tag}: negative path length ({hops})")
                elif hops == 0.0 and pdr:
                    report("FAIL", f"{tag}: mean path length 0 with PDR {pdr} — "
                                   "packets delivered but no hop count "
                                   "recorded")
                elif hops > 0.0 and hops < 1.0:
                    report("FAIL", f"{tag}: mean path length {hops} < 1 hop — "
                                   "a delivered packet traverses at least one "
                                   "transmission")
                elif hops > MAX_PATH_LENGTH:
                    report("FAIL", f"{tag}: mean path length {hops} exceeds "
                                   f"maxPathLength ({MAX_PATH_LENGTH})")
            if hops_max is not None:
                if hops_max > MAX_PATH_LENGTH:
                    report("FAIL", f"{tag}: max path length {hops_max} exceeds "
                                   f"maxPathLength ({MAX_PATH_LENGTH})")
                if hops is not None and hops_max and hops_max < hops:
                    report("FAIL", f"{tag}: max path length {hops_max} < mean "
                                   f"path length {hops}")
            if div is not None:
                if div == 0.0 and pdr:
                    report("FAIL", f"{tag}: path diversity 0 with PDR {pdr} — "
                                   "data was carried but no next hop was "
                                   "attributed (MAC trace not connected?)")
                elif div < 0.0 or (0.0 < div < 1.0):
                    report("FAIL", f"{tag}: path diversity {div} < 1 — a "
                                   "carried destination uses at least one "
                                   "next hop")
                elif (r["proto"] in SINGLE_PATH_PROTOS
                        and div_window is not None
                        and div_window <= DIV_CELL_WINDOW_S
                        and div > DIV_CELL_SANITY_MAX):
                    report("FAIL", f"{tag}: path diversity {div} > "
                                   f"{DIV_CELL_SANITY_MAX} for a single-path "
                                   "protocol even at the churn-free window "
                                   f"(<= {DIV_CELL_WINDOW_S} s) — the window "
                                   "is not churn-free at this offered rate, "
                                   "so the diversity cell is unreadable "
                                   "(#230)")
                # A churn-inflated single-path reading is not judged per row:
                # it is a property of the cell and is read against the other
                # protocols measured beside it, in check_path_diversity().
            if div_max is not None and div is not None and div_max and div_max < div:
                report("FAIL", f"{tag}: max path diversity {div_max} < mean "
                               f"path diversity {div}")
            # #308 phase 2 hopsCommon. Same three a-priori facts as `hops`
            # above — a delivered packet crosses at least one transmission and
            # at most maxPathLength — plus the one that only this metric can
            # get wrong: it is derived from the IP TTL under a flow key rebuilt
            # from (source IP, UDP source port), which must match the key
            # PacketSink reports for the delays. If that ever diverges, every
            # hop lands under a key the common set does not contain and
            # hopsCommon reads absent while nCommon stays large. Without this
            # rule that failure is silent and the per-hop decomposition is
            # simply wrong; with it the run FAILs.
            # #308 phase 2 step 4 pending-queue hold time. Three a-priori
            # facts: no component is negative; a hold cannot outlast the
            # QueueTimeout that bounds it (3 s by default, so a generous 5 s
            # ceiling catches an accounting error without policing the
            # attribute); and a non-zero mean with a zero count is arithmetic
            # that cannot happen, which is what a mis-ordered field mapping
            # would look like.
            if r.get("hold_negative"):
                report("FAIL", f"{tag}: {r['hold_negative']} ##HOLD## row(s) "
                               "with a negative hold count/mean/max")
            if r.get("hold_mean_no_count"):
                report("FAIL", f"{tag}: {r['hold_mean_no_count']} ##HOLD## "
                               "reason(s) report a non-zero mean hold with a "
                               "zero hold count — the fields are mis-mapped")
            hold_max = r.get("hold_max_ms")
            if hold_max is not None and hold_max > HOLD_CEILING_MS:
                report("FAIL", f"{tag}: max hold {hold_max} ms exceeds "
                               f"{HOLD_CEILING_MS} ms — a pending-queue hold is "
                               "bounded by QueueTimeout (#308 phase 2)")
            missing = r.get("hops_common_missing")
            if missing:
                report("FAIL", f"{tag}: {missing} run(s) report a non-empty "
                               "common set with no hopsCommon — the TTL hook "
                               "did not fire, or the (source IP, source port) "
                               "flow key no longer matches the one the delays "
                               "use (#308 phase 2)")
            # #308 phase 2 step 3 channel occupancy. Two a-priori facts: a node
            # cannot see the medium busy for more than the whole run, and no
            # component of the occupancy can be negative. The third rule is the
            # harness-failure detector — a ##AIR## row is only printed when the
            # PHY State trace is connected, so a row that IS present while
            # reporting zero occupancy, in a run where packets were delivered,
            # means the trace fired without recording. (--energyJ=0 prints no
            # row at all; absence skips every rule here, as it should.)
            if r.get("air_negative"):
                report("FAIL", f"{tag}: {r['air_negative']} run(s) report a "
                               "negative channel-occupancy component")
            if r.get("air_zero_runs") and pdr:
                report("FAIL", f"{tag}: {r['air_zero_runs']} run(s) report zero "
                               f"channel occupancy with PDR {pdr} — packets "
                               "were delivered, so the medium cannot have been "
                               "idle throughout (#308 phase 2)")
            busy_max = r.get("air_busy_max")
            if busy_max is not None and busy_max > 100.0:
                report("FAIL", f"{tag}: channel busy {busy_max}% of node-time — "
                               "a node cannot see the medium occupied for more "
                               "than the whole run")
            hc_min, hc_max = r.get("hops_common_min"), r.get("hops_common_max")
            if hc_min is not None and hc_min < 1.0:
                report("FAIL", f"{tag}: hopsCommon {hc_min} < 1 hop — a "
                               "delivered packet traverses at least one "
                               "transmission")
            if hc_max is not None and hc_max > MAX_PATH_LENGTH:
                report("FAIL", f"{tag}: hopsCommon {hc_max} exceeds "
                               f"maxPathLength ({MAX_PATH_LENGTH})")
            if entropy is not None:
                if entropy < 0.0:
                    report("FAIL", f"{tag}: negative path entropy ({entropy})")
                elif div_max and div_max >= 1.0 and entropy > math.log2(div_max) + 0.01:
                    report("FAIL", f"{tag}: path entropy {entropy} bits exceeds "
                                   f"log2(max diversity {div_max})")
            if jain is not None:
                if not (0.0 <= jain <= 1.0 + 1e-9):
                    report("FAIL", f"{tag}: Jain's fairness index {jain} "
                                   "outside [0,1]")
                elif jain == 0.0 and pdr:
                    report("FAIL", f"{tag}: Jain's fairness index 0 with PDR "
                                   f"{pdr} — packets delivered but no per-flow "
                                   "counts")
            # #259 satellite (isl-grid) rules. Present only when the input
            # carried the topology context (the --csv columns or the '+Grid'
            # summary line); MANET inputs never set isl_delay, so nothing here
            # can fire on them.
            isl = num("isl_delay")
            if isl is not None and isl > 0:
                # Propagation floor. Soundness: flows connect distinct
                # satellites and every ISL is a point-to-point link with a
                # fixed one-way delay of isl_delay_ms, so every delivered
                # packet crosses >= 1 ISL and pays >= isl_delay_ms of pure
                # propagation before serialisation/queueing; the mean over
                # delivered packets inherits the bound. A mean below it is a
                # harness/instrumentation bug (wrong clock, wrong counting
                # point), never a fast protocol — the satellite counterpart of
                # "path length < 1 hop". No stronger floor is derivable from
                # the columns present: flow endpoints (and hence per-flow hop
                # counts) are not in the output, so every flow could legally be
                # between adjacent satellites (h=1). The h*d hop-delay identity
                # with its sat_hop_delay_slack_ms band stays a dispatch-time
                # gate (check-sat-anchors.sh), where h is known.
                if delay is not None and pdr and delay < isl:
                    report("FAIL", f"{tag}: mean delay {delay} ms below the "
                                   f"one-ISL propagation floor {isl} ms — "
                                   "every delivered packet crosses >= 1 ISL, "
                                   "so this is a harness/instrumentation bug, "
                                   "not a fast protocol (#259)")
                # Single-ISL anchor, applied to a fetched result (#259): a
                # 2-node/1-link row identifies the sat-single-isl anchor
                # topology from the input itself, so the anchors.yml floor
                # fires without an --anchor flag. Soundness: one lossless p2p
                # link, static, no contention — physics says PDR 100; the
                # floor's own margin (99.0) tolerates only route-setup loss at
                # t=0. Scoped to AODV rows because that is the protocol the
                # anchor is calibrated for (see anchors.yml), mirroring the
                # --anchor floors above.
                nsat, nisl = num("sat_nodes"), num("sat_links")
                if (nsat == 2 and nisl == 1 and r["proto"] == "aodv"
                        and pdr is not None):
                    sfloor = yml_floor("sat_single_isl_pdr_min")
                    if pdr < sfloor:
                        report("FAIL", f"{tag}: single-ISL anchor floor "
                                       f"sat_single_isl_pdr_min {sfloor} "
                                       f"violated (AODV PDR {pdr}) — a p2p "
                                       "link is lossless, so the substrate or "
                                       "route setup is broken; do not trust "
                                       "these numbers (#259)")
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
    # kDefaultPathWindowS in ns3/examples/anthocnet-compare.cc (#217).
    p.add_argument("--pathWindowS", type=float, default=10)
    p.add_argument("--mobility", choices=("rwp", "ssrwp", "gaussmarkov"),
                   default="rwp")
    p.add_argument("--propagation", choices=("range", "tworay", "nakagami"),
                   default="range")
    p.add_argument("--transport", choices=("udp", "tcp"), default="udp")
    r = sub.add_parser("results")
    r.add_argument("files", nargs="+")
    r.add_argument("--anchor", choices=sorted(ANCHOR_KEY))
    args = ap.parse_args()
    (cmd_preflight if args.cmd == "preflight" else cmd_results)(args)


if __name__ == "__main__":
    main()
