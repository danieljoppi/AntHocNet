# Benchmark charts

Generated figures for the scenario matrix and the AntHocNet paper's parameter
sweeps. **Do not edit by hand** — they are produced by:

```bash
# 1. run the matrix in a configured ns-3 tree (writes a classified CSV)
python3 ns3/tools/run-scenarios.py /path/to/ns-3 --out scenarios.csv [--quick]

# 2. render the figures from that CSV (re-plotting never re-runs ns-3)
python3 ns3/tools/make-charts.py scenarios.csv --outdir docs/benchmarks
```

or, in CI, by the manually-dispatched **Scenario matrix + charts** workflow
(`.github/workflows/scenario-matrix.yml`), which uploads the CSV + PNGs as
artifacts and, with `commit=true`, writes them here.

## Figures

| File | What |
|---|---|
| `discrete-summary.png` | Grouped bars: PDR / mean delay / NRL per named scenario, bar per protocol. |
| `sweep-area.png` | Paper Fig. 1 — sparseness sweep (long edge 1500→2500 m). PDR \| mean+99th delay \| NRL, line per protocol. |
| `sweep-pause.png` | Paper Fig. 2 — mobility sweep (pause 0→900 s). |
| `sweep-scale.png` | Paper Fig. 3 — scale sweep (50→200 nodes, terrain ×f). |

In the delay panels, solid lines are the **mean** and dashed lines (`△`) the
**99th-percentile** delay — the paper's QoS/jitter metric.
