# AGENTS.md — guide for AI coding agents

Operational guide for LLM agents working in this repository. Read this plus
[`CONTEXT.md`](CONTEXT.md) before changing anything. Design detail lives in
[`docs/architecture.md`](docs/architecture.md), maintenance detail in
[`docs/porting-notes.md`](docs/porting-notes.md), and the rationale behind the
structure in the [ADRs](docs/adr/).

## What this repo is

AntHocNet — an ant-colony-optimization MANET routing protocol — implemented
**once** as a simulator-agnostic algorithm core, with thin adapters for **NS-2**
and **NS-3**. The repo does **not** vendor a simulator; the adapters install
onto *your* NS-2 / NS-3 tree.

```
core/   simulator-agnostic C++ (no NS-2/NS-3 headers) + unit tests
ns2/    NS-2 Agent adapter + idempotent anchor-based source patch
ns3/    native ns3::Ipv4RoutingProtocol contrib module
docs/   architecture.md, porting-notes.md, adr/
```

## Build & verify

```bash
make test                                  # build core (CMake) + run ctest — fast, no simulator
bash ns2/patch/selftest.sh                 # NS-2 patch apply/revert round-trip on a synthetic tree
make install-ns2  NS2DIR=/path/to/ns-2.3x  # install onto a real NS-2 tree
make install-ns3  NS3DIR=/path/to/ns-3-dev # install onto a real NS-3 tree
make clean                                 # remove core/build
```

`make test` and the NS-2 patch self-test are the two checks that run in CI
(`.github/workflows/ci.yml`) on every push/PR and are runnable here. An actual
NS-2/NS-3 build needs an external simulator tree and is **not** possible from
this repo alone. **Always run `make test` before committing a core change**, and
`bash ns2/patch/selftest.sh` before touching `ns2/patch/`.

### Validating adapter (NS-2 / NS-3) changes — use CI

Because you cannot build a simulator here, the **CI matrix is how you validate
an adapter change**: develop, push a branch, open a PR, and read the job
results.

- `ci.yml` builds the **NS-3 module against the prebuilt GHCR images across
  ns-3.36–3.48** (e2e delivery smoke) and **compiles + runs the NS-2 adapter on
  real ns-2.34 / 2.35 trees**. Iterate on failures from the job logs —
  cross-version API drift is the usual cause (e.g. ns-3.36's non-`const`
  `Histogram` accessors, `RouteInput` by-value vs const-ref, scoped TestSuite
  enums). The `AHN_*`/`ANTHOCNET_NS3_*` macros in the NS-3 headers + CMake
  already gate several of these by version — extend that pattern, don't fork.
- Validate the **core** half locally first (`make test`); only the adapter/build
  half needs CI.
- Heavier, manual workflows: `paper-benchmark` and `scenario-matrix` (taxonomy +
  charts), `release.yml` (Commitizen bump + install-bundle), `images.yml`
  (republish simulator images). Releases are version-bumped by Commitizen from
  Conventional-Commit history; **PR titles must be Conventional Commits** (CI
  enforces it — see `CONTRIBUTING.md`).

## Golden rules (invariants — do not break)

1. **`core/` must never include an NS-2 or NS-3 header.** Time comes through
   `IClock`, randomness through `IRng`, neighbours through `INeighborProvider`,
   deferred work through `ITimerScheduler` (see `core/include/.../ports.h`).
   This is the property that keeps one algorithm working on both simulators.
2. **Adapters must not reimplement routing logic.** An adapter only: converts
   its packet header ⇄ `core::AntMessage`, carries out the `RouteDecision`s the
   core returns, owns the periodic timers and the pending-packet queue (and,
   for NS-2, the link-failure callback). Behaviour belongs in `core/`.
3. **All randomness via `IRng`, all time via `IClock`.** Never call libc
   `rand()` or read the simulator clock directly from shared logic —
   reproducibility depends on this.
4. **One canonical wire format, versioned.** `core/ant_message_codec` defines the
 little-endian layout, prefixed by a 1-byte `kWireVersion` (see
 `docs/wire-format.md` and ADR-0006). If you change `AntMessage` fields — or the
 units/semantics of an existing field — you must **bump `kWireVersion`** and
 update, in the same field order: the codec, the NS-2 header
 (`ns2/src/ant_packet_ns2`), the NS-3 header (`ns3/model/anthocnet-packet`
 `AntHeader`), the round-trip tests (`core/tests/test_codec.cpp`, NS-3 test
 suite), and the layout table in `docs/wire-format.md`.
5. **Keep bounded structures bounded.** The visited path and the `(src,seq)`
   dedup history are capped by `Config::maxPathLength` / `maxHistory`; do not
   reintroduce unbounded growth.
6. **NS-2 patching is anchor-based, never line-numbered.** Edits live as
   fragments under `ns2/patch/fragments/` and inject at stable text anchors
   with `ANTHOCNET-BEGIN/END` markers (or grep-guarded where a comment is
   illegal). Apply must stay idempotent and revert must restore byte-for-byte;
   `selftest.sh` enforces both.
7. **Cover core logic changes with a core unit test** in `core/tests/`.

## Conventions

- C++14 for `core/` (aggregate init with default member initializers); see the
  `-std=c++14` caveat for old NS-2 toolchains in `docs/porting-notes.md`.
- Namespace `anthocnet::core` for shared code.
- Make minimal, reviewable changes; update the relevant doc/ADR when you change
  a documented decision.
- When you open or update an issue, apply the label taxonomy from
  [ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md#labelling-convention):
  one type label (`bug`/`enhancement`/`chore`/`documentation`/`verification`,
  plus `epic` for umbrellas), area label(s) (`protocol`/`adapter`/`ns2`/`ns3`/
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
| Understand a structural decision / its "why" | `docs/adr/` |
| **Pick up open work** | GitHub issues (epics #26–#31; start with `priority:P1`) |
| Record a bug / finding, or hand off across sessions | [ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md) (always open/update an issue) + [`docs/handoffs/`](docs/handoffs/) |
| Maintain the NS-2 patch / wire format | `docs/porting-notes.md`, `ns2/patch/` |
| Change the algorithm | `core/src/`, `core/include/anthocnet/core/` |
| Change routing policy / decision flow | `core/src/ant_router_logic.cpp` |
| Change pheromone math | `core/src/pheromone_engine.cpp`, `pheromone_table.cpp` |
| Change the wire format | `docs/wire-format.md` → `core/include/.../ant_message_codec.h` (+ both adapters; bump `kWireVersion`) |
| Work on the NS-2 adapter | `ns2/src/`, `ns2/tcl/` |
| Work on the NS-3 adapter | `ns3/model/`, `ns3/helper/`, `ns3/examples/` |
| Run / read benchmarks | `docs/benchmarks.md`, `ns3/tools/run-scenarios.py` + `make-charts.py`, `anthocnet-compare --diag` |
| Inspect protocol internals | NS-3 `Tx`/`Rx`/`RouteChanged` trace sources; core counters via `IRouterObserver` |
| Compare benchmark A/B runs (deltas + noise verdict) | `benchmark-results` skill (`.claude/skills/benchmark-results/bench_parse.py`) |
| Pre-push invariant check on a diff | `protocol-review` skill (`.claude/skills/protocol-review/check_invariants.sh`) |
| Cut a release | run the `Release` workflow (Commitizen); see `CONTRIBUTING.md` |
| Tune defaults | `core/include/anthocnet/core/config.h` |
