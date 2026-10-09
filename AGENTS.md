# AGENTS.md — guide for AI coding agents

Operational guide for LLM agents working in this repository. Read this plus
[`CONTEXT.md`](CONTEXT.md) before changing anything. Design detail lives in
[`docs/architecture.md`](docs/architecture.md), maintenance detail in
[`docs/porting-notes.md`](docs/porting-notes.md), and the rationale behind the
structure in the [ADRs](docs/adr/).

## What this repo is

AntHocNet — an ant-colony-optimization MANET routing protocol — implemented
**once** as a simulator-agnostic algorithm core, with a thin **NS-3** adapter
(and a browser adapter for the learn site). The repo does **not** vendor a
simulator; the module installs onto *your* NS-3 tree. The NS-2 adapter was
removed in v2.0.0 ([#307](https://github.com/danieljoppi/AntHocNet/issues/307),
[ADR-0023](docs/adr/0023-one-core-one-simulator-adapter.md)); it lives on at the
v1.2.0–v1.9.0 tags.

```
core/   simulator-agnostic C++ (no simulator headers) + unit tests
ns3/    native ns3::Ipv4RoutingProtocol contrib module
web/    browser adapter (core/ as WebAssembly) + the learn site
docs/   architecture.md, porting-notes.md, adr/ — full map in docs/README.md
```

## Build & verify

```bash
make test                                  # build core (CMake) + run ctest — fast, no simulator
make install-ns3  NS3DIR=/path/to/ns-3-dev # install onto a real NS-3 tree
make clean                                 # remove core/build
```

### Test coverage

`core/` has an opt-in gcov build (default build is untouched):

```bash
cmake -S core -B core/build-coverage -DCMAKE_BUILD_TYPE=Debug -DANTHOCNET_COVERAGE=ON
cmake --build core/build-coverage -j
cd core/build-coverage && ctest --output-on-failure && cd -
gcovr --root . core/build-coverage --filter 'core/src/' --filter 'core/include/' \
      --exclude 'core/tests/' --txt --print-summary   # pip install gcovr
```

CI's `core-coverage` job reports the same line/branch numbers **on every PR**
(per-file table in the job log, HTML + Cobertura XML as a downloadable
artifact). It is **report-only — there is no threshold** ([#162](https://github.com/danieljoppi/AntHocNet/issues/162)); a floor gets
chosen from evidence later. Read it as a map of untested paths to aim tests at,
not as a number to chase (CLAUDE.md rule 2).

`make test` is the check that runs in CI (`.github/workflows/ci.yml`) on every
push/PR and is runnable here. An actual NS-3 build needs an external simulator
tree and is **not** possible from this repo alone. **Always run `make test`
before committing a core change.**

### Validating adapter (NS-3) changes — use CI

Because you cannot build a simulator here, the **CI matrix is how you validate
an adapter change**: develop, push a branch, open a PR, and read the job
results.

- `ci.yml` builds the **NS-3 module against the prebuilt GHCR images across
  ns-3.36–3.48** (e2e delivery smoke). Iterate on failures from the job logs —
  cross-version API drift is the usual cause (e.g. ns-3.36's non-`const`
  `Histogram` accessors, `RouteInput` by-value vs const-ref, scoped TestSuite
  enums). The `AHN_*`/`ANTHOCNET_NS3_*` macros in the NS-3 headers + CMake
  already gate several of these by version — extend that pattern, don't fork.
- Sanitizer pass on the adapter (#130): the `ns3-asan` job rebuilds the
  ns-3 module under ASan/LSan (suppressions: `ns3/tools/lsan.supp`). It is
  `continue-on-error` while suppression calibration accumulates — read its log
  even when it shows green.
- Validate the **core** half locally first (`make test`); only the adapter/build
  half needs CI.
- Heavier, manual workflows: `paper-benchmark` and `scenario-matrix` (taxonomy +
  charts), `release.yml` (Commitizen bump + install-bundle), `images.yml`
  (republish simulator images). Releases are version-bumped by Commitizen from
  Conventional-Commit history; **PR titles must be Conventional Commits** (CI
  enforces it — see `CONTRIBUTING.md`).

## Golden rules (invariants — do not break)

1. **`core/` must never include a simulator header** (ns-3, or the NS-2 it
   once also ran on). Time comes through
   `IClock`, randomness through `IRng`, neighbours through `INeighborProvider`,
   deferred work through `ITimerScheduler` (see `core/include/.../ports.h`).
   This is the property that keeps one algorithm working on every adapter —
   ns-3 and the browser today (ADR-0021, ADR-0023).
2. **Adapters must not reimplement routing logic.** An adapter only: converts
   its packet header ⇄ `core::AntMessage`, carries out the `RouteDecision`s the
   core returns, owns the periodic timers and the pending-packet queue.
   Behaviour belongs in `core/`.
3. **All randomness via `IRng`, all time via `IClock`.** Never call libc
   `rand()` or read the simulator clock directly from shared logic —
   reproducibility depends on this.
4. **One canonical wire format, versioned.** `core/ant_message_codec` defines the
 little-endian layout, prefixed by a 1-byte `kWireVersion` (see
 `docs/wire-format.md` and ADR-0006). If you change `AntMessage` fields — or the
 units/semantics of an existing field — you must **bump `kWireVersion`** and
 update, in the same field order: the codec, the NS-3 header (`ns3/model/anthocnet-packet`
 `AntHeader`), the round-trip tests (`core/tests/test_codec.cpp`, NS-3 test
 suite), and the layout table in `docs/wire-format.md`.
5. **Keep bounded structures bounded.** The visited path and the `(src,seq)`
   dedup history are capped by `Config::maxPathLength` / `maxHistory`; do not
   reintroduce unbounded growth.
6. *(Retired at v2.0.0.)* NS-2 patching was anchor-based, never line-numbered
   ([ADR-0005](docs/adr/0005-ns2-idempotent-anchor-patch.md), now historical);
   the NS-2 adapter is gone. The number is kept so "golden rule 7" keeps
   meaning what every existing reference says.
7. **Cover core logic changes with a core unit test** in `core/tests/`.

## Conventions

- C++14 for `core/` (aggregate init with default member initializers).
- Namespace `anthocnet::core` for shared code.
- Make minimal, reviewable changes; update the relevant doc/ADR when you change
  a documented decision.
- When you open or update an issue, apply the label taxonomy from
  [ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md#labelling-convention):
  one type label (`bug`/`enhancement`/`chore`/`documentation`/`verification`,
  plus `epic` for umbrellas), area label(s) (`protocol`/`adapter`/`ns3`/
  `benchmark`/`observability`/`packaging`), one `model:*` recommendation, and
  one `priority:P1|P2|P3` label on non-epic issues.
  The `.github/ISSUE_TEMPLATE/` forms preset the type label for issues filed
  from the GitHub UI.
- Do not open a pull request unless explicitly asked.

## Git workflow

- Branch from `main` (`claude/<short-topic>`), one focused change per PR.
- **PR titles are Conventional Commits** (`feat:`/`fix:`/`docs:`/…) — CI enforces
  it, and since PRs are squash-merged the title is the commit on `main` and
  drives the next version bump. See `CONTRIBUTING.md`.
- Push with `git push -u origin <branch>`; open a PR; merge when CI is green.

## Where to look

| You want to… | Go to |
|--------------|-------|
| Understand the design & decision flow | `docs/architecture.md` |
| Check a claim/parameter against the papers | `docs/publications/` (digests of [1] + thesis status) |
| See what v1.0 reproduces / deviates from the paper | `docs/fidelity.md` |
| Understand a structural decision / its "why" | `docs/adr/` |
| **Pick up open work** | GitHub issues — start with the highest open `priority:P*` label (query live; see `CONTEXT.md` §10) |
| **Know which release a piece of work serves, or why something is *not* planned** | [#298](https://github.com/danieljoppi/AntHocNet/issues/298) — the 2026 roadmap: literature gap analysis → epics #293–#297, #300–#302 → release goals v1.3.0…v3.0.0, plus the non-goals with the reasoning that would reverse each |
| Understand the ant types (what each one is for, what it writes, which switch gates it) | [`docs/ant-types.md`](docs/ant-types.md) — comparison table + lifecycle diagrams for Hello / Reactive / Proactive / Repair / LinkFail and the backward ant |
| See the whole stack, or which mechanism is live/inert in a given regime | [`docs/software-layers.md`](docs/software-layers.md) — core → ports → adapters → harnesses, mechanisms × their config switches, and per-regime support |
| **Add support for a new network family** (FANET, VANET, …) | [ADR-0019](docs/adr/0019-network-families-change-the-evaluation-not-the-protocol.md) — a family is a *scenario* concern: mobility model, preset, preflight rules, anchor, metrics. **Never** family-specific protocol defaults; a mis-sized constant is an issue + A/B, not a preset. Tracks: [#300](https://github.com/danieljoppi/AntHocNet/issues/300), [#301](https://github.com/danieljoppi/AntHocNet/issues/301) |
| Work on security / trust mechanisms | [ADR-0020](docs/adr/0020-security-is-a-default-off-profile.md) — same implementation, behind attributes, **default off**, default path provably byte-identical; no fork. Track: [#302](https://github.com/danieljoppi/AntHocNet/issues/302) (v3.0.0) |
| Record a bug / finding, or hand off across sessions | [ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md) (always open/update an issue) + [`docs/handoffs/`](docs/handoffs/) |
| Maintain the wire format | `docs/wire-format.md`, `docs/porting-notes.md` |
| Change the algorithm | `core/src/`, `core/include/anthocnet/core/` |
| Change routing policy / decision flow | `core/src/ant_router_logic.cpp` |
| Change pheromone math | `core/src/pheromone_engine.cpp`, `pheromone_table.cpp` |
| Change the wire format | `docs/wire-format.md` → `core/include/.../ant_message_codec.h` (+ the ns-3 header; bump `kWireVersion`) |
| Find the removed NS-2 adapter | [`docs/ns2-support.md`](docs/ns2-support.md) — the v1.2.0 / v1.9.0 tags and images |
| Work on the NS-3 adapter | `ns3/model/`, `ns3/helper/`, `ns3/examples/` |
| Work on the browser adapter (the learn site's simulation) | `web/` ([README](web/README.md), [ADR-0021](docs/adr/0021-the-browser-is-an-adapter.md)); `web/test/parity.sh` must stay byte-identical native vs WASM (CI job `web-parity`) |
| Run / read benchmarks | `docs/benchmarks.md` (index → `docs/benchmarks/{metrics,methodology}.md`, `scenarios/<name>.md`, `sweeps/<name>.md`), `ns3/tools/run-scenarios.py` + `make-charts.py` + `update-benchmarks.py`; family/cross-family + sweep charts from committed data: `ns3/tools/family-charts.py` (re-rendered and committed by `charts.yml`), `anthocnet-compare --diag` |
| Inspect protocol internals | NS-3 `Tx`/`Rx`/`RouteChanged` trace sources; core counters via `IRouterObserver` |
| Run the benchmark campaign loop (dispatch → fetch → parse) | `benchmark-results` skill (SKILL.md documents the whole procedure) |
| Compare benchmark A/B runs (deltas + noise verdict) | `benchmark-results` skill (`tools/bench/bench_parse.py`) |
| Summarize / export campaign sweep CSVs | `benchmark-results` skill (`sweep_summary.py`; `--export-sweeps` feeds the papers repo) |
| Validate a scenario config or result plausibility | `benchmark-results` skill (`scenario_check.py`, #134): `preflight` before dispatching, `results [--anchor …]` before trusting numbers |
| Pre-push invariant check on a diff | `protocol-review` skill (`.claude/skills/protocol-review/check_invariants.sh`) |
| Understand why skills are script-first (and add a new analysis loop) | [ADR-0014](docs/adr/0014-agent-skills-are-script-first.md) — raw data stays out of LLM context; extend a skill script, don't eyeball |
| Work on satellite / ISL topologies | [ADR-0015](docs/adr/0015-satellite-substrate-lives-in-the-image.md) — **there is no separate satellite build**: one binary, scenario differences live in examples and flags (`isl-grid` static, `leo-walker` moving). [ADR-0022](docs/adr/0022-satellite-substrate-is-stock-ns3-leo.md) — the substrate is stock ns-3.48's LEO model, so moving-constellation work is 3.48-only. Track: [#192](https://github.com/danieljoppi/AntHocNet/issues/192) |
| **Understand why satellite ≠ MANET** (before assuming a MANET intuition transfers) | [`docs/network-regimes.md`](docs/network-regimes.md) — the inversion in one line: MANET hides the *topology* and gives you the traffic; a constellation gives you the topology and hides the *traffic*. Diagrams, and a difference table where every row traces to a defect, parameter or control in this repo |
| Cut a release | run the `Release` workflow (Commitizen); see `CONTRIBUTING.md`. **Post-release, record the version DOI** — Zenodo mints it async a few minutes after publish; read it from the public API (`curl -s "https://zenodo.org/api/records/20981980/versions?size=25&sort=version"`; address it through a *version* record — the concept ID 20981979 returns 404 on that endpoint), or ask the maintainer if `zenodo.org` is proxy-blocked (403, as it was until 2026-09). Never invent one. Then append a row to the DOI table in `CONTRIBUTING.md` via a `docs:` PR — the README badge and `CITATION.cff` stay on the concept DOI (#116) |
| Tune defaults | `core/include/anthocnet/core/config.h` |
| **Look up a parameter's default, its provenance, or how to calibrate it** | [`docs/configuration.md`](docs/configuration.md) — all 38 `Config` fields with a `source` column ([1] §/thesis/repo choice/**unknown**), the ns-3 attribute for each, the sweep→A/B→noise loop, and the checklist for adding a parameter. The `unknown` rows in §3.2 are the next #88/#169 candidates |
