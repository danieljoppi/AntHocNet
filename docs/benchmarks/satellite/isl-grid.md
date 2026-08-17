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
> nothing comparative was published from this suite before. Reproduce the
> base-torus results at commit `0f7a3ab`; the
> [#432 adversarial cells](#the-adversarial-cells-corridor-and-failcell-432)
> carry their own provenance (corridor/failcell `820f5cf`, seam cell
> `5220bd0`).

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
  described [below](#the-congestion-cell-216-cell-1)) — **now measured with
  the oracle arm**, [below](#the-adversarial-cells-corridor-and-failcell-432);
- **scripted ISL breaks**
  ([#260](https://github.com/danieljoppi/AntHocNet/issues/260)) — **now
  measured with the oracle arm**,
  [below](#the-adversarial-cells-corridor-and-failcell-432);
- **larger or less regular constellations** — this one now has a designed,
  measured answer: the [#432](https://github.com/danieljoppi/AntHocNet/issues/432)
  item 3 **seam cell** (a deliberately irregular 6×6 torus with the rows-axis
  wrap seam cut, [PR #453](https://github.com/danieljoppi/AntHocNet/pull/453))
  was measured at 20 seeds with the oracle arm,
  [below](#the-seam-cell-static-irregularity-also-ties-the-floor-432-item-3) —
  and **static irregularity also cannot discriminate** on this substrate.
  Headline discrimination in the static suite comes only from load (the
  corridor) or an event instrument (the failcell); the residue of item 3
  (dynamics/churn) is subsumed by
  [#297](https://github.com/danieljoppi/AntHocNet/issues/297).

The recommendation this section used to close on — add the `oracle` arm to
those cells before any satellite comparison is published — **was followed**:
both instrumented cells ran with the control beside them, and the control
stayed *exact* on the cut-ISL topology too (a downed interface simply drops
out of the `Channel` adjacency).

## The adversarial cells: corridor and failcell (#432)

> **Provenance — measured at `820f5cf`, 20 seeds per cell, with the exact
> control.** Both cells are from the
> [#432](https://github.com/danieljoppi/AntHocNet/issues/432) dispatch
> ([dispatch record + pre-registered expectations](https://github.com/danieljoppi/AntHocNet/issues/432#issuecomment-5305417841)):
> `ref=main`, `commit=820f5cfa2295baf8f7b734ece862bd93747b2521`,
> `image=ghcr.io/danieljoppi/ns3:3.42-opt`, `profile=release`,
> `harness=isl-grid`, 900 s, 20 seeds (1–20),
> `protocols=anthocnet,aodv,olsr,oracle` (the pinned canonical order).
> Corridor cell: run
> [31922945507](https://github.com/danieljoppi/AntHocNet/actions/runs/31922945507).
> Failcell: run
> [31922957019](https://github.com/danieljoppi/AntHocNet/actions/runs/31922957019).
> Every number below is a 20-seed mean computed by script from the per-seed
> `##RUN##` / `# corridor` / `# failcell` rows (`bench_parse.py` plus a
> diagnostic-line reducer — nothing eyeballed or hand-averaged); `±` is a
> 95 % t-CI half-width, `boot[lo,hi]` a percentile-bootstrap 95 % interval
> (delay99), and `[lo,hi]` after a paired difference is the paired per-seed
> 95 % t-CI. Both cells passed `scenario_check.py results` (0 fail, 0 warn).
> Reproduce this section's results at commit `820f5cf`.

These are the first two adversarial regimes, each re-run with the `oracle`
arm beside it as recommended above — and they are the suite's **first
discriminating satellite results**. In one sentence each: the corridor cell
separates the arms on the headline delay metric, and AntHocNet beats the
congestion-blind bound on it (with a mechanism caveat that belongs in every
quote of that claim); the failcell still cannot separate anyone on headline
metrics, but its reconvergence instrument now discriminates — OLSR
reconverges 5× slower than the oracle's floor while AntHocNet and AODV sit
statistically on it. A third cell — the [#432 item 3 **seam
cell**](#the-seam-cell-static-irregularity-also-ties-the-floor-432-item-3),
measured after these two — closes the adversarial-design question for the
*static* suite: even genuine topological irregularity does not move the
headline metrics off the bound.

### The corridor cell: beating the congestion-blind bound (#216 cell 1 / #280)

Cell: 6×6 torus (36 satellites, 72 ISLs), 5 ms / 10 Mbps,
`--corridorLoad=12Mbps --corridorLoadAt=15` (ρ = 1.2 — the documented
deliberate overload of the east corridor's second link), `--flows=0`, so the
headline `##RUN##` row **is** the probe flow `(0,0)→(0,3)` over two equal
3-hop corridors (the #280 zero-new-parsing contract). The AntHocNet arm runs
at **shipped defaults** (`EnableMacMetric` off): this cell's question is
where the *shipped* protocols sit against the exact bound; the
mac-metric/gate mechanism ladder stays on
[#216](https://github.com/danieljoppi/AntHocNet/issues/216)/[#180](https://github.com/danieljoppi/AntHocNet/issues/180).

| protocol | probe PDR % | delay (ms) | delay99 (ms) | NRL | clean-corridor seeds |
|---|---|---|---|---|---|
| anthocnet | 100.00 ±0.00 | 55.6 ±19.4 | 57.5 boot[40.9, 74.1] | 36.62 ±0.05 | 10/20 |
| aodv | 99.93 ±0.01 | 97.3 ±0.1 | 99.0 boot[99.0, 99.0] | 36.38 ±0.04 | 0/20 |
| olsr | 100.00 ±0.00 | 68.7 ±18.9 | 70.0 boot[53.4, 86.5] | 39.44 ±0.05 | 7/20 |
| **oracle** | **100.00 ±0.00** | **97.2 ±0.1** | **99.0 boot[99.0, 99.0]** | **0.00** | **0/20** |

("Clean-corridor seeds" = seeds whose `# corridor` line shows the majority
of post-`loadStart` probe packets leaving on the clean west corridor.)

**The cell discriminates, and the pre-registered headline happened: an arm
beat the bound.** The oracle routes the probe through the loaded corridor in
all 20 seeds (`viaLoaded≈3536 viaClean=0`, probe delay 97.19 ±0.13 ms): its
Dijkstra tie-break picks east in every seed, and being blind to congestion
by construction it stays there while the 12 Mbps background saturates the
link. AntHocNet's probe delay is lower by a paired per-seed difference of
**−41.6 ms, 95 % CI [−60.9, −22.2]** at the same 100.00 % probe PDR, and its
delay99 (57.5 boot[40.9, 74.1]) sits far below the bound's 99.0.

**This is not a paradox, and it must never be quoted as "faster than
optimal".** The oracle is a *shortest-path* bound: exact on topology, blind
to load by construction — which is the reason this cell exists (the
[#202 survey](../../satellite-routing-prior-art.md) §6's "congestion the
precomputed control cannot see"). On a saturated corridor the shortest path
is not the fastest path, so the bound's *delay* is beatable here precisely
because the cell was built to make it beatable; its PDR and its NRL = 0.00
remain the bounds they always were.

**The mechanism caveat that belongs in every quote of the claim.** The
per-seed `# corridor` lines are all-or-nothing: every arm's every seed sends
essentially 100 % of post-`loadStart` probe packets down a single corridor.
AntHocNet locks clean-west in 10/20 seeds (15.2–15.5 ms) and loaded-east in
10/20 (92.3–97.4 ms), with **no seed shifting corridors after the load
arrives** — the `# pher` traces show both corridors hold pheromone at load
onset, then the unused corridor's entry evaporates to zero and never
re-forms at the source. The #216 round-2 lock-in observation therefore
**persists at 900 s**; session length did not break it (follow-up (a) of the
[round-2 readout](https://github.com/danieljoppi/AntHocNet/issues/216#issuecomment-5153883684),
now answered). What beats the bound is not measured congestion adaptation
but *initial-choice diversity*: the stochastic ant choice lands half the
seeds on the corridor that will stay clean, and lock-in keeps them there.
OLSR makes the same point from the other side: a purely load-blind hop-count
protocol also "beats the bound" (−28.4 ms, 95 % CI [−47.2, −9.6]) on nothing
but seed-dependent tie-breaking (7/20 clean seeds, at the identical
15.2 ms), and AntHocNet vs OLSR is statistically indistinguishable on this
cell (paired −13.1 ms, 95 % CI [−41.6, +15.3]). AODV, which commits its
discovery-time route on the quiet net and keeps it, ties the bound exactly
(+0.1 ms, 95 % CI [−0.0, +0.3]) and is the only arm below 100 % probe PDR
(99.93 ±0.01 — tail-drops on the saturated ISL).

The quotable claims, in full: **(1)** this is the suite's first cell where
headline metrics separate the arms, at 20 seeds with CIs; **(2)** AntHocNet
at shipped defaults beats the congestion-blind shortest-path bound on probe
delay with a paired CI excluding zero — the first legitimate satellite
"beats-the-bound" claim, valid only with the shortest-path qualifier
attached; **(3)** at shipped defaults the advantage is corridor lottery plus
lock-in, not observed load-shifting — AntHocNet does not separate from
load-blind OLSR here. Whether `EnableMacMetric=true` turns 10/20 clean seeds
into 20/20 is exactly the #216/#180 mechanism ladder, deliberately not part
of this dispatch.

### The failcell: reconvergence at the oracle floor (#260)

Cell: the published base-torus cell exactly (4×4, 8 flows) plus one scripted
break — `--breakLink=0,0,3,0 --breakAt=450` cuts the ISL `(0,0)–(3,0)`,
which preflight verified lies on a shortest path of flows `0→15` and `3→12`;
equal-cost alternates survive on the torus, and 450 s of post-break run
remain. The oracle's recompute cadence is 1 s, and every seed self-reports
`changes=2 noRoute=0` — the initial solve plus exactly one post-break
recompute, never without a route.

| protocol | PDR % | delay (ms) | delay99 (ms) | NRL | tReconverge (s) |
|---|---|---|---|---|---|
| anthocnet | 100.00 ±0.00 | 10.16 ±0.00 | 11.0 boot[11.0, 11.0] | 2.12 ±0.00 | 0.91 ±0.10 |
| aodv | 99.95 ±0.00 | 10.18 ±0.01 | 11.0 boot[11.0, 11.0] | 2.00 ±0.00 | 0.95 ±0.11 |
| olsr | 99.93 ±0.02 | 10.15 ±0.00 | 11.0 boot[11.0, 11.0] | 1.89 ±0.02 | 4.49 ±1.03 |
| **oracle** | **100.00 ±0.00** | **10.15 ±0.00** | **11.0 boot[11.0, 11.0]** | **0.00** | **0.86 ±0.11** |

**On headline metrics the break cell still does not discriminate — that is
the finding, and it is worth stating plainly.** A single cut ISL with
equal-cost alternates on a static lossless torus is absorbed at ~100 % PDR /
10.2 ms by every arm; the visible cost of the entire event is ≤ 0.07 pp of
PDR (aodv 99.95, olsr 99.93 — the packets lost inside each arm's
reconvergence window), far below any materiality threshold. This is the
measured confirmation of the prediction that kept #432 item 3 undispatched:
a topology event the routing can absorb does not move headline numbers on
this substrate; only an instrument aimed at the event window sees it.

**The instrument, however, now discriminates — and no arm beats the floor.**
The oracle's 1 s recompute cadence puts its reconvergence floor at
0.86 ±0.11 s, inside the pre-registered ≤ 1 s. AntHocNet (0.91 ±0.10 s) and
AODV (0.95 ±0.11 s) sit statistically **on** that floor — paired differences
+0.05 s [−0.13, +0.23] and +0.09 s [−0.08, +0.27], both CIs spanning zero —
while **OLSR reconverges 5× slower**: 4.49 ±1.03 s, paired +3.63 s
[+2.55, +4.71] above the floor, the cost of waiting out its periodic
HELLO/TC machinery instead of reacting to the loss event. Pre-registered
expectation 2 is confirmed: nobody beats the topology-change floor; the
comparison is who reaches it, and two of the three real arms do.

Read `tDetect`/`tReconverge` with the documented caveats
([above](#what-this-suite-is-and-is-not)): `tDetect` is 0.00 in all 20
AntHocNet seeds *by construction* for a scripted break (the interface-down
fast path is the detection; the baselines expose no detection trace —
theirs is `nan`), and `tReconverge` is a proxy whose per-seed minima
(0.22–0.38 s across arms) include the ~125 ms CBR-gap contribution of
unaffected flows.

### The seam cell: static irregularity also ties the floor (#432 item 3)

> **Provenance — measured at `5220bd0`, 20 seeds, with the exact control.**
> Run [31985601548](https://github.com/danieljoppi/AntHocNet/actions/runs/31985601548),
> `ref=main`, `commit=5220bd0d6275413d58b9701d944b45d5496462d3`,
> `image=ghcr.io/danieljoppi/ns3:3.42-opt`, `profile=release`,
> `harness=isl-grid`. Cell: 6×6 +Grid torus with the rows-axis wrap seam
> removed at columns 1–5
> (`--removeLinks=5,1,0,1;5,2,0,2;5,3,0,3;5,4,0,4;5,5,0,5` — 67 ISLs, degree
> min 3 / max 4, mean 3.72, connected), 5 ms / 10 Mbps, 8 standard flows
> (`i → 35−i`), cbrBps 4096, 900 s, seeds 1–20,
> `protocols=anthocnet,aodv,olsr,oracle` (the pinned canonical order). Design
> and pre-registration: [PR #453](https://github.com/danieljoppi/AntHocNet/pull/453)
> and the
> [issue design record](https://github.com/danieljoppi/AntHocNet/issues/432#issuecomment-5310762041),
> both written before any 20-seed data existed. Every number below is a
> 20-seed mean computed by script from the per-seed `##RUN##` rows
> (`bench_parse.py`; paired per-seed deltas against the oracle rows via the
> skill's `stats_util` — nothing eyeballed or hand-averaged); `±` is a 95 %
> t-CI half-width, `boot[lo,hi]` a percentile-bootstrap 95 % interval
> (delay99), and paired `[lo,hi]` a per-seed paired 95 % CI (t for PDR/delay,
> bootstrap for delay99), n = 20 seeds. `scenario_check.py results`:
> **OK (0 fail, 0 warn)**. Reproduce this subsection at commit `5220bd0`.

The cell is the designed answer to "larger or less regular constellations"
([#432](https://github.com/danieljoppi/AntHocNet/issues/432) item 3). The
base torus tied because on a 4-regular torus every alternative is an
equal-cost shortest path, so no routing choice has a price. Cutting the
rows-axis wrap seam at every column but 0 makes choices priced while staying
static, lossless and uncongested: non-uniform degree (3–4), genuine
path-length asymmetry (flow shortest paths 2/4/6/6/4/2/4/6 hops, mean 4.25 —
analytic oracle floor **21.25 ms** mean, **31.0** delay99 in the 1 ms bins),
and the surviving wrap ISL `(0,0)–(5,0)` — "the funnel" — on a shortest path
of all 8 flows, strictly so for two of them (the detour around the open rows
axis costs +4 hops = +20 ms).

| protocol | PDR % | delay (ms) | delay99 (ms) | NRL |
|---|---|---|---|---|
| anthocnet | 100.00 ±0.00 | 21.58 ±0.00 | 31.0 boot[31.0, 31.0] | 4.56 ±0.01 |
| aodv | 99.91 ±0.01 | 21.71 ±0.04 | 31.0 boot[31.0, 31.0] | 4.27 ±0.00 |
| olsr | 100.00 ±0.00 | 21.57 ±0.00 | 31.0 boot[31.0, 31.0] | 4.68 ±0.00 |
| **oracle** | **100.00 ±0.00** | **21.57 ±0.00** | **31.0 boot[31.0, 31.0]** | **0.00 ±0.00** |

**Pre-registered expectation 1 — the exact bound — held.** Every seed
self-reports `##ORACLE## … mode=wired approx=0 nodes=36 edges=134
recomputes=900 changes=1 noRoute=0 nrl=0.00` (134 directed edges = the 67
post-removal ISLs, both directions — the oracle proves it solved the seam
graph, not the full torus). Oracle PDR 100.00, delay99 exactly 31.0 in all
20 seeds, and mean delay 21.57 ±0.00 = the 21.25 ms analytic floor plus a
0.32 ms excess (~0.075 ms/hop at 4.25 mean hops — the same
[#250](https://github.com/danieljoppi/AntHocNet/issues/250)-class per-hop
excess the base cell pays).

**Pre-registered expectation 2 — hop-stretch discrimination — failed: the
predicted mechanism did not occur.** The registered signature was AntHocNet
mean delay above the oracle floor by evaporation lock-in onto
longer-than-shortest funnel-flow paths. The smallest version of that effect
is quantized at the hop: a wrong first hop on a strictly-shortest funnel
flow costs +20 ms on that flow, i.e. **+2.5 ms on that seed's 8-flow mean if
held for the run, +0.25 ms if held for a tenth of it**. Measured: AntHocNet
ties the floor — PDR 100.00 in every seed (paired dPDR all-zero), delay99
exactly 31.0 in every seed (paired d_delay99 all-zero), and paired mean
delay **+0.0165 ms [+0.0102, +0.0228]** — fifteen times smaller than even
the tenth-of-a-run signature, four orders below the +20 ms detour. No seed
in 160 flow-seed combinations shows a held longer path: the stochastic ant
choice plus lock-in landed on true shortest paths every time. OLSR ties the
floor outright (paired dPDR −0.001 pp [−0.002, +0.000], d_delay +0.0025 ms
[−0.002, +0.007], both spanning zero). The secondary NRL prediction is not
attributable: packet-NRL ordering did invert vs the base cell (olsr 4.68 >
anthocnet 4.56 > aodv 4.27 here, vs olsr cheapest on the 4×4), but the grid
size changed with the seam and no full 6×6 reference cell exists, so the
shift cannot be pinned on the seam — noted, not claimed.

**Three paired CIs exclude zero, and none of them is discrimination — the
letter-level deviation from the pre-registration, disclosed.** The outcome-3
clause said "all paired CIs spanning zero"; strictly, three do not:
AntHocNet's +0.0165 ms mean-delay offset, and AODV's **dPDR −0.0925 pp
[−0.1036, −0.0814]** with d_delay **+0.143 ms [+0.108, +0.178]**. All three
are constant sub-hop-quantum offsets, 30–300× below the 5 ms hop price the
cell was built to charge, resolvable only because this substrate's
seed-to-seed dispersion is ~0.01 ms — at that dispersion a paired CI
resolves fixed per-protocol processing cost, not path choice. AODV's PDR
deficit is the flood-discovery startup transient, not a seam effect: ≈ 53 of
57 600 offered packets (≈ 7 per flow) dropped before first routes exist,
present in every prior cell (corridor 99.93, failcell 99.95, and ≈ 0.9 pp at
the PR #453 120 s smoke — a fixed packet count amortized over run length),
with delay99 untouched at 31.0. **The methodological finding travels
forward: on a near-deterministic substrate, "paired CI excludes zero" is not
a sufficient discrimination criterion — the next static-cell
pre-registration must pin an effect-size floor to the hop quantum**
(material fraction of 5 ms; ≥ 1 pp PDR).

**Verdict — pre-registered outcome 3 obtains: static irregularity also
cannot discriminate, and #432 item 3 closes on its falsification branch.**
All three real arms sit at or indistinguishably near the oracle bound at
headline scale — no arm pays a hop anywhere on a deliberately irregular
graph where wrong choices finally had a price. With the corridor and
failcell results above, the static satellite suite's discrimination map is
now complete and consistent: **headline metrics move only under load (the
corridor's instrument); events and now irregularity are absorbed without
headline trace** (the failcell needed its reconvergence instrument; the seam
cell has no instrument left to fall back on — that is its verdict). The
remaining scope of item 3 — dynamics, churn, handover — is **subsumed by the
[#297](https://github.com/danieljoppi/AntHocNet/issues/297) satellite
evaluation-credibility epic**, per the closing criterion pre-registered on
the issue. Honest caveats: the cell is lossless and uncongested *by design*
(that isolation is the point, and also the reason nothing separates); the
1 ms delay99 binning makes 31.0 a coarse ceiling check, not a tail
measurement; and the tie says the arms all *find* shortest paths here — it
says nothing about what they do under the dynamics this cell deliberately
excludes.

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
control row has now run beside **both** instruments — the
[#432 adversarial cells](#the-adversarial-cells-corridor-and-failcell-432)
above — so the failcell and corridor lines carry an upper bound and support
protocol-level claims, with the caveats recorded there.

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
| `removeLinks` | off | [#432](https://github.com/danieljoppi/AntHocNet/issues/432) item 3: static ISL removals — semicolon-separated `r1,c1,r2,c2` endpoint quadruples, each adjacent on the grid (same rules as `breakLink`), never built (absent from t=0, both directions). Makes the constellation deliberately irregular: non-uniform degree, unequal-length alternatives. The remaining graph must stay connected (harness abort; the preflight proves it by BFS) |

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
precomputed control, which has now run beside this cell — see
[the measured corridor result](#the-corridor-cell-beating-the-congestion-blind-bound-216-cell-1--280),
where the OLSR reference did real work: it showed that landing on the clean
corridor does not require congestion awareness. Judge the cell
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

The suite's committed results are
[the v1.5.0 phase-3 base-torus cell](#the-headline-result-the-base-torus-does-not-discriminate)
and [the three #432 adversarial cells](#the-adversarial-cells-corridor-and-failcell-432)
above — all 20 seeds with the exact `oracle` control, so above the
statistical policy's ≥ 10-run bar. The base cell is a *negative* result: it
does not discriminate, so nothing comparative may be quoted from it — which
is also why no interval is attached to a column where four arms report the
same number. The corridor cell is the first *positive* comparative result
(quote it only with its mechanism caveat), the failcell separates the
arms on its reconvergence instrument while confirming the headline-metric
tie, and the seam cell is the suite's second designed negative: static
irregularity also ties the floor, closing the static discrimination map. The pipeline
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
   with the `oracle` arm beside it. Three are now
   [measured](#the-adversarial-cells-corridor-and-failcell-432): asymmetric
   congestion ([#280](https://github.com/danieljoppi/AntHocNet/issues/280)),
   scripted ISL breaks
   ([#260](https://github.com/danieljoppi/AntHocNet/issues/260)), and static
   irregularity (the
   [#432 item 3 seam cell](#the-seam-cell-static-irregularity-also-ties-the-floor-432-item-3)
   — measured, and it ties: of the three static instruments, only load
   moves headline metrics). Still open: the handover cell (no instrument
   yet) and dynamics/churn generally — subsumed by
   [#297](https://github.com/danieljoppi/AntHocNet/issues/297). **A
   satellite comparison published from the base torus would be a comparison
   of four ties.**
2. [#206](https://github.com/danieljoppi/AntHocNet/issues/206) — per-next-hop
   congestion signal, precondition for the congestion cell.
3. [#244](https://github.com/danieljoppi/AntHocNet/issues/244) /
   [#245](https://github.com/danieljoppi/AntHocNet/issues/245) — the directed
   reactive A/B and its open steering hazard.
4. The strategy frame for reading any of it:
   [#192 analysis](https://github.com/danieljoppi/AntHocNet/issues/192)
   (detect+reconverge race, path-stretch cost, bootstrap uniformity).
