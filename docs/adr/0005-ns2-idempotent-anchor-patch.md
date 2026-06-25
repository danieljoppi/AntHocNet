# ADR-0005: Install on NS-2 via an idempotent, anchor-based source patch

- **Status:** Accepted
- **Date:** 2026-06-25

## Context

NS-2 has no module system: a routing protocol must edit core simulator files
(`common/packet.h`, `trace/cmu-trace.*`, `Makefile.in`, and three
`tcl/lib/*.tcl` files). The original project shipped these edits by **vendoring
an entire `ns-allinone-2.34` snapshot** — heavy, impossible to apply to a
different NS-2 version, and entangling the protocol with a frozen simulator
copy. We need to install onto a user's own `ns-2.34`/`ns-2.35` tree instead.
(NS-3, by contrast, supports additive `contrib/` modules and needs no core
edits — see [ns3/README.md](../../ns3/README.md).)

## Decision

Ship the NS-2 integration as an **idempotent, anchor-based patch**
(`ns2/patch/`):

- Inject each delta at a **stable textual anchor** (a regex on surrounding
  code), **never at a line number**. If an upstream release moves an anchor the
  installer **fails loudly** (missing anchor) rather than corrupting the file.
- Wrap edits in `ANTHOCNET-BEGIN/END` markers so they are re-runnable and
  cleanly removable; where a comment is illegal (inside a Tcl list/`switch`
  brace, or the backslash-continued `OBJ_CC` make variable) insert unmarked and
  guard with a content grep.
- Assign `PT_ANT` the tree's **current `PT_NTYPE`** value at install time and
  bump `PT_NTYPE`, so the packet-type id never collides across NS-2 releases.
- Provide `revert-patch.sh` (byte-for-byte restore) and `selftest.sh` (CI
  validates apply-idempotency and revert on a synthetic tree).

## Consequences

- One protocol install works across NS-2 versions without vendoring a
  simulator; uninstall is clean.
- The repo no longer carries thousands of upstream simulator files.
- Maintenance burden: anchors are a coupling to upstream source text; when NS-2
  changes one, the corresponding fragment in `ns2/patch/fragments/` must be
  updated. `selftest.sh` is the guard and must stay green.
- Full mechanics are documented in
  [`docs/porting-notes.md`](../porting-notes.md).
