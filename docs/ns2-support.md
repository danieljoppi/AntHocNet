# NS-2 support (deprecated)

Everything about the NS-2 target in one place: its status, how to install and
run it while it lasts, the images, and what happens when it goes away. The
[README](../README.md) carries a single pointer here rather than repeating any
of it.

**Status in one line:** NS-2 is **deprecated and frozen at
[v1.2.0](https://github.com/danieljoppi/AntHocNet/releases/tag/v1.2.0)** — no
new NS-2 work lands, the adapter still ships through the rest of the `v1.x`
line, and it is **removed at v2.0.0**
([#307](https://github.com/danieljoppi/AntHocNet/issues/307)).

## What "frozen" means, precisely

| | |
|---|---|
| **Last actively-supported release** | `v1.2.0` — the last release NS-2 work was done *for* |
| **Still ships the adapter** | every `v1.x` release, including the current one |
| **First release without it** | `v2.0.0` (dropping a platform is breaking, so it needs a major) |
| **What still runs in CI today** | adapter compile + e2e smoke on real ns-2.34 / ns-2.35 trees, patch apply/revert round-trip, a valgrind leg |
| **What does not happen** | new features, a benchmark harness ([#25](https://github.com/danieljoppi/AntHocNet/issues/25) is closed as not-planned), parity investigations |

Nothing already published is withdrawn. Pin `v1.2.0` or its immutable images
for the last actively-supported state; that release stays citable at its own
version DOI, [`10.5281/zenodo.21762983`](https://doi.org/10.5281/zenodo.21762983),
which keeps resolving after the adapter is removed from `main`.

## Why it is being retired

The full reasoning is on [#307](https://github.com/danieljoppi/AntHocNet/issues/307);
the short version:

- It is the **only target that requires edits inside the simulator's own
  tree**. ns-3 installs as an additive `contrib/` module; NS-2 needs an
  idempotent anchor-based source patch ([ADR-0005](adr/0005-ns2-idempotent-anchor-patch.md))
  that breaks — loudly, by design — whenever upstream moves a text anchor.
- It **never got a benchmark harness**. The NS-2 leg runs a CI smoke asserting
  non-zero delivery over a forced 2-hop route and nothing else, so the
  "cross-simulator validation" it was meant to provide was never actually
  built.
- Contemporary reviewers read NS-2 in a 2026 paper as a **reproducibility red
  flag rather than a credential** (the survey work behind
  [#298](https://github.com/danieljoppi/AntHocNet/issues/298)).
- It consumes real CI and packaging budget: two adapter-compile jobs against
  real ns-2.34/2.35 trees, a valgrind leg, a patch round-trip job, and four
  published container images.

What removal does **not** change: the simulator-agnostic [`core/`](../core),
the ports seam, and the "no NS headers in `core/`" golden rule all stay. See
[ADR-0002](adr/0002-one-core-two-adapters.md).

## Install

```bash
make install-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
cd /path/to/ns-allinone-2.3x/ns-2.3x && make
```

Uninstall: `make uninstall-ns2 NS2DIR=...` — reverts the patch cleanly and
byte-for-byte. Per-adapter detail (patch anchors, TCL bindings, example
scenarios) is in [`ns2/README.md`](../ns2/README.md).

## Docker images

```bash
docker run --rm -it ghcr.io/danieljoppi/anthocnet-ns2:2.35   # `ns` with the agent
docker run --rm -it ghcr.io/danieljoppi/ns2:2.35             # plain ns-allinone
```

| Image | Versions | Contents |
|-------|----------|----------|
| `ghcr.io/danieljoppi/anthocnet-ns2` | `2.34`, `2.35` | ns-2 + the AntHocNet patch (compiled) |
| `ghcr.io/danieljoppi/ns2` | `2.34`, `2.35` | plain ns-allinone-2.3x built from source |

The `-<release>` tier is **immutable** — `anthocnet-ns2:2.34-v1.2.0` and
`:2.35-v1.2.0` are the pins for reproducible NS-2 runs, and they stay pullable
after removal. Full tag-tier explanation in [docker/README.md](../docker/README.md).

## Why the architecture is the way it is

NS-2 and NS-3 are different architectures, so there is no single universal
patch. The algorithm (pheromone table, evaporation/reinforcement, ant
construction, routing decisions) lives in [`core/`](../core) and is shared
verbatim; each simulator gets only a thin adapter:

| | NS-2 | NS-3 |
|---|---|---|
| Integration | OTcl + `Agent`, pooled packet headers, **core-tree edits** | additive module subclassing `Ipv4RoutingProtocol` |
| Install | patch + recompile | drop-in + build |
| Packet header | POD `PacketHeaderClass` | `ns3::Header` |

Design detail in [architecture.md](architecture.md).

## See also

- [`ns2/README.md`](../ns2/README.md) — per-adapter install/run details.
- [porting-notes.md](porting-notes.md) — NS-2 patch anchors, the bugs fixed
  during extraction, wire-format and version caveats.
- [cross-validation.md](cross-validation.md) — the NS-2 vs NS-3 behaviour
  check (retired or re-scoped with the removal, per #307 phase 3).
- [ADR-0005](adr/0005-ns2-idempotent-anchor-patch.md) — why the patch is
  anchor-based and idempotent rather than line-numbered.
- [#307](https://github.com/danieljoppi/AntHocNet/issues/307) — the removal
  epic: decision, scope, phases, acceptance.
