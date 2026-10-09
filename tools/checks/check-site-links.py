#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Two-way links between the game and the docs (#631), checked.

The game and the docs teach the same mechanisms. This keeps them pointing at
each other as pages and missions are added:

  * every world in web/site/js/worlds.js has a `read:` Field guide page;
  * every Academy mission in web/site/js/missions-data.js links at least one
    docs page;
  * every family results page has `try:` front matter naming a world;
  * every target exists: docs links resolve to a docs page, API links name a
    class declared in core/include, and `try:` worlds are real world ids;
  * the Nest (#635) has a chamber for every public class/struct in
    core/include, and names no class that does not exist;
  * every install-quest step's command (#636) appears in the install docs.

Stdlib only; reads the JS as text (the data files are plain object literals).

Usage:  python3 tools/checks/check-site-links.py            # the repo
        python3 tools/checks/check-site-links.py --self-test
"""
from __future__ import annotations

import os
import re
import sys

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
FAMILY_PAGES = [
    "docs/benchmarks/grid.md",
    "docs/benchmarks/static-mesh.md",
    "docs/benchmarks/scenarios/vanet.md",
    "docs/benchmarks/scenarios/fanet.md",
    "docs/benchmarks/satellite/leo-walker.md",
]


def read(rel: str) -> str:
    with open(os.path.join(REPO, rel), encoding="utf-8") as f:
        return f.read()


def docs_target_exists(href: str, exists=os.path.exists) -> bool:
    """'docs/x/y/' (a site URL) -> docs/x/y.md, docs/x/y/README.md or index.md."""
    path = href.split("#")[0]
    assert path.startswith("docs/"), href
    stem = path[len("docs/"):].rstrip("/")
    if not stem:
        return exists(os.path.join(REPO, "docs", "README.md"))
    cands = [f"docs/{stem}.md", f"docs/{stem}/README.md", f"docs/{stem}/index.md"]
    return any(exists(os.path.join(REPO, c)) for c in cands)


def api_classes() -> set[str]:
    names = set()
    inc = os.path.join(REPO, "core", "include", "anthocnet", "core")
    for f in os.listdir(inc):
        if f.endswith(".h"):
            with open(os.path.join(inc, f), encoding="utf-8") as h:
                names |= set(re.findall(r"^(?:class|struct)\s+(\w+)\b(?!;)", h.read(), re.MULTILINE))
    return names


def worlds(js: str) -> dict[str, dict]:
    out = {}
    for block in re.split(r"\n  \{\n", js)[1:]:
        m = re.search(r"id: '(\w+)'", block)
        if not m:
            continue
        rd = re.search(r"read: \{ href: GUIDE \+ '([^']+)'", block)
        out[m.group(1)] = {"read": ("docs/" + rd.group(1)) if rd else None}
    return out


def missions(js: str) -> list[dict]:
    # resolve the simple `const X = 'lit';` and `const X = API + 'lit';` forms
    consts: dict[str, str] = {}
    for name, base, lit in re.findall(r"^const (\w+) = (?:(\w+) \+ )?'([^']*)';", js, re.MULTILINE):
        consts[name] = (consts.get(base, "") if base else "") + lit
    out = []
    for block in re.split(r"\n  \{\n", js)[1:]:
        m = re.search(r"id: '([\w-]+)', n: \d+, group: '([^']+)'", block)
        if not m:
            continue
        links = []
        lm = re.search(r"links: \[(.*?)\],\n", block, re.DOTALL)
        if lm:
            for base, lit in re.findall(r"(\w+)(?: \+ '([^']*)')?\]", lm.group(1)):
                if base in consts:
                    links.append(consts[base] + (lit or ""))
        out.append({"id": m.group(1), "group": m.group(2), "links": links})
    return out


def front_matter_try(md: str) -> list[str]:
    m = re.match(r"---\n(.*?)\n---\n", md, re.DOTALL)
    if not m:
        return []
    return re.findall(r"^\s*- world: (\w+)", m.group(1), re.MULTILINE)


def nest_classes(js: str) -> list[str]:
    return [c for block in re.findall(r"classes: \[([^\]]*)\]", js) for c in re.findall(r"'(\w+)'", block)]


def quest_cmds(js: str) -> list[str]:
    return re.findall(r"cmd: '([^']+)'", js)


INSTALL_DOCS = ("docs/places/workshop.md", "ns3/README.md")


def check(worlds_js: str, missions_js: str, pages: dict[str, str], exists=os.path.exists,
          nest_js: str | None = None, steps_js: str | None = None, install_text: str | None = None) -> list[str]:
    errs = []
    w = worlds(worlds_js)
    if not w:
        errs.append("worlds.js: no worlds parsed")
    for wid, d in w.items():
        if not d["read"]:
            errs.append(f"world {wid}: no read: Field guide page")
        elif not docs_target_exists(d["read"], exists):
            errs.append(f"world {wid}: read: {d['read']} has no docs page")
    classes = api_classes()
    ms = missions(missions_js)
    if not ms:
        errs.append("missions-data.js: no missions parsed")
    for m in ms:
        docs = [h for h in m["links"] if h.startswith("docs/")]
        if m["group"] == "Academy" and not docs:
            errs.append(f"mission {m['id']}: no docs link")
        for h in m["links"]:
            if h.startswith("docs/") and not docs_target_exists(h, exists):
                errs.append(f"mission {m['id']}: {h} has no docs page")
            am = re.match(r"api/class(?:anthocnet_1_1core_1_1)?(\w+)\.html$", h)
            if h.startswith("api/") and (not am or am.group(1) not in classes):
                errs.append(f"mission {m['id']}: {h} names no class in core/include")
    if nest_js is not None:
        nest = nest_classes(nest_js)
        for c in sorted(classes - set(nest)):
            errs.append(f"Nest: core class {c} has no chamber (web/site/js/nest-data.js)")
        for c in sorted(set(nest) - classes):
            errs.append(f"Nest: chamber names {c}, which core/include does not declare")
        for c in sorted({c for c in nest if nest.count(c) > 1}):
            errs.append(f"Nest: {c} is in more than one chamber")
    if steps_js is not None:
        for cmd in quest_cmds(steps_js):
            if cmd not in (install_text or ""):
                errs.append(f"install quest: '{cmd}' is not in the install docs ({', '.join(INSTALL_DOCS)})")
    for rel, md in pages.items():
        tries = front_matter_try(md)
        if rel in FAMILY_PAGES and not tries:
            errs.append(f"{rel}: no try: front matter (a family results page links its world)")
        for t in tries:
            if t not in w:
                errs.append(f"{rel}: try: world '{t}' is not a world id ({', '.join(sorted(w))})")
    return errs


def repo_inputs():
    pages = {}
    for d, _, names in os.walk(os.path.join(REPO, "docs")):
        for n in names:
            if n.endswith(".md"):
                rel = os.path.relpath(os.path.join(d, n), REPO).replace(os.sep, "/")
                pages[rel] = read(rel)
    return read("web/site/js/worlds.js"), read("web/site/js/missions-data.js"), pages


def extra_inputs() -> dict:
    return {"nest_js": read("web/site/js/nest-data.js"), "steps_js": read("web/site/js/install-steps.js"),
            "install_text": "\n".join(read(p) for p in INSTALL_DOCS)}


def self_test() -> int:
    """Every rule must fire on a broken input and stay quiet on the repo."""
    wjs, mjs, pages = repo_inputs()
    ex = extra_inputs()
    no_docs = mjs.replace(
        "links: [['How AntHocNet works', DOC + 'ant-colony-routing/'], ['AntRouterLogic::onMaintenanceTick', ARL]]",
        "links: [['AntRouterLogic::onMaintenanceTick', ARL]]", 1)
    no_try = dict(pages)
    no_try["docs/benchmarks/static-mesh.md"] = re.sub(r"^---\n.*?\n---\n", "", no_try["docs/benchmarks/static-mesh.md"], flags=re.DOTALL)
    bad_world = dict(pages)
    bad_world["docs/ant-types.md"] = bad_world["docs/ant-types.md"].replace("- world: line", "- world: atlantis", 1)
    cases = [
        ("the repo as committed", (wjs, mjs, pages), {}, False),
        ("a dangling world read:", (wjs.replace("GUIDE + 'ant-types/'", "GUIDE + 'no-such-page/'", 1), mjs, pages), {}, True),
        ("a world without read:", (re.sub(r"    read: \{[^}]*\},\n", "", wjs, count=1), mjs, pages), {}, True),
        ("an Academy mission without a docs link", (wjs, no_docs, pages), {}, True),
        ("a family page without try:", (wjs, mjs, no_try), {}, True),
        ("a try: world that does not exist", (wjs, mjs, bad_world), {}, True),
        ("an API link to a class that does not exist",
         (wjs, mjs.replace("PheromoneEngine.html", "PheromoneEngin.html", 1), pages), {}, True),
        ("a core class missing from the Nest", (wjs, mjs, pages), {"nest_js": ex["nest_js"].replace("'Config'", "", 1)}, True),
        ("a Nest chamber naming a class that does not exist", (wjs, mjs, pages),
         {"nest_js": ex["nest_js"].replace("'Config'", "'Konfig'", 1)}, True),
        ("an install-quest command not in the docs", (wjs, mjs, pages),
         {"steps_js": ex["steps_js"].replace("cmd: './test.py -s anthocnet'", "cmd: './test.py -s nothing'", 1)}, True),
    ]
    bad = 0
    for name, args, override, should_fire in cases:
        got = len(check(*args, **{**ex, **override}))
        ok = (got >= 1) if should_fire else (got == 0)
        print(f"{'ok  ' if ok else 'FAIL'} {name}: {got} finding(s)")
        bad += not ok
    print(f"{len(cases) - bad}/{len(cases)} cases passed")
    return 1 if bad else 0


def main() -> int:
    if "--self-test" in sys.argv:
        return self_test()
    errs = check(*repo_inputs(), **extra_inputs())
    w = worlds(read("web/site/js/worlds.js"))
    ms = missions(read("web/site/js/missions-data.js"))
    for e in errs:
        print(f"FAIL {e}")
    if errs:
        return 1
    print(f"ok: {len(w)} worlds and {len(ms)} missions link the docs; the {len(FAMILY_PAGES)} family "
          "pages link the game; every target exists; the Nest covers every core class; "
          "every install-quest command is in the docs")
    return 0


if __name__ == "__main__":
    sys.exit(main())
