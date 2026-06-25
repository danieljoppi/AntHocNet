# Porting notes

Reference for maintaining the two adapters and the NS-2 patch.

## Bugs fixed during extraction

These were latent in the original NS-2 module and are fixed in `core/`:

1. **Header-resident heap pointers.** The packet header stored
   `AntTimeEntry**` malloc'd arrays. NS-2 pools and byte-copies header memory,
   so broadcasting an ant duplicated the pointer and led to a double-free; the
   arrays also leaked, and `size()` reported `sizeof(pointer)` rather than the
   real path length. Replaced by `AntMessage` value types + a length-prefixed
   codec.
2. **Evaporation aged the wrong link.** `updateRegularPheromone` evaporated /
   removed `neighbor` (the link the ant travelled) inside the loop branch meant
   for the *other* links, so competing links never decayed. Now operates on the
   iterated link.
3. **8-bit sequence number.** `seqNum` was `u_int8_t` and wrapped after 256
   ants, aliasing ant 256 onto ant 0 in `(src,seq)` dedup. Widened to 32-bit.
4. **Unbounded dedup set.** The `(src,seq)` history grew for the whole run.
   Now FIFO-capped (`Config::maxHistory`).
5. **`randomDestination` never randomised.** Integer division `count/size` was
   0 for every entry but the last. Now a proper uniform draw.

## NS-2 patch anchors

`ns2/patch/apply-patch.sh` injects by these stable anchors (never line
numbers). If an upstream release moves one, the script fails loudly (missing
anchor) rather than corrupting the file.

| File | Anchor (regex) | Edit |
|------|----------------|------|
| `common/packet.h` | `PT_NTYPE =` | insert `PT_ANT` (= old `PT_NTYPE`), bump `PT_NTYPE` |
| `common/packet.h` | `if (type == PT_DSR` | early `if (type == PT_ANT) return ROUTING;` |
| `common/packet.h` | `name_[PT_AODV] =` | `name_[PT_ANT] = "AntHocNet";` |
| `trace/cmu-trace.h` | `void format_aodv(` | `format_anthocnet` declaration |
| `trace/cmu-trace.cc` | first `#include` | include `ant_packet_ns2.h` |
| `trace/cmu-trace.cc` | `case PT_AODV:` | `case PT_ANT:` before it |
| `trace/cmu-trace.cc` | (EOF) | `format_anthocnet` implementation |
| `Makefile.in` | `aodv/aodv.o` | AntHocNet + core `.o` files |
| `tcl/lib/ns-packet.tcl` | `AODV` token | register `AntHocNet` header |
| `tcl/lib/ns-default.tcl` | (EOF) | `Agent/AntHocNet` defaults |
| `tcl/lib/ns-lib.tcl` | `switch -exact $routingAgent_ {` | `AntHocNet` case |
| `tcl/lib/ns-lib.tcl` | (EOF) | `create-ahn-agent` instproc |

### Idempotency / markers

Marked edits are wrapped in `// ANTHOCNET-BEGIN <tag>` / `// ANTHOCNET-END
<tag>` (or `# ...` in top-level Tcl). Two contexts cannot take a comment
marker, because `#` is not a comment there — so those are inserted unmarked and
guarded by a content grep instead:

- inside the Tcl `foreach`/`switch` *braces* (a `#` becomes a list element);
- inside the backslash-continued `OBJ_CC =` list in `Makefile.in` (a `#` would
  truncate the make variable).

`revert-patch.sh` strips the marked regions and deletes the unmarked inserts by
pattern, restoring `PT_NTYPE` to the value `PT_ANT` had taken. Validated on a
synthetic tree: apply is idempotent and revert restores byte-for-byte.

### Dynamic PT_ANT

`PT_ANT` is assigned the tree's *current* `PT_NTYPE` value at install time and
`PT_NTYPE` is bumped, so the id never collides across NS-2 releases (2.34 and
2.35 ship different built-in packet-type counts).

## Wire format

`core/include/anthocnet/core/ant_message_codec.h` defines the canonical
little-endian layout. The NS-2 header (`ant_packet_ns2`) and the NS-3 header
(`AntHeader`) follow the same field order. The NS-3 header serializes directly
against `Buffer::Iterator`; the NS-2 header is a fixed-capacity POD whose
`wireSize()` reports the same byte count the codec would emit.

## Version caveats

- The core uses C++14 (aggregate init with default member initializers). Modern
  g++ defaults to C++14+. For an old NS-2 toolchain, add `-std=c++14` to
  `CCOPT` in `$(NS2DIR)/Makefile`.
- NS-3 module targets 3.36+ (CMake); the `wscript` covers waf-era ns-3.
- Cross-simulator metric parity is not guaranteed — the MAC/PHY models differ.
