#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Reject markdown links whose relative target does not exist.

Why this exists
---------------
This repo's docs lean hard on relative links — ADRs cite source files,
benchmark pages cite campaign CSVs, AGENTS.md cites everything — and a rename
or move silently strands every inbound link. Nothing catches that today: the
page still renders, the link just 404s when a reader (or an agent following
the cross-session trail, ADR-0013) clicks it. So make it a gate: every inline
``](target)`` whose target is a relative path must resolve to a file or
directory in the tree.

The rule enforced here is deliberately narrow, because a check that fires on
innocent input gets ignored and then is not a gate (#229's lesson): external
``http(s)://`` and ``mailto:`` targets are skipped (checking them needs a
network and flakes), pure ``#anchor`` self-links are skipped (heading anchors
are a rendering concern, not a filesystem one), and ``#fragment`` suffixes on
path targets are stripped before the existence check. Fenced code blocks and
inline code spans are skipped too — a ``](...)`` inside an example is prose,
not a link.

Usage:
    python3 docs/tools/check-links.py            # scan git-tracked markdown
    python3 docs/tools/check-links.py --self-test
"""
from __future__ import annotations

import argparse
import pathlib
import re
import subprocess
import sys
import tempfile

LINK = re.compile(r"\]\(([^)\s]+)\)")
FENCE = re.compile(r"^(```|~~~).*?^\1[^\n]*$", re.DOTALL | re.MULTILINE)
CODESPAN = re.compile(r"`[^`\n]*`")
EXTERNAL = ("http://", "https://", "mailto:")


def findings(text: str, md_path: pathlib.Path, display: str | None = None) -> list[str]:
    """Return one message per dangling target; empty list means clean."""
    display = display or str(md_path)
    stripped = CODESPAN.sub("", FENCE.sub(lambda m: "\n" * m.group(0).count("\n"), text))
    out = []
    for lineno, line in enumerate(stripped.split("\n"), start=1):
        for hit in LINK.finditer(line):
            target = hit.group(1)
            if target.startswith(EXTERNAL) or target.startswith("#"):
                continue
            path_part = target.split("#", 1)[0]
            if not path_part:
                continue
            if not (md_path.parent / path_part).exists():
                out.append(
                    f"{display}:{lineno}: link target {target!r} does not exist "
                    f"(resolved against the file's own directory)"
                )
    return out


def scan(root: pathlib.Path) -> int:
    tracked = subprocess.run(
        ["git", "ls-files", "*.md"],
        cwd=root, capture_output=True, text=True, check=True,
    ).stdout.split()
    problems = []
    for rel in sorted(tracked):
        md = root / rel
        problems += findings(md.read_text(encoding="utf-8"), md, rel)
    for line in problems:
        print(f"FAIL: {line}")
    print(f"checked {len(tracked)} tracked markdown file(s) under {root}; {len(problems)} problem(s)")
    return 1 if problems else 0


def self_test() -> int:
    """Every rule gets a case that must fire and one that must stay quiet."""
    with tempfile.TemporaryDirectory() as tmp:
        root = pathlib.Path(tmp)
        (root / "docs").mkdir()
        (root / "docs" / "real.md").write_text("# here\n", encoding="utf-8")
        md = root / "docs" / "page.md"
        must_fire = [
            # The rename failure mode this gate exists for.
            "See [gone](missing.md) for detail.\n",
            # A fragment does not excuse a dangling path.
            "See [gone](missing.md#section).\n",
            # Image links are links too.
            "![chart](../assets/nope.png)\n",
        ]
        must_not_fire = [
            # Sibling file, with and without a fragment; parent dir; external.
            (
                "[ok](real.md) [ok](real.md#here) [up](../docs) "
                "[web](https://example.com/missing.md) [mail](mailto:x@y.z) [anchor](#here)\n"
            ),
            # Inside a code fence or code span it is an example, not a link.
            "```\n[ex](missing.md)\n```\n",
            "Use `[ex](missing.md)` syntax.\n",
        ]
        failures = 0
        for case in must_fire:
            if not findings(case, md):
                failures += 1
                print("SELF-TEST FAIL: expected a finding, got none for:\n" + case)
        for case in must_not_fire:
            got = findings(case, md)
            if got:
                failures += 1
                print(f"SELF-TEST FAIL: expected silence, got {got} for:\n" + case)
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
