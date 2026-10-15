#!/usr/bin/env python3
"""Translation gate for the learn site (#622).

1. Every key in web/site/i18n/en.json exists in every other language file,
   and no other language has a key en.json lacks (a removed string).
2. Placeholders match: a {var} in the English string appears in each
   translation, and no translation invents one.
3. No user-visible English literal is left in web/site/js: a string literal
   with two or more words is text, and text lives in en.json. A literal that
   is not text (a CSS selector, a log format the core defines) carries a
   trailing `// i18n-ok` comment on its line.
4. index.html has no text node outside an element marked data-i18n /
   data-i18n-html.

Exit 1 on any finding. Usage: python3 web/tools/i18n-check.py
"""

import json
import re
import sys
from html.parser import HTMLParser
from pathlib import Path

SITE = Path(__file__).resolve().parent.parent / "site"
I18N = SITE / "i18n"
VAR = re.compile(r"\{(\w+)\}")
# String literals: '...', "...", `...` (no nesting; templates' ${} kept as text).
LIT = re.compile(r"""'((?:[^'\\\n]|\\.)*)'|"((?:[^"\\\n]|\\.)*)"|`((?:[^`\\]|\\.)*)`""")
# A CSS selector ("#missionBody .missions button") is code, not text.
SELECTOR_TOKEN = re.compile(r"[#.]?[\w-]+(?:[.#:\[][^\s]*)?|[>+~,]")

# A canvas font ("700 12px system-ui, sans-serif") and a class list
# (className = 'muted small', class="bevel x") and a shell command (cmd:) are
# code too.
FONT = re.compile(r"\dpx |px system-ui|sans-serif")
CLASS_CTX = re.compile(
    r"(?:className\s*[=:]|\bclass\s*[:=]|classList\.\w+\(|\bcmd\s*:)\s*$"
)


def is_selector(s):
    tokens = s.split()
    return all(SELECTOR_TOKEN.fullmatch(x) for x in tokens) and any(
        x[0] in "#." for x in tokens
    )


WORDS = re.compile(r"[A-Za-z][a-z]+(?:'[a-z]+)?\s+[A-Za-z][a-z]+")
problems = []


def flatten(d, prefix=""):
    out = {}
    for k, v in d.items():
        key = f"{prefix}{k}"
        if isinstance(v, dict):
            out.update(flatten(v, key + "."))
        else:
            out[key] = v
    return out


def check_keys():
    en = flatten(json.loads((I18N / "en.json").read_text(encoding="utf-8")))
    for f in sorted(I18N.glob("*.json")):
        if f.name == "en.json":
            continue
        other = flatten(json.loads(f.read_text(encoding="utf-8")))
        for k in sorted(en.keys() - other.keys()):
            problems.append(f"{f.name}: missing key {k}")
        for k in sorted(other.keys() - en.keys()):
            problems.append(f"{f.name}: key {k} is not in en.json")
        for k in sorted(en.keys() & other.keys()):
            if set(VAR.findall(str(en[k]))) != set(VAR.findall(str(other[k]))):
                problems.append(f"{f.name}: {k} placeholders differ from en.json")
    return en


def strip_comments(src):
    # Drop // line comments and /* */ blocks, keeping line numbers.
    src = re.sub(r"/\*.*?\*/", lambda m: "\n" * m.group(0).count("\n"), src, flags=re.S)
    return src


def check_js():
    for f in sorted((SITE / "js").rglob("*.js")):
        lines = strip_comments(f.read_text(encoding="utf-8")).split("\n")
        for n, line in enumerate(lines, 1):
            if "i18n-ok" in line:
                continue
            code = re.sub(r"(^|[^:'\"`])//.*$", r"\1", line)
            for m in LIT.finditer(code):
                s = next(g for g in m.groups() if g is not None)
                s = re.sub(r"\$\{(?:[^{}]|\{[^{}]*\})*\}", " ", s)  # ${...} is code
                s = re.sub(r"<[^>]*>?", " ", s)  # markup is not text
                if (
                    not WORDS.search(s)
                    or is_selector(s)
                    or FONT.search(s)
                    or CLASS_CTX.search(code[: m.start()])
                ):
                    continue
                problems.append(
                    f"{f.relative_to(SITE)}:{n}: English literal {s[:60]!r}"
                )


class Html(HTMLParser):
    def __init__(self):
        super().__init__()
        self.stack = []
        self.found = []

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag in ("meta", "link", "input", "br", "img", "kbd"):
            return
        marked = "data-i18n" in a or "data-i18n-html" in a
        self.stack.append(
            (
                tag,
                marked
                or (self.stack and self.stack[-1][1])
                or tag in ("script", "style", "svg", "kbd", "code", "noscript"),
            )
        )

    def handle_endtag(self, tag):
        while self.stack:
            t, _ = self.stack.pop()
            if t == tag:
                break

    def handle_data(self, data):
        if self.stack and not self.stack[-1][1] and re.search(r"[A-Za-z]{2,}", data):
            self.found.append((self.getpos()[0], data.strip()[:60]))


def check_html():
    for name in ("index.html", "workshop.html"):
        p = Html()
        p.feed((SITE / name).read_text(encoding="utf-8"))
        for line, text in p.found:
            problems.append(f"{name}:{line}: text outside data-i18n {text!r}")


check_keys()
check_js()
check_html()
for p in problems:
    print(p)
print(f"i18n-check: {'FAIL' if problems else 'OK'} ({len(problems)} finding(s))")
sys.exit(1 if problems else 0)
