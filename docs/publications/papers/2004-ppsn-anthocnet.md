# [1] AntHocNet (PPSN VIII, 2004) — technical digest

> **Citation:** G. Di Caro, F. Ducatelle, L. M. Gambardella, *AntHocNet: an
> Ant-Based Hybrid Routing Algorithm for Mobile Ad Hoc Networks*. Proceedings
> of Parallel Problem Solving from Nature (PPSN) VIII, LNCS 3242, pp. 461–470,
> Springer-Verlag, 2004. **Conference best paper award.** Also published as
> IDSIA Technical Report **IDSIA-25-04-2004** (August 2004); the two bodies are
> 99.96 % identical (verified on the maintainer-supplied PDFs, 2026-07-19).
> DOI: 10.1007/978-3-540-30217-9_47.
>
> This is the document cited as **[1]** throughout `core/` comments,
> `CONTEXT.md`, and the issue tracker. This digest restates its technical
> content in reference form (not a reproduction — see
> [`../README.md`](../README.md)); section numbers (§) refer to the paper.

## 1. Paper structure

| § | Content |
|---|---------|
| 1 | Introduction: MANET routing constraints (mobility, shared limited bandwidth, 802.11 DCF overhead) |
| 2 | Related work: proactive (DSDV) vs reactive (AODV/DSR) vs hybrid (ZRP); multipath routing (AODV-BR); ant-based routing (ABC, AntNet, ARA, PERA) |
| 3 | The algorithm: §3.1 reactive path setup · §3.2 stochastic data routing · §3.3 proactive maintenance + exploration · §3.4 link failures |
| 4 | Experiments in Qualnet vs AODV-with-route-repair: §4.1 setup · §4.2 results (area sweep, pause sweep, scale sweep) |
| 5 | Conclusions + future work (extended pheromone diffusion; virtual-circuit variant) |

## 2. Algorithm digest

### §3 overview
Hybrid multipath: reactive setup on session start; per-`(destination d,
next hop n)` pheromone `T_nd` (a goodness estimate) in each node's routing
table; data forwarded stochastically per pheromone; proactive ants monitor and
explore while the session runs; link failures trigger local repair or
neighbour notification.

### §3.1 Reactive path setup
- A source with no up-to-date routing info for `d` sends a **reactive forward
  ant**: unicast where the current node has routing info for `d`, broadcast
  otherwise.
- **Multipath acceptance filter** (the mechanism behind issue #96): when a node
  receives further ants of the same *generation* (same original forward ant at
  the source), it forwards a later copy only if its **number of hops** and its
  **travel time** are *both* within a factor — *"a parameter which we
  empirically set to 1.5"* — of the best ant of that generation seen so far.
  Purpose: prune bad paths without losing multiple good ones.
- The forward ant carries the visited-node list `P = [1..n]`; at `d` it becomes
  a **backward ant** retracing `P` and updating routing tables.
- **Path-time estimate** accumulated by the backward ant:
  - `T̂_P = Σ_{i=1..n−1} T̂_{i→i+1}`
  - `T̂_{i→i+1} = (Q^i_mac + 1) · T̂^i_mac` — MAC-queue-aware per-hop cost
    (this is the "A2" formula, issue #70: **confirmed**).
  - `T̂^i_mac = α·T̂^i_mac + (1−α)·t^i_mac` — running average of the time from
    a packet's arrival at the MAC layer to the end of successful transmission
    (so it includes channel-access time / local congestion), `α ∈ [0,1]`.
  - Forward ants compute the like estimate for the §3.1 acceptance filter.
- **Pheromone deposit** at node `i` for entry `T_nd` (arrived from neighbour
  `n`, `h` hops to `d`, ant estimate `T̂_{i→d}`):
  - `τ_id = ((T̂_{i→d} + h·T_hop) / 2)^(−1)` — inverse of the *average* of the
    time estimate and a pure hop-count term; `T_hop` is a fixed constant, "the
    time of taking one hop in unloaded conditions". Averaging damps time-sample
    oscillation and blends delay + hop count. **The paper gives no numeric
    value for `T_hop`** (issue #88 → thesis).
  - Existing entries update by running average `T_nd = γ·T_nd + (1−γ)·τ_id`,
    `γ ∈ [0,1]`.
  - No evaporation term appears anywhere in the paper (repo's gated
    evaporation is an extra safety net — ADR-0012, documented deviation).

### §3.2 Stochastic data routing
- Data picks next hop `n` with probability `P_nd = T²_nd / Σ_{i∈N_d} T²_id` —
  pheromone **squared** ("to be more greedy with respect to the better paths").
  I.e. the paper's data exponent is **2** (issue #70 β alignment).
- The number of paths in use is emergent — no a-priori path count; automatic
  load balancing follows from the probabilistic spread.

### §3.3 Proactive path maintenance and exploration
- While a session runs, the source emits **proactive forward ants** clocked to
  the data rate (one ant every n-th data packet).
- They follow pheromone like data but **unsquared** (exponent **1** — samples
  paths more evenly; the ant exponent of #70), with a small per-node
  probability of being broadcast to explore.
- A proactive ant that finds no pheromone after a broadcast may be broadcast
  again, but at most **2** broadcasts total, else deleted — keeps exploration
  concentrated around current paths.
- **Hello messages** (footnote 1): broadcast every `t_hello` seconds (e.g.
  1 s); a hello from an unknown node adds it as a destination; a neighbour is
  removed after **2** missed expected hellos. Hellos guide ants near the
  destination — the paper frames this as **pheromone diffusion** (to be
  extended in future work) — and detect broken links.

### §3.4 Link failures
- Detection: failed unicast (data or ant), or missed hellos.
- If the node still has alternate next hops for the destination, or the
  destination is not in regular use → just update the table and **send a
  notification to neighbours**.
- **Local repair** only when the destination was in regular data use *and* the
  broken link was its only alternative *and* the loss was discovered by a
  failed **data** transmission: broadcast a **route repair ant** (travels like
  a reactive forward ant, max **2** broadcasts), wait **5×** the estimated
  end-to-end delay of the lost path for a backward repair ant, else conclude
  failure and remove the entry.
- The **notification** lists the lost destinations with the sender's new best
  estimated end-to-end delay and hop count (if any path remains). Receivers
  update their tables with the new estimates and re-broadcast only if they in
  turn lost their **best or only** path — propagation stops when nothing
  changed.

## 3. Parameter table (everything the paper pins down)

| Parameter | Paper value | § | Repo counterpart (`core/.../config.h`) | Status |
|---|---|---|---|---|
| Acceptance factor (hops AND time) | **1.5** (empirical) | 3.1 | `antAcceptanceFactor = 1.5`, gated by `enableMultipath` | ✅ matches (#96) |
| MAC-time running-average weight α | **0.7** | 3.1 | `macServiceAlpha` (ns-3 attr) = 0.7 | ✅ matches (#70) |
| Pheromone running-average weight γ | **0.7** | 3.1 | `gamma = 0.7` | ✅ matches |
| Per-hop cost formula | `(Q_mac + 1)·T̂_mac` | 3.1 | `enableMacMetric` path | ✅ formula confirmed (#70); repo default **off** (A2 gated) |
| `T_hop` (unloaded one-hop time) | **not stated** | 3.1 | `hopTimeSec = 0.05` (provisional) | ⏳ thesis (#88) |
| Data routing exponent | **2** (squared) | 3.2 | `betaData = 20` (legacy) | ❗ deviation; alignment tracked in #70 |
| Ant routing exponent | **1** (unsquared) | 3.3 | `betaAnts = 2` (legacy) | ❗ deviation; alignment tracked in #70 |
| Proactive ant rate | 1 per n data packets | 3.3 | `proactiveInterval` (time-based) | ❗ deviation (rate- vs time-clocked), #26 item 04 area |
| Proactive max broadcasts | **2** | 3.3 | `proactiveMaxBroadcasts = 2` | ✅ matches (#45) |
| `t_hello` | **1 s** (example value) | 3.3 fn.1 | `helloInterval = 1.0` | ✅ matches |
| Missed hellos before neighbour removal | **2** | 3.3 fn.1 | `allowedHelloLoss = 2` | ✅ matches |
| Repair ant max broadcasts | **2** | 3.4 | `repairMaxBroadcasts = 2` | ✅ matches |
| Repair wait factor | **5×** estimated end-to-end delay of lost path | 3.4 | `repairWaitFactor = 5.0` | ✅ matches (D6) |
| Repair precondition | regular use + only alternative + failed **data** tx | 3.4 | `reportTxFailure` requires a `dataDest` and no surviving route | ✅ matches |
| Evaporation | none in the paper | — | `enableEvaporation = true` | ❗ documented extra (ADR-0012) |
| Jitter estimator | none defined (99th-percentile delay shown instead) | 4.2 | `anthocnet-compare` jitter column | ⏳ thesis (#89) |

Known deliberate repo deviation not in the paper: with multipath on, the repo
**suppresses** the §3.4 neighbour notification when a usable alternate next hop
survives (the paper always notifies with the new best estimate). Benchmark
-justified on the ns-3 disk-model harness (#96 round 1 vs round 2:
notification floods cost −7.5 pp PDR).

## 4. Experimental setup (§4.1) — the "paper regime"

- Simulator: **Qualnet** (GloMoSim successor). Baseline: **AODV with route
  repair**.
- Base scenario (from Broch et al. [2]): **50 nodes**, **1500 × 300 m²**
  (rectangular to force long paths), random waypoint, **max speed 20 m/s**,
  **pause 30 s**, **900 s** simulated.
- Traffic: **20 CBR sources**, one **64-byte** packet per second each, start
  times uniform in 0–180 s, sending until the end.
- PHY/MAC: **two-ray** propagation, **300 m** transmission range, **2 Mbit/s**,
  **802.11 DCF**.
- Sweeps: long edge 1500→2500 m (fixed 300 m short edge); pause 0→900 s at
  2500 × 300; scale ×f on both edges with nodes ×f² from 50 @ 1500 × 500 up to
  200 @ 3000 × 1000.
- Statistics: 5 independent problem instances × 5 runs each (25 runs per
  point).

Repo mapping: `--scenario=paper` in `ns3/tools`/`paper-benchmark.yml` runs 50
nodes / 1500 × 300 / RWP 20 m/s / pause 30 / 20 CBR flows; the repo's CI runs
use 300 s (time-boxed) vs the paper's 900 s, disk-model `--propagation=range`
by default vs the paper's two-ray (`--propagation=tworay` available), and ns-3
vs Qualnet (CONTEXT.md §8 cross-simulator caveat). The scale/pause/area sweeps
are `scenario-matrix.yml`.

## 5. Results digest (§4.2)

- **Delivery ratio: AntHocNet ≥ AODV in every scenario tested**, and the gap
  *grows* as scenarios get harder (longer/sparser areas, higher mobility,
  larger scale).
- **Average delay: AODV wins the easy scenarios, AntHocNet wins the hard
  ones.** AODV's mean is dragged by a small fraction of packets with very high
  delay — its **99th-percentile** delay explodes in hard scenarios, i.e. high
  delay jitter, a QoS problem. AntHocNet's 95th percentile is *higher* than
  AODV's (multipath spreads some data over non-shortest paths) but its extreme
  tail is far smaller.
- Interpretation offered by the paper: multiple paths at setup + continuous
  proactive search ⇒ alternatives usually exist on route failure ⇒ less loss
  and a bounded tail; single-path AODV collapses when its one path degrades.
- Figures: Fig. 1 delivery + mean/99th delay vs area long-edge (1600–2500 m);
  Fig. 2 same vs pause time (0–900 s) at 2500 × 300; Fig. 3 same vs scale
  factor (1–2). No numeric tables are given; results are read from plots.

Repo relevance (#91 ledger): the repo currently reproduces the delivery-ratio
and overhead claims but not yet the delay-tail/jitter claim (#21) — note the
paper's own caveat that AntHocNet's *mean* delay is allowed to be higher in
easy regimes; the claim to reproduce is the **bounded tail** in hard regimes.

## 6. What this paper does NOT contain (goes to the thesis, `../thesis/`)

- A numeric `T_hop` (#88) and any full parameter table (#58).
- A jitter estimator definition (#89) — only per-packet delay percentiles.
- Evaporation, pheromone-diffusion bootstrapping details (the 2005+
  journal/thesis versions develop diffusion; here it is only hellos +
  future-work), virtual pheromone, `maxHistory`/dedup bounds, ant wire format.
- Any statement about (src,seq) dedup for non-reactive ant types — the repo's
  strict dedup for backward/hello/linkfail/proactive/repair ants is an
  implementation necessity, not a paper mechanism.
