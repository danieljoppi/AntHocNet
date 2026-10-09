# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Put the site's one top bar on every surface (#626/#627).

The game, the docs (mkdocs) and the API reference (Doxygen) are three builds.
They share one bar: web/shell/topbar.html, rendered here with the page's path
to the site root and its active place, plus web/shell/shell.{css,js}. Each
surface carries its own copy of the assets, so the docs and the API also work
when built and served on their own.

Used three ways:
  * game:  python3 web/shell/inject.py game <site-dir>     (build-site.sh)
  * api:   python3 web/shell/inject.py api  <api-html-dir>  (pages.yml)
  * docs:  imported by docs/tools/mkdocs_hooks.py (on_post_page / on_post_build)
"""
from __future__ import annotations

import html as _html
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PLACES = ("play", "guide", "lab", "shop", "arch")
MARKER = re.compile(r"<!--AHN-TOPBAR(?: (\w+))?-->")


def topbar(root: str, active: str | None) -> str:
    """The bar's markup for a page whose path to the site root is `root`."""
    with open(os.path.join(HERE, "topbar.html"), encoding="utf-8") as f:
        html = f.read()
    html = re.sub(r"<!--.*?-->\s*", "", html, count=1, flags=re.DOTALL)  # header comment
    for p in PLACES:
        html = html.replace(f"{{ON:{p}}}", ' aria-current="page"' if p == active else "")
    return html.replace("{ROOT}", root).strip()


def breadcrumb(items: list[tuple[str, str | None]], place: str | None = None) -> str:
    """The trail from the site root to this page (#652): `items` are (label,
    href) pairs, the last one the current page; an href of None is a level with
    no page of its own. The place's colour comes from `data-place`."""
    lis = []
    for i, (label, href) in enumerate(items):
        text = _html.escape(label)
        if i == len(items) - 1:
            lis.append(f'<li><span aria-current="page">{text}</span></li>')
        elif href:
            lis.append(f'<li><a href="{_html.escape(href)}">{text}</a></li>')
        else:
            lis.append(f"<li><span>{text}</span></li>")
    return (f'<nav class="ahn-crumb" aria-label="Breadcrumb" data-place="{place or ""}">'
            f'<ol>{"".join(lis)}</ol></nav>')


def copy_assets(dest: str, extra: tuple[str, ...] = ()) -> None:
    os.makedirs(dest, exist_ok=True)
    for name in ("shell.css", "shell.js") + extra:
        shutil.copyfile(os.path.join(HERE, name), os.path.join(dest, name))


def inject_page(html: str, root: str, active: str | None, assets: str,
                css: tuple[str, ...] = ("shell.css",), script: str | None = None) -> str:
    """Add the stylesheet(s) to <head>, the bar after <body>, and the shell
    script before </body>. `assets` is the page's relative path to the copied
    shell assets. Idempotent: a page that already has the bar is returned as is."""
    if 'class="ahn-bar"' in html:
        return html
    links = "".join(f'<link rel="stylesheet" href="{assets}{c}">' for c in css)
    html = html.replace("</head>", links + "</head>", 1)
    m = MARKER.search(html)
    if m:
        html = html[:m.start()] + topbar(root, m.group(1) or active) + html[m.end():]
    else:
        bar = topbar(root, active)
        html = re.sub(r"(<body[^>]*>)", lambda mm: mm.group(1) + bar, html, count=1)
    if script:
        html = html.replace("</body>", script + "</body>", 1)
    return html


def boot_script(assets: str) -> str:
    if not assets.startswith((".", "/")):
        assets = "./" + assets  # a bare specifier is not a relative module URL
    return f'<script type="module">import {{ initPage }} from "{assets}shell.js"; initPage();</script>'


# --- game --------------------------------------------------------------------
def game(site: str) -> None:
    """Every page in the game's root carries the marker (optionally naming its
    place, `<!--AHN-TOPBAR shop-->`). The pages' own scripts own the theme
    button and search wiring (app.js: the in-game reader), so no boot script."""
    pages = sorted(n for n in os.listdir(site) if n.endswith(".html") and n != "404.html")
    for name in pages:
        path = os.path.join(site, name)
        with open(path, encoding="utf-8") as f:
            html = f.read()
        if not MARKER.search(html):
            sys.exit(f"inject.py: {path} has no <!--AHN-TOPBAR--> marker")
        with open(path, "w", encoding="utf-8") as f:
            f.write(inject_page(html, "./", None, "shell/"))
    copy_assets(os.path.join(site, "shell"))


# --- API reference -------------------------------------------------------------
def api(apidir: str) -> None:
    """Doxygen writes a flat html/ directory (plus search/); the API lives at
    <site>/api/, so the site root is one level up from a top-level page."""
    copy_assets(os.path.join(apidir, "ahn"), ("api.css",))
    n = 0
    for dirpath, _, names in os.walk(apidir):
        rel = os.path.relpath(dirpath, apidir)
        if rel.startswith(("ahn", "search")):
            continue
        depth = 0 if rel == "." else rel.count(os.sep) + 1
        up = "../" * depth
        for name in names:
            if not name.endswith(".html"):
                continue
            p = os.path.join(dirpath, name)
            with open(p, encoding="utf-8", errors="replace") as f:
                html = f.read()
            out = inject_page(html, up + "../", "shop", up + "ahn/",
                              css=("shell.css", "api.css"), script=boot_script(up + "ahn/"))
            out = _api_crumb(out, name, up)
            if out != html:
                with open(p, "w", encoding="utf-8") as f:
                    f.write(out)
                n += 1
    print(f"inject.py: top bar on {n} API pages")


def _api_crumb(html: str, name: str, up: str) -> str:
    """AntHocNet › Workshop › API reference › <page>, above Doxygen's own header."""
    if 'class="ahn-crumb"' in html or '<div id="top">' not in html:
        return html
    m = re.search(r"<title>(?:AntHocNet: )?([^<]*)</title>", html)
    title = _html.unescape(m.group(1).strip()) if m else name
    root = up + "../"
    items = [("AntHocNet", root), ("Workshop", root + "docs/places/workshop/")]
    items += [("API reference", None if name == "index.html" else up + "index.html")]
    if name != "index.html":
        items.append((title, None))
    return html.replace('<div id="top">', breadcrumb(items, "shop") + '<div id="top">', 1)


# --- docs (called from the mkdocs hook) ----------------------------------------
SECTION_PLACE = {"Field guide": "guide", "Lab": "lab", "Workshop": "shop", "Archive": "arch"}


def docs_page(html: str, page_url: str, section: str | None) -> str:
    depth = page_url.strip("/").count("/") + 1 if page_url.strip("/") else 0
    to_docs = "../" * depth
    return inject_page(html, to_docs + "../", SECTION_PLACE.get(section or ""),
                       to_docs + "assets/ahn/", css=("shell.css", "docs.css"),
                       script=boot_script(to_docs + "assets/ahn/"))


def docs_assets(site_dir: str) -> None:
    copy_assets(os.path.join(site_dir, "assets", "ahn"), ("docs.css",))


if __name__ == "__main__":
    if len(sys.argv) != 3 or sys.argv[1] not in ("game", "api"):
        sys.exit("usage: inject.py game <site-dir> | inject.py api <api-html-dir>")
    {"game": game, "api": api}[sys.argv[1]](sys.argv[2])
