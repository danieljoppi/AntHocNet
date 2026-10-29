// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * One (seed, arm) run of the comparison harness (#767): the world (mobility,
 * channel, devices, traffic), the stream pinning, the measurement (trace
 * sinks, drop book, route stability, energy) and RunOne. The command line
 * and the summary output are in routing-bench-harness.cc; what the two share
 * is routing-bench-internal.h.
 */
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/mobility-module.h"
#include "ns3/wifi-module.h"
#include "ns3/internet-module.h"
#include "ns3/applications-module.h"
#include "ns3/flow-monitor-module.h"
#include "ns3/ipv4-flow-classifier.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/tcp-header.h"
#include "ns3/udp-header.h"
// #212: the application-level sequence number the reordering metrics key on.
// Part of the applications module (already included above) since ns-3.31, so it
// is available across the whole CI matrix (3.36-3.48).
#include "ns3/seq-ts-size-header.h"
// #215 drop causes: Ipv4FlowProbe::DropReason indexes FlowStats::packetsDropped;
// LlcSnapHeader is what a wifi MPDU carries above the MAC header.
#include "ns3/ipv4-flow-probe.h"
// #217 path diversity: the WifiMac "AckedMpdu" trace carries the MPDU whose
// 802.11 header names the next hop; above that MAC header a wifi frame carries
// an LLC/SNAP header before the IP header.
#include "ns3/llc-snap-header.h"
#include "ns3/propagation-module.h"

// #708: IEEE 802.11s's mesh control header, stripped from data frames on an
// arm that brings mesh devices.
#include "ns3/mesh-module.h"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iterator>
#include <map>
#include <numeric>
#include <set>
#include <sstream>
#include <utility>
#include <vector>

#include "routing-bench-internal.h"
#include "urban-obstacle-loss-model.h"

using namespace ns3;

namespace routing_bench_detail {

// Data traffic uses this UDP port; every other UDP packet seen at the IP layer
// is routing control (AntHocNet 6900, AODV 654, OLSR 698, DSDV 269, ...), which
// is how we count routing overhead uniformly across protocols.
constexpr uint16_t kDataPort = 9;

// --- RNG stream pinning (#352) ----------------------------------------------
// ns-3 hands every RandomVariableStream a stream index taken from a *global*
// counter at CONSTRUCTION time, and RngSeedManager::SetSeed/SetRun do NOT reset
// that counter. This harness builds a whole scenario per run and runs many runs
// in one process (main's protocol-major loop), so without pinning, run N draws
// from whatever stream indices runs 1..N-1 left behind: a run's realisation
// becomes a function of its *position* in the process — i.e. of --runs, of
// --firstRun and of the protocol order — instead of a function of its seed.
// (Fingerprint before the fix: the same 20 seeds split 7+7+6 vs 4+4+4+4+4 gave
// identical rows for the first protocol only on seeds 1-4, and differing rows
// for every later protocol from seed 1 on.)
//
// So every stream-consuming helper is pinned to an explicit index inside a
// per-seed block [seed*kStreamStride, (seed+1)*kStreamStride).
//
// Stride: the widest scenario run here (100 nodes) consumes on the order of
// 10^3 streams — wifi assigns a handful per device, RandomWaypoint 2 plus the
// position allocator per node, the routing protocol 1-2 per node, plus a few
// per flow — so 10^6 leaves three orders of magnitude of headroom. The index is
// int64_t and ns-3 exposes 2^63 streams, so even a six-digit seed stays in
// range. TakeStreams() enforces the budget at runtime (NS_ABORT, not NS_ASSERT,
// so it holds in optimized builds too) rather than letting a future scenario
// that adds streams silently wrap into the next seed's block.
constexpr int64_t kStreamStride = 1000000;

// #431: the application sub-block. Everything assigned from the running
// counter below is arm-invariant up to and including the internet stack — but
// the routing helpers consume a protocol-dependent number of streams (the
// oracle draws nothing, aodv/olsr pin one per node, anthocnet several), so any
// draw taken from the running counter AFTER them lands on a different stream
// in every arm. The flow start times were exactly such a draw, which meant the
// same (flow, seq) key named a packet SENT AT A DIFFERENT TIME in each arm —
// up to the full --startWindow apart. That silently broke the ##COMMON##
// premise stated below ("application construction is identical and seeded
// identically"): the identity-matched set was matched by index, not by
// transmission, so its per-arm delays/hops were measured on topologies up to
// minutes apart under mobility. Measured before this fix (50 nodes, tworay,
// 300 s, 5 seeds): mean |t_oracle - t_aodv| for the same key was ~60 s, and
// the same-1s-epoch fraction ~2%. The application streams therefore get a
// FIXED offset at the top of the seed block, independent of which routing arm
// ran, restoring cross-arm packet identity. Within-arm determinism and #352
// split-structure invariance are unaffected (the block is still per-seed).
constexpr int64_t kAppStreamOffset = kStreamStride - 10000;

// #708: the hwmp arm's mesh sub-block. MeshHelper::AssignStreams takes a
// different number of streams than the ad-hoc devices every other arm
// installs (four QoS Txops per interface, plus HWMP and peering jitter), and
// mobility is pinned from the running counter right after the devices. Taken
// from the running counter, the mesh would therefore move every node to a
// different position than in the other arms (measured: a 5-hop HWMP path on a
// field whose oracle shortest path is 6). So the mesh draws from this fixed
// block, and the running counter advances by exactly what the ad-hoc devices
// take, keeping mobility and everything after it arm-invariant.
constexpr int64_t kMeshStreamOffset = kStreamStride / 2;

// Advance `next` by the number of streams a helper's AssignStreams() reported,
// and abort if this run has overrun its per-seed block — which for the running
// counter now ends where the fixed application sub-block begins.
void TakeStreams(int64_t& next, int64_t base, int64_t used, const char* what) {
    next += used;
    NS_ABORT_MSG_IF(next - base >= kAppStreamOffset,
                    "RNG stream budget exhausted after assigning "
                        << what << ": this run has consumed " << (next - base)
                        << " streams but the application sub-block starts at " << kAppStreamOffset
                        << " — blocks would overlap (#352/#431). Raise the stride.");
}

// #352 (DSDV's missing AssignStreams wrapper) and #510 (OLSR's source
// refusals) live with their arms in routing-bench now (ADR-0027, #766).

uint64_t g_controlPkts = 0;   // routing-control packets transmitted this run
uint64_t g_controlBytes = 0;  // #132: routing-control bytes transmitted this run

// Ipv4L3Protocol "Tx" trace: one call per IP packet sent out an interface (each
// hop). Count the non-data UDP packets as routing control. Bytes are the full
// IP packet size at the same hook (#132) — packet-count NRL flatters protocols
// that send fewer, larger messages (ants carry a visited path; AODV RREQs are
// small and fixed), so a byte-level number is kept alongside.
void CountControlTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t) {
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return;
    if (ip.GetProtocol() != 17) return;  // not UDP; routing control here is UDP
    // Fragmentation safety (#454, the isl-grid PR #453 fix ported): this trace
    // fires once per FRAGMENT when a datagram exceeds the device MTU, and a
    // continuation fragment (offset > 0) carries no UDP header — peeking one
    // reads past the buffer (NS_ASSERT abort in debug, undefined read in
    // release). A UDP fragment's datagram here can only be routing control:
    // data is 64 B CBR (92 B IP packet) against the 2296 B wifi MTU, so it
    // never fragments (the TCP arm's segments — 536 B default MSS — never
    // fragment either, and are protocol 6, already excluded above). Each
    // fragment is an IP packet on the wire, so it counts as control at this
    // counting point; the first fragment (offset 0) still carries the UDP
    // header and is classified by port exactly as before.
    if (ip.GetFragmentOffset() != 0) {
        ++g_controlPkts;
        g_controlBytes += p->GetSize();
        return;
    }
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return;
    if (udp.GetDestinationPort() != kDataPort) {
        ++g_controlPkts;
        g_controlBytes += p->GetSize();
    }
}

// #708: HWMP routes at layer 2, so its control never crosses the IP "Tx"
// trace above. Its routing transmissions are the 802.11s path-selection
// action frames (category Mesh: PREQ, PREP, PERR and RANN information
// elements), counted here once per frame handed to a mesh interface's MAC
// queue, the L2 point that matches the IP hook: one count per frame sent to
// one next hop (or one broadcast), MAC retries not counted. Bytes are the
// frame body (action header plus IEs), the L2 analogue of the IP packet size
// counted above. The mesh's own link maintenance is reported apart, under
// --diag (`# hwmp` line): peering frames (category Self-protected: peer link
// open, confirm, close) and beacons. They are the analogue of a protocol's
// hellos, but they are the 802.11s MAC rather than its path selection, and
// metrics.md says which side of the line each one is on.
bool g_meshArm = false;          // #708: this run's arm brings 802.11s mesh devices
uint64_t g_meshPeeringPkts = 0;  // #708: self-protected action frames queued
uint64_t g_meshBeacons = 0;      // #708: beacons queued

void CountMeshMgtTx(Ptr<const BENCH_WIFI_MPDU> mpdu) {
    if (!mpdu) return;
    const WifiMacHeader& hdr = mpdu->GetHeader();
    if (hdr.IsBeacon()) {
        ++g_meshBeacons;
        return;
    }
    if (!hdr.IsAction()) return;
    Ptr<Packet> c = mpdu->GetPacket()->Copy();
    WifiActionHeader action;
    if (c->GetSize() < 2) return;
    c->RemoveHeader(action);
    if (action.GetCategory() == WifiActionHeader::MESH) {
        ++g_controlPkts;
        g_controlBytes += mpdu->GetPacket()->GetSize();
    } else if (action.GetCategory() == WifiActionHeader::SELF_PROTECTED) {
        ++g_meshPeeringPkts;
    }
}

// #708: an 802.11s data frame carries the mesh control header (mesh TTL,
// sequence number, address extension) between the 802.11 header and the
// LLC/SNAP header the MAC hooks below parse. Strip it on a mesh arm so
// those hooks read the same IP packet they read on every other arm; a
// no-op elsewhere.
void StripMeshHeader(Ptr<Packet> pkt, const WifiMacHeader& hdr) {
    if (!g_meshArm || !hdr.IsData()) return;
    dot11s::MeshHeader mesh;
    pkt->RemoveHeader(mesh);
}

// --- packet reordering (#212) ----------------------------------------------
// Per-flow arrival-order sequence numbers, keyed by the *source* socket address
// (source IP + ephemeral port). That key is unique per OnOff application in both
// the default i->(n-1-i) pairing and the --sink converge mode, where several
// flows share one PacketSink and a per-sink index would not separate them.
// Filled for every protocol and every run — reordering is a reported metric, not
// a --diag extra.
//
// The ordering key is the sequence number ns-3's OnOffApplication writes when
// its EnableSeqTsSizeHeader attribute is set (see the SetAttribute call in
// RunOne for why this does not change the packet size). FlowMonitor cannot
// supply it: it reports per-flow counts and delays, never per-packet order.
std::map<Address, std::vector<uint32_t>> g_rxSeq;

// --- the thesis's delay jitter, eq 5.1 (#89) ---------------------------------
// Arrival times per flow, same key and same arrival order as g_rxSeq.
//
// This exists because the thesis's "average delay jitter" is NOT the quantity
// FlowMonitor's jitterSum reports, and the difference is not a constant factor:
//
//   thesis eq 5.1   sum |(t_i - t_{i-1}) - (t_{i-1} - t_{i-2})|
//   FlowMonitor     sum |delay_i - delay_{i-1}|,  delay = arrival - send
//
// Eq 5.1 contains no send times at all — it measures how much each inter-arrival
// gap differs from the *previous gap*, where the delay-based figure measures how
// much each packet's delay differs from the previous packet's. Under a perfectly
// periodic source the two differ by one further differencing step, which for iid
// arrival noise inflates eq 5.1's variance by roughly 2x. So the columns are
// reported side by side and are not interchangeable: paper-parity claims cite
// eq 5.1, everything else may cite either as long as it is consistent.
//
// Arrival order, not sequence order, is correct here — the thesis says "the time
// of arrival of the ith packet", so a reordered packet legitimately registers as
// jitter. Do not sort this by sequence number.
std::map<Address, std::vector<double>> g_rxArrival;

// --- per-packet delay, keyed by identity rather than by rank (#308) ----------
// (flow, seq) -> end-to-end delay in seconds, for every delivered data packet.
//
// This is what makes a *like-for-like* tail comparison possible. delay99 ranks
// each protocol's own deliveries, so two protocols with different delivery
// ratios are ranked over different populations and the comparison silently
// rewards the one that delivered less (#308's matched-count measurement bounded
// that effect but could not eliminate it, because truncating by rank still
// assumes which packets the surplus contains). Keying by identity removes the
// assumption: intersect the delivered sets and compare the tails over exactly
// the packets every protocol carried.
//
// SeqTsSizeHeader already carries the send timestamp, and the trace below
// already peeks the header for the sequence number, so this costs one
// subtraction per delivered packet and no extra instrumentation.
std::map<Address, std::map<uint32_t, double>> g_rxDelayBySeq;

// #308 phase 2: (flow, seq) -> hop count, the same key as the delays above.
//
// The phase-2 decomposition needs delay and path length over the SAME packets.
// `hopsMean` (#217) averages over each protocol's own deliveries while
// `meanCommon` averages over the intersection, so dividing one by the other
// mixes two populations — the exact survivorship confound phase 1 was about,
// reappearing in the denominator. With hops keyed by identity, the common-set
// per-hop cost is a like-for-like quotient: is AntHocNet's extra delay more
// hops, or slower hops, on packets both protocols carried?
//
// Filled by CountDeliveredHops below rather than here, because the hop count
// comes from the IP TTL and the sink's Rx trace has no IP header left to read.
std::map<Address, std::map<uint32_t, uint32_t>> g_rxHopsBySeq;

// #386: (flow, seq) -> number of sink deliveries seen so far. Same key as the
// two maps above; filled by RecordRxSeq, read by the re-injection identity
// block further down (see "re-injection identity & fate").
std::map<Address, std::map<uint32_t, uint32_t>> g_rxCount;

// --- route stability (#294 item 4) -------------------------------------------
// The path a delivered packet took: the node IDs that handed it to a real
// interface at the IP layer, in transmission order (the source, then every
// forwarder). Protocol-agnostic — it is the same Ipv4L3Protocol "Tx" hook the
// #215 hop tallies use — so every arm is measured identically, the oracle
// included. UDP arms only: the (flow, seq) identity does not exist under TCP.
//
// g_routePending collects hops per in-flight (flow, seq); the first delivery
// moves the path, interned to a small id, and the packet's send time into
// g_routeRx. A packet more than kRouteWindowSeq sequence numbers behind its
// flow's latest delivery is pruned from the pending map: at the harness's CBR
// rates that is minutes of simulated time, longer than any queue or hold.
bool g_routeOn = false;
std::map<Address, std::map<uint32_t, std::vector<uint32_t>>> g_routePending;
std::map<std::vector<uint32_t>, uint32_t> g_routeIds;
struct RouteRx {
    uint32_t pathId;
    double sendS;
};
std::map<Address, std::map<uint32_t, RouteRx>> g_routeRx;
uint64_t g_routeHopSum = 0;  // sum over first deliveries of path length (hops)
constexpr uint32_t kRouteWindowSeq = 1000;

void RecordRxSeq(Ptr<const Packet> p, const Address& from) {
    SeqTsSizeHeader h;
    p->PeekHeader(h);
    g_rxSeq[from].push_back(h.GetSeq());
    const double now = Simulator::Now().GetSeconds();
    g_rxArrival[from].push_back(now);
    g_rxDelayBySeq[from][h.GetSeq()] = now - h.GetTs().GetSeconds();
    // #386: per-key delivery count, so the re-injection instrumentation can ask
    // "was this packet already delivered?" at trace-fire time and count
    // duplicate deliveries at end of run. Kept for ALL protocols (this callback
    // has no protocol knowledge): one uint32 per delivered (flow, seq), the
    // same growth order as g_rxDelayBySeq's double above — accepted.
    g_rxCount[from][h.GetSeq()] += 1;
}

// --- drop-cause breakdown (#215) --------------------------------------------
// A lost packet used to be anonymous: PDR said how many went missing, nothing
// said why. #173 needed a whole campaign to establish that its collapse was
// channel loss rather than route failure; in a breakdown that is one column.
//
// The protocol-agnostic causes are measured here, in the simulator, for all
// four protocols. Two of them are per-hop tallies at the IP layer — the same
// counting point NRL uses:
//   g_dataHopTx  data IP packets handed to a real interface for transmission
//   g_dataHopRx  data IP packets that arrived at the next hop's IP layer
// Their difference is every data packet that entered the medium and did not
// come out of it. That pool is then carved up: the MAC reports the frames it
// gave up on after exhausting retries (g_macDataDrops), FlowMonitor reports the
// interface/qdisc queue overflows, and whatever remains is genuine channel loss
// — collisions, capture, out-of-range, ARP failures. Only the simulator can see
// that difference, which is exactly why it cannot come from core/ (issue #215).
//
// Interface 0 is the loopback device. AntHocNet (like AODV) bounces a routeless
// packet through it to reach RouteInput, so it must be excluded from BOTH
// tallies or the bounce reads as a hop that was sent and never received.
uint64_t g_dataHopTx = 0;
uint64_t g_dataHopRx = 0;
uint64_t g_macDataDrops = 0;  // data frames dropped at the MAC retry limit
// #377: data frames the sender got an ACK for. Already counted for the #217
// diversity windows; kept as a scalar too because the drop-cause identity
// needs it. See the ##DROPID## emission for what it is used to test.
uint64_t g_ackedDataHops = 0;

// Is this a CBR *data* IP packet (as opposed to routing control)? Same test as
// CountControlTx, from the other side.
bool IsDataIp(Ptr<const Packet> p) {
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return false;
    // #454: a continuation fragment (offset > 0) carries no L4 header to peek
    // a port from, and no data packet ever fragments (UDP data is a 92 B IP
    // packet, TCP segments cap at the 536 B default MSS, both far under the
    // 2296 B wifi MTU) — so a continuation fragment is by construction not
    // data. Classifying by port stays first-fragment-only.
    if (ip.GetFragmentOffset() != 0) return false;
    if (ip.GetProtocol() == 6) {  // TCP (#389)
        // Pure TCP ACKs are excluded naturally: on the reverse path the
        // destination port is the sender's ephemeral port, so only forward
        // data segments count — matching what the UDP arm counts.
        TcpHeader tcp;
        if (c->PeekHeader(tcp) == 0) return false;
        return tcp.GetDestinationPort() == kDataPort;
    }
    if (ip.GetProtocol() != 17) return false;  // not UDP
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return false;
    return udp.GetDestinationPort() == kDataPort;
}

// --- re-injection identity & fate (#386) -------------------------------------
// The #46 detector-D re-injection path puts a MAC retry-limit-dropped data
// packet back into the pending queue. The #377/#386 inclusion-exclusion bound
// says >=59% of those re-injections are of packets that had ALREADY arrived at
// the destination (unackedRx vs reinjected, a floor); this block measures it
// directly, per packet, and follows what re-injected packets then DO.
//
// Identity is the (flow, seq) key the sink-side maps already use: flow =
// InetSocketAddress(source IP, source UDP port) — byte-identical to the
// PacketSink "Rx" trace's `from` (see CountDeliveredHops's key construction) —
// and seq = the SeqTsSizeHeader sequence number. ns-3 Packet::GetUid() would
// also survive the re-inject Copy() (uid lives in the copied metadata), but
// (flow, seq) is what the delivered set is already keyed by, is readable in
// logs, and survives any future packet re-creation.
//
// "Already delivered AT RE-INJECTION TIME" needs no timestamps: traces fire in
// simulation-event order, so if the key is in g_rxCount when the MacReinject
// trace fires, the delivery happened strictly earlier. A copy that has passed
// the failing hop but not yet reached the sink counts as not-yet-delivered
// here, so ofDelivered is a conservative direct count and the end-of-run fate
// buckets bound the same quantity from the other side.

// Per re-injected (flow, seq) key. `rxAtFirstReinj` snapshots the delivered
// count when the key was FIRST re-injected (>=1 = the "already delivered"
// class); postTx/postRx count this key's IP-layer hop transmissions/arrivals
// AFTER that moment (membership in g_reinj starts at first re-injection, so
// pre-re-injection hops are excluded by construction). The l3Drop* fields are
// the isolated, cuttable drop-cause stage (see CountReinjL3Drop).
struct ReinjInfo {
    uint32_t events = 0;          // re-injection events for this key
    uint32_t rxAtFirstReinj = 0;  // sink deliveries seen at first re-injection
    uint64_t postTx = 0;          // hop transmissions after first re-injection
    uint64_t postRx = 0;          // hop arrivals after first re-injection
    uint32_t l3DropRoute = 0;     // L3 drops: route error / no route
    uint32_t l3DropTtl = 0;       // L3 drops: TTL expired
    uint32_t l3DropOther = 0;     // L3 drops: any other reason
};
std::map<std::pair<Address, uint32_t>, ReinjInfo> g_reinj;
uint64_t g_reinjEvents = 0;       // MacReinject trace fires (== reinjected)
uint64_t g_reinjParsed = 0;       // fires where the (flow, seq) parse succeeded
uint64_t g_reinjOfDelivered = 0;  // fires with the key already delivered
// #386 probe finding (comment 5233656930): the detector re-injects any non-ant
// IP payload, and seed 2 of the invariance probe carried 2 events the SeqTs
// identity could not name — most plausibly ICMP (TTL-exceeded travels the same
// unicast hops as data). Classify the parse failures instead of failing the
// books: protocol 1 vs everything else. Recorded, not "fixed" — changing what
// NotifyTxError re-injects would be a protocol-behaviour change, not
// instrumentation.
uint64_t g_reinjUnparsedIcmp = 0;   // parse failures with ip.protocol == 1
uint64_t g_reinjUnparsedOther = 0;  // any other parse failure

// #402: capped skips — the adapter's MaxReinjectPerPacket early-return, where
// a MAC retry-limit drop stays TERMINAL because the cap refused the
// re-injection. The skip happens inside the adapter (no counter, no enqueue),
// so without the MacReinjectSkip trace the harness cannot see it; the #388
// attribution then counts a capped-terminal drop of a delivered packet in
// macTerminal while its earlier copies' hop inflation is still in hopLoss —
// the double-count the cap=1 probe measured as +8.50 pp. Per skipped key the
// fate logic mirrors ReinjInfo: at-fire-time delivered count on FIRST skip,
// end-of-run partition against g_rxCount.
struct ReinjSkipInfo {
    uint32_t events = 0;         // capped-skip events for this key
    uint32_t rxAtFirstSkip = 0;  // sink deliveries seen at first skip
};
std::map<std::pair<Address, uint32_t>, ReinjSkipInfo> g_reinjSkip;
uint64_t g_reinjSkips = 0;  // MacReinjectSkip trace fires (incl. unparsed)

// (flow, seq) off a packet whose front is the UDP header (the form the
// MacReinject trace and the Ipv4L3Protocol traces hand over — IP header
// separate). False on anything that is not a SeqTs CBR datagram; the
// MacReinject listener classifies those (unparsedIcmp/unparsedOther), and
// scenario_check FAILs only when parsed + unparsed != events — the books must
// close, but a non-data re-injection is a finding, not an error.
bool ReinjKeyFromUdp(const Ipv4Header& ip, Ptr<const Packet> p, Address& flow, uint32_t& seq) {
    if (ip.GetProtocol() != 17) return false;
    // #454: a continuation fragment's payload does not start with a UDP
    // header, so there is no (flow, seq) key to parse off it — and data never
    // fragments here (see IsDataIp), so it cannot be a SeqTs CBR datagram.
    // Callers that must close their books (CountMacReinject) classify the
    // false return like any other non-data payload.
    if (ip.GetFragmentOffset() != 0) return false;
    Ptr<Packet> c = p->Copy();
    UdpHeader udp;
    if (c->RemoveHeader(udp) == 0) return false;
    if (udp.GetDestinationPort() != kDataPort) return false;
    SeqTsSizeHeader h;
    if (c->PeekHeader(h) == 0) return false;
    flow = InetSocketAddress(ip.GetSource(), udp.GetSourcePort());
    seq = h.GetSeq();
    return true;
}

// Same key off a full IP packet (the Ipv4L3Protocol "Tx"/"Rx" trace form).
bool ReinjKeyFromIp(Ptr<const Packet> p, Address& flow, uint32_t& seq) {
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return false;
    return ReinjKeyFromUdp(ip, c, flow, seq);
}

// Connected to the adapter's "MacReinject" trace (anthocnet + UDP arm only).
// Read-only: the packet is peeked via a Copy, never mutated — the pre-merge
// A/B relies on this whole block being behaviour-invariant.
void CountMacReinject(const Ipv4Header& ip, Ptr<const Packet> p) {
    ++g_reinjEvents;
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) {
        // Classify, don't drop on the floor: parsed + unparsed must equal
        // events or the books don't close (scenario_check FAILs that).
        if (ip.GetProtocol() == 1)
            ++g_reinjUnparsedIcmp;
        else
            ++g_reinjUnparsedOther;
        return;
    }
    ++g_reinjParsed;
    uint32_t rxNow = 0;
    const auto f = g_rxCount.find(flow);
    if (f != g_rxCount.end()) {
        const auto s = f->second.find(seq);
        if (s != f->second.end()) rxNow = s->second;
    }
    if (rxNow > 0) ++g_reinjOfDelivered;
    auto ins = g_reinj.emplace(std::make_pair(flow, seq), ReinjInfo{});
    if (ins.second) ins.first->second.rxAtFirstReinj = rxNow;
    ++ins.first->second.events;
}

// #402: the capped-skip counterpart of CountMacReinject, connected to the
// adapter's "MacReinjectSkip" trace (same anthocnet + UDP gate). Same
// read-only discipline. An unparseable skip (non-data payload, ICMP etc.)
// counts in the event total only: it has no (flow, seq) key, so it stays
// conservatively terminal in the #402 mac attribution — correct, since it is
// not a delivered data packet.
void CountMacReinjectSkip(const Ipv4Header& ip, Ptr<const Packet> p) {
    ++g_reinjSkips;
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) return;
    uint32_t rxNow = 0;
    const auto f = g_rxCount.find(flow);
    if (f != g_rxCount.end()) {
        const auto s = f->second.find(seq);
        if (s != f->second.end()) rxNow = s->second;
    }
    auto ins = g_reinjSkip.emplace(std::make_pair(flow, seq), ReinjSkipInfo{});
    if (ins.second) ins.first->second.rxAtFirstSkip = rxNow;
    ++ins.first->second.events;
}

// #386 l3Drop stage — deliberately isolated (own callback, own connect line,
// fields grouped at the END of the ##REINJ## line) so that if any CI ns-3
// version rejects the "Drop" trace signature the whole stage is cut from the
// change rather than version-gated. Attributes the L3-visible drops of
// re-injected keys: the pending-queue ageout's error callback lands in
// DROP_ROUTE_ERROR, TTL exhaustion in DROP_TTL_EXPIRED. A re-injected key that
// ends undelivered with NO L3 drop died in the medium/MAC — the residue the
// #377/#388 drop identity is sensitive to.
void CountReinjL3Drop(const Ipv4Header& ip, Ptr<const Packet> p, Ipv4L3Protocol::DropReason reason,
                      Ptr<Ipv4>, uint32_t) {
    if (g_reinj.empty()) return;
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) return;
    const auto it = g_reinj.find(std::make_pair(flow, seq));
    if (it == g_reinj.end()) return;
    if (reason == Ipv4L3Protocol::DROP_ROUTE_ERROR || reason == Ipv4L3Protocol::DROP_NO_ROUTE) {
        ++it->second.l3DropRoute;
    } else if (reason == Ipv4L3Protocol::DROP_TTL_EXPIRED) {
        ++it->second.l3DropTtl;
    } else {
        ++it->second.l3DropOther;
    }
}

// --- #761: per-packet terminal fate (adaptive arms + UDP only) ----------------
// The adaptive arms (ara, termite, qrouting) recover a MAC- or ARP-dropped data
// packet and re-route it, so one offered packet can be lost on several hops
// before it is delivered or finally dropped. Every hop-level book above
// (macDrops, hopLoss, FlowMonitor's per-reason drops) counts loss EVENTS, so on
// a fading channel each column can exceed 100 % of the offered packets — the
// identity pdr + route + queue + mac + chan + ttl = 100 assumes one terminal
// cause per packet. For those arms the drop book is therefore kept per packet:
// every observable event on a data packet's (flow, seq) key overwrites the
// key's state, so at end of run the state IS the packet's terminal fate — the
// last loss not followed by a re-injection. Events, in the order the traces
// fire them:
//   L3 "SendOutgoing" (source)   -> AtNode (handed to IP at its source)
//   L3 "Tx" on a real interface  -> Tx    (on the medium; lost there unless
//                                           a later event says otherwise)
//   L3 "Rx" on a real interface  -> AtNode (arrived at a node)
//   MAC retry-limit drop         -> Mac
//   Mac/ArpReinject              -> AtNode (recovered: the loss was not
//                                           terminal; counted in `recovered`)
//   L3 "Drop"                    -> Route / Ttl / Other by reason
// The harness's DroppedMpdu hook is connected before the interfaces come up,
// i.e. before the adapter's own (NotifyInterfaceUp), so a MAC drop's Mac state
// is always overwritten by the re-injection the same drop triggers. Identity is
// the (flow, seq) key every other per-packet book uses (see #386 above), so the
// copies a re-injection duplicates share one fate. Gated on g_fateOn, set by an
// arm that asks for the book (Measurement::TrackPacketFate: the adaptive arms,
// UDP only): the other arms never parse anything here and stay byte-identical.
enum class Fate : uint8_t { Tx, AtNode, Mac, Route, Ttl, Other };
struct FateInfo {
    Fate last = Fate::Tx;
    uint32_t recovered = 0;  // Mac/ArpReinject events on this key
};
bool g_fateOn = false;
std::map<std::pair<Address, uint32_t>, FateInfo> g_fate;
uint64_t g_fateRecovered = 0;  // recovered loss events (data re-injections)

void FateMark(const Address& flow, uint32_t seq, Fate f) {
    g_fate[std::make_pair(flow, seq)].last = f;
}
void FateMarkIp(Ptr<const Packet> p, Fate f) {
    Address flow;
    uint32_t seq = 0;
    if (ReinjKeyFromIp(p, flow, seq)) FateMark(flow, seq, f);
}
void FateRecovered(const Ipv4Header& ip, Ptr<const Packet> p) {
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) return;
    FateInfo& fi = g_fate[std::make_pair(flow, seq)];
    fi.last = Fate::AtNode;
    ++fi.recovered;
    ++g_fateRecovered;
}
// The source's own hand-over to IP (L3 "SendOutgoing"): the packet exists at
// its source node, so one that never reaches a real interface (held for a
// route until the run stops) reads AtNode rather than unseen.
void CountFateSend(const Ipv4Header& ip, Ptr<const Packet> p, uint32_t) {
    Address flow;
    uint32_t seq = 0;
    if (ReinjKeyFromUdp(ip, p, flow, seq)) FateMark(flow, seq, Fate::AtNode);
}
void CountFateL3Drop(const Ipv4Header& ip, Ptr<const Packet> p, Ipv4L3Protocol::DropReason reason,
                     Ptr<Ipv4>, uint32_t) {
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) return;
    Fate f = Fate::Other;
    if (reason == Ipv4L3Protocol::DROP_ROUTE_ERROR || reason == Ipv4L3Protocol::DROP_NO_ROUTE) {
        f = Fate::Route;
    } else if (reason == Ipv4L3Protocol::DROP_TTL_EXPIRED) {
        f = Fate::Ttl;
    }
    FateMark(flow, seq, f);
}

void CountDataHopTx(Ptr<const Packet> p, Ptr<Ipv4> ipv4, uint32_t iface) {
    if (iface != 0 && IsDataIp(p)) {
        ++g_dataHopTx;
        // #294 item 4: this node is on the packet's path. On the hwmp arm IP
        // transmits only at the source; the path is built from the mesh's
        // own hops in CountMeshDataHop instead (#708).
        if (g_routeOn && !g_meshArm) {
            Address flow;
            uint32_t seq = 0;
            if (ReinjKeyFromIp(p, flow, seq)) {
                g_routePending[flow][seq].push_back(ipv4->GetObject<Node>()->GetId());
            }
        }
        // #386: subsequent hops of re-injected packets. g_reinj only fills on
        // the anthocnet arm (the trace is connected nowhere else), so the
        // emptiness gate keeps the extra parse off every other arm.
        if (!g_reinj.empty()) {
            Address flow;
            uint32_t seq = 0;
            if (ReinjKeyFromIp(p, flow, seq)) {
                const auto it = g_reinj.find(std::make_pair(flow, seq));
                if (it != g_reinj.end()) ++it->second.postTx;
            }
        }
        if (g_fateOn) FateMarkIp(p, Fate::Tx);  // #761
    }
}
void CountDataHopRx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t iface) {
    if (iface != 0 && IsDataIp(p)) {
        ++g_dataHopRx;
        if (!g_reinj.empty()) {  // #386: see CountDataHopTx
            Address flow;
            uint32_t seq = 0;
            if (ReinjKeyFromIp(p, flow, seq)) {
                const auto it = g_reinj.find(std::make_pair(flow, seq));
                if (it != g_reinj.end()) ++it->second.postRx;
            }
        }
        if (g_fateOn) FateMarkIp(p, Fate::AtNode);  // #761
    }
}

// WifiMac "DroppedMpdu": a retry-limit drop is the MAC giving up on a unicast,
// i.e. the link broke under the packet. Counted for every protocol from the
// same trace the AntHocNet adapter uses for ADR-0008 detector D, so the column
// means the same thing in all four arms. Other drop reasons (queue full,
// lifetime expiry) are congestion and are counted by FlowMonitor instead.
// v2.5.0 (#563): data packets the adaptive arms recovered from a MAC drop,
// and from an ARP drop (the next hop never answered: the frame never reached
// the medium, so it sits in hopLoss without being channel loss).
uint64_t g_adaptiveReinjData = 0;
uint64_t g_adaptiveArpReinjData = 0;
void CountAdaptiveReinject(const Ipv4Header& ip, Ptr<const Packet> p) {
    Ptr<Packet> c = p->Copy();
    c->AddHeader(ip);
    if (IsDataIp(c)) ++g_adaptiveReinjData;
    if (g_fateOn) FateRecovered(ip, p);  // #761
}
void CountAdaptiveArpReinject(const Ipv4Header& ip, Ptr<const Packet> p) {
    Ptr<Packet> c = p->Copy();
    c->AddHeader(ip);
    if (IsDataIp(c)) ++g_adaptiveArpReinjData;
    if (g_fateOn) FateRecovered(ip, p);  // #761
}

void CountMacDataDrop(WifiMacDropReason reason, Ptr<const BENCH_WIFI_MPDU> mpdu) {
    if (reason != WIFI_MAC_DROP_REACHED_RETRY_LIMIT || !mpdu) return;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    StripMeshHeader(pkt, mpdu->GetHeader());  // #708
    LlcSnapHeader llc;
    if (pkt->GetSize() < llc.GetSerializedSize()) return;
    pkt->RemoveHeader(llc);
    if (llc.GetType() != 0x0800) return;  // not IPv4
    if (IsDataIp(pkt)) ++g_macDataDrops;
    if (g_fateOn) FateMarkIp(pkt, Fate::Mac);  // #761
}

// --- #229: routing-layer pending-queue conservation (dsdv + aodv arms only) --
// ns-3's dsdv::PacketQueue sheds packets with NO observable signal: its
// Drop() has the error callback commented out (stock dsdv-packet-queue.cc,
// identical ns-3.36 through ns-3.48), Enqueue() overflow returns false into a
// caller that ignores it, and the protocol registers no TraceSource. Those
// packets are offered, never delivered, and attributed to no cause — the
// -21.8 pp identity shortfall at dense-small (#229 comment 5252059859). The
// baselines run STOCK ns-3 code, so the hook lives entirely here, on traces
// stock Ipv4L3Protocol already fires.
//
// Conservation argument. Both dsdv and aodv defer a routed-less packet the
// same way: RouteOutput tags it and returns the loopback route, so it crosses
// the L3 "Tx" trace on interface 0 exactly once (Ipv4L3Protocol::SendRealOut
// treats loopback as a normal interface), loops back into RouteInput, and is
// enqueued. Deferral happens only at the source (the RouteInput branch
// requires idev == lo), and a queued packet exists nowhere else in the stack,
// so from that moment exactly one of three things can happen to its
// (flow, seq) key:
//   1. it exits the queue via SendPacketFromQueue -> ucb -> IpForward and
//      crosses "Tx" on a REAL interface (any later hop also erases — no-op);
//   2. aodv only: the queue drops it (timeout purge, overflow eviction,
//      RERR flush) through the entry's error callback ->
//      Ipv4L3Protocol::RouteInputError -> the "Drop" trace with
//      DROP_ROUTE_ERROR — while its key is still pending, which is what
//      distinguishes a queue drop from an ordinary forwarding route error;
//   3. nothing further is ever observed: dsdv's silent sheds (purge, Enqueue
//      overflow, SendPacketFromQueue's oif-mismatch discard) and, for both
//      protocols, packets still sitting in the queue when the run stops.
// Keys still pending at teardown are therefore the protocol queue's invisible
// losses (class 3), and pending keys seen at "Drop" are aodv queue drops that
// FlowMonitor has already counted — under DROP_ROUTE_ERROR, i.e. in the
// route column, where they are misattributed (a queue timeout is congestion,
// not a route failure). The report step adds class 3 to drop_queue_pct and
// moves class 2 from drop_route_pct to drop_queue_pct.
//
// Known imprecision, accepted: a packet that exits the queue and then dies to
// DROP_TTL_EXPIRED inside IpForward (before the real-interface "Tx") stays
// pending and is double-counted (ttl + queue). TTL starts at 64 on cells a
// handful of hops wide, so this path is structurally negligible.
//
// Byte-identity: connected only on the dsdv/aodv arms (and never under TCP,
// where the SeqTs key does not exist — same rule as ##DROPID##). The
// anthocnet and olsr arms never traverse these callbacks, both counters stay
// zero there, and the report arithmetic degenerates to the pre-#229 values.
std::set<std::pair<Address, uint32_t>> g_pqPending;
uint64_t g_pqEcbDrops = 0;

void PqTrackTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t iface) {
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromIp(p, flow, seq)) return;
    if (iface == 0) {
        g_pqPending.insert(std::make_pair(flow, seq));
    } else {
        g_pqPending.erase(std::make_pair(flow, seq));
    }
}

void PqTrackDrop(const Ipv4Header& ip, Ptr<const Packet> p, Ipv4L3Protocol::DropReason, Ptr<Ipv4>,
                 uint32_t) {
    if (g_pqPending.empty()) return;
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) return;
    // A pending key can only be dropped by the protocol queue's own error
    // callback (see conservation argument above), so no reason filter: any
    // L3 drop of a pending key IS a queue drop, and the reason it arrives
    // under (DROP_ROUTE_ERROR) is the misattribution being corrected.
    if (g_pqPending.erase(std::make_pair(flow, seq)) > 0) ++g_pqEcbDrops;
}

// --- diagnostics (--diag): ant-level introspection for AntHocNet -----------
// Answers "are routes forming and when?": per-type ant send/receive tallies
// (from the protocol's own item-15 Tx/Rx trace sources) and the time of the
// first delivered data packet (works for every protocol, from the sink's Rx).
bool g_diag = false;
std::map<uint8_t, uint64_t> g_antTx;  // by AntType byte
std::map<uint8_t, uint64_t> g_antRx;
double g_firstDeliveryS = -1.0;
// #23: per-flow route-setup latency. g_firstDeliveryS alone is the sim time of
// the FIRST packet any sink receives — a min over all flows' random starts —
// so it measures the luckiest flow, not convergence. Track per-flow app start
// and first sink Rx instead (index-aligned with `sinks`; default pairing only,
// converge/--sink mode shares one sink and is skipped).
std::vector<double> g_flowStart;
std::vector<double> g_flowFirstRx;  // -1 = flow never delivered
// #62: per-flow delivered packets (index-aligned with g_flowStart), read by
// the --seriesEvery sampler below.
std::vector<uint64_t> g_flowRx;

// --- control and delivery over time (--seriesEvery, #62) --------------------
// The end-of-run books say how much control a run sent, not when. The
// partition/merge scenario needs the when: control must plateau while the
// field is split (a #20/#45-class storm grows instead), and each flow across
// the split must deliver again soon after the merge. Every S seconds the
// sampler records the cumulative routing-control count, AntHocNet's ant
// transmissions by type, and each flow's delivered packets; the run prints
// them as `# series` lines. Read-only: nothing is scheduled unless the flag
// is given, so every other run is unchanged.
struct SeriesSample {
    double t;
    uint64_t ctrl;
    uint64_t ant[5];  // hello, reactive, proactive, repair, linkfail
    std::vector<uint64_t> rx;
};
std::vector<SeriesSample> g_series;

void DiagAntTx(uint8_t type, uint8_t /*dir*/, bool /*broadcast*/) {
    if (g_diag) g_antTx[type] += 1;
}
void DiagAntRx(uint8_t type, uint8_t /*dir*/) {
    if (g_diag) g_antRx[type] += 1;
}
void DiagSinkRx(Ptr<const Packet>, const Address&) {
    if (g_firstDeliveryS < 0.0) g_firstDeliveryS = Simulator::Now().GetSeconds();
}
void DiagSinkRxFlow(uint32_t idx, Ptr<const Packet> p, const Address& a) {
    DiagSinkRx(p, a);
    if (idx < g_flowFirstRx.size() && g_flowFirstRx[idx] < 0.0) {
        g_flowFirstRx[idx] = Simulator::Now().GetSeconds();
    }
    if (idx < g_flowRx.size()) ++g_flowRx[idx];
}

void SampleSeries(double every, double stop) {
    SeriesSample s;
    s.t = Simulator::Now().GetSeconds();
    s.ctrl = g_controlPkts;
    const uint8_t types[5] = {0x01, 0x02, 0x04, 0x08, 0x10};
    for (int k = 0; k < 5; ++k) {
        auto it = g_antTx.find(types[k]);
        s.ant[k] = it == g_antTx.end() ? 0 : it->second;
    }
    s.rx = g_flowRx;
    g_series.push_back(std::move(s));
    if (s.t + every <= stop + 1e-9) Simulator::Schedule(Seconds(every), &SampleSeries, every, stop);
}

// --- queue diagnostics (--qdiag): does the A2 congestion signal exist? --------
// A2 (item 10) keys off the WiFi MAC queue depth Q_mac. If 802.11 loss under
// load is collision-dominated (frames lost on-air, shallow queues) rather than
// queue-dominated, Q_mac stays ~0 even at low PDR and A2 has nothing to act on.
// Sample every node's MAC backlog periodically and report the distribution to
// settle that empirically before pursuing A2 further (issue #73).
bool g_qdiag = false;
uint64_t g_qCount = 0, g_qNonzero = 0, g_qMax = 0;
double g_qSum = 0.0;

static uint32_t NodeMacBacklog(Ptr<Node> node) {
    uint32_t total = 0;
    for (uint32_t d = 0; d < node->GetNDevices(); ++d) {
        Ptr<WifiNetDevice> w = node->GetDevice(d)->GetObject<WifiNetDevice>();
        if (!w) continue;
        Ptr<WifiMac> mac = w->GetMac();
        if (!mac) continue;
        // AC_BE_NQOS first: the non-QoS AdhocWifiMac keeps its single DCF queue
        // there, not under AC_BE — omitting it makes the backlog always read 0
        // (issue #73, the reason the first qdiag pass saw maxQ=0 everywhere).
        for (AcIndex ac : {AC_BE_NQOS, AC_BE, AC_BK, AC_VI, AC_VO}) {
            Ptr<WifiMacQueue> q = mac->GetTxopQueue(ac);
            if (q) total += q->GetNPackets();
        }
    }
    return total;
}

// --- energy (#209) ----------------------------------------------------------
// Accounted directly from WifiPhyStateHelper's "State" trace — NOT from ns-3's
// BasicEnergySource + WifiRadioEnergyModel, which this harness used until
// #256: WifiRadioEnergyModel::ChangeState cancel-reschedules its
// m_switchToOffEvent (fire time = the battery's depletion horizon) on EVERY
// PHY state change, and a cancelled ns-3 event stays in the scheduler until
// its timestamp pops. With --energyJ sized so no node ever depletes, that
// horizon lies beyond Simulator::Stop, so the dense 50-node field leaked
// ~1e5 dead events per simulated second — ~12 MB/sim-s, ~11 GB per 900 s
// seed, the OOM that killed six 900 s campaign runs (measured: 11.09 GB with
// the model on vs 114 MB off, every other metric byte-identical — runs
// 30593659946 / 30596625756).
//
// The physics is unchanged: the "State" trace fires once per PHY state period
// with its exact duration, so consumed energy is the same
// sum(duration x I(state) x V) the framework integrated — with zero scheduled
// events and zero per-event allocation. The final still-open state at
// Simulator::Stop is never logged (the framework's GetRemainingEnergy()
// force-update did catch it); the resulting undercount is one state period,
// micro- to milliseconds of idle draw, ~1e-4 J.
//
// First-node-death: the framework's BasicEnergySource raised depletion at
// BasicEnergyLowBatteryThreshold (10% of initial remaining), and
// WifiRadioEnergyModel then STOPPED the radio. Here the crossing time is
// recorded at the same 10% threshold, but the radio keeps running — this is
// accounting, not battery emulation. Identical at the default --energyJ
// (nothing ever crosses; see kDefaultEnergyJ's sizing bound); a run that
// lowers --energyJ to provoke deaths now measures when nodes WOULD die
// instead of an energy-limited PDR. Sentinel -1.0 = no crossing this run.
double g_firstDeathS = -1.0;
std::vector<double> g_energyConsumedJ;  // per node, index-aligned with nodes
double g_energyInitJ = 0.0;             // this run's --energyJ
double g_energyVoltV = 0.0;
double g_energyTxA = 0.0, g_energyRxA = 0.0, g_energyIdleA = 0.0;

// #308 phase 2 step 3: channel-occupancy totals, summed over nodes (seconds).
//
// Step 2 measured the deficit as 36% extra path length and 64% extra cost per
// hop, and left one hypothesis standing for the per-hop half: AntHocNet sends
// fewer control PACKETS than AODV (NRL 36.08 vs 55.39) but substantially more
// control BYTES (nrl_bytes 42.607 vs 29.133), so it may simply be putting more
// airtime on a shared 2 Mbit/s medium that data then queues behind. That would
// raise per-hop delay while causing neither MAC drops (0.44% vs AODV's 10.43%)
// nor queue overflow (drop_queue 0.00 for both) — which is exactly the observed
// signature, and exactly why it needs measuring rather than believing.
//
// The PHY "State" trace is already connected for the energy accounting and
// already carries the duration of each state, so the occupancy totals are free:
// no new hook, no extra simulated work. TX is what this node put on the air;
// RX plus CCA_BUSY is what it saw others put there.
double g_airTxS = 0.0, g_airRxS = 0.0, g_airCcaS = 0.0;

/// #145: node `node`'s residual energy fraction, for the energy metric.
double ResidualEnergyFraction(uint32_t node) {
    if (g_energyInitJ <= 0.0 || node >= g_energyConsumedJ.size()) {
        return std::numeric_limits<double>::quiet_NaN();
    }
    const double left = (g_energyInitJ - g_energyConsumedJ[node]) / g_energyInitJ;
    return left < 0.0 ? 0.0 : left;
}

void OnPhyState(uint32_t node, Time, Time duration, WifiPhyState state) {
    switch (state) {
        case WifiPhyState::TX:
            g_airTxS += duration.GetSeconds();
            break;
        case WifiPhyState::RX:
            g_airRxS += duration.GetSeconds();
            break;
        case WifiPhyState::CCA_BUSY:
            g_airCcaS += duration.GetSeconds();
            break;
        default:
            break;
    }
    double currentA;
    switch (state) {
        case WifiPhyState::TX:
            currentA = g_energyTxA;
            break;
        case WifiPhyState::RX:
            currentA = g_energyRxA;
            break;
        // CcaBusy and Switching draw the idle current — the same tie the
        // helper-based install kept (see the --idleCurrentA note below).
        case WifiPhyState::IDLE:
        case WifiPhyState::CCA_BUSY:
        case WifiPhyState::SWITCHING:
            currentA = g_energyIdleA;
            break;
        // SLEEP/OFF: unreachable under AdhocWifiMac (no power save, and
        // nothing turns a PHY off any more — that was the leaking event's
        // job). Zero draw if a future config ever reaches them.
        default:
            currentA = 0.0;
            break;
    }
    double& consumed = g_energyConsumedJ[node];
    consumed += duration.GetSeconds() * currentA * g_energyVoltV;
    if (g_firstDeathS < 0.0 && g_energyInitJ - consumed <= 0.10 * g_energyInitJ) {
        g_firstDeathS = Simulator::Now().GetSeconds();
    }
}

// Radio energy parameters. These are ns-3's own WifiRadioEnergyModel /
// BasicEnergySource defaults, restated here explicitly instead of being
// inherited silently — docs/configuration.md's provenance rule, and this repo
// has already been bitten three times by unsourced defaults (#88, #169, #173).
//
// PROVENANCE (from ns-3's src/wifi/model/wifi-radio-energy-model.h, verbatim
// in every release from 3.36 to 3.48): the values come from the measurements
// reported in D. Halperin, B. Greenstein, A. Sheth and D. Wetherall,
// "Demystifying 802.11n power consumption", Proceedings of HotPower'10. The
// modelled hardware is a **single-antenna 802.11n NIC**, measured at
//   P_tx = 1.14 W (transmitting at 0 dBm), P_rx = 0.94 W,
//   P_idle = 0.82 W, P_sleep = 0.10 W,
// which at BasicEnergySource's 3.0 V default supply voltage give
//   I_tx = 0.380 A, I_rx = 0.313 A, I_idle = 0.273 A, I_sleep = 0.033 A.
// CcaBusy and Switching default to the idle current; Sleep is left at ns-3's
// 0.033 A and never reached (AdhocWifiMac has no power-save state here).
//
// CAVEAT worth carrying into any claim made from these numbers: the modelled
// NIC is 802.11n, while this harness runs 802.11b DCF at 2 Mbit/s (#51) — so
// absolute joules are a consistent yardstick across the four protocols, not a
// measurement of the paper's radio. --txCurrentA / --rxCurrentA /
// --idleCurrentA / --voltageV re-target them.
// kDefaultTxCurrentA: in routing-bench-internal.h, shared with the command line.
// kDefaultRxCurrentA: in routing-bench-internal.h, shared with the command line.
// kDefaultIdleCurrentA: in routing-bench-internal.h, shared with the command line.
// kDefaultVoltageV: in routing-bench-internal.h, shared with the command line.

// Initial energy per node (J). Deliberately sized so that no node dies during
// a normal run: a dying node makes PDR energy-limited, and every other metric
// in the taxonomy would silently change meaning. Bound: one node cannot draw
// more than the tx current for the whole run, 0.380 A x 3.0 V = 1.14 W, so the
// longest scenario the harness runs (900 s — --scenario=paper and =thesis)
// cannot consume more than 1026 J per node; the realistic idle-dominated draw
// is ~0.82 W, i.e. ~740 J. 5000 J is ~4.9x that hard upper bound (and covers
// runs up to ~4380 s even if a node transmitted continuously), while staying a
// physically plausible cell: 5000 J / 3.0 V = 463 mAh. Raise --energyJ for
// longer runs; lower it deliberately to provoke node deaths.
// kDefaultEnergyJ: in routing-bench-internal.h, shared with the command line.

// --- route quality: path length, path diversity, fairness (#217) ------------
// AntHocNet's defining property is that it lays and maintains *multiple* paths,
// and until now the harness measured nothing about paths at all: `a2 = 2.0`
// (antAcceptanceFactorNewHop) exists in the 2007 thesis specifically to buy
// disjoint paths and shipped in v1.1.0 evaluated on PDR/delay/NRL alone.
// Everything below is measured protocol-agnostically, from ns-3's own traces,
// for all four arms — the single-path baselines are the instrumentation's
// self-check, not a blank column.

// PATH LENGTH — hop count actually traversed by *delivered* data packets.
// Taken from the IP TTL seen at the destination's Ipv4L3Protocol "LocalDeliver"
// hook: every real forwarding hop runs through Ipv4L3Protocol::IpForward, which
// decrements the TTL exactly once, so
//     hops = (initial TTL - TTL at delivery) + 1
// counts transmissions, i.e. a neighbour delivery is 1 hop. Equivalent to
// FlowMonitor's FlowStats::timesForwarded + 1 (which accumulates only for
// delivered packets), but per packet rather than per flow — which is what makes
// the *maximum* available, and FlowMonitor exposes only the sum.
//
// The initial TTL is ns-3's Ipv4L3Protocol "DefaultTtl" attribute default, 64,
// unchanged across the 3.36-3.48 CI matrix; nothing here sets a SocketIpTtlTag,
// so every data packet starts there. CAVEAT (documented in
// docs/benchmarks/metrics.md): a reactive protocol that has no route yet bounces
// the packet through the loopback device to reach RouteInput (AODV and this
// adapter both do), and the resolved packet then leaves via IpForward — one
// extra TTL decrement that no radio ever carried. Those packets therefore read
// one hop high, so for anthocnet/aodv the mean is a slight over-estimate,
// bounded by (route discoveries)/(delivered packets). FlowMonitor's
// timesForwarded counts that same bounce, so this is not a defect of the TTL
// route specifically.
constexpr uint8_t kIpDefaultTtl = 64;
uint64_t g_hopSum = 0;    // sum of hop counts over delivered data packets
uint64_t g_hopCount = 0;  // delivered data packets seen at LocalDeliver
uint32_t g_hopMax = 0;

// PATH DIVERSITY (used, not available). The issue is explicit about the
// definition and it matters: pheromone entries above `minPheromone` are
// *available* paths, and a table full of pheromone that data never uses would
// read as diversity that does not exist. What is counted here is the number of
// distinct next hops that actually **carried a data packet**, per (node,
// destination) pair, within a time window.
//
// The window is load-bearing. Over a whole run a single-path protocol also
// touches several next hops for one destination — sequentially, as routes break
// and are rediscovered — so a whole-run count would credit AODV with
// "multipath" it does not have. Diversity is *concurrency*, so it is measured
// per (node, destination, window) cell and averaged over the cells that carried
// data. At the default 10 s window the baselines read ~1 (the residual excess
// above 1 is sequential route replacement inside one window, which is route
// churn, not spreading), while AntHocNet's stochastic spreading shows up
// immediately.
//
// Source: the WifiMac "AckedMpdu" trace. It fires at the transmitter for each
// unicast MPDU the next hop acknowledged, and its 802.11 header's Addr1 *is*
// the next hop — the only address-bearing transmit hook ns-3 offers uniformly
// to all four protocols (the Ipv4L3Protocol traces do not carry the gateway).
// "Acked" also makes "carried" literal: a frame the next hop never received is
// not a path that was used. The AntHocNet adapter already relies on this same
// trace across the whole CI matrix (#68), so its availability is established.
// kDefaultPathWindowS: in routing-bench-internal.h, shared with the command line.
double g_pathWindowS = kDefaultPathWindowS;
uint64_t g_divWindow = 0;  // index of the window g_divCur is accumulating
// (node index, destination IPv4) -> next-hop MAC (packed) -> data packets.
// Holds the current window only and is flushed into the accumulators when time
// crosses into the next one, so memory stays bounded however long the run is.
std::map<std::pair<uint32_t, uint32_t>, std::map<uint64_t, uint32_t>> g_divCur;
uint64_t g_divCells = 0;   // (node, dest, window) cells that carried data
double g_divSum = 0.0;     // sum over cells of distinct used next hops
double g_divEntSum = 0.0;  // sum over cells of the split's Shannon entropy
uint32_t g_divMax = 0;     // most distinct next hops seen in any one cell

void FlushDiversityWindow() {
    for (const auto& cell : g_divCur) {
        uint64_t total = 0;
        for (const auto& kv : cell.second) total += kv.second;
        if (total == 0) continue;
        double entropy = 0.0;
        for (const auto& kv : cell.second) {
            const double p = static_cast<double>(kv.second) / total;
            if (p > 0.0) entropy -= p * std::log(p) / std::log(2.0);
        }
        const uint32_t k = static_cast<uint32_t>(cell.second.size());
        ++g_divCells;
        g_divSum += k;
        g_divEntSum += entropy;
        if (k > g_divMax) g_divMax = k;
    }
    g_divCur.clear();
}

void CountAckedDataHop(uint32_t node, Ptr<const BENCH_WIFI_MPDU> mpdu) {
    if (!mpdu) return;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    StripMeshHeader(pkt, mpdu->GetHeader());  // #708
    LlcSnapHeader llc;
    if (pkt->GetSize() < llc.GetSerializedSize()) return;
    pkt->RemoveHeader(llc);
    if (llc.GetType() != 0x0800) return;  // not IPv4
    Ipv4Header ip;
    if (pkt->RemoveHeader(ip) == 0) return;
    // #454: a fragment crosses the MAC as its own frame, so a continuation
    // fragment (offset > 0, no L4 header to peek) can land here too. Data
    // never fragments (see IsDataIp), so it is never a data hop.
    if (ip.GetFragmentOffset() != 0) return;
    // Data only: routing control is exactly what must NOT count as a used path.
    // Routing control here is UDP, so a data-port TCP segment is by
    // construction never control (#389).
    if (ip.GetProtocol() == 6) {  // TCP
        TcpHeader tcp;
        if (pkt->PeekHeader(tcp) == 0) return;
        if (tcp.GetDestinationPort() != kDataPort) return;
    } else if (ip.GetProtocol() == 17) {  // UDP
        UdpHeader udp;
        if (pkt->PeekHeader(udp) == 0) return;
        if (udp.GetDestinationPort() != kDataPort) return;
    } else {
        return;  // neither UDP nor TCP
    }
    ++g_ackedDataHops;  // #377
    const uint64_t window = static_cast<uint64_t>(Simulator::Now().GetSeconds() / g_pathWindowS);
    if (window != g_divWindow) {
        FlushDiversityWindow();
        g_divWindow = window;
    }
    uint8_t mac[6] = {0, 0, 0, 0, 0, 0};
    mpdu->GetHeader().GetAddr1().CopyTo(mac);
    uint64_t nextHop = 0;
    for (int i = 0; i < 6; ++i) nextHop = (nextHop << 8) | mac[i];
    g_divCur[std::make_pair(node, ip.GetDestination().Get())][nextHop] += 1;
}

// #708: the hwmp arm's path. IP never sees the mesh's relays, so the path is
// the mesh points that queued the packet's data frame, in order: the BE queue
// of each interface (UDP data is TID 0), one enqueue per hop however many
// retries follow, and always before the frame is sent, so the path is complete
// when the destination delivers (the last hop's ack arrives after that).
void CountMeshDataHop(uint32_t node, Ptr<const BENCH_WIFI_MPDU> mpdu) {
    if (!g_routeOn || !mpdu || !mpdu->GetHeader().IsData()) return;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    StripMeshHeader(pkt, mpdu->GetHeader());
    LlcSnapHeader llc;
    if (pkt->GetSize() < llc.GetSerializedSize()) return;
    pkt->RemoveHeader(llc);
    if (llc.GetType() != 0x0800) return;
    Ipv4Header ip;
    if (pkt->RemoveHeader(ip) == 0) return;
    Address flow;
    uint32_t seq = 0;
    if (ReinjKeyFromUdp(ip, pkt, flow, seq)) g_routePending[flow][seq].push_back(node);
}

// Ipv4L3Protocol "LocalDeliver": one call per packet handed to the local
// transport, i.e. exactly the delivered packets PDR counts. The header arrives
// with the TTL the packet carried on the wire. Unlike the per-fragment "Tx"/
// "Rx" traces (#454), this one fires only after reassembly — Ipv4L3Protocol::
// LocalDeliver runs ProcessFragment first and traces the complete datagram
// with the offset reset to 0 — so the L4 peeks below need no fragment guard.
void CountDeliveredHops(const Ipv4Header& ip, Ptr<const Packet> p, uint32_t) {
    const bool isTcp = ip.GetProtocol() == 6;  // #389: TCP data counts here too
    UdpHeader udp;
    if (isTcp) {
        TcpHeader tcp;
        if (p->PeekHeader(tcp) == 0) return;
        if (tcp.GetDestinationPort() != kDataPort) return;
    } else {
        if (ip.GetProtocol() != 17) return;
        if (p->PeekHeader(udp) == 0) return;
        if (udp.GetDestinationPort() != kDataPort) return;
    }
    const uint8_t ttl = ip.GetTtl();
    uint32_t hops = ttl < kIpDefaultTtl ? static_cast<uint32_t>(kIpDefaultTtl - ttl) + 1u : 1u;
    // #708: the IP TTL of an 802.11s mesh reads one hop whatever the path, so
    // the hwmp arm counts the mesh hops CountMeshDataHop recorded for this
    // packet (UDP only, like the path itself).
    if (g_meshArm && !isTcp) {
        Ptr<Packet> b = p->Copy();
        UdpHeader u;
        b->RemoveHeader(u);
        SeqTsSizeHeader st;
        if (b->PeekHeader(st) != 0) {
            const auto f =
                g_routePending.find(InetSocketAddress(ip.GetSource(), u.GetSourcePort()));
            if (f != g_routePending.end()) {
                const auto it = f->second.find(st.GetSeq());
                if (it != f->second.end() && !it->second.empty()) {
                    hops = static_cast<uint32_t>(it->second.size());
                }
            }
        }
    }
    g_hopSum += hops;
    ++g_hopCount;
    if (hops > g_hopMax) g_hopMax = hops;

    // #389: stop here under TCP. SeqTsSizeHeader only exists in UDP datagrams;
    // under TCP the common-set key cannot be parsed off a byte stream (and the
    // flow key below needs udp.GetSourcePort()), so g_rxHopsBySeq stays empty
    // by design — absence is the encoding, same principle as #382.
    if (isTcp) return;

    // #308 phase 2: also record this packet's hop count under the same
    // (flow, seq) key the delays use, so the common set can be measured in hops
    // as well as in milliseconds. The flow key must be byte-identical to the one
    // PacketSink reports to RecordRxSeq, which is an InetSocketAddress built
    // from the sender's IP and UDP source port — exactly the two fields
    // available here. If that ever stopped matching, hopsCommon would read zero
    // while PDR stayed positive, which scenario_check.py results treats as a
    // FAIL rather than as "no hop data" (the #229/#230 rule).
    Ptr<Packet> body = p->Copy();
    body->RemoveHeader(udp);
    SeqTsSizeHeader seqTs;
    if (body->PeekHeader(seqTs) == 0) return;
    const Address flow = InetSocketAddress(ip.GetSource(), udp.GetSourcePort());
    g_rxHopsBySeq[flow][seqTs.GetSeq()] = hops;

    // #294 item 4: close this packet's path on its FIRST delivery. A duplicate
    // (#386 re-injection) finds no pending entry, or a fresh one that only
    // holds the copy's later hops, and is ignored either way.
    if (!g_routeOn) return;
    const uint32_t seq = seqTs.GetSeq();
    auto& pend = g_routePending[flow];
    auto& rx = g_routeRx[flow];
    const auto it = pend.find(seq);
    if (it != pend.end() && rx.find(seq) == rx.end()) {
        g_routeHopSum += it->second.size();
        const auto id = g_routeIds.emplace(it->second, static_cast<uint32_t>(g_routeIds.size()));
        rx[seq] = RouteRx{id.first->second, seqTs.GetTs().GetSeconds()};
    }
    if (it != pend.end()) pend.erase(it);
    if (seq > kRouteWindowSeq) {
        pend.erase(pend.begin(), pend.lower_bound(seq - kRouteWindowSeq));
    }
}

void SampleQueues(NodeContainer nodes, double period, double until) {
    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        const uint32_t q = NodeMacBacklog(nodes.Get(i));
        g_qCount += 1;
        g_qSum += q;
        if (q > 0) g_qNonzero += 1;
        if (q > g_qMax) g_qMax = q;
    }
    if (Simulator::Now().GetSeconds() + period < until) {
        Simulator::Schedule(Seconds(period), &SampleQueues, nodes, period, until);
    }
}

// --- #639: recording a run's movement as an ns-2 trace ---------------------------
// Each node's track is piecewise linear between course changes (RWP legs and
// pauses, Gauss-Markov steps, Manhattan waypoints), so a leg is written when
// it ends: "at t1 setdest <position at t2> <speed>". Written once per process
// (the first arm of the first seed; mobility is identical in every arm on a
// seed, #352) at 17 significant digits so every double round-trips.
struct TraceDump {
    bool active = false, done = false;
    std::vector<Vector> pos, vel;
    std::vector<double> t;
    std::ostringstream out;
};
static TraceDump g_traceDump;

static void TraceLeg(uint32_t i, const Vector& at) {
    const Vector v = g_traceDump.vel[i];
    const double speed = std::sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    if (speed > 0.0) {
        g_traceDump.out << "$ns_ at " << g_traceDump.t[i] << " \"$node_(" << i << ") setdest "
                        << at.x << ' ' << at.y << ' ' << speed << "\"\n";
    }
}

static void TraceCourseChange(uint32_t i, Ptr<const MobilityModel> m) {
    const Vector p = m->GetPosition();
    TraceLeg(i, p);
    g_traceDump.pos[i] = p;
    g_traceDump.vel[i] = m->GetVelocity();
    g_traceDump.t[i] = Simulator::Now().GetSeconds();
}

// #488: Manhattan-grid mobility (the VANET family, #301). The model of Bai,
// Sadagopan & Helmy, "IMPORTANT: a framework to systematically analyze the
// Impact of Mobility on Performance of RouTing protocols for Adhoc NeTworks",
// INFOCOM 2003 -- the model BonnMotion's ManhattanGrid implements -- built
// here as waypoints rather than imported as a BonnMotion trace, so a run needs
// no external tool and stays a function of its seed alone (#352).
//   * Streets are the block edges: x = i*areaX/blocksX, y = j*areaY/blocksY,
//     border streets included.
//   * A vehicle starts at a uniform point of the street network (placement is
//     length-weighted over all streets) heading either way along its street.
//   * At each intersection it goes straight with probability 0.5 and turns
//     left or right with 0.25 each (Bai 2003); a choice that would leave the
//     field is redrawn among the valid ones, and a dead end turns it back.
//   * Each block-to-block leg is driven at a speed drawn U(speedMin, speed).
//     BonnMotion instead perturbs speed every update interval; a per-leg draw
//     is the harness's simplification, recorded in docs/benchmarks/scenarios/vanet.md.
//   * There is no pause: --pause is inert under this model.
// All draws come from `u`, one stream pinned by the caller, consumed in node
// order -- so the schedule is identical in every arm on a seed.
void BuildManhattanWaypoints(Ptr<WaypointMobilityModel> wp, Ptr<UniformRandomVariable> u,
                             const Params& P) {
    const double bx = P.areaX / P.blocksX, by = P.areaY / P.blocksY;
    const double hLen = (P.blocksY + 1) * P.areaX;  // all horizontal streets
    const double vLen = (P.blocksX + 1) * P.areaY;  // all vertical streets
    double x, y;
    int dx, dy;
    const double r = u->GetValue(0.0, hLen + vLen);
    if (r < hLen) {
        const uint32_t j = std::min<uint32_t>(static_cast<uint32_t>(r / P.areaX), P.blocksY);
        x = std::fmod(r, P.areaX);
        y = j * by;
        dx = u->GetValue() < 0.5 ? 1 : -1;
        dy = 0;
    } else {
        const double rv = r - hLen;
        const uint32_t i = std::min<uint32_t>(static_cast<uint32_t>(rv / P.areaY), P.blocksX);
        x = i * bx;
        y = std::fmod(rv, P.areaY);
        dx = 0;
        dy = u->GetValue() < 0.5 ? 1 : -1;
    }
    double t = 0.0;
    wp->AddWaypoint(Waypoint(Seconds(t), Vector(x, y, 0.0)));
    // A direction is valid from an intersection if one more block stays on
    // the field.
    auto valid = [&](double px, double py, int ddx, int ddy) {
        const double nx = px + ddx * bx, ny = py + ddy * by;
        return nx > -1e-6 && nx < P.areaX + 1e-6 && ny > -1e-6 && ny < P.areaY + 1e-6;
    };
    constexpr double eps = 1e-9;
    while (t < P.simTime) {
        // Drive to the next intersection along (dx, dy).
        double nx = x, ny = y;
        if (dx != 0) {
            const double k =
                dx > 0 ? std::floor((x + eps) / bx) + 1 : std::ceil((x - eps) / bx) - 1;
            nx = std::min(std::max(k * bx, 0.0), P.areaX);
        } else {
            const double k =
                dy > 0 ? std::floor((y + eps) / by) + 1 : std::ceil((y - eps) / by) - 1;
            ny = std::min(std::max(k * by, 0.0), P.areaY);
        }
        const double dist = std::abs(nx - x) + std::abs(ny - y);
        const double v = u->GetValue(P.speedMin, P.speed);
        if (dist > 0.0) {
            t += dist / v;
            wp->AddWaypoint(Waypoint(Seconds(t), Vector(nx, ny, 0.0)));
        }
        x = nx;
        y = ny;
        // Turn: straight 0.5, left 0.25, right 0.25 (Bai 2003).
        const int opt[3][2] = {{dx, dy}, {-dy, dx}, {dy, -dx}};
        const double c = u->GetValue();
        int pick = c < 0.5 ? 0 : (c < 0.75 ? 1 : 2);
        if (!valid(x, y, opt[pick][0], opt[pick][1])) {
            int ok[3], n = 0;
            for (int k = 0; k < 3; ++k) {
                if (valid(x, y, opt[k][0], opt[k][1])) ok[n++] = k;
            }
            if (n == 0) {
                dx = -dx;  // dead end: turn back
                dy = -dy;
                continue;
            }
            pick = ok[std::min(n - 1, static_cast<int>(u->GetValue() * n))];
        }
        dx = opt[pick][0];
        dy = opt[pick][1];
    }
}

// ADR-0027: what an arm may touch of this run's measurement. The sinks are
// the file's own trace callbacks; the opt-in books record that an arm asked
// for them, so their lines are printed for that arm only (#382: absence, not
// zero, on every other arm).
class HarnessMeasurement : public bench::Measurement {
public:
    explicit HarnessMeasurement(const NodeContainer& nodes) : m_nodes(nodes) {}
    uint64_t ControlPackets() const override { return g_controlPkts; }
    uint64_t ControlBytes() const override { return g_controlBytes; }
    // #386: re-injection identity & fate. The l3Drop stage is an isolated
    // connect, cuttable with CountReinjL3Drop if a CI ns-3 version rejects
    // the "Drop" signature.
    void TrackReinjectionIdentity() override {
        reinjIdentity = true;
        for (uint32_t i = 0; i < m_nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = m_nodes.Get(i)->GetObject<Ipv4>();
            Ptr<Ipv4RoutingProtocol> rp = ip ? ip->GetRoutingProtocol() : nullptr;
            if (rp) {
                rp->TraceConnectWithoutContext("MacReinject", MakeCallback(&CountMacReinject));
                // #402: the capped-skip trace, same gate. Fires only when
                // MaxReinjectPerPacket != 0, so every field it feeds is a
                // measured zero on uncapped arms.
                rp->TraceConnectWithoutContext("MacReinjectSkip",
                                               MakeCallback(&CountMacReinjectSkip));
            }
            Ptr<Ipv4L3Protocol> l3 = m_nodes.Get(i)->GetObject<Ipv4L3Protocol>();
            if (l3) {
                l3->TraceConnectWithoutContext("Drop", MakeCallback(&CountReinjL3Drop));
            }
        }
    }
    void MacReinjectedData(const Ipv4Header& ip, Ptr<const Packet> p) override {
        CountAdaptiveReinject(ip, p);
    }
    void ArpReinjectedData(const Ipv4Header& ip, Ptr<const Packet> p) override {
        CountAdaptiveArpReinject(ip, p);
    }
    uint64_t ReinjectedData() const override { return g_adaptiveReinjData; }
    // #761: per-packet terminal fate (see the FateInfo block).
    void TrackPacketFate() override {
        g_fateOn = true;
        for (uint32_t i = 0; i < m_nodes.GetN(); ++i) {
            Ptr<Ipv4L3Protocol> l3 = m_nodes.Get(i)->GetObject<Ipv4L3Protocol>();
            if (l3) {
                l3->TraceConnectWithoutContext("SendOutgoing", MakeCallback(&CountFateSend));
                l3->TraceConnectWithoutContext("Drop", MakeCallback(&CountFateL3Drop));
            }
        }
    }
    // #229: pending-queue conservation (see the PqTrackTx block comment).
    void TrackPendingQueue() override {
        pendingQueue = true;
        for (uint32_t i = 0; i < m_nodes.GetN(); ++i) {
            Ptr<Ipv4L3Protocol> l3 = m_nodes.Get(i)->GetObject<Ipv4L3Protocol>();
            if (l3) {
                l3->TraceConnectWithoutContext("Tx", MakeCallback(&PqTrackTx));
                l3->TraceConnectWithoutContext("Drop", MakeCallback(&PqTrackDrop));
            }
        }
    }
    void MeshManagementEnqueue(Ptr<const BENCH_WIFI_MPDU> mpdu) override { CountMeshMgtTx(mpdu); }
    void MeshDataEnqueue(uint32_t node, Ptr<const BENCH_WIFI_MPDU> mpdu) override {
        CountMeshDataHop(node, mpdu);
    }
    uint64_t MeshPeeringFrames() const override { return g_meshPeeringPkts; }
    uint64_t MeshBeacons() const override { return g_meshBeacons; }
    void TypedControlTx(uint8_t type, uint8_t dir, bool broadcast) override {
        DiagAntTx(type, dir, broadcast);
    }
    void TypedControlRx(uint8_t type, uint8_t dir) override { DiagAntRx(type, dir); }
    uint64_t TypedControlTxCount(uint8_t type) const override { return Tally(g_antTx, type); }
    uint64_t TypedControlRxCount(uint8_t type) const override { return Tally(g_antRx, type); }

    bool reinjIdentity = false;  // the arm asked for ##REINJ##
    bool pendingQueue = false;   // the arm asked for pqSilent/pqEcb

private:
    static uint64_t Tally(const std::map<uint8_t, uint64_t>& m, uint8_t k) {
        auto it = m.find(k);
        return it == m.end() ? 0 : it->second;
    }
    NodeContainer m_nodes;
};

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    // Reset the RNG run so every protocol sees the identical realisation.
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    // #352: and pin the stream indices into this seed's own block, so the
    // realisation depends on the seed alone and not on how many runs (or which
    // protocols) preceded this one in the process. See kStreamStride.
    const int64_t streamBase = static_cast<int64_t>(seed) * kStreamStride;
    int64_t stream = streamBase;
    g_controlPkts = 0;
    g_controlBytes = 0;
    g_meshPeeringPkts = g_meshBeacons = 0;  // #708
    // ADR-0027: a fresh arm per run, like every helper (the oracle's owns
    // this run's ground-truth graph, #296). An unknown arm aborts here rather
    // than run on the bare IP stack and emit a plausible-looking 0 % row (#448).
    Ptr<bench::Arm> arm = bench::Registry().Make(proto);
    NS_ABORT_MSG_UNLESS(arm,
                        "unknown protocol '" << proto << "' -- see --PrintHelp's --protocols list");
    bench::RunContext run;
    run.seed = seed;
    run.transport = P.transport;
    run.standard = P.standard;
    run.rateManager = P.rateManager;
    run.simTime = P.simTime;
    run.areaX = P.areaX;
    run.areaY = P.areaY;
    run.areaZ = P.areaZ;
    run.energyJ = P.energyJ;
    run.residualEnergy = &ResidualEnergyFraction;
    run.diag = g_diag;
    run.qdiag = g_qdiag;
    g_meshArm = arm->ProvidesDevices();  // #708
    g_antTx.clear();
    g_antRx.clear();
    g_firstDeliveryS = -1.0;
    g_flowStart.clear();
    g_flowFirstRx.clear();
    g_flowRx.clear();
    g_series.clear();
    g_qCount = g_qNonzero = g_qMax = 0;
    g_qSum = 0.0;
    g_firstDeathS = -1.0;
    g_airTxS = g_airRxS = g_airCcaS = 0.0;  // #308 phase 2 step 3
    g_rxSeq.clear();
    g_rxArrival.clear();               // #89
    g_rxDelayBySeq.clear();            // #308
    g_rxHopsBySeq.clear();             // #308 phase 2
    g_rxCount.clear();                 // #386
    g_routeOn = P.transport != "tcp";  // #294 item 4
    g_routePending.clear();
    g_routeIds.clear();
    g_routeRx.clear();
    g_routeHopSum = 0;
    g_reinj.clear();                                         // #386
    g_reinjEvents = g_reinjParsed = g_reinjOfDelivered = 0;  // #386
    g_reinjUnparsedIcmp = g_reinjUnparsedOther = 0;          // #386
    g_reinjSkip.clear();                                     // #402
    g_reinjSkips = 0;                                        // #402
    g_pqPending.clear();                                     // #229
    g_pqEcbDrops = 0;                                        // #229
    g_dataHopTx = g_dataHopRx = g_macDataDrops = 0;          // #215
    g_adaptiveReinjData = g_adaptiveArpReinjData = 0;        // #563
    g_fateOn = false;                                        // #761
    g_fate.clear();                                          // #761
    g_fateRecovered = 0;                                     // #761
    g_ackedDataHops = 0;                                     // #377
    // #217
    g_hopSum = g_hopCount = 0;
    g_hopMax = 0;
    g_pathWindowS = P.pathWindowS;
    g_divWindow = 0;
    g_divCur.clear();
    g_divCells = 0;
    g_divSum = g_divEntSum = 0.0;
    g_divMax = 0;

    NodeContainer nodes;
    nodes.Create(P.nNodes);

    // #708: --standard=80211a is the 5 GHz OFDM radio of the static-mesh
    // cell, where stock ns-3 802.11s can run (MeshHelper tunes its interfaces
    // to channel 100). main() holds it to the disk channel, which ignores
    // frequency, so the topology is the same as on 802.11b.
    const WifiStandard standard =
        P.standard == "80211a" ? WIFI_STANDARD_80211a : WIFI_STANDARD_80211b;
    WifiHelper wifi;
    wifi.SetStandard(standard);
    // #51/#708: the run's rate manager (bench::ApplyRateManager says why the
    // ns-3 default is not used), shared with a mesh arm's own helper.
    bench::ApplyRateManager(wifi, P.rateManager, P.standard);
    YansWifiPhyHelper phy;
    YansWifiChannelHelper channel;
    if (P.propagation == "tworay") {
        // Two-ray ground reflection (the paper's propagation model, #24): free
        // space (Friis) below the crossover distance, 1/d^4 beyond, so received
        // power — and thus capture and edge losses — vary realistically with
        // distance instead of the all-or-nothing disk. Two parameters are
        // mandatory or it misbehaves: the 802.11b Frequency (the model defaults
        // to 5.15 GHz) and a non-zero antenna height (nodes sit at z=0, and the
        // two-ray term scales with ht^2*hr^2 -> height 0 gives infinite loss and
        // no links, the classic ns-3 footgun). Effective range is then governed
        // by tx power vs receiver sensitivity, not a hard cap.
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::TwoRayGroundPropagationLossModel", "Frequency",
                                   DoubleValue(2.4e9), "HeightAboveZ", DoubleValue(1.5));
    } else if (P.propagation == "nakagami") {
        // #60: the fading arm. Two-ray path loss with Nakagami-m fast fading
        // stacked on top -- YansWifiChannelHelper chains loss models, and
        // Nakagami models *only* the fading envelope, so it needs a
        // distance-dependent model underneath it or there is no path loss at
        // all.
        //
        // Deliberately the same two-ray path loss as the `tworay` arm, with
        // identical Frequency/HeightAboveZ. That makes {tworay, nakagami} a
        // controlled contrast isolating fading alone, rather than two
        // unrelated channels -- which is what a channel-sensitivity axis
        // actually needs to say anything.
        //
        // ns-3's defaults (Distance1 80 m, Distance2 200 m, m0 1.5, m1 0.75,
        // m2 0.75) are the ns-2 model's: near-Rician close in, Rayleigh-ish
        // (m < 1) further out. Left at the defaults on purpose -- an
        // unsourced m-profile is exactly the kind of invented constant #88 and
        // #173 were.
        //
        // This is the first *stochastic* channel in the harness. Its RNG draws
        // are pinned by the existing channel.AssignStreams call below, which
        // was written for precisely this case.
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::TwoRayGroundPropagationLossModel", "Frequency",
                                   DoubleValue(2.4e9), "HeightAboveZ", DoubleValue(1.5));
        channel.AddPropagationLoss("ns3::NakagamiPropagationLossModel");
    } else if (P.propagation == "urban") {
        // #488: the VANET channel. The same two-ray path loss as the tworay
        // arm (identical Frequency/HeightAboveZ, so {tworay, urban} isolates
        // the buildings alone), plus the deterministic building shadowing of
        // Sommer et al. 2011 over the Manhattan grid's blocks. Requires
        // --mobility=manhattan (main() refuses otherwise): vehicles must drive
        // the streets the buildings line, or they would sit inside them.
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::TwoRayGroundPropagationLossModel", "Frequency",
                                   DoubleValue(2.4e9), "HeightAboveZ", DoubleValue(1.5));
        channel.AddPropagationLoss("ns3::UrbanObstacleShadowingLossModel", "AreaX",
                                   DoubleValue(P.areaX), "AreaY", DoubleValue(P.areaY), "BlocksX",
                                   UintegerValue(P.blocksX), "BlocksY", UintegerValue(P.blocksY),
                                   "StreetWidth", DoubleValue(P.streetWidth), "Buildings",
                                   StringValue(P.buildings));
    } else if (P.range > 0.0) {
        // A clean disk model at the paper's transmission range (reproducible
        // connectivity, independent of tx-power/sensitivity defaults).
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::RangePropagationLossModel", "MaxRange",
                                   DoubleValue(P.range));
    } else {
        channel = YansWifiChannelHelper::Default();
    }
    Ptr<YansWifiChannel> wifiChannel = channel.Create();
    phy.SetChannel(wifiChannel);
    WifiMacHelper mac;
    mac.SetType("ns3::AdhocWifiMac");
    // #708: an arm may bring its own devices (hwmp: one 802.11s mesh point
    // per node) on the same standard, PHY, channel and rate manager.
    // `devices` then holds what IP is bound to and `radios` the wifi
    // interfaces (what the energy and MAC hooks below read); on every other
    // arm the two are the same container, so nothing changes there.
    run.nodes = nodes;
    NetDeviceContainer devices, radios;
    if (arm->ProvidesDevices()) {
        bench::DeviceRequest req;
        req.phy = &phy;
        req.standard = standard;
        devices = arm->InstallDevices(run, req, radios);
    } else {
        devices = wifi.Install(phy, mac, nodes);
        radios = devices;
    }
    // #352: the propagation models configured above are all deterministic, so
    // the channel normally reports 0 streams — pinned anyway so swapping in a
    // fading model (Nakagami, ...) cannot reintroduce the position dependence.
    // WifiHelper::AssignStreams covers the PHY's reception-error variable, the
    // MAC/Txop backoff and the rate manager in one call.
    run.devices = devices;
    run.radios = radios;
    TakeStreams(stream, streamBase, channel.AssignStreams(wifiChannel, stream), "wifi channel");
    if (arm->ProvidesDevices()) {
        // #708: the arm's devices (hwmp: MeshHelper::AssignStreams, the same
        // PHY, MAC and Txop variables through each mesh point's interfaces,
        // plus HWMP's and the peering protocol's own jitter) draw from the
        // device sub-block (see kMeshStreamOffset). The running counter then
        // advances by what the ad-hoc arms take: one scratch ad-hoc device,
        // off this run's channel, measures the per-device count on this ns-3
        // release.
        NS_ABORT_MSG_IF(stream - streamBase >= kMeshStreamOffset,
                        "running stream counter reached the mesh sub-block (#708)");
        const int64_t meshUsed = arm->AssignDeviceStreams(run, streamBase + kMeshStreamOffset);
        NS_ABORT_MSG_IF(kMeshStreamOffset + meshUsed >= kAppStreamOffset,
                        "mesh streams overlap the application sub-block (#708)");
        NodeContainer scratch;
        scratch.Create(1);
        YansWifiPhyHelper scratchPhy = phy;
        scratchPhy.SetChannel(CreateObject<YansWifiChannel>());
        const int64_t perDevice = wifi.AssignStreams(wifi.Install(scratchPhy, mac, scratch),
                                                     streamBase + kMeshStreamOffset + meshUsed);
        TakeStreams(stream, streamBase, perDevice * static_cast<int64_t>(nodes.GetN()),
                    "wifi (hwmp: the ad-hoc arms' count, held for pairing)");
    } else {
        TakeStreams(stream, streamBase, wifi.AssignStreams(devices, stream), "wifi");
    }

    // --- energy accounting (#209, leak-free per #256) ------------------------
    // Hooked here — right after the devices exist, before the routing stack,
    // from the same parameters, for every protocol — so the joule figures are
    // comparable across arms exactly the way PDR/NRL already are. See the
    // OnPhyState block above for why this integrates the PHY "State" trace
    // instead of installing BasicEnergySource + WifiRadioEnergyModel, and for
    // the --energyJ=0 / first-death semantics. WifiPhy::GetState() and the
    // WifiPhyStateHelper "State" trace (Time start, Time duration,
    // WifiPhyState) are unchanged across the 3.36-3.48 CI matrix (checked
    // against 3.36's wifi-phy.h / wifi-phy-state-helper.h).
    //
    // --idleCurrentA covers Idle, CcaBusy and Switching alike — the same tie
    // the helper-based install kept: the radio is idle or CCA-busy for almost
    // the entire run, so a third-applied override would silently dominate the
    // result.
    const bool energyOn = P.energyJ > 0.0;
    g_energyConsumedJ.assign(nodes.GetN(), 0.0);
    g_energyInitJ = P.energyJ;
    g_energyVoltV = P.voltageV;
    g_energyTxA = P.txCurrentA;
    g_energyRxA = P.rxCurrentA;
    g_energyIdleA = P.idleCurrentA;
    if (energyOn) {
        for (uint32_t i = 0; i < radios.GetN(); ++i) {
            Ptr<WifiNetDevice> w = radios.Get(i)->GetObject<WifiNetDevice>();
            if (w && w->GetPhy()) {
                w->GetPhy()->GetState()->TraceConnectWithoutContext(
                    "State", MakeBoundCallback(&OnPhyState, i));
            }
        }
    }

    MobilityHelper mobility;
    Ptr<UniformRandomVariable> ux = CreateObject<UniformRandomVariable>();
    ux->SetAttribute("Min", DoubleValue(0.0));
    ux->SetAttribute("Max", DoubleValue(P.areaX));
    Ptr<UniformRandomVariable> uy = CreateObject<UniformRandomVariable>();
    uy->SetAttribute("Min", DoubleValue(0.0));
    uy->SetAttribute("Max", DoubleValue(P.areaY));
    // #480: a 3-D box only when --areaZ > 0. The planar field keeps the exact
    // RandomRectanglePositionAllocator it always had -- same object, same two
    // variables, same stream count -- so areaZ=0 stays byte-identical to the
    // published corpus rather than merely equivalent in distribution.
    Ptr<PositionAllocator> pos;
    if (P.areaZ > 0.0) {
        Ptr<UniformRandomVariable> uz = CreateObject<UniformRandomVariable>();
        uz->SetAttribute("Min", DoubleValue(0.0));
        uz->SetAttribute("Max", DoubleValue(P.areaZ));
        Ptr<RandomBoxPositionAllocator> box = CreateObject<RandomBoxPositionAllocator>();
        box->SetX(ux);
        box->SetY(uy);
        box->SetZ(uz);
        pos = box;
    } else {
        Ptr<RandomRectanglePositionAllocator> rect =
            CreateObject<RandomRectanglePositionAllocator>();
        rect->SetX(ux);
        rect->SetY(uy);
        pos = rect;
    }
    mobility.SetPositionAllocator(pos);
    std::ostringstream speedStr, pauseStr;
    speedStr << "ns3::UniformRandomVariable[Min=" << P.speedMin << "|Max=" << P.speed << "]";
    pauseStr << "ns3::ConstantRandomVariable[Constant=" << P.pause << "]";
    // #61: mobility model selection. `rwp` is the default and is left exactly
    // as it was — every published number was measured under it, and the
    // steady-state/Gauss-Markov arms are additions, not replacements.
    if (P.mobility == "ssrwp") {
        // Steady-state RWP (Navidi & Camp): initial speed/position are drawn
        // from RWP's *stationary* distribution, so the run starts where plain
        // RWP only arrives asymptotically. This removes the speed-decay
        // transient that makes long RWP runs slower than their nominal speed
        // (Yoon et al., INFOCOM 2003) and the matching density transient.
        //
        // It takes its own field bounds instead of a PositionAllocator: the
        // stationary position distribution is not uniform, so it must place
        // nodes itself. MinSpeed must be > 0 — the stationary distribution
        // divides by speed — which the 1.0 m/s floor above already satisfies.
        mobility.SetMobilityModel(
            "ns3::SteadyStateRandomWaypointMobilityModel", "MinSpeed", DoubleValue(P.speedMin),
            "MaxSpeed", DoubleValue(P.speed), "MinPause", DoubleValue(P.pause), "MaxPause",
            DoubleValue(P.pause), "MinX", DoubleValue(0.0), "MaxX", DoubleValue(P.areaX), "MinY",
            DoubleValue(0.0), "MaxY", DoubleValue(P.areaY));
    } else if (P.mobility == "gaussmarkov") {
        // Gauss-Markov: velocity and direction are temporally correlated
        // (alpha = 0.85), so tracks are smooth rather than the sharp
        // waypoint-to-waypoint turns of RWP. This is the qualitatively
        // different model #295 asks for, and the one aerial/FANET claims
        // require.
        //
        // Two-dimensional by default: with --areaZ=0 the Box's z extent is
        // zero and the pitch is pinned at 0, so nodes stay in the plane the
        // propagation models and the 2-D field geometry assume. With
        // --areaZ > 0 (#480, the FANET family #300) the Box gains that z
        // extent and the pitch a small symmetric spread, so tracks climb and
        // descend; the model reflects off every face of the box, the top and
        // bottom included.
        //
        // The 3-D pitch values below are a harness choice, not a sourced
        // profile: +/-0.05 rad mean pitch and a Normal(0, 0.02) perturbation
        // bounded at 0.04 rad, i.e. the direction perturbation's shape scaled
        // down by ten. #482 found no published FANET evaluation that states
        // its Gauss-Markov pitch parameters, so the FANET preset keeps these
        // and docs/benchmarks/scenarios/fanet.md records them as an
        // assumption rather than a citation.
        //
        // There is no pause concept here -- a Gauss-Markov node never stops.
        // `--pause` is therefore inert under this model, which is why
        // scenario_check.py's preflight refuses the combination rather than
        // letting a sweep believe it varied something.
        mobility.SetMobilityModel(
            "ns3::GaussMarkovMobilityModel", "Bounds",
            BoxValue(Box(0.0, P.areaX, 0.0, P.areaY, 0.0, P.areaZ)), "TimeStep",
            TimeValue(Seconds(1.0)), "Alpha", DoubleValue(0.85), "MeanVelocity",
            StringValue(speedStr.str()), "MeanDirection",
            StringValue("ns3::UniformRandomVariable[Min=0.0|Max=6.283185307]"), "MeanPitch",
            StringValue(P.areaZ > 0.0 ? "ns3::UniformRandomVariable[Min=-0.05|Max=0.05]"
                                      : "ns3::ConstantRandomVariable[Constant=0.0]"),
            "NormalVelocity",
            StringValue("ns3::NormalRandomVariable[Mean=0.0|Variance=1.0|Bound=1.0]"),
            "NormalDirection",
            StringValue("ns3::NormalRandomVariable[Mean=0.0|Variance=0.2|Bound=0.4]"),
            // Zero-variance *Normal*, not a ConstantRandomVariable: ns-3 types
            // the three Normal* attributes with
            // MakePointerChecker<NormalRandomVariable>, so a constant is
            // rejected outright ("Invalid value for attribute set
            // (NormalPitch)", SIGABRT). MeanPitch above takes the plain
            // RandomVariableStream checker and does accept a constant, which
            // is why only this one tripped. Variance 0 keeps the pitch pinned
            // at 0 and the model two-dimensional (the planar default).
            "NormalPitch",
            StringValue(P.areaZ > 0.0
                            ? "ns3::NormalRandomVariable[Mean=0.0|Variance=0.02|Bound=0.04]"
                            : "ns3::NormalRandomVariable[Mean=0.0|Variance=0.0|Bound=0.0]"));
    } else if (P.mobility == "manhattan") {
        // #488: waypoints are filled in after Install(), below.
        mobility.SetMobilityModel("ns3::WaypointMobilityModel");
    } else if (P.mobility == "trace") {
        // #639: installed from the trace below, after the stream reservation.
    } else {
        // With --areaZ > 0 the waypoints come from the 3-D box allocator above,
        // so RWP legs are straight 3-D segments with no further change (#480).
        mobility.SetMobilityModel("ns3::RandomWaypointMobilityModel", "Speed",
                                  StringValue(speedStr.str()), "Pause", StringValue(pauseStr.str()),
                                  "PositionAllocator", PointerValue(pos));
    }
    // #352: the initial positions are drawn during Install(), so the allocator
    // has to be pinned BEFORE it — MobilityHelper::AssignStreams can only reach
    // the models (and, through RandomWaypoint, the allocator's later waypoint
    // draws) once they exist.
    TakeStreams(stream, streamBase, pos->AssignStreams(stream), "position allocator");
    if (P.mobility == "trace") {
        // #639: reserve exactly the streams the RWP default would take, so
        // every later stream (routing, MAC, applications) keeps the index it
        // has in the generated run and a dumped run replays byte-identically.
        // The models are only counted, never installed or initialised.
        int64_t used = 0;
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            Ptr<RandomWaypointMobilityModel> m = CreateObject<RandomWaypointMobilityModel>();
            m->SetAttribute("Speed", StringValue(speedStr.str()));
            m->SetAttribute("Pause", StringValue(pauseStr.str()));
            m->SetAttribute("PositionAllocator", PointerValue(pos));
            used += m->AssignStreams(stream + used);
        }
        TakeStreams(stream, streamBase, used, "mobility");
        Ns2MobilityHelper ns2(P.traceFile);
        ns2.Install(nodes.Begin(), nodes.End());  // $node_(i) = the i-th node here
    } else {
        mobility.Install(nodes);
        TakeStreams(stream, streamBase, mobility.AssignStreams(nodes, stream), "mobility");
    }
    // #639: --dumpTrace records the first run's movement (see TraceDump).
    g_traceDump.active = !P.dumpTrace.empty() && !g_traceDump.done;
    if (g_traceDump.active) {
        const uint32_t n = nodes.GetN();
        g_traceDump.pos.assign(n, Vector());
        g_traceDump.vel.assign(n, Vector());
        g_traceDump.t.assign(n, 0.0);
        g_traceDump.out.str("");
        g_traceDump.out << std::setprecision(17);
        for (uint32_t i = 0; i < n; ++i) {
            Ptr<MobilityModel> m = nodes.Get(i)->GetObject<MobilityModel>();
            const Vector p = m->GetPosition();
            g_traceDump.pos[i] = p;
            g_traceDump.out << "$node_(" << i << ") set X_ " << p.x << '\n'
                            << "$node_(" << i << ") set Y_ " << p.y << '\n'
                            << "$node_(" << i << ") set Z_ " << p.z << '\n';
            m->TraceConnectWithoutContext("CourseChange", MakeBoundCallback(&TraceCourseChange, i));
        }
    }
    if (P.mobility == "manhattan") {
        // #488: one pinned stream for the whole grid schedule, drawn in node
        // order. Mobility is installed before routing, so the stream index
        // (and hence every vehicle's route) is the same in every arm.
        Ptr<UniformRandomVariable> mh = CreateObject<UniformRandomVariable>();
        mh->SetStream(stream);
        TakeStreams(stream, streamBase, 1, "manhattan mobility");
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            BuildManhattanWaypoints(nodes.Get(i)->GetObject<WaypointMobilityModel>(), mh, P);
        }
        // Evidence the vehicles drive the streets (the CI smoke reads it):
        // under --diag, every node's position at t=0 and mid-run, as the
        // distance to the nearest street centre line (0 on the grid).
        if (g_diag) {
            auto road = [nodes, proto, seed, P]() {
                const double bx = P.areaX / P.blocksX, by = P.areaY / P.blocksY;
                double worst = 0.0;
                for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                    const Vector q = nodes.Get(i)->GetObject<MobilityModel>()->GetPosition();
                    const double ox = std::abs(q.x - bx * std::round(q.x / bx));
                    const double oy = std::abs(q.y - by * std::round(q.y / by));
                    worst = std::max(worst, std::min(ox, oy));
                }
                std::cout << std::fixed << std::setprecision(3) << "# road " << proto
                          << " seed=" << seed << " t=" << Simulator::Now().GetSeconds()
                          << " offStreetMaxM=" << worst << '\n';
            };
            Simulator::Schedule(Seconds(0.0), road);
            Simulator::Schedule(Seconds(P.simTime / 2.0), road);
        }
    }
    // #480: evidence that a 3-D field is really 3-D. Under --diag, a 3-D run
    // prints the altitude span of the nodes at t=0 and at mid-run (the second
    // shows the mobility model actually moves them vertically, not just the
    // placement). Planar runs print nothing, so their --diag output is
    // unchanged. Prefixed "# " like every diagnostic, so CSV consumers skip it.
    if (g_diag && P.areaZ > 0.0) {
        auto geom = [nodes, proto, seed]() {
            double zMin = 0.0, zMax = 0.0;
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                const double z = nodes.Get(i)->GetObject<MobilityModel>()->GetPosition().z;
                if (i == 0 || z < zMin) zMin = z;
                if (i == 0 || z > zMax) zMax = z;
            }
            std::cout << std::fixed << std::setprecision(2) << "# geom " << proto
                      << " seed=" << seed << " t=" << Simulator::Now().GetSeconds()
                      << " zMin=" << zMin << " zMax=" << zMax << '\n';
        };
        geom();
        Simulator::Schedule(Seconds(P.simTime / 2.0), geom);
    }

    // #352: the arm owns its routing helper, so the helper's AssignStreams()
    // can run after Install() (SetRoutingHelper stores a Copy(), but
    // AssignStreams reaches the *installed* protocols through the nodes).
    InternetStackHelper internet;
    arm->InstallRouting(internet, run);
    internet.Install(nodes);
    // Post-stack wiring the arm needs (gpsr's UDP re-wiring, AntHocNet's
    // energy probe), on this run's nodes only, so repeated RunOne calls
    // can't cross-wire.
    arm->AfterStack(run);
    // The IPv4 stack is NOT stream-free, contrary to the first cut of this fix:
    // ArpL3Protocol owns m_requestJitter, a RandomVariableStream used to de-sync
    // ARP requests, and on a wifi MANET every next-hop change resolves through
    // ARP. Leaving it unpinned is what made the seed-independence gate still
    // fail after everything else was pinned — small per-run timing shifts that
    // cascade into route discovery. InternetStackHelper::AssignStreams reaches
    // it (and Ipv4GlobalRouting, which is inert here); it exists in every ns-3
    // of the 3.36-3.48 matrix.
    TakeStreams(stream, streamBase, internet.AssignStreams(nodes, stream),
                "internet stack (arp request jitter)");
    // Each protocol builds a UniformRandomVariable per node (ant/RREQ jitter,
    // hello jitter) at construction; the arm pins them.
    TakeStreams(stream, streamBase, arm->AssignStreams(run, stream), (proto + " routing").c_str());

    // Count routing-control transmissions uniformly at the IP layer. Connect to
    // this run's nodes specifically (not a global /NodeList/* path) so repeated
    // RunOne calls in one process can't cross-wire.
    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnectWithoutContext("Tx", MakeCallback(&CountControlTx));
        // #215: the same IP-layer hook, counting *data* hops in and out, plus
        // the MAC's own retry-limit verdict. Connected per protocol arm, so the
        // causes are measured identically for anthocnet, aodv, olsr and dsdv.
        if (l3) {
            l3->TraceConnectWithoutContext("Tx", MakeCallback(&CountDataHopTx));
            l3->TraceConnectWithoutContext("Rx", MakeCallback(&CountDataHopRx));
            // #217 path length: TTL of every locally delivered data packet.
            l3->TraceConnectWithoutContext("LocalDeliver", MakeCallback(&CountDeliveredHops));
        }
    }
    // ADR-0027: the arm connects its protocol's traces to this run's
    // measurement, and asks for the opt-in books its protocol supports:
    // #386's re-injection identity (AntHocNet + UDP: the baselines have no
    // detector, and under TCP the SeqTs identity does not exist) and #229's
    // pending-queue conservation (dsdv + aodv + UDP). An arm that asks for
    // neither emits neither line (#382: absence, not zero).
    HarnessMeasurement measurement(nodes);
    arm->ConnectTraces(run, measurement);
    for (uint32_t i = 0; i < radios.GetN(); ++i) {
        Ptr<WifiNetDevice> w = radios.Get(i)->GetObject<WifiNetDevice>();
        Ptr<WifiMac> wmac = w ? w->GetMac() : nullptr;  // `mac` above is the helper
        // TraceConnect returns false if the source is absent on this ns-3
        // release; tolerated, exactly as the adapter's detector D does — the
        // MAC column then reads 0 and its share lands in channel loss.
        // #217 path diversity: the next hop of every data frame the MAC got an
        // ack for, bound to the transmitting node. `devices` is index-aligned
        // with `nodes` (one wifi device per node), so `i` names the transmitter.
        // The same tolerance applies — the diversity columns then read 0, which
        // scenario_check.py FAILs whenever PDR is non-zero rather than letting a
        // silently-missing trace pass as "no multipath".
        if (wmac) {
            wmac->TraceConnectWithoutContext("DroppedMpdu", MakeCallback(&CountMacDataDrop));
            wmac->TraceConnectWithoutContext("AckedMpdu", MakeBoundCallback(&CountAckedDataHop, i));
        }
    }

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer ifs = address.Assign(devices);
    // #708: what the arm does once addresses exist (hwmp: the ARP caches).
    arm->AfterAddresses(run, ifs);

    // nFlows CBR flows from node i to node (nNodes-1-i), each starting at a
    // random time within the start window (paper staggers sources over 0-180 s).
    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(0.0));
    startVar->SetAttribute("Max", DoubleValue(std::min(P.startWindow, P.simTime * 0.5)));
    // #352: pinned before the flow loop below reads it — the start times are
    // drawn there, not at Simulator::Run().
    // #431: pinned at a FIXED offset in the seed block, not the running
    // counter — the counter's value here depends on how many streams the
    // routing arm consumed, and an arm-dependent stream would give every arm
    // different flow start times, breaking the (flow, seq) packet identity
    // the ##COMMON##/##MATCH## comparison rests on (see kAppStreamOffset).
    int64_t appStream = streamBase + kAppStreamOffset;
    startVar->SetStream(appStream);
    appStream += 1;
    std::ostringstream rate;
    rate << static_cast<uint64_t>(P.cbrBps) << "bps";
    uint16_t port = kDataPort;
    ApplicationContainer apps, sinks;
    // Gateway hotspot (#71): all flows converge on one sink so nodes near it are
    // congested while peripheral approach paths stay idle — the localized
    // congestion + detour regime where load-aware routing can pay. Sources can
    // then span up to n-1 nodes; the default 1:1 pairing caps them at n/2.
    const bool converge = (P.sink >= 0);
    const uint32_t maxFlows = converge ? (P.nNodes - 1) : (P.nNodes / 2);
    // #639: --flowsFile replaces the generated pairing. Each flow keeps the
    // data port (every data classifier keys on it), so flows sharing a
    // destination share its sink; per-flow setup latency is then off, as in
    // converge mode.
    std::vector<Params::FlowSpec> dumped;
    if (!P.flowList.empty()) {
        std::set<uint32_t> sinkAt;
        for (const Params::FlowSpec& f : P.flowList) {
            const double stopS = std::min(f.stop, P.simTime - 1.0);
            std::ostringstream fr;
            fr << static_cast<uint64_t>(f.bps) << "bps";
            if (P.transport == "tcp") {
                BulkSendHelper bulk("ns3::TcpSocketFactory",
                                    InetSocketAddress(ifs.GetAddress(f.dst), port));
                bulk.SetAttribute("MaxBytes", UintegerValue(0));
                bulk.SetAttribute("StartTime", TimeValue(Seconds(f.start)));
                bulk.SetAttribute("StopTime", TimeValue(Seconds(stopS)));
                apps.Add(bulk.Install(nodes.Get(f.src)));
            } else {
                OnOffHelper onoff("ns3::UdpSocketFactory",
                                  InetSocketAddress(ifs.GetAddress(f.dst), port));
                onoff.SetAttribute("DataRate", StringValue(fr.str()));
                onoff.SetAttribute("PacketSize", UintegerValue(64));
                onoff.SetAttribute("EnableSeqTsSizeHeader", BooleanValue(true));
                onoff.SetAttribute("OnTime",
                                   StringValue("ns3::ConstantRandomVariable[Constant=1]"));
                std::ostringstream off;
                off << "ns3::ConstantRandomVariable[Constant=" << P.offTime << ']';
                onoff.SetAttribute("OffTime", StringValue(off.str()));
                onoff.SetAttribute("StartTime", TimeValue(Seconds(f.start)));
                onoff.SetAttribute("StopTime", TimeValue(Seconds(stopS)));
                apps.Add(onoff.Install(nodes.Get(f.src)));
            }
            g_flowStart.push_back(f.start);
            if (sinkAt.insert(f.dst).second) {
                PacketSinkHelper sink(
                    P.transport == "tcp" ? "ns3::TcpSocketFactory" : "ns3::UdpSocketFactory",
                    InetSocketAddress(Ipv4Address::GetAny(), port));
                sinks.Add(sink.Install(nodes.Get(f.dst)));
            }
        }
    }
    for (uint32_t i = 0; P.flowList.empty() && i < P.nFlows && i < maxFlows; ++i) {
        uint32_t src = i;
        uint32_t dst = converge ? static_cast<uint32_t>(P.sink) : (P.nNodes - 1 - i);
        if (src == dst) continue;  // source coincides with the gateway: skip
        // #63: the TCP arm. A saturating BulkSend, not a rate-limited OnOff
        // over TCP: at the paper's 512 bps / 1 packet-per-second the congestion
        // window never leaves 1-2 segments, so reordering — the entire reason
        // this arm exists — could not affect it. The trade is that 20
        // saturating flows congest a pinned 2 Mbit/s channel, so this is its
        // own regime and NOT a drop-in variant of the UDP base scenario.
        //
        // READ THE METRICS DIFFERENTLY HERE. TCP retransmits until it succeeds,
        // so FlowMonitor's txPackets inflates and `pdr` stops being a delivery
        // ratio; `thrput` counts retransmitted IP bytes rather than goodput;
        // and NRL's per-delivered-packet denominator inflates with them, which
        // *flatters* whichever protocol reorders most — the opposite of what
        // this arm is measuring. The headline for a TCP cell is ##GOODPUT##
        // (application bytes delivered), emitted below.
        if (P.transport == "tcp") {
            BulkSendHelper bulk("ns3::TcpSocketFactory",
                                InetSocketAddress(ifs.GetAddress(dst), port));
            bulk.SetAttribute("MaxBytes", UintegerValue(0));  // unbounded
            const double startS = startVar->GetValue();
            dumped.push_back({src, dst, startS, P.simTime - 1.0, P.cbrBps});
            bulk.SetAttribute("StartTime", TimeValue(Seconds(startS)));
            bulk.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
            apps.Add(bulk.Install(nodes.Get(src)));
            if (!converge) {
                g_flowStart.push_back(startS);
                PacketSinkHelper sink("ns3::TcpSocketFactory",
                                      InetSocketAddress(Ipv4Address::GetAny(), port));
                sinks.Add(sink.Install(nodes.Get(dst)));
            }
            continue;
        }
        OnOffHelper onoff("ns3::UdpSocketFactory", InetSocketAddress(ifs.GetAddress(dst), port));
        onoff.SetAttribute("DataRate", StringValue(rate.str()));
        onoff.SetAttribute("PacketSize", UintegerValue(64));
        // #212: carry a per-flow application sequence number so reordering can
        // be measured at the sink. This does NOT change the packet size, and so
        // does not move a single existing PDR / delay / throughput / NRL number:
        // ns-3 builds the 20-byte SeqTsSizeHeader *inside* the configured
        // PacketSize (onoff-application.cc does
        // `Create<Packet>(m_pktSize - header.GetSerializedSize())` and then
        // `AddHeader`), so the datagram stays 64 bytes on the wire and only 44
        // of them are now dummy payload. The attribute and that construction
        // date from ns-3.31, i.e. they predate the whole CI matrix (3.36-3.48),
        // which is where this is actually compiled and run.
        onoff.SetAttribute("EnableSeqTsSizeHeader", BooleanValue(true));
        // #521: CBR, not ns-3's default 1 s on / 1 s off duty (see Params::
        // offTime). Constant variables draw nothing, so the #352/#431 stream
        // layout is unchanged.
        onoff.SetAttribute("OnTime", StringValue("ns3::ConstantRandomVariable[Constant=1]"));
        {
            std::ostringstream off;
            off << "ns3::ConstantRandomVariable[Constant=" << P.offTime << ']';
            onoff.SetAttribute("OffTime", StringValue(off.str()));
        }
        const double startS = startVar->GetValue();
        dumped.push_back({src, dst, startS, P.simTime - 1.0, P.cbrBps});
        onoff.SetAttribute("StartTime", TimeValue(Seconds(startS)));
        onoff.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
        apps.Add(onoff.Install(nodes.Get(src)));

        // In converge mode every flow shares one sink node/port, so install its
        // PacketSink exactly once (a second bind on the same port would fail).
        if (!converge) {
            g_flowStart.push_back(startS);  // #23: index-aligned with `sinks`
            PacketSinkHelper sink("ns3::UdpSocketFactory",
                                  InetSocketAddress(Ipv4Address::GetAny(), port));
            sinks.Add(sink.Install(nodes.Get(dst)));
        }
    }
    if (converge && P.sink >= 0 && static_cast<uint32_t>(P.sink) < P.nNodes) {
        PacketSinkHelper sink(
            P.transport == "tcp" ? "ns3::TcpSocketFactory" : "ns3::UdpSocketFactory",
            InetSocketAddress(Ipv4Address::GetAny(), port));
        sinks.Add(sink.Install(nodes.Get(P.sink)));
    }
    sinks.Start(Seconds(0.0));
    // #639: --dumpFlows writes the generated flows once, in --flowsFile format.
    if (g_traceDump.active && !P.dumpFlows.empty() && P.flowList.empty()) {
        std::ofstream ff(P.dumpFlows);
        ff << std::setprecision(17)
           << "# src dst start stop cbrBps (anthocnet-compare --dumpFlows, #639)" << '\n';
        for (const Params::FlowSpec& f : dumped) {
            ff << f.src << ' ' << f.dst << ' ' << f.start << ' ' << f.stop << ' ' << f.bps << '\n';
        }
    }

    // #352: the OnOff sources' on/off variables. They are ConstantRandomVariable
    // in this harness (a CBR source is always on), so they consume streams
    // without drawing from them — pinned regardless, so an on/off duty cycle
    // added later cannot reintroduce the position dependence. PacketSink draws
    // nothing. AssignStreams is called on the applications rather than through
    // OnOffHelper::AssignStreams because the helper is per-flow and scoped to
    // the loop above.
    // #431: from the fixed application sub-block, like the start times above —
    // these too must be identical in every arm for the (flow, seq) identity to
    // name the same physical transmission.
    for (uint32_t i = 0; i < apps.GetN(); ++i) {
        Ptr<OnOffApplication> onoffApp = DynamicCast<OnOffApplication>(apps.Get(i));
        if (onoffApp) {
            appStream += onoffApp->AssignStreams(appStream);
            NS_ABORT_MSG_IF(appStream - streamBase >= kStreamStride,
                            "RNG stream budget exhausted assigning the onoff "
                            "applications: the application sub-block "
                            "(kStreamStride - kAppStreamOffset streams) is too "
                            "small for this flow count (#431).");
        }
    }

    // #212: reordering is a reported metric for every protocol and every run, so
    // this hook is unconditional — unlike the --diag hooks below. The sink's
    // plain "Rx" trace hands over the whole datagram, header included, so the
    // sequence number is read here rather than through PacketSink's own
    // EnableSeqTsSizeHeader path (that one runs a TCP-oriented reassembly buffer
    // we have no use for on UDP).
    // #63: NOT connected under TCP. RecordRxSeq reads a SeqTsSizeHeader off the
    // sink's "Rx" trace, which hands over whole datagrams on UDP but byte-stream
    // chunks on TCP — the parse would be garbage rather than absent, i.e. a
    // wrong number instead of no number. The reorder columns therefore read as
    // absent on a TCP cell, following the ##HOLD##/##AIR## rule.
    //
    // The irony is worth stating: TCP is the arm where reordering matters most
    // (it is what collapses the congestion window, and the reason #63 exists)
    // and it is the arm our reordering instrumentation cannot measure. Read the
    // mechanism from ##GOODPUT## against the UDP arm instead.
    if (P.transport != "tcp") {
        for (uint32_t i = 0; i < sinks.GetN(); ++i) {
            sinks.Get(i)->TraceConnectWithoutContext("Rx", MakeCallback(&RecordRxSeq));
        }
    }

    // Per-flow first-Rx for the #23 setup latency (default pairing only;
    // converge mode has one shared sink and no per-flow mapping). Connected on
    // every run since #294 item 4 made the latency a ##ROUTE## column rather
    // than a --diag extra; the hook is read-only.
    const bool perFlowSinks = !converge && sinks.GetN() == g_flowStart.size();
    g_flowFirstRx.assign(g_flowStart.size(), -1.0);
    g_flowRx.assign(g_flowStart.size(), 0);
    if (perFlowSinks) {
        for (uint32_t i = 0; i < sinks.GetN(); ++i) {
            sinks.Get(i)->TraceConnectWithoutContext("Rx", MakeBoundCallback(&DiagSinkRxFlow, i));
        }
    }

    if (g_diag) {
        // First-delivery timestamp from every data sink (all protocols). With
        // per-flow sinks DiagSinkRxFlow above already records it.
        if (!perFlowSinks) {
            for (uint32_t i = 0; i < sinks.GetN(); ++i) {
                sinks.Get(i)->TraceConnectWithoutContext("Rx", MakeCallback(&DiagSinkRx));
            }
        }
    }

    // Queue-depth sampler (#73): start after a 10% warm-up so convergence
    // transients don't dominate, sample every 0.5 s until the run ends.
    if (g_qdiag) {
        Simulator::Schedule(Seconds(P.simTime * 0.1), &SampleQueues, nodes, 0.5, P.simTime);
    }

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();
    // #641: the replay (--vizTrace), recorded by the arm that supports it
    // (AntHocNet's, on its first run of the process).
    bool vizThisRun = false;
    if (!P.vizTrace.empty()) {
        std::ostringstream h;
        h << "\"seed\":" << seed << ",\"area\":[" << P.areaX << ',' << P.areaY << ',' << P.areaZ
          << "],\"range\":" << P.range << ",\"mobility\":\"" << P.mobility
          << "\",\"propagation\":\"" << P.propagation << '"';
        if (P.mobility == "manhattan") {
            h << ",\"blocks\":[" << P.blocksX << ',' << P.blocksY
              << "],\"street\":" << P.streetWidth;
        }
        bench::ReplayRequest req;
        req.path = P.vizTrace;
        req.header = h.str();
        req.step = P.vizStep;
        req.dataPort = kDataPort;
        vizThisRun = arm->StartReplay(run, req, monitor, fmHelper.GetClassifier());
    }

    if (P.seriesEvery > 0.0) {
        Simulator::Schedule(Seconds(P.seriesEvery), &SampleSeries, P.seriesEvery, P.simTime);
    }

    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();
    if (g_traceDump.active) {
        // Close the legs still under way at the end of the run.
        for (uint32_t i = 0; i < g_traceDump.pos.size(); ++i) {
            const Vector v = g_traceDump.vel[i];
            const double dt = P.simTime - g_traceDump.t[i];
            TraceLeg(i, Vector(g_traceDump.pos[i].x + v.x * dt, g_traceDump.pos[i].y + v.y * dt,
                               g_traceDump.pos[i].z + v.z * dt));
        }
        std::ofstream tf(P.dumpTrace);
        tf << g_traceDump.out.str();
        g_traceDump.active = false;
        g_traceDump.done = true;
    }

    monitor->CheckForLostPackets();
    // #217: fold the window still open at Simulator::Stop() into the diversity
    // accumulators, or the last (up to) --pathWindowS seconds are dropped.
    FlushDiversityWindow();
    Result r;
    r.proto = proto;
    // #63: application-level goodput, summed over the PacketSinks. Measured
    // rather than derived, and independent of FlowMonitor — so on the UDP arm
    // it should track throughputKbps closely, and that agreement is a free
    // cross-check on the new metric. On TCP the two diverge by exactly the
    // retransmitted bytes.
    {
        uint64_t rxBytes = 0;
        for (uint32_t i = 0; i < sinks.GetN(); ++i) {
            Ptr<PacketSink> ps = DynamicCast<PacketSink>(sinks.Get(i));
            if (ps) rxBytes += ps->GetTotalRx();
        }
        r.rxAppBytes = rxBytes;
        r.goodputKbps =
            P.simTime > 0.0 ? 8.0 * static_cast<double>(rxBytes) / P.simTime / 1000.0 : 0.0;
    }
    double totalDelay = 0.0;
    uint64_t rxForDelay = 0;
    double totalRxBytes = 0.0;
    double totalJitter = 0.0;                // #57: FlowMonitor jitterSum over data flows
    uint64_t jitterSamples = 0;              // each flow contributes rx-1 jitter samples
    std::map<uint32_t, uint64_t> delayBins;  // aggregated delay histogram
    double binWidth = 0.0;
    // #215: IP-layer drop attribution, restricted to the data flows exactly the
    // way PDR is. FlowMonitor indexes FlowStats::packetsDropped by
    // Ipv4FlowProbe::DropReason and grows the vector lazily, so every read is
    // bounds-checked.
    uint64_t dropRoute = 0, dropTtl = 0, dropQueue = 0, dropL3Total = 0;
    // #217: per-flow delivered-packet counts, for Jain's fairness index.
    std::vector<double> flowRx;
    // Restrict the delivery/delay/throughput metrics to the CBR *data* flows
    // (dest port kDataPort). FlowMonitor also classifies the routing-control
    // flows, which must not count toward PDR.
    Ptr<Ipv4FlowClassifier> classifier = DynamicCast<Ipv4FlowClassifier>(fmHelper.GetClassifier());
    for (auto& kv : monitor->GetFlowStats()) {
        Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow(kv.first);
        if (t.destinationPort != kDataPort) continue;  // data flows only
        r.txPackets += kv.second.txPackets;
        r.rxPackets += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        rxForDelay += kv.second.rxPackets;
        totalRxBytes += kv.second.rxBytes;
        totalJitter += kv.second.jitterSum.GetSeconds();
        if (kv.second.rxPackets > 0) jitterSamples += kv.second.rxPackets - 1;
        // #217: one entry per data flow that offered at least one packet.
        if (kv.second.txPackets > 0) {
            flowRx.push_back(static_cast<double>(kv.second.rxPackets));
        }
        // Copy: Histogram's accessors are non-const in older ns-3 (<=3.36).
        Histogram h = kv.second.delayHistogram;
        for (uint32_t b = 0; b < h.GetNBins(); ++b) {
            if (binWidth == 0.0) binWidth = h.GetBinWidth(b);
            delayBins[b] += h.GetBinCount(b);
        }
        // #215 drop attribution for this data flow.
        const std::vector<uint32_t>& pd = kv.second.packetsDropped;
        auto reason = [&pd](std::size_t i) -> uint64_t { return i < pd.size() ? pd[i] : 0u; };
        dropRoute += reason(Ipv4FlowProbe::DROP_NO_ROUTE) + reason(Ipv4FlowProbe::DROP_ROUTE_ERROR);
        dropTtl += reason(Ipv4FlowProbe::DROP_TTL_EXPIRE);
        dropQueue += reason(Ipv4FlowProbe::DROP_QUEUE) + reason(Ipv4FlowProbe::DROP_QUEUE_DISC);
        for (uint32_t v : pd) dropL3Total += v;
    }
    // #464/#510: an arm whose protocol refuses a locally originated send
    // outright (the oracle when its graph holds no path, OLSR without a table
    // entry) puts the refusals back: RouteOutput returns nullptr, the socket
    // send fails and FlowMonitor never counts the packet as transmitted, so
    // without this PDR is computed over "the packets the arm had a route for"
    // rather than over offered traffic. A refused send is an offered packet
    // lost for want of a route: it belongs in the denominator and in the
    // route column. AntHocNet, AODV, AOMDV and DSDV defer an unroutable send
    // (loopback or pending queue) instead, so FlowMonitor already counts it
    // -- measured, their delivered-bytes share of offered traffic matches
    // their PDR to 0.05 pp in every committed cell (#510).
    {
        bench::RunCounts counts;
        counts.txPackets = r.txPackets;
        counts.dropRoute = dropRoute;
        arm->AdjustCounts(run, counts);
        r.txPackets = counts.txPackets;
        dropRoute = counts.dropRoute;
    }
    r.pdr = r.txPackets ? 100.0 * r.rxPackets / r.txPackets : 0.0;
    if (vizThisRun) arm->FinishReplay(r.txPackets, r.rxPackets, r.pdr);
    r.meanDelayMs = rxForDelay ? 1000.0 * totalDelay / rxForDelay : 0.0;
    r.throughputKbps = (totalRxBytes * 8.0 / 1000.0) / P.simTime;
    r.nrl = r.rxPackets ? static_cast<double>(g_controlPkts) / r.rxPackets : 0.0;
    // #132: same IP-layer counting point as nrl, but in bytes; delivered data
    // bytes are the FlowMonitor rxBytes already summed for throughput.
    r.nrlBytes = totalRxBytes > 0.0 ? static_cast<double>(g_controlBytes) / totalRxBytes : 0.0;
    // #708: a per-run note of the arm's (hwmp: the mesh's link maintenance,
    // which NRL does not count, so a reader can see its size beside the path
    // selection).
    arm->EmitRunNote(run, measurement, std::cout);
    // #62: the --seriesEvery samples, one line each, cumulative counts.
    for (const SeriesSample& s : g_series) {
        std::cout << "# series " << proto << " seed=" << seed << " t=" << s.t << " ctrl=" << s.ctrl
                  << " ant=" << s.ant[0] << ',' << s.ant[1] << ',' << s.ant[2] << ',' << s.ant[3]
                  << ',' << s.ant[4] << " rx=";
        for (std::size_t i = 0; i < s.rx.size(); ++i) std::cout << (i ? "," : "") << s.rx[i];
        std::cout << '\n';
    }

    r.jitterMs = jitterSamples ? 1000.0 * totalJitter / jitterSamples : 0.0;

    // #89: the thesis's eq 5.1, computed from arrival times per flow.
    //
    // The thesis writes eq 5.1 as a bare *sum* over a session, even though every
    // figure caption calls it "average delay jitter". A sum is unusable here: it
    // scales with the number of packets delivered, so the protocol that delivers
    // less scores *better* purely arithmetically — the survivorship trap #57
    // already had to design around. So it is normalised, and the normaliser is
    // recorded rather than assumed: each flow of n arrivals contributes n-2
    // terms, because the sum's first well-defined index is i=3 (the thesis
    // writes i=2 but references t_{i-2}, an off-by-one in the source).
    {
        double sumEq51 = 0.0;
        uint64_t termsEq51 = 0;
        for (auto& kv : g_rxArrival) {
            const std::vector<double>& t = kv.second;  // arrival order
            if (t.size() < 3) continue;                // no term is defined
            for (std::size_t i = 2; i < t.size(); ++i) {
                sumEq51 += std::fabs((t[i] - t[i - 1]) - (t[i - 1] - t[i - 2]));
            }
            termsEq51 += t.size() - 2;
        }
        r.jitterEq51Ms = termsEq51 ? 1000.0 * sumEq51 / termsEq51 : 0.0;
    }

    // 99th-percentile delay from the aggregated histogram.
    if (rxForDelay && binWidth > 0.0) {
        uint64_t target = static_cast<uint64_t>(0.99 * rxForDelay);
        uint64_t cum = 0;
        for (auto& kv : delayBins) {
            cum += kv.second;
            if (cum >= target) {
                r.delay99Ms = 1000.0 * (kv.first + 0.5) * binWidth;
                break;
            }
        }
    }
    // #308: keep the histogram for the matched-delivery percentile, and the
    // per-packet delays for the common-set comparison — both need every
    // protocol's data, so they are computed after the whole grid exists.
    r.delayHist = delayBins;
    r.delayBinWidth = binWidth;
    r.rxDelayBySeq = g_rxDelayBySeq;
    r.rxHopsBySeq = g_rxHopsBySeq;

    // #57 offered-load delay percentiles: the q-th percentile over *sent*
    // packets, treating undelivered as infinite delay. Monotone-honest — a
    // protocol cannot improve this by dropping the hard packets (the
    // survivorship confound in cross-protocol delay99, see #21/#54). The
    // histogram holds only delivered packets, but undelivered sort above every
    // delivered delay, so the q·tx-th smallest overall is reachable iff
    // q·tx <= delivered; otherwise the percentile is infinite (-1).
    if (r.txPackets && binWidth > 0.0) {
        auto offered = [&](double q) {
            uint64_t target = static_cast<uint64_t>(q * r.txPackets);
            if (target < 1) target = 1;
            uint64_t cum = 0;
            for (auto& kv : delayBins) {
                cum += kv.second;
                if (cum >= target) return 1000.0 * (kv.first + 0.5) * binWidth;
            }
            return -1.0;  // fewer than q of the sent packets ever arrived
        };
        r.dOff50Ms = offered(0.50);
        r.dOff90Ms = offered(0.90);
    }

    // #209 energy: read out of the g_energyConsumedJ integration (see the
    // OnPhyState block for the method and its one-open-state undercount).
    // energyOn=false leaves every entry 0, so the columns read 0/-1 exactly as
    // the --energyJ=0 ablation documented in #270.
    {
        std::vector<double> residual;
        residual.reserve(g_energyConsumedJ.size());
        double consumed = 0.0;
        if (energyOn) {
            for (double c : g_energyConsumedJ) {
                consumed += c;
                residual.push_back(P.energyJ - c);
            }
        }
        r.energyJ = consumed;
        // #308 phase 2 step 3: the occupancy totals are only meaningful when the
        // PHY "State" trace is connected, which is the same condition the energy
        // accounting uses — --energyJ=0 turns both off (#270). The -1 default
        // survives in that case so no ##AIR## row is printed at all, rather than
        // an all-zero one that would read as "the medium was never busy".
        if (energyOn) {
            r.airTxS = g_airTxS;
            r.airRxS = g_airRxS;
            r.airCcaS = g_airCcaS;
        }
        // Efficiency figure: joules spent per data packet actually delivered.
        // Comparable across protocols sitting at different PDRs, which total
        // joules alone is not (every node's radio is on for the same wall time
        // whatever the protocol does). 0 when nothing was delivered, matching
        // how nrl handles the same case.
        r.energyPerPktJ = r.rxPackets ? consumed / static_cast<double>(r.rxPackets) : 0.0;
        // #294 item 3: the same figure per delivered application *bit*, the
        // literature's cross-protocol energy column. Packet sizes are fixed
        // under CBR, so on UDP this is energyPerPktJ / (8 x payload); it is
        // measured from the sinks rather than derived so a TCP cell, whose
        // segments are not one size, reads correctly too.
        r.energyPerBitJ = r.rxAppBytes ? consumed / (8.0 * static_cast<double>(r.rxAppBytes)) : 0.0;
        if (!residual.empty()) {
            double sum = 0.0, sumSq = 0.0;
            r.resMinJ = residual[0];
            for (double v : residual) {
                sum += v;
                sumSq += v * v;
                if (v < r.resMinJ) r.resMinJ = v;
            }
            const double n = static_cast<double>(residual.size());
            r.resMeanJ = sum / n;
            if (residual.size() > 1) {
                const double var = (sumSq - n * r.resMeanJ * r.resMeanJ) / (n - 1.0);
                r.resSdJ = var > 0.0 ? std::sqrt(var) : 0.0;
            }
        }
        r.firstDeathS = g_firstDeathS;
    }

    // --- packet reordering (#212) --------------------------------------------
    // Computed per flow first and only then aggregated: a single badly-spread
    // flow is the interesting case, and a packet-weighted aggregate alone would
    // hide it — hence reorderRatioMax (the worst flow) alongside the pooled
    // ratio. Definitions (stated in full in docs/benchmarks/metrics.md because
    // "reordering" has several non-equivalent definitions in the literature):
    //
    //  - **Out-of-order (reordered) ratio** — RFC 4737's `Type-P-Reordered`
    //    singleton: keep NextExp = (largest sequence number seen so far) + 1;
    //    an arriving packet with sequence number s is reordered iff s < NextExp,
    //    and NextExp advances to s+1 only when it is not. Losses do not count as
    //    reordering: a gap merely makes NextExp jump.
    //  - **Reordering extent** — RFC 4737's `Type-P-Packet-Reordering-Extent`:
    //    for a reordered packet received at position i, the number of positions
    //    back to the *earliest* packet received with a larger sequence number,
    //    i.e. i - min{ j < i : seq[j] > s }. RFC 4737 notes this
    //    position-distance form tends to *overestimate* the receiver storage
    //    actually needed, which is exactly why the buffer-occupancy figure below
    //    is carried alongside it.
    //  - **Reorder-buffer occupancy** — the largest number of packets a receiver
    //    would have to hold at once to hand the *delivered* packets up in
    //    sequence order. Defined over the packets that actually arrived, so a
    //    lost packet does not stall the buffer forever (a naive "wait for the
    //    next sequence number" buffer would measure loss, not reordering, at
    //    this harness's PDRs).
    //
    // Prefix maxima make both the reordered test and the extent search cheap:
    // pref[i] = max(seq[0..i]) is non-decreasing, so s is reordered iff
    // s <= pref[i-1], and the earliest arrival with a larger sequence number is
    // the first index at which pref exceeds s (binary search).
    {
        uint64_t rxSeqTotal = 0, reorderedTotal = 0;
        uint64_t extSum = 0, extCount = 0, extMax = 0, bufMax = 0;
        double ratioMaxFlow = 0.0;
        for (auto& kv : g_rxSeq) {
            const std::vector<uint32_t>& arr = kv.second;  // arrival order
            if (arr.empty()) continue;
            std::vector<uint32_t> pref(arr.size());
            uint32_t m = arr[0];
            for (std::size_t i = 0; i < arr.size(); ++i) {
                if (arr[i] > m) m = arr[i];
                pref[i] = m;
            }
            uint64_t reordered = 0;
            for (std::size_t i = 1; i < arr.size(); ++i) {
                if (arr[i] > pref[i - 1]) continue;  // in order (s >= NextExp)
                ++reordered;
                const std::size_t j = static_cast<std::size_t>(
                    std::upper_bound(pref.begin(), pref.begin() + i, arr[i]) - pref.begin());
                const uint64_t ext = i - j;  // >= 1 for any reordered packet
                extSum += ext;
                ++extCount;
                if (ext > extMax) extMax = ext;
            }
            // Reorder-buffer occupancy: walk the arrivals, release the prefix of
            // the sorted (in-sequence) delivery order that has become complete,
            // and record the high-water mark of what is still held.
            std::vector<uint32_t> ordered(arr);
            std::sort(ordered.begin(), ordered.end());
            std::vector<char> arrived(ordered.size(), 0);
            std::size_t k = 0;
            uint64_t occ = 0, occMax = 0;
            for (uint32_t s : arr) {
                arrived[static_cast<std::size_t>(
                    std::lower_bound(ordered.begin(), ordered.end(), s) - ordered.begin())] = 1;
                ++occ;
                while (k < ordered.size() && arrived[k]) {
                    --occ;
                    ++k;
                }
                if (occ > occMax) occMax = occ;
            }
            rxSeqTotal += arr.size();
            reorderedTotal += reordered;
            const double ratio = static_cast<double>(reordered) / arr.size();
            if (ratio > ratioMaxFlow) ratioMaxFlow = ratio;
            if (occMax > bufMax) bufMax = occMax;
        }
        r.reorderRatio = rxSeqTotal ? static_cast<double>(reorderedTotal) / rxSeqTotal : 0.0;
        r.reorderRatioMax = ratioMaxFlow;
        r.reorderExtMean = extCount ? static_cast<double>(extSum) / extCount : 0.0;
        r.reorderExtMax = static_cast<double>(extMax);
        r.reorderBufMax = static_cast<double>(bufMax);
    }

    // #215 drop-cause breakdown, as a fraction of offered packets.
    //
    // The identity this is built to satisfy, and which scenario_check.py
    // enforces, follows from packet conservation at the IP layer. Over all
    // nodes and all data packets:
    //
    //   offered + hopRx + reinjected = hopTx + delivered + L3drops + stillQueued
    //
    // (a node's data packets come in from the app or from a device — or back
    // from the MAC-failure re-injection path — and leave to a device, to the
    // local transport, or into a drop). With
    //   hopTx - hopRx = macDrops + queueDrops + channel      [definition of channel]
    //   macTerminal   = macDrops - reinjected                [the rest came back]
    // it rearranges to
    //   offered - delivered = L3drops + macTerminal + queueDrops + channel + stillQueued
    // i.e. pdr + route + ttl + queue + mac + channel = 100, up to the packets
    // still sitting in a pending queue when the run stops. Nothing here is
    // forced to add up: the L3 causes come from FlowMonitor, the hop tallies
    // from the Ipv4L3Protocol traces and the MAC verdicts from the WifiMac
    // trace, so a shortfall means one of those three books is wrong — which is
    // precisely the harness regression the check is there to catch.
    if (r.txPackets) {
        const double tx = static_cast<double>(r.txPackets);
        // AntHocNet-only causes: the pending queue and the local-repair discard
        // exist in no other arm, so they stay at the -1 "not applicable"
        // sentinel there rather than reporting a misleading 0.
        uint64_t reinjected = 0;
        // ADR-0027: the arm reports what its protocol can measure. AntHocNet
        // has a pending queue and a local-repair discard (its own causes) and
        // counts its own MAC re-injections; the adaptive arms (#563) report
        // theirs through the measurement's sinks, the data ones (IsDataIp,
        // the same predicate as g_macDataDrops) netted out of the mac column.
        bench::DropDetail detail;
        arm->FillDropDetail(run, detail);
        if (detail.holdCauses) {
            r.dropSetupPct = 100.0 * detail.holdSetup / tx;
            r.dropReconvPct = 100.0 * detail.holdReconv / tx;
            r.dropRepairPct = 100.0 * detail.repairPkts / tx;
        }
        reinjected = detail.ownReinjected ? detail.reinjected : measurement.ReinjectedData();
        // Every one of these three ends in an error callback, so together they
        // are a *sub-breakdown* of dropRoutePct, not extra causes on top of it;
        // adding them to the identity would double-count.
        const uint64_t macTerminal = g_macDataDrops > reinjected ? g_macDataDrops - reinjected : 0;
        // #402: capped-skip aggregates, in BOTH units. The ##REINJ## fields
        // partition distinct skipped keys (parallel to the pkts partition);
        // the mac attribution below needs EVENTS, because g_macDataDrops
        // counts frame-drop events and each skip event is exactly one MAC
        // drop the cap left terminal — a key can be skipped more than once
        // (the ReinjCountTag budget is per packet COPY, so duplicated copies
        // each carry their own; events > pkts measured under cap=1), and
        // each of those frames sits in g_macDataDrops individually.
        // skipsDelivEvents is therefore "skips − skipsNever" evaluated in
        // event units: skip events on keys delivered at ANY point (before
        // the first skip or by end of run). Empty map on every uncapped arm
        // (the adapter trace only fires under MaxReinjectPerPacket != 0), so
        // all of this is an arithmetic no-op there.
        uint64_t skipsPkts = 0, skipsDelivBefore = 0, skipsDelivAfterOnly = 0, skipsNever = 0,
                 skipsDelivEvents = 0;
        for (const auto& kv : g_reinjSkip) {
            ++skipsPkts;
            uint32_t endCount = 0;
            const auto f = g_rxCount.find(kv.first.first);
            if (f != g_rxCount.end()) {
                const auto s = f->second.find(kv.first.second);
                if (s != f->second.end()) endCount = s->second;
            }
            if (kv.second.rxAtFirstSkip >= 1)
                ++skipsDelivBefore;
            else if (endCount >= 1)
                ++skipsDelivAfterOnly;
            else
                ++skipsNever;
            if (kv.second.rxAtFirstSkip >= 1 || endCount >= 1) skipsDelivEvents += kv.second.events;
        }
        const double hopLoss = static_cast<double>(g_dataHopTx) - static_cast<double>(g_dataHopRx);
        // #377: a retry-limit drop is not necessarily a lost packet. 802.11
        // unicast is data then ACK, two independent chances to fail, and under
        // fading the data frame can arrive while its ACK does not: the peer
        // has the packet (so it is NOT in hopLoss) while the sender exhausts
        // its retries (so it IS in g_macDataDrops). Subtracting the raw count
        // from hopLoss therefore removes packets that were never in it, and
        // the residual runs negative — measured at -13.10 % on a Nakagami cell
        // (run 31288485211) against +1.88 % on the matched two-ray control.
        //
        // macLost is the genuinely-lost subset. It is a subset of hopLoss by
        // construction — a frame that hit the retry limit and did not arrive
        // is, definitionally, a hop that was sent and not received — so the
        // residual below cannot go negative for the reason #377 reports.
        // Verified against both probe cells: the identity closes to 99.87 /
        // 100.00 / 100.22 for the three baselines and is a near no-op on
        // two-ray, where unackedRx is 0-13 packets per run.
        const uint64_t unackedRx =
            g_dataHopRx > g_ackedDataHops ? g_dataHopRx - g_ackedDataHops : 0;
        const uint64_t macLost = g_macDataDrops > unackedRx ? g_macDataDrops - unackedRx : 0;
        // #229: the pending-queue conservation counters (dsdv/aodv arms; zero
        // everywhere else, making the two assignments below arithmetically
        // identical to their pre-#229 form on the anthocnet/olsr arms).
        //   pqSilent — keys deferred into the protocol queue and never seen
        //              again: dsdv's silent sheds plus, for both protocols,
        //              packets still queued at teardown. In no FlowMonitor
        //              bucket and never in hopLoss (they never crossed a real
        //              interface), so they ADD to the queue column and must
        //              NOT join the raw dropQueue that the chan residual and
        //              overlap diagnostic carve out of hopLoss below.
        //   pqEcb   — aodv queue drops that fired the entry's error callback;
        //              FlowMonitor already counted them under
        //              DROP_ROUTE_ERROR, so they MOVE from the route column
        //              to the queue column (sum unchanged). The raw dropRoute
        //              stays untouched for the `other` diagnostic.
        const uint64_t pqSilent = g_pqPending.size();
        const uint64_t pqEcb = g_pqEcbDrops;
        r.dropRoutePct = 100.0 * (dropRoute > pqEcb ? dropRoute - pqEcb : 0) / tx;
        r.dropTtlPct = 100.0 * dropTtl / tx;
        r.dropQueuePct = 100.0 * (dropQueue + pqSilent + pqEcb) / tx;
        // The correction applies to dropMacPct only where that column is
        // macDrops-based, i.e. where nothing was re-injected. AntHocNet's is
        // already macTerminal — #46 has removed the re-injected packets from
        // it — and subtracting unackedRx again would correct it twice. Its
        // arm keeps the hop-vs-terminal residue tracked on #386; the three
        // baselines never re-inject, so macTerminal == g_macDataDrops there
        // and macLost is the right replacement.
        //
        // #402: under a MaxReinjectPerPacket cap, macTerminal alone
        // double-counts. A packet can accumulate re-injections (inflating the
        // per-hop books) and THEN hit the cap, so its final MAC drop is
        // terminal and lands in macTerminal — while the same packet's earlier
        // hop inflation is still in hopLoss, and in ~3/4 of skip events the
        // packet was in fact delivered (the #377 delivered-but-ACK-lost
        // class). The uncapped #388 derivation never saw that combination and
        // measured +8.50 pp of residue on the cap=1 probe cell. Cap-aware
        // numerator: subtract the skip events whose key was delivered —
        // macDrops − reinjected − (skips − skipsNever) in event units — so
        // only never-delivered capped drops count as terminal MAC loss;
        // delivered-packet skips move into the documented #377-class
        // straddle. skipsDelivEvents == 0 on every uncapped arm, so the
        // attribution there is arithmetically identical to pre-#402. The
        // ##DROPID## macTerminal field stays the RAW macDrops − reinjected.
        const uint64_t macTerminalCapAware =
            macTerminal > skipsDelivEvents ? macTerminal - skipsDelivEvents : 0;
        r.dropMacPct = 100.0 * (reinjected ? macTerminalCapAware : macLost) / tx;
        // v2.5.0 (#563): an adaptive arm's ARP re-injections never reached the
        // medium; they leave the channel residual (0 on every other arm).
        r.dropChanPct = 100.0 *
                        (hopLoss - static_cast<double>(macLost) - static_cast<double>(dropQueue) -
                         static_cast<double>(g_adaptiveArpReinjData)) /
                        tx;
        // L3 drops in none of the buckets above (bad checksum, interface down,
        // fragment timeout — all structurally zero in this harness). Diagnostic
        // only: if it is ever non-zero it is the reason the identity misses.
        const uint64_t other = dropL3Total > dropRoute + dropTtl + dropQueue
                                   ? dropL3Total - dropRoute - dropTtl - dropQueue
                                   : 0;
        r.dropOtherPct = 100.0 * other / tx;
        // #377: the raw counters behind the residual above, so the attribution
        // can be audited in counts rather than in percentages.
        //
        //   overlap    = macLost + queue - hopLoss
        //                the amount by which the subtracted causes exceed the
        //                pool they are carved from. Exactly -dropChanPct*tx/100,
        //                so it MUST track whatever that residual subtracts --
        //                it has been wrong twice for failing to. It read
        //                macTerminal first (24x off on the AntHocNet arm, whose
        //                #46 detector re-injects nearly every MAC failure), then
        //                the raw macDrops; both are superseded now that the
        //                residual carves out only the genuinely-lost subset.
        //
        //                With macLost a subset of hopLoss by construction, this
        //                can no longer go positive for the #377 reason. The gate
        //                on it is kept precisely so that if it ever does, the
        //                books have overlapped for some *other* reason and that
        //                is worth hearing about.
        //
        //   unackedRx  = hopRx - ackedHops
        //                frames that reached the next hop's IP layer without the
        //                sender ever recording an ACK -- the delivered-but-ACK-
        //                lost case the correction above removes. Kept in the
        //                line because it is the quantity that explains the
        //                correction's size, and because #386 reads it against
        //                `reinjected` to bound how many re-injections are of
        //                packets that had already arrived (>=58.8% per run on
        //                a Nakagami cell).
        //
        // Measured, both probe cells at 900 s: unackedRx is 1028-1719 per run
        // under Nakagami and 0.2-8.8 under two-ray, three orders of magnitude
        // apart on cells differing only in the fading model.
        //
        // Signed integers, not doubles: every field is a difference of exact
        // counters, and printing them through the shared std::cout would
        // otherwise need a precision change that leaks into every line after
        // it.
        const int64_t hopLossN =
            static_cast<int64_t>(g_dataHopTx) - static_cast<int64_t>(g_dataHopRx);
        int64_t overlap = static_cast<int64_t>(macLost) + static_cast<int64_t>(dropQueue) +
                          static_cast<int64_t>(g_adaptiveArpReinjData) - hopLossN;
        // #761: on the adaptive arms the event books above count a re-routed
        // packet once per lost hop, so mac/chan/route/ttl are replaced by the
        // per-packet terminal fates (see the FateInfo block). Partition of the
        // offered packets:
        //   delivered (distinct keys at the sink) + termMac + termRoute +
        //   termTtl + termOther + termTx + termAtNode + unseen = offered
        // termTx is the channel pool (last seen on the medium); the interface /
        // qdisc queue drops FlowMonitor reports also last saw the medium, so
        // they are carved out of it exactly as from hopLoss, and overlap stays
        // -chan in counts. termAtNode (sat at a node, never seen again: still
        // queued at the end, or shed without an L3 error callback) is
        // attributed to no cause — it is the identity's shortfall, never folded
        // into a column. unseen (offered by FlowMonitor, never seen by any hook)
        // is 0 when the books agree; negative means a packet was booked twice
        // (scenario_check FAILs that).
        uint64_t fDelivered = 0, fMac = 0, fRoute = 0, fTtl = 0, fOther = 0, fTx = 0, fAtNode = 0,
                 fRecoveredPkts = 0;
        int64_t fUnseen = 0;
        if (g_fateOn) {
            for (const auto& kv : g_rxCount) fDelivered += kv.second.size();
            for (const auto& kv : g_fate) {
                if (kv.second.recovered) ++fRecoveredPkts;
                const auto f = g_rxCount.find(kv.first.first);
                if (f != g_rxCount.end() && f->second.count(kv.first.second)) continue;
                switch (kv.second.last) {
                    case Fate::Mac:
                        ++fMac;
                        break;
                    case Fate::Route:
                        ++fRoute;
                        break;
                    case Fate::Ttl:
                        ++fTtl;
                        break;
                    case Fate::Other:
                        ++fOther;
                        break;
                    case Fate::Tx:
                        ++fTx;
                        break;
                    case Fate::AtNode:
                        ++fAtNode;
                        break;
                }
            }
            fUnseen = static_cast<int64_t>(r.txPackets) - static_cast<int64_t>(fDelivered) -
                      static_cast<int64_t>(fMac + fRoute + fTtl + fOther + fTx + fAtNode);
            const int64_t chanN = static_cast<int64_t>(fTx) - static_cast<int64_t>(dropQueue);
            overlap = -chanN;
            r.dropMacPct = 100.0 * fMac / tx;
            r.dropRoutePct = 100.0 * fRoute / tx;
            r.dropTtlPct = 100.0 * fTtl / tx;
            r.dropChanPct = 100.0 * static_cast<double>(chanN) / tx;
        }
        // Not emitted under TCP. Since #389 the counters above DO count TCP
        // data segments, but the drop-cause identity itself is unvalidated
        // under TCP — it was closed on per-packet UDP books, and TCP counts
        // segments and retransmits them, so the arithmetic has not been shown
        // to close there. The emission stays suppressed until it is (#389
        // follow-up); same rule as ##HOLD##/##AIR## and #382 — an unvalidated
        // line would read as clean books, so absence is the encoding.
        if (P.transport != "tcp") {
            std::cout << "##DROPID## " << seed << ' ' << proto << " hopTx=" << g_dataHopTx
                      << " hopRx=" << g_dataHopRx << " ackedHops=" << g_ackedDataHops
                      << " macDrops=" << g_macDataDrops << " reinjected=" << reinjected
                      << " macTerminal=" << macTerminal << " macLost=" << macLost
                      << " queue=" << dropQueue << " hopLoss=" << hopLossN << " overlap=" << overlap
                      << " unackedRx=" << unackedRx;
            // #229: the pending-queue conservation counters, appended at the
            // END and only on the arms whose hook is connected — on the other
            // arms the quantity is unmeasured, and per the #382 rule absence
            // must stay distinguishable from a measured zero.
            if (measurement.pendingQueue) {
                std::cout << " pqSilent=" << pqSilent << " pqEcb=" << pqEcb;
            }
            // #761: the per-packet terminal-fate partition, appended at the END
            // and only on the adaptive arms (absence elsewhere, #382 rule).
            // recovered/recoveredPkts are the losses a re-injection undid, in
            // events and in distinct packets — never a drop cause.
            if (g_fateOn) {
                std::cout << " recovered=" << g_fateRecovered << " recoveredPkts=" << fRecoveredPkts
                          << " delivered=" << fDelivered << " termMac=" << fMac
                          << " termRoute=" << fRoute << " termTtl=" << fTtl
                          << " termOther=" << fOther << " termTx=" << fTx
                          << " termAtNode=" << fAtNode << " unseen=" << fUnseen;
            }
            std::cout << '\n';
        }

        // #386: the direct re-injection counter behind the >=59% inclusion-
        // exclusion floor above (unackedRx vs reinjected), plus what re-injected
        // packets then DO. Event view: `events` MUST equal `reinjected` (the
        // trace fires at the same site that increments the adapter counter —
        // scenario_check FAILs a mismatch); parsed + unparsedIcmp +
        // unparsedOther must equal `events` (the books close; the unparsed
        // counts are the probe's non-data-re-injection finding, WARNed not
        // FAILed); `ofDelivered` counts re-injections of packets already at the
        // destination AT RE-INJECTION TIME (the floor's direct counterpart).
        // Packet view (distinct keys): pktsDelivBefore (delivered before first
        // re-injection) / pktsDelivAfterOnly (delivered late, only after) /
        // pktsNever (dropped) partition `pkts`; pktsDupDeliv/dupRx count sink
        // duplicates; postTx/postRx are the hops re-injected packets traversed
        // afterwards (attempts / arrivals — the wasted-work number). The
        // l3Drop* tail is the isolated cuttable drop-cause stage. The #402
        // skips* tail after it: capped-skip events (skips), distinct skipped
        // keys (skipsPkts) and their fate partition (skipsDelivBefore +
        // skipsDelivAfterOnly + skipsNever == skipsPkts, same rule as the
        // pkts partition) — all zero on uncapped arms, where the adapter's
        // MacReinjectSkip trace structurally never fires.
        //
        // Emitted for anthocnet+UDP only — baselines and TCP stay ABSENT (no
        // detector / no SeqTs identity; #382 absence rule). A detector-off
        // anthocnet arm still emits, all fields measured zeros, so the
        // EnableMacFailureDetector=false control is a number, not an absence.
        if (measurement.reinjIdentity) {
            uint64_t pkts = 0, delivBefore = 0, delivAfterOnly = 0, never = 0;
            uint64_t dupDeliv = 0, dupRx = 0, postTx = 0, postRx = 0;
            uint64_t l3Route = 0, l3Ttl = 0, l3Other = 0;
            for (const auto& kv : g_reinj) {
                ++pkts;
                uint32_t endCount = 0;
                const auto f = g_rxCount.find(kv.first.first);
                if (f != g_rxCount.end()) {
                    const auto s = f->second.find(kv.first.second);
                    if (s != f->second.end()) endCount = s->second;
                }
                if (kv.second.rxAtFirstReinj >= 1)
                    ++delivBefore;
                else if (endCount >= 1)
                    ++delivAfterOnly;
                else
                    ++never;
                if (endCount >= 2) {
                    ++dupDeliv;
                    dupRx += endCount - 1;
                }
                postTx += kv.second.postTx;
                postRx += kv.second.postRx;
                l3Route += kv.second.l3DropRoute;
                l3Ttl += kv.second.l3DropTtl;
                l3Other += kv.second.l3DropOther;
            }
            std::cout << "##REINJ## " << seed << ' ' << proto << " events=" << g_reinjEvents
                      << " parsed=" << g_reinjParsed << " unparsedIcmp=" << g_reinjUnparsedIcmp
                      << " unparsedOther=" << g_reinjUnparsedOther
                      << " ofDelivered=" << g_reinjOfDelivered << " pkts=" << pkts
                      << " pktsDelivBefore=" << delivBefore
                      << " pktsDelivAfterOnly=" << delivAfterOnly << " pktsNever=" << never
                      << " pktsDupDeliv=" << dupDeliv << " dupRx=" << dupRx << " postTx=" << postTx
                      << " postRx=" << postRx << " l3DropRoute=" << l3Route
                      << " l3DropTtl=" << l3Ttl << " l3DropOther=" << l3Other
                      << " skips=" << g_reinjSkips << " skipsPkts=" << skipsPkts
                      << " skipsDelivBefore=" << skipsDelivBefore
                      << " skipsDelivAfterOnly=" << skipsDelivAfterOnly
                      << " skipsNever=" << skipsNever << '\n';
        }
    }

    // #217 route quality.
    r.hopsMean = g_hopCount ? static_cast<double>(g_hopSum) / static_cast<double>(g_hopCount) : 0.0;
    r.hopsMax = static_cast<double>(g_hopMax);
    r.divUsed = g_divCells ? g_divSum / static_cast<double>(g_divCells) : 0.0;
    r.divEntropyBits = g_divCells ? g_divEntSum / static_cast<double>(g_divCells) : 0.0;
    r.divMax = static_cast<double>(g_divMax);

    // #294 item 4 route stability (definitions in docs/benchmarks/metrics.md).
    if (g_routeOn) {
        std::vector<double> setup;
        for (std::size_t i = 0; i < g_flowFirstRx.size(); ++i) {
            if (g_flowFirstRx[i] < 0.0) {
                ++r.flowsNoDelivery;
                continue;
            }
            setup.push_back(g_flowFirstRx[i] - g_flowStart[i]);
        }
        if (!setup.empty()) {
            std::sort(setup.begin(), setup.end());
            r.setupMedS = setup[setup.size() / 2];
            r.setupMaxS = setup.back();
        }
        // Per flow, in sequence order: a change is a consecutive pair of
        // delivered packets on different paths. A run is a maximal stretch on
        // one path; its lifetime is the send-time span from its first packet to
        // the first packet of the next run. A flow's last run is censored by
        // the end of the flow and is not counted.
        uint64_t pairs = 0, changes = 0, delivered = 0;
        std::vector<double> life;
        for (const auto& [flow, bySeq] : g_routeRx) {
            const RouteRx* prev = nullptr;
            double runStart = 0.0;
            for (const auto& [seq, rx] : bySeq) {
                ++delivered;
                if (prev == nullptr) {
                    runStart = rx.sendS;
                } else {
                    ++pairs;
                    if (rx.pathId != prev->pathId) {
                        ++changes;
                        life.push_back(rx.sendS - runStart);
                        runStart = rx.sendS;
                    }
                }
                prev = &rx;
            }
        }
        r.pathChg = pairs ? static_cast<double>(changes) / pairs : 0.0;
        r.pathLifeN = life.size();
        if (!life.empty()) {
            std::sort(life.begin(), life.end());
            r.pathLifeMedS = life[life.size() / 2];
        }
        r.pathHopsMean = delivered ? static_cast<double>(g_routeHopSum) / delivered : 0.0;
        // A path hook that recorded nothing while packets were delivered is
        // blind on this arm, not measuring zero churn: GPSR puts its own header
        // between IP and UDP, so the (flow, seq) parse never matches. Emit no
        // row there (absence, not zero — the #382 rule).
        r.routeValid = !(g_hopCount > 0 && delivered == 0);
    }
    // Jain's fairness index over per-flow delivered-packet counts:
    //     J = (sum x_i)^2 / (n * sum x_i^2),  J in (0, 1], J = 1/n at maximum
    // unfairness (one flow gets everything), J = 1 when every flow gets the
    // same. n is the number of source applications actually installed, so a
    // flow so starved that not one of its packets ever reached the IP layer
    // (its socket send failed for want of a route, which FlowMonitor never
    // sees) still counts as a zero rather than vanishing from the index — that
    // starved flow is the whole point of the metric. Equivalently computed over
    // per-flow throughput: every flow here sends the same 64-byte payload, so
    // the throughput vector is a scalar multiple of the packet-count vector and
    // Jain is scale-invariant. One column, both readings.
    {
        std::vector<double> x = flowRx;
        while (x.size() < apps.GetN()) x.push_back(0.0);
        double sum = 0.0, sumSq = 0.0;
        for (double v : x) {
            sum += v;
            sumSq += v * v;
        }
        r.jain = (!x.empty() && sumSq > 0.0) ? (sum * sum) / (static_cast<double>(x.size()) * sumSq)
                                             : 0.0;
    }

    // #308 phase 2 step 4: gather the pending-queue hold-time attribution
    // UNCONDITIONALLY, not just under --diag. It has been measured since #104
    // but only ever printed inside the --diag line, where it sat outside the
    // workflow's compact re-emit — so reading it for the phase-2 decomposition
    // needed a 900-line log tail and still lost three of twenty seeds. The
    // measurement was never the missing piece; reaching it was.
    r.holdValid = arm->CollectHoldTimes(run, r.hold);

    // Diagnostics line (prefixed "# " so CSV consumers ignore it). Shows whether
    // routes form (reactive ants sent vs received elsewhere; back-ant arrivals)
    // and when the first packet is delivered.
    if (g_diag) {
        std::cout << std::fixed << std::setprecision(2) << "# diag " << proto << " seed=" << seed
                  << " pdr=" << r.pdr << " firstDeliveryS=" << g_firstDeliveryS
                  << " ctrlTx=" << g_controlPkts;
        // #23: route-setup latency per flow (first delivery − flow start).
        {
            std::vector<double> setup;
            uint32_t never = 0;
            for (std::size_t i = 0; i < g_flowFirstRx.size(); ++i) {
                if (g_flowFirstRx[i] < 0.0) {
                    ++never;
                    continue;
                }
                setup.push_back(g_flowFirstRx[i] - g_flowStart[i]);
            }
            if (!setup.empty() || never > 0) {
                std::sort(setup.begin(), setup.end());
                std::cout << " setupMedS=" << (setup.empty() ? -1.0 : setup[setup.size() / 2])
                          << " setupMaxS=" << (setup.empty() ? -1.0 : setup.back())
                          << " flowsNoDelivery=" << never;
            }
        }
        arm->AppendDiag(run, measurement, std::cout);
        std::cout << "\n";
    }

    // Queue-depth summary (#73): the distribution of per-node MAC backlog seen
    // over the run. High maxQ / pctNonzero => the A2 signal is present; ~0 even
    // at low PDR => loss is collision-dominated and A2 is structurally inert.
    if (g_qdiag) {
        const double mean = g_qCount ? g_qSum / g_qCount : 0.0;
        const double pct = g_qCount ? 100.0 * g_qNonzero / g_qCount : 0.0;
        std::cout << std::fixed << std::setprecision(2) << "# qdiag " << proto << " seed=" << seed
                  << " pdr=" << r.pdr << " meanQ=" << mean << " maxQ=" << g_qMax
                  << " pctNonzero=" << pct << " samples=" << g_qCount << "\n";
    }

    // ADR-0027: the arm's own diagnostics after the markers (the oracle's
    // ##ORACLE##), then its invariants (the oracle puts nothing on the wire).
    arm->EmitDiagnostics(run, measurement, r.nrl, std::cout);
    arm->Check(run, measurement);

    Simulator::Destroy();
    return r;
}

}  // namespace routing_bench_detail
