#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Reject Mermaid blocks that GitHub will refuse to render.

Why this exists
---------------
A ``sequenceDiagram`` message containing the HTML entities ``&lt;``/``&gt;``
(written to express a C++ template such as ``vector<RouteDecision>``) parses
locally as balanced text but is a hard parse error in Mermaid's sequence
grammar, so GitHub replaces the whole diagram with "Unable to render rich
display". It shipped because the pre-commit check verified *structure*
(``subgraph``/``end`` nesting, bracket balance) and never asked whether Mermaid
could actually parse the block.

The rule enforced here is deliberately narrow, because a check that fires on
innocent input gets ignored and then is not a gate (#229's lesson): HTML
entities are never *needed* inside a Mermaid block — plain words render better
and parse everywhere — so forbidding them outright has no false positives.
Inline tags such as ``<b>``, ``<i>`` and ``<br/>`` are left alone; they are used
throughout the existing diagrams and render correctly.

Usage:
    python3 docs/tools/check-mermaid.py            # scan the repo's markdown
    python3 docs/tools/check-mermaid.py --self-test
"""
from __future__ import annotations

import argparse
import pathlib
import re
import sys

BLOCK = re.compile(r"```mermaid\n(.*?)```", re.DOTALL)
# Named entities (&lt; &gt; &amp; &quot; &nbsp;) and numeric ones (&#94; &#x5e;).
ENTITY = re.compile(r"&(?:[a-zA-Z][a-zA-Z0-9]{1,10}|#[0-9]{1,5}|#x[0-9a-fA-F]{1,4});")


def findings(text: str, path: str = "<input>") -> list[str]:
    """Return one message per offending line; empty list means clean."""
    out = []
    for block in BLOCK.finditer(text):
        base = text[: block.start()].count("\n") + 1  # 1-based line of the fence
        for offset, line in enumerate(block.group(1).split("\n"), start=1):
            for hit in ENTITY.finditer(line):
                out.append(
                    f"{path}:{base + offset}: HTML entity {hit.group(0)!r} inside a "
                    f"mermaid block — write it as plain text instead "
                    f"(entities break Mermaid's sequence grammar and GitHub "
                    f"renders nothing)"
                )
    return out


def scan(root: pathlib.Path) -> int:
    problems = []
    for md in sorted(root.rglob("*.md")):
        if any(part in {".git", "node_modules"} for part in md.parts):
            continue
        problems += findings(md.read_text(encoding="utf-8"), str(md.relative_to(root)))
    for line in problems:
        print(f"FAIL: {line}")
    print(f"checked markdown under {root}; {len(problems)} problem(s)")
    return 1 if problems else 0


def self_test() -> int:
    """Every rule gets a case that must fire and one that must stay quiet."""
    must_fire = [
        # The exact shipped defect.
        "```mermaid\nsequenceDiagram\n    A-->>B: vector&lt;RouteDecision&gt;\n```\n",
        # Numeric entity in a flowchart label.
        '```mermaid\nflowchart LR\n    A["T&#94;i"] --> B\n```\n',
    ]
    must_not_fire = [
        # Inline tags and arrows are fine and are used across the docs.
        '```mermaid\nflowchart LR\n    A["<b>bold</b><br/>next"] --> B{"q?"}\n```\n',
        "```mermaid\nsequenceDiagram\n    A-->>B: a list of RouteDecision\n    Note over A: 5 > 3\n```\n",
        # Entities outside a mermaid block are none of this check's business.
        "Prose mentioning &lt;T&gt; and a table | &amp; | value |\n",
    ]
    failures = 0
    for case in must_fire:
        if not findings(case):
            failures += 1
            print("SELF-TEST FAIL: expected a finding, got none for:\n" + case)
    for case in must_not_fire:
        got = findings(case)
        if got:
            failures += 1
            print(f"SELF-TEST FAIL: expected silence, got {got} for:\n" + case)
    print("self-test:", "PASS" if not failures else f"{failures} FAILURE(S)")
    return 1 if failures else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--self-test", action="store_true", help="run the rule's own cases")
    ap.add_argument("root", nargs="?", default=".", help="directory to scan")
    args = ap.parse_args()
    if args.self_test:
        return self_test()
    return scan(pathlib.Path(args.root))


if __name__ == "__main__":
    sys.exit(main())
