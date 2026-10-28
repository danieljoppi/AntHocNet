#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Self-test for comparator_view.py: an anchor reads arm minus reference in
one file; the Termite trend reads s20 minus s1 from the ##RUN## PDR and the
##ROUTE## hop means; a family cell pairs the arm's rows with the control generation's
AntHocNet, oracle and best-native rows by seed, with the sign arm minus
reference."""
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
TOOL = os.path.join(HERE, "comparator_view.py")


def rows(proto, pdrs, nrl):
    return "".join(f"##RUN## {s} {proto} {p} 10.0 100.0 13.0 {nrl}\n"
                   for s, p in enumerate(pdrs, 1))


def main():
    with tempfile.TemporaryDirectory() as d:
        with open(os.path.join(d, "anchor-ara-p0-v250c.txt"), "w") as f:
            f.write(rows("ara", [90, 92, 94], 5.0) + rows("aodv", [80, 81, 83], 9.0))
        ctrl = (rows("anthocnet", [98, 98, 98], 4.0) + rows("oracle", [99, 99, 99], 3.0)
                + rows("aodv", [88, 87, 86], 9.0) + rows("olsr", [70, 70, 70], 20.0))
        for cell, pdrs, hop in (("s1", [96, 95, 97], 3.0), ("s20", [80, 82, 78], 6.0)):
            route = "".join(f"##ROUTE## {s} termite 1 2 0 0.1 10 5 {hop} {hop + s / 10}\n"
                            for s in (1, 2, 3))
            with open(os.path.join(d, f"anchor-termite-{cell}-v250c.txt"), "w") as f:
                f.write(rows("termite", pdrs, 2.0) + route)
        with open(os.path.join(d, "grid-rwp-tworay-v240.txt"), "w") as f:
            f.write(ctrl)
        with open(os.path.join(d, "grid-rwp-tworay-v250c.txt"), "w") as f:
            f.write(rows("qrouting", [88, 88, 88], 6.0))
        out = subprocess.run([sys.executable, TOOL, "--dir", d], capture_output=True,
                             text=True, check=True).stdout
    trend = [ln for ln in out.splitlines() if ln.startswith(("| pdr |", "| data hops |"))]
    assert trend[0].startswith("| pdr | 96.00 | 80.00 | -16.00 ["), trend
    assert trend[1].startswith("| data hops | 3.20 | 6.20 | +3.00 [+2.77, +3.23]"), trend  # se 0.0816, t(4) 2.776
    lines = {tuple(c.strip() for c in ln.split("|")[1:5]): ln for ln in out.splitlines()
             if ln.startswith("| ")}
    anchor = lines[("anchor-ara-p0", "ara", "aodv", "3")]
    assert "| +10.67 [" in anchor, anchor  # mean(10, 11, 11)
    fam = {k[3]: v for k, v in lines.items() if k[:3] == ("MANET grid", "grid-rwp-tworay",
                                                          "qrouting")}
    assert set(fam) == {"anthocnet", "oracle", "best native (aodv)"}, fam
    assert "| -10.00 [-10.00, -10.00]" in fam["anthocnet"], fam["anthocnet"]
    assert "| +1.00 [" in fam["best native (aodv)"], fam  # 88 - mean(88, 87, 86)
    print("comparator_view self-test: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
