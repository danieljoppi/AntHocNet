# Satellite suite: the ISL grid

**Regime:** satellite / inter-satellite-link mesh — the second of the two
regimes this project measures. The MANET suite (the original) lives under
[`scenarios/`](../../benchmarks.md); why the two regimes are different enough
to need separate suites is [`network-regimes.md`](../../network-regimes.md).

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) ·
[Methodology](../methodology.md)

## What this suite is, and is not

One harness, [`ns3/examples/isl-grid.cc`](../../../ns3/examples/isl-grid.cc):
an R×C **+Grid torus** of point-to-point ISLs — one `/30` subnet per link, so
every satellite holds one interface *per neighbour* (degree 4 on the torus).
That multi-interface shape is the point: it is what the MANET suite can never
exercise, and it is what #203 broke on before [#224](https://github.com/danieljoppi/AntHocNet/pull/224)
fixed next-hop resolution per interface. Metrics mirror `anthocnet-compare`'s
definitions at the same IP-layer counting point, so a number here is comparable
in *kind* (never in regime) to a MANET number.

It is a **static snapshot** grid: no orbital mechanics, no GSL handover, no
link churn. That makes it the quiet-cell instrument — the regime where the
[#216](https://github.com/danieljoppi/AntHocNet/issues/216) precomputed
shortest-path control is expected to win and AntHocNet is expected to lose.
Of the adversarial cells that could show the opposite (unpredicted ISL loss,
asymmetric congestion, handover churn), the first **two have instruments**:

- **Unpredicted ISL loss** —
  [#260](https://github.com/danieljoppi/AntHocNet/issues/260) added a scripted
  single-ISL break (`--breakLink=r1,c1,r2,c2 --breakAt=<s>`, cut via
  `Ipv4::SetDown` on both endpoint interfaces) that reports a per-run
  `# failcell … tDetect=<s> tReconverge=<s>` line.
- **Asymmetric congestion** ([#216](https://github.com/danieljoppi/AntHocNet/issues/216)
  cell 1, unblocked by [#206](https://github.com/danieljoppi/AntHocNet/issues/206)) —
  `--corridorLoad=<rate>` offers background load over one of two equal-length
  corridors and reports a per-run `# corridor` line; see
  [the congestion cell](#the-congestion-cell-216-cell-1) below.

The handover cell is still #216's scope and does not exist yet; until the
#216 control row exists, results from this page — failcell and corridor lines
included — support harness-validation claims, not protocol-advantage claims.

**Read the failcell numbers honestly.** `tDetect` (break → the protocol's
first neighbour-loss event for the severed peer, from the `RouteChanged`
trace; AntHocNet only — the baselines expose no such trace) is ~0 *by
construction* for a scripted break: the adapter's #260 fast path is the
`Ipv4` interface-down notification itself, the only failure signal a
`PointToPointNetDevice` offers (no retry-limit trace; IP drops packets to a
down interface before any device trace can fire). That models an ISL terminal
reporting loss-of-light locally within ms. A *silent* failure — the interface
stays up but frames stop arriving (e.g. a receive-side error model) — is not
covered by the fast path and still waits the full hello timeout,
`helloInterval × allowedHelloLoss` = 2 s at defaults; a failure cell built on
silent loss lower-bounds the protocol, exactly the pre-#260 caveat.
`tReconverge` (break → the last of the per-flow first deliveries after the
break) is a **proxy**: the harness does not know which flows crossed the
broken ISL, so unaffected flows contribute ~one CBR inter-packet gap
(~125 ms at the 64 B / 4096 bps defaults) and only a value clearly above that
gap measures re-convergence.

## Configuration

| knob | default | meaning |
|---|---|---|
| `rows` × `cols` | 4 × 4 | orbital planes × satellites per plane |
| `torus` | true | wrap the edges (+Grid); false = open grid |
| `islDelayMs` | 5 | one-way ISL propagation delay (LEO ISLs are ~3–13 ms) |
| `islRate` | 10Mbps | ISL data rate |
| `flows` / `cbrBps` | 8 / 4096 | CBR load |
| `protocols` | anthocnet,aodv,olsr,dsdv | `anthocnet,aodv` is the [#250](https://github.com/danieljoppi/AntHocNet/issues/250) hop-delay discriminator pair |
| `breakLink` / `breakAt` | off | [#260](https://github.com/danieljoppi/AntHocNet/issues/260) scripted single-ISL break: endpoints `r1,c1,r2,c2` + cut time (s); emits `# failcell` detect/reconverge lines |
| `corridorLoad` / `corridorLoadAt` | off / 15 | [#216](https://github.com/danieljoppi/AntHocNet/issues/216) cell 1: background rate (e.g. `12Mbps`) loading one of two equal-length corridors, switched on at `corridorLoadAt` (s); emits `# corridor` path-shift lines. Needs `torus=true` and even `cols` ≥ 4 |

### The congestion cell (#216 cell 1)

"Congestion the precomputed control cannot see" — the adversarial regime the
[#202 survey](../../satellite-routing-prior-art.md) §6 names first, runnable
since [#206](https://github.com/danieljoppi/AntHocNet/issues/206) gave
`EnableMacMetric` a real per-next-hop signal on ISLs (ADR-0017).

**Construction** (fixed, derived from the grid): probe flow from satellite
`(0,0)` to `(0,cols/2)` at the standard `cbrBps`/64 B. On the torus row ring
there are exactly two shortest paths, each `cols/2` hops — **east**
`(0,0)→(0,1)→…→(0,cols/2)` and **west** `(0,0)→(0,cols−1)→…→(0,cols/2)`;
any path leaving row 0 is ≥ 2 hops longer. A background OnOff flow
`(0,1)→(0,2)` (1000 B packets, rate `corridorLoad`, UDP port 10) loads the
east corridor's second link from `corridorLoadAt` onward — after discovery
has settled on the quiet net, so a reactive baseline has already committed a
route. Hop count cannot distinguish the corridors; only a congestion signal
can. The background load is *offered load*, not traffic under measurement:
port 10 is excluded from the data metrics and from the NRL control counter.

**Output**, one line per (protocol, seed) next to the `##RUN##` row:

```
# corridor <proto> seed=<s> loadStart=<s> viaLoaded=<n> viaClean=<n> viaOther=<n> probePdr=<pct> probeDelayMs=<ms>
```

`viaLoaded`/`viaClean`/`viaOther` count probe data packets by the interface
they leave the source on (east / west / off-row), **from `loadStart` onward**;
`probePdr`/`probeDelayMs` are the probe flow's own whole-run FlowMonitor
numbers. **Pass criterion:** the congestion-aware arm
(`--ns3::anthocnet::RoutingProtocol::EnableMacMetric=true`) moves probe
traffic off the loaded corridor (`viaClean` dominates, or at least the
loaded share drops materially vs the blind arms) *and* its
`probePdr`/`probeDelayMs` beat the blind control's on the same seeds.

**Read it honestly:** the background flow is itself routed by the protocol
under test — real cross-traffic is — so an adaptive arm may *spread* the load
across both corridors rather than leave it east; and AntHocNet's default
wall-clock ant metric also feels queueing delay, so the mac-metric-OFF arm is
not fully blind. The truly load-blind references are the hop-count baselines
(OLSR/DSDV) and, once it exists, the #216 precomputed control. Judge the cell
on the probe's counters and QoS across arms, not on the background's path.
With `--flows=0` the headline `##RUN##`/table row *is* the probe flow, so the
standard pipeline compares the cell without any new parsing.

## How to run it

- **Dispatch** the manual **Satellite benchmark** workflow
  (`satellite-benchmark.yml`) — the regime's counterpart of the MANET
  `paper-benchmark.yml`. Same contract: results file + `time -v` artifact, a
  compact tail block cheap to fetch from the job log, `extraArgs` for ns-3
  attribute overrides (e.g.
  `--ns3::anthocnet::RoutingProtocol::EnableDirectedReactive=true` for the
  [#244](https://github.com/danieljoppi/AntHocNet/issues/244) satellite arm).
- **Locally**, with an ns-3 tree carrying the module:
  `./ns3 run "isl-grid --rows=4 --cols=4 --runs=3 --protocols=anthocnet,aodv"`.

## Validation gates (run on every PR, 3.42 CI leg)

The satellite suite's anchors are **analytic**, and therefore stricter than
the MANET suite's literature-derived ones
([methodology](../methodology.md#validation-anchors-known-expected-results)):
a point-to-point grid with fixed per-link delay has no stochastic channel, so

- **single-isl**: delivery over one ISL must be ≥ `sat_single_isl_pdr_min`
  (99.0 — physics says 100);
- **hop-delay**: mean delay must sit within `sat_hop_delay_slack_ms` (1.5 ms)
  of the analytic floor `hops × islDelayMs`;
- **determinism**: the same seed twice must be byte-identical
  (`check-determinism.sh … isl-grid`).

Values live in [`ns3/tools/anchors.yml`](../../../ns3/tools/anchors.yml);
the gate is [`ns3/tools/check-sat-anchors.sh`](../../../ns3/tools/check-sat-anchors.sh)
(#237/#238). Known open question against the hop-delay floor: the ~0.25 ms
excess tracked in [#250](https://github.com/danieljoppi/AntHocNet/issues/250)
— inside the slack, not yet attributed.

## Results

**No committed results yet**, but the pipeline that lands and gates them is
real ([#259](https://github.com/danieljoppi/AntHocNet/issues/259)) — the same
dispatch → rescue → validate → parse loop the MANET suite runs, so no
satellite number is ever eyeball-only:

1. **Dispatch** `satellite-benchmark.yml` (above). The results file
   (`satellite-results.txt`: `##RUN##` per-seed rows plus the summary table)
   is uploaded as the `satellite-benchmark` artifact (30-day retention).
2. **Rescue** it past expiry with the `rescue-artifacts` workflow
   (`sat_run_ids` input); it is committed as
   `docs/benchmarks/campaign/<runid>-sat.txt`.
3. **Validate** before reading:
   `python3 .claude/skills/benchmark-results/scenario_check.py results FILE`
   understands both the `--csv` schema and the human
   `##RUN##`/table output, runs the generic plausibility rules (PDR bounds,
   delay99 ≥ mean, negatives, dead cells) and adds the satellite invariants —
   mean delay at or above the one-ISL propagation floor (`isl_delay_ms`), and
   the `sat_single_isl_pdr_min` floor from
   [`ns3/tools/anchors.yml`](../../../ns3/tools/anchors.yml) on any AODV row
   whose topology is the 2-node/1-link anchor. A FAIL is a harness bug: do
   not compare, publish, or quote the numbers.
4. **Parse / A/B** with
   `python3 .claude/skills/benchmark-results/bench_parse.py OFF ON` — both
   the text output and `--csv` rows are accepted; the
   [#244](https://github.com/danieljoppi/AntHocNet/issues/244) directed-arm
   and [#250](https://github.com/danieljoppi/AntHocNet/issues/250) comparisons
   are exactly this. Record the verdict + run IDs on the driving issue
   (ADR-0013).

This suite has no per-merge refresh (the MANET quick taxonomy keeps that
job). Do not quote the CI smoke numbers — they are delivery gates at tiny
scale, not measurements.

What the suite is waiting on, in dependency order:

1. [#216](https://github.com/danieljoppi/AntHocNet/issues/216) — the
   precomputed-shortest-path control row and the satellite scenario class in
   the taxonomy (with the adversarial cells). **The control is what makes a
   satellite result a result.**
2. [#206](https://github.com/danieljoppi/AntHocNet/issues/206) — per-next-hop
   congestion signal, precondition for the congestion cell.
3. [#244](https://github.com/danieljoppi/AntHocNet/issues/244) /
   [#245](https://github.com/danieljoppi/AntHocNet/issues/245) — the directed
   reactive A/B and its open steering hazard.
4. The strategy frame for reading any of it:
   [#192 analysis](https://github.com/danieljoppi/AntHocNet/issues/192)
   (detect+reconverge race, path-stretch cost, bootstrap uniformity).
