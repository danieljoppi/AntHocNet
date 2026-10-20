# Scenario: partition/merge

**Class:** stress: a field that splits and re-joins ([#62](https://github.com/danieljoppi/AntHocNet/issues/62))

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) · [Methodology](../methodology.md)

## What it stresses

Two teams of nodes, out of radio range of each other, joined by a chain of
bridge nodes that withdraws and comes back. While the field is split, half
the flows have unreachable destinations. That is where failure-recovery
machinery either backs off or storms. Two past AntHocNet bugs were exactly
that, and both were found late, through benchmark forensics:

- the linkfail broadcast storm ([#20](https://github.com/danieljoppi/AntHocNet/issues/20));
- the unbounded proactive flood ([#45](https://github.com/danieljoppi/AntHocNet/issues/45)).

This scene catches that class on every PR. It is also the partition building
block for the disaster family ([#580](https://github.com/danieljoppi/AntHocNet/issues/580)).

## Configuration

| item | value |
|---|---|
| teams | 20 nodes each, random waypoint inside their own 600 × 300 m box, 1–5 m/s, pauses 0–30 s |
| gap | 800 m between the boxes (x 600 → 1400 m), at 300 m disk range: no link crosses it |
| bridges | 3 nodes. Merged, they sit at x = 720, 960 and 1200 m, 240 m apart, and link both boxes. Split, they withdraw to x = 1000 m, 400 m from either box. They move at 20 m/s, so each transition takes about 12 s |
| phases | merged 0–150 s, split 150–300 s, merged 300–450 s, split 450–600 s, merged 600–750 s, split 750–900 s |
| flows | 10 CBR flows at 2048 bit/s (4 × 64 B/s), each to its own destination: 3 inside team A, 2 inside team B, 3 A → B, 2 B → A |
| channel | disk (`--propagation=range --range=300`), 802.11b at 2 Mbit/s |

The scene is generated, not hand-written:
`python3 tools/bench/partition_scene.py gen --out DIR --seed 1` writes an
ns-2 movement trace and a flow file for `anthocnet-compare --mobility=trace
--traceFile=… --flowsFile=…` ([#639](https://github.com/danieljoppi/AntHocNet/issues/639)).
The flow file's `#` header records the phases and which flows cross, so the
checker reads the scene from the same file the run used.

## What is measured

Under `--diag --seriesEvery=1`, the harness prints one `# series` line per
second for each run. Each line carries:

- the cumulative routing-control count (NRL's numerator);
- AntHocNet's ant transmissions by type;
- each flow's delivered packets.

Nothing is scheduled without the flag, so every other run is unchanged.
`partition_scene.py check FLOWS RESULTS` reads those lines and reports three
things.

- **Bounded control while split.** In each split phase, after a 30 s settle,
  it compares the control rate of the second half against the first. A storm
  grows; a bounded protocol plateaus. It FAILs when the second half exceeds
  1.5× the first plus 1 pkt/s.
- **The split is real.** No crossing flow may deliver once the bridges have
  withdrawn. If one does, the scene's geometry is broken, not the protocol.
- **Re-convergence.** It measures the time from each merge to each crossing
  flow's first delivery after it. With `--strict`, it FAILs when a crossing
  flow is still silent 60 s after a merge.

## The CI gate

`tools/checks/check-partition.sh` runs AntHocNet on seed 1 of this scene,
900 s on the ns-3.42 leg (about 4 min), and applies the checker with
`--strict`. The checker's own self-test
(`tools/bench/test_partition_scene.py`) feeds it synthetic runs:

- a plateau, which must pass;
- a rate that climbs through the split (the #45 shape), which must fail;
- a crossing flow that delivers while split, which must fail;
- a crossing flow that never rejoins, which must fail under `--strict`.

The gate is on AntHocNet, the protocol under test. The baselines are
reported, not gated. AODV's route requests come in bursts, so its
half-against-half ratio varies by seed: 0.6× to 1.32× on the two seeds below.

## Measured (ns-3.42, scene seed 1, 2 seeds, 900 s)

| protocol | PDR % | control while split (pkt/s) | rate growth within a split | re-join after a merge: median / max |
|---|---|---|---|---|
| AntHocNet | 63.3 / 62.7 | 232–277 | 0.93–1.17× | 12 s / 36–39 s |
| AODV | 64.1 / 63.5 | 113–240 | 0.59–1.32× | 15–16 s / 17–18 s |
| OLSR | 57.5 / 58.0 | 23–25 | 1.00–1.07× | 32 s / 47 s |
| oracle | 65.7 / 65.7 | 0 | — | 12 s / 12 s |

The two seeds are shown as seed 1 / seed 2, or as the range over both. The
oracle's re-join time, 12 s, is the bridges' travel time: it is the floor
for any protocol. PDR is about 65 % for everyone because the five crossing
flows lose half the run to the partition by construction.

**A finding, filed as [#723](https://github.com/danieljoppi/AntHocNet/issues/723).** While the field is split, AntHocNet's
reactive ants rise from about 40 pkt/s (merged, first phase) to 196–218
pkt/s. These are route-setup retries toward the unreachable destinations.
The rate is bounded, so the gate passes. But it is about 10× OLSR's whole
control traffic, and it decays slowly after the merge: 152 pkt/s of
reactive ants in the merged phase that follows the first split. A
destination-unreachable back-off is the obvious candidate. It is a protocol
change, so it is measured and decided on its own issue, not here.

These are 2-seed numbers, for the gate's thresholds. A 20-seed cell with
CIs comes with the disaster family's campaign, which builds on this scene.
