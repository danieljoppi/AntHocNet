#!/usr/bin/env bash
#
# apply-patch.sh NS2DIR
#
# Injects the AntHocNet integration deltas into a user-supplied NS-2 source
# tree (ns-2.34 or ns-2.35). The edits are made by stable textual ANCHORS, not
# line numbers, wrapped in ANTHOCNET-BEGIN/END markers (or grep-guarded where a
# marker comment would be illegal, e.g. inside a Tcl list/switch body), so the
# script is idempotent and survives across the 2.3x series. If an expected
# anchor is missing the script FAILS LOUDLY rather than corrupting a file.
#
# The matching revert-patch.sh removes everything this adds.

set -euo pipefail

NS2DIR="${1:-}"
if [[ -z "$NS2DIR" ]]; then
    echo "usage: apply-patch.sh NS2DIR" >&2
    exit 2
fi
if [[ ! -d "$NS2DIR" ]]; then
    echo "error: NS2DIR '$NS2DIR' is not a directory" >&2
    exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAG="$SCRIPT_DIR/fragments"

BEGIN="ANTHOCNET-BEGIN"
END="ANTHOCNET-END"

# --- helpers ----------------------------------------------------------------

die() { echo "error: $*" >&2; exit 1; }

require_file() {
    [[ -f "$1" ]] || die "expected file not found: $1"
}

require_anchor() {
    # require_anchor FILE REGEX
    grep -qE "$2" "$1" || die "anchor not found in $1 : /$2/"
}

# Insert FRAGMENT (a file) immediately AFTER the first line matching REGEX,
# wrapped in comment markers. Idempotent: a no-op if the marker is already
# present. COMMENT is the line-comment token ("//" or "#").
insert_after_marked() {
    local file="$1" regex="$2" fragfile="$3" comment="$4" tag="$5"
    require_file "$file"
    if grep -q "$BEGIN $tag" "$file"; then
        echo "  [skip] $file already has $tag"
        return 0
    fi
    require_anchor "$file" "$regex"

    local tmp; tmp="$(mktemp)"
    awk -v rx="$regex" -v frag="$fragfile" -v c="$comment" \
        -v b="$BEGIN" -v e="$END" -v tag="$tag" '
        { print }
        $0 ~ rx && !done {
            print c " " b " " tag
            while ((getline line < frag) > 0) print line
            close(frag)
            print c " " e " " tag
            done = 1
        }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "  [ok]   $file <- $tag"
}

# Append FRAGMENT at EOF wrapped in markers. Idempotent via grep guard.
append_marked() {
    local file="$1" fragfile="$2" comment="$3" tag="$4"
    require_file "$file"
    if grep -q "$BEGIN $tag" "$file"; then
        echo "  [skip] $file already has $tag"
        return 0
    fi
    {
        echo "$comment $BEGIN $tag"
        cat "$fragfile"
        echo "$comment $END $tag"
    } >> "$file"
    echo "  [ok]   $file <- $tag (appended)"
}

# Insert FRAGMENT immediately BEFORE the first line matching REGEX, no marker
# (for Tcl list/switch bodies where '#' is not a comment). Idempotent via a
# caller-supplied GUARD regex.
insert_before_unmarked() {
    local file="$1" regex="$2" fragfile="$3" guard="$4"
    require_file "$file"
    if grep -qE "$guard" "$file"; then
        echo "  [skip] $file already patched (guard /$guard/)"
        return 0
    fi
    require_anchor "$file" "$regex"

    local tmp; tmp="$(mktemp)"
    awk -v rx="$regex" -v frag="$fragfile" '
        $0 ~ rx && !done {
            while ((getline line < frag) > 0) print line
            close(frag)
            done = 1
        }
        { print }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "  [ok]   $file (unmarked insert before /$regex/)"
}

# Insert FRAGMENT immediately AFTER the first line matching REGEX, no marker.
# Idempotent via a caller-supplied GUARD regex.
insert_after_unmarked() {
    local file="$1" regex="$2" fragfile="$3" guard="$4"
    require_file "$file"
    if grep -qE "$guard" "$file"; then
        echo "  [skip] $file already patched (guard /$guard/)"
        return 0
    fi
    require_anchor "$file" "$regex"

    local tmp; tmp="$(mktemp)"
    awk -v rx="$regex" -v frag="$fragfile" '
        { print }
        $0 ~ rx && !done {
            while ((getline line < frag) > 0) print line
            close(frag)
            done = 1
        }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "  [ok]   $file (unmarked insert after /$regex/)"
}

echo ">> Patching NS-2 tree at: $NS2DIR"

# --- 1. common/packet.h -----------------------------------------------------
# Dynamically assign PT_ANT = current PT_NTYPE value, bump PT_NTYPE, classify
# PT_ANT as ROUTING, and give it a printable name.
PKT="$NS2DIR/common/packet.h"
require_file "$PKT"
if grep -q "$BEGIN packet.h" "$PKT"; then
    echo "  [skip] $PKT already patched"
else
    require_anchor "$PKT" 'PT_NTYPE[[:space:]]*='
    N="$(grep -oE 'PT_NTYPE[[:space:]]*=[[:space:]]*[0-9]+' "$PKT" | grep -oE '[0-9]+' | head -1)"
    [[ -n "$N" ]] || die "could not read PT_NTYPE value from $PKT"
    NEXT=$((N + 1))
    echo "  PT_ANT = $N, PT_NTYPE -> $NEXT"

    tmp="$(mktemp)"
    awk -v n="$N" -v nxt="$NEXT" -v b="$BEGIN" -v e="$END" '
        # Insert PT_ANT just before the PT_NTYPE definition and renumber it.
        /static[[:space:]]+packet_t[[:space:]]+PT_NTYPE[[:space:]]*=/ && !pdone {
            print "// " b " packet.h"
            print "static const packet_t PT_ANT = " n ";"
            print "// " e " packet.h"
            sub(/=[[:space:]]*[0-9]+/, "= " nxt)
            pdone = 1
        }
        # Early ROUTING classification for PT_ANT, before the DSR/AODV block.
        /if[[:space:]]*\([[:space:]]*type[[:space:]]*==[[:space:]]*PT_DSR/ && !cdone {
            print "\t\t// " b " packet.h-class"
            print "\t\tif (type == PT_ANT) return ROUTING;"
            print "\t\t// " e " packet.h-class"
            cdone = 1
        }
        { print }
        # Printable name, right after the AODV name entry.
        /name_\[PT_AODV\][[:space:]]*=/ && !ndone {
            print "\t\t// " b " packet.h-name"
            print "\t\tname_[PT_ANT] = \"AntHocNet\";"
            print "\t\t// " e " packet.h-name"
            ndone = 1
        }
    ' "$PKT" > "$tmp"
    grep -q 'PT_ANT' "$tmp" || die "packet.h patch produced no PT_ANT; aborting"
    mv "$tmp" "$PKT"
    echo "  [ok]   $PKT"
fi

# --- 2. trace/cmu-trace.h ---------------------------------------------------
insert_after_marked "$NS2DIR/trace/cmu-trace.h" \
    'void[[:space:]]+format_aodv[[:space:]]*\(' \
    "$FRAG/cmu-trace.h.fragment" "//" "cmu-trace.h"

# --- 3. trace/cmu-trace.cc --------------------------------------------------
CMU="$NS2DIR/trace/cmu-trace.cc"
require_file "$CMU"
# include (after the first include line)
insert_after_marked "$CMU" '^#include' \
    "$FRAG/cmu-trace.cc.include.fragment" "//" "cmu-trace.cc-include"
# switch case (before the AODV case so we do not depend on break placement)
insert_before_unmarked "$CMU" 'case[[:space:]]+PT_AODV[[:space:]]*:' \
    "$FRAG/cmu-trace.cc.case.fragment" 'case[[:space:]]+PT_ANT[[:space:]]*:'
# implementation (appended at EOF)
append_marked "$CMU" "$FRAG/cmu-trace.cc.impl.fragment" "//" "cmu-trace.cc-impl"

# --- 4. Makefile.in ---------------------------------------------------------
# No comment markers here: a '#' inside the backslash-continued OBJ_CC list
# would truncate the make variable. Insert the (each-line-continued) object
# list right after the aodv anchor, grep-guarded for idempotency.
insert_after_unmarked "$NS2DIR/Makefile.in" \
    'aodv/aodv\.o' \
    "$FRAG/Makefile.in.fragment" 'anthocnet/ant_packet_ns2\.o'

# --- 5. tcl/lib/ns-packet.tcl -----------------------------------------------
# Register the packet header by adding the bare token to the protocol list,
# right after the AODV entry.
insert_after_unmarked "$NS2DIR/tcl/lib/ns-packet.tcl" \
    '^[[:space:]]*AODV([[:space:]]|$)' \
    "$FRAG/ns-packet.tcl.fragment" '^[[:space:]]*AntHocNet([[:space:]]|$)'

# --- 6. tcl/lib/ns-default.tcl ----------------------------------------------
append_marked "$NS2DIR/tcl/lib/ns-default.tcl" \
    "$FRAG/ns-default.tcl.fragment" "#" "ns-default.tcl"

# --- 7. tcl/lib/ns-lib.tcl --------------------------------------------------
NSLIB="$NS2DIR/tcl/lib/ns-lib.tcl"
# switch case: inject as the first case right after the switch opens
insert_after_unmarked "$NSLIB" \
    'switch[[:space:]]+-exact[[:space:]]+\$routingAgent_[[:space:]]*\{' \
    "$FRAG/ns-lib.tcl.case.fragment" 'create-ahn-agent[[:space:]]+\$node'
# create-ahn-agent instproc appended at EOF (idempotent guard inside helper)
append_marked "$NSLIB" \
    "$FRAG/ns-lib.tcl.proc.fragment" "#" "ns-lib.tcl-proc"

echo ">> Patch applied successfully."
