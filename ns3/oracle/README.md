# Oracle shortest-path control — design, exactness and cadence

The global-knowledge upper bound for both benchmark suites —
[#415](https://github.com/danieljoppi/AntHocNet/issues/415), i.e.
[#296](https://github.com/danieljoppi/AntHocNet/issues/296) item 1, folding the
control half of [#216](https://github.com/danieljoppi/AntHocNet/issues/216) /
[#196](https://github.com/danieljoppi/AntHocNet/issues/196). Off by default;
it runs only when `--protocols` names `oracle`.

**How to read an oracle number** — which arm is an anchor, which is a
competitor and which is a bound — is in
[`docs/benchmarks/methodology.md`](../../docs/benchmarks/methodology.md#baselines-what-each-arm-is-for-296)
and is not repeated here. This page is the *implementation*: where the edges
come from, what "exact" means per channel, and what the recompute cadence
costs.

It is **a control, not a protocol**, and every design decision below follows
from that. AODV/OLSR/DSDV are *replication anchors* (they are what the 2004/2005
papers compared against) and GPSR is a *competitive-frontier* baseline; none of
them answers the question a reviewer asks first — **how much of the gap is the
protocol's fault and how much is the network's?** The oracle answers it, and on
a constellation it is the baseline the LEO literature holds every result to.

## What it does

One `oracle::Topology` object per simulation holds the ground-truth graph and
the all-pairs next-hop table. Every node's `oracle::RoutingProtocol` reads that
one table.

| Property | Value | Why it is that way |
|---|---|---|
| Control traffic | **exactly none** | No socket is opened. No hello, no request, no reply. NRL is 0 by construction, and both harnesses `NS_ABORT` if a single control packet is counted on this arm. |
| Discovery latency | **none** | The next hop is known before the first packet is offered (first solve at `t = 0`). There is no pending-packet queue, so the measured delay is queueing + propagation over a shortest path and nothing else. |
| No route | **immediate drop** | `ERROR_NOROUTETOHOST`, no queue, no retry, no discovery. A packet the oracle cannot place is one the network could not have carried. |
| Learning | **none** | Nothing a node knows came from another node. |
| Randomness | **none** | `AssignStreams` returns 0. The arm is bit-reproducible without a seed. |
| Metric | **hop count** (unit edge weight) | Makes "no protocol routes the same packet in fewer hops" an assertion, not a hope. |

The Dijkstra + first-hop layer is not in this module: it is
`core/shortest_path.{h,cpp}`, simulator-agnostic and covered by
`core/tests/test_shortest_path.cpp` (AGENTS.md rule 7) against hand-built
graphs — a diamond with a deliberate equal-cost tie and an unreachable node, a
weighted variant, a directed pair, and a 3×3 +Grid torus where every distance
is the closed-form wrapped Manhattan distance. Equal-cost paths are broken
deterministically (**smallest first hop wins**), so the next-hop table is a
pure function of the edge set and not of container iteration order — the #352
reproducibility failure in a different guise.

## Where the edges come from, and where the oracle is exact

Adjacency is derived per interface, from the simulator's own objects, by device
class. **The oracle never assumes a disk.** Interfaces that are administratively
down (`Ipv4::IsUp`) are excluded, which is what makes a scripted ISL break
([#260](https://github.com/danieljoppi/AntHocNet/issues/260)) visible to the
control with no extra plumbing.

| Channel | Rule | `mode=` | Exact? |
|---|---|---|---|
| Not a `WifiNetDevice` — point-to-point ISLs, CSMA | channel co-membership, read off the ns-3 `Channel` | `wired` | **Yes.** The graph *is* the wiring. |
| Wifi whose loss chain is exactly one `RangePropagationLossModel` (`--propagation=range`) | that model's own `MaxRange`, read off the live channel | `disk` | **Yes.** A disk model has a crisp cutoff and this is it. |
| Wifi on a lone `TwoRayGroundPropagationLossModel` (`--propagation=tworay`) | the **decode disk** ([#431](https://github.com/danieljoppi/AntHocNet/issues/431)): the distance at which the deterministic two-ray received power crosses the PHY's decode floor, every parameter read off the installed objects | `decode-approx` | **No — flagged `approx=1`** (propagation-exact, interference-blind; below). |
| Wifi on two-ray + `NakagamiPropagationLossModel` (`--propagation=nakagami`) | the **median disk** (#431): under Nakagami the received power is Gamma-distributed, so P(decode\|d) has a closed form; the P = 1/2 crossing of that form, zero RNG draws | `p50-approx` | **No — flagged `approx=1`** (a probabilistic link has no true radius). |
| Any other wifi channel | the explicit `LinkRangeM` radius — **required** here, an **override** everywhere above | `disk-approx` | **No — flagged `approx=1`.** |

With neither a derivation nor `LinkRangeM` the oracle **aborts** at `t = 0`
rather than guess a radius. `scenario_check.py preflight` knows which
propagation models the harness offers are derivable.

### The fading-channel derivations (#431), and the withdrawn budget rule

Two-ray ground is deterministic, so "derive the adjacency from the channel" is
tempting: compute `Prx = TxPowerEnd + TxGain − loss + RxGain` off the live
propagation chain and call the link real when `Prx >= RxSensitivity`. That was
implemented first and then measured, at paper base (50 nodes, 1500 × 300 m,
60 s, ns-3.36):

```
##ORACLE## mode=budget approx=0 nodes=50 edges=2440 recomputes=60 ...
oracle   PDR 30.4%   delay 1.1 ms   hops 1.00
aodv     PDR 69.6%   delay 102.2 ms hops 1.94
```

**2440 of the 2450 possible directed edges** — a near-complete graph. The
resulting "oracle" routed everything in one hop and delivered **30.4 %** — below
every protocol it exists to bound — so that rule was withdrawn, and for a
release the fading cells were held to the harness's nominal `--range` instead
(300 m, `disk-approx`). That approximation had its own measured cost, #431: the
300 m disk under-reaches the radios by ~40 %, so the oracle used **more hops
than every real arm on the identity-matched packet set in all six published
fading cells** (`rwp-tworay` oracle 1.90 vs anthocnet 1.56) and intermittently
partitioned fields the radios cover (noRoute up to 61 lookups/seed).

The #431 measurement study found the budget rule's actual defect: **it read the
wrong attribute.** `RxSensitivity` (−101 dBm) is where ns-3 stops *attempting*
reception, but `WifiPhyHelper` installs a `ThresholdPreambleDetectionModel` on
every PHY whose `MinimumRssi` (−82 dBm, 19 dB higher) drops any frame below it
at preamble detection regardless of SNR. The binding decode floor is therefore

```
T = max(RxSensitivity, ThresholdPreambleDetectionModel::MinimumRssi)
```

read off the installed PHY exactly the way the disk rule reads `MaxRange` off
the live channel — **no free calibration constant**. From that threshold the
two fading channels get separate, closed-form derivations
(`oracle-decode-budget.{h,cc}`, unit-tested against hand-computed values):

- **`tworay` — the decode disk.** Solve the two-ray loss for the crossing
  distance, in whichever regime it lands (ns-3's model is Friis below the
  crossover `dCross = 4πh_t h_r/λ`, `1/d⁴` beyond; the two agree at `dCross`).
  At the harness's paper PHY that is **423.3 m** (vs the withdrawn rule's
  1264 m and the noise-floor variant's 806 m). Measured against an empirical
  probe of the same PHY, the 423 m disk *is* the zero-load delivery graph:
  99.8 % precision / 99.8 % recall (the 300 m disk: 100 % / 71 %).
- **`nakagami` — the median disk.** The Nakagami power gain is
  Gamma-distributed with shape `m(d)` and mean the two-ray power `P(d)`, so
  `P(decode|d) = Q(m, m·T_W/P_W(d))` (regularized upper incomplete gamma) in
  closed form — matched the empirically probed delivery curve within ~2 pp.
  The P = 1/2 crossing (**373.4 m** at the paper PHY and ns-3's default
  m-profile) is the best single-radius approximation of a link that is
  genuinely probabilistic; the full probability-weighted graph is #431
  direction 2 and deliberately not built.

Why the split, measured (#431, 5 seeds, 20 nodes, 1500 × 300 m): the decode
disk on `tworay` clears the full acceptance bar per seed — oracle PDR ≥ every
arm **and** identity-matched hops ≤ every arm in every seed (at 300 m the hop
bound failed in 10/10 seed×arm combinations). The same 423 m disk on
`nakagami` breaks the delivery bound (a 423 m Nakagami link delivers ~35 % of
frames; an arm beat the oracle in 1 of 5 seeds, p99 blew out to 2.4 s), while
the median disk restores delivery in every seed and cuts the matched-hop gap
an order of magnitude.

**Both derived rules stay `approx=1`.** The decode disk is exact with respect
to propagation and the decode threshold, but decoding under load also depends
on interference and capture, which no disk can carry; `approx=0` stays
reserved for adjacency the scenario itself configured. On these cells the
oracle is a **calibrated reference point, not a proven upper bound** —
`scenario_check.py` still WARNs on every `approx=1` cell, and its per-seed
identity-matched hop gate (ε = 0.05) is the mechanical check that the
calibration holds.

`LinkRangeM` remains as an **explicit override** (it is what lets the #431
A/B hold the oracle to any radius, e.g.
`--ns3::oracle::Topology::LinkRangeM=300`), and is **required** only on a
chain the oracle has no derivation for.

No propagation model is ever *evaluated* — the derivations mirror ns-3's
formulas — which has a second benefit: the oracle takes no draw from the
channel's pinned RNG stream
([#352](https://github.com/danieljoppi/AntHocNet/issues/352)), so the oracle arm
sees the same fading realisation as every other arm rather than a perturbed one.
And because the `tworay` and `nakagami` radii derive from the **same decode
threshold through each channel's own law**, the harness's controlled
{`tworay`, `nakagami`} contrast compares one rule under two channels rather
than two unrelated adjacency definitions.

### What "exact" does and does not claim

Even on the exact rows, exact means *the adjacency is the one the scenario
configured*. It does not mean every packet on an adjacent link arrives: MAC
contention, collisions and interference are still simulated in full, and the
oracle suffers them like everything else. That is the point — the control
removes routing ignorance, not physics. At paper base/range/300 s the oracle
loses 3.06 % of packets to MAC retry exhaustion and 1.00 % to channel loss, with
**0.00 %** to route failure.

## Recompute cadence

Periodic, `RecomputeInterval` (default **1 s**), first solve at `t = 0` before
any traffic.

- **Rebuilding the edge set** is the cheap half and runs every interval.
- **The all-pairs Dijkstra** runs only when the edge set actually changed. A
  static topology therefore costs exactly one solve for the whole run —
  measured on the 4×4 ISL torus: `recomputes=60 changes=1`.

The tradeoff, stated rather than discovered: **an interval of `T` bounds the
oracle's staleness by `T`.** At the paper scenario's 20 m/s a 1 s interval can
be wrong about a link for up to 20 m of node travel — about 7 % of a 300 m
radius. Event-driven recompute was rejected: ns-3's `CourseChange` fires on
waypoint changes, not continuously, so on `RandomWaypoint` it would miss exactly
the link events that matter (two nodes drifting apart mid-leg), and on
`GaussMarkov` it fires every `TimeStep` anyway. A periodic rebuild whose cost is
skipped when nothing moved is both simpler and more honest about what it
guarantees. Lower `RecomputeInterval` if a cell needs a tighter bound; the cost
is O(recomputes × n²) distance checks, and on 50 nodes that is 2450 comparisons
per interval.

## Diagnostics

Each harness prints one line per (seed, oracle) run:

```
##ORACLE## <seed> oracle mode=<tags> approx=<0|1> nodes=N edges=E \
           recomputes=R changes=C range=<m|-1> noRoute=X nrl=<v>
```

`mode` is the "+"-joined set of adjacency rules in force (`wired`, `disk`,
`decode-approx`, `p50-approx`, `disk-approx`); `range` is −1 on an all-wired
topology and the derived (or overridden) radius otherwise; `noRoute` counts
lookups that found no path, i.e. the field partitioned under the oracle's own
topology. `scenario_check.py results` asserts on this row (NRL exactly 0, the
graph was solved, the graph is non-empty, `approx` agrees with `mode`) and
cross-checks the arm against the others in the same cell.

## The assertions, and one that could not be made

`scenario_check.py` (cases in `test_scenario_check.py`, each proved to fire
**and** to stay quiet):

1. **NRL is exactly 0** — on the `##ORACLE##` row and on the results table.
   Asserted in the harnesses too, as `NS_ABORT`, so it holds in optimized
   campaign builds.
2. **No protocol routes the same packet in fewer hops** — asserted two ways:
   on the whole-run mean with a survivorship guard (below), and — since #431 —
   **unguarded on the identity-matched `##COMMON##` set, per seed**: on the
   packets every arm delivered, survivorship is eliminated by construction, so
   `oracle hopsC <= arm hopsC + 0.05` is a real FAIL. The 0.05 is draw-noise
   headroom (per-seed sd of the matched-hop diff measured at 0.03–0.08), not a
   tolerance for structural excess: #431's defect was +0.17 to +0.74 in the
   mean yet ≤ +1 hop for ~96 % of individual packets, so any per-packet or
   ≥ 1-hop tolerance would have stayed green through the whole regression.
3. **Nothing outperforms full knowledge on a static, lossless topology** —
   asserted on ISL-grid cells, and deliberately *not* asserted on the #216
   adversarial cells (congestion corridor, scripted ISL break), which exist
   precisely so the control loses.

**The hop-count assertion needed weakening, and the reason is worth keeping.**
`path_hops_mean` is a mean over *delivered* packets, so it is survivorship-
biased: an arm that delivers less skims the short flows and scores a **lower**
mean hop count without routing anything better. Measured at paper base/range,
300 s, 2 seeds:

| arm | PDR | mean hops |
|---|---|---|
| oracle | 95.9 % | 2.09 |
| aodv | 80.2 % | 2.22 |
| anthocnet | 87.2 % | 2.60 |
| **olsr** | **75.4 %** | **1.90** |

OLSR's mean path is shorter than the oracle's while delivering 20 pp less. A
naive "the oracle must have the fewest hops" rule FAILs on correct data. So the
rule fires only where survivorship cannot explain it: **the other arm delivered
at least as much as the oracle and still shows a shorter mean path.** That is
still falsifiable — it catches a wrong solve, a stale table or a next-hop
mismatch — without firing on the physics of the metric.

## Using it

```bash
# MANET field — the oracle is exact on the disk arm
./ns3 run "anthocnet-compare --scenario=paper --protocols=anthocnet,aodv,oracle"

# satellite +Grid torus — the oracle is exact, full stop
./ns3 run "isl-grid --rows=10 --cols=10 --protocols=anthocnet,aodv,oracle"

# tighter staleness bound on a fast cell
./ns3 run "anthocnet-compare --protocols=oracle,aodv \
           --ns3::oracle::Topology::RecomputeInterval=100ms"
```

Installed by `make install-ns3` into `$(NS3DIR)/contrib/oracle`, alongside the
anthocnet and gpsr modules; it carries the one `core/` source it needs. Existing
arms are untouched — the oracle adds no attribute, no stream and no trace to any
other protocol, and every baseline row stays byte-identical.
