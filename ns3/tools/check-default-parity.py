#!/usr/bin/env python3
"""Cross-tree Config default parity check (issue #258).

The same protocol default lives in up to four places:

  core   core/include/anthocnet/core/config.h      (default member initializers)
  ns2.h  ns2/src/ahn_router.h                      (AHN_* compile-time macros)
  ns2.cc ns2/src/ahn_router.cc                     (tcl-bound constructor initializers)
  ns2.tcl ns2/patch/fragments/ns-default.tcl.fragment (Agent/AntHocNet set ...)
  ns3    ns3/model/anthocnet-routing-protocol.cc   (constructor initializers)

PR #252 leaked proactiveInterval 10 -> 2 in one tree while claiming not to;
tracing the resulting benchmark regression cost two days (#254). This script
fails (exit 1) naming any field whose literal defaults disagree across the
trees it appears in. Only fields with a certain name mapping are compared;
the checked list is printed so coverage is visible.

Deliberately NOT mapped: ns-3 m_reactiveRetryInterval — it is the adapter's
own retry timer, a different quantity from core reactiveRetryInterval
(docs/configuration.md §3.3 item 2). Adapter-only knobs (queue caps, MAC
failure detector, MAC service EWMA) have no core counterpart and are skipped.

Runs on stdlib only: python3 ns3/tools/check-default-parity.py
"""

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]

CONFIG_H = REPO / "core/include/anthocnet/core/config.h"
NS2_H = REPO / "ns2/src/ahn_router.h"
NS2_CC = REPO / "ns2/src/ahn_router.cc"
NS2_TCL = REPO / "ns2/patch/fragments/ns-default.tcl.fragment"
NS3_CC = REPO / "ns3/model/anthocnet-routing-protocol.cc"

# core field -> identifier per tree. Omitted key = field absent from that tree.
# ns2_var covers both the ahn_router.cc constructor initializer and (where
# present) the ns-default.tcl.fragment line, which share the tcl variable name.
FIELDS = {
    "alpha": {"ns3": "m_alpha"},
    "gamma": {"ns3": "m_gamma"},
    "betaAnts": {"ns2_var": "beta_ants_", "ns3": "m_betaAnts"},
    "betaData": {"ns2_var": "beta_data_", "ns3": "m_betaData"},
    "hopTimeSec": {"ns3": "m_hopTime"},
    "enableMacMetric": {"ns2_var": "enable_mac_metric_", "ns3": "m_enableMacMetric"},
    "enableProactive": {"ns2_var": "enable_proactive_", "ns3": "m_enableProactive"},
    "enableDiffusion": {"ns2_var": "enable_diffusion_", "ns3": "m_enableDiffusion"},
    "enableReactive": {"ns2_var": "enable_reactive_", "ns3": "m_enableReactive"},
    "enableRepair": {"ns2_var": "enable_repair_", "ns3": "m_enableRepair"},
    "enableLinkFail": {"ns2_var": "enable_linkfail_", "ns3": "m_enableLinkFail"},
    "enableDirectedReactive": {
        "ns2_var": "enable_directed_reactive_",
        "ns3": "m_enableDirectedReactive",
    },
    "proactiveBroadcastProb": {
        "ns2_var": "proactive_bcast_prob_",
        "ns3": "m_proactiveBroadcastProb",
    },
    "proactiveVirtualMargin": {
        "ns2_var": "proactive_virtual_margin_",
        "ns3": "m_proactiveVirtualMargin",
    },
    "sessionTtl": {"ns2_var": "session_ttl_", "ns3": "m_sessionTtl"},
    "helloInterval": {"ns2_macro": "AHN_HELLO_INTERVAL", "ns3": "m_helloInterval"},
    "proactiveInterval": {
        "ns2_macro": "AHN_PROACTIVE_INTERVAL",
        "ns3": "m_proactiveInterval",
    },
    "lifeAnt": {"ns2_macro": "AHN_LIFE_ANT"},
    "networkDiameter": {"ns2_macro": "AHN_NETWORK_DIAMETER"},
    "linkfailNotifyInterval": {"ns3": "m_linkfailNotifyInterval"},
    "txFailureThreshold": {
        "ns2_var": "tx_failure_threshold_",
        "ns3": "m_txFailureThreshold",
    },
    "enableMultipath": {"ns3": "m_enableMultipath"},
    "antAcceptanceFactor": {"ns3": "m_antAcceptanceFactor"},
    "antAcceptanceFactorNewHop": {"ns3": "m_antAcceptanceFactorNewHop"},
    "repairWaitFactor": {"ns2_var": "repair_wait_factor_", "ns3": "m_repairWaitFactor"},
    "repairTimeout": {"ns2_var": "repair_timeout_", "ns3": "m_repairTimeout"},
}


def norm(literal):
    """Normalize a C++/tcl literal to a float for comparison."""
    literal = literal.strip()
    if literal == "true":
        return 1.0
    if literal == "false":
        return 0.0
    return float(literal)


def parse_config_h(text):
    # e.g. "double alpha = 0.7;  ///< ..." / "std::size_t maxHistory = 4096;"
    pat = re.compile(
        r"^\s*(?:double|bool|int|std::size_t)\s+(\w+)\s*=\s*([-\w.]+)\s*;", re.M
    )
    return {name: norm(value) for name, value in pat.findall(text)}


def parse_ns2_macros(text):
    # e.g. "#define AHN_HELLO_INTERVAL      1.0"
    pat = re.compile(r"^#define\s+(AHN_\w+)\s+([-\d.]+)", re.M)
    return {name: norm(value) for name, value in pat.findall(text)}


def parse_ns2_ctor(text):
    # Constructor initializers, e.g. "      beta_ants_(1.0)," — restricted to
    # the identifiers named in FIELDS, so unrelated calls never match.
    out = {}
    for spec in FIELDS.values():
        var = spec.get("ns2_var")
        if var is None:
            continue
        m = re.search(rf"^\s*{re.escape(var)}\(([-\d.]+)\)", text, re.M)
        if m:
            out[var] = norm(m.group(1))
    return out


def parse_ns2_tcl(text):
    # e.g. "Agent/AntHocNet set beta_ants_ 1.0"
    pat = re.compile(r"^Agent/AntHocNet\s+set\s+(\w+)\s+([-\d.]+)", re.M)
    return {name: norm(value) for name, value in pat.findall(text)}


def parse_ns3_ctor(text):
    # e.g. "      m_helloInterval(Seconds(1.0))," / "m_alpha(0.7)," /
    #      "m_enableProactive(true),"
    pat = re.compile(r"^\s*(m_\w+)\((?:Seconds\()?(true|false|[-\d.]+)\)?\)", re.M)
    return {name: norm(value) for name, value in pat.findall(text)}


def main():
    core = parse_config_h(CONFIG_H.read_text())
    ns2_macros = parse_ns2_macros(NS2_H.read_text())
    ns2_ctor = parse_ns2_ctor(NS2_CC.read_text())
    ns2_tcl = parse_ns2_tcl(NS2_TCL.read_text())
    ns3_ctor = parse_ns3_ctor(NS3_CC.read_text())

    errors = []
    checked = []

    for field, spec in sorted(FIELDS.items()):
        if field not in core:
            errors.append(
                f"{field}: not found in {CONFIG_H.relative_to(REPO)} "
                "(parser or mapping is stale)"
            )
            continue
        values = [("core", core[field])]

        macro = spec.get("ns2_macro")
        if macro is not None:
            if macro in ns2_macros:
                values.append((f"ns2.h {macro}", ns2_macros[macro]))
            else:
                errors.append(f"{field}: macro {macro} not found in ns2/src/ahn_router.h")

        var = spec.get("ns2_var")
        if var is not None:
            if var in ns2_ctor:
                values.append((f"ns2.cc {var}", ns2_ctor[var]))
            else:
                errors.append(f"{field}: initializer {var} not found in ns2/src/ahn_router.cc")
            # Not every bound variable has an ns-default.tcl.fragment line;
            # compare only when present.
            if var in ns2_tcl:
                values.append((f"ns2.tcl {var}", ns2_tcl[var]))

        ns3 = spec.get("ns3")
        if ns3 is not None:
            if ns3 in ns3_ctor:
                values.append((f"ns3 {ns3}", ns3_ctor[ns3]))
            else:
                errors.append(
                    f"{field}: initializer {ns3} not found in "
                    "ns3/model/anthocnet-routing-protocol.cc"
                )

        if len({v for _, v in values}) > 1:
            detail = ", ".join(f"{where}={value:g}" for where, value in values)
            errors.append(f"{field}: defaults disagree — {detail}")
        checked.append((field, values))

    print(f"checked {len(checked)} field(s) across trees:")
    for field, values in checked:
        trees = ", ".join(where for where, _ in values)
        print(f"  {field}: {trees}")

    if errors:
        print(f"\nFAIL: {len(errors)} problem(s):", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1
    print("\nOK: all mapped defaults agree across trees")
    return 0


if __name__ == "__main__":
    sys.exit(main())
