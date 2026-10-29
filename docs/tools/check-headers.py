#!/usr/bin/env python3
# SPDX-License-Identifier: MIT OR GPL-2.0-only
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
are looked at, so build files, docs and the binary fuzz corpus
are none of its business.

The dual-licensed roots are the exception (ADR-0028): ``core/`` and the
standalone tooling (``tools/``, ``ns3/tools/``, ``docs/tools/``) are
``MIT OR GPL-2.0-only``. That MIT option is only real while the following
hold, so this gate checks them:

- every covered file there carries exactly ``MIT OR GPL-2.0-only``. A file
  that says ``GPL-2.0-only`` would quietly take the MIT option away from
  whoever copies it out. ``GPL_ONLY`` lists the files that stay GPL on
  purpose;
- a ``core/`` C++ file includes nothing from outside ``core/``. Angle includes
  must be C++ standard-library headers, and quote includes must resolve to a
  file under ``core/``. A ``core/`` file that pulled in an ns-3, ``web/`` or
  vendored-baseline header would bind the whole core to GPL. Golden rule 1
  already forbids simulator headers; this check makes the licence boundary
  just as explicit;
- a dual-licensed Python file that loads code by path (``sys.path``,
  ``spec_from_file_location``, ``import_module``) names no GPL-only Python
  root (``web/shell``, ``.claude/skills``). Loading one would make the
  script's working form GPL-only.

Usage:
    python3 docs/tools/check-headers.py            # scan git-tracked sources
    python3 docs/tools/check-headers.py --self-test
"""
from __future__ import annotations

import argparse
import pathlib
import re
import subprocess
import sys

SPDX = "SPDX-License-Identifier"
# The notice must be at the very top — after a shebang at most, not buried
# halfway down a file where a reader copying the file out would miss it.
HEAD_LINES = 5

CORE = "core/"
# Directories a core/ quote include may resolve against (besides the file's own).
CORE_INCLUDE_DIRS = ("core/include", "core/tests", "core/bench")
# The C++ standard library: the only angle includes core/ may use.
STD_HEADERS = frozenset([
    "algorithm", "any", "array", "atomic", "bitset", "cassert", "cctype",
    "cerrno", "cfloat", "chrono", "cinttypes", "climits", "clocale",
    "cmath", "complex", "condition_variable", "csignal", "cstdarg",
    "cstddef", "cstdint", "cstdio", "cstdlib", "cstring", "ctime", "cwchar",
    "deque", "exception", "forward_list", "fstream", "functional",
    "initializer_list", "iomanip", "ios", "iosfwd", "iostream", "istream",
    "iterator", "limits", "list", "locale", "map", "memory", "mutex", "new",
    "numeric", "optional", "ostream", "queue", "random", "ratio", "regex",
    "set", "sstream", "stack", "stdexcept", "streambuf", "string",
    "string_view", "system_error", "thread", "tuple", "type_traits",
    "typeindex", "typeinfo", "unordered_map", "unordered_set", "utility",
    "valarray", "variant", "vector",
])

CXX = (".cpp", ".cc", ".h")
# (path prefix, extensions) — a file is covered when it matches any pair.
COVERED = (
    ("core/", CXX),
    ("ns3/", CXX),
    ("ns3/tools/", (".py", ".sh")),
    ("docs/tools/", (".py", ".sh")),
    ("tools/", (".py", ".sh")),
    (".claude/skills/", (".py",)),
)

# ADR-0028: roots whose covered files must carry DUAL_SPDX.
DUAL_ROOTS = ("core/", "tools/", "ns3/tools/", "docs/tools/")
DUAL_SPDX = f"{SPDX}: MIT OR GPL-2.0-only"
# Files under a dual root that stay GPL-2.0-only, with the reason.
GPL_ONLY = {
    # Imports web/shell/inject.py (GPL-only) to render the site chrome.
    "docs/tools/mkdocs_hooks.py",
}
# Python that loads code by path, and the GPL-only Python roots it must not name.
PY_LOADERS = ("sys.path", "spec_from_file_location", "import_module")
GPL_PY_ROOTS = re.compile(
    r"""web["']?\s*[,/]\s*["']?shell|\.claude["']?\s*[,/]\s*["']?skills""")


def is_dual(rel: str) -> bool:
    """True when a repo-relative path must carry the dual licence."""
    return rel.startswith(DUAL_ROOTS) and rel not in GPL_ONLY


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


def dual_findings(text: str, display: str) -> list[str]:
    """ADR-0028: a dual-root file carries the exact dual expression."""
    if any(DUAL_SPDX in line for line in text.split("\n")[:HEAD_LINES]):
        return []
    msg = (f"{display}:1: this root is dual-licensed (ADR-0028) — the first "
           f"{HEAD_LINES} line(s) must carry\n    {DUAL_SPDX}\n"
           f"  (or list the file in GPL_ONLY with the reason it stays GPL)")
    return [msg]


# This checker names the GPL-only roots (and loader calls, in its self-test) to
# check for them; it loads nothing from them.
PY_NAMES_ONLY = {"docs/tools/check-headers.py"}


def py_findings(text: str, display: str) -> list[str]:
    """ADR-0028: dual-licensed Python loads no GPL-only Python by path."""
    if display in PY_NAMES_ONLY or not any(k in text for k in PY_LOADERS):
        return []
    return [f"{display}:{n}: loads code by path and names a GPL-only Python root "
            f"({m.group(0)}); a dual-licensed script must not import GPL-only "
            f"code (ADR-0028)"
            for n, line in enumerate(text.split("\n"), 1)
            for m in [GPL_PY_ROOTS.search(line)] if m]


def core_findings(text: str, display: str, exists=None) -> list[str]:
    """ADR-0028: a core/ C++ file includes nothing from outside core/.

    ``exists(rel)`` says whether a repo-relative path is a file; it is
    injectable so the self-test needs no tree.
    """
    out = []
    lines = text.split("\n")
    here = display.rsplit("/", 1)[0] if "/" in display else ""
    for n, line in enumerate(lines, 1):
        s = line.strip()
        if not s.startswith("#include"):
            continue
        target = s[len("#include"):].strip()
        if target.startswith("<"):
            name = target[1:target.find(">")] if ">" in target else target[1:]
            if name not in STD_HEADERS:
                out.append(f"{display}:{n}: core/ may include only the C++ standard "
                           f"library with <...>, not <{name}> (ADR-0028)")
        elif target.startswith('"'):
            name = target[1:target.find('"', 1)]
            dirs = ([here] if here else []) + list(CORE_INCLUDE_DIRS)
            hits = [f"{d}/{name}" for d in dirs]
            if exists is None or not any(
                    exists(h) and _norm(h).startswith(CORE) for h in hits):
                out.append(f'{display}:{n}: "{name}" does not resolve to a file '
                           f"under core/ — core/ includes nothing from outside "
                           f"core/ (ADR-0028)")
    return out


def _norm(rel: str) -> str:
    """Collapse ``..`` so ``core/src/../../ns3/x.h`` is seen as ``ns3/x.h``."""
    return str(pathlib.PurePosixPath(*_squash(pathlib.PurePosixPath(rel).parts)))


def _squash(parts):
    out = []
    for part in parts:
        if part == "..":
            if out:
                out.pop()
        elif part != ".":
            out.append(part)
    return out or ["."]


def scan(root: pathlib.Path) -> int:
    tracked = subprocess.run(
        ["git", "ls-files"],
        cwd=root, capture_output=True, text=True, check=True,
    ).stdout.split()
    files = sorted(rel for rel in tracked if covered(rel))
    problems = []
    for rel in files:
        text = (root / rel).read_text(encoding="utf-8")
        problems += findings(text, rel)
        if is_dual(rel):
            problems += dual_findings(text, rel)
            if rel.endswith(".py"):
                problems += py_findings(text, rel)
        if rel.startswith(CORE):
            problems += core_findings(text, rel, lambda h: (root / _norm(h)).is_file())
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
        "ns3/anthocnet/model/anthocnet-packet.cc",
        "docs/tools/check-headers.py",
        "ns3/tools/run-scenarios.py",
        "tools/bench/stats_util.py",
    ]
    covered_no = [
        # Build files, docs and the binary fuzz corpus are out of scope.
        "core/CMakeLists.txt",
        "core/tests/fuzz_corpus/seed-hello.bin",
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
    known = {"core/include/anthocnet/core/ports.h", "core/tests/test_support.h",
             "ns3/anthocnet/model/anthocnet-packet.h"}

    def has(h: str) -> bool:
        return _norm(h) in known

    core_ok = (
        "// SPDX-License-Identifier: MIT OR GPL-2.0-only\n// Copyright (C) 2026 X\n\n"
        '#include "anthocnet/core/ports.h"\n#include "test_support.h"\n'
        "#include <map>\n#include <cstdint>\n"
    )
    core_bad = {
        "GPL-only SPDX in core/":
            "// SPDX-License-Identifier: GPL-2.0-only\n#include <map>\n",
        "MIT-only SPDX in core/":
            "// SPDX-License-Identifier: MIT\n#include <map>\n",
        "simulator angle include":
            "// SPDX-License-Identifier: MIT OR GPL-2.0-only\n#include <ns3/node.h>\n",
        "non-standard angle include":
            "// SPDX-License-Identifier: MIT OR GPL-2.0-only\n#include <emscripten.h>\n",
        "quote include outside core/":
            "// SPDX-License-Identifier: MIT OR GPL-2.0-only\n"
            '#include "ns3/anthocnet/model/anthocnet-packet.h"\n',
        "quote include escaping core/ by ..":
            "// SPDX-License-Identifier: MIT OR GPL-2.0-only\n"
            '#include "../../ns3/anthocnet/model/anthocnet-packet.h"\n',
        "quote include that resolves nowhere":
            "// SPDX-License-Identifier: MIT OR GPL-2.0-only\n#include \"missing.h\"\n",
    }
    def both(case, display):
        return dual_findings(case, display) + core_findings(case, display, has)

    got = both(core_ok, "core/tests/test_x.cpp")
    if got:
        failures += 1
        print(f"SELF-TEST FAIL: expected silence for a clean core/ file, got {got}")
    for label, case in core_bad.items():
        if not both(case, "core/src/x.cpp"):
            failures += 1
            print(f"SELF-TEST FAIL: expected a core/ finding for {label}")
    py_ok = [
        # The tooling's own loaders: siblings under tools/bench.
        ("# SPDX-License-Identifier: MIT OR GPL-2.0-only\n"
         'SKILL = os.path.join(HERE, "..", "..", "tools", "bench")\n'
         "sys.path.insert(0, SKILL)\n"),
        # Naming a GPL path without loading code is not an import.
        ("# SPDX-License-Identifier: MIT OR GPL-2.0-only\n"
         'COVERED = ((".claude/skills/", (".py",)),)\n'),
    ]
    py_bad = {
        "sys.path into web/shell":
            '_sys.path.insert(0, os.path.join(ROOT, "web", "shell"))\nimport inject\n',
        "spec load from .claude/skills":
            'spec = importlib.util.spec_from_file_location("x", ".claude/skills/loader.py")\n',
    }
    for case in py_ok:
        got = dual_findings(case, "tools/x.py") + py_findings(case, "tools/x.py")
        if got:
            failures += 1
            print(f"SELF-TEST FAIL: expected silence for clean dual Python, got {got}")
    for label, case in py_bad.items():
        if not py_findings(case, "tools/x.py"):
            failures += 1
            print(f"SELF-TEST FAIL: expected a Python finding for {label}")
    for rel, want in (("tools/bench/stats_util.py", True), ("ns3/tools/run.sh", True),
                      ("core/src/a.cpp", True), ("docs/tools/mkdocs_hooks.py", False),
                      ("ns3/anthocnet/model/a.cc", False), ("web/shell/inject.py", False),
                      (".claude/skills/y.py", False)):
        if is_dual(rel) != want:
            failures += 1
            print(f"SELF-TEST FAIL: is_dual({rel}) should be {want}")
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
