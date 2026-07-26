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

# #217: core Config::maxPathLength — the cap on the visited path an ant carries
# and therefore on any path the protocol can lay. A delivered data packet
# reported above it is an instrumentation error, not a long route.
MAX_PATH_LENGTH = 100

# #230: the baselines all install exactly one route per destination at a time,
# so their path_div_used is 1.0 by construction. Anything materially above that
# is the diversity *window* counting route replacement as concurrent multipath —
# it calibrates the window, and it is the only external check on whether an
# AntHocNet diversity figure means anything.
SINGLE_PATH_PROTOS = ("aodv", "olsr", "dsdv")
SINGLE_PATH_DIV_MAX = 1.10

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

    Reordering fields (#212) exist only in CSVs produced after the reordering
    instrumentation landed; older inputs simply omit them and the reordering
    rules below are skipped. They are CSV-only by design — anthocnet-compare
    prints them on a '# reorder' line rather than widening the fixed-width
    results table, and ROW does not match a '# ' line.

    Drop-cause fields (#215) are likewise CSV-only and post-instrumentation:
    anthocnet-compare prints them on a '# drops' line rather than widening the
    fixed-width table, so a results table yields None for all of them and the
    drop rules below skip. The three AntHocNet-only causes are deliberately
    **blank** for the other protocols (the cause does not exist there, as
    opposed to existing and measuring zero); a blank parses to None and is
    skipped, exactly like an absent column.

    Route-quality fields (#217) are likewise post-instrumentation and skipped
    when absent. The results table carries the two headline columns (hops,
    jain) at positions 12/13; used-path diversity and its entropy live in the
    CSV only (the human output puts them on a '# paths' line).
    """
    with open(path) as fh:
        text = fh.read()
    first = text.lstrip().splitlines()[0] if text.strip() else ""
    if first.startswith("kind,") or ",protocol," in first:
        for r in csv.DictReader(text.splitlines()):
            yield {"where": f"{r.get('group')}={r.get('x')}",
                   "proto": r.get("protocol"),
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
                   "entropy": r.get("path_entropy_bits"),
                   "jain": r.get("jain_pkts")}
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
        if len(nums) >= 11:  # #209: ... nrlBytes, energy(J), J/pkt
            row["energy"] = nums[9]
            row["energy_per_pkt"] = nums[10]
        if len(nums) >= 13:  # #217: ... J/pkt, hops, jain
            row["hops"] = nums[11]
            row["jain"] = nums[12]
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
                # attributed nowhere — the 11.46 pp shortfall at dense-small.
                # Gated on a real shortfall: AntHocNet and AODV also report
                # queue 0.00 there, but their identities close, so a bare
                # "queue is zero" heuristic would fire on protocols that are
                # accounting correctly.
                if gap < -1.0 and causes["queue"] == 0.0:
                    report("WARN", f"{tag}: drop_queue_pct is exactly 0 while "
                                   f"{-gap:.2f} pp is unaccounted — the likely "
                                   "cause is a routing-layer pending queue that "
                                   "sheds without an L3 error callback and so "
                                   "is invisible to the drop probes (#229)")
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
                        and div > SINGLE_PATH_DIV_MAX):
                    report("FAIL", f"{tag}: path diversity {div} > "
                                   f"{SINGLE_PATH_DIV_MAX} for a single-path "
                                   "protocol — path_div_window_s is longer than "
                                   "the route lifetime, so route replacement is "
                                   "being counted as concurrent multipath; "
                                   "recalibrate the window (#230) before "
                                   "reading any path_div_* or path_entropy_bits "
                                   "figure, including AntHocNet's")
            if div_max is not None and div is not None and div_max and div_max < div:
                report("FAIL", f"{tag}: max path diversity {div_max} < mean "
                               f"path diversity {div}")
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
    r = sub.add_parser("results")
    r.add_argument("files", nargs="+")
    r.add_argument("--anchor", choices=sorted(ANCHOR_KEY))
    args = ap.parse_args()
    (cmd_preflight if args.cmd == "preflight" else cmd_results)(args)


if __name__ == "__main__":
    main()
