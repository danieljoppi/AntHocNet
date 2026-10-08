#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Cross-tree Config default parity check (issue #258).

The same protocol default lives in two places:

  core   core/include/anthocnet/core/config.h      (default member initializers)
  ns3    ns3/model/anthocnet-routing-protocol.cc   (constructor initializers)

(Through v1.9.0 it also lived in three NS-2 files -- ahn_router.h macros,
ahn_router.cc initializers and ns-default.tcl.fragment -- and this check
compared all of them. The NS-2 adapter was removed in v2.0.0, #307.)

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
NS3_CC = REPO / "ns3/model/anthocnet-routing-protocol.cc"

# core field -> its ns-3 constructor initializer.
FIELDS = {
    "alpha": {"ns3": "m_alpha"},
    "gamma": {"ns3": "m_gamma"},
    "hopCountAlpha": {"ns3": "m_hopCountAlpha"},
    "betaAnts": {"ns3": "m_betaAnts"},
    "betaData": {"ns3": "m_betaData"},
    "hopTimeSec": {"ns3": "m_hopTime"},
    "enableMacMetric": {"ns3": "m_enableMacMetric"},
    "enableProactive": {"ns3": "m_enableProactive"},
    "enableDiffusion": {"ns3": "m_enableDiffusion"},
    "enableReactive": {"ns3": "m_enableReactive"},
    "enableRepair": {"ns3": "m_enableRepair"},
    "enableLinkFail": {"ns3": "m_enableLinkFail"},
    "enableDirectedReactive": {"ns3": "m_enableDirectedReactive"},
    "proactiveBroadcastProb": {"ns3": "m_proactiveBroadcastProb"},
    "proactiveVirtualMargin": {"ns3": "m_proactiveVirtualMargin"},
    "maxHelloAdverts": {"ns3": "m_maxHelloAdverts"},
    "sessionTtl": {"ns3": "m_sessionTtl"},
    "helloInterval": {"ns3": "m_helloInterval"},
    "proactiveInterval": {"ns3": "m_proactiveInterval"},
    "linkfailNotifyInterval": {"ns3": "m_linkfailNotifyInterval"},
    "txFailureThreshold": {"ns3": "m_txFailureThreshold"},
    "enableMultipath": {"ns3": "m_enableMultipath"},
    "antAcceptanceFactor": {"ns3": "m_antAcceptanceFactor"},
    "antAcceptanceFactorNewHop": {"ns3": "m_antAcceptanceFactorNewHop"},
    "repairWaitFactor": {"ns3": "m_repairWaitFactor"},
    "repairTimeout": {"ns3": "m_repairTimeout"},
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
        r"^\s*(?:double|bool|int|std::size_t)\s+(\w+)\s*=\s*([-\w.]+)\s*;", re.MULTILINE
    )
    return {name: norm(value) for name, value in pat.findall(text)}


def parse_ns3_ctor(text):
    # e.g. "      m_helloInterval(Seconds(1.0))," / "m_alpha(0.7)," /
    #      "m_enableProactive(true),"
    pat = re.compile(r"^\s*(m_\w+)\((?:Seconds\()?(true|false|[-\d.]+)\)?\)", re.MULTILINE)
    return {name: norm(value) for name, value in pat.findall(text)}


def main():
    core = parse_config_h(CONFIG_H.read_text())
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
