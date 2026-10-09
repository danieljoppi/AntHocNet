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

from mkdocs.utils import get_relative_url

_sys.path.insert(0, os.path.join(_REPO_ROOT, "web", "shell"))
import inject as _shell


def _section(page) -> str | None:
    """The page's top-level nav section, which is its place."""
    anc = list(getattr(page, "ancestors", []) or [])
    return anc[-1].title if anc else None


def _to_site_root(page) -> str:
    url = page.url.strip("/")
    return "../" * (url.count("/") + 1 if url else 0) + "../"


def _overview(section):
    """A nav section's own page: its first child when that is titled Overview."""
    first = (section.children or [None])[0]
    return first if getattr(first, "is_page", False) and first.title == "Overview" else None


def _trail(page) -> list[tuple[str, str | None]]:
    """AntHocNet › place › sections › page, each level linked to its overview
    page when it has one. A section's overview page ends the trail at the
    section itself (Lab, not Lab › Overview)."""
    items = [("AntHocNet", _to_site_root(page))]
    for sec in reversed(list(getattr(page, "ancestors", []) or [])):
        ov = _overview(sec)
        items.append((sec.title, ov and get_relative_url(ov.url, page.url)))
        if ov is page:
            return items
    items.append((page.title or "", None))
    return items


def on_page_content(html: str, page, config, files) -> str:
    section = _section(page)
    place = _shell.SECTION_PLACE.get(section or "")
    bar = (f'<div class="ahn-titlebar" data-place="{place or ""}"><span class="ahn-dots" aria-hidden="true">'
           f"<i></i><i></i><i></i></span>{_shell.breadcrumb(_trail(page), place)}</div>")
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
    # The 404 page is rendered outside on_post_page and served at any depth,
    # so its bar uses the site's absolute paths.
    p404 = os.path.join(config["site_dir"], "404.html")
    if os.path.exists(p404):
        with open(p404, encoding="utf-8") as f:
            html = f.read()
        with open(p404, "w", encoding="utf-8") as f:
            f.write(_shell.inject_page(html, "/AntHocNet/", None, "/AntHocNet/docs/assets/ahn/",
                                       css=("shell.css", "docs.css"),
                                       script=_shell.boot_script("/AntHocNet/docs/assets/ahn/")))


# --- release notes (one page per release) ------------------------------------
# CHANGELOG.md is the record (release.yml's `cz bump --changelog` writes it on
# every release); the site renders it as one page per release under
# docs/releases/, generated at build time so it can never drift from the file.
# A release lands on the site when release.yml finishes (pages.yml redeploys).
from mkdocs.structure.files import File as _File

_REPO = "https://github.com/danieljoppi/AntHocNet"
_RELEASE = re.compile(r"^## (v\d+\.\d+\.\d+\S*) \((\d{4}-\d{2}-\d{2})\)[ \t]*$", re.MULTILINE)
_KINDS = {"BREAKING CHANGE": "Breaking changes", "Feat": "Features", "Fix": "Fixes",
          "Refactor": "Refactoring", "Perf": "Performance"}
_COUNT = {"BREAKING CHANGE": ("breaking change", "breaking changes"), "Feat": ("feature", "features"),
          "Fix": ("fix", "fixes")}
_ISSUE = re.compile(r"(?<![\w/&`])#(\d+)\b")


def _releases() -> list[tuple[str, str, str]]:
    """(tag, date, body) per CHANGELOG.md release, newest first."""
    with open(os.path.join(_REPO_ROOT, "CHANGELOG.md"), encoding="utf-8") as f:
        text = f.read()
    parts = _RELEASE.split(text)
    return [(parts[i], parts[i + 1], parts[i + 2].strip()) for i in range(1, len(parts), 3)]


def _notes_body(body: str) -> str:
    out = []
    for line in body.splitlines():
        if line.startswith("### "):
            kind = line[4:].strip()
            line = "## " + _KINDS.get(kind, kind)
        elif line.startswith("- "):
            line = _ISSUE.sub(lambda m: f"[#{m.group(1)}]({_REPO}/issues/{m.group(1)})", line)
        out.append(line)
    return "\n".join(out)


def _release_page(tag: str, date: str, body: str, prev: str | None) -> str:
    links = [f"Released {date}", f"[GitHub release and downloads]({_REPO}/releases/tag/{tag})"]
    if prev:
        links.append(f"[every commit since {prev}]({_REPO}/compare/{prev}...{tag})")
    notes = _notes_body(body) if body else ("The first tagged release, cut from the tree as it stood (no changelog entries yet);\n"
                                      "its notes are on the GitHub release.")
    return f"# {tag}\n\n{' · '.join(links)}\n\n{notes}\n"


def _releases_index(rels) -> str:
    rows = []
    for tag, date, body in rels:
        heads = [h[4:].strip() for h in body.splitlines() if h.startswith("### ")]
        count = {h: 0 for h in heads}
        kind = None
        for line in body.splitlines():
            if line.startswith("### "):
                kind = line[4:].strip()
            elif line.startswith("- ") and kind:
                count[kind] += 1
        what = ", ".join(f"{n} {_COUNT.get(k, (k.lower(),) * 2)[n != 1]}" for k, n in count.items()) or "baseline"
        rows.append(f"| [{tag}]({tag}.md) | {date} | {what} |")
    return ("# Releases\n\n"
            "Every AntHocNet release, newest first. Each page is that release's entry in\n"
            f"[CHANGELOG.md]({_BLOB}CHANGELOG.md), rendered when the site is built; the\n"
            f"downloads, checksums and the full pull-request list are on its [GitHub release]({_REPO}/releases).\n"
            "The software version is distinct from the on-wire protocol version, see\n"
            "[wire-format.md](../wire-format.md).\n\n"
            "| Release | Date | What changed |\n|---|---|---|\n" + "\n".join(rows) + "\n")


def on_config(config):
    rels = _releases()
    section = {"Releases": [{"Overview": "releases/index.md"}] + [f"releases/{t}.md" for t, _, _ in rels]}
    for entry in config["nav"] or []:
        if isinstance(entry, dict) and "Archive" in entry:
            items = entry["Archive"]
            at = next((i + 1 for i, it in enumerate(items) if it == "roadmap.md"), len(items))
            items.insert(at, section)
    return config


def on_files(files, config):
    rels = _releases()
    files.append(_File.generated(config, "releases/index.md", content=_releases_index(rels)))
    for i, (tag, date, body) in enumerate(rels):
        prev = rels[i + 1][0] if i + 1 < len(rels) else None
        files.append(_File.generated(config, f"releases/{tag}.md", content=_release_page(tag, date, body, prev)))
    return files
