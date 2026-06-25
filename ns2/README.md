# AntHocNet for NS-2

A thin NS-2 `Agent` adapter over the shared, simulator-agnostic
[`core/`](../core) AntHocNet implementation. Installing copies the core plus
this adapter into your NS-2 tree and applies a small, idempotent source patch;
nothing here ships a copy of NS-2.

Validated targets: **ns-2.34** and **ns-2.35**.

## Install

```bash
# from the repository root
make install-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x

# then rebuild NS-2
cd /path/to/ns-allinone-2.3x/ns-2.3x
./configure && make        # or just `make` if already configured
```

`NS2DIR` is the `ns-2.34` / `ns-2.35` source directory (the one containing
`common/packet.h`), not the `ns-allinone-2.3x` root.

> The core uses C++14. Modern g++ defaults to C++14 or later, so no change is
> usually needed. If your compiler defaults to an older standard, add
> `-std=c++14` to `CCOPT` in `$(NS2DIR)/Makefile` before building.

## Uninstall

```bash
make uninstall-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
cd /path/to/ns-allinone-2.3x/ns-2.3x && make
```

This reverts the patch (restoring the original files) and removes the copied
sources.

## Check status

```bash
make check-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
```

## What the installer does

`make install-ns2`:

1. Copies `core/` (headers + sources, the latter renamed `*.cc` so NS-2's
   build rule compiles them) and `ns2/src/` into `$(NS2DIR)/anthocnet/`.
2. Runs `patch/apply-patch.sh`, which injects the integration deltas by stable
   textual **anchors** (never line numbers), wrapped in `ANTHOCNET-BEGIN/END`
   markers (or grep-guarded where a comment would be illegal, e.g. inside a Tcl
   list or the `OBJ_CC` continuation). It is idempotent and re-runnable, and it
   **fails loudly** if an expected anchor is missing rather than corrupting a
   file.

The patched files and anchors:

| File | Edit |
|------|------|
| `common/packet.h` | `PT_ANT` (id taken dynamically from `PT_NTYPE`, then bumped), ROUTING classification, printable name |
| `trace/cmu-trace.h` | `format_anthocnet` declaration |
| `trace/cmu-trace.cc` | include, `case PT_ANT`, `format_anthocnet` implementation |
| `Makefile.in` | AntHocNet + core object files in `OBJ_CC` |
| `tcl/lib/ns-packet.tcl` | register the `AntHocNet` packet header |
| `tcl/lib/ns-default.tcl` | `Agent/AntHocNet` default parameters |
| `tcl/lib/ns-lib.tcl` | `AntHocNet` routing-agent case + `create-ahn-agent` |

The `PT_ANT` id is computed from the tree's current `PT_NTYPE` value, so it
never collides across NS-2 releases.

## Run an example

```tcl
# in your tcl scenario
$ns node-config -adhocRouting AntHocNet ...
```

Example scenarios are in [`tcl/`](tcl) (`0-low.tcl`, `1-simple.tcl`,
`2-complex.tcl`, and `scenario1..3/`).

## Manual install (fallback)

If `make` is unavailable, copy `core/` and `ns2/src/` into
`$(NS2DIR)/anthocnet/` yourself (core sources as `*.cc`), run
`bash ns2/patch/apply-patch.sh $(NS2DIR)`, then rebuild NS-2.

## Layout

```
ns2/
  src/                     thin Agent adapter
    ahn_router.{h,cc}      NS-2 Agent: Packet <-> core, schedules sends
    ant_packet_ns2.{h,cc}  POD packet header <-> core::AntMessage
    ahn_adapters.{h,cc}    IClock / IRng ports over Scheduler / Random
  patch/
    apply-patch.sh         idempotent anchor-based injector
    revert-patch.sh        removes everything apply added
    fragments/             the injected snippets
  tcl/                     example scenarios
```
