# NS-2 support (removed in v2.0.0)

Everything about the former NS-2 target in one place: what was removed, where
to get it, and why. The [README](../README.md) carries a single pointer here
rather than repeating any of it.

**Status in one line:** the NS-2 adapter was **removed in v2.0.0**
([#307](https://github.com/danieljoppi/AntHocNet/issues/307)). It was frozen at
[v1.2.0](https://github.com/danieljoppi/AntHocNet/releases/tag/v1.2.0), the last
release NS-2 work was done *for*, and shipped unchanged through
[v1.9.0](https://github.com/danieljoppi/AntHocNet/releases/tag/v1.9.0), the
last release that contains it.

## Where to get it

| | |
|---|---|
| **Last actively-supported release** | `v1.2.0` — citable at its own version DOI, [`10.5281/zenodo.21762983`](https://doi.org/10.5281/zenodo.21762983) |
| **Last release that ships the adapter** | `v1.9.0` |
| **First release without it** | `v2.0.0` (dropping a platform is breaking, so it needed a major) |
| **Images** | `ghcr.io/danieljoppi/anthocnet-ns2:2.34` / `:2.35` and the plain `ns2:2.34` / `:2.35`; the immutable `-v1.2.0` pins (`anthocnet-ns2:2.34-v1.2.0`, `:2.35-v1.2.0`) are the reproducible ones. Nothing published is deleted, but no new NS-2 image is built after v2.0.0 |

To run it, check out a tag that ships it and use that tree's own instructions:

```bash
git clone https://github.com/danieljoppi/AntHocNet.git && cd AntHocNet
git checkout v1.2.0            # or v1.9.0
make install-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
cd /path/to/ns-allinone-2.3x/ns-2.3x && make
```

```bash
docker run --rm -it ghcr.io/danieljoppi/anthocnet-ns2:2.35-v1.2.0   # `ns` with the agent
```

Per-adapter detail (patch anchors, TCL bindings, example scenarios) is in that
tree's [`ns2/README.md`](https://github.com/danieljoppi/AntHocNet/blob/v1.9.0/ns2/README.md).

## Why it was retired

The full reasoning is on [#307](https://github.com/danieljoppi/AntHocNet/issues/307);
the short version:

- It was the **only target that required edits inside the simulator's own
  tree**. ns-3 installs as an additive `contrib/` module; NS-2 needed an
  idempotent anchor-based source patch ([ADR-0005](adr/0005-ns2-idempotent-anchor-patch.md),
  now historical) that broke — loudly, by design — whenever upstream moved a
  text anchor.
- It **never got a benchmark harness**. The NS-2 leg ran a CI smoke asserting
  non-zero delivery over a forced 2-hop route and nothing else, so the
  "cross-simulator validation" it was meant to provide was never actually
  built.
- Contemporary reviewers read NS-2 in a 2026 paper as a **reproducibility red
  flag rather than a credential** (the survey work behind
  [#298](https://github.com/danieljoppi/AntHocNet/issues/298)).
- It consumed real CI and packaging budget: two adapter-compile jobs against
  real ns-2.34/2.35 trees, a valgrind leg, a patch round-trip job, and four
  published container images.

Papers are version-scoped (the maintainer decision recorded on #307): a paper
written against a release that ships both adapters is not falsified by a later
release that ships one.

## What the removal did not change

The simulator-agnostic [`core/`](../core), the ports seam, the wire codec and
the "no NS headers in `core/`" golden rule all stay —
[ADR-0023](adr/0023-one-core-one-simulator-adapter.md), which supersedes
ADR-0002, records why. The core still has two consumers: the ns-3 adapter and
the browser adapter that runs it as WebAssembly on the learn site
([ADR-0021](adr/0021-the-browser-is-an-adapter.md)).

## See also

- [porting-notes.md](porting-notes.md) — the bugs fixed while extracting the
  core from the original NS-2 module, and the wire-format caveats.
- [ADR-0005](adr/0005-ns2-idempotent-anchor-patch.md) — why the patch was
  anchor-based and idempotent rather than line-numbered (historical).
- [#307](https://github.com/danieljoppi/AntHocNet/issues/307) — the removal
  epic: decision, scope, phases, acceptance.
