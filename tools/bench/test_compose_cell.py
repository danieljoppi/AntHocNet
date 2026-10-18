#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for compose_cell.py: the composed cell keeps every baseline line,
carries the arm's lines for the protocol, drops that protocol's set rows,
keeps both provenance lines, and refuses an arm whose seeds differ."""
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
TOOL = os.path.join(HERE, "compose_cell.py")

BASE = """# campaign control
##CONFIG## protocols=anthocnet,aodv
##RUN## 1 anthocnet 99.0 3.0 10.0 13.0 4.5
##RUN## 1 aodv 97.0 14.0 215.0 12.8 17.5
##RUN## 2 anthocnet 98.0 3.1 11.0 13.0 4.6
##RUN## 2 aodv 96.0 15.0 216.0 12.7 17.6
##COMMON## 1 anthocnet 100 90 1 2 3
##COMMON## 1 aodv 100 90 1 2 3
# diag anthocnet seed=1 pdr=99.0
# diag aodv seed=1 pdr=97.0
protocol PDR% delay delay99 thrput NRL
anthocnet 98.5 3.0 10.5 13.0 4.55
aodv 96.5 14.5 215.5 12.8 17.55
# stddev anthocnet pdr=0.7 delay=0.1 delay99=0.7 nrl=0.07
# stddev aodv pdr=0.7 delay=0.7 delay99=0.7 nrl=0.07
##PROV## commit=aaaa run_id=1
"""
ARM = """# campaign quiet
##CONFIG## protocols=anthocnet
##RUN## 1 anthocnet 99.1 3.0 9.0 13.0 4.1
##RUN## 2 anthocnet 98.1 3.1 9.5 13.0 4.2
##COMMON## 1 anthocnet 100 99 1 2 3
# diag anthocnet seed=1 pdr=99.1
protocol PDR% delay delay99 thrput NRL
anthocnet 98.6 3.0 9.2 13.0 4.15
# stddev anthocnet pdr=0.7 delay=0.1 delay99=0.4 nrl=0.07
##PROV## commit=bbbb run_id=2
"""

failures = 0


def check(cond, msg):
    global failures
    if not cond:
        failures += 1
        print(f"FAIL: {msg}")


def compose(base, arm):
    with tempfile.TemporaryDirectory() as d:
        b, a, o = (os.path.join(d, n) for n in ("base.txt", "arm.txt", "out.txt"))
        for path, text in ((b, base), (a, arm)):
            with open(path, "w") as f:
                f.write(text)
        r = subprocess.run([sys.executable, TOOL, b, a, "--proto", "anthocnet", "-o", o],
                           capture_output=True, text=True, check=False)
        out = ""
        if os.path.exists(o):
            with open(o) as f:
                out = f.read()
        return r.returncode, out, r.stderr


rc, out, err = compose(BASE, ARM)
lines = out.splitlines()
check(rc == 0, f"compose exits 0 ({err.strip()})")
check(lines[0].startswith("# composed:"), "the first line names the composition")
check("##RUN## 1 anthocnet 99.1 3.0 9.0 13.0 4.1" in lines, "the arm's anthocnet ##RUN## row is in")
check("##RUN## 1 anthocnet 99.0 3.0 10.0 13.0 4.5" not in lines, "the control's anthocnet ##RUN## row is out")
check("##RUN## 2 aodv 96.0 15.0 216.0 12.7 17.6" in lines, "every baseline row is kept")
check(not any(ln.startswith("##COMMON## 1 anthocnet") for ln in lines), "anthocnet's ##COMMON## rows are dropped")
check("##COMMON## 1 aodv 100 90 1 2 3" in lines, "the baselines' ##COMMON## rows are kept")
check("anthocnet 98.6 3.0 9.2 13.0 4.15" in lines and "anthocnet 98.5 3.0 10.5 13.0 4.55" not in lines,
      "the human table row is the arm's")
check("# stddev anthocnet pdr=0.7 delay=0.1 delay99=0.4 nrl=0.07" in lines, "the stddev line is the arm's")
check(lines.index("anthocnet 98.6 3.0 9.2 13.0 4.15") < lines.index("aodv 96.5 14.5 215.5 12.8 17.55"),
      "the arm's table row takes the control's slot")
check(sum(ln.startswith("##PROV##") for ln in lines) == 2, "both provenance lines are kept")

rc, _, err = compose(BASE, ARM.replace("##RUN## 2 anthocnet", "##RUN## 3 anthocnet"))
check(rc != 0 and "seeds differ" in err, "an arm with other seeds is refused")
rc, _, err = compose(BASE, "##PROV## commit=bbbb\n")
check(rc != 0 and "no ##RUN## rows" in err, "an arm without the protocol is refused")

print("compose_cell self-test:", "FAIL" if failures else "PASS")
sys.exit(1 if failures else 0)
