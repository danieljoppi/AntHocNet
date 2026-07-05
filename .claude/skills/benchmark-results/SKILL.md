---
name: benchmark-results
description: Parse anthocnet-compare / paper-benchmark output and A/B-compare runs (EnableMacMetric on/off, protocol vs baseline, load sweeps) with an automatic run-to-run-noise verdict. Use whenever collecting or comparing AntHocNet benchmark numbers so the parsing, per-metric deltas, and noise call are done by a script instead of by hand in context.
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

Verdict per pair: `NOISE` (|dPDR|<1pp and |d_delay|<10% and |d_NRL|<10%),
else `IMPROVED` / `WORSE` by PDR direction. Treat a single pair's IMPROVED/WORSE
at <5 runs with suspicion — confirm with more runs before concluding.

## Dispatching runs (not scriptable here)

`workflow_dispatch` POSTs 403 from a script, so fire runs via
`mcp__github__actions_run_trigger` (workflow `paper-benchmark.yml`). Drive
scenario knobs through the `extraArgs` input, e.g.
`--cbrBps=8000 --sink=25 --flows=30 --ns3::anthocnet::RoutingProtocol::EnableMacMetric=true`.
Pair every ON run with an identical OFF run for a clean A/B (baselines are
deterministic on identical seeds).
