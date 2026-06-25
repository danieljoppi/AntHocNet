#!/usr/bin/env bash
#
# selftest.sh — validate apply-patch.sh / revert-patch.sh against a synthetic
# NS-2 tree (no real NS-2 needed). Checks that:
#   * applying twice is idempotent,
#   * the patched Makefile.in stays a valid backslash-continued OBJ_CC list,
#   * reverting restores the tree byte-for-byte.
#
# Exits non-zero on any failure. Used by CI.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

PRISTINE="$WORK/pristine"
TREE="$WORK/ns2"
mkdir -p "$PRISTINE"/{common,trace,tcl/lib}

cat > "$PRISTINE/common/packet.h" <<'EOF'
static const packet_t PT_AODV = 38;
static const packet_t PT_AOMDV = 61;
        // insert new packet types here
static packet_t       PT_NTYPE = 62; // This MUST be the LAST one

enum packetClass getClass() const {
		if (type == PT_DSR ||
		    type == PT_TORA ||
		    type == PT_AODV)
			return ROUTING;
		return UNCLASSIFIED;
}

void initName() {
		name_[PT_AODV]= "AODV";
		name_[PT_AOMDV]= "AOMDV";
		name_[PT_NTYPE]= "undefined";
}
EOF

cat > "$PRISTINE/trace/cmu-trace.h" <<'EOF'
class CMUTrace {
	void	format_aodv(Packet *p, int offset);
};
EOF

cat > "$PRISTINE/trace/cmu-trace.cc" <<'EOF'
#include <packet.h>
#include "cmu-trace.h"

void CMUTrace::format(Packet* p, int offset) {
	switch(ch->ptype()) {
	case PT_AODV:
		format_aodv(p, offset);
		break;
	}
}
EOF

cat > "$PRISTINE/Makefile.in" <<'EOF'
OBJ_CC = \
	aodv/aodv_logs.o aodv/aodv.o \
	aodv/aodv_rtable.o \
	$(LIB_DIR)
EOF

cat > "$PRISTINE/tcl/lib/ns-packet.tcl" <<'EOF'
foreach prot {
	TORA
	AODV
	AOMDV
} {
	add-packet-header $prot
}
EOF

cat > "$PRISTINE/tcl/lib/ns-default.tcl" <<'EOF'
Agent/AOMDV set sport_ 0
EOF

cat > "$PRISTINE/tcl/lib/ns-lib.tcl" <<'EOF'
Simulator instproc create-wireless-node args {
	switch -exact $routingAgent_ {
	AODV {
	    set ragent [$self create-aodv-agent $node]
	}
	}
}
EOF

cp -r "$PRISTINE" "$TREE"

echo ">> apply (1st)"
bash "$SCRIPT_DIR/apply-patch.sh" "$TREE" >/dev/null
echo ">> apply (2nd, idempotent)"
bash "$SCRIPT_DIR/apply-patch.sh" "$TREE" >/dev/null

# Makefile.in must not contain a '#' on a continued OBJ_CC line.
if grep -nE '\\\s*$' "$TREE/Makefile.in" | grep -q '#'; then
    echo "FAIL: '#' found on a continued Makefile.in line"; exit 1
fi
grep -q 'anthocnet/ant_packet_ns2.o' "$TREE/Makefile.in" || { echo "FAIL: objects not injected"; exit 1; }
grep -qE 'PT_ANT[[:space:]]*=[[:space:]]*62' "$TREE/common/packet.h" || { echo "FAIL: PT_ANT not assigned 62"; exit 1; }
grep -qE 'PT_NTYPE[[:space:]]*=[[:space:]]*63' "$TREE/common/packet.h" || { echo "FAIL: PT_NTYPE not bumped to 63"; exit 1; }

echo ">> revert"
bash "$SCRIPT_DIR/revert-patch.sh" "$TREE" >/dev/null

echo ">> diff vs pristine"
if diff -ru "$PRISTINE" "$TREE"; then
    echo "PASS: clean apply/idempotent/revert round-trip"
else
    echo "FAIL: revert did not restore the tree"; exit 1
fi
