#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for harness_control.py (#769).

Run: python3 test_harness_control.py   (no pytest dependency; exits non-zero
                                        on the first failure)
"""

import importlib.util
import os

path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "harness_control.py")
spec = importlib.util.spec_from_file_location("harness_control", path)
hc = importlib.util.module_from_spec(spec)
spec.loader.exec_module(hc)

COMMITTED = """##CONFIG## scenario=paper nNodes=50 runs=10 firstRun=1 protocols=anthocnet,aodv
##RUN## 1 anthocnet 98.6 9.6
##ROUTE## 1 anthocnet 1.08 4.02
##RUN## 1 aodv 88.8 37.3
##RUN## 2 anthocnet 97.0 9.9
##RUN## 2 aodv 87.1 30.0
##RUN## 3 anthocnet 96.0 9.0
##COMMON## 1 anthocnet 10 20
# drops anthocnet pdr=98.6 route=1.0
"""

# Seeds 1-2 only, the same rows: PASS, whatever seed 3 holds.
NEW_OK = """##CONFIG## scenario=paper nNodes=50 runs=2 firstRun=1 protocols=anthocnet,aodv
##RUN## 1 anthocnet 98.6 9.6
##ROUTE## 1 anthocnet 1.08 4.02
##RUN## 1 aodv 88.8 37.3
##COMMON## 1 anthocnet 10 20
##RUN## 2 anthocnet 97.0 9.9
##RUN## 2 aodv 87.1 30.0
# drops anthocnet pdr=98.6 route=1.0 mac=0.4
"""


def check(cond, msg):
    if not cond:
        raise SystemExit(f"FAIL: {msg}")


v, detail, warn = hc.compare(COMMITTED, NEW_OK)
check(v == "PASS" and not warn, f"identical rows pass ({v}: {detail} {warn})")

v, detail, _ = hc.compare(COMMITTED, NEW_OK.replace("88.8 37.3", "88.9 37.3"))
check(v == "FAIL" and "##RUN## seed 1 aodv" in detail, f"a changed row fails ({detail})")

v, detail, _ = hc.compare(COMMITTED, NEW_OK.replace("##COMMON## 1 anthocnet 10 20\n", ""))
check(v == "FAIL" and "##COMMON##" in detail, f"a missing row fails ({detail})")

v, _, warn = hc.compare(COMMITTED, NEW_OK.replace("nNodes=50", "nNodes=51"))
check(warn, "a config drift warns")

v, _, _ = hc.compare(COMMITTED, "nothing here\n")
check(v == "FAIL", "an empty new file fails")

print("PASS test_harness_control.py")
