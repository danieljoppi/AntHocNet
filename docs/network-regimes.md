---
# Try it in the game (#629): rendered as a rail above the page on the site.
try:
  - world: manet
    seed: 1
    title: "The ad hoc regime"
  - world: satellite
    seed: 1
    title: "The satellite regime"
---

# MANET and satellite are not the same problem

Both are multi-hop wireless networks without fixed infrastructure. Almost every
other property differs — and the differences decide which routing mechanisms
make sense, what the benchmark must control for, and what may honestly be
claimed.

This page exists because the satellite track
([#192](https://github.com/danieljoppi/AntHocNet/issues/192)) kept producing
findings whose real cause was "this regime does not work like the one the
protocol was designed for". Rather than re-derive that each time, it is written
down once. Every row of the difference table below changed a concrete decision
in this repository — a defect, a parameter, a benchmark control, or an
architectural call.

## 1. Where the two regimes sit

Infrastructure-free networks, ordered by how knowable the topology is. The two
this repository cares about are at opposite ends.

```mermaid
flowchart LR
    subgraph axis [" topology unpredictable  ──────────▶  computable years ahead "]
    direction LR
    A["<b>MANET</b><br/>random waypoint<br/>shared radio"]
    F["FANET<br/>3D, smooth<br/>trajectories"]
    B["VANET<br/>road-constrained"]
    C["WSN / IoT<br/>static, energy-bound"]
    D["GEO<br/>one hop, ~119 ms"]
    E["<b>LEO ISL mesh</b><br/>+Grid, 4 links/node"]
    A ~~~ F ~~~ B ~~~ C ~~~ D ~~~ E
    end
    style A fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style E fill:#e8e6f8,stroke:#5b4fc4,stroke-width:2px
```

GEO sits near the deterministic end but is a different shape again: a bent-pipe
hop to a gateway, with essentially no path to choose. That is why SNS3 — the
most mature ns-3 satellite module — is the wrong substrate for routing work
([#199](https://github.com/danieljoppi/AntHocNet/issues/199)).

The intermediate families change the *evaluation*, not the protocol: the same
binary runs everywhere, but each family constrains mobility differently, so
each needs its own mobility model, scenario shape, and — sometimes — metrics
before a number from it means anything.

| Family | Mobility | What it changes | Status in this repo |
|---|---|---|---|
| **MANET** | unconstrained random (RWP), 1–20 m/s, 2D | nothing — the regime the 2004/2007 sources designed and tuned for | supported: the paper and thesis fields ([benchmarks](benchmarks.md)) |
| **FANET** | 3D smooth trajectories (Gauss-Markov standard), 10–30 m/s, sparse | third dimension, faster link churn, energy budgets that matter | **supported (v1.7.0, [#300](https://github.com/danieljoppi/AntHocNet/issues/300)):** [FANET results](benchmarks/scenarios/fanet.md). `--scenario=fanet` is a sourced preset (#482): 30 UAVs in 1000 × 1000 × 300 m, 3-D Gauss-Markov at 10–30 m/s. It has its own analytic anchors, and 20-seed results for six arms in a main cell and a partition-bound sparse cell. AntHocNet leads every protocol in both cells, and in the main cell delivers within 2.70 pp of the oracle. No geographic arm runs in 3-D (GPSR is planar). Priority rationale: 2024–2026 FANET surveys evaluate AntHocNet directly and rate it strongest among the classical protocols they test, which makes FANET the family where the protocol's reputation is currently made |
| **VANET** | road-constrained (Manhattan, SUMO traces), 10–40 m/s, platooning | churn is fast but street-shaped; density swings block-by-block; RSU/infrastructure hybrids common | **supported (v1.9.0, [#301](https://github.com/danieljoppi/AntHocNet/issues/301)):** [VANET results](benchmarks/scenarios/vanet.md). `--scenario=vanet` ([#488](https://github.com/danieljoppi/AntHocNet/issues/488)): 100 vehicles on an 800 × 800 m Manhattan grid (Bai & Helmy 2003), 10–20 m/s, two-ray + building shadowing (Sommer et al. 2011), seven arms (GPSR included) and the per-pair oracle, 20 seeds, plus a partition-bound sparse cell. **AntHocNet ties AODV on delivery** (42.1 vs 42.3 %) with half its `delay99` and +13 NRL; every other arm trails both, and the oracle delivers 81.7 %. Losses are 36 % reconvergence: buildings break links at every corner ([#537](https://github.com/danieljoppi/AntHocNet/issues/537)). The Veins/SUMO confirmation arm ([#485](https://github.com/danieljoppi/AntHocNet/issues/485)) is deferred with the OMNeT++ adapter |
| **Static Wi-Fi mesh** | none (community / Freifunk-class networks) | nothing to track: proactive maintenance pays for a topology that never changes, and the Babel / BATMAN-adv baselines are home here | supported: [static-mesh results](benchmarks/static-mesh.md) (#484). AntHocNet beats AODV on every metric, and OLSR leads, once the [#496](https://github.com/danieljoppi/AntHocNet/issues/496) timer fix is in. The earlier `ReconvHoldCap` finding ([#494](https://github.com/danieljoppi/AntHocNet/issues/494)) was that artifact |
| **WSN / IoT** | static or near-static, energy-bound | routing problem becomes energy/sleep scheduling, not topology discovery | out of scope (energy-aware `ILinkMetric` is the nearest hook, [#145](https://github.com/danieljoppi/AntHocNet/issues/145)) |
| **LEO ISL mesh** | deterministic orbits | the §3 inversion: topology known, traffic unknown | supported as a static +Grid snapshot; dynamics are epic [#297](https://github.com/danieljoppi/AntHocNet/issues/297) |

The two supported regimes in detail:

| | MANET — paper field | MANET — thesis field | Satellite — ISL +Grid |
|---|---|---|---|
| Harness | [`anthocnet-compare`](../ns3/anthocnet/examples/anthocnet-compare.cc) `--scenario=paper` | [`anthocnet-compare`](../ns3/anthocnet/examples/anthocnet-compare.cc) `--scenario=thesis` | [`isl-grid`](../ns3/anthocnet/examples/isl-grid.cc) |
| Nodes / field | 50 · 1500×300 m (Broch '98 calibration field) | 100 · 2400×800 m (Ducatelle 2007 §5.1.3) | rows×cols torus (default 6×6), static snapshot |
| Mobility | RandomWaypoint, 1–20 m/s, pause 30 s | RandomWaypoint, 1–10 m/s, pause 30 s | none — topology fixed by construction |
| Medium | 802.11b @ 2 Mbit/s, shared broadcast channel (disk or two-ray propagation) | same | point-to-point ISLs, 10 Mbit/s, 5 ms/link, one `/30` subnet each, degree 4 |
| Topology | unknown — discovered by ants | unknown — discovered by ants | deterministic — degree/link count asserted every run |
| Loss | collisions, retry exhaustion, mobility | same | none on the link; any loss indicts the stack |
| Traffic | 20 CBR flows × 512 bps | 20 CBR flows × 2048 bps | 4 CBR flows × 4096 bps + adversarial cells (scripted link cut, corridor congestion) |
| Baselines | AODV / OLSR / DSDV on identical seeds | same | same, plus (planned) precomputed shortest-path control ([#216](https://github.com/danieljoppi/AntHocNet/issues/216)) |
| Results | [benchmarks.md](benchmarks.md) | [benchmarks.md](benchmarks.md) | [benchmarks/satellite/isl-grid.md](benchmarks/satellite/isl-grid.md) (static torus), [benchmarks/satellite/leo-walker.md](benchmarks/satellite/leo-walker.md) (moving Walker shell) |

## 2. The two topologies

**A MANET node's degree depends on who happens to be nearby.** Neighbours are
unknown until a hello arrives, and there is one interface on one shared
broadcast domain.

```mermaid
graph LR
    n1((n1)) --- n2((n2))
    n2 --- n3((n3))
    n1 --- n3
    n2 --- n4((n4))
    n2 --- n5((n5))
```

`n2` has degree 4 here, `n4` degree 1 — and both change as the nodes move.

**A satellite's degree is fixed by construction:** two intra-plane links (fore
and aft, near-constant length) and two cross-plane links (port and starboard,
length varying with latitude).

```mermaid
graph TB
    fore["fore<br/><i>same plane</i>"] --- SAT(("SAT"))
    SAT --- aft["aft<br/><i>same plane</i>"]
    port["port<br/><i>adjacent plane</i>"] --- SAT
    SAT --- stbd["starboard<br/><i>adjacent plane</i>"]
```

Tiled, that is a **+Grid torus** — the standard LEO abstraction, and what
[`ns3/anthocnet/examples/isl-grid.cc`](../ns3/anthocnet/examples/isl-grid.cc) builds:

```
        ┌───────────────────────────┐   ← cross-plane wrap
        │                           │
    ────●───────●───────●───────●────┐  ← intra-plane wrap
        │       │       │       │    │
    ────●───────●───────●───────●────┤
        │       │       │       │    │
    ────●───────●───────●───────●────┘
        │                           │
        └───────────────────────────┘

    every node: exactly 4 ISLs, each on its own /30 subnet
```

Measured on the 4×4 harness: **16 nodes, 32 links** — exactly 2 contributed per
node, hence degree 4. That count is asserted on every run
([#226](https://github.com/danieljoppi/AntHocNet/issues/226)), because a
silently-wrong torus still delivers ~100% of packets and would produce entirely
plausible numbers for the wrong network.

## 3. The inversion that explains everything else

| | What is **unknown** | What is **given** |
|---|---|---|
| **MANET** | the topology — nodes move unpredictably, links appear and vanish, no node can know the graph | traffic demand is usually treated as given |
| **LEO constellation** | the traffic — where demand lands (ocean crossings, ground-station clustering, diurnal peaks) does not follow from orbits | the topology, for any second of the next decade, from the orbital elements |

**Move a routing protocol from one regime to the other and you take away the
problem it was designed to solve, then hand it a different one.**

That is why a claim about ant-colony routing on a constellation has to be about
**congestion and disruption**, never about finding routes — the conclusion
reached independently in
[`satellite-routing-prior-art.md`](satellite-routing-prior-art.md) §3, where the
published ACO-on-LEO literature turns out to have converged on load balancing
for exactly this reason.

## 4. The differences that bite

| Property | MANET | LEO satellite | Consequence in this repo |
|---|---|---|---|
| **Topology** | unknown, stochastic | deterministic from orbital elements | the control to beat is a precomputed shortest path (or OPSPF), **not** AODV — [#216](https://github.com/danieljoppi/AntHocNet/issues/216) |
| **Medium** | shared broadcast radio, 802.11 DCF, contention | point-to-point ISL, one peer per link | no contention ⇒ expected values are **analytic**, not literature-derived — the satellite anchors in [`benchmarks/methodology.md`](benchmarks/methodology.md) |
| **Interfaces per node** | one | four, each on its own `/30` | exposed a real defect: the data path used interface 0 for *every* next hop — [#203](https://github.com/danieljoppi/AntHocNet/issues/203) |
| **Node degree** | varies with density, 1 to many | exactly 4 | degree becomes an assertable invariant — [#226](https://github.com/danieljoppi/AntHocNet/issues/226) |
| **Loss** | collisions, retry exhaustion | essentially none on the link itself | anything under 100 % delivery indicts the stack, not the channel |
| **Delay** | queueing/contention dominated; `T_hop` = 3 ms | propagation dominated; 3–18 ms per ISL, GEO ~119 ms | delay becomes predictable: 2 hops × 5 ms → measured **10.39 ms**. Also means the 802.11-calibrated timers are mis-sized — [#205](https://github.com/danieljoppi/AntHocNet/issues/205) |
| **Neighbour discovery** | hello beacons are the only way to know | the peer is fixed and known from geometry | 1 Hz hello on a known peer is overhead: **NRL 12.18** with nothing to discover — [#204](https://github.com/danieljoppi/AntHocNet/issues/204) |
| **Link failure** | random, mobility-driven, constant | mostly **scheduled** (polar seams, visibility windows) | only *unscheduled* failure is interesting; the scheduled kind is already in the control's tables |
| **Scale** | tens of nodes, diameter ~5 | ~1584 per shell, diameter 20–40 | reactive flooding cost is the open scaling question — [#207](https://github.com/danieljoppi/AntHocNet/issues/207) |
| **Congestion signal** | wifi MAC queue occupancy | no wifi MAC exists on an ISL | the A2 metric is inert on satellites until the signal is generalised — [#206](https://github.com/danieljoppi/AntHocNet/issues/206) |
| **Realistic baseline** | AODV, OLSR, DSDV | snapshot routing, OPSPF, segment routing | terrestrial protocols become a sanity row, never the claim — §2.2 of the prior-art survey |

## 5. What this means for the algorithm

AntHocNet's mechanisms split cleanly along this line:

- **Reactive discovery** — flooding forward ants to find a path nobody knows —
  is its answer to *unknown topology*. A constellation does not have that
  problem: the +Grid is a known graph and every node can compute where a
  destination *is*.

  Be precise about what that does and does not buy, though. Knowing the topology
  is not the same as a node already holding a **next hop** for a given
  destination: it still has to acquire direction, and on 1584 nodes with four
  links each, acquiring it by flooding is the expensive way. The correction is
  not "discovery is free" — it is that discovery here is *steerable* rather than
  blind, because the direction is derivable instead of unknown.

  That is exactly the gap `enableDirectedReactive`
  ([`configuration.md`](configuration.md)) probes, and it does so without
  assuming a constellation: it steers along the diffused virtual gradient, which
  is pheromone the node already received, not a coordinate. So the same switch
  is testable on a MANET, where it degrades to "no gradient yet, flood as
  before" rather than to "wrong answer".
- **Multipath with delay-weighted pheromone** is a different mechanism
  entirely: it responds to *load*, and load is precisely what orbits cannot
  predict.

So the defensible position is not "ACO works on satellites" but **"one half of
it addresses a problem that exists there, and the other half addresses one that
does not"**. That is narrower, more honest, and testable.

It is also contested. Segment routing already performs congestion-aware traffic
engineering on deployed hardware without per-packet stochastic decisions. What
remains distinctive is that pheromone needs **no central traffic view** — which
matters exactly when that view is stale or unreachable, i.e. under unpredicted
failure and handover churn rather than under steady-state congestion. See
[`satellite-routing-prior-art.md`](satellite-routing-prior-art.md) §5.1.

## 6. What runs where — mechanism × regime

Section 5 gives the argument; this table gives the inventory. One attribute set
(defaults in [`configuration.md`](configuration.md)) serves both regimes — no
per-regime build, no per-regime preset. What differs is which mechanisms are
*live*: some bind to the Wi-Fi MAC and physically cannot fire on a
point-to-point ISL, and some answer a question the regime doesn't ask. The
harnesses set **no** protocol attributes; every A/B arm goes through explicit
`--ns3::anthocnet::RoutingProtocol::<Attr>=<v>` overrides
([#177](https://github.com/danieljoppi/AntHocNet/issues/177)), so a table row
below describes the *default* run of that regime's harness.

| Mechanism (attribute) | Default | MANET (Wi-Fi broadcast) | Satellite ISL (p2p grid) |
|---|---|---|---|
| Reactive forward-ant flood (`EnableReactive`) | on | **live, essential** — the only way to learn a topology nobody knows | live, but steerable-not-blind is the honest framing (§5): the flood re-derives direction the geometry already gives |
| Proactive ants (`EnableProactive`, `ProactiveInterval` 10 s) + diffusion (`EnableDiffusion`) | on | live — path maintenance and improvement during a session | live — diffusion carries the virtual gradient across the grid; it is what `EnableDirectedReactive` would steer along |
| Proactive emission gate (`ProactiveVirtualMargin`) | **0 = off** | off deliberately — the thesis's 10% gate measured harmful ([#180](https://github.com/danieljoppi/AntHocNet/issues/180)) | same |
| Hello beacons (`HelloInterval` 1 Hz) | on | live, essential — sole neighbour-discovery mechanism | live but **redundant**: one fixed, known peer per link; measured cost NRL 12.18 on a churn-free grid ([#204](https://github.com/danieljoppi/AntHocNet/issues/204)) |
| Multipath acceptance (`EnableMultipath`, a1 `AntAcceptanceFactor` 0.9, a2 `AntAcceptanceFactorNewHop` 2.0) | on | live — disjoint paths when density allows | live — the torus has equal-length corridors by construction; this is the half of the protocol with a real satellite claim (§5) |
| Local repair ants (`EnableRepair`, `RepairWaitFactor` 5, `RepairTimeout` 1 s) | on | live, constantly exercised — mobility breaks links | live, exercised only by *unscheduled* failure — the `--breakLink` cell ([#260](https://github.com/danieljoppi/AntHocNet/issues/260)); scheduled failure belongs to the control's tables |
| Link-failure notifications (`EnableLinkFail`, cooldown `LinkfailNotifyInterval` 5 s) | on | live | live |
| Failure detector A — hello timeout | always on | live | live (and sufficient: `Ipv4::SetDown` on a cut link also raises the interface event) |
| Failure detector D — Wi-Fi MAC transmit failures (`EnableMacFailureDetector`, `TxFailureThreshold` 3) | on | live — the fast detector ([ADR-0008](adr/0008-neighbour-liveness-two-detectors.md)) | **inert** — subscription requires a `WifiNetDevice`; a p2p ISL has none |
| A2 congestion metric (`EnableMacMetric`, `MacServiceAlpha` 0.7) | **off** | available — reads `WifiMacQueue` (AC_BE_NQOS) occupancy | **inert even if enabled** — no Wi-Fi MAC queue to read; needs a generalised congestion signal ([#206](https://github.com/danieljoppi/AntHocNet/issues/206)); the corridor experiments ([#216](https://github.com/danieljoppi/AntHocNet/issues/216)) exposed the deeper attribution gap ([#292](https://github.com/danieljoppi/AntHocNet/issues/292)) |
| Directed reactive discovery (`EnableDirectedReactive`) | **off** | A/B arm — no gradient yet ⇒ degrades to the stock flood | A/B arm — the regime this switch exists to probe (§5, [#245](https://github.com/danieljoppi/AntHocNet/issues/245)) |
| Pending-queue timing (`QueueTimeout` 3 s, `ReconvHoldCap` 200 ms, `RepairHoldCap` 0, `ReactiveRetryInterval` 0.25 s) | #21/#103 frontier values; `ReconvHoldCap` re-picked at 200 ms by [#371](https://github.com/danieljoppi/AntHocNet/issues/371) | live — tuned on this regime's delay tail | live but calibrated against 802.11 contention delays, not 5–18 ms propagation floors ([#205](https://github.com/danieljoppi/AntHocNet/issues/205)) |
| Goodness timing reference (`HopTime` 3 ms) | thesis value ([#88](https://github.com/danieljoppi/AntHocNet/issues/88)) | live — matches an unloaded 802.11 hop | mis-sized — an ISL hop is 5 ms of pure propagation before queueing ([#205](https://github.com/danieljoppi/AntHocNet/issues/205)) |
| Pheromone dynamics (`Alpha` 0.7, `Gamma` 0.7, `BetaAnts` 20, `BetaData` 20) | shipped values (the β exponents are the thesis's, adopted on a measured A/B — [#179](https://github.com/danieljoppi/AntHocNet/issues/179)) | live | live — and on a static grid the closed-form orbit of these constants is exactly reproducible ([#216](https://github.com/danieljoppi/AntHocNet/issues/216) derivation) |

Reading the table column-wise gives each regime's honest summary. **MANET:**
everything live; the protocol is in its design regime. **Satellite ISL:** the
discovery half runs but answers a solved problem, two Wi-Fi-coupled mechanisms
(detector D, A2 metric) are inert, hello pays overhead for nothing, and the
timing constants are calibrated for a medium that isn't there — while the
multipath/load-response half faces exactly the problem the regime does have.
That asymmetry is the satellite research programme
([#192](https://github.com/danieljoppi/AntHocNet/issues/192)), not a defect
list.

## 7. Measured: the v2.2.0 knobs per regime

Section 6 says which mechanisms are live in each regime. The
[v2.2.0 campaign](benchmarks/v2.2.0-campaign.md#results) measured four
pending-queue and link knobs in **every** family:
- 18 cells;
- 20 seeds;
- paired per seed against the shipped defaults.

None moved a default: each loses delivery somewhere (ADR-0019). This table
is what each one does where, so a reader who runs one regime can still use
it. Each entry shows AntHocNet's paired change in PDR, delay99 and NRL; "≡"
marks byte-identical runs, where the knob never binds.

| knob (attribute) | MANET grid | static mesh | FANET | VANET | satellite ISL grid | LEO shells |
|---|---|---|---|---|---|---|
| `RepairHoldCap=200ms` ([#433](https://github.com/danieljoppi/AntHocNet/issues/433)) | two-ray: PDR −0.3 to −1.0 pp, d99 −3 to −13 %; Nakagami: PDR noise, d99 −22 to −33 %, NRL −4 to −9 % | ≡ | main: d99 −10 %; sparse: PDR −0.4 pp, d99 −22 % | **main: PDR +1.1 pp, d99 −1.1 s, NRL −11 (recommended)**; sparse: PDR −0.2 pp, d99 −340 ms | ≡ | ≡ |
| `LinkMetric=sinr` ([#181](https://github.com/danieljoppi/AntHocNet/issues/181), ADR-0024) | two-ray: PDR +0.1 to +0.4 pp; Nakagami: d99 up to +98 ms, NRL +1 to +2.4 | d99 +0.4 ms | main: PDR +0.4 pp, d99 +18 ms; sparse: d99 +535 ms | **main: PDR −1.6 pp, d99 +1 s, NRL +13 (avoid)**; sparse: PDR +0.4 pp, d99 +1.5 s | PDR and delay identical (no PHY SINR on a p2p ISL: falls back to hop count) | starlink1: PDR +0.7 pp at NRL +49 (the access links do report SINR) |
| `HelloInterval=500ms` ([#537](https://github.com/danieljoppi/AntHocNet/issues/537)) | **PDR −0.5 to −8.0 pp, NRL +3.8 to +20 (avoid)** | PDR −0.4 pp, NRL +3.3 | PDR +0.5 to +0.6 pp, NRL +0.9 to +1.5 | **main: PDR +1.9 pp, d99 −15 % (recommended)**; sparse: PDR +0.5 pp, NRL +1.7 | PDR ≡, NRL +1 to +18 (pure beacon cost) | PDR +2.6 to +6.5 pp, NRL +76 to +550 (load roughly doubles) |
| `ReconvHoldCap=1s` ([#537](https://github.com/danieljoppi/AntHocNet/issues/537)) | two-ray: PDR +0.3 to +1.2 pp, d99 +6 to +36 %; **Nakagami: PDR −1.4 to −6.0 pp, d99 +310 to +470 ms (avoid)** | noise | main: PDR +1.3 pp; sparse: PDR +4.4 pp; d99 +180 to +590 ms | **main: PDR +5.3 pp; sparse: PDR +6.2 pp; d99 +210 to +360 ms (recommended where delay is tolerable)** | ≡ | walker16: noise; Starlink: PDR +0.5 to +0.8 pp, d99 +100 to +120 ms |

Read the table by the regime's link-break signature:

- **Breaks that are clean and frequent** (VANET corners, sparse FANET) reward
  every knob that waits or re-detects faster: the hold caps and the faster hello.
- **Breaks that are transient fades** (Nakagami) punish waiting.
  Held packets queue behind ones the next attempt would have delivered, and
  faster beacons add contention.
- **Breaks that cannot happen to the routing** (the ISL torus, the static
  mesh) leave the caps idle. The hello pays its beacons and buys nothing.

These are the same three signatures section 4 derives from the topology. The
campaign's contribution is the measured size of each effect.

## 8. Measured: the v2.3.0 mechanisms per regime

The [v2.3.0 campaign](benchmarks/v2.3.0-campaign.md#results) measured the six
regime-gated mechanisms the same way: 18 cells, 20 seeds, paired per seed
against the shipped defaults at the campaign commit. Each entry shows
AntHocNet's paired change in PDR, delay99 and NRL where the 95 % interval
excludes zero; "noise" means none does, and "≡" marks byte-identical runs.

| mechanism (attribute) | MANET grid | static mesh | FANET | VANET | satellite ISL grid | LEO shells |
|---|---|---|---|---|---|---|
| link lifetime `EnableLinkLifetime` ([#574](https://github.com/danieljoppi/AntHocNet/issues/574)) | **two-ray: PDR +0.3 to +0.7 pp, d99 −28 to −37 ms; Nakagami: PDR +2.1 to +3.9 pp, d99 −159 to −215 ms, NRL −1.1 to −1.8 (recommended)** | d99 +0.7 ms | main: PDR +0.5 pp, d99 −11 ms; sparse: noise | main: NRL +1.7, PDR noise; sparse: noise | ≡ (nothing moves, so no link is predicted to end) | walker16, storm: noise; Starlink S1: PDR −0.5 pp, NRL +37 |
| quiet mode `EnableQuietMode` ([#571](https://github.com/danieljoppi/AntHocNet/issues/571)) | noise; ≡ on the three Nakagami cells | **NRL −0.40 (−8.6 %), d99 −0.7 ms, PDR noise (default on from v2.3.0)** | noise | noise | **NRL −0.04 to −0.11, PDR and delay ≡** | noise |
| adaptive evaporation `EnableAdaptiveEvaporation` ([#572](https://github.com/danieljoppi/AntHocNet/issues/572)) | two-ray: noise; Nakagami: d99 +51 to +59 ms, NRL +1.3 to +2.0, PDR −1.1 pp on Gauss-Markov | NRL −0.14 | main: PDR +0.4 pp; sparse: d99 +13 ms | main: d99 +180 ms, NRL +1.5; sparse: d99 +108 ms | noise (seam: NRL −0.01) | **walker16: PDR −0.5 pp; Starlink: PDR −5.4 to −5.5 pp, NRL +164 to +236 (avoid)** |
| energy metric `LinkMetric=energy` ([#145](https://github.com/danieljoppi/AntHocNet/issues/145)) | two-ray: d99 +8 to +28 ms, NRL +0.2; Nakagami: d99 +126 to +139 ms, NRL +1.4 to +2.3 | noise | main: PDR +0.5 pp, d99 +20 ms; sparse: d99 +564 ms | **main: PDR −1.5 pp, d99 +1.0 s, NRL +13 (avoid)**; sparse: PDR +0.5 pp, d99 +1.6 s | noise (no energy probe: hop count) | walker16: NRL +2.0; Starlink S1: PDR +0.7 pp, NRL +49 |
| propagation timing `--timingProfile=propagation` ([#205](https://github.com/danieljoppi/AntHocNet/issues/205)) | — | — | — | — | noise | noise |
| p2p hello throttle `P2pHelloEvery=5` ([#204](https://github.com/danieljoppi/AntHocNet/issues/204)) | — | — | — | — | base, failcell, corridor: **NRL −0.5 to −10.5, PDR ≡**; seam: PDR −0.12 pp, d99 +9 ms | — |

Five of the six cannot move a default: each loses delivery somewhere, or
(timing) shows no effect at all. Quiet mode is the one mechanism with no
regression in any cell, so the pre-registered rule moves its default: it
ships on from v2.3.0. Three readings carry over from
section 7:

- **Lookahead pays where breaks are fades, not where they are corners.**
  Link lifetime's largest gain is on the Nakagami grid, where it steers off
  links that are about to fade. Its target, the VANET corner break, is a
  topology change that kinematics alone does not predict.
- **The fixed-topology regimes reward doing less.** Quiet mode and the hello
  throttle cut overhead only where the routes cannot change: the static mesh
  and the ISL torus. The seam, where links do fail, is where throttled
  hellos lose packets.
- **A non-hop-count metric at full batteries behaves like `sinr` did.**
  The energy metric prices every hop at about 1.0 to 1.2. Its losses match
  v2.2.0's `LinkMetric=sinr` row cell for cell in sign and size: what costs
  is leaving hop-count goodness, not the energy signal.

## Provenance of the numbers

Measurements are from this repository's own CI, not from the literature:
`isl-grid` on a 4×4 torus gives **10.39 ms** mean delay against a **10 ms**
analytic floor (2 hops × 5 ms) and **5.1 ms** at one hop, with **32** links
across **16** nodes and **NRL 12.18** on a churn-free grid
([#214](https://github.com/danieljoppi/AntHocNet/issues/214),
[#237](https://github.com/danieljoppi/AntHocNet/issues/237)).

`T_hop` = 3 ms is the 2007 Ducatelle thesis value
([#88](https://github.com/danieljoppi/AntHocNet/issues/88)). The protocol
landscape and the ~119 ms GEO figure are sourced in
[`satellite-routing-prior-art.md`](satellite-routing-prior-art.md), which also
records which of its claims have been checked against a full text and which
have not.
