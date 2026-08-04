# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Note: the **software release version** (below) is distinct from the **on-wire
protocol version** (`kWireVersion`, see [docs/wire-format.md](docs/wire-format.md)),
which gates packet compatibility independently.

## Unreleased

### Deprecated
- **NS-2 support.** `v1.2.0` is the **last release in which the NS-2 adapter
  was actively supported** — it is frozen (no new NS-2 work) but still ships
  through the rest of the `v1.x` line, and is removed at `v2.0.0`
  ([#307](https://github.com/danieljoppi/AntHocNet/issues/307)). Nothing already
  published is withdrawn — pin the `v1.2.0` tag or its immutable images
  (`ghcr.io/danieljoppi/anthocnet-ns2:2.34-v1.2.0` / `:2.35-v1.2.0`), which stay
  pullable and citable at that release's DOI. The simulator-agnostic `core/`,
  its ports seam and the "no NS headers in `core/`" rule are unaffected.


First tagged release. Establishes the simulator-agnostic architecture, both
adapters, the benchmark harness, and reproducible CI/packaging.

### Added
- **Core** (`core/`): simulator-agnostic AntHocNet algorithm (pheromone table +
  engine, ant state machine, reactive setup, proactive ants, pheromone
  diffusion, hello-timeout link-failure detection + bounded repair) behind
  `IClock`/`IRng` ports, returning `RouteDecision`s. Bounds-checked wire codec.
  Unit + property tests, ASan/UBSan, libFuzzer corpus.
- **NS-2 adapter** (`ns2/`): idempotent source patch for ns-2.34 / ns-2.35,
  with a MAC transmit-failure repair hook.
- **NS-3 adapter** (`ns3/`): additive `contrib/` module (ns-3.36–3.48),
  `anthocnet-compare` benchmark, and `Tx`/`Rx`/`RouteChanged` trace sources.
- **Benchmarks**: classified scenario taxonomy + the paper's parameter sweeps,
  paper-style charts, NRL + 99th-percentile delay + `--diag` ant diagnostics;
  results auto-published to `docs/benchmarks.md` on every merge.
- **Reproducibility**: pre-built ns-2 / ns-3 Docker images on GHCR; CI builds
  against them across the version matrix.
- **Project**: `CITATION.cff`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`,
  security policy, and this changelog.

[Unreleased]: https://github.com/danieljoppi/AntHocNet/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/danieljoppi/AntHocNet/releases/tag/v0.1.0

## v1.2.0 (2026-08-02)

### Feat

- **bench**: corridor-cell pheromone sampler — the #216 mechanism trace for arms that fail to shift (#288)
- **core**: the proactive emission gate compares per-link — the #180 re-derivation, ADR-0018 (#284)
- **bench**: the asymmetric-congestion corridor cell on the ISL torus — #216 cell 1 (#280)
- **ns3**: per-interface transmit-queue congestion reader for the p2p/ISL regime + ADR-0017 (#206) (#277)
- **core**: the ILinkState congestion queries name the next hop — the stamp moves to where the interface is known (#206) (#276)
- **core**: virtual pheromone ages on the regular table's time-proportional clock (#262) (#275)
- **bench**: adopt the dedicated diversity cell — floor-relative gate at the churn-free window (#273)
- **ns3**: fast ISL failure detection via interface-down + failcell detect/reconverge split (#266)
- **skills**: satellite results pipeline — validate, parse and commit isl-grid output (#265)
- **bench**: split the benchmark surface into MANET and satellite views (#257)
- **core**: land the proactive emission gate, default OFF, with its experiment (#252)
- **bench**: add the thesis's eq 5.1 delay jitter alongside the FlowMonitor column (#247)
- **core**: per-ant-type gates and directed reactive discovery (#243)
- **ns3**: route next hops per interface and add the isl-grid scenario (#224)
- **bench**: measure path length, used-path diversity and flow fairness (#217) (#223)
- **bench**: break the anonymous packet loss down by cause (#215) (#222)
- **bench**: measure packet reordering, the documented cost of multipath (#212) (#221)
- **bench**: measure radio energy for all four protocols (#209) (#219)

### Fix

- **core**: receptions refresh the 1-hop pheromone at the metric's unloaded 1-hop value — not the legacy constant 1.0 (#279) (#283)
- **bench**: the corridor background transmits at constant duty — the OnOff default off-phase zeroed the congestion signal every other second (#282)
- **bench**: leak-free energy accounting — integrate the PHY State trace, drop BasicEnergySource + WifiRadioEnergyModel (#271)
- **bench**: let --energyJ=0 disable the energy model — the #256 OOM is its cancelled switchToOff events (#270)
- **bench**: cap sim address space at 13 GiB so an OOM dies gracefully, not with the runner (#269)
- **bench**: stream ##RSS## samples from the paper run — forensics that survive runner death (#268)
- **bench**: keep OOM forensics — print and upload time -v + stderr on a failed benchmark run (#267)
- **ns2**: add missing ns-default.tcl entries for four tcl-bound parameters (#261)
- **core**: restore proactiveInterval to 10 s — #252 leaked the 2 s rate it claimed not to ship (#255)
- **skills**: validate ##BENCH## cells' diagnostic lines, not just the table (#253)
- **bench**: carry jitter_eq51_ms through the campaign CSV (#249)
- **benchmarks**: catch the metric defects the campaigns exposed, and the gate starvation that hid them (#242)

## v1.1.0 (2026-07-26)

### Feat

- **core**: adopt the thesis's two-factor acceptance band as the reactive-setup default (#190)
- **skill**: compare a sweep across two code generations with a baseline control (#172)
- **core**: add an ILinkMetric registry mapping metric names to instances (#163)
- **skills**: campaign-loop tooling, scenario validation (#134), and ADR-0014 (#161)
- **infra**: publish a release-profile ns-3 campaign image (ns3:&lt;ver&gt;-opt) (#157)
- **bench**: emit ##PERF## wall-clock + peak-RSS lines per sim run (#139)
- **bench**: byte-normalized routing load nrl_bytes (#140)
- **bench**: emit per-run ##RUN## rows and paired A/B verdicts (#137)
- **core**: pheromone-table size gauge (regular/virtual) in counters + --diag (#141)
- **bench**: add --point for single-point sweep dispatch (#120)
- **bench**: add a --propagation override to run-scenarios.py (#114)

### Fix

- **bench**: correct the --scenario=thesis preset from the thesis, add extraArgs to scenario-matrix (#187)
- **core**: bound the reactive flood per (node, generation), not per ant path (#174)
- **core**: stop bounding reactive floods — a broadcast budget is a hop limit (#170)
- **core**: adopt T_hop = 3 ms from the 2007 thesis, replacing the provisional 50 ms (#167)
- **infra**: split the Docker Hub mirror into non-fatal steps so a bad token can't skip GHCR publishes (#159)
- **bench**: flush the CSV after every point, not just at script exit (#119)
- correct the Zenodo DOI (concept DOI, README badge + CITATION.cff) (#116)

## v1.0.0 (2026-07-23)

### Feat

- **ns3**: per-reason pending-queue hold cap, default ReconvHoldCap=1.0s (#21, #103) (#104)

## v0.5.0 (2026-07-20)

### Feat

- **core**: adopt the paper's routing exponents betaData=2 / betaAnts=1 (#70) (#100)
- **core**: fill hello advert slots active-first, then by best pheromone (#26 item 6.5) (#99)
- **core**: multipath reactive setup (1.5× acceptance filter) with linkfail churn bound, default on (#96) (#97)
- **core**: enforce the maxPathLength ant hop cap with a drop (#26, item 6.2) (#95)
- **ns3**: attribute pending-queue hold time by reason (#21) (#93)
- **ns3**: expose T_hop as the HopTime attribute (#88) (#92)

### Fix

- **ns3**: release held packets on backward-ant traversal and retry-timer route hits (#21) (#101)
- **ns3**: drive re-discovery for held data with a reactive-retry timer (#21) (#94)

## v0.4.0 (2026-07-19)

### Feat

- paper-parity QoS metrics, across-run dispersion, and the provisional thesis preset (#90)
- measured A2 MAC metric (ns-3 + ns-2) + blocking benchmark anchors (#87)
- **release**: release-pinned + :latest image tags, mirrored to Docker Hub (#77) (#79)

### Fix

- **ns3**: cut the delay tail via a measured 3 s pending-queue hold (#21) (#86)
- **core**: bound the LinkFail origin storm + honest convergence metric (#20, #23) (#85)
- **bench**: pin the paper's 2 Mbit/s radio — ns-3 default rate control halves single-hop PDR (#51) (#84)

## v0.3.0 (2026-07-06)

### Feat

- **bench**: gateway-hotspot scenario (--sink) to give the A2 metric a verdict (#72)
- **core**: congestion-aware per-hop metric from MAC queue occupancy (#55) (#67)
- **ns3**: re-inject MAC-failed data packets and expose detector-D tuning (#54)
- **core**: bound proactive broadcasts (#45) and add repair wait/discard timer (#49) (#53)
- **bench**: #24 propagation/range/area knobs, stock-baseline control, and PDR diagnostics (#50)

### Fix

- **ns3**: read AC_BE_NQOS so A2 has a queue signal — re-land --qdiag + CLAUDE.md (#75)

## v0.2.0 (2026-06-28)

### Feat

- **ns3**: wire MAC transmit-failure repair hook (detector D) (#43)

### Fix

- **core**: debounce detector D to stop the link-failure storm (#19)

## v0.1.1 (2026-06-28)

### Fix

- correct and expand README badges (#41)

## v0.1.0 (2026-06-28)
