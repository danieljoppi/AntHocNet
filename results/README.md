# Benchmark data

The raw measurements behind every published number (#615). The pages that
explain them live in [`docs/benchmarks/`](../docs/benchmarks/README.md); the
charts are drawn from these files by
[`ns3/tools/family-charts.py`](../ns3/tools/family-charts.py) and committed
next to the pages.

| directory | what | written by |
|---|---|---|
| `cells/` | one harness run per file (`##RUN##` per-seed rows, `##PROV##` commit, `# stddev` lines): the family results pages, the MANET grid, the satellite suites | saved from `paper-benchmark` / `satellite-benchmark` logs (the `benchmark-results` skill) |
| `campaign/` | classified campaign CSVs from `scenario-matrix` and `rescue-artifacts`, named `<actions-run-id>-<label>.csv` (and `-runs.csv` per-seed siblings) | `scenario-matrix.yml` (`commit=true`), `rescue-artifacts.yml` |

Rules:
- **Never edit a file here by hand.** A number that changes is a new run with
  its own run ID, so an old page keeps citing the data it was written from.
- **Validate before you cite:** `python3 tools/bench/scenario_check.py results <file>`.
- **Summarise by script:** `tools/bench/bench_parse.py` for cells,
  `tools/bench/sweep_summary.py` for campaign CSVs,
  `ns3/tools/leo-summary.py` for the constellation cells.
