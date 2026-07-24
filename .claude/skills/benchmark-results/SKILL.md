---
name: benchmark-results
description: Run the full AntHocNet benchmark loop — dispatch paper-benchmark / scenario-matrix, fetch results cheaply, parse and A/B-compare runs, and summarize classified campaign CSVs — with automatic run-to-run-noise verdicts. Use whenever dispatching benchmark workflows or collecting/comparing AntHocNet benchmark numbers (including docs/benchmarks/campaign/*.csv sweeps) so parsing, deltas, filtering, and the noise call are done by scripts instead of by hand in context.
---

# benchmark-results

Turns raw `anthocnet-compare` output into a compact delta grid with a noise
verdict, using `bench_parse.py` (in this skill dir). All arithmetic and the
noise call happen in the script — your context only sees the summary.

## Getting the numbers out of CI (the constraint)

Scripts here **cannot** download CI logs or artifacts — the sandbox proxy blocks
the blob hosts (`api.github.com` JSON reads work; log/artifact/zip 403). So the
result text must come through `mcp__github__get_job_logs`. Two ways to keep that
fetch cheap:

- **Preferred:** the `paper-benchmark` workflow's last step prints a compact
  `##BENCH## <proto> <pdr> <delay> <delay99> <thrput> <nrl>` block *after* the
  upload step, so `get_job_logs` with `tail_lines: 8` captures just the numbers.
- Otherwise fetch ~55 tail lines (the human table sits just above the
  upload/cleanup noise) and save it.

Save each run's text to a file (one file per run); a leading `# <label>` line
names the cell. Then run the parser — never eyeball tables or compute deltas by
hand.

## Commands

```bash
S=.claude/skills/benchmark-results/bench_parse.py
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

## Dispatching runs (not scriptable here)

`workflow_dispatch` POSTs 403 from a script, so fire runs via
`mcp__github__actions_run_trigger` (workflow `paper-benchmark.yml`). Drive
scenario knobs through the `extraArgs` input, e.g.
`--cbrBps=8000 --sink=25 --flows=30 --ns3::anthocnet::RoutingProtocol::EnableMacMetric=true`.
Pair every ON run with an identical OFF run for a clean A/B (baselines are
deterministic on identical seeds).

## The full campaign loop (dispatch → fetch → parse)

The cross-session procedure (formerly buried in issue #91's session notes):

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
   workflow, then read `docs/benchmarks/campaign/<runid>-*.csv` from the ref.
4. **Parse by script, never by eye**: `bench_parse.py` for `##BENCH##` cells,
   `sweep_summary.py` for campaign CSVs (below).
5. **Record** the verdict + run IDs on the relevant issue (ADR-0013).

## Campaign CSVs (`sweep_summary.py`)

Classified CSVs (`run-scenarios.py` schema, e.g.
`docs/benchmarks/campaign/*.csv`) are hundreds of cells — schema check,
per-point deltas, and the stddev-aware noise call happen in the script; only
its compact grid should reach context.

```bash
S=.claude/skills/benchmark-results/sweep_summary.py
python3 $S docs/benchmarks/campaign/*.csv        # anthocnet vs aodv per point
python3 $S --baseline olsr --group pause FILE    # other baseline / one group
python3 $S --export-sweeps sweeps.csv FILE...    # emit the papers-repo
                                                 #   plots/data/sweeps.csv schema
```

Per-point verdict uses bench_parse's materiality thresholds (PDR ±1pp,
delay99/NRL ±10%); `~sd` marks a material PDR delta still inside
2·RSS(`pdr_sd`) — run-to-run dispersion, treat as noise and bump `--runs`.
`--export-sweeps` is the bridge to the papers repo's `figures` skill
(`plot_sweeps.py` reads that schema directly).
