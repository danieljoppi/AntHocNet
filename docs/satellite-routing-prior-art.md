# ACO routing on satellite constellations — prior art and the deterministic-topology objection

> **Status:** web/abstract-level survey, 2026-07-26. Answers the gating question
> on [#202](https://github.com/danieljoppi/AntHocNet/issues/202) for the
> satellite track ([#192](https://github.com/danieljoppi/AntHocNet/issues/192)).
> **Not** a full-text review — see [§8 Limits](#8-limits-of-this-survey) for
> exactly what still needs a human pass.

## 1. The question this answers

Before spending anything on a satellite substrate ([#193](https://github.com/danieljoppi/AntHocNet/issues/193))
or a satellite module ([#195](https://github.com/danieljoppi/AntHocNet/issues/195)),
the track needs an answer to the objection a reviewer raises in one sentence:

> **LEO topology is deterministic.** The inter-satellite-link graph for any
> second of the next decade follows from the TLEs. AntHocNet exists because
> MANET topology is *unknown and stochastic*. Why would you route a predictable
> network with an algorithm designed for an unpredictable one — when you can
> precompute shortest paths?

The objection is sound, and the operational world agrees with it: Iridium runs
**virtual-topology-based snapshot routing**, and the research substrate the
track was considering (Hypatia) precomputes per-timestep forwarding tables
rather than running a routing protocol at all.

## 2. What the mainstream actually does

The LEO routing literature splits into two families:

| Family | Mechanism | Notes |
|---|---|---|
| **Static / topology-exploiting** | Virtual topology (VT), virtual node (VN), snapshot routing (SSR) — Dijkstra per snapshot, tables uploaded periodically from the ground | Exploits the periodicity and predictability of the constellation to avoid onboard computation and distributed signalling. **Iridium uses this operationally.** |
| **Time-expanded** | Time-expanded graph (TEG) — links adjacent snapshots so a path can span a topology change | Addresses the core limitation of snapshot methods: they optimise *within* one snapshot and ignore the relation between neighbouring ones |
| **Dynamic** | On-demand and traffic-aware routing | Where the adaptive/ACO work lives |

This is the bar. Any claim we make is measured against a precomputed
shortest-path control, not against AODV — which is exactly the framing already
written into [#196](https://github.com/danieljoppi/AntHocNet/issues/196) /
[#216](https://github.com/danieljoppi/AntHocNet/issues/216), and this survey
confirms it is not a self-imposed handicap but the field's actual convention.

## 3. Prior art: ACO on LEO constellations

The field is **substantial and converged**. Every ACO-on-LEO paper found frames
its contribution as **load balancing / congestion**, not as topology discovery.

| Work | What it optimises | Baseline(s) | Platform |
|---|---|---|---|
| Deng et al., *An ACO-Based Routing Algorithm for Load Balancing in LEO Satellite Networks*, Wireless Communications and Mobile Computing, 2022 — **ACORA-WR** | Load balancing; ant movement confined to a window; combines path distance, transmission direction, link load | **LBRA-CP, SPR (shortest-path routing), LCRA** | not stated in abstract |
| Zhi et al., *Load Balancing Routing Algorithm for LEO Satellite Networks Based on ACO*, Internet Technology Letters, 2025 — **LBRA-ACO** | Globally optimal paths + real-time link monitoring + periodic rerouting of degraded paths | not stated in abstract | not stated in abstract |
| *Routing Optimization of LEO Satellite Network Based on Genetic Ant Colony Algorithm*, 2024 | GA+ACO hybrid for dynamic load balancing | reports gains in optimal-path search rate, RTT, packet loss | not stated in abstract |
| *An Ant Colony Based Approach to Multi-Constraint Routing*, IEEE, 2023 | Multi-constraint (QoS) routing | — | — |
| *A distributed QoS routing based on ant algorithm for LEO satellite network*, J. Electronics (China), 2006 | Distributed QoS routing | — | — |
| *Application of ACO to Adaptive Routing in LEO Telecommunications Satellite Network* (early) | Adaptive routing | compared against link-state algorithms | custom C++ + MATLAB frontend |
| ACO-PSO hybrid, IJSDR, 2025 | Optimal path selection | — | — |

Two facts from this table drive everything below.

**(a) The congestion framing is the field's answer to the objection — and it is
the same answer this repo hypothesised independently.** The stated motivation is
consistent across the literature: *bursty Internet traffic plus distributed
satellite links means traffic-intensive regions congest while other links sit
idle.* Orbital mechanics predict the **topology**; they do not predict **where
the traffic goes**. That is the gap an adaptive protocol occupies, and it is
precisely the mechanism AntHocNet already has (multipath + delay-weighted
pheromone + the A2 congestion metric, [#55](https://github.com/danieljoppi/AntHocNet/issues/55)/[#67](https://github.com/danieljoppi/AntHocNet/issues/67)).

**(b) Shortest-path controls are already standard here.** ACORA-WR is compared
against **SPR** among others. So a submission without that control would be
rejected, and one *with* it is merely meeting the existing bar — not exceeding
it.

## 4. Where the actual gap is

The gap is **not algorithmic**. It is in *evaluation*:

- The ACO-on-LEO work evaluates on **NS-2** and on **custom C++ simulators with
  a MATLAB frontend**. No reproducible artifact, no shared scenario definition,
  no common baseline implementation — the results are not comparable to each
  other, let alone reproducible by a third party.
- Meanwhile the satellite-simulation infrastructure has moved on: Hypatia,
  ns3-leo, xeoverse, SNS3 all exist on ns-3, and recent work builds
  trace-driven emulation on top of Hypatia.
- **No implementation of AntHocNet for satellite topologies on ns-3 was found.**

Crucially, **ns3-leo states our exact use case as its design goal**: a
simulation environment where *existing routing protocols from the WSN and MANET
areas can be evaluated in satellite networks*. That is a direct hit on
[#198](https://github.com/danieljoppi/AntHocNet/issues/198) and a strong signal
for the substrate decision — and it further weakens the case for building our
own module ([#195](https://github.com/danieljoppi/AntHocNet/issues/195)).

## 5. The defensible claim

**There is one, and it is not "ACO is novel for LEO".** That space is crowded
and converged; proposing another ACO variant would be the eighth such paper and
would have to beat tuned, published load-balancing algorithms on their own
ground.

The defensible claim is the repo's **existing** positioning
([#31](https://github.com/danieljoppi/AntHocNet/issues/31),
[#109](https://github.com/danieljoppi/AntHocNet/issues/109)) applied to a new
domain: an **open, tested, simulator-agnostic implementation** of a canonical
ACO routing protocol, evaluated on a **current, reproducible ns-3 satellite
substrate against a precomputed shortest-path control** — the comparison the
existing ACO-on-LEO literature asserts but does not make reproducible. The
contribution is *"here is what an unmodified, paper-faithful ACO protocol
actually does on a constellation, measured against the control that exploits
determinism, with an artifact anyone can re-run"*, not *"here is a better
algorithm"*.

That claim is worth making only if the measurement is honest about the likely
outcome: **on a quiet, fully-predicted constellation the control should win**,
and the interesting cells are the ones where its assumptions fail.

## 6. What the benchmark must create

Directly actionable for [#216](https://github.com/danieljoppi/AntHocNet/issues/216) —
these are the regimes where the deterministic control is blind:

1. **Congestion the control cannot see.** Asymmetric offered load over paths of
   equal length; the literature's own motivation (bursty traffic, idle links
   elsewhere). Requires the non-wifi `ILinkState` signal
   ([#206](https://github.com/danieljoppi/AntHocNet/issues/206)) or AntHocNet's
   congestion mechanism is inert on ISLs.
2. **Failures it did not predict.** Unscheduled ISL loss, degraded or jammed
   satellites — as distinct from the *scheduled* topology changes the control
   already has in its tables.
3. **Endpoint churn.** Ground-station handover
   ([#211](https://github.com/danieljoppi/AntHocNet/issues/211)) forces the
   control to recompute whole paths; traffic endpoints should therefore be
   ground stations, not satellites.

A benchmark that cannot produce these cells cannot falsify the claim, which
makes building them part of #216 rather than a follow-up.

## 7. Consequences for the track (see also §8 for what this does not establish)

| Ticket | Effect of this survey |
|---|---|
| [#192](https://github.com/danieljoppi/AntHocNet/issues/192) | Track is **not** closed as a negative result — a defensible claim exists, but it is an evaluation claim, not an algorithmic one |
| [#193](https://github.com/danieljoppi/AntHocNet/issues/193) | Substrate must be a *current, reproducible* ns-3 base; that is now a selection criterion, not a nice-to-have |
| [#198](https://github.com/danieljoppi/AntHocNet/issues/198) | **Promoted** — ns3-leo's stated goal is literally this use case |
| [#195](https://github.com/danieljoppi/AntHocNet/issues/195) | **Weakened** — the infrastructure exists; building our own is harder to justify |
| [#206](https://github.com/danieljoppi/AntHocNet/issues/206) | **Confirmed load-bearing** — congestion is *the* claim, and the signal is wifi-only today |
| [#216](https://github.com/danieljoppi/AntHocNet/issues/216) | Control is mandatory and matches field convention; §6 defines the cells |

## 8. Limits of this survey

Stated plainly so nobody mistakes its reach:

- **Abstract-level only.** This is a web search over titles, abstracts and
  landing pages. No paywalled full text was read — the environment cannot fetch
  academic PDFs (proxy 403), the same constraint that blocks the 2007 thesis
  work ([#58](https://github.com/danieljoppi/AntHocNet/issues/58)/[#88](https://github.com/danieljoppi/AntHocNet/issues/88)).
- **Baseline columns are largely unfilled**, which is the single most important
  column in §3. Only ACORA-WR's baselines were recoverable from the abstract.
  Whether the other works use a shortest-path control decides how strong the
  "not reproducible / not comparable" claim in §4 really is.
- **Simulation platforms are mostly unstated** in abstracts. The NS-2 / custom
  C++ finding comes from two of seven works; treat §4's first bullet as
  *indicative*, not established.
- **No claim is made about result quality** in any surveyed paper.

### Worth a human pass, in priority order

1. **Deng et al. 2022 (ACORA-WR)** — the most directly comparable work, and the
   one confirmed to use an SPR baseline. Full text would settle the bar we must
   clear and the scenario parameters to mirror.
2. **Zhi et al. 2025 (LBRA-ACO)** — the most recent; establishes current
   state of the art.
3. **The ITU/arXiv survey** *LEO Satellite Networking Relaunched: Survey and
   Current Research Challenges* (arXiv 2310.07646) — open access, so this one
   needs no paywall access and is the cheapest way to validate §2.

Once obtained, land them under `library/` and grep them with the `pdf-extract`
skill rather than reading them into context.

## Sources

- [An Ant Colony Optimization-Based Routing Algorithm for Load Balancing in LEO Satellite Networks (Deng, WCMC 2022)](https://onlinelibrary.wiley.com/doi/10.1155/2022/3032997) · [Hindawi landing page](https://www.hindawi.com/journals/wcmc/2022/3032997/)
- [Load Balancing Routing Algorithm for LEO Satellite Networks Based on Ant Colony Optimization (Zhi, Internet Technology Letters 2025)](https://onlinelibrary.wiley.com/doi/full/10.1002/itl2.70031)
- [Routing Optimization of LEO Satellite Network Based on Genetic Ant Colony Algorithm](https://www.researchgate.net/publication/380121673_Routing_Optimization_of_LEO_Satellite_Network_Based_on_Genetic_Ant_Colony_Algorithm)
- [An Ant Colony Based Approach to Multi-Constraint Routing Problem in LEO Satellite Networks (IEEE)](https://ieeexplore.ieee.org/document/10066019/)
- [Application of Ant Colony Optimization to Adaptive Routing in LEO Telecommunications Satellite Network](https://www.researchgate.net/publication/220545437_Application_of_Ant_Colony_Optimization_to_Adaptive_Routing_in_LEO_Telecommunications_Satellite_Network)
- [A distributed QoS routing based on ant algorithm for LEO satellite network (J. Electronics China, 2006)](https://link.springer.com/article/10.1007/s11767-006-0040-6)
- [Swarm-Based Hybrid ACO-PSO Algorithm for Optimal Path (IJSDR 2025)](https://www.ijsdr.org/papers/IJSDR2505301.pdf)
- [LEO Satellite Networking Relaunched: Survey and Current Research Challenges (arXiv 2310.07646)](https://arxiv.org/pdf/2310.07646) · [ITU Journal version](https://www.itu.int/dms_pub/itu-s/opb/jnl/S-JNL-VOL4.ISSUE4-2023-A50-PDF-E.pdf)
- [Dynamic Routings in Satellite Networks: An Overview (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9231381/)
- [A Novel Routing Algorithm Based on Virtual Topology Snapshot in LEO Satellite Networks (IEEE)](https://ieeexplore.ieee.org/document/7023604/)
- [Trace-driven Path Emulation of Satellite Networks using Hypatia (arXiv 2510.27027)](https://arxiv.org/pdf/2510.27027)
- [xeoverse: A Real-time Simulation Platform for Large LEO Satellite Mega-Constellations (arXiv 2406.11366)](https://arxiv.org/pdf/2406.11366)
- [Secure and Scalable Rerouting in LEO Satellite Networks (arXiv 2509.10173)](https://arxiv.org/pdf/2509.10173)
- [AntHocNet: An Ant-Based Hybrid Routing Algorithm for Mobile Ad Hoc Networks (Springer, the repo's [1])](https://link.springer.com/chapter/10.1007/978-3-540-30217-9_47)
