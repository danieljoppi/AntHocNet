# AntHocNet

[![CI](https://github.com/danieljoppi/AntHocNet/actions/workflows/ci.yml/badge.svg)](https://github.com/danieljoppi/AntHocNet/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/danieljoppi/AntHocNet?sort=semver&cacheSeconds=1800)](https://github.com/danieljoppi/AntHocNet/releases)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20981979.svg)](https://doi.org/10.5281/zenodo.20981979) 
[![Cite](https://img.shields.io/badge/cite-CITATION.cff-blue)](CITATION.cff)
[![License: GPL v2](https://img.shields.io/badge/license-GPL--2.0-blue)](LICENSE)
[![C++14](https://img.shields.io/badge/C%2B%2B-14-blue?logo=cplusplus)](CONTRIBUTING.md)
[![Simulators](https://img.shields.io/badge/simulators-ns--2%20%C2%B7%20ns--3-informational)](#)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow)](https://www.conventionalcommits.org)
[![Top language](https://img.shields.io/github/languages/top/danieljoppi/AntHocNet)](#)

An ant-colony-optimization routing protocol for mobile ad-hoc networks,
implemented once as a **simulator-agnostic algorithm core** with thin adapters
for **NS-2** and **NS-3**.

The repository no longer bundles a copy of any simulator. You install AntHocNet
onto *your own* NS-2 or NS-3 tree:

- **NS-2** — installed as an idempotent, version-independent source patch
  (`ns-2.34` / `ns-2.35`).
- **NS-3** — installed as an additive `contrib/` module (ns-3.36+, with a
  `wscript` for older waf builds).

```
core/   simulator-agnostic C++ (no NS-2/NS-3 dependency) + unit tests
ns2/    thin Agent adapter + anchor-based source patch installer
ns3/    native Ipv4RoutingProtocol module
docs/   architecture, configuration, benchmarks, fidelity, ADRs — map in docs/README.md
```

## Why one core, two adapters

NS-2 and NS-3 are different architectures, so there is no single universal
patch. The algorithm (pheromone table, evaporation/reinforcement, ant
construction, routing decisions) lives in [`core/`](core) and is shared
verbatim. Each simulator gets only a thin adapter:

| | NS-2 | NS-3 |
|---|---|---|
| Integration | OTcl + `Agent`, pooled packet headers, **core-tree edits** | additive module subclassing `Ipv4RoutingProtocol` |
| Install | patch + recompile | drop-in + build |
| Packet header | POD `PacketHeaderClass` | `ns3::Header` |

See [docs/architecture.md](docs/architecture.md).

## Quick start

### Run the core unit tests

```bash
make test
```

(Builds `core/` with CMake and runs the ctest suite — no simulator needed.)

### Install on NS-2

```bash
make install-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
cd /path/to/ns-allinone-2.3x/ns-2.3x && make
```

Uninstall: `make uninstall-ns2 NS2DIR=...` (reverts the patch cleanly). Details
in [ns2/README.md](ns2/README.md).

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
docker run --rm -it ghcr.io/danieljoppi/anthocnet-ns2:2.35   # `ns` with the agent
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
| `ghcr.io/danieljoppi/anthocnet-ns2` | `2.34`, `2.35` | ns-2 + the AntHocNet patch (compiled) |

**Plain images** — a clean simulator (no AntHocNet) for baseline comparisons:

| Image | Versions | Contents |
|-------|----------|----------|
| `ghcr.io/danieljoppi/ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | plain ns-3 with the comparison protocols (AODV/OLSR/DSDV/…) |
| `ghcr.io/danieljoppi/ns2` | `2.34`, `2.35` | plain ns-allinone-2.3x built from source |

Build them yourself or see the full matrix in [docker/README.md](docker/README.md).

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
- [cross-validation.md](docs/cross-validation.md) — NS-2 vs NS-3 behaviour check

## Documentation

| Document | Purpose |
|----------|---------|
| [docs/README.md](docs/README.md) | **The docs map** — every page in `docs/`, grouped by what you are trying to do. |
| [docs/ant-colony-routing.md](docs/ant-colony-routing.md) | Concepts primer: ant foraging → ACO → AntNet → AntHocNet, and how they map to the code. Start here for the *idea*. |
| [docs/architecture.md](docs/architecture.md) | Design, the core/adapter split, and the decision flow. |
| [docs/porting-notes.md](docs/porting-notes.md) | Bugs fixed in extraction, NS-2 patch anchors, wire format, version caveats. |
| [docs/configuration.md](docs/configuration.md) | **Every tunable parameter, its default and where that default came from**, the ns-3 attribute / NS-2 bind for it, and the calibration loop. Read before changing a knob or trusting one. |
| [docs/benchmarks.md](docs/benchmarks.md) | Results index → [metrics](docs/benchmarks/metrics.md), [methodology](docs/benchmarks/methodology.md), per-scenario and per-sweep pages. |
| [docs/fidelity.md](docs/fidelity.md) | What v1.0 reproduces from the 2004 paper and where it deliberately deviates. |
| [docs/wire-format.md](docs/wire-format.md) | Canonical on-wire ant layout, version byte, and diff vs. the original and the papers. |
| [docs/publications/](docs/publications/README.md) | Source-of-truth digests of the 2004 paper and 2007 thesis — what every fidelity claim is checked against. |
| [docs/network-regimes.md](docs/network-regimes.md) | Why MANET and satellite/ISL routing are different problems (the satellite research track's ground rules). |
| [docs/adr/](docs/adr/README.md) | Architecture Decision Records 0001–0018, indexed — the "why" behind the structure. |
| [paper/](paper/) | JOSS software-paper draft (`paper.md`/`paper.bib`), for submission against this repo. |
| [CONTEXT.md](CONTEXT.md) | Project orientation: domain background, repo map, current state, glossary, open questions. |
| [AGENTS.md](AGENTS.md) | Build/verify/conventions and invariants for contributors and AI agents. |
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
[CITATION.cff](CITATION.cff)). Once the repo is linked to
[Zenodo](https://zenodo.org), each release is archived with a DOI, which is then
added to `CITATION.cff`. Please also cite the sources this implements:

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
