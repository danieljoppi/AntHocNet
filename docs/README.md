# Documentation map

Where to find things in `docs/`. Repo-level orientation is one directory up:
[`README.md`](../README.md) (front door), [`CONTEXT.md`](../CONTEXT.md)
(project orientation + glossary), [`AGENTS.md`](../AGENTS.md) (build/verify,
golden rules, where-to-look), [`CONTRIBUTING.md`](../CONTRIBUTING.md).

## Understand the protocol

| Page | What it is |
|---|---|
| [ant-colony-routing.md](ant-colony-routing.md) | Concepts primer: ant foraging → ACO → AntNet → AntHocNet. Start here for the *idea*. |
| [ant-types.md](ant-types.md) | Reference for the five ant types: comparison table, lifecycle diagrams (setup, maintenance, repair), and how to observe them at runtime. |
| [architecture.md](architecture.md) | The core/adapter split, ports, and the decision flow. |
| [roadmap.md](roadmap.md) | Release ladder v1.3.0→v3.0.0, the epic dependency graph, per-release exit criteria, and the deliberate non-goals. Live status lives on #298. |
| [software-layers.md](software-layers.md) | Three diagrams: the software stack, the ant mechanisms + the switches that gate them, and what is live/inert/planned per network regime. |
| [network-regimes.md](network-regimes.md) | Why MANET and satellite/ISL are different routing problems — read before transferring an intuition between them. §6 tables which AntHocNet mechanism is live/inert in each regime. |

## Build, port, extend

| Page | What it is |
|---|---|
| [porting-notes.md](porting-notes.md) | Bugs fixed in extraction, NS-2 patch anchors, version caveats. |
| [ns2-support.md](ns2-support.md) | **The deprecated NS-2 target in one place** — frozen at v1.2.0, still ships through `v1.x`, removed at v2.0.0 ([#307](https://github.com/danieljoppi/AntHocNet/issues/307)); install, images, rationale. |
| [wire-format.md](wire-format.md) | Canonical on-wire ant layout and the `kWireVersion` rules (golden rule 4). |
| [configuration.md](configuration.md) | Every tunable, its default's **provenance**, the ns-3/NS-2 surface for it, and the calibration loop. |
| [cross-validation.md](cross-validation.md) | NS-2 vs NS-3 behaviour re-validation (not bit-for-bit parity). |

## Measure & reproduce

| Page | What it is |
|---|---|
| [benchmarks.md](benchmarks.md) | Results index: per-merge taxonomy table + links to every scenario/sweep page. |
| [benchmarks/metrics.md](benchmarks/metrics.md) | What PDR, delay99, NRL etc. mean, and their caveats. |
| [benchmarks/methodology.md](benchmarks/methodology.md) | Reproduce commands (local and CI dispatch), build profiles, validation anchors, determinism gate. |
| [benchmarks/README.md](benchmarks/README.md) | How the figures/tables are generated and regenerated. |
| [benchmarks/satellite/isl-grid.md](benchmarks/satellite/isl-grid.md) | The satellite/ISL suite: harness, analytic anchors, dispatch. |
| [benchmarks/grid.md](benchmarks/grid.md) | v1.4.0's mobility × channel grid and its scoped ranking-stability statement. |

## Research provenance & fidelity

| Page | What it is |
|---|---|
| [fidelity.md](fidelity.md) | What this implementation reproduces from the 2004 paper, and every deliberate deviation — the claims page. |
| [publications/](publications/README.md) | Source-of-truth digests of the 2004 PPSN paper and the 2007 Ducatelle thesis (no vendored PDFs). |
| [satellite-routing-prior-art.md](satellite-routing-prior-art.md) | ACO-on-constellations survey behind the satellite track (#192). |

## Decisions & process

| Page | What it is |
|---|---|
| [adr/](adr/README.md) | Architecture Decision Records 0001–0020, indexed with one-line summaries. |
| [handoffs/](handoffs/) | Dated cross-session investigation handoffs (see ADR-0013 for the issue-first discipline). |
