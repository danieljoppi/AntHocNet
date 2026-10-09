# Where AntHocNet could go next — research landscape (2026-10)

> **Status:** a web- and abstract-level survey from 2026-10-09, written for the
> post-v2.0.0 replan ([roadmap.md](roadmap.md#replan-after-v200-proposed-2026-10-09)).
> It shares the limits of [satellite-routing-prior-art.md](satellite-routing-prior-art.md):
>
> - each result below is quoted from an abstract or a summary, not checked
>   against the full text;
> - no number here may be cited in a publication until someone has read the
>   paper;
> - "no 2024–2025 paper found" means *this* search found none — it is not a
>   claim that the literature has none.
>
> The page exists so the replan's choices can be traced to sources, and so the
> next person to pick up a family starts from a reading list rather than a
> blank search box.

## 1. The question

v2.0.0 closed the family axis this project committed to:

- MANET (the grid);
- static mesh;
- FANET;
- VANET;
- satellite, both the ISL torus and the moving Walker / Starlink shell.

Each family has a results page with CIs, and there is a cross-family ranking
statement. The question this page answers is the maintainer's
(2026-10-09):

1. what other networks could the protocol be evaluated on;
2. which algorithm adjustments could improve specific cases;
3. which research should inform both.

Two existing constraints bound every answer below:

- **[ADR-0019](adr/0019-network-families-change-the-evaluation-not-the-protocol.md):**
  a family changes the scenario, never the protocol defaults. A per-regime
  improvement must be a *gated mechanism with its own default-off switch*,
  earned by an A/B on identical seeds.
- **[ADR-0020](adr/0020-security-is-a-default-off-profile.md):** default-off
  extensions must be provably byte-identical when off. This is the template
  for every mechanism proposed in §3.

## 2. Candidate network families

The table assesses each candidate on four questions:

- does the literature use ACO there;
- is there an ns-3 substrate (ADR-0023 keeps one simulator);
- would AntHocNet's mechanisms actually be exercised;
- what is the risk.

| family | ACO / swarm literature | ns-3 substrate | what it would test | risk | verdict |
|---|---|---|---|---|---|
| **Disaster / emergency response** — partitioned first-responder teams, mixed indoor/outdoor shadowing | MANET protocol comparisons under disaster-area mobility find connectivity "varies widely enough to be hard for current routing protocols" (Raffelsberger & Hellwagner, WISES 2012); composite rescue-team mobility models exist (Reina et al.; RTTMM, Gondaliya & Atiquzzaman) | stock ns-3 (mobility model + shadowing are scenario work); reuses the open partition/merge stress item [#62](https://github.com/danieljoppi/AntHocNet/issues/62) | repair under *partition and re-merge*, which no current family exercises; group mobility | low — no new substrate | **adopt (family axis III)** |
| **Space-air-ground integrated (SAGIN)** — LEO shell + HAPS/UAV relay layer + ground | surveys flag routing across vertically heterogeneous layers as open: "the current routing protocol is not applicable to vertical space networks" (2020 survey, arXiv 2002.08811); HAPS as a central NTN component is under-studied (arXiv 2510.19731, 2025) | extends `leo-walker` (stock ns-3.48 LEO, ADR-0022) with an air layer: the FANET mobility already exists | heterogeneous link delays (ms ISL vs sub-ms air), a third tier for the pheromone to choose between | medium — harness work, no new module | **adopt (family axis III)** |
| **Tactical narrowband MANET** — 9.6–64 kbit/s radios, high latency | no ACO work found; 2012 tactical-mobility study concludes no protocol "routes efficiently across all network sizes, loads, and mobility levels" (Kioumourtzis et al.); ns-3/CORE behaviours not seen on hardware (Grandhomme et al. 2016) | stock ns-3 (rate-limited PHY) | **control overhead as the binding constraint** — AntHocNet's NRL lead/lag matters most here | low substrate, high relevance-of-claim risk (no open benchmark to anchor to) | **spike** — one cell inside the disaster family, not a family of its own |
| **Underwater acoustic (UASN)** — ~1500 m/s propagation, long delays, energy-bound | ACAR (IET Comms 2020), PB-ACR (IEEE Access 2021) show ACO routing there, both energy-focused, evaluated on NS-2 Aqua-Sim | Aqua-Sim NG is a third-party ns-3 add-on that recommends **ns-3.40** — not in this repo's 3.36–3.48 matrix; Aqua-Sim FG is a separate newer codebase | propagation-dominated timing — the same mismatch as the satellite ISL ([#205](https://github.com/danieljoppi/AntHocNet/issues/205)), at seconds instead of milliseconds | **high** — third-party substrate, version pin conflict, a whole new PHY/MAC | **research spike only**; revisit if #205 produces a propagation-aware timing mechanism worth testing at the extreme |
| **LoRa mesh** — duty-cycle limited, multi-km links | 2024 ACM Computing Surveys review: reactive protocols edge out proactive ones on scalability and power; hybrid only helps in specific topologies; ns-3 LoRaMesh raised far-node PDR 40.2 → 73.8 % (Sensors, 2025) | ns-3 `lorawan` module (third party) | whether ants fit inside a 1 % duty cycle at all | high — ant overhead may simply not fit the duty cycle | **out** (as WSN/IoT, RPL's problem); recorded so it is not re-proposed without new evidence |
| **Maritime (ship ad hoc, VHF)** — sparse, long-range, partitioned | SANET studies compare DSDV/AODV/AOMDV/DSR; MADNET switches MANET↔DTN by connectivity | stock ns-3 | sparse, long-range partitions | medium | **out for now** — its distinctive need (DTN store-carry-forward) is a non-goal; reopens with DTN below |
| **mmWave / directional mesh** (UAV swarms) | directional FANET routing survey (2021); 2024 survey on neighbour discovery / beam alignment in mmWave UAV swarms (arXiv 2410.11490) | ns-3 mmWave modules (third party, heavy) | beam alignment breaks the broadcast assumption hellos and reactive floods rely on | high — breaks a protocol assumption, not a scenario knob | **out** — it is a protocol redesign, not a family |

## 3. Algorithm adjustments worth measuring (all gated, default-off)

These are mechanisms, not presets. Each one must:

- (a) have a default-off attribute;
- (b) pass a byte-identical determinism check when off;
- (c) be A/B'd on identical seeds in the family it targets **and** in every
  other family, so that a regression elsewhere is visible;
- (d) update the mechanism × regime table in
  [network-regimes.md](network-regimes.md).

| mechanism | measured weak spot it targets | literature | existing issue |
|---|---|---|---|
| **Link-lifetime prediction** — discount pheromone on a next hop whose predicted link expiry is near (position + velocity) | VANET: 36 % of AntHocNet's traffic lost to reconvergence; oracle 81.7 % vs AntHocNet 42.1 % — the widest gap of any family ([#537](https://github.com/danieljoppi/AntHocNet/issues/537)) | intersection-aware link lifetime (iCAR, 2013); ML link-lifetime prediction (Sensors 2022, doi:10.3390/s22166038); ACO + link prediction (ERIACO, 2024); mobility-anticipated ETX gives PDR close to 1 in ns-3 (HAL hal-01072234) | #537 (new mechanism; needs a position port, see note) |
| **SINR link metric** | fidelity: every thesis headline result uses it, and this repo's default is the metric the thesis benchmarks as worse | Neishaboori & Kesidis 2008 (SINR as secondary metric on ETX, damps instability); ETX/ETT comparisons (Draves et al., Microsoft Research) | [#181](https://github.com/danieljoppi/AntHocNet/issues/181), through the [#142](https://github.com/danieljoppi/AntHocNet/issues/142) seam |
| **Propagation-dominated timing** (T_hop, hello, lifeAnt, repair waits) | S1: AntHocNet 15.5 pp under the delay oracle (7.0 pp on walker16); the gap grows with path length | — (this repo's own finding, ADR-0019 cites it as the example) | [#205](https://github.com/danieljoppi/AntHocNet/issues/205) |
| **Hello suppression on point-to-point ISLs** | satellite: hellos are redundant on a link with one known peer (network-regimes §6) | — | [#204](https://github.com/danieljoppi/AntHocNet/issues/204) |
| **Quiet mode for stable topologies** — proactive-ant back-off when sampled routes stop changing | static mesh: OLSR leads (99.82 % vs 99.34 % PDR, NRL 1.78 vs 4.51); ants keep sampling links that never change (the learn site's mesh challenge shows it) | adaptive evaporation for dynamic optimisation (Mavrovouniotis & Yang 2013/2014); counterpoint: Pellegrini, Stützle & Birattari 2012 on when parameter adaptation helps | new |
| **Adaptive evaporation** — evaporation rate tracks observed route churn | handover-heavy shells (walker16 hop changes 2.07 vs the oracles' ~1.0 per flow-minute) and VANET corners | Mavrovouniotis & Yang (EvoApplications 2013; IEEE CIDUE 2014): self-adaptive evaporation beats fixed rates on dynamic problems — tested on dynamic TSP/VRP, **not** packet routing, so transfer needs its own validation | new |
| **Energy-aware link metric** | FANET energy per delivered bit is published ([#508](https://github.com/danieljoppi/AntHocNet/pull/508)) but nothing optimises it | BeeAdHoc (GECCO 2005: energy savings from fewer control packets + multipath); PEEBR (predicted residual battery); min-energy vs max-min residual routing | [#145](https://github.com/danieljoppi/AntHocNet/issues/145) |
| **Re-injection that tells redundant from delivering** | 65–67 % duplicate rate by direct measurement ([reinjection.md](benchmarks/reinjection.md)) | — | [#430](https://github.com/danieljoppi/AntHocNet/issues/430) |
| **RepairHoldCap** | ~168 ms of tail the #371 flip left on the table | — | [#433](https://github.com/danieljoppi/AntHocNet/issues/433) |

**Note on position-aware mechanisms.** Link-lifetime prediction (and any
geographic hint) needs node position and velocity inside `core/`. Today `core/`
sees neither. That is a new port in the ADR-0003 sense — the adapter supplies
it, the core never reads a simulator. It must be absent (not zero) when an
adapter cannot supply it, so the default path stays byte-identical. This
deserves its own ADR before code.

## 4. Comparators the literature now expects

- **Other swarm protocols.** These are the natural "is it the ants, or this
  design of ants?" control. As of this search, none has a maintained ns-3
  implementation; past comparisons ran on NS-2 or OMNeT++, pairwise, in
  scenarios that cannot be lined up. No study was found that compares them all
  under identical conditions.

  | protocol | design | what it tests against AntHocNet | plan |
  |---|---|---|---|
  | **ARA** (Güneş et al. 2002) | purely reactive ACO, built to cut overhead (roots in ABC and AntNet) | whether proactive sampling and repair pay for themselves | v2.5.0 |
  | **Termite** (Roth & Wicker, SIDM 2005) | stigmergy: routing information rides inside data packets, no control ants; randomised multipath | a different overhead model; its authors report it beats AODV on primary metrics | v2.5.0 |
  | **BeeAdHoc** (Wedde et al., GECCO 2005) | bee-inspired source routing, scouts and foragers; low energy from fewer control packets | a second swarm family, and the energy-per-bit metric | stretch |
  | **HOPNET** (Wang, 2007 thesis) | ants hopping between routing zones | the only result found benchmarking against AntHocNet directly; it claims better scaling | stretch |
  | AntNet (Di Caro & Dorigo 1998) | ACO for wired networks | — | skip: AntHocNet's ancestor, not a competitor |

  The risk is a strawman: a quickly written competitor loses for the wrong
  reason. This repository has paid for that once (#425/#416: two vendored arms
  compiled, passed CI and forwarded nothing). Each arm therefore needs a
  fidelity sheet from its paper, the per-PR delivery smoke (#439), and an
  anchor reproducing its own paper's headline trend against AODV before its
  numbers are published. An NS-2 thesis from Thapar University that compared
  an ant scheme with ARA and AntHocNet is the closest earlier attempt found.

- **Learned routing (DRL / MARL).** This is the most-cited new comparator family:
  - DeepCQ+ (Kaviani et al., arXiv 2101.03273) reports 10–15 % over Q-routing
    and robustness outside the training range;
  - Alanazi & Zareei (IEEE Access 2025) pair MADRL with GNNs;
  - a 2024 FANET routing review (Alexandria Eng. J., doi:10.1016/j.aej.2024.09.032)
    builds its taxonomy around RL;
  - tooling exists (ns3-gym, Gawłowicz & Zubow, MSWiM 2019; PRISMA, a
    multi-agent RL routing playground on ns-3).

  No head-to-head reproducible benchmark was found. That is both the risk (no
  agreed setup) and the opportunity (this repo's 20-seed paired-test harness is
  exactly what that comparison lacks). The roadmap's existing non-goal says a
  DRL baseline is "planned but gated: a leaky comparison would damage
  credibility". The replan keeps the gate and states what lifts it (train/test
  seed split, held-out families, the training budget reported).
- **Q-routing.** A tabular, non-deep RL comparator is cheap, old (Boyan &
  Littman 1994) and the natural "learning but not ants" control.
- **Hybrid ACO variants.** In the 2024–2025 literature found, recent ACO-for-LEO
  work mostly hybridises ACO with another metaheuristic to escape stagnation:
  - ACO + sparrow search (IEEE ICDSCA 2024);
  - SAT-IACO (Springer 2025), for satellite IoT access rather than routing.

  None reports an ns-3 or comparable-harness evaluation in what was found.

## 5. Store-carry-forward (DTN) — why it stays out, and what would bring it in

DTN routing is a capability AntHocNet structurally lacks: it drops a packet it
cannot forward after `QueueTimeout`. The swarm literature has ACO-for-DTN
designs:

- ACR (Yang et al., 2012): ≥ 25.8 % lower delay than other forwarding schemes
  on the Infocom/RollerNet traces;
- GrAnt (SBrT): more deliveries with fewer replicas than Epidemic and PROPHET.

**What would bring it in:** suppose the disaster family (§2) shows that
partition-bound loss dominates AntHocNet's shortfall there, i.e. the oracle
also fails, as the sparse cells already show. Then an opt-in carry buffer is
the measured next step, and maritime (§2) comes with it.

## 6. Sources

Every entry was retrieved on 2026-10-09 at abstract or summary level.

**Families**
- Raffelsberger & Hellwagner, *Evaluation of MANET routing protocols in a realistic emergency response scenario*, WISES 2012 — [CCS Labs entry](https://www.ccs-labs.org/bib/raffelsberger2012evaluation/), [PDF](https://www.itec.aau.at/bib/files/WISES2012-cr.pdf)
- Reina et al., *Ad hoc network in a disaster area: a composite mobility model and its evaluation* — [HAL](https://hal.archives-ouvertes.fr/hal-00544222)
- Kioumourtzis et al., tactical MANET routing evaluation (2012) — [Univ. Patras](https://telematics.upatras.gr/?p=1808)
- Grandhomme et al., *Comparison of inter-MANET routing protocol evaluation tools* (2016) — [EURECOM](https://www.eurecom.edu/fr/publication/5061)
- *Satellite Communications in the New Space Era* (survey) — [arXiv 2002.08811](https://arxiv.org/pdf/2002.08811)
- *Bridging Earth and Space: A Survey on HAPS for Non-Terrestrial Networks* (2025) — [arXiv 2510.19731](https://arxiv.org/pdf/2510.19731)
- *Survey on Near-Space Information Networks* — [arXiv 2310.09025](https://arxiv.org/pdf/2310.09025)
- ACAR (ant colony routing for UASN), IET Communications — [IET](https://digital-library.theiet.org/content/journals/10.1049/iet-com.2020.0160)
- Aqua-Sim NG (ns-3 port) — [GitHub](https://github.com/rmartin5/aqua-sim-ng); Aqua-Sim FG — [arXiv 2410.20698](https://arxiv.org/html/2410.20698v1)
- Durand & Booysen, *Performance Evaluation of a Mesh-Topology LoRa Network*, Sensors 2025 — [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11902654/)
- Multi-hop and mesh for LoRa networks (survey) — [UMS eprints](https://eprints.ums.edu.my/id/eprint/44907)
- Maritime communication review, J. Mar. Sci. Eng. 12:1264 (2024) — [MDPI](https://mdpi-res.com/d_attachment/jmse/jmse-12-01264/article_deploy/jmse-12-01264.pdf)
- *Survey on Neighbor Discovery and Beam Alignment in mmWave-Enabled UAV Swarm Networks* (2024) — [arXiv 2410.11490](https://arxiv.org/pdf/2410.11490)

**Mechanisms**
- Mobility-anticipated ETX — [HAL hal-01072234](https://hal.archives-ouvertes.fr/hal-01072234)
- Neishaboori & Kesidis, *SINR-sensitive routing in wireless 802.11 mesh networks* — [Penn State](https://pure.psu.edu/en/publications/sinr-sensitive-routing-in-wireless-80211-mesh-networks/)
- Draves, Padhye & Zill, mesh routing metrics — [Microsoft Research](https://microsoft.com/en-us/research/wp-content/uploads/2016/02/mesh-metrics.pdf)
- iCAR: intersection-based connectivity-aware routing — [ICESI repository](https://repository.icesi.edu.co/handle/10906/83089)
- ML link-lifetime prediction in VANETs, Sensors 2022 — [doi:10.3390/s22166038](https://api.crossref.org/works/10.3390%2FS22166038)
- Driving path stability in VANETs — [arXiv 1906.08370](https://arxiv.org/pdf/1906.08370)
- Mavrovouniotis & Yang, adaptive / self-adaptive evaporation — [CUT repository](https://ktisis.cut.ac.cy/handle/20.500.14279/30859), [Springer](https://link.springer.com/doi/10.1007/978-3-642-37192-9_61)
- BeeAdHoc, GECCO 2005 — [PDF](https://gpbib.cs.ucl.ac.uk/gecco2005/docs/p153.pdf); PEEBR — [SAI](https://saiconference.com/Downloads/Volume5No4/Paper_11-On_the_Performance_of_the_Predicted_Energy_Efficient_Bee-Inspired_Routing_PEEBR.pdf)
- Hybrid ant-colony inter-cluster routing for FANET, Sci. Rep. 2024 — [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11228038/)

**Comparators**
- DeepCQ+ — [arXiv 2101.03273](https://export.arxiv.org/abs/2101.03273v1)
- ns3-gym — [arXiv 1810.03943](https://arxiv.org/pdf/1810.03943)
- ACO + sparrow search for LEO routing (2024) — [BUAA](https://research.buaa.edu.cn/en/publications/a-novel-ant-colony-and-sparrow-search-optimization-based-routing-/)
- SAT-IACO (2025) — [Springer](https://link.springer.com/article/10.1007/s44443-025-00286-x)
- Zhang et al., ACO-based MANET routing survey, IEEE Access 2017 — [IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8066299)

**Swarm comparators**
- Güneş et al., ARA — the ant-colony based routing algorithm for MANETs (2002) — [FU Berlin](https://cst-pub.imp.fu-berlin.de/Guenes2002e.html)
- Roth & Wicker, Termite (SIDM 2005) — [PDF](https://forum.cone.informatik.uni-freiburg.de/teaching/seminar/adhoc-s08/mobiPapers/SIDM2005.pdf); Roth thesis — [Cornell eCommons](https://ecommons.cornell.edu/bitstream/handle/1813/240/thesis2.pdf;sequence=1); seminar critique — [Freiburg](https://forum.cone.informatik.uni-freiburg.de/teaching/seminar/adhoc-s08/finalTalks/05fin_Termite_Max_Fechner.pdf)
- Wang, HOPNET (2007 thesis) — [UManitoba MSpace](https://mspace.lib.umanitoba.ca/bitstream/1993/20935/1/Wang_HOPNET_a.pdf)
- Ducatelle, AntHocNet thesis (2007) — [USI](https://susi.usi.ch/rerodoc/9027/files/2007INFO001.pdf)
- *Performance Analysis of Swarm Based Routing Protocols for MANETs* (NS-2 thesis, Thapar University) — [TUDR](https://tudr.thapar.edu/items/22361eb3-790e-4330-bfe9-1bb009c24e4c)

**DTN**
- Routing in delay-tolerant networking (overview) — [Wikipedia](https://en.wikipedia.org/wiki/Routing_in_delay-tolerant_networking)
- ACR, ant-colony DTN routing (2012) — [CRAD](https://crad.ict.ac.cn/en/article/id/677)
- GrAnt — [SBrT](https://biblioteca.sbrt.org.br/articlefile/1547.pdf)
