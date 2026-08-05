#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Reject tracked source files that carry no SPDX licence identifier.

Why this exists
---------------
The repo is GPL-2.0-only but for its whole history not one source file said so:
the licence lived only in ``LICENSE`` (stock FSF text, FSF copyright). GPLv2 §1
expects the notice to travel *with the file*, and this is a protocol
implementation people copy files out of — a ``pheromone_engine.cpp`` pasted into
someone's simulator tree arrives with no licence, no author and no way back to
this repo. #332 added the two-line notice everywhere; this gate is what keeps
the next new file from landing without one.

The rule enforced here is deliberately narrow, because a check that fires on
innocent input gets ignored and then is not a gate (#229's lesson): it asks one
question — does ``SPDX-License-Identifier`` appear in the file's first few lines
— and says nothing about the copyright line, the comment style, or the licence
name. Only tracked files under the covered roots and with a covered extension
are looked at, so build files, Tcl scenarios, docs and the binary fuzz corpus
are none of its business.

``ns2/patch/fragments/`` is covered by neither this gate nor #332's sweep, on
purpose: those files are inserted **verbatim** into a user-supplied NS-2 tree by
the anchor-based patch, and several are reverted by pattern rather than by
marker, so a prepended comment line would survive ``revert-patch.sh`` and break
its byte-for-byte round-trip (and, in the Tcl switch body and the Makefile.in
object list, a ``#`` is not even a comment). ``ns2/patch/NOTICE`` states the
licensing posture for that directory instead.

Usage:
    python3 docs/tools/check-headers.py            # scan git-tracked sources
    python3 docs/tools/check-headers.py --self-test
"""
from __future__ import annotations

import argparse
import pathlib
import subprocess
import sys

SPDX = "SPDX-License-Identifier"
# The notice must be at the very top — after a shebang at most, not buried
# halfway down a file where a reader copying the file out would miss it.
HEAD_LINES = 5

CXX = (".cpp", ".cc", ".h")
# (path prefix, extensions) — a file is covered when it matches any pair.
COVERED = (
    ("core/", CXX),
    ("ns3/", CXX),
    ("ns2/src/", CXX),
    ("ns3/tools/", (".py",)),
    ("docs/tools/", (".py",)),
    (".claude/skills/", (".py",)),
)


def covered(rel: str) -> bool:
    """True when a repo-relative path is in scope for the notice."""
    return any(rel.startswith(p) and rel.endswith(e) for p, e in COVERED)


def findings(text: str, display: str) -> list[str]:
    """Return one message per offending file; empty list means clean."""
    if any(SPDX in line for line in text.split("\n")[:HEAD_LINES]):
        return []
    msg = (
        f"{display}:1: no {SPDX} in the first {HEAD_LINES} line(s) — add\n"
        f"    // SPDX-License-Identifier: GPL-2.0-only\n"
        f"    // Copyright (C) <year> <author>\n"
        f"  at the top ('#' comments for Python, after any shebang)"
    )
    return [msg]


def scan(root: pathlib.Path) -> int:
    tracked = subprocess.run(
        ["git", "ls-files"],
        cwd=root, capture_output=True, text=True, check=True,
    ).stdout.split()
    files = sorted(rel for rel in tracked if covered(rel))
    problems = []
    for rel in files:
        problems += findings((root / rel).read_text(encoding="utf-8"), rel)
    for line in problems:
        print(f"FAIL: {line}")
    print(f"checked {len(files)} tracked source file(s) under {root}; {len(problems)} problem(s)")
    return 1 if problems else 0


def self_test() -> int:
    """Every rule gets a case that must fire and one that must stay quiet."""
    must_fire = [
        # The shipped state before #332: a doc comment, no licence anywhere.
        "/**\n * PheromoneTable: per-node routing state.\n */\n#include <map>\n",
        # A notice pushed below the header window is not a file-top notice.
        "\n\n\n\n\n// SPDX-License-Identifier: GPL-2.0-only\n",
        # Shebang only.
        '#!/usr/bin/env python3\n"""A tool."""\n',
    ]
    must_not_fire = [
        # The two forms #332 writes.
        "// SPDX-License-Identifier: GPL-2.0-only\n// Copyright (C) 2026 X\n\n#include <map>\n",
        '#!/usr/bin/env python3\n# SPDX-License-Identifier: GPL-2.0-only\n# Copyright (C) 2026 X\n"""A tool."""\n',
        # Any SPDX expression counts; this gate does not police the licence.
        "/* SPDX-License-Identifier: MIT */\n",
    ]
    covered_yes = [
        "core/src/pheromone_table.cpp",
        "core/include/anthocnet/core/ports.h",
        "ns3/model/anthocnet-packet.cc",
        "ns2/src/ahn_router.h",
        "docs/tools/check-headers.py",
        "ns3/tools/run-scenarios.py",
        ".claude/skills/benchmark-results/stats_util.py",
    ]
    covered_no = [
        # Build files, Tcl, docs and the binary fuzz corpus are out of scope,
        # and so are the NS-2 patch fragments (see the module docstring).
        "core/CMakeLists.txt",
        "core/tests/fuzz_corpus/seed-hello.bin",
        "ns2/tcl/scenario1/scenario1.tcl",
        "ns2/patch/fragments/cmu-trace.cc.impl.fragment",
        "ns2/patch/apply-patch.sh",
        "docs/architecture.md",
        "README.md",
    ]
    failures = 0
    for case in must_fire:
        if not findings(case, "<case>"):
            failures += 1
            print("SELF-TEST FAIL: expected a finding, got none for:\n" + case)
    for case in must_not_fire:
        got = findings(case, "<case>")
        if got:
            failures += 1
            print(f"SELF-TEST FAIL: expected silence, got {got} for:\n" + case)
    for rel in covered_yes:
        if not covered(rel):
            failures += 1
            print(f"SELF-TEST FAIL: {rel} should be covered")
    for rel in covered_no:
        if covered(rel):
            failures += 1
            print(f"SELF-TEST FAIL: {rel} should not be covered")
    print("self-test:", "PASS" if not failures else f"{failures} FAILURE(S)")
    return 1 if failures else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--self-test", action="store_true", help="run the rule's own cases")
    ap.add_argument("root", nargs="?", default=".", help="repo root to scan")
    args = ap.parse_args()
    if args.self_test:
        return self_test()
    return scan(pathlib.Path(args.root))


if __name__ == "__main__":
    sys.exit(main())
