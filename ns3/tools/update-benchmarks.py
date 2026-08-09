#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""
update-benchmarks.py CSV_FILE DOC_FILE

Read a benchmark CSV and refresh the *generated* blocks of the benchmark docs.
Every generated block lives between the markers:

    <!-- BENCHMARK-TABLE-START -->
    ... generated table ...
    <!-- BENCHMARK-TABLE-END -->

so hand-written prose above and below a block survives regeneration.

DOC_FILE is the benchmark index (docs/benchmarks.md). The per-scenario and
per-sweep pages live in the sibling folder named after it — DOC_FILE minus the
".md" suffix, i.e. docs/benchmarks/ — so the CLI stays the one
`.github/workflows/benchmarks.yml` already calls:

    docs/benchmarks.md          <- compact cross-scenario SUMMARY table
    docs/benchmarks/scenarios/<scenario>.md   <- one page per discrete scenario
    docs/benchmarks/sweeps/<sweep>.md         <- one page per parameter sweep

A scenario (or sweep) that appears in the CSV without a page yet gets a stub
written for it — title, class, configuration, caveat and an empty marker block
— so a new scenario self-registers and only its prose needs writing by hand.

Used by the benchmark CI pipeline to keep the docs current, and runnable by
hand. Deterministic: if a block is unchanged, its file is not rewritten (so CI
does not create empty commits), and running twice is a no-op.

Where a CSV carries *_sd and runs columns, the PDR / delay / 99th-delay / NRL
cells render as "mean ± hw" with hw the 95% CI half-width (t-distribution,
n-1 df) per the statistical policy (#293, docs/benchmarks/methodology.md).

Provenance (#365). Pass --commit SHA (and optionally --run-url URL) and every
generated block states the commit its numbers were measured at. CI always
passes it; a hand-run that omits it emits no stamp at all rather than a
placeholder, because a wrong commit is worse than a missing one.
"""
import argparse
import csv
import importlib.util
import os

START = "<!-- BENCHMARK-TABLE-START -->"
END = "<!-- BENCHMARK-TABLE-END -->"

# Provenance stamp for the generated blocks (#365), set once from the CLI in
# main(). A module global rather than a parameter threaded through all four
# build_* functions: this is a single-shot CLI, and the stamp is one immutable
# fact about the whole invocation, not a per-block input.
_PROVENANCE = ""


def _load_stats_util():
    """Load the skill-side stats module (single source for the CI math)."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..",
                        ".claude", "skills", "benchmark-results", "stats_util.py")
    spec = importlib.util.spec_from_file_location("stats_util", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


su = _load_stats_util()


_TABLE_HEAD = [
    ("| protocol | PDR % ±95 | mean delay (ms) ±95 | 99th delay (ms) ±95 "
     "| throughput (kbps) | NRL ±95 | jitter (ms) | dOff90 (ms) |"),
    ("|----------|----------:|--------------------:|--------------------:"
     "|------------------:|--------:|------------:|------------:|"),
]

# Mirrored from docs/fidelity.md so the standing caveat is visible wherever
# results are presented, not only on the fidelity page. Keep this in step with
# fidelity.md — a stale caveat is worse than none, because it tells the reader
# the numbers are older than they are.
_CAVEAT = (
    "> **Caveat — `large-scale` and `heavy-load` currently reflect an open\n"
    "> defect.** [#173](https://github.com/danieljoppi/AntHocNet/issues/173)\n"
    "> (P1, open): with `enableMultipath` on, reactive forward ants are bounded\n"
    "> neither by a broadcast budget nor by `(src,seq)` duplicate suppression, so\n"
    "> route discovery floods combinatorially in dense graphs. Read those two rows\n"
    "> as a bug report, not as protocol character. See\n"
    "> [docs/fidelity.md](../../fidelity.md).\n"
)


def _off(v):
    # #57 offered-load percentile: -1 encodes infinity (less than the offered
    # fraction ever delivered).
    return "inf" if v not in (None, "", "-") and float(v) < 0 else (v or "-")


def _pm(r, value, sd_key, prec=1):
    """"mean ± hw" cell (95% t-CI, #293), or the bare value without sd/runs."""
    if value in (None, "", "-"):
        return "-"
    try:
        sd, runs = float(r.get(sd_key, "")), int(float(r.get("runs", "")))
    except (TypeError, ValueError):
        return str(value)
    if runs < 2:
        return str(value)
    return f"{value} ± {su.t_halfwidth(sd, runs):.{prec}f}"


def _row(r):
    # Columns after delay_ms are newer; tolerate older CSVs without them.
    # jitter_ms / delay_off90_ms are the #57 paper-parity QoS metrics.
    return (f"| {r['protocol']} | {_pm(r, r['pdr_pct'], 'pdr_sd')} | "
            f"{_pm(r, r['delay_ms'], 'delay_sd')} | "
            f"{_pm(r, r.get('delay99_ms', '-'), 'delay99_sd')} | "
            f"{r['throughput_kbps']} | "
            f"{_pm(r, r.get('nrl', '-'), 'nrl_sd', prec=2)} | "
            f"{r.get('jitter_ms', '-')} | "
            f"{_off(r.get('delay_off90_ms'))} |")


def _set_provenance(commit, run_url):
    """Render the per-block provenance sentence once (#365).

    Empty when no commit was supplied: a block with no stamp says "whoever
    regenerated this did not record where from", which a reader can act on. A
    fabricated stamp ("local", "unknown", HEAD of a possibly-dirty tree) reads
    as provenance and is not, which is the failure this whole issue is about.
    """
    global _PROVENANCE
    if not commit:
        _PROVENANCE = ""
        return
    short = commit[:7]
    where = f"[`{short}`](https://github.com/danieljoppi/AntHocNet/commit/{commit})"
    run = f", [run]({run_url})" if run_url else ""
    _PROVENANCE = f"_Measured at {where}{run}._"


def _stamp():
    """The provenance sentence as its own paragraph, or nothing at all."""
    return f"{_PROVENANCE}\n\n" if _PROVENANCE else ""


def _stamp_item():
    """Same sentence, as one element of a list later joined on "\\n" — so it
    carries the single trailing newline that makes it a paragraph. Empty
    strings are dropped by the callers' filter."""
    return f"{_PROVENANCE}\n" if _PROVENANCE else ""


def _uniq(values):
    """Stable de-duplication: CSV order in, CSV order out (deterministic)."""
    out = []
    for v in values:
        if v not in out:
            out.append(v)
    return out


def build_single(rows):
    """Old format: one scenario, one table (anthocnet-compare CSV)."""
    meta = rows[0]
    header = (
        f"_Scenario: {meta['nNodes']} nodes, {meta['area']} m area, "
        f"max speed {meta['speed']} m/s, {meta['flows']} flows, "
        f"mean of {meta['runs']} run(s); ± is the 95% CI half-width (#293). "
        f"Generated by `anthocnet-compare`._\n\n"
    )
    return (header + _stamp()
            + "\n".join(_TABLE_HEAD + [_row(r) for r in rows]) + "\n")


# --- generated blocks -------------------------------------------------------

def build_summary(discrete, folder):
    """Compact cross-scenario overview for the index page: PDR per protocol,
    one row per scenario, each linking to its detail page. The taxonomy chart
    rides along so the figure publishes next to the numbers."""
    runs = discrete[0].get("runs", "?")
    scenarios = _uniq(r["scenario"] for r in discrete)
    protos = _uniq(r["protocol"] for r in discrete)
    out = [
        (f"_Scenario taxonomy — **PDR % ± 95% CI**, mean of {runs} run(s) per "
         f"scenario, every baseline on identical realisations. Full per-scenario "
         f"metrics (delay, tail, NRL, jitter) are on the linked pages. Generated "
         f"by `run-scenarios.py`; charts by `make-charts.py`._\n"),
        _stamp_item(),
        f"![scenario taxonomy]({folder}/discrete-summary.png)\n",
        "| scenario | class | " + " | ".join(protos) + " |",
        "|---|---|" + "".join("---:|" for _ in protos),
    ]
    for scen in scenarios:
        srows = [r for r in discrete if r["scenario"] == scen]
        klass = srows[0].get("class", "")
        pdr = {r["protocol"]: _pm(r, r.get("pdr_pct", "-"), "pdr_sd")
               for r in srows}
        cells = " | ".join(pdr.get(p, "-") for p in protos)
        out.append(f"| [{scen}]({folder}/scenarios/{scen}.md) | {klass} | {cells} |")
    # No timestamp: the block changes when the numbers or the measuring commit
    # do, never merely because the job ran again.
    return "\n".join(x for x in out if x) + "\n"


def build_scenario(srows):
    """Full metric table for one named scenario's detail page."""
    runs = srows[0].get("runs", "?")
    head = (f"_Mean of {runs} run(s), every baseline on identical realisations; "
            f"± is the 95% CI half-width (#293). "
            f"Generated by `run-scenarios.py`._\n")
    return (head + "\n" + _stamp()
            + "\n".join(_TABLE_HEAD + [_row(r) for r in srows]) + "\n")


def build_sweep(name, srows):
    """Per-point metric table for one parameter sweep's detail page, with the
    swept value as the leading column and the sweep's line chart above it."""
    runs = srows[0].get("runs", "?")
    xlabel = srows[0].get("class", name)

    def xkey(r):
        try:
            return (0, float(r.get("x", "")))
        except (TypeError, ValueError):
            return (1, 0.0)

    ordered = sorted(srows, key=xkey)
    head = [
        (f"_Sweep `{name}` — mean of {runs} run(s) per point, every baseline on "
         f"identical realisations; ± is the 95% CI half-width (#293). "
         f"Generated by `run-scenarios.py`; chart by `make-charts.py`._\n"),
        _stamp_item(),
        f"![sweep: {name}](../sweep-{name}.png)\n",
        f"| {xlabel} " + _TABLE_HEAD[0],
        "|---:" + _TABLE_HEAD[1],
    ]
    rows_out = head + [f"| {r.get('x', '')} " + _row(r) for r in ordered]
    return "\n".join(x for x in rows_out if x) + "\n"


# --- stubs for pages that do not exist yet ----------------------------------

def scenario_stub(scen, srows, index_name):
    r = srows[0]
    cfg = [("nodes", r.get("nNodes", "")), ("area long edge (m)", r.get("areaX", "")),
           ("max speed (m/s)", r.get("speed", "")), ("pause (s)", r.get("pause", "")),
           ("flows", r.get("flows", "")), ("propagation", r.get("propagation", ""))]
    cfg = [(k, v) for k, v in cfg if v not in (None, "")]
    return (
        f"# Scenario: {scen}\n\n"
        f"**Class:** {r.get('class', '')}\n\n"
        f"[← Benchmark index](../../{index_name}) · [Metrics](../metrics.md) · "
        f"[Methodology](../methodology.md)\n\n"
        f"## What it stresses\n\n"
        f"_Not written yet._ Describe what this scenario is for — text outside the\n"
        f"generated block below survives regeneration, so it is safe to edit here.\n\n"
        f"## Configuration\n\n"
        + "| " + " | ".join(k for k, _ in cfg) + " |\n"
        + "|" + "".join("---|" for _ in cfg) + "\n"
        + "| " + " | ".join(str(v) for _, v in cfg) + " |\n\n"
        f"Defined as `DISCRETE[\"{scen}\"]` in "
        f"[`ns3/tools/run-scenarios.py`](../../../ns3/tools/run-scenarios.py).\n\n"
        f"## Results\n\n"
        + _CAVEAT + "\n"
        + f"{START}\n{END}\n"
    )


def sweep_stub(name, srows, index_name):
    xlabel = srows[0].get("class", name)
    return (
        f"# Sweep: {name}\n\n"
        f"**Varies:** {xlabel}\n\n"
        f"[← Benchmark index](../../{index_name}) · [Metrics](../metrics.md) · "
        f"[Methodology](../methodology.md)\n\n"
        f"## What it varies\n\n"
        f"_Not written yet._ Describe the axis and the paper figure it reproduces —\n"
        f"text outside the generated block below survives regeneration.\n\n"
        f"Defined as `SWEEPS[\"{name}\"]` in "
        f"[`ns3/tools/run-scenarios.py`](../../../ns3/tools/run-scenarios.py).\n\n"
        f"## Results\n\n"
        + _CAVEAT + "\n"
        + f"{START}\n{END}\n"
    )


# --- splicing ---------------------------------------------------------------

def write_block(path, block, stub=None):
    """Replace the marked block in `path`, creating it from `stub` if missing.
    Returns True when the file changed on disk."""
    if not os.path.exists(path):
        if stub is None:
            raise SystemExit(f"{path} does not exist and no stub is available")
        os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
        doc = stub
    else:
        with open(path) as f:
            doc = f.read()
    if START not in doc or END not in doc:
        raise SystemExit(f"markers {START} / {END} not found in {path}")

    pre = doc[: doc.index(START) + len(START)]
    post = doc[doc.index(END):]
    new_doc = pre + "\n" + block + "\n" + post
    if new_doc == doc:
        return False
    with open(path, "w") as f:
        f.write(new_doc)
    return True


def update_classified(rows, doc_path):
    """Classified format (run-scenarios.py): summary into the index, detail into
    one page per scenario / per sweep."""
    root = doc_path[:-3] if doc_path.endswith(".md") else doc_path + "-pages"
    folder = os.path.basename(root)
    index_name = os.path.basename(doc_path)

    changed = []
    discrete = [r for r in rows if r.get("kind") == "discrete"]
    sweeps = [r for r in rows if r.get("kind") == "sweep"]
    if not discrete and not sweeps:
        raise SystemExit("classified CSV has no discrete or sweep rows")

    if discrete:
        if write_block(doc_path, build_summary(discrete, folder)):
            changed.append(doc_path)
        for scen in _uniq(r["scenario"] for r in discrete):
            srows = [r for r in discrete if r["scenario"] == scen]
            path = os.path.join(root, "scenarios", f"{scen}.md")
            if write_block(path, build_scenario(srows),
                           stub=scenario_stub(scen, srows, index_name)):
                changed.append(path)

    for name in _uniq(r["group"] for r in sweeps):
        srows = [r for r in sweeps if r["group"] == name]
        path = os.path.join(root, "sweeps", f"{name}.md")
        if write_block(path, build_sweep(name, srows),
                       stub=sweep_stub(name, srows, index_name)):
            changed.append(path)
    return changed


def main():
    ap = argparse.ArgumentParser(
        description="Refresh the generated blocks of the benchmark docs.")
    ap.add_argument("csv_file")
    ap.add_argument("doc_file")
    ap.add_argument("--commit", default="",
                    help="commit SHA the numbers were measured at (#365); "
                         "omitted means no provenance stamp is written")
    ap.add_argument("--run-url", default="",
                    help="URL of the workflow run that measured them")
    args = ap.parse_args()
    _set_provenance(args.commit, args.run_url)
    csv_path, doc_path = args.csv_file, args.doc_file
    with open(csv_path, newline="") as f:
        rows = list(csv.DictReader(f))
    if not rows:
        raise SystemExit("no CSV rows")

    if "kind" in rows[0] and "scenario" in rows[0]:
        changed = update_classified(rows, doc_path)
    else:
        changed = [doc_path] if write_block(doc_path, build_single(rows)) else []

    for p in changed:
        print(f"updated {p}")
    if not changed:
        print("benchmark docs already up to date")


if __name__ == "__main__":
    main()
