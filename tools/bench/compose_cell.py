#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Compose a published cell from a campaign's control and one arm.

    compose_cell.py BASE ARM --proto anthocnet -o OUT

When a campaign moves one protocol's default (v2.3.0: quiet mode), the new
generation is the control for every other protocol and the arm for the one
that moved. The baselines are byte-identical whether or not that protocol ran
beside them (the attribution control checks it), so their rows pair with the
arm's per seed exactly as they did with the control's.

OUT is BASE with every line of PROTO replaced by ARM's, in ARM's order:
the per-run tagged rows (`##TAG## <seed> <proto> ...`), the `# diag`,
`# stddev`, `# drops`, `# paths`, `# energy`, `# reorder` lines and the
human table row. PROTO's `##COMMON##` and `##MATCH##` rows are dropped: they
describe the set of packets every protocol of one run delivered, and no run
held this pairing. Every `##PROV##` line of both inputs is kept, and a `#`
header names the composition. Exit 1 if ARM has no PROTO rows, or its seeds
differ from BASE's.
"""
import argparse
import os
import sys

SET_TAGS = ("##COMMON##", "##MATCH##")


def proto_of(line):
    """The protocol a line belongs to, or None."""
    p = line.split()
    if len(p) >= 3 and p[0].startswith("##") and p[0].endswith("##") and p[1].isdigit():
        return p[2]
    if len(p) >= 2 and p[0] == "#" and p[1] in ("diag", "stddev", "drops", "paths", "energy", "reorder"):
        return p[2] if len(p) > 2 else None
    return None


def is_table_row(line, proto):
    p = line.split()
    return len(p) > 5 and p[0] == proto and not line.startswith("#")


def seeds(lines, proto):
    return sorted(int(ln.split()[1]) for ln in lines if ln.startswith("##RUN##") and proto_of(ln) == proto)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("base")
    ap.add_argument("arm")
    ap.add_argument("--proto", required=True)
    ap.add_argument("-o", "--out", required=True)
    a = ap.parse_args()
    with open(a.base) as f:
        base = f.read().splitlines()
    with open(a.arm) as f:
        arm = f.read().splitlines()

    def mine(ln):
        return proto_of(ln) == a.proto or is_table_row(ln, a.proto)

    sb, sa = seeds(base, a.proto), seeds(arm, a.proto)
    if not sa:
        sys.exit(f"{a.arm}: no ##RUN## rows for {a.proto}")
    if sb and sa != sb:
        sys.exit(f"seeds differ: {a.base} {sb} vs {a.arm} {sa}")
    # ARM's lines of PROTO, by kind, in ARM's order; the set rows are dropped.
    take = {}
    for ln in arm:
        if mine(ln) and not ln.startswith(SET_TAGS):
            kind = ln.split()[0] if ln.startswith("#") else "<table>"
            if ln.startswith("# "):
                kind = "# " + ln.split()[1]
            take.setdefault(kind, []).append(ln)
    out = [(f"# composed: {os.path.basename(a.base)} with {a.proto} from {os.path.basename(a.arm)} "
            f"(compose_cell.py); {a.proto}'s ##COMMON##/##MATCH## rows dropped")]
    placed = set()
    for ln in base:
        if not mine(ln):
            out.append(ln)
            continue
        kind = ln.split()[0] if ln.startswith("#") else "<table>"
        if ln.startswith("# "):
            kind = "# " + ln.split()[1]
        if kind in placed or ln.startswith(SET_TAGS):
            continue
        out.extend(take.get(kind, []))
        placed.add(kind)
    missing = [k for k in take if k not in placed]
    if missing:
        sys.exit(f"{a.arm}: {a.proto} lines with no slot in {a.base}: {', '.join(missing)}")
    out.extend(ln for ln in arm if ln.startswith("##PROV##"))
    with open(a.out, "w") as f:
        f.write("\n".join(out) + "\n")


if __name__ == "__main__":
    main()
