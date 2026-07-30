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


def run_cell(text):
    """Check a ##BENCH## cell text; return (levels, printed output)."""
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
    levels, out = run_cell(CELL.replace("aodv divUsed=1.112",
                                        "aodv divUsed=9.999"))
    expect("path diversity 9.999" in out, "cell-div",
           f"planted divUsed=9.999 not flagged\n{out}")


@case("cell: broken drop identity on a '# drops' line fires")
def _cell_drops_fire():
    levels, out = run_cell(CELL.replace("chan=24.01", "chan=90.00"))
    expect("do not account for the offered packets" in out, "cell-drops",
           f"planted chan=90 left the identity unchecked\n{out}")


@case("cell: closing drop identity stays quiet, '-' sub-causes skip")
def _cell_drops_quiet():
    levels, out = run_cell(CELL)
    expect("do not account" not in out and "exit path is not attributed" not in out,
           "cell-drops-quiet",
           f"drop rules over-fired on a closing identity / '-' causes\n{out}")


@case("cell: out-of-range reorder ratio on a '# reorder' line fires")
def _cell_reorder_fires():
    levels, out = run_cell(CELL.replace("ratio=0.0077", "ratio=9.9999"))
    expect("reorder_ratio 9.9999 outside [0,1]" in out, "cell-reorder",
           f"planted ratio not flagged\n{out}")


@case("cell: residual energy above initial on a '# energy' line fires")
def _cell_energy_fires():
    levels, out = run_cell(CELL.replace("resMinJ=4740.6", "resMinJ=5740.6"))
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


def main():
    for name, fn in CASES:
        fn()
        print(f"ok   {name}")
    print(f"\n{len(CASES)} cases passed")


if __name__ == "__main__":
    main()
