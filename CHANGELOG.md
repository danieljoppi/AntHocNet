# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Note: the **software release version** (below) is distinct from the **on-wire
protocol version** (`kWireVersion`, see [docs/wire-format.md](docs/wire-format.md)),
which gates packet compatibility independently.

## [Unreleased]

## [0.1.0] - 2026-06-27

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
