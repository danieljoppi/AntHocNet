#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for scenario_check.py.

`scenario_check.py` is the gate that decides whether a campaign's numbers may
be read, quoted or published. Until this file existed nothing tested it, and
the consequences showed up twice in one afternoon:

  - #230's path-diversity defect sat in six merged campaigns because no rule
    asserted the one thing the metric's own docs called its self-check (the
    single-path baselines must read ~1).
  - The first cut of #229's queue-drop diagnosis fired on `anthocnet` and
    `aodv` rows whose accounting was correct, because it keyed on "queue is
    zero" instead of on an actual shortfall.

So each rule gets two cases: one crafted row where it **must** fire, and one
where it **must not**. The second half is the half that catches over-firing,
which is what makes a check untrustworthy and then ignored.

Numbers in the fixtures are the real campaign values (runs 30201145972 /
30201179429) wherever a rule was written in response to a real reading, so a
change in threshold has to confront the observation that motivated it.

Run: python3 test_scenario_check.py     (no pytest dependency; exits non-zero
                                         on the first failure)
"""

import argparse
import contextlib
import importlib.util
import io
import os
import sys
import tempfile


def _load_scenario_check():
    """Load scenario_check.py from source, next to this file.

    Deliberately not a module-level `import`. Two reasons, both learned the
    hard way:

    - A stale `__pycache__` entry can shadow an edited rule, so the suite
      reports a pass (or a phantom failure) for code that is not the code on
      disk. `exec_module` on the file always runs what is there.
    - The `sys.path` juggling an import would need puts a statement before the
      import, which is E402, which needs a `noqa`, whose necessity then depends
      on how ruff resolves config — it differed between this sandbox and CI on
      0.16.0, failing the lint either way round.
    """
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "scenario_check.py")
    spec = importlib.util.spec_from_file_location("scenario_check", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


sc = _load_scenario_check()

# A row that must pass every rule cleanly. Deliberately an `anthocnet` row with
# a closing identity (99.98 at dense-small is the real measured value), so any
# rule that fires here is over-firing on correct data.
CLEAN = {
    "kind": "scenario", "group": "taxonomy", "x": "paper-base",
    "scenario": "paper-base", "class": "sparse / mobile",
    "protocol": "anthocnet", "runs": "20", "nNodes": "50", "areaX": "1500",
    "speed": "20", "pause": "30", "flows": "20", "propagation": "range",
    "pdr_pct": "89.4", "delay_ms": "40.0", "delay99_ms": "200.0",
    "throughput_kbps": "9.0", "nrl": "2.0", "jitter_ms": "10.0",
    "delay_off50_ms": "30.0", "delay_off90_ms": "90.0",
    "pdr_sd": "1.0", "delay_sd": "1.0", "delay99_sd": "1.0", "nrl_sd": "0.1",
    "nrl_bytes": "100.0",
    "energy_j": "500.0", "energy_per_pkt_j": "0.01",
    "energy_res_min_j": "4500.0", "energy_res_mean_j": "4600.0",
    "energy_res_sd_j": "10.0", "energy_init_j": "5000.0",
    "first_death_s": "-1",
    "reorder_ratio": "0.0003", "reorder_ratio_max": "0.0065",
    "reorder_extent_mean": "0.20", "reorder_extent_max": "1.0",
    "reorder_buf_max": "13.4",
    "drop_route_pct": "2.97", "drop_queue_pct": "1.50", "drop_mac_pct": "3.00",
    "drop_chan_pct": "3.10", "drop_ttl_pct": "0.03",
    "drop_setup_pct": "0.50", "drop_reconv_pct": "2.40",
    "drop_repair_pct": "0.07",
    "path_hops_mean": "2.5", "path_hops_max": "6.0",
    "path_div_used": "1.303", "path_div_max": "5.0",
    "path_entropy_bits": "0.29", "path_div_window_s": "10.0",
    "jain_pkts": "0.9",
}


def run_results(**overrides):
    """Check one row (CLEAN + overrides); return the list of reported levels."""
    row = dict(CLEAN, **overrides)
    text = ",".join(row) + "\n" + ",".join(str(v) for v in row.values()) + "\n"
    fd, path = tempfile.mkstemp(suffix=".csv")
    try:
        with os.fdopen(fd, "w") as fh:
            fh.write(text)
        sc.issues = []
        args = argparse.Namespace(files=[path], anchor=None)
        with contextlib.redirect_stdout(io.StringIO()) as out:
            try:
                sc.cmd_results(args)
            except SystemExit:
                pass
        return list(sc.issues), out.getvalue()
    finally:
        os.unlink(path)


def run_preflight(**overrides):
    kw = {"nodes": 50, "areaX": 1500.0, "areaY": 300.0, "range": 300.0,
          "time": 300.0, "pause": 30.0, "speed": 20.0, "flows": 20,
          "pktBytes": 64, "pktPerSec": 1.0, "rateMbps": 2.0,
          "pathWindowS": 10.0, "mobility": "rwp", "propagation": "range",
          "transport": "udp"}
    kw.update(overrides)
    sc.issues = []
    with contextlib.redirect_stdout(io.StringIO()) as out:
        try:
            sc.cmd_preflight(argparse.Namespace(**kw))
        except SystemExit:
            pass
    return list(sc.issues), out.getvalue()


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


# --- the clean row -----------------------------------------------------------

@case("clean anthocnet row reports nothing")
def _clean():
    levels, out = run_results()
    expect(levels == [], "clean", f"expected no reports, got {levels}\n{out}")


# --- #293 runs-floor ----------------------------------------------------------


@case("#293 a 5-run cell WARNs below the published-point floor")
def _runs_floor_fires():
    # 5 was the pre-#110 sweep run count — exactly the data the floor exists
    # to keep out of publications (DSDV's delay99 dispersion was invisible
    # at 5 seeds, #293).
    levels, out = run_results(runs="5")
    expect("WARN" in levels, "runs-floor-fires",
           f"runs=5 did not WARN\n{out}")
    expect("published-point floor" in out, "runs-floor-fires",
           f"WARN did not name the floor\n{out}")


@case("#293 the floor stays quiet at 10 runs and on rows with no run count")
def _runs_floor_quiet():
    levels, out = run_results(runs="10")
    expect(levels == [], "runs-floor-quiet",
           f"runs=10 (the floor) must not WARN\n{out}")
    # A bare table row with no ##RUN## rows carries no run count: skip.
    levels, out = run_cell(
        "anthocnet 89.4 40.0 200.0 9.0 2.0\n")
    expect(levels == [], "runs-floor-no-count",
           f"row without a run count must not WARN\n{out}")


# --- #230 path diversity -----------------------------------------------------

@case("#230 single-path baseline above 1.10 FAILs")
def _div_fires():
    # olsr / heavy-load, the worst real reading of the campaign.
    levels, out = run_results(protocol="olsr", path_div_used="1.428")
    expect("FAIL" in levels, "div-fires", f"no FAIL for olsr div 1.428\n{out}")
    expect("single-path protocol" in out, "div-fires",
           f"FAIL did not name the cause\n{out}")


@case("#230 single-path baseline at 1.004 passes")
def _div_quiet_baseline():
    # olsr / sparse-static — the churn-free control, the one row that already
    # reads correctly. If the threshold ever creeps below this the calibration
    # target becomes unreachable.
    levels, out = run_results(protocol="olsr", path_div_used="1.004")
    expect(levels == [], "div-quiet", f"fired on the good control\n{out}")


@case("#230 rule does not apply to anthocnet")
def _div_quiet_anthocnet():
    # AntHocNet is *supposed* to exceed 1; flagging it would invert the rule.
    levels, out = run_results(protocol="anthocnet", path_div_used="1.512")
    expect(levels == [], "div-anthocnet", f"fired on anthocnet\n{out}")


# --- #230 reordering extent --------------------------------------------------

@case("#230 extent above buffer high-water mark WARNs")
def _extent_fires():
    # aodv / dense-small: extentMean 45.8 vs bufMax 22.6.
    levels, out = run_results(protocol="aodv", path_div_used="1.05",
                              reorder_extent_mean="45.8",
                              reorder_extent_max="60.0",
                              reorder_buf_max="22.6")
    expect(levels == ["WARN"], "extent-fires",
           f"expected exactly one WARN, got {levels}\n{out}")
    expect("route flapping" in out, "extent-fires",
           f"WARN did not name the mechanism\n{out}")


@case("#230 extent below buffer high-water mark is quiet")
def _extent_quiet():
    levels, out = run_results(reorder_extent_mean="2.03",
                              reorder_buf_max="973.8")
    expect(levels == [], "extent-quiet", f"fired on a sane row\n{out}")


# --- #229 drop accounting ----------------------------------------------------

@case("#229 identity shortfall FAILs and names the queue cause")
def _drop_fires():
    # dsdv / dense-small: 22.2 + 0.15 + 0 + 52.37 + 13.59 + 0.23 = 88.54.
    levels, out = run_results(
        protocol="dsdv", pdr_pct="22.2", path_div_used="1.05",
        drop_route_pct="0.15", drop_queue_pct="0.00", drop_mac_pct="52.37",
        drop_chan_pct="13.59", drop_ttl_pct="0.23",
        drop_setup_pct="", drop_reconv_pct="", drop_repair_pct="",
        reorder_extent_mean="0.0", reorder_buf_max="0.6")
    expect("FAIL" in levels, "drop-fires", f"identity did not FAIL\n{out}")
    expect("WARN" in levels, "drop-fires",
           f"shortfall carried no queue diagnosis\n{out}")
    expect("error callback" in out, "drop-fires",
           f"diagnosis did not name the mechanism\n{out}")


@case("#229 queue diagnosis does not fire when the identity closes")
def _drop_quiet_when_balanced():
    # This is the over-firing bug the first cut of the rule had: anthocnet and
    # aodv both read drop_queue_pct 0.00 at dense-small while accounting
    # correctly (99.98 and 99.33). Keying on "queue is zero" flags them.
    levels, out = run_results(
        protocol="anthocnet", pdr_pct="42.1", path_div_used="1.257",
        drop_route_pct="55.91", drop_queue_pct="0.00", drop_mac_pct="0.54",
        drop_chan_pct="1.42", drop_ttl_pct="0.00",
        drop_setup_pct="4.58", drop_reconv_pct="50.23",
        drop_repair_pct="1.12",
        reorder_extent_mean="5.49", reorder_buf_max="151.0")
    expect(levels == [], "drop-quiet",
           f"fired on a correctly-accounted row: {levels}\n{out}")


@case("#229 sub-breakdown is checked against its parent, not added to it")
def _sub_breakdown():
    # setup+reconv+repair must reconstruct drop_route_pct. Breaking one term
    # must WARN; the identity itself must stay clean, proving the three are
    # never summed into it (the ~156% double-count).
    levels, out = run_results(drop_setup_pct="0.50", drop_reconv_pct="0.10",
                              drop_repair_pct="0.07")
    expect(levels == ["WARN"], "sub-breakdown",
           f"expected one WARN for the broken partition, got {levels}\n{out}")
    expect("not attributed" in out, "sub-breakdown", out)


# --- pre-instrumentation inputs ---------------------------------------------

@case("rows without the new columns skip every new rule")
def _absent_columns():
    blank = {k: "" for k in
             ("reorder_ratio", "reorder_ratio_max", "reorder_extent_mean",
              "reorder_extent_max", "reorder_buf_max", "drop_route_pct",
              "drop_queue_pct", "drop_mac_pct", "drop_chan_pct",
              "drop_ttl_pct", "drop_setup_pct", "drop_reconv_pct",
              "drop_repair_pct", "path_hops_mean", "path_hops_max",
              "path_div_used", "path_div_max", "path_entropy_bits",
              "jain_pkts", "energy_j", "energy_per_pkt_j",
              "energy_res_min_j", "energy_res_mean_j", "energy_init_j")}
    levels, out = run_results(**blank)
    expect(levels == [], "absent-columns",
           f"a rule fired on a pre-instrumentation row\n{out}")


# --- #63 TCP transport preflight ----------------------------------------------

@case("#63 preflight WARNs that a TCP arm is saturating")
def _transport_tcp_fires():
    levels, out = run_preflight(transport="tcp", pathWindowS=2.0)
    expect("WARN" in levels, "transport-tcp-fires",
           f"a saturating TCP arm did not WARN\n{out}")
    expect("SATURATING" in out, "transport-tcp-fires", out)
    expect("##GOODPUT##" in out, "transport-tcp-fires",
           f"the WARN did not name the metric to read instead\n{out}")


@case("#63 preflight says nothing about transport on the udp default")
def _transport_udp_silent():
    # Must-not-fire: udp is what every published number used, so it must not
    # acquire a new warning.
    _, out = run_preflight(pathWindowS=2.0)
    expect("SATURATING" not in out, "transport-udp-silent", out)


# --- #61/#60 grid regression floors ------------------------------------------
#
# These floors are derived from our own measurement, not from literature, so
# the must-not-fire half matters more than usual: if they fire on the very
# numbers they were calibrated from, they are wrong by construction.

def run_results_anchor(anchor, **overrides):
    """Check one row against an --anchor floor; return (levels, stdout)."""
    row = dict(CLEAN, **overrides)
    text = ",".join(row) + "\n" + ",".join(str(v) for v in row.values()) + "\n"
    fd, path = tempfile.mkstemp(suffix=".csv")
    try:
        with os.fdopen(fd, "w") as fh:
            fh.write(text)
        sc.issues = []
        args = argparse.Namespace(files=[path], anchor=anchor)
        with contextlib.redirect_stdout(io.StringIO()) as out:
            try:
                sc.cmd_results(args)
            except SystemExit:
                pass
        return list(sc.issues), out.getvalue()
    finally:
        os.unlink(path)


@case("#60 grid-tworay floor stays quiet at the measured AODV PDR")
def _grid_tworay_quiet():
    # 83.90 is the worst measured two-ray cell (gaussmarkov, run 31239973590).
    # Assert on the anchor's own verdict, not on the global level list: the
    # shared CLEAN fixture trips unrelated rules once pdr_pct is overridden,
    # and a test that keys on "any FAIL" would be testing those instead.
    _, out = run_results_anchor("grid-tworay", protocol="aodv",
                                pdr_pct="83.90")
    expect("floor 75.0 met" in out, "grid-tworay-quiet",
           f"the floor fired on the number it was calibrated from\n{out}")
    expect("'grid-tworay' floor 75.0 violated" not in out,
           "grid-tworay-quiet", out)


@case("#60 grid-tworay floor fires on a #51-class collapse")
def _grid_tworay_fires():
    _, out = run_results_anchor("grid-tworay", protocol="aodv",
                                pdr_pct="50.0")
    expect("'grid-tworay' floor 75.0 violated" in out, "grid-tworay-fires",
           f"a ~50% rate-manager regression did not fire\n{out}")


@case("#60 grid-nakagami floor stays quiet at the measured AODV PDR")
def _grid_nakagami_quiet():
    # 67.23 is the worst measured fading cell (gaussmarkov, run 31239979624)
    # and sits well below the two-ray floor — which is exactly why the fading
    # arm needs its own threshold rather than reusing grid-tworay.
    _, out = run_results_anchor("grid-nakagami", protocol="aodv",
                                pdr_pct="67.23")
    expect("floor 55.0 met" in out, "grid-nakagami-quiet",
           f"the floor fired on the number it was calibrated from\n{out}")
    expect("'grid-nakagami' floor 55.0 violated" not in out,
           "grid-nakagami-quiet", out)


@case("#60 grid-tworay floor would reject a healthy fading cell")
def _grid_wrong_anchor_fires():
    # The reason there are two floors: a legitimate Nakagami reading checked
    # against the two-ray floor must FAIL, so picking the wrong --anchor is a
    # loud error rather than a silently-passing one.
    _, out = run_results_anchor("grid-tworay", protocol="aodv",
                                pdr_pct="67.23")
    expect("'grid-tworay' floor 75.0 violated" in out,
           "grid-wrong-anchor-fires",
           f"a fading cell passed the two-ray floor\n{out}")


# --- #61 mobility-model preflight --------------------------------------------

@case("#61 preflight FAILs pause>0 under gaussmarkov (inert knob)")
def _mobility_pause_fires():
    levels, out = run_preflight(mobility="gaussmarkov", pathWindowS=2.0)
    expect("FAIL" in levels, "mobility-pause-fires",
           f"pause=30 under gaussmarkov did not FAIL\n{out}")
    expect("inert" in out, "mobility-pause-fires", out)


@case("#61 preflight stays quiet on pause=0 under gaussmarkov")
def _mobility_pause_quiet():
    # The knob is stated explicitly, so the coherence rule has nothing to say.
    # A WARN about non-rwp comparability is expected and correct here; what
    # must not happen is a FAIL.
    levels, out = run_preflight(mobility="gaussmarkov", pause=0.0,
                                pathWindowS=2.0)
    expect("FAIL" not in levels, "mobility-pause-quiet",
           f"pause=0 under gaussmarkov should not FAIL\n{out}")


@case("#61 preflight FAILs ssrwp at zero speed")
def _mobility_ssrwp_fires():
    levels, out = run_preflight(mobility="ssrwp", speed=0.0, pathWindowS=2.0)
    expect("FAIL" in levels, "mobility-ssrwp-fires",
           f"ssrwp at speed=0 did not FAIL\n{out}")
    expect("undefined at zero" in out, "mobility-ssrwp-fires", out)


@case("#61 preflight WARNs that a non-rwp model leaves the published corpus")
def _mobility_corpus_warn():
    levels, out = run_preflight(mobility="ssrwp", pathWindowS=2.0)
    expect("WARN" in levels, "mobility-corpus-warn",
           f"a non-rwp model did not WARN about comparability\n{out}")
    expect("published corpus" in out, "mobility-corpus-warn", out)


@case("#61 preflight says nothing about mobility on the default rwp")
def _mobility_default_silent():
    # The must-not-fire half: the model every published number was measured
    # under must not acquire a new warning, or the gate cries wolf on the
    # scenario it is most often run against.
    _, out = run_preflight(pathWindowS=2.0)
    expect("published corpus" not in out, "mobility-default-silent", out)
    expect("inert" not in out, "mobility-default-silent", out)


# --- #60 channel-model preflight ---------------------------------------------

@case("#60 preflight WARNs that --range is inert off the disk model")
def _channel_range_inert_fires():
    levels, out = run_preflight(propagation="tworay", pathWindowS=2.0)
    expect("WARN" in levels, "channel-range-inert-fires",
           f"tworay did not WARN that range is inert\n{out}")
    expect("inert" in out, "channel-range-inert-fires", out)


@case("#60 preflight WARNs that nakagami is stochastic")
def _channel_nakagami_fires():
    levels, out = run_preflight(propagation="nakagami", pathWindowS=2.0)
    expect("WARN" in levels, "channel-nakagami-fires",
           f"nakagami did not WARN about dispersion\n{out}")
    expect("stochastic channel" in out, "channel-nakagami-fires", out)


@case("#60 preflight says nothing about the channel on the disk default")
def _channel_default_silent():
    # Must-not-fire half: the disk model is what the published corpus used and
    # what most dispatches pass, so it must not acquire a new warning.
    _, out = run_preflight(pathWindowS=2.0)
    expect("inert" not in out, "channel-default-silent", out)
    expect("stochastic channel" not in out, "channel-default-silent", out)


# --- #230 preflight ----------------------------------------------------------

@case("#230 preflight FAILs the shipped 10s window at paper-base")
def _preflight_fires():
    levels, out = run_preflight()
    expect("FAIL" in levels, "preflight-fires",
           f"the 10s default did not FAIL\n{out}")
    expect("link lifetime" in out, "preflight-fires", out)


@case("#230 preflight downgrades a mid window to WARN, not clean")
def _preflight_quiet():
    # 2 s clears the churn bound but sits exactly on the 2-packets/cell floor.
    # It must not FAIL (the window itself is fine) and must not pass silently
    # (the measurement says it does not separate).
    levels, out = run_preflight(pathWindowS=2.0)
    expect("FAIL" not in levels, "preflight-quiet",
           f"2s should not FAIL on churn\n{out}")
    expect("WARN" in levels, "preflight-quiet",
           f"2s passed clean despite being at the sampling floor\n{out}")


@case("#230 preflight FAILs a window too short to sample")
def _preflight_starved():
    # 0.5 s at 1 pkt/s = 0.5 packets/cell; a cell needs >=2 to exceed 1.0.
    # Measured: all four protocols read 1.000-1.001 at this window.
    levels, out = run_preflight(pathWindowS=0.5)
    expect("FAIL" in levels, "preflight-starved",
           f"0.5s did not FAIL on sampling\n{out}")
    expect("per cell" in out, "preflight-starved", out)


@case("#230 preflight flags every window at the paper's 1 pkt/s")
def _preflight_no_window():
    # The squeeze: churn caps the window at ~7.5 s, sampling floors it at 4 s,
    # and the 2 s midpoint measured anthocnet 1.002 vs aodv 1.002. Every window
    # in the swept range must be flagged, or the calibration looks solvable
    # when it is not.
    for w in (0.5, 1.0, 2.0, 5.0, 10.0):
        levels, out = run_preflight(pathWindowS=w)
        expect(levels != [], "preflight-no-window",
               f"window {w}s passed clean at 1 pkt/s\n{out}")


@case("#230 preflight passes once the rate supports the window")
def _preflight_rate_fixes():
    # Raising the offered rate is the escape the FAIL points at.
    levels, out = run_preflight(pathWindowS=2.0, pktPerSec=4.0)
    expect(levels == [], "preflight-rate",
           f"2s at 4 pkt/s should be clean, got {levels}\n{out}")


@case("#230 preflight skips a static field")
def _preflight_static():
    levels, out = run_preflight(pause=900.0, time=300.0, speed=1.0)
    expect("FAIL" not in levels, "preflight-static",
           f"window rule fired on a static field\n{out}")


# --- ##BENCH## cell input: the diagnostic lines feed the same rules (#230) ----
#
# Until this landed, `results` on a saved cell parsed only the table rows: every
# '# paths' / '# drops' / '# reorder' / '# energy' line was skipped by ROW, so
# the drop/reorder/route-quality/energy rules never ran and a cell whose
# diversity figures were out of band still returned OK — measured on run
# 30379320885, where planting divUsed=9.999 changed nothing. The fixture below
# is that run's real cell (paper-base, main@6a479fa, time=300, runs=2,
# pathWindowS=4); its aodv/olsr rows genuinely breach the single-path bound, so
# the *unmodified* cell must FAIL — that is finding 2 on #230, now gate-visible.

CELL = """\
##BENCH## anthocnet 71.9 410.8 1797.5 3.63 278.02 212.35 542.5 inf 302.165
##BENCH## aodv 81.7 41.4 802.5 4.60 60.09 66.65 6.0 inf 31.557
##BENCH## olsr 76.6 10.2 30.0 3.84 6.45 13.89 1.5 inf 13.284
##BENCH## dsdv 70.2 16.5 698.0 3.77 33.90 29.13 2.0 inf 23.232
# paths anthocnet divUsed=1.104 divMax=3.0 entropyBits=0.101 windowS=4.0 hopsMean=3.42 hopsMax=44.5
# paths aodv divUsed=1.112 divMax=2.5 entropyBits=0.112 windowS=4.0 hopsMean=2.07 hopsMax=7.5
# paths olsr divUsed=1.117 divMax=2.0 entropyBits=0.117 windowS=4.0 hopsMean=1.69 hopsMax=6.0
# paths dsdv divUsed=1.057 divMax=2.0 entropyBits=0.057 windowS=4.0 hopsMean=1.73 hopsMax=6.5
# energy anthocnet initJ=5000.0 resMinJ=4740.6 resMeanJ=4741.9 resSdJ=0.868 firstDeathS=-1.0
# drops anthocnet pdr=71.88 route=2.33 queue=0.00 mac=0.97 chan=24.01 ttl=0.36 sum=99.56 other=0.00 [route: setup=0.12 reconv=2.26 repair=0.27]
# drops aodv pdr=81.72 route=3.29 queue=0.00 mac=9.25 chan=5.59 ttl=0.04 sum=99.89 other=0.00 [route: setup=- reconv=- repair=-]
# reorder anthocnet ratio=0.0077 ratioWorstFlow=0.0358 extentMean=0.23 extentMax=1.00 bufMax=58.00
"""


PROV = ("##PROV## commit=0b42c896b8969081a7b0ba160a9a7f4082461803 ref=main "
        "run_id=31284265709 attempt=1 image=ghcr.io/danieljoppi/ns3:3.42-opt "
        "profile=release harness=compare\n")


def run_cell(text, prov=True):
    """Check a ##BENCH## cell text; return (levels, printed output).

    A ##PROV## line (#365) is appended by default, because every cell fetched
    from a campaign workflow now carries one — a fixture without it would make
    "clean" mean something no real input is. Pass prov=False for the cases that
    are specifically about provenance being absent.
    """
    # Appended only to log-shaped inputs — the same scope check_provenance
    # applies. Some fixtures routed through here are CSVs, where an extra line
    # is a data row, not a comment.
    if prov and ("##BENCH##" in text or "##RUN##" in text):
        text = text if text.endswith("\n") else text + "\n"
        text += PROV
    fd, path = tempfile.mkstemp(suffix=".txt")
    try:
        with os.fdopen(fd, "w") as fh:
            fh.write(text)
        sc.issues = []
        args = argparse.Namespace(files=[path], anchor=None)
        with contextlib.redirect_stdout(io.StringIO()) as out:
            try:
                sc.cmd_results(args)
            except SystemExit:
                pass
        return list(sc.issues), out.getvalue()
    finally:
        os.unlink(path)


@case("cell: real run 30379320885 FAILs on its own out-of-band baselines")
def _cell_real():
    levels, out = run_cell(CELL)
    expect(levels.count("FAIL") == 2, "cell-real",
           f"expected exactly the aodv+olsr diversity FAILs, got {levels}\n{out}")
    expect("aodv: path diversity 1.112" in out and
           "olsr: path diversity 1.117" in out, "cell-real",
           f"wrong rows flagged\n{out}")


@case("cell: impossible divUsed on a '# paths' line fires (the 9.999 probe)")
def _cell_div_fires():
    _levels, out = run_cell(CELL.replace("aodv divUsed=1.112",
                                        "aodv divUsed=9.999"))
    expect("path diversity 9.999" in out, "cell-div",
           f"planted divUsed=9.999 not flagged\n{out}")


# --- #308 phase 2 step 4: pending-queue hold on the ##HOLD## rows -------------
#
# Fixture values are the real step-4 readings (run 31069667952): setup
# 21/428.7ms/max2752.9ms, reconv 1677/87.3ms, repair ~1959/24.0ms. The rules are
# arithmetic impossibilities, not thresholds: negative components, a mean with
# no count behind it, and a hold outlasting the QueueTimeout that bounds it.
HOLD_CELL = """anthocnet 95.8 54.3 862.1 6.32 36.08
##HOLD## 1 anthocnet 21 428.70 2752.90 1677 87.30 994.50 1959 24.00 1945.90
##HOLD## 2 anthocnet 27 331.40 2074.80 1849 104.90 981.20 1902 23.10 1877.40
"""


@case("#308p2 hold rows stay quiet on real step-4 values")
def _hold_quiet():
    levels, out = run_cell(HOLD_CELL)
    expect(levels == [], "hold-quiet",
           f"real ##HOLD## values must not report, got {levels}\n{out}")


@case("#308p2 a hold outlasting QueueTimeout FAILs")
def _hold_ceiling():
    _levels, out = run_cell(HOLD_CELL.replace("2752.90", "5200.00"))
    expect("exceeds 5000.0 ms" in out, "hold-ceiling",
           f"a 5.2 s hold was not flagged\n{out}")


@case("#308p2 a non-zero mean hold with a zero count FAILs")
def _hold_mean_no_count():
    # What a mis-ordered field mapping looks like: a mean with nothing behind it.
    _levels, out = run_cell(HOLD_CELL.replace("21 428.70", "0 428.70"))
    expect("zero hold count" in out, "hold-mean-no-count",
           f"mean-without-count was not flagged\n{out}")


@case("#308p2 negative hold FAILs, and a cell with no ##HOLD## rows skips")
def _hold_negative_and_absent():
    _levels, out = run_cell(HOLD_CELL.replace("1677 87.30", "1677 -87.30"))
    expect("negative hold" in out, "hold-negative",
           f"negative mean hold was not flagged\n{out}")
    # AODV/OLSR/DSDV emit no ##HOLD## row at all — absence must report nothing,
    # never "this protocol never held a packet".
    levels, out = run_cell("aodv 83.9 32.4 472.6 5.54 55.39\n")
    expect(levels == [], "hold-absent",
           f"a protocol with no ##HOLD## rows must skip, got {levels}\n{out}")


# --- #308 phase 2 step 3: channel occupancy on the ##AIR## rows --------------
#
# Two a-priori bounds (occupancy is non-negative; a node cannot see the medium
# busy for more than the whole run) plus the harness-failure detector: an ##AIR##
# row is only printed when the PHY State trace is connected, so a row that IS
# present while reporting zero occupancy in a run that delivered packets means
# the trace fired without recording. --energyJ=0 prints no row at all, and that
# absence must skip every rule rather than read as a failure.
AIR_CELL = """anthocnet 95.8 54.3 862.1 6.32 36.08
##AIR## 1 anthocnet 1204.500 8931.250 3310.750 29.8811
##AIR## 2 anthocnet 1198.125 8902.500 3288.375 29.7532
"""


@case("#308p2 channel occupancy stays quiet on plausible values")
def _air_quiet():
    levels, out = run_cell(AIR_CELL)
    expect(levels == [], "air-quiet",
           f"plausible ##AIR## rows must not report, got {levels}\n{out}")


@case("#308p2 busy above 100% of node-time FAILs")
def _air_over_hundred():
    _levels, out = run_cell(AIR_CELL.replace("29.8811", "100.4000"))
    expect("cannot see the medium occupied" in out, "air-over",
           f"busyPct above 100 was not flagged\n{out}")


@case("#308p2 a present-but-zero occupancy row with non-zero PDR FAILs")
def _air_zero():
    _levels, out = run_cell(AIR_CELL.replace(
        "1204.500 8931.250 3310.750 29.8811", "0.000 0.000 0.000 0.0000"))
    expect("medium cannot have been idle" in out, "air-zero",
           f"zero occupancy with PDR 95.8 was not flagged\n{out}")


@case("#308p2 negative occupancy FAILs, and an absent ##AIR## block skips")
def _air_negative_and_absent():
    _levels, out = run_cell(AIR_CELL.replace("8931.250", "-1.000"))
    expect("negative channel-occupancy" in out, "air-negative",
           f"negative component was not flagged\n{out}")
    # --energyJ=0 emits no ##AIR## row at all; that must report nothing.
    levels, out = run_cell("anthocnet 95.8 54.3 862.1 6.32 36.08\n")
    expect(levels == [], "air-absent",
           f"a cell with no ##AIR## rows must skip, got {levels}\n{out}")


# --- #308 phase 2: hopsCommon on the ##COMMON## rows -------------------------
#
# The a-priori control: a delivered packet crosses at least one transmission
# and at most maxPathLength, so hopsCommon is in [1, 100] on any real run. The
# value that matters most is the one only this metric can get wrong — hops are
# keyed by a flow address rebuilt from (source IP, UDP source port), and if that
# ever stops matching the key the delays use, hopsCommon vanishes while nCommon
# stays large. Fixture values are the real phase-2 re-measure (run 31042812548):
# nCommon 6605, hopsCommon 2.73 for anthocnet against 2.19 for aodv.
COMMON_CELL = """anthocnet 95.8 54.3 862.1 6.32 36.08
##COMMON## 1 anthocnet 7775 6605 784.5 37.0 1008.9 2.730 3.410
##COMMON## 2 anthocnet 7859 6584 944.0 59.5 1146.0 2.744 3.502
"""


@case("#308p2 hopsCommon stays quiet on real phase-2 values")
def _hops_common_quiet():
    levels, out = run_cell(COMMON_CELL)
    expect(levels == [], "hops-common-quiet",
           f"real hopsCommon values must not report, got {levels}\n{out}")


@case("#308p2 a missing hopsCommon with a non-empty common set FAILs")
def _hops_common_missing_fires():
    # The flow-key divergence this rule exists for: nCommon large, no hops.
    _levels, out = run_cell(COMMON_CELL.replace("1008.9 2.730 3.410",
                                                "1008.9 na na"))
    expect("no hopsCommon" in out, "hops-common-missing",
           f"absent hopsCommon on a non-empty common set was not flagged\n{out}")


@case("#308p2 hopsCommon below one hop, and above maxPathLength, FAIL")
def _hops_common_bounds_fire():
    _levels, out = run_cell(COMMON_CELL.replace("2.730", "0.500"))
    expect("hopsCommon 0.5 < 1 hop" in out, "hops-common-low",
           f"hopsCommon below one hop was not flagged\n{out}")
    _levels, out = run_cell(COMMON_CELL.replace("2.730", "101.000"))
    expect("exceeds maxPathLength" in out, "hops-common-high",
           f"hopsCommon above maxPathLength was not flagged\n{out}")


@case("#308p2 rows predating the hop fields, and an empty common set, skip")
def _hops_common_skips():
    # Seven-field ##COMMON## lines are what every run before this metric
    # emitted; they must parse and report nothing rather than read as missing.
    old = """anthocnet 95.8 54.3 862.1 6.32 36.08
##COMMON## 1 anthocnet 7775 6605 784.5 37.0 1008.9
"""
    levels, out = run_cell(old)
    expect(levels == [], "hops-common-old",
           f"pre-instrumentation ##COMMON## row must skip, got {levels}\n{out}")
    # nCommon 0 with no hop data is arithmetic, not a harness failure.
    levels, out = run_cell(COMMON_CELL.replace(
        "7775 6605 784.5 37.0 1008.9 2.730 3.410", "7775 0 -1.0 -1.0 na na na"))
    expect(levels == [], "hops-common-empty",
           f"empty common set must not FAIL, got {levels}\n{out}")


@case("cell: broken drop identity on a '# drops' line fires")
def _cell_drops_fire():
    _levels, out = run_cell(CELL.replace("chan=24.01", "chan=90.00"))
    expect("do not account for the offered packets" in out, "cell-drops",
           f"planted chan=90 left the identity unchecked\n{out}")


@case("cell: closing drop identity stays quiet, '-' sub-causes skip")
def _cell_drops_quiet():
    _levels, out = run_cell(CELL)
    expect("do not account" not in out and "exit path is not attributed" not in out,
           "cell-drops-quiet",
           f"drop rules over-fired on a closing identity / '-' causes\n{out}")


@case("cell: out-of-range reorder ratio on a '# reorder' line fires")
def _cell_reorder_fires():
    _levels, out = run_cell(CELL.replace("ratio=0.0077", "ratio=9.9999"))
    expect("reorder_ratio 9.9999 outside [0,1]" in out, "cell-reorder",
           f"planted ratio not flagged\n{out}")


@case("cell: residual energy above initial on a '# energy' line fires")
def _cell_energy_fires():
    _levels, out = run_cell(CELL.replace("resMinJ=4740.6", "resMinJ=5740.6"))
    expect("exceeds initial" in out, "cell-energy",
           f"planted residual > initial not flagged\n{out}")


@case("cell: rounded pdr on a '# drops' line must NOT overwrite the row pdr")
def _cell_pdr_authoritative():
    # The '# drops' pdr is a rounded duplicate; mapping it would let a
    # corrupted diagnostic line silently replace the table value the headline
    # rules already checked. Corrupt it and nothing may change.
    levels, out = run_cell(CELL.replace("# drops anthocnet pdr=71.88",
                                        "# drops anthocnet pdr=1.00"))
    base, _ = run_cell(CELL)
    expect(levels == base, "cell-pdr",
           f"'# drops' pdr leaked into the row: {levels} vs {base}\n{out}")


# --- #230 dedicated diversity cell (cbrBps=4096, pathWindowS=2) --------------
# Real readings from run 30650903707: at the churn-free 2 s window with the
# raised rate, the single-path floor sits legitimately above the 1.10 absolute
# bound (aodv 1.133 — a route break at 8 pkt/s lands packets on both routes
# within one short window), so the absolute rule must NOT fire there; only the
# 1.50 sanity ceiling may.
DIVCELL = """\
##BENCH## anthocnet 94.8 62.0 900.0 6.10 40.00 95.00 3.5 361.0 47.9
##BENCH## aodv 90.1 33.0 480.0 5.60 53.00 47.00 4.0 inf 28.2
# paths anthocnet divUsed=1.229 divMax=7.0 entropyBits=0.163 windowS=2.0 hopsMean=2.77 hopsMax=64.0
# paths aodv divUsed=1.133 divMax=6.0 entropyBits=0.093 windowS=2.0 hopsMean=2.17 hopsMax=63.0
"""


@case("#230 diversity cell: baseline above 1.10 at windowS<=2 stays quiet")
def _divcell_floor_allowed():
    _levels, out = run_cell(DIVCELL)
    expect("path diversity" not in out, "divcell-quiet",
           f"absolute 1.10 rule fired inside the diversity cell\n{out}")


@case("#230 diversity cell: baseline above the 1.50 sanity ceiling fires")
def _divcell_sanity_fires():
    _levels, out = run_cell(DIVCELL.replace("aodv divUsed=1.133",
                                            "aodv divUsed=1.633"))
    expect("not churn-free at this offered rate" in out, "divcell-sanity",
           f"planted 1.633 above the sanity ceiling not flagged\n{out}")


# --- #259 satellite (isl-grid) input: CSV schema + human mode + rules --------
#
# The CSV fixture is a realistic 4x4 torus at the anchor knobs: 16 satellites,
# 32 ISLs, islDelayMs=5, 8 flows. delay 10.4 ms is the measured hop-delay
# identity reading (h=2, d=5 ms: 10.39 ms, CI run 30190452648, anchors.yml).
# runs sits at the #293 published-point floor so the clean fixture stays
# clean; the runs-floor WARN has its own must-fire case below.

ISL_CLEAN = {
    "protocol": "anthocnet", "runs": "20", "rows": "4", "cols": "4",
    "nodes": "16", "links": "32", "isl_delay_ms": "5.0", "flows": "8",
    "pdr_pct": "100.0", "delay_ms": "10.4", "delay99_ms": "10.9",
    "throughput_kbps": "32.28", "nrl": "1.401", "nrl_bytes": "0.988",
    "jitter_ms": "0.15",
}


def run_isl(**overrides):
    """Check one isl-grid --csv row (ISL_CLEAN + overrides)."""
    row = dict(ISL_CLEAN, **overrides)
    return run_cell(",".join(row) + "\n"
                    + ",".join(str(v) for v in row.values()) + "\n")


# The human-mode fixture mirrors what satellite-benchmark.yml's
# satellite-results.txt artifact holds: ##RUN## per-seed rows, '# diag' ant
# tallies (deliberately unparsed), the '+Grid' summary and the aggregate table
# — whose column order (…thrput nrl nrlbytes jitter) differs from the MANET
# table, the trap the dedicated branch exists for.

ISL_CELL = """\
##RUN## 1 anthocnet 100.00 10.40 10.90 32.28 1.40 0.99 0.15
##RUN## 2 anthocnet 100.00 10.41 10.92 32.29 1.41 0.99 0.15
# diag anthocnet seed=1 ctrlTx=1234 antTx[1=100,2=50,] antRx[1=98,2=49,]
##RUN## 1 aodv 100.00 10.30 10.60 32.28 0.60 0.35 0.10
##RUN## 2 aodv 100.00 10.31 10.61 32.28 0.60 0.35 0.10
+Grid torus 4x4 = 16 satellites, 32 ISLs (mean degree 4.00) @ 5.00 ms 10Mbps, 8 flows, 60.00 s, mean of 2 run(s)

protocol          PDR%  delay(ms)  delay99(ms)  thrput(kbps)     NRL   NRLbytes  jitter(ms)
-------------------------------------------------------------------------------------------
anthocnet        100.0       10.4         10.9         32.28    1.40       0.99        0.15
aodv             100.0       10.3         10.6         32.28    0.60       0.35        0.10
"""


@case("#259 clean isl-grid CSV row reports nothing")
def _isl_clean():
    levels, out = run_isl()
    expect(levels == [], "isl-clean", f"expected no reports, got {levels}\n{out}")
    expect("checked 1 rows" in out, "isl-clean",
           f"CSV row not parsed\n{out}")


@case("#259 mean delay below the one-ISL propagation floor FAILs")
def _isl_floor_fires():
    levels, out = run_isl(delay_ms="3.2", delay99_ms="3.4")
    expect("FAIL" in levels, "isl-floor-fires",
           f"delay 3.2 < islDelayMs 5.0 did not FAIL\n{out}")
    expect("propagation floor" in out, "isl-floor-fires",
           f"FAIL did not name the floor\n{out}")


@case("#259 propagation floor skips a dead cell (delay 0, PDR 0)")
def _isl_floor_dead_cell():
    # Nothing delivered => the mean-of-none prints 0.0; the dead-cell WARN
    # owns that reading, the physics floor must not pile a FAIL on top.
    levels, out = run_isl(pdr_pct="0.0", delay_ms="0.0", delay99_ms="0.0",
                          throughput_kbps="0.00", jitter_ms="0.00")
    expect("FAIL" not in levels, "isl-floor-dead",
           f"floor fired on a dead cell\n{out}")
    expect("WARN" in levels, "isl-floor-dead",
           f"dead cell not WARNed\n{out}")


@case("#259 single-ISL AODV row below sat_single_isl_pdr_min FAILs")
def _isl_anchor_fires():
    levels, out = run_isl(protocol="aodv", rows="1", cols="2", nodes="2",
                          links="1", delay_ms="5.2", delay99_ms="5.4",
                          pdr_pct="97.0")
    expect("FAIL" in levels, "isl-anchor-fires",
           f"AODV 97.0 on one lossless ISL did not FAIL\n{out}")
    expect("sat_single_isl_pdr_min" in out, "isl-anchor-fires",
           f"FAIL did not name the anchor key\n{out}")


@case("#259 single-ISL anchor stays quiet at 100.0 and off-anchor topologies")
def _isl_anchor_quiet():
    levels, out = run_isl(protocol="aodv", rows="1", cols="2", nodes="2",
                          links="1", delay_ms="5.2", delay99_ms="5.4",
                          pdr_pct="100.0")
    expect(levels == [], "isl-anchor-quiet",
           f"fired on a perfect single-ISL row\n{out}")
    # 97.0 on the 4x4 grid is congestion territory, not the anchor topology;
    # firing there would make the gate cry wolf on every loaded run.
    levels, out = run_isl(protocol="aodv", pdr_pct="97.0")
    expect(levels == [], "isl-anchor-quiet",
           f"anchor fired off the 2-node/1-link topology\n{out}")


@case("#259 human satellite-results.txt parses runs+table and stays quiet")
def _isl_cell_clean():
    levels, out = run_cell(ISL_CELL)
    expect(levels == [], "isl-cell-clean",
           f"clean human-mode output reported {levels}\n{out}")
    # 4 ##RUN## rows + 2 table rows; the '# diag' line must bind to nothing.
    expect("checked 6 rows" in out, "isl-cell-clean",
           f"wrong row count from human mode\n{out}")


@case("#259 planted sub-floor delay on a ##RUN## line fires")
def _isl_cell_floor_fires():
    _levels, out = run_cell(ISL_CELL.replace("##RUN## 2 aodv 100.00 10.31",
                                            "##RUN## 2 aodv 100.00 3.10"))
    expect("propagation floor" in out and "run2/aodv" in out,
           "isl-cell-floor", f"per-run sub-floor delay not flagged\n{out}")


@case("#259 table jitter binds to column 7, not to NRLbytes")
def _isl_cell_jitter_position():
    # Corrupt only the table's last column (jitter). Under the MANET mapping
    # position 5 (NRLbytes) would be read as jitter and this would stay
    # silent — the mis-binding the dedicated isl-grid branch prevents.
    _levels, out = run_cell(ISL_CELL.replace(
        "aodv             100.0       10.3         10.6         32.28    0.60       0.35        0.10",
        "aodv             100.0       10.3         10.6         32.28    0.60       0.35       -0.10"))
    expect("negative jitter" in out, "isl-cell-jitter",
           f"negative jitter in the last table column not flagged\n{out}")


# --- #365 provenance ---------------------------------------------------------
# The marker is emitted by the workflow, so nothing in the harness can prove it
# arrives. This pair is the only thing that can fail: one case that the warning
# fires when a cell has no commit, one that it stays quiet when it has.

@case("#365 a ##BENCH## cell with no ##PROV## line WARNs")
def _prov_missing_fires():
    _levels, out = run_cell(ISL_CELL, prov=False)
    expect("no ##PROV## line" in out, "prov-missing",
           f"cell without provenance not flagged\n{out}")


@case("#365 a ##PROV## line silences the warning and echoes the commit")
def _prov_present_quiet():
    _levels, out = run_cell(ISL_CELL)
    expect("no ##PROV## line" not in out, "prov-present",
           f"provenance present but still warned\n{out}")
    expect("measured at 0b42c89" in out, "prov-present-echo",
           f"commit not echoed for the reader\n{out}")


@case("#365 a truncated commit field is not accepted as provenance")
def _prov_short_sha_fires():
    # A tail cut mid-line leaves a stub that still starts with ##PROV##.
    # Matching the marker alone would read that as provenance recorded.
    _levels, out = run_cell(ISL_CELL + "##PROV## commit=0b4\n", prov=False)
    expect("no ##PROV## line" in out, "prov-short-sha",
           f"a 3-char commit stub was accepted as provenance\n{out}")


@case("#365 a campaign CSV is exempt — provenance is the run ID, not a line")
def _prov_csv_exempt():
    _levels, out = run_results()
    expect("no ##PROV## line" not in out, "prov-csv-exempt",
           f"CSV input warned about a marker it is not supposed to carry\n{out}")


# --- #377 drop-identity overlap ----------------------------------------------
# Numbers taken from the shape of the reported failure: the rwp x nakagami
# anthocnet cell reads drop_chan_pct -13.77 on ~20 000 offered packets, i.e. an
# overlap of a couple of thousand packets, against a clean two-ray cell.

DROPID_CLEAN = ("##DROPID## 1 aodv hopTx=52000 hopRx=50000 ackedHops=50000 "
                "macDrops=1800 reinjected=0 macTerminal=1800 queue=200 "
                "hopLoss=2000 overlap=0 unackedRx=0\n")
DROPID_OVERLAP = ("##DROPID## 3 anthocnet hopTx=52000 hopRx=51000 "
                  "ackedHops=48250 macDrops=3750 reinjected=0 "
                  "macTerminal=3750 queue=0 hopLoss=1000 overlap=2750 "
                  "unackedRx=2750\n")


@case("#377 a ##DROPID## row with overlap>0 WARNs and names both figures")
def _dropid_overlap_fires():
    _levels, out = run_cell(ISL_CELL + DROPID_OVERLAP)
    expect("drop-cause books overlap by 2750" in out, "dropid-overlap",
           f"positive overlap not flagged\n{out}")
    expect("unackedRx=2750" in out, "dropid-unacked",
           f"the discriminating figure was not reported alongside it\n{out}")


@case("#377 a ##DROPID## row with overlap=0 stays quiet")
def _dropid_clean_quiet():
    _levels, out = run_cell(ISL_CELL + DROPID_CLEAN)
    expect("drop-cause books overlap" not in out, "dropid-clean",
           f"a clean drop identity was flagged\n{out}")


@case("#377 one warning per protocol, not per seed")
def _dropid_worst_per_proto():
    # Twenty seeds of the same broken cell must not bury every other finding.
    rows = "".join(DROPID_OVERLAP.replace("##DROPID## 3 ", f"##DROPID## {s} ")
                   for s in range(1, 21))
    _levels, out = run_cell(ISL_CELL + rows)
    expect(out.count("drop-cause books overlap") == 1, "dropid-once",
           f"expected one warning for the protocol, got "
           f"{out.count('drop-cause books overlap')}\n{out}")


@case("#377 an AntHocNet row is judged on the same term the residual uses")
def _dropid_reinject_arm():
    # Shaped from probe run 31286508174 (rwp x nakagami) with hopLoss lowered
    # so the residual goes negative. The re-injection gap is what matters:
    # macDrops=475 against macTerminal=9. A rule keyed on macTerminal would
    # report a large negative overlap and stay silent on the very arm #377
    # reports the worst drop_chan_pct for.
    row = ("##DROPID## 1 anthocnet hopTx=4584 hopRx=4106 ackedHops=3789 "
           "macDrops=475 reinjected=466 macTerminal=9 macLost=158 queue=0 "
           "hopLoss=151 overlap=7 unackedRx=317\n")
    _levels, out = run_cell(ISL_CELL + row)
    expect("drop-cause books overlap by 7" in out, "dropid-reinject",
           f"the re-injecting arm was not flagged\n{out}")


@case("#377 the real 900 s Nakagami rows read clean once macLost is subtracted")
def _dropid_corrected_residual_quiet():
    # Verbatim counters from run 31288485211 seeds 1-2, the cell that reported
    # drop_chan_pct -13.10 before the correction. overlap is recomputed as
    # macLost + queue - hopLoss, which is <= 0 by construction because macLost
    # is a subset of hopLoss. If a future change reverts the residual to the
    # raw MAC-drop count these rows go positive again and this case fails.
    rows = (
        "##DROPID## 1 anthocnet hopTx=20571 hopRx=18761 ackedHops=17194 "
        "macDrops=2738 reinjected=2698 macTerminal=40 macLost=1171 queue=0 "
        "hopLoss=1810 overlap=-639 unackedRx=1567\n"
        "##DROPID## 1 aodv hopTx=12721 hopRx=11387 ackedHops=10433 "
        "macDrops=1899 reinjected=0 macTerminal=1899 macLost=945 queue=0 "
        "hopLoss=1334 overlap=-389 unackedRx=954\n"
        "##DROPID## 1 olsr hopTx=11762 hopRx=10862 ackedHops=9738 "
        "macDrops=1554 reinjected=0 macTerminal=1554 macLost=430 queue=0 "
        "hopLoss=900 overlap=-470 unackedRx=1124\n")
    _levels, out = run_cell(ISL_CELL + rows)
    expect("drop-cause books overlap" not in out, "dropid-corrected",
           f"the corrected residual was still flagged as overlapping\n{out}")


@case("#377 a cell with no ##DROPID## rows is not flagged")
def _dropid_absent_quiet():
    # TCP cells and every pre-#377 run carry no such row; absence is not a
    # failure, it is the marker not existing yet.
    _levels, out = run_cell(ISL_CELL)
    expect("drop-cause books overlap" not in out, "dropid-absent",
           f"absent counters were treated as a defect\n{out}")


def main():
    for name, fn in CASES:
        fn()
        print(f"ok   {name}")
    print(f"\n{len(CASES)} cases passed")


if __name__ == "__main__":
    main()
