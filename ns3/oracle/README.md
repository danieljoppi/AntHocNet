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
| Any other wifi channel — `tworay`, `nakagami` | the explicit `LinkRangeM` radius (the harnesses pass their `--range`) | `disk-approx` | **No — flagged `approx=1`.** |

With no `LinkRangeM` set on such a channel the oracle **aborts** at `t = 0`
rather than guess a radius. `scenario_check.py preflight` FAILs the same
combination before the dispatch is spent.

### Why `tworay` gets an approximation and not a link budget

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

**2440 of the 2450 possible directed edges** — a near-complete graph. ns-3
attempts reception ~25 dB below what a frame needs to survive interference
(`RxSensitivity` is −101 dBm; the noise floor for 22 MHz at NF 7 dB is about
−93.6 dBm), so the link budget says every node hears every other node. The
resulting "oracle" routed everything in one hop and delivered **30.4 %** — below
every protocol it exists to bound. An upper bound that loses to the things it
bounds is not an upper bound, so that rule was withdrawn rather than shipped.
The number is recorded here so nobody re-derives it.

What replaced it is the rule this repository's own methodology already implies:
hold the control to the scenario's nominal `--range`. Note the **direction of
the error**, because it is what a reader needs:

- the 300 m disk is *conservative* under two-ray — real two-ray links reach
  further — so the oracle uses a **subset** of the links that actually work;
- therefore on `tworay`/`nakagami` the oracle is a **reference point, not a
  proven upper bound**. Measured at paper base/60 s it still dominates
  comfortably (`tworay`: oracle 100.0 % vs aodv 69.6 %; `nakagami`: oracle
  99.3 % vs aodv 55.2 %), but that is an observation, not a theorem.

`scenario_check.py` WARNs on every `approx=1` cell so the distinction cannot be
lost between the run and the write-up.

No propagation model is ever *evaluated*, which has a second benefit: the oracle
takes no draw from the channel's pinned RNG stream
([#352](https://github.com/danieljoppi/AntHocNet/issues/352)), so the oracle arm
sees the same fading realisation as every other arm rather than a perturbed one.
And because `tworay` and `nakagami` are held to the same radius by the same
rule, the harness's controlled {`tworay`, `nakagami`} contrast is not confounded
by the control changing its own definition of adjacency between the two cells.

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
`disk-approx`); `range` is −1 on an all-wired topology; `noRoute` counts
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
2. **No protocol routes the same packet in fewer hops** — with a survivorship
   guard, below.
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
