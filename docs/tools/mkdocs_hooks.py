# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""mkdocs hook: render repo-tree links as GitHub URLs (#331).

The site's ``docs_dir`` is ``docs/``, so a relative link that escapes it —
``../AGENTS.md``, ``../CONTRIBUTING.md``, ``../core/include/...``,
``../ns3/tools/run-scenarios.py`` — has no target inside the built site.

Those links must keep working when the same file is read in the repo tree (the
tree is canonical, the site only renders it), so the sources are never
rewritten. Instead the escaping targets are rewritten *at render time* into
``https://github.com/danieljoppi/AntHocNet/blob|tree/main/<path>`` URLs: the
site's copy sends the reader to the file on GitHub, the repo's copy keeps its
relative link. Links that stay inside ``docs/`` are left untouched for mkdocs
to resolve. See the decision note in ``mkdocs.yml``.
"""

from __future__ import annotations

import os
import posixpath
import re

_REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
_BLOB = "https://github.com/danieljoppi/AntHocNet/blob/main/"
_TREE = "https://github.com/danieljoppi/AntHocNet/tree/main/"

# Inline markdown link/image; the target runs up to whitespace (an optional
# title) or the closing paren. Reference-style links and links inside code
# fences do not occur in docs/ (checked when this hook was added).
_LINK = re.compile(r"(!?\[[^\]]*\]\()([^)\s]+)")


def _rewrite(target: str, page_dir: str) -> str:
    if "://" in target or target.startswith(("#", "/", "mailto:")):
        return target
    path, _, anchor = target.partition("#")
    if not path:
        return target
    rel = posixpath.normpath(posixpath.join("docs", page_dir, path))
    suffix = f"#{anchor}" if anchor else ""
    if rel == "docs" or rel.startswith("docs/"):
        # Inside docs_dir: mkdocs resolves pages and copied assets itself. The
        # exception is a link to a *directory* (`adr`, `benchmarks/`, `../`,
        # `../campaign/`) — a listing on GitHub, but mkdocs leaves it as-is and
        # the site's directory URLs then resolve it against the page's own
        # directory, i.e. a 404. Point it at the directory's index page if it
        # has one (mkdocs rewrites that correctly), otherwise at GitHub.
        abs_rel = os.path.join(_REPO_ROOT, rel)
        if os.path.isdir(abs_rel):
            for index in ("README.md", "index.md"):
                if os.path.exists(os.path.join(abs_rel, index)):
                    return posixpath.join(path, index) + suffix
            return _TREE + rel + suffix
        return target
    if rel == ".":
        return _TREE + suffix
    base = _TREE if os.path.isdir(os.path.join(_REPO_ROOT, rel)) else _BLOB
    return base + rel + suffix


def on_page_markdown(markdown: str, page, config, files) -> str:
    page_dir = posixpath.dirname(page.file.src_uri)
    return _LINK.sub(lambda m: m.group(1) + _rewrite(m.group(2), page_dir), markdown)


# --- the site shell (#626/#627/#629) ----------------------------------------
# Every docs page is a game window under the site's one top bar. The bar and
# its assets come from web/shell/ (one source for the game, the docs and the
# API); this hook adds them to the rendered pages, so the markdown stays
# plain markdown that reads the same in the repo tree.
import html as _html
import sys as _sys

_sys.path.insert(0, os.path.join(_REPO_ROOT, "web", "shell"))
import inject as _shell


def _section(page) -> str | None:
    """The page's top-level nav section, which is its place."""
    anc = list(getattr(page, "ancestors", []) or [])
    return anc[-1].title if anc else None


def _to_site_root(page) -> str:
    url = page.url.strip("/")
    return "../" * (url.count("/") + 1 if url else 0) + "../"


def on_page_content(html: str, page, config, files) -> str:
    section = _section(page)
    place = _shell.SECTION_PLACE.get(section or "")
    crumb = f"<b>{_html.escape(section)}</b> › " if section else ""
    bar = (f'<div class="ahn-titlebar" data-place="{place or ""}"><span class="ahn-dots" aria-hidden="true">'
           f'<i></i><i></i><i></i></span><span class="ahn-crumb">{crumb}{_html.escape(page.title or "")}'
           "</span></div>")
    tries = page.meta.get("try") or []
    rail = ""
    if tries:
        root = _to_site_root(page)
        cards = []
        for t in tries:
            target = t.get("mission") and f"#mission={t['mission']}" or f"#{t['world']}?seed={t.get('seed', 1)}"
            cards.append(f'<a href="{root}{target}"><span class="ahn-go" aria-hidden="true">▶</span>'
                         f'<b>Try it</b><span>{_html.escape(t["title"])}</span></a>')
        rail = '<nav class="ahn-try" aria-label="Try it in the game">' + "".join(cards) + "</nav>"
    return bar + rail + html


def on_post_page(output: str, page, config) -> str:
    return _shell.docs_page(output, page.url, _section(page))


def on_post_build(config) -> None:
    _shell.docs_assets(config["site_dir"])
