# Licensing

AntHocNet is licensed per directory
([ADR-0028](docs/adr/0028-core-is-dual-licensed.md)):

| Path | Licence | Text |
|------|---------|------|
| `core/` (the simulator-agnostic algorithm core, its tests and benchmarks) | `MIT OR GPL-2.0-only`, at your choice | [`core/LICENSE`](core/LICENSE) (MIT) and [`LICENSE`](LICENSE) (GPL-2.0) |
| `tools/`, `ns3/tools/`, `docs/tools/` (the standalone tooling: benchmark parsing and statistics, campaigns, charts, CI checks, release scripts, their plans and fixtures) | `MIT OR GPL-2.0-only`, at your choice | [`LICENSE-MIT`](LICENSE-MIT) (MIT) and [`LICENSE`](LICENSE) (GPL-2.0) |
| `docs/tools/mkdocs_hooks.py` | `GPL-2.0-only`: it imports `web/shell/` | [`LICENSE`](LICENSE) |
| Everything else (the ns-3 modules under `ns3/`, including the `routing-bench` harness; `web/`; `docs/`; `results/`; `api/`; `paper/`; …) | `GPL-2.0-only` | [`LICENSE`](LICENSE) |
| `ns3/baselines/aomdv/`, `ns3/baselines/gpsr/` | `GPL-2.0-only`, third-party (Copyright IITP RAS); provenance in each module's `README.md` | [`LICENSE`](LICENSE) |

Each source file states its licence in an `SPDX-License-Identifier` line.
`docs/tools/check-headers.py` checks those lines in CI.

## What this means in practice

- **Using the core on its own** (in another simulator, a routing daemon,
  firmware, or a closed-source product) is allowed under MIT. Keep the
  copyright notice and the MIT text from `core/LICENSE`.
- **Using the tooling on its own** (the noise verdicts and paired statistics
  in `tools/bench/`, the campaign runner, the chart and parse scripts, the CI
  checks) is allowed under MIT as well, for any protocol on any simulator.
  These are standalone programs: they read logs and CSVs, and they import no
  ns-3 code and nothing GPL-only.
- **Using the ns-3 module** (`make install-ns3`, the module tarball) or the
  learn site gives you a combined work that includes GPL-2.0-only code. It is
  distributed under GPL-2.0. The `core/` files inside it keep their dual notice.
- **The dependency only goes one way.** GPL code may use the dual-licensed
  parts, but they never pull GPL-only code in. `core/` includes nothing from
  outside `core/`, and the dual-licensed Python loads nothing from `web/shell/`
  or `.claude/`. CI enforces both rules, so the MIT option stays real.
- **The C++ comparison harness stays GPL.** `ns3/routing-bench/` is an ns-3
  module that builds only inside a GPL ns-3 tree, so an MIT option would buy
  nothing there.
- **Contributions** to the dual-licensed paths are accepted under both licences. Contributions
  anywhere else are accepted under GPL-2.0-only. See
  [`CONTRIBUTING.md`](CONTRIBUTING.md).
- **Past releases are unchanged.** Every release up to and including v2.6.0 is
  GPL-2.0-only, `core/` and the tooling included.
