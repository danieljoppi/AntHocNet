# AntHocNet

[![CI](https://github.com/danieljoppi/AntHocNet/actions/workflows/ci.yml/badge.svg)](https://github.com/danieljoppi/AntHocNet/actions/workflows/ci.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/danieljoppi/AntHocNet/badge)](https://scorecard.dev/viewer/?uri=github.com/danieljoppi/AntHocNet)
[![Release](https://img.shields.io/github/v/release/danieljoppi/AntHocNet?sort=semver&cacheSeconds=1800)](https://github.com/danieljoppi/AntHocNet/releases)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20981979.svg)](https://doi.org/10.5281/zenodo.20981979) 
[![Cite](https://img.shields.io/badge/cite-CITATION.cff-blue)](CITATION.cff)
[![License: GPL v2](https://img.shields.io/badge/license-GPL--2.0-blue)](LICENSE)
[![C++14](https://img.shields.io/badge/C%2B%2B-14-blue?logo=cplusplus)](CONTRIBUTING.md)
[![Simulators](https://img.shields.io/badge/simulators-ns--2%20%C2%B7%20ns--3-informational)](#)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow)](https://www.conventionalcommits.org)
[![Top language](https://img.shields.io/github/languages/top/danieljoppi/AntHocNet)](#)
[![Docs](https://img.shields.io/badge/docs-site-blue)](https://danieljoppi.github.io/AntHocNet/)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/danieljoppi/AntHocNet?quickstart=1)

**A paper-faithful AntHocNet you can install on a stock ns-3 tree in three
commands** — a drop-in `contrib/` module, no forked simulator. It is benchmarked
against AODV / OLSR / DSDV on identical scenarios under a fixed methodology
(20-seed, 900 s runs; every published number carries a 95% confidence interval —
[methodology](docs/benchmarks/methodology.md)). The algorithm itself is
simulator-independent C++ with its own unit-test suite: `make test` runs it with
no simulator installed. Releases are archived on Zenodo with DOIs, so results
can cite an exact, immutable version.

![Benchmark summary: PDR, mean delay and NRL for AntHocNet vs AODV, OLSR and DSDV across six named MANET scenarios, with 95% CI error bars](docs/benchmarks/discrete-summary.png)

*AntHocNet vs AODV / OLSR / DSDV across the six named MANET scenarios (error
bars: 95% CI) — current numbers and per-scenario pages in
[docs/benchmarks.md](docs/benchmarks.md).*

An ant-colony-optimization routing protocol for mobile ad-hoc networks,
implemented once as a **simulator-agnostic algorithm core** with thin adapters
for **NS-2** and **NS-3**.

The repository no longer bundles a copy of any simulator. You install AntHocNet
onto *your own* NS-2 or NS-3 tree:

- **NS-3** — installed as an additive `contrib/` module (ns-3.36+, with a
  `wscript` for older waf builds).
- **NS-2** — installed as an idempotent source patch (`ns-2.34` / `ns-2.35`).

> [!NOTE]
> **NS-2 is deprecated and frozen at
> [v1.2.0](https://github.com/danieljoppi/AntHocNet/releases/tag/v1.2.0)** — it
> still ships through the rest of `v1.x` and is removed at v2.0.0
> ([#307](https://github.com/danieljoppi/AntHocNet/issues/307)). Everything
> NS-2 — status, install, images, rationale — lives in
> **[docs/ns2-support.md](docs/ns2-support.md)**. ns-3 is the supported target
> and is what the rest of this README describes.

```
core/   simulator-agnostic C++ (no NS-2/NS-3 dependency) + unit tests
ns2/    thin Agent adapter + anchor-based source patch installer
ns3/    native Ipv4RoutingProtocol module
docs/   architecture, configuration, benchmarks, fidelity, ADRs — map in docs/README.md
```

## Why one core, thin adapters

Simulators differ in architecture, so there is no single universal patch. The
algorithm (pheromone table, evaporation/reinforcement, ant construction,
routing decisions) lives in [`core/`](core) and is shared verbatim; each
simulator gets only a thin adapter that converts packets and executes the
decisions the core returns. See [docs/architecture.md](docs/architecture.md)
(and [docs/ns2-support.md](docs/ns2-support.md) for how the NS-2 adapter
differs).

```mermaid
flowchart TB
    H["Benchmark harnesses (ns3/examples)<br/>anthocnet-compare · isl-grid · run-scenarios.py"]

    subgraph NS3["ns3/ — contrib module (supported)"]
        A3["RoutingProtocol : Ipv4RoutingProtocol<br/>~30 attributes = the config surface"]
    end
    subgraph NS2["ns2/ — source patch (frozen at v1.2.0)"]
        A2["AntHocNetAgent : Agent"]
    end

    P["Ports: IClock · IRng · INeighborProvider · ITimerScheduler"]

    subgraph CORE["core/ — simulator-agnostic C++, unit-tested (make test)"]
        C1["AntRouterLogic → RouteDecision"]
        C2["PheromoneTable · PheromoneEngine"]
        C3["AntMessage codec (versioned wire format)"]
    end

    H --> A3
    A3 --> P
    A2 --> P
    P --> C1
    C1 --- C2 --- C3

    style CORE fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
```

The full stack — every mechanism, the switch that gates it, and what is
live/inert per network regime — is diagrammed in
[docs/software-layers.md](docs/software-layers.md).

## Quick start

### Run a simulation with zero setup (Codespaces / VS Code devcontainer)

One click gives you a container with ns-3.42 already built ([`.devcontainer/`](.devcontainer/),
on the pinned [GHCR image](docker/README.md)); it installs this checkout's AntHocNet module and
builds it for you. Locally: clone, then VS Code → *Dev Containers: Reopen in Container*. When the
setup log finishes:

```bash
cd /opt/ns-3
./ns3 run anthocnet-example                          # your first simulation
./ns3 run "anthocnet-compare --nNodes=20 --time=30"  # vs AODV / OLSR / DSDV
```

### Run the core unit tests

```bash
make test
```

(Builds `core/` with CMake and runs the ctest suite — no simulator needed.)

### Install on NS-3

```bash
make install-ns3 NS3DIR=/path/to/ns-3-dev
cd /path/to/ns-3-dev && ./ns3 configure --enable-examples --enable-tests && ./ns3 build
./ns3 run anthocnet-example
```

Uninstall: `make uninstall-ns3 NS3DIR=...`. Details in
[ns3/README.md](ns3/README.md).

The NS-3 module also ships `anthocnet-compare`, which benchmarks AntHocNet
against AODV / OLSR / DSDV on an identical scenario (delivery ratio, delay,
throughput via FlowMonitor) — see [ns3/README.md](ns3/README.md#compare-against-aodv--olsr--dsdv).
Current results, regenerated on every merge to the default branch, are in
[docs/benchmarks.md](docs/benchmarks.md); the commands to reproduce a run, and
the validation anchors to check first, are in
[docs/benchmarks/methodology.md](docs/benchmarks/methodology.md).

### Tune the protocol

Every tunable parameter, its default, **where that default came from**, and the
calibration loop (sweep one knob → A/B → noise verdict) are in
[docs/configuration.md](docs/configuration.md). ns-3 exposes them as attributes:

```bash
./ns3 run "anthocnet-compare --scenario=paper --runs=5 \
  --ns3::anthocnet::RoutingProtocol::HopTime=0.003"
```

### Container images

Prefer not to install a simulator yourself? Pre-built images are published to
GHCR (`ghcr.io/danieljoppi/…`) — for **each supported version**, a plain simulator
and the same simulator with AntHocNet built in (so you can compare against a
clean baseline):

```bash
docker run --rm ghcr.io/danieljoppi/anthocnet-ns3:3.42 ./ns3 run anthocnet-example
```

Each image has three tag tiers: `:<sim-version>` (e.g. `:3.42`, latest build for
that simulator version), `:<sim-version>-<release>` (e.g. `:3.42-v0.3.0`,
**immutable** — pin this for reproducible / citable runs), and `:latest` (newest
simulator version + latest AntHocNet). The `:<sim-version>` and `:latest` tiers
track the default branch; the `-<release>` tier is fixed to a release.

**AntHocNet images** — the simulator with our protocol built in:

| Image | Versions | Contents |
|-------|----------|----------|
| `ghcr.io/danieljoppi/anthocnet-ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | ns-3 + the AntHocNet module |

**Plain images** — a clean simulator (no AntHocNet) for baseline comparisons:

| Image | Versions | Contents |
|-------|----------|----------|
| `ghcr.io/danieljoppi/ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | plain ns-3 with the comparison protocols (AODV/OLSR/DSDV/…) |

NS-2 images (`anthocnet-ns2`, `ns2`) are listed in
[docs/ns2-support.md](docs/ns2-support.md). Build them yourself or see the full
matrix in [docker/README.md](docker/README.md).

## Supported network regimes

The same protocol binary runs in two very different networks: the **MANET
fields** (paper + thesis, via `anthocnet-compare`) and a **satellite ISL +Grid
snapshot** (via `isl-grid`), with VANET/FANET mobility families planned. What
is *unknown* in each regime decides which of AntHocNet's mechanisms matter
there — the family table, the side-by-side harness comparison, and the
mechanism-by-mechanism live/inert map are all in
[docs/network-regimes.md](docs/network-regimes.md).

## What changed from the original

The original project was a whole vendored `ns-allinone-2.34` snapshot with the
protocol buried inside it. This refactor:

- extracts the algorithm into a portable, tested `core/` library;
- replaces the NS-2-coupled, header-resident malloc'd pointer arrays with POD
  value types — removing a memory leak, a broadcast double-free, and an
  incorrect serialized packet size;
- fixes the pheromone-evaporation bug (competing links were never aged),
  widens the ant sequence number past 8 bits, and bounds the dedup history;
- ships the NS-2 integration as an idempotent, anchor-based patch instead of a
  forked simulator tree;
- adds a native NS-3 module.

History of the work is in the per-phase commits; design rationale is in
[docs/](docs):

- [architecture.md](docs/architecture.md) — core/ports design and decision flow
- [porting-notes.md](docs/porting-notes.md) — bug fixes, NS-2 anchors, caveats
- [configuration.md](docs/configuration.md) — every parameter, its provenance, how to calibrate
- [benchmarks.md](docs/benchmarks.md) — AntHocNet vs AODV/OLSR/DSDV (auto-updated)
- [ns2-support.md](docs/ns2-support.md) — the deprecated NS-2 target: status, install, images, rationale

## Documentation

| Document | Purpose |
|----------|---------|
| [docs/README.md](docs/README.md) | **The docs map** — every page in `docs/`, grouped by what you are trying to do. |
| [docs/ant-colony-routing.md](docs/ant-colony-routing.md) | Concepts primer: ant foraging → ACO → AntNet → AntHocNet, and how they map to the code. Start here for the *idea*. |
| [docs/ant-types.md](docs/ant-types.md) | The five ant types side by side: what triggers each, how it travels, what it writes, which switch gates it — plus lifecycle diagrams. |
| [docs/architecture.md](docs/architecture.md) | Design, the core/adapter split, and the decision flow. |
| [docs/roadmap.md](docs/roadmap.md) | Where the project is going: release ladder, epic dependency graph, exit criteria per release, and what is deliberately not planned. |
| [docs/software-layers.md](docs/software-layers.md) | Diagrams: the software stack, ant mechanisms + their config switches, and what runs (live/inert/planned) in each network regime. |
| [docs/porting-notes.md](docs/porting-notes.md) | Bugs fixed in extraction, NS-2 patch anchors, wire format, version caveats. |
| [docs/configuration.md](docs/configuration.md) | **Every tunable parameter, its default and where that default came from**, the ns-3 attribute / NS-2 bind for it, and the calibration loop. Read before changing a knob or trusting one. |
| [docs/benchmarks.md](docs/benchmarks.md) | Results index → [metrics](docs/benchmarks/metrics.md), [methodology](docs/benchmarks/methodology.md), per-scenario and per-sweep pages. |
| [docs/fidelity.md](docs/fidelity.md) | What v1.0 reproduces from the 2004 paper and where it deliberately deviates. |
| [docs/wire-format.md](docs/wire-format.md) | Canonical on-wire ant layout, version byte, and diff vs. the original and the papers. |
| [docs/publications/](docs/publications/README.md) | Source-of-truth digests of the 2004 paper and 2007 thesis — what every fidelity claim is checked against. |
| [docs/network-regimes.md](docs/network-regimes.md) | Why MANET and satellite/ISL routing are different problems (the satellite research track's ground rules), and which AntHocNet mechanism is live/inert in each regime (§6). |
| [docs/adr/](docs/adr/README.md) | Architecture Decision Records 0001–0020, indexed — the "why" behind the structure. |
| [paper/](paper/) | JOSS software-paper draft (`paper.md`/`paper.bib`), for submission against this repo. |
| [CONTEXT.md](CONTEXT.md) | Project orientation: domain background, repo map, current state, glossary, open questions. |
| [AGENTS.md](AGENTS.md) | Build/verify/conventions and invariants for contributors and AI agents. |
| [docs/ns2-support.md](docs/ns2-support.md) | **The deprecated NS-2 target, end to end** — status and what "frozen" means, install, images, why it is retired. |
| [ns2/README.md](ns2/README.md) · [ns3/README.md](ns3/README.md) | Per-adapter install/run details. |
| [docker/README.md](docker/README.md) | Pre-built container images (plain vs. AntHocNet, per simulator version). |

## Releases & citing

Versioning follows [SemVer](https://semver.org); see [CHANGELOG.md](CHANGELOG.md).
Tagging `vX.Y.Z` builds a lean **install bundle** zip and publishes a GitHub
[Release](https://github.com/danieljoppi/AntHocNet/releases) (via
`.github/workflows/release.yml`). There is no prebuilt simulator `.so`/installer
by design — an ns-2/ns-3 module is ABI/version-locked to the user's tree, so it
is distributed as **source** (`make install-ns3` / `make install-ns2`) plus the
pre-built **Docker images** on GHCR (see [docker/README.md](docker/README.md)).

To cite this implementation, use the “Cite this repository” button (from
[CITATION.cff](CITATION.cff)). Each release is archived on
[Zenodo](https://zenodo.org) with its own DOI:

| DOI | resolves to |
|---|---|
| [`10.5281/zenodo.20981979`](https://doi.org/10.5281/zenodo.20981979) | **concept DOI** — always the latest release. This is the badge above, and the right citation when you mean "this project". |
| [`10.5281/zenodo.21795253`](https://doi.org/10.5281/zenodo.21795253) | **version DOI — `v1.3.0`.** Cite this when reproducing a published number: every benchmark result in `docs/benchmarks/` was measured at or before that tag, and `main` has since moved (see [Provenance](docs/benchmarks/methodology.md#provenance-which-version-a-number-was-measured-at)). |

Both are recorded in `CITATION.cff`; the version DOI for a future release is
added there when that release is archived. Please also cite the sources this
implements:

- G. Di Caro, F. Ducatelle, L. M. Gambardella, *AntHocNet: an Ant-Based Hybrid
  Routing Algorithm for Mobile Ad Hoc Networks*, PPSN VIII, LNCS 3242,
  pp. 461–470, Springer, 2004 — the algorithm ([digest](docs/publications/papers/2004-ppsn-anthocnet.md)).
- F. Ducatelle, *Adaptive Routing in Ad Hoc Wireless Multi-hop Networks*, PhD
  thesis, Università della Svizzera Italiana / IDSIA, 2007 — the designated
  primary source for parameters the paper leaves unspecified
  ([status](docs/publications/thesis/README.md)).

What this implementation reproduces from those sources — and every deliberate
deviation — is stated in [docs/fidelity.md](docs/fidelity.md).

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md) has the build/test steps per component, the
code style, and the Conventional-Commit PR-title rules; [AGENTS.md](AGENTS.md)
has the golden rules (invariants) and verification workflow. Bugs and findings
are tracked as GitHub issues with a label taxonomy
([ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md)); changes to
protocol behaviour are expected to carry an A/B benchmark verdict
([docs/configuration.md §5](docs/configuration.md#5-how-to-calibrate-a-parameter)).
Security reports: [SECURITY.md](SECURITY.md).

## License

See [LICENSE](LICENSE). Original implementation by Daniel Henrique Joppi.
