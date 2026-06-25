#!/usr/bin/env bash
#
# revert-patch.sh NS2DIR
#
# Removes everything apply-patch.sh added: it strips the ANTHOCNET-BEGIN/END
# marked regions, deletes the unmarked Tcl/switch inserts by pattern, and
# restores common/packet.h's PT_NTYPE to the value PT_ANT had taken.

set -euo pipefail

NS2DIR="${1:-}"
if [[ -z "$NS2DIR" || ! -d "$NS2DIR" ]]; then
    echo "usage: revert-patch.sh NS2DIR" >&2
    exit 2
fi

# Strip every "... ANTHOCNET-BEGIN ..." / "... ANTHOCNET-END ..." region.
strip_markers() {
    local file="$1"
    [[ -f "$file" ]] || return 0
    local tmp; tmp="$(mktemp)"
    awk '
        /ANTHOCNET-BEGIN/ { skip = 1; next }
        /ANTHOCNET-END/   { skip = 0; next }
        !skip { print }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
}

# Delete a contiguous block: the line matching START_RE through the first
# following line matching END_RE (inclusive). Only the first such block.
delete_block() {
    local file="$1" start_re="$2" end_re="$3"
    [[ -f "$file" ]] || return 0
    local tmp; tmp="$(mktemp)"
    awk -v s="$start_re" -v e="$end_re" '
        !inblock && $0 ~ s && !done { inblock = 1; next }
        inblock { if ($0 ~ e) { inblock = 0; done = 1 } ; next }
        { print }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
}

echo ">> Reverting AntHocNet patch in: $NS2DIR"

# --- packet.h: restore PT_NTYPE then strip markers --------------------------
PKT="$NS2DIR/common/packet.h"
if [[ -f "$PKT" ]] && grep -q 'PT_ANT' "$PKT"; then
    ANT="$(grep -oE 'PT_ANT[[:space:]]*=[[:space:]]*[0-9]+' "$PKT" | grep -oE '[0-9]+' | head -1 || true)"
    if [[ -n "$ANT" ]]; then
        # PT_NTYPE was bumped to ANT+1; put it back to ANT.
        sed -i -E "s/(PT_NTYPE[[:space:]]*=[[:space:]]*)[0-9]+/\1$ANT/" "$PKT"
    fi
    strip_markers "$PKT"
    echo "  [ok]   $PKT"
fi

# --- cmu-trace.h ------------------------------------------------------------
strip_markers "$NS2DIR/trace/cmu-trace.h"

# --- cmu-trace.cc: strip marked include+impl, delete unmarked switch case ---
CMU="$NS2DIR/trace/cmu-trace.cc"
strip_markers "$CMU"
delete_block "$CMU" 'case[[:space:]]+PT_ANT[[:space:]]*:' 'break[[:space:]]*;'

# --- Makefile.in: delete the unmarked object-list block ---------------------
delete_block "$NS2DIR/Makefile.in" \
    'anthocnet/ant_packet_ns2\.o' 'anthocnet/core/ant_message_codec\.o'

# --- ns-packet.tcl: remove the bare AntHocNet token -------------------------
NSPKT="$NS2DIR/tcl/lib/ns-packet.tcl"
[[ -f "$NSPKT" ]] && sed -i -E '/^[[:space:]]*AntHocNet[[:space:]]*$/d' "$NSPKT"

# --- ns-default.tcl ---------------------------------------------------------
strip_markers "$NS2DIR/tcl/lib/ns-default.tcl"

# --- ns-lib.tcl: strip marked proc, delete unmarked switch case -------------
NSLIB="$NS2DIR/tcl/lib/ns-lib.tcl"
strip_markers "$NSLIB"
delete_block "$NSLIB" '^[[:space:]]*AntHocNet[[:space:]]*\{' '^[[:space:]]*\}'

echo ">> Patch reverted."
