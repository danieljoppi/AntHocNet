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
- Do not open a pull request unless explicitly asked.

## Git workflow

- Active development branch: `claude/anthocnet-protocol-review-wu1huq`.
- Commit with a descriptive message; push with `git push -u origin <branch>`.

## Where to look

| You want to… | Go to |
|--------------|-------|
| Understand the design & decision flow | `docs/architecture.md` |
| Understand a structural decision / its "why" | `docs/adr/` |
| Maintain the NS-2 patch / wire format | `docs/porting-notes.md`, `ns2/patch/` |
| Change the algorithm | `core/src/`, `core/include/anthocnet/core/` |
| Change routing policy / decision flow | `core/src/ant_router_logic.cpp` |
| Change pheromone math | `core/src/pheromone_engine.cpp`, `pheromone_table.cpp` |
| Change the wire format | `docs/wire-format.md` → `core/include/.../ant_message_codec.h` (+ both adapters; bump `kWireVersion`) |
| Work on the NS-2 adapter | `ns2/src/`, `ns2/tcl/` |
| Work on the NS-3 adapter | `ns3/model/`, `ns3/helper/`, `ns3/examples/` |
| Tune defaults | `core/include/anthocnet/core/config.h` |
