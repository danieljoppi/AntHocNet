#!/usr/bin/env python3
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
import io
import os
import sys
import tempfile

# Import scenario_check from *source* every time. Without this a stale
# __pycache__ entry can shadow an edited rule and the suite reports a pass (or
# a phantom failure) for code that is not the code on disk — hit once while
# writing these very cases.
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import scenario_check as sc  # noqa: E402

# A row that must pass every rule cleanly. Deliberately an `anthocnet` row with
# a closing identity (99.98 at dense-small is the real measured value), so any
# rule that fires here is over-firing on correct data.
CLEAN = {
    "kind": "scenario", "group": "taxonomy", "x": "paper-base",
    "scenario": "paper-base", "class": "sparse / mobile",
    "protocol": "anthocnet", "runs": "2", "nNodes": "50", "areaX": "1500",
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
          "pathWindowS": 10.0}
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


# --- #230 preflight ----------------------------------------------------------

@case("#230 preflight FAILs the shipped 10s window at paper-base")
def _preflight_fires():
    levels, out = run_preflight()
    expect("FAIL" in levels, "preflight-fires",
           f"the 10s default did not FAIL\n{out}")
    expect("link lifetime" in out, "preflight-fires", out)


@case("#230 preflight passes a short window")
def _preflight_quiet():
    levels, out = run_preflight(pathWindowS=2.0)
    expect(levels == [], "preflight-quiet", f"fired at 2s\n{out}")


@case("#230 preflight skips a static field")
def _preflight_static():
    levels, out = run_preflight(pause=900.0, time=300.0, speed=1.0)
    expect("FAIL" not in levels, "preflight-static",
           f"window rule fired on a static field\n{out}")


def main():
    for name, fn in CASES:
        fn()
        print(f"ok   {name}")
    print(f"\n{len(CASES)} cases passed")


if __name__ == "__main__":
    main()
