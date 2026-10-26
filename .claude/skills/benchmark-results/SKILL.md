---
name: benchmark-results
description: Run the full AntHocNet benchmark loop — pre-flight-validate scenario configs, dispatch paper-benchmark / scenario-matrix, fetch results cheaply, check result plausibility and anchor floors, parse and A/B-compare runs, and summarize classified campaign CSVs — with automatic run-to-run-noise verdicts. Use whenever dispatching benchmark workflows, validating a scenario or its results, or collecting/comparing AntHocNet benchmark numbers (including results/campaign/*.csv sweeps) so validation, parsing, deltas, filtering, and the noise call are done by scripts instead of by hand in context.
---

# benchmark-results

> **Where the scripts live:** `tools/bench/` — not in this skill directory. They
> ship with every release (the shipped `ns3/tools/` harness tools import them),
> while `.claude/` is excluded from release packages (#604). This file is the
> *procedure*; the scripts are product code with their own CI (ruff, the two
> self-tests in `lint.yml`).

Turns raw `anthocnet-compare` output into a compact delta grid with a noise
verdict, using `bench_parse.py`. All arithmetic and the
noise call happen in the script — your context only sees the summary.

## Getting the numbers out of CI (the constraint)

Scripts here **cannot** download CI logs or artifacts — the sandbox proxy blocks
the blob hosts (`api.github.com` JSON reads work; log/artifact/zip 403). So the
result text must come through `mcp__github__get_job_logs`. Two ways to keep that
fetch cheap:

- **Preferred:** the `paper-benchmark` workflow's last step prints a compact
  `##BENCH## <proto> <pdr> <delay> <delay99> <thrput> <nrl>` block *after* the
  upload step, so `get_job_logs` with `tail_lines: 8` captures just the numbers.
  The very last line of that block is `##PROV## commit=…` (#365) — the commit
  the cell was measured at. Keep it in whatever you save: it is what makes the
  saved file self-describing after the run's logs expire. The artifact's
  results file ends with the same line (#674), so a cell saved from the
  artifact needs no provenance rebuilt from the run record.
- Otherwise fetch ~55 tail lines (the human table sits just above the
  upload/cleanup noise) and save it.
- **Whole log to a file, not to context:** `mcp__github__get_job_logs` with
  `return_content: false` returns a short-lived signed URL; `curl -sSL "$URL"
  -o job.log` then works (the signed host is reachable even though `gh api`
  cannot follow the blob redirect). Use it for long cells (leo-walker,
  campaign logs) and grep/extract by script.

Save each run's text to a file (one file per run); a leading `# <label>` line
names the cell. Then run the parser — never eyeball tables or compute deltas by
hand.

## Commands

```bash
S=tools/bench/bench_parse.py
python3 $S off.txt on.txt                 # deltas of every cell vs the first
python3 $S --ab off1 on1 off2 on2         # (off,on) pairs; flags cross-pair sign
python3 $S --all a.txt b.txt              # every protocol, not just anthocnet
python3 $S --proto aodv a.txt b.txt       # compare a different protocol
```

`--ab` is the money mode for `EnableMacMetric` sweeps: it computes on-vs-off
within each load pair and, if the PDR deltas disagree in sign across pairs,
prints the **NOISE** call (the exact trap hit in #47/#68/#71 — opposite
directions at low run counts mean noise, bump `--runs`).

Each delta line shows `dPDR / d_delay / d_d99 / d_NRL` (d_d99 = 99th-pct delay,
often the real signal — e.g. A2's win was flat PDR but −20% d99). Verdict is
multi-signal over the material deltas (PDR up good; d99 and NRL down good):
`NOISE` if none are material, `IMPROVED`/`WORSE` if they agree, `MIXED` if they
conflict. So a flat-PDR run whose tail and overhead both drop reads IMPROVED, not
MIXED. Treat a single pair's verdict at <5 runs with suspicion — confirm with
more runs before concluding.
Cells with `##RUN##` per-seed rows also get a `95% CI` line per protocol and,
per comparison, a `paired 95% CI (n=..)` line whose `PAIRED-*` verdict
**replaces** the materiality verdict. A column-mapping self-check FAIL exits 1:
never quote numbers from that cell. Details: [reference/statistics.md](reference/statistics.md).

## Dispatching runs

Fire a single run via `mcp__github__actions_run_trigger` (workflow
`paper-benchmark.yml`). Drive
scenario knobs through the `extraArgs` input, e.g.
`--cbrBps=8000 --sink=25 --flows=30 --ns3::anthocnet::RoutingProtocol::EnableMacMetric=true`.
Pair every ON run with an identical OFF run for a clean A/B (baselines are
deterministic on identical seeds).

**A campaign (more than a handful of runs) goes through
`tools/bench/campaign.py` and a committed plan** (#662). The plan is
`tools/bench/campaigns/<release>.yaml`: cells, arms and which arm runs where;
`campaigns/v2.2.0-phase2.yaml` is the worked example. The plan is committed in
the PR that pre-registers the campaign.

```bash
C=tools/bench/campaign.py; P=tools/bench/campaigns/v2.3.0.yaml
python3 $C plan $P                            # review the job list; sends nothing
python3 $C dispatch $P --log runs.tsv         # up to the cap (12), then exits
python3 $C status $P --log runs.tsv --brief   # only labels not yet green; counts
python3 $C collect $P --log runs.tsv --out results/cells [--from DIR]
python3 $C verdicts $P --dir results/cells    # bench_parse --ab per arm x cell
```

- **The cap leaves PR CI its runners.** v2.2.0's phase 1 dispatched 36 jobs at
  once and PR CI queued for hours. Never hand-dispatch a campaign.
- **`dispatch` is resumable.** It skips labels already in the log and exits
  at the cap. Re-run it from a scheduled check-in every 60–90 min; an agent's
  background tasks die at 2 h, and a campaign takes about 10 h.
- **A check-in is `dispatch` then `status --brief`** — two calls, a few
  lines of output. Read full `status` only when a label needs its run id.
- **`collect` refuses a stub.** A run killed at its time limit uploads an
  artifact with only `##PROV##`; collect reports it and skips the cell. Re-run
  the label, or, if the maintainer accepts fewer seeds, write the cell by hand
  and say so in its header (scale-500-olsr-v240, n=19).
- **`collect --from DIR`** reads `DIR/<label>/<results file>`, for an
  environment where `gh api` cannot follow the artifact's blob redirect.
  There, get each artifact's signed URL with
  `mcp__github__actions_get` (`download_workflow_run_artifact`) and `curl` it,
  changing `\u0026` to `&`.

## The full campaign loop (dispatch → fetch → parse)

The cross-session procedure (formerly buried in issue #91's session notes):

0. **Pre-flight** the scenario before spending a dispatch (#121 budget):
   `scenario_check.py preflight` with the knobs you intend to override —
   flags partitioned fields, channel saturation, accidental single-hop,
   too-short sim time (see below).
1. **Dispatch** `paper-benchmark.yml` (single point, ##BENCH## output) or
   `scenario-matrix.yml` (taxonomy/sweeps → classified CSV artifact) via
   `mcp__github__actions_run_trigger` on `main` or a branch ref. For
   `scenario-matrix`, `only=<sweep>` + `point=<x>` runs one point;
   `commit=true` writes CSV+charts into `docs/benchmarks/` on that ref.
2. **Wait** — a real sweep point can exceed an hour (job timeout 720 min).
   Poll `mcp__github__actions_get` occasionally or schedule a check-in; do
   not spin.
3. **Fetch cheap.** `paper-benchmark`: `get_job_logs` with `tail_lines: 15`
   (the `##BENCH##` block is last; `# stddev` / `# diag hold[...]` lines sit
   just above — fetch ~55 lines if you need those). Save the tail verbatim to
   a file, one per run. `scenario-matrix`: the CSV artifact is
   proxy-blocked; use `commit=true` on dispatch, or the `rescue-artifacts`
   workflow, then read `results/campaign/<runid>-*.csv` from the ref.
4. **Validate before comparing**: `scenario_check.py results` on the saved
   cell/CSV — plausibility invariants (PDR bounds, delay99 ≥ mean, negative
   metrics) and, for anchor-shaped scenarios, the `ns3/tools/anchors.yml`
   floors (#59). A FAIL here means harness/channel regression (#51-class):
   do not compare, publish, or quote the numbers. It also echoes the cell's
   `##PROV##` commit (#365) and WARNs when a log cell has none — a number whose
   version is unknown is not publishable, and the usual cause is a tail cut
   above the line rather than a workflow that failed to emit it.
5. **Parse by script, never by eye**: `bench_parse.py` for `##BENCH##` cells,
   `sweep_summary.py` for campaign CSVs (below).
6. **Attribution control** when a campaign changes code between two
   generations: `bench_parse.py --control BEFORE AFTER` on a cell run with
   every protocol. Every baseline's `##RUN##` rows must be identical; stock
   AODV on a satellite cell may read ORDER-ONLY (#675, heap-ordered sockets),
   anything else that moved is a FAIL and the delta is not attributable.
7. **Record** the verdict + run IDs on the relevant issue (ADR-0013).
## Campaign CSVs and satellite cells

```bash
python3 tools/bench/sweep_summary.py results/campaign/*.csv          # anthocnet vs aodv per point
python3 tools/bench/sweep_summary.py AFTER.csv --vs BEFORE.csv       # what did our change do (AFTER first)
python3 ns3/tools/leo-summary.py walker16 starlink1 starlink1-storm  # leo-walker tables, paste verbatim
```

`--vs` exits 1 when a baseline moved between generations: the delta is not
attributable. Flags, the paired branch and the satellite tables:
[reference/sweeps.md](reference/sweeps.md).

## Scenario validation (`scenario_check.py`, #134)

```bash
S=tools/bench/scenario_check.py
python3 $S preflight [--knob value ...]           # before any dispatch; exit 1 on FAIL
python3 $S preflight --harness isl-grid ...       # satellite cell
python3 $S results cell.txt [--anchor NAME]       # before trusting any number
python3 tools/bench/test_scenario_check.py        # the gate's own tests (~1 s)
```

A `results` FAIL is a harness regression: fix the harness before you compare,
publish or quote anything from that run. Every rule, the path-diversity
churn floor, and what a new metric must ship with:
[reference/scenario-check.md](reference/scenario-check.md).
