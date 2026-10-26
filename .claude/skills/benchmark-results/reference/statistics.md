# Statistics in bench_parse / sweep_summary output

Part of the `benchmark-results` skill; [SKILL.md](../SKILL.md) is the procedure. Read this file when the step you are on needs it.

## What the extra lines mean (#293)

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
