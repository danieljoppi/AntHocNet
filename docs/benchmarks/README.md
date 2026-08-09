# Benchmark pages & charts

Detail pages and generated figures behind the [benchmark index](../benchmarks.md).

## Layout

```
docs/benchmarks.md            index: cross-scenario summary table + links (generated block)
docs/benchmarks/
  metrics.md                  metric definitions and their caveats
  methodology.md              reproduce commands, taxonomy & sweeps, build profiles,
                              validation anchors
  scenarios/<name>.md         one page per named scenario: class, what it stresses,
                              configuration, full metric table (generated block)
  sweeps/<name>.md            one page per parameter sweep: what it varies, the paper
                              figure it reproduces, chart + per-point table (generated block)
  tcp.md                      the transport arm: TCP goodput + paired tests + UDP control
                              (hand-written tables; data in campaign/tcp-goodput.csv)
  campaign/*.csv              raw campaign sweep CSVs rescued from expiring artifacts
  *.png                       the figures, written here by make-charts.py
```

Every page has a **generated block** between

```
<!-- BENCHMARK-TABLE-START -->
<!-- BENCHMARK-TABLE-END -->
```

Only that block is rewritten. Prose outside it — "what it stresses", the
configuration table, caveats — is hand-written and survives regeneration. A
scenario or sweep that appears in the CSV without a page yet gets a **stub**
written for it (title, class, configuration, caveat, empty marker block), so a
new scenario self-registers and only its prose needs filling in.

## Regenerating

**Do not edit the generated blocks or the PNGs by hand** — they are produced by:

```bash
# 1. run the matrix in a configured ns-3 tree (writes a classified CSV)
python3 ns3/tools/run-scenarios.py /path/to/ns-3 --out scenarios.csv [--quick]

# 2. render the figures from that CSV (re-plotting never re-runs ns-3)
python3 ns3/tools/make-charts.py scenarios.csv --outdir docs/benchmarks

# 3. write the tables into the index + the per-scenario / per-sweep pages
python3 ns3/tools/update-benchmarks.py scenarios.csv docs/benchmarks.md
```

Step 3 derives the page paths from the doc path: `docs/benchmarks.md` →
`docs/benchmarks/scenarios/` and `docs/benchmarks/sweeps/`. It is idempotent —
running it twice produces no second diff.

In CI:

- **Benchmarks** (`.github/workflows/benchmarks.yml`, every merge to the default
  branch) runs the *discrete* scenarios with `--quick` and commits the refreshed
  index summary, scenario pages and `discrete-summary.png`.
- **Scenario matrix + charts** (`.github/workflows/scenario-matrix.yml`, manual)
  runs the heavier sweeps, uploads the CSV + PNGs as artifacts and, with
  `commit=true`, writes the figures here. Point step 3 at its CSV to refresh the
  sweep pages' tables.

## Figures

| File | What |
|---|---|
| `discrete-summary.png` | Grouped bars: PDR / mean delay / NRL per named scenario, bar per protocol. Embedded in [the index](../benchmarks.md). |
| `sweep-area.png` | Paper Fig. 1 — sparseness sweep (long edge 1500→2500 m). PDR \| mean+99th delay \| NRL, line per protocol. Embedded in [sweeps/area.md](sweeps/area.md). |
| `sweep-pause.png` | Paper Fig. 2 — mobility sweep (pause 0→900 s). Embedded in [sweeps/pause.md](sweeps/pause.md). |
| `sweep-scale.png` | Paper Fig. 3 — scale sweep (50→200 nodes, terrain ×f). Embedded in [sweeps/scale.md](sweeps/scale.md). |

In the delay panels, solid lines are the **mean** and dashed lines (`△`) the
**99th-percentile** delay — the paper's QoS/jitter metric.
