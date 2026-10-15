#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
"""Offline shell and download budget for the assembled game (#624).

    python3 web/site-manifest.py <site-out>

Lists the game shell (the two game pages, their scripts, styles and icon, the
top bar's assets, the versioned WASM core), writes that list and a build id
into <site-out>/sw.js, writes <site-out>/size-report.json, and exits non-zero
when the shell exceeds web/size-budget.json. web/build-site.sh runs it last.
"""
import gzip
import hashlib
import json
import os
import re
import sys
from pathlib import Path

HERE = os.path.dirname(os.path.abspath(__file__))
SHELL_DIRS = ("js", "css", "img", "shell")
SHELL_FILES = ("index.html", "workshop.html", "manifest.webmanifest", "anthocnet.js", "anthocnet.wasm")


def main(out: str) -> int:
    files = [f for f in SHELL_FILES if os.path.isfile(os.path.join(out, f))]
    for d in SHELL_DIRS:
        for root, _, names in os.walk(os.path.join(out, d)):
            files += [os.path.relpath(os.path.join(root, n), out) for n in sorted(names)]
    files = sorted(set(files))

    # The core is fetched under its cache-busting URL (web/build-site.sh).
    engine = Path(out, "js", "engine.js").read_text(encoding="utf-8")
    m = re.search(r"anthocnet\.js\?v=([0-9a-f]+)", engine)
    if not m:
        sys.exit("site-manifest: js/engine.js has no versioned anthocnet.js import")
    v = m.group(1)
    urls = [f"{f}?v={v}" if f in ("anthocnet.js", "anthocnet.wasm") else f for f in files]

    h = hashlib.sha256()
    raw = gz = 0
    rows = []
    for f in files:
        data = Path(out, f).read_bytes()
        h.update(f.encode() + b"\0" + data)
        z = len(gzip.compress(data, 9, mtime=0))
        raw += len(data)
        gz += z
        rows.append({"file": f, "bytes": len(data), "gzip": z})
    build = h.hexdigest()[:12]

    sw_path = os.path.join(out, "sw.js")
    sw = Path(sw_path).read_text(encoding="utf-8")
    if "__AHN_BUILD__" not in sw or "__AHN_SHELL__" not in sw:
        sys.exit("site-manifest: sw.js placeholders missing")
    sw = sw.replace("'__AHN_BUILD__'", json.dumps(build)).replace("__AHN_SHELL__", json.dumps(urls))
    Path(sw_path).write_text(sw, encoding="utf-8")

    budget = json.loads(Path(HERE, "size-budget.json").read_text())
    report = {"build": build, "files": len(files), "raw_bytes": raw, "gzip_bytes": gz,
              "budget_raw_kb": budget["raw_kb"], "budget_gzip_kb": budget["gzip_kb"],
              "largest": sorted(rows, key=lambda r: -r["bytes"])[:8]}
    Path(out, "size-report.json").write_text(json.dumps(report, indent=1))
    print(f"game shell: {len(files)} files, {raw / 1024:.0f} KB raw / {gz / 1024:.0f} KB gzipped "
          f"(budget {budget['raw_kb']} / {budget['gzip_kb']} KB), offline build {build}")
    over = [f"raw {raw / 1024:.0f} KB > {budget['raw_kb']} KB"] if raw > budget["raw_kb"] * 1024 else []
    over += [f"gzip {gz / 1024:.0f} KB > {budget['gzip_kb']} KB"] if gz > budget["gzip_kb"] * 1024 else []
    if over:
        print("site-manifest: the game shell is over its download budget: " + "; ".join(over), file=sys.stderr)
        for r in report["largest"]:
            print(f"  {r['bytes'] / 1024:7.1f} KB  {r['gzip'] / 1024:6.1f} KB gz  {r['file']}", file=sys.stderr)
        print("Shrink it, or raise web/size-budget.json in a commit that says why.", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
