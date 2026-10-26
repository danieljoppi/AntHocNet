# Campaign CSVs and satellite cells

Part of the `benchmark-results` skill; [SKILL.md](../SKILL.md) is the procedure. Read this file when the step you are on needs it.

## Campaign CSVs (`sweep_summary.py`)

Classified CSVs (`run-scenarios.py` schema, e.g.
`results/campaign/*.csv`) are hundreds of cells — schema check,
per-point deltas, and the stddev-aware noise call happen in the script; only
its compact grid should reach context.

```bash
S=tools/bench/sweep_summary.py
python3 $S results/campaign/*.csv        # anthocnet vs aodv per point
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
python3 $S results/campaign/<after>.csv --vs results/campaign/<before>.csv
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

**When both generations carry the per-run sibling CSV (#319), each point also
gets a paired line and the `PAIRED-*` verdict replaces the materiality one** —
same rule as `bench_parse --ab`, for the same reason: per-seed evidence beats a
fixed threshold, and pairing removes the between-seed variance that makes a
real effect read as `NOISE` or `~sd`. This is the branch that settled #179,
where three campaigns of unpaired reads had all landed on "direction is right,
nothing clears the noise floor":

```
sparse-static   0  20   97.7 0.6  97.2 0.7   +0.5  -4.1  -9.7  PAIRED-IMPROVED
        paired 95% CI (n=20): dPDR +0.50 [+0.11,+0.88]pp p=0.0254 ...
```

The unpaired columns on that same line say `NOISE`. Older CSVs without the
sibling fall back to the materiality verdict and print no paired line, so
pre-#319 campaigns still compare exactly as before.
`--export-sweeps` is the bridge to the papers repo's `figures` skill
(`plot_sweeps.py` reads that schema directly).

## Satellite constellation cells (`ns3/tools/leo-summary.py`, #297)

The leo-walker cells (`results/cells/leo-<cell>-<arm>.txt`, one arm per
file, 20 seeds) are summarised by script into the tables on
`docs/benchmarks/satellite/leo-walker.md` — headline per arm with CIs, paired
AntHocNet-vs-arm differences (oracles excluded: they are bounds), the handover
family and route churn:

```bash
python3 ns3/tools/leo-summary.py walker16 starlink1 starlink1-storm
```

Paste its output; never retype the numbers. Validate each cell with
`scenario_check.py results` first. The CI smoke for the harness itself
(geometry, handover, every arm delivers, reproducibility) is
`tools/checks/check-leo-walker.sh <ns3-dir>`.
