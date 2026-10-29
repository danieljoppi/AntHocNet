# Licensing

AntHocNet is licensed per directory
([ADR-0028](docs/adr/0028-core-is-dual-licensed.md)):

| Path | Licence | Text |
|------|---------|------|
| `core/` (the simulator-agnostic algorithm core, its tests and benchmarks) | `MIT OR GPL-2.0-only`, at your choice | [`core/LICENSE`](core/LICENSE) (MIT) and [`LICENSE`](LICENSE) (GPL-2.0) |
| Everything else (`ns3/`, `web/`, `tools/`, `docs/`, `results/`, `api/`, `paper/`, …) | `GPL-2.0-only` | [`LICENSE`](LICENSE) |
| `ns3/baselines/aomdv/`, `ns3/baselines/gpsr/` | `GPL-2.0-only`, third-party (Copyright IITP RAS); provenance in each module's `README.md` | [`LICENSE`](LICENSE) |

Each source file states its licence in an `SPDX-License-Identifier` line.
`docs/tools/check-headers.py` checks those lines in CI.

## What this means in practice

- **Using the core on its own** (in another simulator, a routing daemon,
  firmware, or a closed-source product) is allowed under MIT. Keep the
  copyright notice and the MIT text from `core/LICENSE`.
- **Using the ns-3 module** (`make install-ns3`, the module tarball) or the
  learn site gives you a combined work that includes GPL-2.0-only code. It is
  distributed under GPL-2.0. The `core/` files inside it keep their dual notice.
- **The dependency only goes one way.** GPL code may use `core/`, but `core/`
  never includes code from outside `core/`. CI enforces this, so the MIT option
  always stays real.
- **Contributions** to `core/` are accepted under both licences. Contributions
  anywhere else are accepted under GPL-2.0-only. See
  [`CONTRIBUTING.md`](CONTRIBUTING.md).
- **Past releases are unchanged.** Every release up to and including v2.6.0 is
  GPL-2.0-only, `core/` included.
