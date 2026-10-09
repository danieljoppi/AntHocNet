# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Doxygen XML -> api-index.json for the Workshop's Nest (#635).

For every class/struct in namespace anthocnet::core: its brief, the HTML page
Doxygen wrote for it, and its public members with their briefs. The Nest reads
this to show a chamber's API without loading Doxygen's pages.

Usage: python3 web/shell/api_index.py <doxygen-xml-dir> <out.json>
"""
from __future__ import annotations

import json
import os
import sys
import xml.etree.ElementTree as ET


def text(el) -> str:
    return " ".join("".join(el.itertext()).split()) if el is not None else ""


def build(xml_dir: str) -> dict:
    classes = {}
    for name in sorted(os.listdir(xml_dir)):
        if not (name.startswith(("class", "struct")) and name.endswith(".xml")):
            continue
        root = ET.parse(os.path.join(xml_dir, name)).getroot()
        for cd in root.iter("compounddef"):
            full = cd.findtext("compoundname") or ""
            if not full.startswith("anthocnet::core::") or full.count("::") != 2:
                continue
            short = full.split("::")[-1]
            members = []
            for sec in cd.iter("sectiondef"):
                if not sec.get("kind", "").startswith("public"):
                    continue
                for m in sec.iter("memberdef"):
                    members.append({
                        "name": m.findtext("name"),
                        "kind": m.get("kind"),
                        "sig": " ".join(x for x in (m.findtext("type"), m.findtext("name"), m.findtext("argsstring")) if x).strip(),
                        "brief": text(m.find("briefdescription")),
                    })
            classes[short] = {
                "kind": cd.get("kind"),
                "brief": text(cd.find("briefdescription")),
                "url": cd.get("id") + ".html",
                "header": (cd.find("location").get("file") if cd.find("location") is not None else ""),
                "members": members,
            }
    return {"classes": classes}


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: api_index.py <doxygen-xml-dir> <out.json>")
    data = build(sys.argv[1])
    with open(sys.argv[2], "w", encoding="utf-8") as f:
        json.dump(data, f, separators=(",", ":"), sort_keys=True)
    print(f"api_index.py: {len(data['classes'])} core classes")
