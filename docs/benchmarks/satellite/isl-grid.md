# Satellite suite: the ISL grid

**Regime:** satellite / inter-satellite-link mesh — the second of the two
regimes this project measures. The MANET suite (the original) lives under
[`scenarios/`](../../benchmarks.md); why the two regimes are different enough
to need separate suites is [`network-regimes.md`](../../network-regimes.md).

[← Benchmark index](../../benchmarks.md) · [Metrics](../metrics.md) ·
[Methodology](../methodology.md)

> **Provenance — measured at `0f7a3ab`, with the upper-bound control.** These
> are the **first satellite numbers this project has produced against a
> control**, from the v1.5.0 campaign's phase 3
> ([campaign plan](../v1.5.0-campaign.md),
> [#415](https://github.com/danieljoppi/AntHocNet/issues/415)): run
> [31830581632](https://github.com/danieljoppi/AntHocNet/actions/runs/31830581632),
> `ref=main`, `commit=0f7a3ab9f3b7ba837b43bbd2d3fd7e04f7090c1c`,
> `image=ghcr.io/danieljoppi/ns3:3.42-opt`, `profile=release`,
> `harness=isl-grid`. Cell: 4×4 +Grid torus — 16 satellites / 32 ISLs (mean
> degree 4.00) at 5.00 ms / 10 Mbps — 8 flows, 900 s, **20 seeds**,
> `protocols=anthocnet,aodv,olsr,oracle`. They supersede nothing, because
> nothing comparative was published from this suite before. Reproduce this
> page's results at commit `0f7a3ab`.

## The headline result: the base torus does not discriminate

**The [#216](https://github.com/danieljoppi/AntHocNet/issues/216) control now
exists, it ran on this cell, and its first finding is a negative one — all
three real protocols already sit exactly on the upper bound, so this cell
cannot carry a comparative delivery or latency claim in either direction.**

| protocol | PDR% | delay (ms) | delay99 (ms) | thrput (kbps) | NRL | NRL bytes | jitter (ms) |
|---|---|---|---|---|---|---|---|
| anthocnet | 100.0 | 10.2 | 11.0 | 23.35 | 2.16 | 3.63 | 0.00 |
| aodv | 100.0 | 10.2 | 11.0 | 23.34 | 2.03 | 1.06 | 0.01 |
| olsr | 100.0 | 10.2 | 11.0 | 23.29 | 1.93 | 4.76 | 0.00 |
| **oracle** | **100.0** | **10.2** | **11.0** | **23.36** | **0.00** | **0.00** | **0.00** |

### The control is exact here

On this topology the oracle arm
([#419](https://github.com/danieljoppi/AntHocNet/pull/419)) is not an
approximation of an upper bound — it *is* one. Every seed self-describes as

```
##ORACLE## <seed> oracle mode=wired approx=0 nodes=16 edges=64 recomputes=900 changes=1 range=-1.0 noRoute=0 nrl=0.00
```

- `mode=wired approx=0` — adjacency comes from ns-3 `Channel` co-membership,
  so on point-to-point ISLs **the graph *is* the wiring**; there is no radius,
  no propagation model and nothing to guess (`range=-1.0`).
- `edges=64` directed edges = the 32 ISLs of the 4×4 torus, both directions.
- `recomputes=900 changes=1` — the edge rebuild runs every second for the
  whole 900 s run, but the topology is static, so **one Dijkstra solve covers
  the entire run**.
- `noRoute=0` and `nrl=0.00` — never without a route, and not one routing
  packet on the wire.

That is the contrast with the MANET suite, where the same arm runs
`approx=1` against a geometric disk and is therefore a reference point rather
than a proven bound — see [the grid page](../grid.md) for what that costs
there (do not carry its numbers across regimes).

### What the tie means

PDR, mean delay and `delay99` are **identical to the bound on all three real
protocols**. The 10.2 ms is simply two ISL hops at 5.00 ms — the analytic
floor this page already gates on — plus the small unattributed excess tracked
in [#250](https://github.com/danieljoppi/AntHocNet/issues/250), which the
oracle now shows is not a protocol artefact: the control pays it too. On a
static,
lossless, uncongested 4-regular torus every protocol finds a shortest path;
there is no routing difficulty here to be better or worse at.

So **no delivery or latency claim can be made from this cell in either
direction**: a protocol cannot beat 100 % / 10.2 ms, and failing to separate
the protocols here says nothing about them.

This is exactly the service the control provides, and nothing else could have
provided it. **Before the oracle arm existed, "all three protocols deliver
100 %" was indistinguishable from "all three protocols are excellent here."**
The oracle shows the ceiling was touching the floor.

### The only separating axis is overhead

Routing overhead is the only axis that separates the arms at all. (Throughput
spans 23.29–23.36 kbps and jitter 0.00–0.01 ms across all four rows — that is
the arms agreeing, not differing.)

**NRL** — olsr 1.93 < aodv 2.03 < anthocnet 2.16, against the oracle's exact
**0.00**.

But `nrl_bytes` **reorders that ranking** — aodv 1.06 < anthocnet 3.63 < olsr
4.76 — which is its own caution: OLSR sends the fewest control *packets* and
the most control *bytes*. Quote both, or neither; never NRL alone. (Both
metrics are defined in [metrics](../metrics.md).)

### Where discrimination has to come from instead

The harness is now validated end to end — anchors, determinism, and the
control — but the base torus cannot carry a comparative result. Discrimination
must come from the adversarial cells this suite already anticipates:

- the **asymmetric-congestion corridor**
  ([#280](https://github.com/danieljoppi/AntHocNet/issues/280), instrument
  described [below](#the-congestion-cell-216-cell-1));
- **scripted ISL breaks**
  ([#260](https://github.com/danieljoppi/AntHocNet/issues/260));
- **larger or less regular constellations**, where a shortest path is not
  trivially reachable by everyone.

**Recommendation: add the `oracle` arm to those cells before any satellite
comparison is published.** The incremental cost is one arm per cell, and the
control stays *exact* on any wired topology — including a torus with a cut
ISL, since a downed interface simply drops out of the `Channel` adjacency.

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
link churn. That makes it the quiet-cell instrument — and the measured
answer is sharper than the expectation this page used to record. It said the
[#216](https://github.com/danieljoppi/AntHocNet/issues/216) precomputed
shortest-path control was *expected to win* here and AntHocNet *expected to
lose*; [with the control measured](#the-headline-result-the-base-torus-does-not-discriminate),
neither happened — every protocol ties the bound exactly, and the cell
discriminates nothing. Of the adversarial cells that could separate them
(unpredicted ISL loss, asymmetric congestion, handover churn), the first
**two have instruments**:

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

The handover cell is still #216's scope and does not exist yet. The #216
control row now exists and has run **on the base torus cell only** — so the
failcell and corridor lines still have no upper bound beside them and still
support harness-validation claims, not protocol-advantage claims, until they
are re-run with the `oracle` arm.

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
| `protocols` | anthocnet,aodv,olsr,oracle | `anthocnet,aodv` is the [#250](https://github.com/danieljoppi/AntHocNet/issues/250) hop-delay discriminator pair; `oracle` is the [#419](https://github.com/danieljoppi/AntHocNet/pull/419) exact upper bound. **`dsdv` is not available in this suite** — see below |
| `breakLink` / `breakAt` | off | [#260](https://github.com/danieljoppi/AntHocNet/issues/260) scripted single-ISL break: endpoints `r1,c1,r2,c2` + cut time (s); emits `# failcell` detect/reconverge lines |
| `corridorLoad` / `corridorLoadAt` | off / 15 | [#216](https://github.com/danieljoppi/AntHocNet/issues/216) cell 1: background rate (e.g. `12Mbps`) loading one of two equal-length corridors, switched on at `corridorLoadAt` (s); emits `# corridor` path-shift lines. Needs `torus=true` and even `cols` ≥ 4 |

### Why `dsdv` is not one of the arms ([#420](https://github.com/danieljoppi/AntHocNet/issues/420))

**This table used to list `anthocnet,aodv,olsr,dsdv` as the default protocol
list. That list never ran.** DSDV has been an arm of `isl-grid.cc` since the
file was added, and it has aborted on every multi-ISL grid since — the
suite's own documented default was never once exercised end to end. It
surfaced only when the [#415](https://github.com/danieljoppi/AntHocNet/issues/415)
campaign asked for all five arms and the process died, with an empty stderr,
straight after the `olsr` rows. This is a **latent defect, not a regression**;
the narrowing above is a correction of the documentation to what the harness
can actually measure, not a quiet retreat from a working configuration.

The cause is in ns-3's `dsdv::RoutingProtocol`, and it is structural rather
than a tuning problem. DSDV there is written for a node with exactly one
non-loopback interface: when it advertises itself it hardcodes
`m_ipv4->GetAddress(1, 0)`, so a satellite holding four ISLs announces only
the address of the first one. Its peers, however, learn next hops from the
*source address of the update*, which is the address of the `/30` the update
arrived on — three of the four are addresses DSDV never advertised. The
next-hop lookup in `LookForQueuedPackets()` therefore misses, its return value
is not checked, and the packet is forwarded on a default-constructed
`Ipv4Route` whose output device is null. `Ipv4L3Protocol::SendRealOut` asserts
on that in a debug build (`cond="interface >= 0"`) and indexes the interface
list with `-1` in the optimised profile the campaign runs — hence a SIGSEGV
with nothing on stderr.

There is no fix on this side of the boundary. One interface per link *is* the
ISL mesh (it is the shape [#203](https://github.com/danieljoppi/AntHocNet/issues/203)
exists for), so the harness rejects the combination up front with an
explanatory message instead of dying mid-campaign. The rejection is keyed on
the **topology**, not on the arm: the 1×2 single-ISL grid used by the
[#237](https://github.com/danieljoppi/AntHocNet/issues/237) anchors gives every
node one interface, and DSDV is correct there. DSDV remains a full baseline in
the MANET suite, where every node has a single wifi interface and the
assumption holds.

`ns3/tools/check-sat-arms.sh` runs every supported arm on a small torus per PR
so a defect of this class cannot reach a campaign dispatch again.

`dsdv` is therefore **absent by necessity, not by choice**, and its absence
from the result table above is not a gap in the comparison.

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
`(0,1)→(0,2)` (1000 B packets, rate `corridorLoad`, UDP port 10, **constant
duty** — the OnOff default of 1 s on/1 s off would oscillate the queue
empty→full→empty every 2 s, and an ant sampling the off-phase reads zero
backlog; the first dispatches measured exactly that) loads the
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
numbers. AntHocNet runs additionally emit a `# pher` line every 30 s from
`loadStart` — the probe source's regular/virtual pheromone toward each
corridor's first hop for the probe destination
(`# pher <proto> seed=<s> t=<t> eastR=<> eastV=<> westR=<> westV=<>`) — the
mechanism trace for arms that fail to shift: it shows whether a
clean-corridor gradient ever forms at the source and whether diffusion (the
`V` columns) feeds it. **Pass criterion:** the congestion-aware arm
(`--ns3::anthocnet::RoutingProtocol::EnableMacMetric=true`) moves probe
traffic off the loaded corridor (`viaClean` dominates, or at least the
loaded share drops materially vs the blind arms) *and* its
`probePdr`/`probeDelayMs` beat the blind control's on the same seeds.

**Read it honestly:** the background flow is itself routed by the protocol
under test — real cross-traffic is — so an adaptive arm may *spread* the load
across both corridors rather than leave it east; and AntHocNet's default
wall-clock ant metric also feels queueing delay, so the mac-metric-OFF arm is
not fully blind. The truly load-blind references are the hop-count baseline
(OLSR — not DSDV, which cannot run here at all, above) and the #216
precomputed control, which now exists and should be added to this cell before
anything comparative is read out of it. Judge the cell
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
  (`check-determinism.sh … isl-grid`);
- **arms actually run**: `check-sat-arms.sh` exercises every arm this page
  advertises, so an unrunnable default cannot stay latent again
  ([#422](https://github.com/danieljoppi/AntHocNet/pull/422); the DSDV case
  above is why it exists).

Values live in [`ns3/tools/anchors.yml`](../../../ns3/tools/anchors.yml);
the gate is [`ns3/tools/check-sat-anchors.sh`](../../../ns3/tools/check-sat-anchors.sh)
(#237/#238). Known open question against the hop-delay floor: the ~0.25 ms
excess tracked in [#250](https://github.com/danieljoppi/AntHocNet/issues/250)
— inside the slack, not yet attributed.

## Results

The suite's first committed result is
[the v1.5.0 phase-3 base-torus cell](#the-headline-result-the-base-torus-does-not-discriminate)
above — 20 seeds, with the exact `oracle` control, so it is above the
statistical policy's ≥ 10-run bar. It is a *negative* result: the cell does
not discriminate, so nothing comparative may be quoted from it — which is also
why no interval is attached to a column where four arms report the same
number. The pipeline
that lands and gates results is
real ([#259](https://github.com/danieljoppi/AntHocNet/issues/259)) — the same
dispatch → rescue → validate → parse loop the MANET suite runs, so no
satellite number is ever eyeball-only. When results do land here they fall
under the [statistical policy](../methodology.md#statistical-policy-293):
published points need ≥ 10 runs with 95% CIs, **except** the analytic anchor
cells (`single-isl`, `hop-delay`), which are derivation checks on
deterministic point-to-point links — those stay low-run and are read as
**diagnostic identities, not estimates** (#318 wording pass):

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

What the suite is waiting on, in dependency order. **The control is no longer
one of them** — [#419](https://github.com/danieljoppi/AntHocNet/pull/419)
built it, [#415](https://github.com/danieljoppi/AntHocNet/issues/415) measured
it, and it runs `approx=0` here. What the suite waits on now is a cell where
the control's answer and the protocols' answers can differ at all:

1. **Discriminating cells** — the adversarial regimes under
   [#216](https://github.com/danieljoppi/AntHocNet/issues/216), each re-run
   with the `oracle` arm beside it: asymmetric congestion
   ([#280](https://github.com/danieljoppi/AntHocNet/issues/280)), scripted ISL
   breaks ([#260](https://github.com/danieljoppi/AntHocNet/issues/260)), the
   handover cell (no instrument yet), and larger or less regular
   constellations. **A satellite comparison published from the base torus
   would be a comparison of four ties.**
2. [#206](https://github.com/danieljoppi/AntHocNet/issues/206) — per-next-hop
   congestion signal, precondition for the congestion cell.
3. [#244](https://github.com/danieljoppi/AntHocNet/issues/244) /
   [#245](https://github.com/danieljoppi/AntHocNet/issues/245) — the directed
   reactive A/B and its open steering hazard.
4. The strategy frame for reading any of it:
   [#192 analysis](https://github.com/danieljoppi/AntHocNet/issues/192)
   (detect+reconverge race, path-stretch cost, bootstrap uniformity).
