#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Crawl the assembled Pages site and fail on anything a visitor would hit.

Runs on web/build-pages.sh's output, the exact tree pages.yml deploys:
  * every internal link and asset (href/src) resolves to a file in the site;
  * every #anchor to a docs or game page exists in the target page;
  * every page of the game, the docs and the API carries the one top bar
    (#627), with no template placeholder left over ({ROOT}, {ON:...});
  * no page has two elements with the same id (anchors and labels rely on it).

External links (http/https to other hosts) are not fetched: CI must not
depend on the network, and check-links.py already validates the markdown.
Stdlib only.

Usage:  python3 tools/checks/check-site.py <site-dir>
        python3 tools/checks/check-site.py --self-test
"""
from __future__ import annotations

import os
import shutil
import sys
import tempfile
from html.parser import HTMLParser
from urllib.parse import unquote, urlsplit

SITE_PREFIX = "/AntHocNet/"  # the Pages base path; root-absolute links use it


class Page(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.links: list[tuple[str, str]] = []  # (attr, value)
        self.ids: list[str] = []
        self.bar = False
        self.redirect = False

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if a.get("id"):
            self.ids.append(a["id"])
        if tag == "a" and a.get("name"):
            self.ids.append(a["name"])
        if "ahn-bar" in (a.get("class") or "").split():
            self.bar = True
        if tag == "meta" and (a.get("http-equiv") or "").lower() == "refresh":
            self.redirect = True
        for attr in ("href", "src"):
            v = a.get(attr)
            if v and not (tag == "link" and a.get("rel") in ("canonical", "alternate")):
                self.links.append((attr, v))


def parse(path: str) -> Page:
    p = Page()
    with open(path, encoding="utf-8", errors="replace") as f:
        text = f.read()
    p.feed(text)
    p.raw = text
    return p


def resolve(site: str, page_path: str, url: str) -> tuple[str | None, str]:
    """-> (filesystem path or None if external/ignored, fragment)."""
    parts = urlsplit(url)
    if parts.scheme in ("mailto", "javascript", "data", "tel"):
        return None, ""
    if parts.scheme or parts.netloc:
        if parts.netloc == "danieljoppi.github.io" and parts.path.startswith(SITE_PREFIX):
            target = os.path.join(site, parts.path[len(SITE_PREFIX):])
        else:
            return None, ""
    elif parts.path.startswith("/"):
        if not parts.path.startswith(SITE_PREFIX):
            return None, ""
        target = os.path.join(site, parts.path[len(SITE_PREFIX):])
    elif not parts.path:
        target = page_path
    else:
        target = os.path.join(os.path.dirname(page_path), unquote(parts.path))
    target = os.path.normpath(target)
    if os.path.isdir(target):
        target = os.path.join(target, "index.html")
    return target, parts.fragment


def check(site: str) -> list[str]:
    site = os.path.abspath(site)
    pages: dict[str, Page] = {}
    for d, _, names in os.walk(site):
        for n in names:
            if n.endswith(".html"):
                path = os.path.join(d, n)
                pages[path] = parse(path)
    errs = []
    for path, p in sorted(pages.items()):
        rel = os.path.relpath(path, site)
        surface = rel.split(os.sep)[0]
        is_api_search = rel.startswith(os.path.join("api", "search"))
        # docs/images/*.html are mockup sources rendered to PNGs, not pages.
        is_asset = rel.startswith(os.path.join("docs", "images") + os.sep)
        if not p.redirect and not is_api_search and not is_asset and rel != "404.html" and not p.bar:
            errs.append(f"{rel}: no top bar (#627)")
        if "{ROOT}" in p.raw or "{ON:" in p.raw:
            errs.append(f"{rel}: a top-bar placeholder was left in the page")
        dup = {i for i in p.ids if p.ids.count(i) > 1}
        if dup and surface != "api":  # Doxygen's own output repeats ids; not ours to fix
            errs.append(f"{rel}: duplicate ids {sorted(dup)[:5]}")
        for attr, url in p.links:
            target, frag = resolve(site, path, url)
            if target is None:
                continue
            if not target.startswith(site):
                errs.append(f"{rel}: {attr}={url} points outside the site")
                continue
            if not os.path.exists(target):
                errs.append(f"{rel}: {attr}={url} -> {os.path.relpath(target, site)} does not exist")
                continue
            # The game's front page routes on its hash (#play, #vanet?seed=1):
            # those are not element ids. Doxygen's anchors are its own.
            game_root = target == os.path.join(site, "index.html")
            if frag and target.endswith(".html") and target in pages and not game_root \
                    and not target.startswith(os.path.join(site, "api")):
                t = pages[target]
                if not t.redirect and unquote(frag) not in t.ids:
                    errs.append(f"{rel}: {url} -> no #{frag} in {os.path.relpath(target, site)}")
    return errs


def self_test() -> int:
    tmp = tempfile.mkdtemp()
    bar = '<header class="ahn-bar"></header>'
    try:
        def write(rel, html):
            path = os.path.join(tmp, rel)
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w") as f:
                f.write(html)
        write("index.html", f'<html><body>{bar}<a href="docs/">docs</a><a href="docs/#intro">x</a><img src="a.png"></body></html>')
        write("a.png", "")
        write("docs/index.html", f'<html><body>{bar}<h1 id="intro">Hi</h1><a href="../index.html">home</a>'
              '<a href="https://example.com/">ext</a><a href="/AntHocNet/docs/">abs</a></body></html>')
        cases = [("a well-formed site", lambda: None, 0)]

        def edit(rel, old, new):
            with open(os.path.join(tmp, rel)) as f:
                text = f.read()
            write(rel, text.replace(old, new))

        def broken_link():
            edit("docs/index.html", "../index.html", "../nope.html")

        def broken_anchor():
            edit("index.html", "docs/#intro", "docs/#missing")

        def no_bar():
            write("docs/more.html", "<html><body><p>no bar</p></body></html>")

        def placeholder():
            write("docs/ph.html", f"<html><body>{bar}<a href='{{ROOT}}docs/'>x</a></body></html>")

        def missing_asset():
            os.remove(os.path.join(tmp, "a.png"))

        cases += [("a broken link", broken_link, 1), ("a broken anchor", broken_anchor, 1),
                  ("a page without the bar", no_bar, 1), ("a leftover placeholder", placeholder, 1),
                  ("a missing image", missing_asset, 1)]
        bad = 0
        seen = 0
        for name, mutate, want in cases:
            mutate()
            got = len(check(tmp))
            # each mutation adds to the previous ones: findings must keep growing
            ok = got == 0 if want == 0 else got > seen
            seen = got
            print(f"{'ok  ' if ok else 'FAIL'} {name}: {got} finding(s) in total")
            bad += not ok
        print(f"{len(cases) - bad}/{len(cases)} cases passed")
        return 1 if bad else 0
    finally:
        shutil.rmtree(tmp)


def main() -> int:
    if len(sys.argv) == 2 and sys.argv[1] == "--self-test":
        return self_test()
    if len(sys.argv) != 2 or not os.path.isdir(sys.argv[1]):
        sys.exit("usage: check-site.py <site-dir> | --self-test")
    errs = check(sys.argv[1])
    for e in errs[:200]:
        print(f"FAIL {e}")
    if len(errs) > 200:
        print(f"... and {len(errs) - 200} more")
    n = sum(1 for _, _, ns in os.walk(sys.argv[1]) for x in ns if x.endswith(".html"))
    if errs:
        print(f"site check: FAIL ({len(errs)} problem(s) in {n} pages)")
        return 1
    print(f"site check: ok — {n} pages, every internal link, asset and anchor resolves, the top bar is on every page")
    return 0


if __name__ == "__main__":
    sys.exit(main())
