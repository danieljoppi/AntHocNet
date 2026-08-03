---
name: benchmark-results
description: Run the full AntHocNet benchmark loop — pre-flight-validate scenario configs, dispatch paper-benchmark / scenario-matrix, fetch results cheaply, check result plausibility and anchor floors, parse and A/B-compare runs, and summarize classified campaign CSVs — with automatic run-to-run-noise verdicts. Use whenever dispatching benchmark workflows, validating a scenario or its results, or collecting/comparing AntHocNet benchmark numbers (including docs/benchmarks/campaign/*.csv sweeps) so validation, parsing, deltas, filtering, and the noise call are done by scripts instead of by hand in context.
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

### Statistics (#293) — what the extra lines mean

When a cell carries `##RUN##` per-seed rows, three things appear automatically:

- **`95% CI` line per protocol**: t-distribution half-widths (`±`) for
  pdr/delay/thrput/nrl and a percentile-**bootstrap** interval
  (`boot[lo,hi]`, deterministic seed) for delay99 — a t-CI on a p99 is not
  defensible. These are the intervals every published number must carry.
- **`paired 95% CI (n=..)` line per comparison** (both cells need `##RUN##`
  rows): per-seed **difference** CI (t for dPDR/d_NRL, bootstrap for d_d99)
  plus a two-sided **Wilcoxon signed-rank p** (exact for n≤25 without ties).
  Its `PAIRED-*` verdict — significance = CI excludes zero — **replaces** the
  materiality verdict on that delta line: per-seed evidence beats thresholds.
- **Column-mapping self-check**: `##RUN##` fields are positional, and a
  mis-mapped column yields a plausible table with delay where jitter should
  be. Any cell also carrying the harness's `# stddev` lines gets each sd
  recomputed from the columns the parser believes are that metric; `OK
  (N checks)` or a loud FAIL + **exit 1** — never quote numbers from a cell
  that failed (fetch ~55 tail lines so the `# stddev` lines are included).

`sweep_summary.py`'s grid gains `±95` columns next to the PDR means (t-CI
from the CSV's `pdr_sd`/`runs`; blank for pre-#28 CSVs). The shared math
lives in `stats_util.py`; `test_stats.py` covers it (runs in `lint.yml`).

## Dispatching runs (not scriptable here)

`workflow_dispatch` POSTs 403 from a script, so fire runs via
`mcp__github__actions_run_trigger` (workflow `paper-benchmark.yml`). Drive
scenario knobs through the `extraArgs` input, e.g.
`--cbrBps=8000 --sink=25 --flows=30 --ns3::anthocnet::RoutingProtocol::EnableMacMetric=true`.
Pair every ON run with an identical OFF run for a clean A/B (baselines are
deterministic on identical seeds).

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
   workflow, then read `docs/benchmarks/campaign/<runid>-*.csv` from the ref.
4. **Validate before comparing**: `scenario_check.py results` on the saved
   cell/CSV — plausibility invariants (PDR bounds, delay99 ≥ mean, negative
   metrics) and, for anchor-shaped scenarios, the `ns3/tools/anchors.yml`
   floors (#59). A FAIL here means harness/channel regression (#51-class):
   do not compare, publish, or quote the numbers.
5. **Parse by script, never by eye**: `bench_parse.py` for `##BENCH##` cells,
   `sweep_summary.py` for campaign CSVs (below).
6. **Record** the verdict + run IDs on the relevant issue (ADR-0013).

## Campaign CSVs (`sweep_summary.py`)

Classified CSVs (`run-scenarios.py` schema, e.g.
`docs/benchmarks/campaign/*.csv`) are hundreds of cells — schema check,
per-point deltas, and the stddev-aware noise call happen in the script; only
its compact grid should reach context.

```bash
S=.claude/skills/benchmark-results/sweep_summary.py
python3 $S docs/benchmarks/campaign/*.csv        # anthocnet vs aodv per point
python3 $S --baseline olsr --group pause FILE    # other baseline / one group
python3 $S AFTER.csv --vs BEFORE.csv             # same sweep, two code
                                                 #   generations (see below)
python3 $S --export-sweeps sweeps.csv FILE...    # emit the papers-repo
                                                 #   plots/data/sweeps.csv schema
```

### Did *our change* move the sweep? (`--vs`)

The default mode answers "AntHocNet vs AODV". After a protocol change you need
the other question — **what did this commit do to the sweep** — which is the
loop #88 (`T_hop`) and #169 (`reactiveMaxBroadcasts`) forced when they
invalidated every published number. `--vs` takes the BEFORE CSVs and diffs the
same `(kind, group, x)` points of the same protocol:

```bash
python3 $S docs/benchmarks/campaign/<after>.csv --vs docs/benchmarks/campaign/<before>.csv
```

Note the argument order: `--vs` is greedy (`nargs='+'`), so the AFTER files must
come **before** the flag.

It also prints a **control** line, which is the part that makes the result
trustworthy: the baseline protocols are untouched code on identical seeds, so
their `pdr_pct`/`delay_ms`/`delay99_ms`/`nrl` must be *identical* across the two
generations. If they moved, the harness moved too, the AntHocNet delta is not
attributable to your change (a #51-class finding) — and the script **exits 1**
so a scripted campaign stops instead of publishing the number.

Points present in only one of the two CSVs are reported and skipped, so a
partial re-run still compares cleanly against a full sweep.

Per-point verdict uses bench_parse's materiality thresholds (PDR ±1pp,
delay99/NRL ±10%); `~sd` marks a material PDR delta still inside
2·RSS(`pdr_sd`) — run-to-run dispersion, treat as noise and bump `--runs`.
`--export-sweeps` is the bridge to the papers repo's `figures` skill
(`plot_sweeps.py` reads that schema directly).

## Scenario validation (`scenario_check.py`, #134)

Pre-flight a config before dispatching; sanity-check results after fetching.
Both exit non-zero on FAIL.

```bash
S=.claude/skills/benchmark-results/scenario_check.py
python3 $S preflight                              # paper base defaults, OK
python3 $S preflight --areaX 2500 --flows 40      # override what you'd dispatch
python3 $S results cell.txt                       # ##BENCH## cell or campaign CSV
python3 $S results --anchor broch-low-mobility cell.txt   # enforce #59 floor
```

`preflight` checks: expected mean node degree (strip-geometry aware) vs the
ln(n) connectivity threshold, offered load vs the pinned 2 Mbit/s channel
(#84), `range ≥ area` single-hop degeneracy, short-sim and static-field
warnings, and the #230 **diversity-window coherence** rule — `--pathWindowS`
against the `range / (2·speed)` link lifetime, since a window longer than a
route survives counts route *replacement* as concurrent multipath. That last
one FAILs the shipped 10 s default at the paper-base knobs, which is where
#230 should have been caught instead of after a 115-minute campaign. `results` checks: PDR ∈ [0,100], delay99 ≥ mean delay, negative
metrics, dead cells (#28), the #209 energy invariants (total energy positive
and finite, energy-per-delivered-packet finite and non-negative — and non-zero
whenever PDR is, residual energy within [0, initial]; all skipped for inputs
predating energy instrumentation), the #212 reordering bounds (out-of-order
ratios in [0,1]; extents and reorder-buffer occupancies finite and
non-negative — all skipped for inputs predating reordering instrumentation),
the #215 drop-cause identity (PDR plus the
five protocol-agnostic causes must account for ~100% of offered packets: WARN
past 1 pp, FAIL past 5 pp — the tolerance is the data still queued when the run
stops; also FAILs a negative cause share, which means two causes count the same
packet; skipped for inputs predating drop instrumentation),
the #217 route-quality invariants (mean path
length ≥ 1 hop and ≤ `maxPathLength`, max ≥ mean; used-path diversity ≥ 1 and
≤ its own maximum; path entropy in [0, log2(max diversity)]; Jain's fairness
index ∈ [0,1] — each of them non-zero whenever PDR is, so a trace that silently
failed to connect reads as a FAIL rather than as "no multipath"; all skipped for
inputs predating route-quality instrumentation), and — with `--anchor` — the AODV floors read from
`ns3/tools/anchors.yml` (never duplicated). A `results` FAIL is a #51-class
harness regression: fix the harness before trusting any number from that run.

### Testing the gate itself (`test_scenario_check.py`)

```bash
python3 .claude/skills/benchmark-results/test_scenario_check.py
```

No pytest, no simulator, ~1 s; runs on every PR from `lint.yml`. Every rule
gets **two** cases — a crafted row where it must fire and one where it must
not. The second half is the point: the first cut of #229's queue diagnosis
keyed on "`drop_queue_pct` is zero" and flagged `anthocnet` and `aodv` rows
that were accounting correctly. A check that cries wolf gets ignored, and then
it is not a gate. Fixture values are the real campaign readings, so moving a
threshold has to confront the observation that set it.

## Adding a metric: the three things that ship with it (#229/#230)

Both the reordering and path-diversity defects were findable **before** any
campaign, in milliseconds, from a synthetic input. They survived six merged
campaigns because the metric shipped with a definition and a CSV column and
nothing that could fail. So a new metric family is not done until it has:

1. **A control arm with a value known a priori** — written down as a *number*,
   not as "should be small". `path_div_used` had exactly this in prose ("the
   single-path baselines are the instrumentation's self-check") and still
   shipped reading 1.428 for OLSR, because prose does not fail.
2. **An automated assertion of that control** in `scenario_check.py results`,
   with a case in `test_scenario_check.py` proving it fires and one proving it
   stays quiet. If the assertion cannot be written, the metric's claim is not
   yet falsifiable — and that is the finding, before the dispatch.
3. **A preflight coherence rule** for any parameter the metric depends on,
   checked against the scenario knobs. `--pathWindowS` is meaningless without
   the mobility it is compared against; the rule relating the two costs nothing
   and catches the defect at zero dispatches.

**Order of operations.** Run `preflight` (free), then *one cheap point* —
`paper-benchmark.yml` at `runs=2`, `time=300`, a `-opt` image — and run
`scenario_check.py results` on that before committing to a taxonomy sweep. A
control that reads wrong reads wrong in 20 minutes just as clearly as in 115.
