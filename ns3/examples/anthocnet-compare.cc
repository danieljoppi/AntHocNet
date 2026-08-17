// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * AntHocNet vs. AODV / OLSR / DSDV / GPSR / oracle comparison.
 *
 * Runs the SAME mobile-ad-hoc scenario (identical node layout, mobility and
 * CBR traffic, driven from the same RNG run) under each routing protocol and
 * reports the metrics from the AntHocNet paper [1, §4]: packet-delivery ratio,
 * mean and 99th-percentile end-to-end delay, throughput, and normalized routing
 * load (NRL = routing-control packets transmitted / data packets delivered;
 * nrl_bytes is the byte-level counterpart, control bytes / delivered data
 * bytes, #132), plus radio energy (#209): total joules consumed, joules per
 * delivered packet, the residual-energy spread across nodes and the
 * first-node-death time, integrated from the PHY's own State trace with the
 * same currents on every node for every protocol (leak-free per #256),
 * plus packet reordering (#212): the RFC 4737 out-of-order
 * delivery ratio, the reordering extent (mean/max) and the reorder-buffer
 * occupancy needed to restore order, measured per flow at the sink and then
 * aggregated,
 * and a per-cause drop
 * breakdown (#215): why the packets PDR is missing went missing — L3 route
 * failure, interface-queue overflow, MAC retry exhaustion, channel loss and TTL
 * expiry, measured identically for all four protocols and summing with PDR to
 * ~100% of offered packets,
 * and route quality
 * (#217): the hop count actually traversed by delivered packets, the number of
 * distinct next hops that actually *carried* data per destination (the direct
 * measurement of multipath), and Jain's fairness index across the flows.
 * Fair comparison: the RNG run is reset before each protocol so every protocol
 * sees the identical mobility/traffic realisation, and NRL is counted uniformly
 * for every protocol from the IP layer.
 *
 * --scenario=paper reproduces the paper's base scenario (50 nodes in a
 * 1500x300 m area, random-waypoint at 20 m/s with 30 s pause, 20 CBR sources of
 * one 64-byte packet/s, 300 m range, 900 s). Override individual knobs to sweep
 * (e.g. --scenario=paper --areaX=2500, or --scenario=paper --pause=0).
 *
 * [1] Di Caro, Ducatelle, Gambardella, "AntHocNet: an ant-based hybrid routing
 *     algorithm for mobile ad hoc networks", PPSN VIII, 2004.
 *
 * The `oracle` arm (#296 item 1, #216) is the global-knowledge shortest-path
 * CONTROL: Dijkstra over the ground-truth topology, zero control traffic, zero
 * discovery latency. It is off by default and only runs when it is named in
 * --protocols; it is an upper bound, not a competitor. See ns3/oracle/README.md
 * for what "ground truth" means per propagation model.
 *
 * Requires the aodv, olsr, dsdv, gpsr (the #296 vendored baseline module),
 * oracle (the #296 control module) and
 * flow-monitor modules. Build with those enabled, then e.g.:
 *   ./ns3 run "anthocnet-compare --scenario=paper --runs=5"
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


#include "ns3/aodv-module.h"
// #296: the vendored AOMDV baseline module (contrib/aomdv, installed together
// with anthocnet by `make install-ns3`).
#include "ns3/aomdv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/dsdv-module.h"
// #296: the vendored GPSR baseline (contrib/gpsr). Geographic — position
// knowledge comes from the mobility models via its GOD location service.
#include "ns3/gpsr-module.h"
// #296 item 1: the oracle shortest-path control (contrib/oracle). Global
// knowledge, no packets — see the note at the top and ns3/oracle/README.md.
#include "ns3/oracle-module.h"
#include "ns3/anthocnet-helper.h"
#include "ns3/anthocnet-routing-protocol.h"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iterator>
#include <map>
#include <numeric>
#include <set>
#include <utility>
#include <vector>

using namespace ns3;

namespace {

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

// Advance `next` by the number of streams a helper's AssignStreams() reported,
// and abort if this run has overrun its per-seed block.
void TakeStreams(int64_t& next, int64_t base, int64_t used, const char* what) {
    next += used;
    NS_ABORT_MSG_IF(next - base >= kStreamStride,
                    "RNG stream budget exhausted after assigning " << what
                    << ": this run has consumed " << (next - base)
                    << " streams but kStreamStride is " << kStreamStride
                    << " — seed blocks would overlap (#352). Raise the stride.");
}

// #352: DsdvHelper is the one baseline helper with no AssignStreams() wrapper —
// AodvHelper, OlsrHelper and AntHocNetHelper all have one, DsdvHelper has none
// anywhere in the 3.36-3.48 CI matrix. dsdv::RoutingProtocol itself does declare
// AssignStreams(int64_t) in every one of those versions, so reach the installed
// protocol objects through the nodes and do what the missing wrapper would do.
// DSDV cannot simply be left unpinned: it is one of the untouched-baseline arms
// whose numbers must stay byte-identical across generations for a comparison to
// be attributable at all.
int64_t AssignDsdvStreams(const NodeContainer& nodes, int64_t stream) {
    int64_t used = 0;
    for (auto it = nodes.Begin(); it != nodes.End(); ++it) {
        Ptr<Ipv4> ipv4 = (*it)->GetObject<Ipv4>();
        NS_ABORT_MSG_IF(!ipv4, "node has no IPv4 stack; cannot pin dsdv streams");
        Ptr<dsdv::RoutingProtocol> dsdv =
            DynamicCast<dsdv::RoutingProtocol>(ipv4->GetRoutingProtocol());
        NS_ABORT_MSG_IF(!dsdv, "expected dsdv::RoutingProtocol on this node (#352)");
        used += dsdv->AssignStreams(stream + used);
    }
    return used;
}

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
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return;
    if (udp.GetDestinationPort() != kDataPort) {
        ++g_controlPkts;
        g_controlBytes += p->GetSize();
    }
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
bool ReinjKeyFromUdp(const Ipv4Header& ip, Ptr<const Packet> p,
                     Address& flow, uint32_t& seq) {
    if (ip.GetProtocol() != 17) return false;
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
        if (ip.GetProtocol() == 1) ++g_reinjUnparsedIcmp;
        else ++g_reinjUnparsedOther;
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
void CountReinjL3Drop(const Ipv4Header& ip, Ptr<const Packet> p,
                      Ipv4L3Protocol::DropReason reason, Ptr<Ipv4>, uint32_t) {
    if (g_reinj.empty()) return;
    Address flow;
    uint32_t seq = 0;
    if (!ReinjKeyFromUdp(ip, p, flow, seq)) return;
    const auto it = g_reinj.find(std::make_pair(flow, seq));
    if (it == g_reinj.end()) return;
    if (reason == Ipv4L3Protocol::DROP_ROUTE_ERROR ||
        reason == Ipv4L3Protocol::DROP_NO_ROUTE) {
        ++it->second.l3DropRoute;
    } else if (reason == Ipv4L3Protocol::DROP_TTL_EXPIRED) {
        ++it->second.l3DropTtl;
    } else {
        ++it->second.l3DropOther;
    }
}

void CountDataHopTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t iface) {
    if (iface != 0 && IsDataIp(p)) {
        ++g_dataHopTx;
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
    }
}

// WifiMac "DroppedMpdu": a retry-limit drop is the MAC giving up on a unicast,
// i.e. the link broke under the packet. Counted for every protocol from the
// same trace the AntHocNet adapter uses for ADR-0008 detector D, so the column
// means the same thing in all four arms. Other drop reasons (queue full,
// lifetime expiry) are congestion and are counted by FlowMonitor instead.
void CountMacDataDrop(WifiMacDropReason reason, Ptr<const AHN_WIFI_MPDU> mpdu) {
    if (reason != WIFI_MAC_DROP_REACHED_RETRY_LIMIT || !mpdu) return;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    LlcSnapHeader llc;
    if (pkt->GetSize() < llc.GetSerializedSize()) return;
    pkt->RemoveHeader(llc);
    if (llc.GetType() != 0x0800) return;  // not IPv4
    if (IsDataIp(pkt)) ++g_macDataDrops;
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

void PqTrackDrop(const Ipv4Header& ip, Ptr<const Packet> p,
                 Ipv4L3Protocol::DropReason, Ptr<Ipv4>, uint32_t) {
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
std::map<uint8_t, uint64_t> g_antTx;   // by AntType byte
std::map<uint8_t, uint64_t> g_antRx;
double g_firstDeliveryS = -1.0;
// #23: per-flow route-setup latency. g_firstDeliveryS alone is the sim time of
// the FIRST packet any sink receives — a min over all flows' random starts —
// so it measures the luckiest flow, not convergence. Track per-flow app start
// and first sink Rx instead (index-aligned with `sinks`; default pairing only,
// converge/--sink mode shares one sink and is skipped).
std::vector<double> g_flowStart;
std::vector<double> g_flowFirstRx;  // -1 = flow never delivered

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
}

// --- queue diagnostics (--qdiag): does the A2 congestion signal exist? --------
// A2 (item 10) keys off the WiFi MAC queue depth Q_mac. If 802.11 loss under
// load is collision-dominated (frames lost on-air, shallow queues) rather than
// queue-dominated, Q_mac stays ~0 even at low PDR and A2 has nothing to act on.
// Sample every node's MAC backlog periodically and report the distribution to
// settle that empirically before pursuing A2 further (issue #73).
bool g_qdiag = false;
uint64_t g_qCount = 0, g_qNonzero = 0, g_qMax = 0;
double   g_qSum = 0.0;

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

void OnPhyState(uint32_t node, Time, Time duration, WifiPhyState state) {
    switch (state) {
        case WifiPhyState::TX: g_airTxS += duration.GetSeconds(); break;
        case WifiPhyState::RX: g_airRxS += duration.GetSeconds(); break;
        case WifiPhyState::CCA_BUSY: g_airCcaS += duration.GetSeconds(); break;
        default: break;
    }
    double currentA;
    switch (state) {
        case WifiPhyState::TX: currentA = g_energyTxA; break;
        case WifiPhyState::RX: currentA = g_energyRxA; break;
        // CcaBusy and Switching draw the idle current — the same tie the
        // helper-based install kept (see the --idleCurrentA note below).
        case WifiPhyState::IDLE:
        case WifiPhyState::CCA_BUSY:
        case WifiPhyState::SWITCHING: currentA = g_energyIdleA; break;
        // SLEEP/OFF: unreachable under AdhocWifiMac (no power save, and
        // nothing turns a PHY off any more — that was the leaking event's
        // job). Zero draw if a future config ever reaches them.
        default: currentA = 0.0; break;
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
constexpr double kDefaultTxCurrentA = 0.380;
constexpr double kDefaultRxCurrentA = 0.313;
constexpr double kDefaultIdleCurrentA = 0.273;
constexpr double kDefaultVoltageV = 3.0;

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
constexpr double kDefaultEnergyJ = 5000.0;

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
constexpr double kDefaultPathWindowS = 10.0;
double   g_pathWindowS = kDefaultPathWindowS;
uint64_t g_divWindow = 0;  // index of the window g_divCur is accumulating
// (node index, destination IPv4) -> next-hop MAC (packed) -> data packets.
// Holds the current window only and is flushed into the accumulators when time
// crosses into the next one, so memory stays bounded however long the run is.
std::map<std::pair<uint32_t, uint32_t>, std::map<uint64_t, uint32_t>> g_divCur;
uint64_t g_divCells = 0;   // (node, dest, window) cells that carried data
double   g_divSum = 0.0;   // sum over cells of distinct used next hops
double   g_divEntSum = 0.0;  // sum over cells of the split's Shannon entropy
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

void CountAckedDataHop(uint32_t node, Ptr<const AHN_WIFI_MPDU> mpdu) {
    if (!mpdu) return;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    LlcSnapHeader llc;
    if (pkt->GetSize() < llc.GetSerializedSize()) return;
    pkt->RemoveHeader(llc);
    if (llc.GetType() != 0x0800) return;  // not IPv4
    Ipv4Header ip;
    if (pkt->RemoveHeader(ip) == 0) return;
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
    const uint64_t window =
        static_cast<uint64_t>(Simulator::Now().GetSeconds() / g_pathWindowS);
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

// Ipv4L3Protocol "LocalDeliver": one call per packet handed to the local
// transport, i.e. exactly the delivered packets PDR counts. The header arrives
// with the TTL the packet carried on the wire.
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
    const uint32_t hops =
        ttl < kIpDefaultTtl ? static_cast<uint32_t>(kIpDefaultTtl - ttl) + 1u : 1u;
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

struct Params {
    uint32_t nNodes;
    double   simTime;
    double   areaX, areaY;
    double   speed;
    double   pause;
    double   range;     // 0 => ns-3 default channel (log-distance)
    uint32_t nFlows;
    double   cbrBps;
    double   startWindow;
    std::string propagation;  // "range" (disk, default) | "tworay" (two-ray ground, #24)
    std::string rateManager;  // "constant2" (paper's 2 Mbit/s radio, default) | ... (#51)
    int32_t  sink;            // >=0: all flows converge on this node (gateway
                              // hotspot, #71); <0: default i->(n-1-i) pairing.
    // #209 energy model (see the provenance block above main()).
    double   energyJ;         // initial energy per node (J)
    double   voltageV;        // supply voltage (V)
    double   txCurrentA, rxCurrentA, idleCurrentA;
    // #217: window over which "distinct next hops used for a destination" is
    // counted (s). See the path-diversity block above main().
    double   pathWindowS;
    // #61: mobility model. "rwp" (Random Waypoint, the default and the model
    // every published number was measured under) | "ssrwp" (steady-state RWP,
    // no speed-decay transient) | "gaussmarkov" (smooth correlated tracks).
    std::string mobility;
    // #63: transport. "udp" (CBR OnOff, the default and what every published
    // number was measured under) | "tcp" (saturating BulkSend). Read the
    // metric-semantics warning above the flow loop before quoting a TCP cell.
    std::string transport;
};

struct Result {
    std::string proto;
    uint64_t txPackets = 0;
    uint64_t rxPackets = 0;
    double pdr = 0.0;            // %
    double meanDelayMs = 0.0;
    double delay99Ms = 0.0;      // 99th pct over *delivered* packets
    double throughputKbps = 0.0;
    double nrl = 0.0;            // control pkts / delivered data pkts
    double nrlBytes = 0.0;       // #132: control bytes / delivered data bytes
    // #57 paper-parity / survivorship-safe QoS metrics:
    double jitterMs = 0.0;       // mean delay jitter (the paper's QoS metric)
    double jitterEq51Ms = 0.0;   // #89: the thesis's eq 5.1, a different quantity
    double dOff50Ms = -1.0;      // delay at the 50th pct of *offered* (sent)
    double dOff90Ms = -1.0;      // packets, undelivered = inf; -1 encodes inf
    // #308: the delivered-delay histogram this run's percentiles were read
    // from, retained so a *matched-delivery* percentile can be taken after all
    // protocols have run. delay99 compares tails over different-sized
    // delivered sets — AntHocNet delivers ~10 pp more than AODV — so part of
    // its worse tail may be the packets AODV never delivered at all. Answering
    // that needs one protocol's distribution queried at another's delivery
    // count, which is only possible once both exist.
    std::map<uint32_t, uint64_t> delayHist;  // bin index -> delivered count
    double delayBinWidth = 0.0;              // seconds; 0 when no deliveries
    // #308: (flow, seq) -> delay (s) for every delivered packet, so the tails
    // can be compared over the packets *every* protocol delivered rather than
    // over each protocol's own differently-sized delivered set.
    std::map<Address, std::map<uint32_t, double>> rxDelayBySeq;
    // #308 phase 2: the same keys carrying hop counts, so the common set can be
    // normalised by path length like-for-like.
    std::map<Address, std::map<uint32_t, uint32_t>> rxHopsBySeq;
    // #308 phase 2 step 4: pending-queue hold-time attribution, summed over
    // nodes. `holdValid` is false for every protocol that is not AntHocNet —
    // see the ##HOLD## emission for why absence, not zero, is the right
    // representation there.
    ns3::anthocnet::HoldStats hold;
    bool holdValid = false;
    // #209 energy:
    // #308 phase 2 step 3: channel occupancy summed over nodes (node-seconds).
    // -1 = not measured (the PHY State trace is only connected when the energy
    // model is on), which suppresses the ##AIR## row entirely.
    double airTxS = -1.0, airRxS = -1.0, airCcaS = -1.0;
    // #63: application bytes actually delivered, per second, summed over the
    // PacketSinks. Distinct from throughputKbps, which is FlowMonitor's
    // delivered *IP* bytes and therefore counts TCP retransmissions. On UDP the
    // two agree; on TCP their gap is the retransmission overhead, which is why
    // this is the TCP arm's headline rather than PDR.
    double goodputKbps = 0.0;
    double energyJ = 0.0;        // total consumed over all nodes (J)
    double energyPerPktJ = 0.0;  // energyJ / delivered data packets (J/pkt)
    double resMinJ = 0.0;        // residual energy across nodes: min / mean /
    double resMeanJ = 0.0;       // sample stddev (J) — the fairness spread
    double resSdJ = 0.0;
    double firstDeathS = -1.0;   // -1 = no node died (see OnPhyState)
    // #212 packet reordering (definitions in docs/benchmarks/metrics.md):
    double reorderRatio = 0.0;     // RFC 4737 Type-P-Reordered fraction, [0,1]
    double reorderRatioMax = 0.0;  // worst single flow's ratio, [0,1]
    double reorderExtMean = 0.0;   // mean reordering extent over reordered pkts
    double reorderExtMax = 0.0;    // max reordering extent, packets
    double reorderBufMax = 0.0;    // max reorder-buffer occupancy, packets
    // #215 drop causes, each as a % of *offered* (txPackets), so that
    // pdr + the five protocol-agnostic causes ≈ 100. Sentinel **-1 = not
    // applicable to this protocol** (emitted as a blank field, never a 0, so
    // "this protocol has no such cause" stays distinguishable from "measured
    // zero"); the three AntHocNet-only causes use it for every other arm.
    double dropRoutePct = 0.0;   // L3 route failure (no route / route error)
    double dropQueuePct = 0.0;   // interface/qdisc queue overflow; on the
                                 // dsdv/aodv arms also the protocol's own
                                 // pending-queue losses (#229, PqTrackTx)
    double dropMacPct   = 0.0;   // MAC retry limit, terminal (not re-injected)
    double dropChanPct  = 0.0;   // sent on the medium, never received
    double dropTtlPct   = 0.0;   // IP TTL exhausted
    double dropSetupPct  = -1.0; // AntHocNet: pending-queue loss, never routed
    double dropReconvPct = -1.0; // AntHocNet: pending-queue loss, route lost
    double dropRepairPct = -1.0; // AntHocNet: DiscardPending after a failed repair
    double dropOtherPct  = 0.0;  // L3 drops in none of the buckets above (diag)
    // #217 route quality. hops* are 0 when nothing was delivered and div*/
    // entropy are 0 when no data hop was ever acked, matching the `nrl` and
    // `energy_per_pkt_j` convention for an empty denominator.
    double hopsMean = 0.0;       // mean hop count over delivered data packets
    double hopsMax = 0.0;        // max hop count over delivered data packets
    double divUsed = 0.0;        // mean distinct *used* next hops per cell
    double divMax = 0.0;         // max distinct used next hops in any one cell
    double divEntropyBits = 0.0; // mean Shannon entropy (bits) of the split
    double jain = 0.0;           // Jain's index over per-flow delivered packets
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
    g_antTx.clear();
    g_antRx.clear();
    g_firstDeliveryS = -1.0;
    g_flowStart.clear();
    g_flowFirstRx.clear();
    g_qCount = g_qNonzero = g_qMax = 0;
    g_qSum = 0.0;
    g_firstDeathS = -1.0;
    g_airTxS = g_airRxS = g_airCcaS = 0.0;  // #308 phase 2 step 3
    g_rxSeq.clear();
    g_rxArrival.clear();  // #89
    g_rxDelayBySeq.clear();  // #308
    g_rxHopsBySeq.clear();   // #308 phase 2
    g_rxCount.clear();       // #386
    g_reinj.clear();         // #386
    g_reinjEvents = g_reinjParsed = g_reinjOfDelivered = 0;  // #386
    g_reinjUnparsedIcmp = g_reinjUnparsedOther = 0;          // #386
    g_reinjSkip.clear();  // #402
    g_reinjSkips = 0;     // #402
    g_pqPending.clear();  // #229
    g_pqEcbDrops = 0;     // #229
    g_dataHopTx = g_dataHopRx = g_macDataDrops = 0;  // #215
    g_ackedDataHops = 0;  // #377
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

    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
    // #51: the ns-3 default (IdealWifiManager) oscillates 1<->11 Mbps and loses
    // every second unicast to retry exhaustion (DSSS 11 Mbps never delivers in
    // this setup), halving PDR for every protocol. Default is the paper's fixed
    // 2 Mbit/s radio; --rateManager reaches the alternatives for A/B.
    if (P.rateManager == "arf") {
        wifi.SetRemoteStationManager("ns3::ArfWifiManager");
    } else if (P.rateManager.rfind("constant", 0) == 0) {
        std::string rate = P.rateManager == "constant1"  ? "DsssRate1Mbps"
                         : P.rateManager == "constant2"  ? "DsssRate2Mbps"
                         : P.rateManager == "constant5"  ? "DsssRate5_5Mbps"
                                                         : "DsssRate11Mbps";
        wifi.SetRemoteStationManager("ns3::ConstantRateWifiManager",
                                     "DataMode", StringValue(rate),
                                     "ControlMode", StringValue("DsssRate1Mbps"));
    }  // "ideal": keep the WifiHelper default
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
        channel.AddPropagationLoss("ns3::TwoRayGroundPropagationLossModel",
                                   "Frequency", DoubleValue(2.4e9),
                                   "HeightAboveZ", DoubleValue(1.5));
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
        channel.AddPropagationLoss("ns3::TwoRayGroundPropagationLossModel",
                                   "Frequency", DoubleValue(2.4e9),
                                   "HeightAboveZ", DoubleValue(1.5));
        channel.AddPropagationLoss("ns3::NakagamiPropagationLossModel");
    } else if (P.range > 0.0) {
        // A clean disk model at the paper's transmission range (reproducible
        // connectivity, independent of tx-power/sensitivity defaults).
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::RangePropagationLossModel",
                                   "MaxRange", DoubleValue(P.range));
    } else {
        channel = YansWifiChannelHelper::Default();
    }
    Ptr<YansWifiChannel> wifiChannel = channel.Create();
    phy.SetChannel(wifiChannel);
    WifiMacHelper mac;
    mac.SetType("ns3::AdhocWifiMac");
    NetDeviceContainer devices = wifi.Install(phy, mac, nodes);
    // #352: the propagation models configured above are all deterministic, so
    // the channel normally reports 0 streams — pinned anyway so swapping in a
    // fading model (Nakagami, ...) cannot reintroduce the position dependence.
    // WifiHelper::AssignStreams covers the PHY's reception-error variable, the
    // MAC/Txop backoff and the rate manager in one call.
    TakeStreams(stream, streamBase, channel.AssignStreams(wifiChannel, stream),
                "wifi channel");
    TakeStreams(stream, streamBase, wifi.AssignStreams(devices, stream), "wifi");

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
        for (uint32_t i = 0; i < devices.GetN(); ++i) {
            Ptr<WifiNetDevice> w = devices.Get(i)->GetObject<WifiNetDevice>();
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
    Ptr<RandomRectanglePositionAllocator> pos =
        CreateObject<RandomRectanglePositionAllocator>();
    pos->SetX(ux);
    pos->SetY(uy);
    mobility.SetPositionAllocator(pos);
    std::ostringstream speedStr, pauseStr;
    speedStr << "ns3::UniformRandomVariable[Min=1.0|Max=" << P.speed << "]";
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
        mobility.SetMobilityModel("ns3::SteadyStateRandomWaypointMobilityModel",
                                  "MinSpeed", DoubleValue(1.0),
                                  "MaxSpeed", DoubleValue(P.speed),
                                  "MinPause", DoubleValue(P.pause),
                                  "MaxPause", DoubleValue(P.pause),
                                  "MinX", DoubleValue(0.0),
                                  "MaxX", DoubleValue(P.areaX),
                                  "MinY", DoubleValue(0.0),
                                  "MaxY", DoubleValue(P.areaY));
    } else if (P.mobility == "gaussmarkov") {
        // Gauss-Markov: velocity and direction are temporally correlated
        // (alpha = 0.85), so tracks are smooth rather than the sharp
        // waypoint-to-waypoint turns of RWP. This is the qualitatively
        // different model #295 asks for, and the one aerial/FANET claims
        // require.
        //
        // Two-dimensional on purpose: the Box's z extent is zero and the pitch
        // is fixed at 0, so nodes stay in the plane the propagation models and
        // the 2-D field geometry assume.
        //
        // There is no pause concept here -- a Gauss-Markov node never stops.
        // `--pause` is therefore inert under this model, which is why
        // scenario_check.py's preflight refuses the combination rather than
        // letting a sweep believe it varied something.
        mobility.SetMobilityModel(
            "ns3::GaussMarkovMobilityModel",
            "Bounds", BoxValue(Box(0.0, P.areaX, 0.0, P.areaY, 0.0, 0.0)),
            "TimeStep", TimeValue(Seconds(1.0)),
            "Alpha", DoubleValue(0.85),
            "MeanVelocity", StringValue(speedStr.str()),
            "MeanDirection",
            StringValue("ns3::UniformRandomVariable[Min=0.0|Max=6.283185307]"),
            "MeanPitch", StringValue("ns3::ConstantRandomVariable[Constant=0.0]"),
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
            // at 0 and the model two-dimensional.
            "NormalPitch",
            StringValue("ns3::NormalRandomVariable[Mean=0.0|Variance=0.0|Bound=0.0]"));
    } else {
        mobility.SetMobilityModel("ns3::RandomWaypointMobilityModel",
                                  "Speed", StringValue(speedStr.str()),
                                  "Pause", StringValue(pauseStr.str()),
                                  "PositionAllocator", PointerValue(pos));
    }
    // #352: the initial positions are drawn during Install(), so the allocator
    // has to be pinned BEFORE it — MobilityHelper::AssignStreams can only reach
    // the models (and, through RandomWaypoint, the allocator's later waypoint
    // draws) once they exist.
    TakeStreams(stream, streamBase, pos->AssignStreams(stream),
                "position allocator");
    mobility.Install(nodes);
    TakeStreams(stream, streamBase, mobility.AssignStreams(nodes, stream),
                "mobility");

    // #352: the routing helpers are hoisted out of the branches so their
    // AssignStreams() can run after Install() (SetRoutingHelper stores a Copy(),
    // but AssignStreams reaches the *installed* protocols through the nodes, so
    // the local helper is the right handle). Constructing all of them is free —
    // each is an ObjectFactory and instantiates nothing.
    InternetStackHelper internet;
    AntHocNetHelper ahnHelper;
    AodvHelper aodvHelper;
    AomdvHelper aomdvHelper;
    OlsrHelper olsrHelper;
    DsdvHelper dsdvHelper;
    GpsrHelper gpsrHelper;
    // #296: constructed per RunOne, like every other helper here — the oracle
    // helper owns this run's ground-truth graph, so a fresh one per run is what
    // stops run N inheriting run N-1's nodes.
    OracleHelper oracleHelper;
    // #296/#431: the oracle derives its adjacency from the installed objects
    // on every channel this harness configures — the disk channel's own
    // MaxRange (exact), the two-ray decode radius at the PHY's decode
    // threshold, or the Nakagami closed-form median radius at that same
    // threshold (both flagged approx=1). LinkRangeM is deliberately NOT set
    // here any more: pinning it to --range was what held the fading cells to
    // a 300 m disk the radios outreach by 40 % (#431's measured hop
    // violation). To force a radius, pass the attribute explicitly:
    // --ns3::oracle::Topology::LinkRangeM=<m>. On a channel the oracle cannot
    // derive, it still aborts rather than guess.
    if (proto == "anthocnet") {
        internet.SetRoutingHelper(ahnHelper);
    } else if (proto == "aodv") {
        internet.SetRoutingHelper(aodvHelper);
    } else if (proto == "aomdv") {
        // #296: vendored multipath baseline. Not in the default protocol list —
        // it joins campaign dispatches explicitly (phase 3); the harness
        // attaches to it exactly what it attaches to the other baselines.
        internet.SetRoutingHelper(aomdvHelper);
    } else if (proto == "olsr") {
        internet.SetRoutingHelper(olsrHelper);
    } else if (proto == "dsdv") {
        internet.SetRoutingHelper(dsdvHelper);
    } else if (proto == "gpsr") {
        internet.SetRoutingHelper(gpsrHelper);
    } else if (proto == "oracle") {
        internet.SetRoutingHelper(oracleHelper);
    } else {
        // #448: an unknown arm must abort here, not run on the bare IP stack
        // and emit a plausible-looking 0 % row.
        NS_ABORT_MSG("unknown protocol '" << proto
                     << "' -- see --PrintHelp's --protocols list");
    }
    internet.Install(nodes);
    // #296: gpsr's data packets carry a position header, injected by
    // re-pointing the UDP down target — the helper wires that after the stack
    // exists, exactly as the dwosion examples do (scoped to this run's nodes,
    // not the global container, so repeated RunOne calls can't cross-wire).
    if (proto == "gpsr") {
        gpsrHelper.Install(nodes);
    }
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
    // Each of these protocols builds a UniformRandomVariable per node (ant/RREQ
    // jitter, hello jitter) at construction; pin them.
    if (proto == "anthocnet") {
        TakeStreams(stream, streamBase, ahnHelper.AssignStreams(nodes, stream),
                    "anthocnet routing");
    } else if (proto == "aodv") {
        TakeStreams(stream, streamBase, aodvHelper.AssignStreams(nodes, stream),
                    "aodv routing");
    } else if (proto == "aomdv") {
        TakeStreams(stream, streamBase, aomdvHelper.AssignStreams(nodes, stream),
                    "aomdv routing");
    } else if (proto == "olsr") {
        TakeStreams(stream, streamBase, olsrHelper.AssignStreams(nodes, stream),
                    "olsr routing");
    } else if (proto == "dsdv") {
        TakeStreams(stream, streamBase, AssignDsdvStreams(nodes, stream),
                    "dsdv routing");
    } else if (proto == "gpsr") {
        TakeStreams(stream, streamBase, gpsrHelper.AssignStreams(nodes, stream),
                    "gpsr routing");
    } else if (proto == "oracle") {
        // Pinned through the same path as every other arm even though the
        // oracle draws nothing: the count it returns is 0, and taking it here
        // makes that a measured zero rather than a gap in the #352 coverage.
        TakeStreams(stream, streamBase, oracleHelper.AssignStreams(nodes, stream),
                    "oracle routing");
    } else {
        // #448: unreachable once the install chain above aborts, but the two
        // dispatch chains stay structurally parallel by convention — guard both.
        NS_ABORT_MSG("unknown protocol '" << proto
                     << "' -- see --PrintHelp's --protocols list");
    }

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
            l3->TraceConnectWithoutContext("LocalDeliver",
                                           MakeCallback(&CountDeliveredHops));
        }
    }
    // #386: re-injection identity & fate. anthocnet + UDP only: the baselines
    // have no detector (their arms emit NO ##REINJ## line — absence, not zero,
    // per the #382 rule), and under TCP the SeqTs identity does not exist. The
    // EnableMacFailureDetector=false arm keeps the hooks: its trace never
    // fires, so every field reads a *measured* zero, which is what lets
    // scenario_check assert the detector-off control as a number.
    if (proto == "anthocnet" && P.transport != "tcp") {
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
            Ptr<Ipv4RoutingProtocol> rp = ip ? ip->GetRoutingProtocol() : nullptr;
            if (rp) {
                rp->TraceConnectWithoutContext("MacReinject",
                                               MakeCallback(&CountMacReinject));
                // #402: the capped-skip trace, same gate. Fires only when
                // MaxReinjectPerPacket != 0, so every field it feeds is a
                // measured zero on uncapped arms.
                rp->TraceConnectWithoutContext(
                    "MacReinjectSkip", MakeCallback(&CountMacReinjectSkip));
            }
            // l3Drop stage — isolated connect, cuttable with CountReinjL3Drop
            // if a CI ns-3 version rejects the "Drop" signature (#386).
            Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
            if (l3) {
                l3->TraceConnectWithoutContext("Drop",
                                               MakeCallback(&CountReinjL3Drop));
            }
        }
    }
    // #229: pending-queue conservation, dsdv + aodv + UDP only (see the
    // PqTrackTx block comment). The other arms never connect these, so their
    // books are byte-identical to pre-#229.
    if ((proto == "dsdv" || proto == "aodv") && P.transport != "tcp") {
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
            if (l3) {
                l3->TraceConnectWithoutContext("Tx", MakeCallback(&PqTrackTx));
                l3->TraceConnectWithoutContext("Drop",
                                               MakeCallback(&PqTrackDrop));
            }
        }
    }
    for (uint32_t i = 0; i < devices.GetN(); ++i) {
        Ptr<WifiNetDevice> w = devices.Get(i)->GetObject<WifiNetDevice>();
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
            wmac->TraceConnectWithoutContext("DroppedMpdu",
                                             MakeCallback(&CountMacDataDrop));
            wmac->TraceConnectWithoutContext(
                "AckedMpdu", MakeBoundCallback(&CountAckedDataHop, i));
        }
    }

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer ifs = address.Assign(devices);

    // nFlows CBR flows from node i to node (nNodes-1-i), each starting at a
    // random time within the start window (paper staggers sources over 0-180 s).
    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(0.0));
    startVar->SetAttribute("Max", DoubleValue(std::min(P.startWindow, P.simTime * 0.5)));
    // #352: pinned before the flow loop below reads it — the start times are
    // drawn there, not at Simulator::Run().
    startVar->SetStream(stream);
    TakeStreams(stream, streamBase, 1, "flow start times");
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
    for (uint32_t i = 0; i < P.nFlows && i < maxFlows; ++i) {
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
        OnOffHelper onoff("ns3::UdpSocketFactory",
                          InetSocketAddress(ifs.GetAddress(dst), port));
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
        const double startS = startVar->GetValue();
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
        PacketSinkHelper sink(P.transport == "tcp" ? "ns3::TcpSocketFactory"
                                                   : "ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), port));
        sinks.Add(sink.Install(nodes.Get(P.sink)));
    }
    sinks.Start(Seconds(0.0));

    // #352: the OnOff sources' on/off variables. They are ConstantRandomVariable
    // in this harness (a CBR source is always on), so they consume streams
    // without drawing from them — pinned regardless, so an on/off duty cycle
    // added later cannot reintroduce the position dependence. PacketSink draws
    // nothing. AssignStreams is called on the applications rather than through
    // OnOffHelper::AssignStreams because the helper is per-flow and scoped to
    // the loop above.
    for (uint32_t i = 0; i < apps.GetN(); ++i) {
        Ptr<OnOffApplication> onoffApp = DynamicCast<OnOffApplication>(apps.Get(i));
        if (onoffApp) {
            TakeStreams(stream, streamBase, onoffApp->AssignStreams(stream),
                        "onoff application");
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

    if (g_diag) {
        // First-delivery timestamp from every data sink (all protocols), plus
        // per-flow first-Rx for the #23 setup-latency metric (default pairing
        // only; converge mode has one shared sink and no per-flow mapping).
        g_flowFirstRx.assign(g_flowStart.size(), -1.0);
        for (uint32_t i = 0; i < sinks.GetN(); ++i) {
            if (!converge && sinks.GetN() == g_flowStart.size()) {
                sinks.Get(i)->TraceConnectWithoutContext(
                    "Rx", MakeBoundCallback(&DiagSinkRxFlow, i));
            } else {
                sinks.Get(i)->TraceConnectWithoutContext("Rx", MakeCallback(&DiagSinkRx));
            }
        }
        // Per-type ant tallies from AntHocNet's own trace sources (item 15).
        // Guarded to anthocnet: other protocols have no "Tx"/"Rx" ant traces.
        if (proto == "anthocnet") {
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<Ipv4RoutingProtocol> rp = ip->GetRoutingProtocol();
                if (!rp) continue;
                rp->TraceConnectWithoutContext("Tx", MakeCallback(&DiagAntTx));
                rp->TraceConnectWithoutContext("Rx", MakeCallback(&DiagAntRx));
            }
        }
    }

    // Queue-depth sampler (#73): start after a 10% warm-up so convergence
    // transients don't dominate, sample every 0.5 s until the run ends.
    if (g_qdiag) {
        Simulator::Schedule(Seconds(P.simTime * 0.1), &SampleQueues, nodes, 0.5,
                            P.simTime);
    }

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();

    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();

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
        r.goodputKbps = P.simTime > 0.0
                            ? 8.0 * static_cast<double>(rxBytes) / P.simTime / 1000.0
                            : 0.0;
    }
    double totalDelay = 0.0;
    uint64_t rxForDelay = 0;
    double totalRxBytes = 0.0;
    double totalJitter = 0.0;    // #57: FlowMonitor jitterSum over data flows
    uint64_t jitterSamples = 0;  // each flow contributes rx-1 jitter samples
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
    Ptr<Ipv4FlowClassifier> classifier =
        DynamicCast<Ipv4FlowClassifier>(fmHelper.GetClassifier());
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
        auto reason = [&pd](std::size_t i) -> uint64_t {
            return i < pd.size() ? pd[i] : 0u;
        };
        dropRoute += reason(Ipv4FlowProbe::DROP_NO_ROUTE)
                   + reason(Ipv4FlowProbe::DROP_ROUTE_ERROR);
        dropTtl += reason(Ipv4FlowProbe::DROP_TTL_EXPIRE);
        dropQueue += reason(Ipv4FlowProbe::DROP_QUEUE)
                   + reason(Ipv4FlowProbe::DROP_QUEUE_DISC);
        for (uint32_t v : pd) dropL3Total += v;
    }
    r.pdr = r.txPackets ? 100.0 * r.rxPackets / r.txPackets : 0.0;
    r.meanDelayMs = rxForDelay ? 1000.0 * totalDelay / rxForDelay : 0.0;
    r.throughputKbps = (totalRxBytes * 8.0 / 1000.0) / P.simTime;
    r.nrl = r.rxPackets ? static_cast<double>(g_controlPkts) / r.rxPackets : 0.0;
    // #132: same IP-layer counting point as nrl, but in bytes; delivered data
    // bytes are the FlowMonitor rxBytes already summed for throughput.
    r.nrlBytes = totalRxBytes > 0.0
        ? static_cast<double>(g_controlBytes) / totalRxBytes : 0.0;

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
        r.energyPerPktJ = r.rxPackets
            ? consumed / static_cast<double>(r.rxPackets) : 0.0;
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
                    std::upper_bound(pref.begin(), pref.begin() + i, arr[i])
                    - pref.begin());
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
                    std::lower_bound(ordered.begin(), ordered.end(), s)
                    - ordered.begin())] = 1;
                ++occ;
                while (k < ordered.size() && arrived[k]) { --occ; ++k; }
                if (occ > occMax) occMax = occ;
            }
            rxSeqTotal += arr.size();
            reorderedTotal += reordered;
            const double ratio = static_cast<double>(reordered) / arr.size();
            if (ratio > ratioMaxFlow) ratioMaxFlow = ratio;
            if (occMax > bufMax) bufMax = occMax;
        }
        r.reorderRatio = rxSeqTotal
            ? static_cast<double>(reorderedTotal) / rxSeqTotal : 0.0;
        r.reorderRatioMax = ratioMaxFlow;
        r.reorderExtMean = extCount
            ? static_cast<double>(extSum) / extCount : 0.0;
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
        if (proto == "anthocnet") {
            uint64_t holdSetup = 0, holdReconv = 0, repairPkts = 0;
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<ns3::anthocnet::RoutingProtocol> ahn =
                    DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
                if (!ahn) continue;
                const ns3::anthocnet::HoldStats& s = ahn->HoldTimeStats();
                holdSetup += s.droppedCount[ns3::anthocnet::HOLD_SETUP];
                // A packet re-injected after a MAC failure (#46) and then aged
                // out was still waiting for a route that had existed and did
                // not come back — the reconvergence cause, not a separate one.
                holdReconv += s.droppedCount[ns3::anthocnet::HOLD_RECONV]
                            + s.droppedCount[ns3::anthocnet::HOLD_REPAIR];
                repairPkts += ahn->RepairDiscardedPackets();
                reinjected += ahn->MacReinjectedPackets();
            }
            r.dropSetupPct  = 100.0 * holdSetup / tx;
            r.dropReconvPct = 100.0 * holdReconv / tx;
            r.dropRepairPct = 100.0 * repairPkts / tx;
        }
        // Every one of these three ends in an error callback, so together they
        // are a *sub-breakdown* of dropRoutePct, not extra causes on top of it;
        // adding them to the identity would double-count.
        const uint64_t macTerminal =
            g_macDataDrops > reinjected ? g_macDataDrops - reinjected : 0;
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
        uint64_t skipsPkts = 0, skipsDelivBefore = 0, skipsDelivAfterOnly = 0,
                 skipsNever = 0, skipsDelivEvents = 0;
        for (const auto& kv : g_reinjSkip) {
            ++skipsPkts;
            uint32_t endCount = 0;
            const auto f = g_rxCount.find(kv.first.first);
            if (f != g_rxCount.end()) {
                const auto s = f->second.find(kv.first.second);
                if (s != f->second.end()) endCount = s->second;
            }
            if (kv.second.rxAtFirstSkip >= 1) ++skipsDelivBefore;
            else if (endCount >= 1) ++skipsDelivAfterOnly;
            else ++skipsNever;
            if (kv.second.rxAtFirstSkip >= 1 || endCount >= 1)
                skipsDelivEvents += kv.second.events;
        }
        const double hopLoss = static_cast<double>(g_dataHopTx)
                             - static_cast<double>(g_dataHopRx);
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
        const uint64_t unackedRx = g_dataHopRx > g_ackedDataHops
            ? g_dataHopRx - g_ackedDataHops : 0;
        const uint64_t macLost =
            g_macDataDrops > unackedRx ? g_macDataDrops - unackedRx : 0;
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
        r.dropRoutePct = 100.0 * (dropRoute > pqEcb ? dropRoute - pqEcb : 0)
                       / tx;
        r.dropTtlPct   = 100.0 * dropTtl / tx;
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
        r.dropMacPct   = 100.0 * (reinjected ? macTerminalCapAware : macLost) / tx;
        r.dropChanPct  = 100.0 * (hopLoss - static_cast<double>(macLost)
                                          - static_cast<double>(dropQueue)) / tx;
        // L3 drops in none of the buckets above (bad checksum, interface down,
        // fragment timeout — all structurally zero in this harness). Diagnostic
        // only: if it is ever non-zero it is the reason the identity misses.
        const uint64_t other = dropL3Total > dropRoute + dropTtl + dropQueue
            ? dropL3Total - dropRoute - dropTtl - dropQueue : 0;
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
        const int64_t hopLossN = static_cast<int64_t>(g_dataHopTx)
                               - static_cast<int64_t>(g_dataHopRx);
        const int64_t overlap = static_cast<int64_t>(macLost)
                              + static_cast<int64_t>(dropQueue) - hopLossN;
        // Not emitted under TCP. Since #389 the counters above DO count TCP
        // data segments, but the drop-cause identity itself is unvalidated
        // under TCP — it was closed on per-packet UDP books, and TCP counts
        // segments and retransmits them, so the arithmetic has not been shown
        // to close there. The emission stays suppressed until it is (#389
        // follow-up); same rule as ##HOLD##/##AIR## and #382 — an unvalidated
        // line would read as clean books, so absence is the encoding.
        if (P.transport != "tcp") {
            std::cout << "##DROPID## " << seed << ' ' << proto
                      << " hopTx=" << g_dataHopTx
                      << " hopRx=" << g_dataHopRx
                      << " ackedHops=" << g_ackedDataHops
                      << " macDrops=" << g_macDataDrops
                      << " reinjected=" << reinjected
                      << " macTerminal=" << macTerminal
                      << " macLost=" << macLost
                      << " queue=" << dropQueue
                      << " hopLoss=" << hopLossN
                      << " overlap=" << overlap
                      << " unackedRx=" << unackedRx;
            // #229: the pending-queue conservation counters, appended at the
            // END and only on the arms whose hook is connected — on the other
            // arms the quantity is unmeasured, and per the #382 rule absence
            // must stay distinguishable from a measured zero.
            if (proto == "dsdv" || proto == "aodv") {
                std::cout << " pqSilent=" << pqSilent << " pqEcb=" << pqEcb;
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
        if (proto == "anthocnet" && P.transport != "tcp") {
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
                if (kv.second.rxAtFirstReinj >= 1) ++delivBefore;
                else if (endCount >= 1) ++delivAfterOnly;
                else ++never;
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
            std::cout << "##REINJ## " << seed << ' ' << proto
                      << " events=" << g_reinjEvents
                      << " parsed=" << g_reinjParsed
                      << " unparsedIcmp=" << g_reinjUnparsedIcmp
                      << " unparsedOther=" << g_reinjUnparsedOther
                      << " ofDelivered=" << g_reinjOfDelivered
                      << " pkts=" << pkts
                      << " pktsDelivBefore=" << delivBefore
                      << " pktsDelivAfterOnly=" << delivAfterOnly
                      << " pktsNever=" << never
                      << " pktsDupDeliv=" << dupDeliv
                      << " dupRx=" << dupRx
                      << " postTx=" << postTx
                      << " postRx=" << postRx
                      << " l3DropRoute=" << l3Route
                      << " l3DropTtl=" << l3Ttl
                      << " l3DropOther=" << l3Other
                      << " skips=" << g_reinjSkips
                      << " skipsPkts=" << skipsPkts
                      << " skipsDelivBefore=" << skipsDelivBefore
                      << " skipsDelivAfterOnly=" << skipsDelivAfterOnly
                      << " skipsNever=" << skipsNever << '\n';
        }
    }

    // #217 route quality.
    r.hopsMean = g_hopCount
        ? static_cast<double>(g_hopSum) / static_cast<double>(g_hopCount) : 0.0;
    r.hopsMax = static_cast<double>(g_hopMax);
    r.divUsed = g_divCells ? g_divSum / static_cast<double>(g_divCells) : 0.0;
    r.divEntropyBits =
        g_divCells ? g_divEntSum / static_cast<double>(g_divCells) : 0.0;
    r.divMax = static_cast<double>(g_divMax);
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
        r.jain = (!x.empty() && sumSq > 0.0)
            ? (sum * sum) / (static_cast<double>(x.size()) * sumSq) : 0.0;
    }

    // #308 phase 2 step 4: gather the pending-queue hold-time attribution
    // UNCONDITIONALLY, not just under --diag. It has been measured since #104
    // but only ever printed inside the --diag line, where it sat outside the
    // workflow's compact re-emit — so reading it for the phase-2 decomposition
    // needed a 900-line log tail and still lost three of twenty seeds. The
    // measurement was never the missing piece; reaching it was.
    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
        if (!ip) continue;
        Ptr<ns3::anthocnet::RoutingProtocol> ahn =
            DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
        if (!ahn) continue;
        r.holdValid = true;
        const ns3::anthocnet::HoldStats& s = ahn->HoldTimeStats();
        for (uint8_t hr = 0; hr < ns3::anthocnet::kHoldReasons; ++hr) {
            r.hold.deliveredCount[hr] += s.deliveredCount[hr];
            r.hold.deliveredSumS[hr] += s.deliveredSumS[hr];
            if (s.deliveredMaxS[hr] > r.hold.deliveredMaxS[hr])
                r.hold.deliveredMaxS[hr] = s.deliveredMaxS[hr];
            r.hold.droppedCount[hr] += s.droppedCount[hr];
            r.hold.droppedSumS[hr] += s.droppedSumS[hr];
        }
    }

    // Diagnostics line (prefixed "# " so CSV consumers ignore it). Shows whether
    // routes form (reactive ants sent vs received elsewhere; back-ant arrivals)
    // and when the first packet is delivered.
    if (g_diag) {
        std::cout << std::fixed << std::setprecision(2)
                  << "# diag " << proto << " seed=" << seed
                  << " pdr=" << r.pdr
                  << " firstDeliveryS=" << g_firstDeliveryS
                  << " ctrlTx=" << g_controlPkts;
        // #23: route-setup latency per flow (first delivery − flow start).
        {
            std::vector<double> setup;
            uint32_t never = 0;
            for (std::size_t i = 0; i < g_flowFirstRx.size(); ++i) {
                if (g_flowFirstRx[i] < 0.0) { ++never; continue; }
                setup.push_back(g_flowFirstRx[i] - g_flowStart[i]);
            }
            if (!setup.empty() || never > 0) {
                std::sort(setup.begin(), setup.end());
                std::cout << " setupMedS="
                          << (setup.empty() ? -1.0 : setup[setup.size() / 2])
                          << " setupMaxS=" << (setup.empty() ? -1.0 : setup.back())
                          << " flowsNoDelivery=" << never;
            }
        }
        if (proto == "anthocnet") {
            auto n = [](std::map<uint8_t, uint64_t>& m, uint8_t k) {
                auto it = m.find(k);
                return it == m.end() ? static_cast<uint64_t>(0) : it->second;
            };
            std::cout << " antTx[hello=" << n(g_antTx, 0x01)
                      << ",reactive=" << n(g_antTx, 0x02)
                      << ",proactive=" << n(g_antTx, 0x04)
                      << ",repair=" << n(g_antTx, 0x08)
                      << ",linkfail=" << n(g_antTx, 0x10) << "]"
                      << " antRx[hello=" << n(g_antRx, 0x01)
                      << ",reactive=" << n(g_antRx, 0x02)
                      << ",proactive=" << n(g_antRx, 0x04)
                      << ",repair=" << n(g_antRx, 0x08)
                      << ",linkfail=" << n(g_antRx, 0x10) << "]";
            // Issue #20: origin vs propagation split of the linkfail volume
            // (origins = antTx[linkfail] - linkfailProp; budgetDrop counts
            // propagations suppressed by the inherited broadcastBudget).
            uint64_t lfProp = 0, lfBudget = 0, lfSuppressed = 0;
            // Reactive ants steered by the diffusion gradient instead of
            // broadcast (EnableDirectedReactive). Always 0 with the default
            // gate off; on an enabled arm it is the "did the mechanism engage"
            // number to read *before* comparing NRL between the two arms.
            uint64_t steers = 0;
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<ns3::anthocnet::RoutingProtocol> ahn =
                    DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
                if (!ahn) continue;
                lfProp += ahn->LinkfailPropagations();
                lfBudget += ahn->LinkfailBudgetDrops();
                lfSuppressed += ahn->LinkfailOriginsSuppressed();
                steers += ahn->DirectedSteers();
            }
            std::cout << " linkfailProp=" << lfProp
                      << " linkfailBudgetDrop=" << lfBudget
                      << " linkfailOrigSuppressed=" << lfSuppressed
                      << " directedSteers=" << steers;

            // Issue #133: pheromone-table size gauge at end of run. Per node
            // the table grows with destinations x neighbours (regular +
            // virtual) and only evaporation / link-failure removal shrink it,
            // so avg/max across nodes is the growth observable for long runs
            // (notably the enableEvaporation=false ablation).
            uint64_t ptRegSum = 0, ptRegMax = 0, ptVirSum = 0, ptVirMax = 0;
            uint32_t ptNodes = 0;
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<ns3::anthocnet::RoutingProtocol> ahn =
                    DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
                if (!ahn) continue;
                ++ptNodes;
                const uint64_t reg = ahn->PtableEntriesRegular();
                const uint64_t vir = ahn->PtableEntriesVirtual();
                ptRegSum += reg;
                ptVirSum += vir;
                if (reg > ptRegMax) ptRegMax = reg;
                if (vir > ptVirMax) ptVirMax = vir;
            }
            std::cout << " ptable[regAvg="
                      << (ptNodes ? static_cast<double>(ptRegSum) / ptNodes : 0.0)
                      << ",regMax=" << ptRegMax
                      << ",virAvg="
                      << (ptNodes ? static_cast<double>(ptVirSum) / ptNodes : 0.0)
                      << ",virMax=" << ptVirMax << "]";

            // Issue #21: pending-queue hold-time attribution. dOff50 is ~3 ms
            // (#88) so the delay/jitter gap vs AODV is carried by queue-held
            // packets; this splits the delivered hold time (and the aged-out
            // drops) across the setup / reconvergence / repair hold paths so
            // the dominant one can be attacked. Summed across nodes.
            const ns3::anthocnet::HoldStats& hs = r.hold;  // gathered above (#308)
            // #215: the repair-discard cause from both sides — the core's
            // simulator-agnostic event count (how many local repairs expired)
            // and the adapter's packet count (how much data each released).
            uint64_t repairEvents = 0, repairPkts = 0, macReinjected = 0;
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<ns3::anthocnet::RoutingProtocol> ahn =
                    DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
                if (!ahn) continue;
                repairEvents += ahn->RepairDiscards();
                repairPkts += ahn->RepairDiscardedPackets();
                macReinjected += ahn->MacReinjectedPackets();
            }
            static const char* kReasonName[3] = {"setup", "reconv", "repair"};
            std::cout << " hold[";
            for (uint8_t r = 0; r < ns3::anthocnet::kHoldReasons; ++r) {
                const double meanMs = hs.deliveredCount[r]
                    ? 1000.0 * hs.deliveredSumS[r] / hs.deliveredCount[r] : 0.0;
                std::cout << (r ? " " : "") << kReasonName[r] << "="
                          << hs.deliveredCount[r] << "/" << std::setprecision(1)
                          << meanMs << "ms/max" << std::setprecision(1)
                          << 1000.0 * hs.deliveredMaxS[r] << "ms";
            }
            std::cout << "] holdDrop[";
            for (uint8_t r = 0; r < ns3::anthocnet::kHoldReasons; ++r) {
                std::cout << (r ? " " : "") << kReasonName[r] << "="
                          << hs.droppedCount[r];
            }
            std::cout << "]"
                      << " repairDiscard=" << repairEvents << "ev/" << repairPkts
                      << "pkt macReinject=" << macReinjected;
        }
        std::cout << "\n";
    }

    // Queue-depth summary (#73): the distribution of per-node MAC backlog seen
    // over the run. High maxQ / pctNonzero => the A2 signal is present; ~0 even
    // at low PDR => loss is collision-dominated and A2 is structurally inert.
    if (g_qdiag) {
        const double mean = g_qCount ? g_qSum / g_qCount : 0.0;
        const double pct = g_qCount ? 100.0 * g_qNonzero / g_qCount : 0.0;
        std::cout << std::fixed << std::setprecision(2)
                  << "# qdiag " << proto << " seed=" << seed
                  << " pdr=" << r.pdr << " meanQ=" << mean << " maxQ=" << g_qMax
                  << " pctNonzero=" << pct << " samples=" << g_qCount << "\n";
    }

    // #296 item 1: the two things that make this arm a CONTROL rather than a
    // protocol, asserted rather than assumed.
    //
    // (a) Zero control traffic. The oracle opens no socket and sends nothing;
    //     if this ever fires, something in the arm started talking and its NRL
    //     stopped being an upper-bound reference point. NS_ABORT, not
    //     NS_ASSERT, so it holds in the optimized builds the campaign uses.
    // (b) The topology it routed on is reported, not guessed at afterwards:
    //     which adjacency rule was in force, whether that rule is exact for
    //     this channel, and how often it was re-solved. `approx=1` marks a
    //     cell whose oracle is an approximation (fading), which is what
    //     scenario_check reads to refuse to treat it as exact.
    if (proto == "oracle") {
        NS_ABORT_MSG_IF(g_controlPkts != 0 || g_controlBytes != 0,
                        "oracle arm transmitted " << g_controlPkts << " control packets ("
                        << g_controlBytes << " B): the control is supposed to put NOTHING on "
                        "the wire, so its NRL is no longer an upper-bound reference (#296)");
        Ptr<oracle::Topology> topo = oracleHelper.GetTopology();
        std::cout << "##ORACLE## " << seed << ' ' << proto
                  << " mode=" << topo->GetMode()
                  << " approx=" << (topo->IsApproximate() ? 1 : 0)
                  << " nodes=" << topo->GetNodeCount()
                  << " edges=" << topo->GetEdgeCount()
                  << " recomputes=" << topo->GetRecomputeCount()
                  << " changes=" << topo->GetTopologyChanges()
                  << " range=" << std::fixed << std::setprecision(1) << topo->GetLinkRange()
                  << " noRoute=" << topo->GetNoRouteCount()
                  << " nrl=" << std::fixed << std::setprecision(2) << r.nrl
                  << "\n";
    }

    Simulator::Destroy();
    return r;
}

}  // namespace

int main(int argc, char* argv[]) {
    // Sentinels (<0 / 0) mean "unset" so a preset or the legacy defaults fill in.
    std::string scenario;
    int32_t  nNodes = 0;
    double   simTime = -1, area = -1, areaX = -1, areaY = -1;
    double   speed = -1, pause = -1, range = -1, cbrBps = -1;
    int32_t  nFlows = 0;
    int32_t  sink = -1;
    uint32_t runs = 0;  // 0 = unset; resolved below (preset-dependent, #58)
    // #126: first RNG run of this invocation. Runs cover
    // firstRun..firstRun+runs-1, so one point's 20 seeds can be split across
    // dispatches that each fit the hosted-runner job ceiling (the 162/200-node
    // scale points exceed it at 20 seeds even on the -opt image). SetRun(s)
    // semantics are unchanged — the ##RUN##/##MATCH##/##COMMON## rows carry
    // the TRUE seed, so downstream per-seed pairing keeps working across
    // split dispatches. Default 1 keeps every existing invocation identical.
    uint32_t firstRun = 1;
    bool csv = false;
    std::string protocols = "anthocnet,aodv,olsr,dsdv";

    CommandLine cmd(__FILE__);
    cmd.AddValue("scenario", "Preset: 'paper' (Broch/CMU calibration field) or "
                             "'thesis' (AntHocNet's own evaluation field, "
                             "Ducatelle PhD 2007 §5.1.3 — #58)", scenario);
    cmd.AddValue("nNodes", "Number of nodes", nNodes);
    cmd.AddValue("time", "Simulation time (s)", simTime);
    cmd.AddValue("area", "Square area side (m); shorthand for areaX=areaY", area);
    cmd.AddValue("areaX", "Area width (m)", areaX);
    cmd.AddValue("areaY", "Area height (m)", areaY);
    cmd.AddValue("speed", "Max node speed (m/s)", speed);
    cmd.AddValue("pause", "Random-waypoint pause time (s)", pause);
    cmd.AddValue("range", "Transmission range (m); 0 = ns-3 default channel", range);
    cmd.AddValue("flows", "Number of CBR flows", nFlows);
    cmd.AddValue("cbrBps", "Per-flow CBR rate (bits/s)", cbrBps);
    cmd.AddValue("sink", "If >=0, all flows converge on this node (gateway "
                         "hotspot, #71) instead of i->(n-1-i) pairing", sink);
    cmd.AddValue("runs", "Number of RNG runs to average (seeds 1..runs); unset "
                         "= 1, or 20 for --scenario=thesis (#58)", runs);
    cmd.AddValue("firstRun", "First RNG run (seed) of this invocation; runs "
                             "cover firstRun..firstRun+runs-1, so a point's "
                             "seeds can split across dispatches (#126)",
                 firstRun);
    cmd.AddValue("csv", "Emit machine-readable CSV instead of a table", csv);
    cmd.AddValue("protocols",
                 "Comma-separated list (anthocnet,aodv,olsr,dsdv,gpsr,aomdv,oracle). "
                 "`oracle` is the #296 global-knowledge shortest-path CONTROL "
                 "(upper bound, zero control traffic), off unless named.",
                 protocols);
    cmd.AddValue("diag", "Emit per-run '# diag' lines (ant tallies, first delivery)", g_diag);
    cmd.AddValue("qdiag", "Emit per-run '# qdiag' lines: per-node MAC queue depth "
                          "distribution (meanQ/maxQ/pctNonzero) — does A2 have a "
                          "signal? (#73)", g_qdiag);
    std::string mobilityModel = "rwp";
    std::string transport = "udp";
    std::string propagation = "range";
    cmd.AddValue("transport",
                 "Transport (#63): 'udp' (CBR OnOff, default — what every "
                 "published number was measured under) | 'tcp' (saturating "
                 "BulkSend). A TCP cell is its own regime: pdr/thrput/nrl "
                 "change meaning and the reorder columns go absent; read "
                 "##GOODPUT##.",
                 transport);
    cmd.AddValue("mobility",
                 "Mobility model (#61): 'rwp' (Random Waypoint, default — the "
                 "model every published number was measured under) | 'ssrwp' "
                 "(steady-state RWP, no speed-decay transient) | 'gaussmarkov' "
                 "(smooth correlated tracks; --pause is inert under it)",
                 mobilityModel);
    cmd.AddValue("propagation",
                 "Propagation loss model: 'range' (disk) | 'tworay' (#24) | "
                 "'nakagami' (#60: the same two-ray path loss plus Nakagami-m "
                 "fading, so tworay-vs-nakagami isolates fading alone). "
                 "--range is inert under tworay and nakagami.",
                 propagation);
    std::string rateManager = "constant2";
    cmd.AddValue("rateManager",
                 "Rate control: constant1|constant2|constant5|constant11 (fixed "
                 "DSSS rate; default constant2, the paper's radio) | arf | ideal "
                 "(ns-3 default; loses ~50% single-hop, #51)", rateManager);
    // #209 energy model. Defaults and their provenance: see the kDefault*
    // block above. Overridable because they are modelling choices, not
    // measurements of this scenario's radio.
    double energyJ = kDefaultEnergyJ;
    double voltageV = kDefaultVoltageV;
    double txCurrentA = kDefaultTxCurrentA;
    double rxCurrentA = kDefaultRxCurrentA;
    double idleCurrentA = kDefaultIdleCurrentA;
    cmd.AddValue("energyJ", "Initial energy per node (J); default 5000 is sized "
                            "so no node dies in a 900 s run (#209). 0 disables "
                            "energy accounting; energy columns then read 0",
                 energyJ);
    cmd.AddValue("voltageV", "Energy-source supply voltage (V)", voltageV);
    cmd.AddValue("txCurrentA", "Radio transmit current (A)", txCurrentA);
    cmd.AddValue("rxCurrentA", "Radio receive current (A)", rxCurrentA);
    cmd.AddValue("idleCurrentA", "Radio idle current (A); also applied to the "
                                 "CCA-busy and switching states", idleCurrentA);
    // #217: the window over which concurrently-used next hops are counted.
    // Carried into the CSV (path_div_window_s) because it defines what the
    // diversity number means — see the path-diversity block above main().
    double pathWindowS = kDefaultPathWindowS;
    cmd.AddValue("pathWindowS", "Window (s) over which distinct next hops used "
                                "for a destination are counted as concurrent "
                                "paths (#217); default 10", pathWindowS);
    cmd.Parse(argc, argv);

    // 'paper' = the Broch/CMU MobiCom'98 field (the literature *calibration*
    // anchor, #24). 'thesis' = AntHocNet's own evaluation field, read from
    // Ducatelle, "Adaptive Routing in Ad Hoc Wireless Multi-hop Networks"
    // (PhD thesis, 2007) **§5.1.3** — quoted values, no longer reconstructed
    // (#58). Fidelity claims run on 'thesis', calibration on 'paper'.
    //
    //   nodes        100
    //   area         2400 x 800 m   ("move in a rectangular area of 2400 x 800m²")
    //   mobility     RWP, speed U[0,10] m/s, pause 30 s  ("a minimum and maximum
    //                speed of respectively 0 and 10 m/s, and a pause time of 30 s")
    //   duration     900 s, repeated 20 times  ("Each experiment has a duration
    //                of 900 s, and is repeated 20 times")
    //   traffic      20 UDP sessions, 4 x 64-byte packets/s = 2048 bps  ("Each
    //                session generates 4 packets of 64 bytes per second")
    //   start window uniform in [0, 180] s
    //   radio        802.11 DCF at 2 Mbit/s; range 250 m  ("The estimated radio
    //                range is 250 m")
    //
    // Before #58's PDF pass this preset carried five wrong constants (3000x1000 m,
    // 20 m/s, 512 bps, 300 m range, 5 runs), all inherited from 'paper' or from a
    // secondary-source reconstruction. Provenance is spelled out inline on
    // purpose: unsourced numbers caused #88, #169 and #173.
    //
    // Two axes are deliberately NOT forced by the preset:
    //  - **propagation**: the thesis uses a **two-ray** model; this harness
    //    defaults to the `range` disk model (the #24 calibration disentangler,
    //    a global default we do not change per-preset). Pass
    //    `--propagation=tworay` to match §5.1.3.
    //  - **repetitions**: `--runs` defaults to 20 for this preset only (see
    //    below), but any explicit `--runs=N` wins — and run-scenarios.py and
    //    both benchmark workflows always pass one. Reproducing a thesis figure
    //    through those means setting runs=20 there.
    // See docs/benchmarks/methodology.md ("Reproducing a thesis run").
    const bool thesis = (scenario == "thesis");
    const bool paper = (scenario == "paper") || thesis;
    // #58: the thesis averages 20 repetitions; everything else keeps the
    // historical default of 1. Explicit --runs=N always overrides.
    if (runs < 1) runs = thesis ? 20 : 1;
    Params P;
    P.nNodes  = nNodes > 0 ? static_cast<uint32_t>(nNodes)
                           : (thesis ? 100 : paper ? 50 : 20);
    P.simTime = simTime >= 0 ? simTime : (paper ? 900.0 : 40.0);
    P.areaX   = areaX >= 0 ? areaX
                           : (area >= 0 ? area : (thesis ? 2400.0 : paper ? 1500.0 : 300.0));
    P.areaY   = areaY >= 0 ? areaY
                           : (area >= 0 ? area : (thesis ? 800.0 : paper ? 300.0 : 300.0));
    P.speed   = speed >= 0 ? speed : (thesis ? 10.0 : paper ? 20.0 : 5.0);
    P.pause   = pause >= 0 ? pause : (paper ? 30.0 : 1.0);
    P.range   = range >= 0 ? range : (thesis ? 250.0 : paper ? 300.0 : 0.0);
    P.nFlows  = nFlows > 0 ? static_cast<uint32_t>(nFlows) : (paper ? 20 : 5);
    P.cbrBps  = cbrBps >= 0 ? cbrBps : (thesis ? 2048.0 : paper ? 512.0 : 8000.0);
    P.startWindow = paper ? 180.0 : 5.0;
    // An explicitly empty --propagation= has always meant "the default", and
    // scenario-matrix.yml documents its blank input that way; normalise it
    // rather than letting the guard below reject a working dispatch.
    if (propagation.empty()) propagation = "range";
    P.propagation = propagation;
    NS_ABORT_MSG_UNLESS(propagation == "range" || propagation == "tworay" ||
                            propagation == "nakagami",
                        "unknown --propagation='" << propagation
                        << "' (expected range|tworay|nakagami). Refusing rather "
                           "than falling through to a default channel: the "
                           "silent fallback would produce a plausible run of "
                           "the wrong channel (#60).");
    P.mobility = mobilityModel;
    P.transport = transport;
    NS_ABORT_MSG_UNLESS(transport == "udp" || transport == "tcp",
                        "unknown --transport='" << transport
                        << "' (expected udp|tcp). Refusing rather than "
                           "defaulting to udp: a typo would silently produce a "
                           "UDP run labelled as a TCP one (#63).");
    NS_ABORT_MSG_UNLESS(mobilityModel == "rwp" || mobilityModel == "ssrwp" ||
                            mobilityModel == "gaussmarkov",
                        "unknown --mobility='" << mobilityModel
                        << "' (expected rwp|ssrwp|gaussmarkov). Refusing rather "
                           "than silently falling back to rwp: a typo would "
                           "otherwise produce a plausible run of the wrong "
                           "model (#61).");
    P.rateManager = rateManager;
    P.sink = sink;
    P.energyJ = energyJ;
    P.voltageV = voltageV;
    P.txCurrentA = txCurrentA;
    P.rxCurrentA = rxCurrentA;
    P.idleCurrentA = idleCurrentA;
    P.pathWindowS = pathWindowS > 0.0 ? pathWindowS : kDefaultPathWindowS;

    // 1 ms delay bins for the 99th-percentile computation.
    Config::SetDefault("ns3::FlowMonitor::DelayBinWidth", DoubleValue(0.001));

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) {
        if (!item.empty()) list.push_back(item);
    }

    // Each protocol: mean over runs (every protocol sees the same seed set).
    // #28: also sample stddev across runs (0 when runs==1) so published numbers
    // carry dispersion. Offered-load percentiles use -1 as "infinite": any
    // infinite run makes the aggregate infinite (monotone-honest, like the
    // metric itself).
    struct Agg {
        double pdr = 0, delay = 0, delay99 = 0, thrput = 0, nrl = 0;
        double nrlBytes = 0;  // #132
        double jitter = 0, dOff50 = 0, dOff90 = 0;
        double jitterEq51 = 0;  // #89
        double pdrSq = 0, delaySq = 0, delay99Sq = 0, nrlSq = 0, nrlBytesSq = 0;
        bool off50Inf = false, off90Inf = false;
        double pdrSd = 0, delaySd = 0, delay99Sd = 0, nrlSd = 0, nrlBytesSd = 0;
        // #209: energy means across runs. firstDeath is averaged over the runs
        // that actually saw a death (deathRuns); -1 when no run did.
        double energy = 0, energyPerPkt = 0;
        double resMin = 0, resMean = 0, resSd = 0;
        double firstDeath = 0;
        uint32_t deathRuns = 0;
        // #212 reordering. The *Max fields are averaged across runs like every
        // other column: a mean of per-run maxima, not a max over runs.
        double reordRatio = 0, reordRatioMax = 0;
        double reordExtMean = 0, reordExtMax = 0, reordBufMax = 0;
        // #215: drop-cause means across runs. dropNa latches when a cause does
        // not apply to this protocol, so the mean stays the -1 "not applicable"
        // sentinel and is emitted blank rather than as a measured 0.
        double dropRoute = 0, dropQueue = 0, dropMac = 0, dropChan = 0, dropTtl = 0;
        double dropSetup = 0, dropReconv = 0, dropRepair = 0, dropOther = 0;
        bool dropNa = false;
        // #217: route-quality means across runs. hopsMax/divMax are averaged
        // like every other column rather than maxed, so they stay comparable
        // with the per-run rows and with the mean columns beside them.
        double hopsMean = 0, hopsMax = 0;
        double divUsed = 0, divMax = 0, divEntropy = 0, jain = 0;
    };
    std::vector<Agg> agg(list.size());
    // #308: per (protocol, run), enough of the delivered-delay distribution to
    // re-take a percentile at another protocol's delivery count. Protocols run
    // outermost, so the comparison is only possible after the whole grid exists.
    struct MatchCell {
        std::map<uint32_t, uint64_t> hist;
        double   binWidth = 0.0;
        uint64_t rx = 0;
        double   delay99Ms = 0.0;
        std::map<Address, std::map<uint32_t, double>> bySeq;  // #308
        std::map<Address, std::map<uint32_t, uint32_t>> hopsBySeq;  // #308 phase 2
    };
    // #308/#369: record what this invocation actually ran, in the compact
    // block, before any result row. A benchmark number is only reproducible if
    // the configuration behind it is recoverable, and until now it was not:
    // the effective knobs lived solely in the workflow's command echo, which
    // sits ~900 lines above the cheap tail and vanishes entirely if the run is
    // cancelled before it finishes. Three hold-cap ablation arms were lost
    // exactly that way -- cancelled before pickup, logs since expired, and the
    // `--ns3::...::ReconvHoldCap=` values they were dispatched with are simply
    // gone. Emitting them here makes the run self-describing.
    //
    // Deliberately `key=value` rather than positional fields, unlike ##RUN##:
    // a mis-read position in a provenance row would misattribute a whole
    // campaign, and there is no `# stddev` cross-check to catch it the way
    // there is for the metric columns.
    std::cout << "##CONFIG## scenario=" << scenario
              << " nNodes=" << P.nNodes << " time=" << P.simTime
              << " runs=" << runs << " firstRun=" << firstRun
              << " areaX=" << P.areaX << " areaY=" << P.areaY
              << " speed=" << P.speed << " pause=" << P.pause
              << " range=" << P.range << " propagation=" << P.propagation
              << " mobility=" << P.mobility
              << " transport=" << P.transport
              << " flows=" << P.nFlows << " cbrBps=" << P.cbrBps
              << " rateManager=" << P.rateManager
              << " protocols=" << protocols << '\n';
    // Every AntHocNet attribute at its *effective* value. ns-3 routes
    // `--ns3::anthocnet::RoutingProtocol::X=Y` through Config::SetDefault,
    // which rewrites the TypeId's stored initial value -- so reading it back
    // here reports overrides and compiled defaults alike, and any lever a
    // future sweep adds is carried without touching this code. Baseline
    // protocols' attributes are not dumped: nothing in this repo sweeps them,
    // and the row is provenance for our own knobs.
    {
        TypeId tid;
        if (TypeId::LookupByNameFailSafe("ns3::anthocnet::RoutingProtocol", &tid)) {
            // std::size_t rather than decltype(GetAttributeN()): the return
            // type changed from uint32_t to std::size_t across the ns-3
            // versions in the matrix, and both convert to std::size_t without
            // a sign-compare warning.
            const std::size_t nAttr = tid.GetAttributeN();
            for (std::size_t a = 0; a < nAttr; ++a) {
                const TypeId::AttributeInformation info = tid.GetAttribute(a);
                if (!info.initialValue || !info.checker) continue;
                std::cout << "##CONFIG## attr " << info.name << '='
                          << info.initialValue->SerializeToString(info.checker)
                          << '\n';
            }
        }
    }
    // #63: on a TCP run, the congestion-control variant IS part of the
    // configuration -- ns-3's default has changed across releases, so a cell
    // that does not record it is not reproducible against a future image.
    if (P.transport == "tcp") {
        TypeId tcpTid;
        if (TypeId::LookupByNameFailSafe("ns3::TcpL4Protocol", &tcpTid)) {
            const std::size_t nT = tcpTid.GetAttributeN();
            for (std::size_t a = 0; a < nT; ++a) {
                const TypeId::AttributeInformation info = tcpTid.GetAttribute(a);
                if (info.name != "SocketType") continue;
                if (!info.initialValue || !info.checker) break;
                std::cout << "##CONFIG## attr ns3::TcpL4Protocol::SocketType="
                          << info.initialValue->SerializeToString(info.checker)
                          << '\n';
                break;
            }
        }
    }
    std::vector<std::vector<MatchCell>> matchGrid(
        list.size(), std::vector<MatchCell>(runs));
    for (std::size_t i = 0; i < list.size(); ++i) {
        for (uint32_t s = firstRun; s < firstRun + runs; ++s) {
            Result r = RunOne(list[i], P, s);
            MatchCell& mc = matchGrid[i][s - firstRun];
            mc.hist = r.delayHist;
            mc.binWidth = r.delayBinWidth;
            mc.rx = r.rxPackets;
            mc.delay99Ms = r.delay99Ms;
            mc.bySeq = r.rxDelayBySeq;
            mc.hopsBySeq = r.rxHopsBySeq;
            // #128: per-run (per-seed) row for paired statistics. Every
            // protocol sees the identical RNG realisation per run, so
            // downstream can pair rows by run number (per-seed deltas, sign
            // tests) — far more powerful at small `runs` than the unpaired
            // mean±sd. Same field order/precision as the final table and the
            // workflow's ##BENCH## re-emit; dOff percentiles print "inf" like
            // the table when -1 (infinite).
            std::cout << std::fixed << "##RUN## " << s << ' ' << list[i]
                      << ' ' << std::setprecision(1) << r.pdr
                      << ' ' << std::setprecision(1) << r.meanDelayMs
                      << ' ' << std::setprecision(1) << r.delay99Ms
                      << ' ' << std::setprecision(2) << r.throughputKbps
                      << ' ' << std::setprecision(2) << r.nrl
                      << ' ' << std::setprecision(2) << r.jitterMs;
            for (double v : {r.dOff50Ms, r.dOff90Ms}) {
                if (v < 0) std::cout << " inf";
                else std::cout << ' ' << std::setprecision(1) << v;
            }
            // #132: keep the per-run row field-aligned with the mean row, so
            // paired per-seed statistics cover nrl_bytes too.
            std::cout << ' ' << std::setprecision(4) << r.nrlBytes;
            std::cout << "\n";
            // #308 phase 2 step 3: channel occupancy, per run so it pairs on
            // identical seeds like every other per-seed row. Its own marker
            // rather than extra ##RUN## columns, for the reason ##MATCH## and
            // ##COMMON## have their own: the ##RUN## field order is consumed
            // positionally, so appending there would shift downstream mappings.
            // Reported as a fraction of node-time rather than raw seconds so
            // the number does not silently depend on --nNodes or --time:
            // busyPct is what one node saw the medium occupied, on average.
            // #308 phase 2 step 4: pending-queue hold time, per run so it pairs
            // on identical seeds. Emitted ONLY for a protocol that actually has
            // the instrumentation — i.e. AntHocNet. AODV also queues packets
            // during route discovery (aodv::RequestQueue) and OLSR/DSDV do not
            // queue at all, but none of them is measured here, so printing a row
            // of zeros for them would assert "this protocol never held a packet"
            // when the truth is "nobody looked". Absence is the honest encoding,
            // and it is the same rule ##AIR## follows for --energyJ=0.
            if (r.holdValid) {
                std::cout << std::fixed << "##HOLD## " << s << ' ' << list[i];
                for (uint8_t hr = 0; hr < ns3::anthocnet::kHoldReasons; ++hr) {
                    const double meanMs = r.hold.deliveredCount[hr]
                        ? 1000.0 * r.hold.deliveredSumS[hr] / r.hold.deliveredCount[hr]
                        : 0.0;
                    std::cout << ' ' << r.hold.deliveredCount[hr]
                              << ' ' << std::setprecision(2) << meanMs
                              << ' ' << std::setprecision(2)
                              << 1000.0 * r.hold.deliveredMaxS[hr];
                }
                std::cout << "\n";
            }
            if (r.airTxS >= 0.0) {
                const double nodeSeconds =
                    static_cast<double>(P.nNodes) * P.simTime;
                const double busy = r.airTxS + r.airRxS + r.airCcaS;
                std::cout << std::fixed << "##AIR## " << s << ' ' << list[i]
                          << ' ' << std::setprecision(3) << r.airTxS
                          << ' ' << std::setprecision(3) << r.airRxS
                          << ' ' << std::setprecision(3) << r.airCcaS
                          << ' ' << std::setprecision(4)
                          << (nodeSeconds > 0.0 ? 100.0 * busy / nodeSeconds : 0.0)
                          << "\n";
            }
            // #63: application bytes delivered per second, from the
            // PacketSinks. Emitted on every run, not only TCP ones: on UDP it
            // should track the thrput column, and that agreement is the
            // cross-check that the metric is wired correctly. On TCP the gap
            // between the two is the retransmission overhead, and ##GOODPUT##
            // -- not pdr, not thrput -- is the cell's headline.
            std::cout << std::fixed << "##GOODPUT## " << s << ' ' << list[i]
                      << ' ' << std::setprecision(3) << r.goodputKbps << "\n";
            agg[i].pdr += r.pdr;
            agg[i].delay += r.meanDelayMs;
            agg[i].delay99 += r.delay99Ms;
            agg[i].thrput += r.throughputKbps;
            agg[i].nrl += r.nrl;
            agg[i].nrlBytes += r.nrlBytes;
            agg[i].jitter += r.jitterMs;
            agg[i].jitterEq51 += r.jitterEq51Ms;  // #89
            agg[i].pdrSq += r.pdr * r.pdr;
            agg[i].delaySq += r.meanDelayMs * r.meanDelayMs;
            agg[i].delay99Sq += r.delay99Ms * r.delay99Ms;
            agg[i].nrlSq += r.nrl * r.nrl;
            agg[i].nrlBytesSq += r.nrlBytes * r.nrlBytes;
            if (r.dOff50Ms < 0) agg[i].off50Inf = true; else agg[i].dOff50 += r.dOff50Ms;
            if (r.dOff90Ms < 0) agg[i].off90Inf = true; else agg[i].dOff90 += r.dOff90Ms;
            agg[i].energy += r.energyJ;
            agg[i].energyPerPkt += r.energyPerPktJ;
            agg[i].resMin += r.resMinJ;
            agg[i].resMean += r.resMeanJ;
            agg[i].resSd += r.resSdJ;
            if (r.firstDeathS >= 0.0) {
                agg[i].firstDeath += r.firstDeathS;
                ++agg[i].deathRuns;
            }
            agg[i].reordRatio += r.reorderRatio;
            agg[i].reordRatioMax += r.reorderRatioMax;
            agg[i].reordExtMean += r.reorderExtMean;
            agg[i].reordExtMax += r.reorderExtMax;
            agg[i].reordBufMax += r.reorderBufMax;
            agg[i].dropRoute += r.dropRoutePct;
            agg[i].dropQueue += r.dropQueuePct;
            agg[i].dropMac += r.dropMacPct;
            agg[i].dropChan += r.dropChanPct;
            agg[i].dropTtl += r.dropTtlPct;
            agg[i].dropOther += r.dropOtherPct;
            if (r.dropSetupPct < 0.0) {
                agg[i].dropNa = true;  // #215: cause not applicable to this arm
            } else {
                agg[i].dropSetup += r.dropSetupPct;
                agg[i].dropReconv += r.dropReconvPct;
                agg[i].dropRepair += r.dropRepairPct;
            }
            agg[i].hopsMean += r.hopsMean;
            agg[i].hopsMax += r.hopsMax;
            agg[i].divUsed += r.divUsed;
            agg[i].divMax += r.divMax;
            agg[i].divEntropy += r.divEntropyBits;
            agg[i].jain += r.jain;
        }
        agg[i].pdr /= runs;
        agg[i].delay /= runs;
        agg[i].delay99 /= runs;
        agg[i].thrput /= runs;
        agg[i].nrl /= runs;
        agg[i].nrlBytes /= runs;
        agg[i].jitter /= runs;
        agg[i].jitterEq51 /= runs;  // #89
        agg[i].dOff50 = agg[i].off50Inf ? -1.0 : agg[i].dOff50 / runs;
        agg[i].dOff90 = agg[i].off90Inf ? -1.0 : agg[i].dOff90 / runs;
        agg[i].energy /= runs;
        agg[i].energyPerPkt /= runs;
        agg[i].resMin /= runs;
        agg[i].resMean /= runs;
        agg[i].resSd /= runs;
        agg[i].firstDeath = agg[i].deathRuns
            ? agg[i].firstDeath / agg[i].deathRuns : -1.0;
        agg[i].reordRatio /= runs;
        agg[i].reordRatioMax /= runs;
        agg[i].reordExtMean /= runs;
        agg[i].reordExtMax /= runs;
        agg[i].reordBufMax /= runs;
        agg[i].dropRoute /= runs;
        agg[i].dropQueue /= runs;
        agg[i].dropMac /= runs;
        agg[i].dropChan /= runs;
        agg[i].dropTtl /= runs;
        agg[i].dropOther /= runs;
        if (agg[i].dropNa) {
            agg[i].dropSetup = agg[i].dropReconv = agg[i].dropRepair = -1.0;
        } else {
            agg[i].dropSetup /= runs;
            agg[i].dropReconv /= runs;
            agg[i].dropRepair /= runs;
        }
        agg[i].hopsMean /= runs;
        agg[i].hopsMax /= runs;
        agg[i].divUsed /= runs;
        agg[i].divMax /= runs;
        agg[i].divEntropy /= runs;
        agg[i].jain /= runs;
        if (runs > 1) {
            auto sd = [runs](double sum, double sumSq) {
                const double mean = sum / runs;
                const double var = (sumSq - runs * mean * mean) / (runs - 1);
                return var > 0.0 ? std::sqrt(var) : 0.0;
            };
            agg[i].pdrSd = sd(agg[i].pdr * runs, agg[i].pdrSq);
            agg[i].delaySd = sd(agg[i].delay * runs, agg[i].delaySq);
            agg[i].delay99Sd = sd(agg[i].delay99 * runs, agg[i].delay99Sq);
            agg[i].nrlSd = sd(agg[i].nrl * runs, agg[i].nrlSq);
            agg[i].nrlBytesSd = sd(agg[i].nrlBytes * runs, agg[i].nrlBytesSq);
        }
    }

    // -----------------------------------------------------------------------
    // #308: matched-delivery 99th-percentile delay.
    //
    // delay99 compares tails over delivered sets of different sizes. AntHocNet
    // delivers ~10 pp more than AODV, and some of that surplus is exactly the
    // packets that waited through a reconvergence — so part of its worse tail
    // may be the packets AODV never delivered at all rather than slower
    // service of the packets both carry.
    //
    // Per run, take the smallest delivered count across the protocols
    // (`rxMin`) and re-read every protocol's 99th percentile at that *absolute*
    // count: the delay below which 0.99*rxMin of its packets arrived. For the
    // protocol that delivered fewest this is its own delay99; for the others it
    // is the tail of their fastest rxMin packets.
    //
    // Read it in one direction only. If the gap persists after truncation, the
    // delivery surplus cannot account for it — that is conclusive. If the gap
    // closes, it is *consistent with* the surplus explaining the tail but does
    // not establish it, because truncating the slowest packets assumes the
    // surplus is the slow ones rather than showing it. Treat a closing gap as
    // grounds for the per-packet attribution in #308's phase 1, not as its
    // answer.
    //
    // Emitted as ##MATCH## rather than extra ##RUN## columns: the ##RUN##
    // field order is consumed positionally by bench_parse.py and by the CI
    // campaign scripts, and appending to it would silently shift their mapping.
    {
        auto quantileAt = [](const MatchCell& c, uint64_t targetCount) {
            if (c.binWidth <= 0.0 || targetCount == 0) return -1.0;
            uint64_t cum = 0;
            for (const auto& kv : c.hist) {
                cum += kv.second;
                if (cum >= targetCount)
                    return 1000.0 * (kv.first + 0.5) * c.binWidth;
            }
            return -1.0;  // fewer deliveries than the target: undefined here
        };
        for (uint32_t s = firstRun; s < firstRun + runs; ++s) {
            uint64_t rxMin = 0;
            bool have = false;
            for (std::size_t i = 0; i < list.size(); ++i) {
                const uint64_t rx = matchGrid[i][s - firstRun].rx;
                if (!have || rx < rxMin) { rxMin = rx; have = true; }
            }
            if (!have || rxMin == 0) continue;
            const uint64_t target = static_cast<uint64_t>(0.99 * rxMin);
            for (std::size_t i = 0; i < list.size(); ++i) {
                const MatchCell& c = matchGrid[i][s - firstRun];
                const double matched = quantileAt(c, target);
                std::cout << std::fixed << "##MATCH## " << s << ' ' << list[i]
                          << ' ' << c.rx << ' ' << rxMin
                          << ' ' << std::setprecision(1) << c.delay99Ms << ' ';
                if (matched < 0) std::cout << "na";
                else std::cout << std::setprecision(1) << matched;
                std::cout << "\n";
            }
        }
    }

    // -----------------------------------------------------------------------
    // #308 phase 1: like-for-like tail over the packets EVERY protocol carried.
    //
    // ##MATCH## above bounds the survivorship confound but cannot remove it: it
    // truncates by *rank*, which assumes the surplus deliveries are the slowest
    // ones. Keying by packet identity removes the assumption entirely. Intersect
    // the delivered (flow, seq) sets across protocols and report each protocol's
    // tail over that common set — same packets, same seeds, both delivered, so
    // no population difference remains to confound the comparison.
    //
    // The surplus tail is reported beside it, because that is the hypothesis
    // ##MATCH## could only assume: if a protocol's extra deliveries really are
    // its slow ones, its surplus tail is far above its common tail.
    //
    // Cross-protocol keying relies on the (source IP, source port) of a flow
    // being identical across protocols in the same run. It is — the topology,
    // addressing and application construction are identical and seeded
    // identically, only the routing protocol differs — but it is an assumption
    // the output makes checkable rather than hidden: nCommon collapsing toward
    // zero means the keys did not line up, which no real routing difference
    // could cause.
    {
        auto pct = [](std::vector<double>& v, double q) {
            if (v.empty()) return -1.0;
            std::sort(v.begin(), v.end());
            std::size_t i = static_cast<std::size_t>(q * v.size());
            if (i >= v.size()) i = v.size() - 1;
            return 1000.0 * v[i];
        };
        for (uint32_t s = firstRun; s < firstRun + runs; ++s) {
            // Keys delivered by every protocol this run.
            std::set<std::pair<Address, uint32_t>> common;
            bool first = true;
            for (std::size_t i = 0; i < list.size(); ++i) {
                std::set<std::pair<Address, uint32_t>> mine;
                for (const auto& f : matchGrid[i][s - firstRun].bySeq)
                    for (const auto& kv : f.second) mine.insert({f.first, kv.first});
                if (first) { common = mine; first = false; continue; }
                std::set<std::pair<Address, uint32_t>> both;
                std::set_intersection(common.begin(), common.end(),
                                      mine.begin(), mine.end(),
                                      std::inserter(both, both.begin()));
                common.swap(both);
            }
            if (common.empty()) continue;
            for (std::size_t i = 0; i < list.size(); ++i) {
                std::vector<double> inCommon, surplus;
                std::size_t nSelf = 0;
                for (const auto& f : matchGrid[i][s - firstRun].bySeq) {
                    for (const auto& kv : f.second) {
                        ++nSelf;
                        if (common.count({f.first, kv.first})) inCommon.push_back(kv.second);
                        else surplus.push_back(kv.second);
                    }
                }
                // #308 phase 2: the same split over hop counts. Averaged over
                // exactly the packets whose delays produced meanCommon, so
                // meanCommon / hopsCommon is a per-hop cost on one population
                // instead of a quotient of two differently-sized ones.
                uint64_t hopSumC = 0, hopNC = 0, hopSumS = 0, hopNS = 0;
                for (const auto& f : matchGrid[i][s - firstRun].hopsBySeq) {
                    for (const auto& kv : f.second) {
                        if (common.count({f.first, kv.first})) {
                            hopSumC += kv.second;
                            ++hopNC;
                        } else {
                            hopSumS += kv.second;
                            ++hopNS;
                        }
                    }
                }
                const double p99c = pct(inCommon, 0.99);
                const double meanc = inCommon.empty() ? -1.0 :
                    1000.0 * std::accumulate(inCommon.begin(), inCommon.end(), 0.0)
                    / inCommon.size();
                const double p99s = pct(surplus, 0.99);
                const double hopsc = hopNC ? static_cast<double>(hopSumC) / hopNC : -1.0;
                const double hopss = hopNS ? static_cast<double>(hopSumS) / hopNS : -1.0;
                std::cout << std::fixed << "##COMMON## " << s << ' ' << list[i]
                          << ' ' << nSelf << ' ' << common.size()
                          << ' ' << std::setprecision(1) << p99c
                          << ' ' << std::setprecision(1) << meanc << ' ';
                if (p99s < 0) std::cout << "na";
                else std::cout << std::setprecision(1) << p99s;
                // Appended, never inserted: the fields above are consumed
                // positionally by the issue-thread tooling and docs/benchmarks.
                std::cout << ' ';
                if (hopsc < 0) std::cout << "na";
                else std::cout << std::setprecision(3) << hopsc;
                std::cout << ' ';
                if (hopss < 0) std::cout << "na";
                else std::cout << std::setprecision(3) << hopss;
                std::cout << "\n";
            }
        }
    }

    if (csv) {
        // Field order through throughput_kbps is stable (downstream parsers rely
        // on it); later columns are append-only (consumers read by header name):
        // delay99_ms/nrl, then #57 jitter + offered-load percentiles (-1 = inf),
        // then #28 per-metric sample stddev across runs (0 when runs==1), then
        // #132 nrl_bytes (control bytes / delivered data bytes), then #209
        // energy (total consumed, per delivered packet, residual spread across
        // nodes, the initial energy the run was configured with, and the
        // first-node-death time with -1 = no node died), then #212
        // reordering (out-of-order ratio pooled over flows and for the worst
        // single flow, reordering extent mean/max, reorder-buffer occupancy),
        // then #215's drop-cause breakdown: the five protocol-agnostic
        // causes (which sum with pdr_pct to ~100), then the three AntHocNet-only
        // ones, which are a sub-breakdown of drop_route_pct and are **blank**
        // for the other protocols (blank = the cause does not exist there;
        // 0 would mean it exists and never fired), then #217 route
        // quality (hop count of delivered packets, *used* next-hop diversity
        // and the entropy of that split, the window those are counted over,
        // and Jain's fairness index across flows).
        std::cout << "protocol,runs,nNodes,area,speed,flows,pdr_pct,delay_ms,"
                     "throughput_kbps,delay99_ms,nrl,jitter_ms,delay_off50_ms,"
                     "delay_off90_ms,pdr_sd,delay_sd,delay99_sd,nrl_sd,"
                     "nrl_bytes,energy_j,energy_per_pkt_j,energy_res_min_j,"
                     "energy_res_mean_j,energy_res_sd_j,energy_init_j,"
                     "first_death_s,reorder_ratio,reorder_ratio_max,"
                     "reorder_extent_mean,reorder_extent_max,"
                     "reorder_buf_max,drop_route_pct,drop_queue_pct,"
                     "drop_mac_pct,"
                     "drop_chan_pct,drop_ttl_pct,drop_setup_pct,"
                     "drop_reconv_pct,drop_repair_pct,"
                     "path_hops_mean,path_hops_max,"
                     "path_div_used,path_div_max,path_entropy_bits,"
                     "path_div_window_s,jain_pkts,jitter_eq51_ms\n";
        std::cout << std::fixed;
        // Blank, not zero, when a cause does not apply to this protocol (#215).
        auto optPct = [](double v) {
            std::ostringstream o;
            if (v >= 0.0) o << std::fixed << std::setprecision(3) << v;
            return o.str();
        };
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << list[i] << ',' << runs << ',' << P.nNodes << ','
                      << std::setprecision(0) << P.areaX << ','
                      << std::setprecision(0) << P.speed << ',' << P.nFlows << ','
                      << std::setprecision(1) << agg[i].pdr << ','
                      << std::setprecision(1) << agg[i].delay << ','
                      << std::setprecision(2) << agg[i].thrput << ','
                      << std::setprecision(1) << agg[i].delay99 << ','
                      << std::setprecision(3) << agg[i].nrl << ','
                      << std::setprecision(2) << agg[i].jitter << ','
                      << std::setprecision(1) << agg[i].dOff50 << ','
                      << std::setprecision(1) << agg[i].dOff90 << ','
                      << std::setprecision(2) << agg[i].pdrSd << ','
                      << std::setprecision(1) << agg[i].delaySd << ','
                      << std::setprecision(1) << agg[i].delay99Sd << ','
                      << std::setprecision(3) << agg[i].nrlSd << ','
                      << std::setprecision(3) << agg[i].nrlBytes << ','
                      << std::setprecision(2) << agg[i].energy << ','
                      << std::setprecision(4) << agg[i].energyPerPkt << ','
                      << std::setprecision(2) << agg[i].resMin << ','
                      << std::setprecision(2) << agg[i].resMean << ','
                      << std::setprecision(3) << agg[i].resSd << ','
                      << std::setprecision(2) << P.energyJ << ','
                      << std::setprecision(1) << agg[i].firstDeath << ','
                      << std::setprecision(4) << agg[i].reordRatio << ','
                      << std::setprecision(4) << agg[i].reordRatioMax << ','
                      << std::setprecision(2) << agg[i].reordExtMean << ','
                      << std::setprecision(2) << agg[i].reordExtMax << ','
                      << std::setprecision(2) << agg[i].reordBufMax << ','
                      << std::setprecision(3) << agg[i].dropRoute << ','
                      << std::setprecision(3) << agg[i].dropQueue << ','
                      << std::setprecision(3) << agg[i].dropMac << ','
                      << std::setprecision(3) << agg[i].dropChan << ','
                      << std::setprecision(3) << agg[i].dropTtl << ','
                      << optPct(agg[i].dropSetup) << ','
                      << optPct(agg[i].dropReconv) << ','
                      << optPct(agg[i].dropRepair) << ','
                      << std::setprecision(2) << agg[i].hopsMean << ','
                      << std::setprecision(1) << agg[i].hopsMax << ','
                      << std::setprecision(3) << agg[i].divUsed << ','
                      << std::setprecision(1) << agg[i].divMax << ','
                      << std::setprecision(3) << agg[i].divEntropy << ','
                      << std::setprecision(1) << P.pathWindowS << ','
                      << std::setprecision(4) << agg[i].jain << ','
                      // #89: appended last — the CSV is append-only and
                      // consumers read by header name.
                      << std::setprecision(2) << agg[i].jitterEq51 << '\n';
        }
        return 0;
    }

    std::cout << "AntHocNet protocol comparison (mean of " << runs << " run(s))\n"
              << "  nodes=" << P.nNodes << " time=" << P.simTime << "s area="
              << P.areaX << "x" << P.areaY << "m maxSpeed=" << P.speed
              << "m/s pause=" << P.pause << "s flows=" << P.nFlows
              << (P.sink >= 0 ? " sink=" + std::to_string(P.sink) : "") << "\n\n";
    // First six fields (proto..NRL) are position-stable: the workflows' compact
    // ##BENCH## re-emit and bench_parse.py read them by position. The #57 QoS
    // columns (jitter, offered-load 90th pct) are appended to the right, then
    // #132 nrl_bytes (control bytes / delivered data bytes), then #209's two
    // headline energy columns. paper-benchmark.yml's ##BENCH## awk re-emits
    // fields $1..$10, so anything from nrlBytes rightwards is table-only —
    // appending here cannot disturb it. The remaining #209 numbers (residual
    // spread, first death) go on the '# energy' lines below, the way #28's
    // dispersion does, rather than widening the fixed-width table further.
    // #217 appends two more headline columns (mean hop count, Jain's fairness);
    // used-next-hop diversity and its entropy go on the '# paths' lines.
    std::cout << std::left << std::setw(12) << "protocol"
              << std::right << std::setw(8) << "PDR%" << std::setw(11) << "delay(ms)"
              << std::setw(13) << "delay99(ms)" << std::setw(13) << "thrput(kbps)"
              << std::setw(8) << "NRL"
              << std::setw(12) << "jitter(ms)" << std::setw(12) << "dOff50(ms)"
              << std::setw(12) << "dOff90(ms)" << std::setw(12) << "nrlBytes"
              << std::setw(12) << "energy(J)" << std::setw(12) << "J/pkt"
              << std::setw(12) << "hops" << std::setw(12) << "jain"
              // #89: eq 5.1 sits next to the FlowMonitor jitter it is NOT
              // interchangeable with; see docs/benchmarks/metrics.md.
              << std::setw(13) << "jitterEq51" << "\n";
    std::cout << std::string(174, '-') << "\n";
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::left << std::setw(12) << list[i] << std::right << std::fixed
                  << std::setw(8) << std::setprecision(1) << agg[i].pdr
                  << std::setw(11) << std::setprecision(1) << agg[i].delay
                  << std::setw(13) << std::setprecision(1) << agg[i].delay99
                  << std::setw(13) << std::setprecision(2) << agg[i].thrput
                  << std::setw(8) << std::setprecision(2) << agg[i].nrl
                  << std::setw(12) << std::setprecision(2) << agg[i].jitter;
        for (double v : {agg[i].dOff50, agg[i].dOff90}) {
            if (v < 0) std::cout << std::setw(12) << "inf";
            else std::cout << std::setw(12) << std::setprecision(1) << v;
        }
        std::cout << std::setw(12) << std::setprecision(3) << agg[i].nrlBytes
                  << std::setw(12) << std::setprecision(1) << agg[i].energy
                  << std::setw(12) << std::setprecision(4) << agg[i].energyPerPkt
                  << std::setw(12) << std::setprecision(2) << agg[i].hopsMean
                  << std::setw(12) << std::setprecision(4) << agg[i].jain
                  << std::setw(13) << std::setprecision(2) << agg[i].jitterEq51
                  << "\n";
    }
    // #217 path detail: used-path diversity (distinct next hops that actually
    // carried data for a destination, within a --pathWindowS window), the
    // entropy of that split, and the longest delivered path. divUsed ~1 with
    // entropy ~0 is a single-path protocol — the expected reading for aodv,
    // olsr and dsdv, and the instrumentation's self-check.
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::fixed << "# paths " << list[i]
                  << " divUsed=" << std::setprecision(3) << agg[i].divUsed
                  << " divMax=" << std::setprecision(1) << agg[i].divMax
                  << " entropyBits=" << std::setprecision(3) << agg[i].divEntropy
                  << " windowS=" << std::setprecision(1) << P.pathWindowS
                  << " hopsMean=" << std::setprecision(2) << agg[i].hopsMean
                  << " hopsMax=" << std::setprecision(1) << agg[i].hopsMax
                  << "\n";
    }
    // #209 energy detail: residual-energy spread across nodes (the fairness
    // signal — a protocol that funnels traffic through one relay drains it
    // first) and the first-node-death time (-1 = no node died, the expected
    // case at the default --energyJ). '# ' prefix keeps these off the
    // CSV/##BENCH## paths, same as the '# stddev' lines.
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::fixed << "# energy " << list[i]
                  << " initJ=" << std::setprecision(1) << P.energyJ
                  << " resMinJ=" << std::setprecision(1) << agg[i].resMin
                  << " resMeanJ=" << std::setprecision(1) << agg[i].resMean
                  << " resSdJ=" << std::setprecision(3) << agg[i].resSd
                  << " firstDeathS=" << std::setprecision(1) << agg[i].firstDeath
                  << "\n";
    }
    // #215 drop causes: why the packets PDR is missing went missing, as a % of
    // offered. `sum` is pdr + the five protocol-agnostic causes and should read
    // ~100; `other` and the gap between `sum` and 100 are the diagnostic
    // handles when it does not (unbucketed L3 drop reasons, and packets still
    // held in a pending queue when the run stopped). setup/reconv/repair are
    // AntHocNet's sub-breakdown of `route` and print as "-" elsewhere. '# '
    // prefix keeps the line off the CSV/##BENCH## paths, like '# energy'.
    auto opt = [](double v) {
        std::ostringstream o;
        if (v < 0.0) o << "-";
        else o << std::fixed << std::setprecision(2) << v;
        return o.str();
    };
    for (std::size_t i = 0; i < list.size(); ++i) {
        const double sum = agg[i].pdr + agg[i].dropRoute + agg[i].dropQueue
                         + agg[i].dropMac + agg[i].dropChan + agg[i].dropTtl;
        std::cout << std::fixed << std::setprecision(2) << "# drops " << list[i]
                  << " pdr=" << agg[i].pdr
                  << " route=" << agg[i].dropRoute
                  << " queue=" << agg[i].dropQueue
                  << " mac=" << agg[i].dropMac
                  << " chan=" << agg[i].dropChan
                  << " ttl=" << agg[i].dropTtl
                  << " sum=" << sum
                  << " other=" << agg[i].dropOther
                  << " [route: setup=" << opt(agg[i].dropSetup)
                  << " reconv=" << opt(agg[i].dropReconv)
                  << " repair=" << opt(agg[i].dropRepair) << "]\n";
    }
    // #28 dispersion: '# ' prefix keeps these out of the CSV/##BENCH## paths.
    if (runs > 1) {
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << std::fixed << "# stddev " << list[i]
                      << " pdr=" << std::setprecision(2) << agg[i].pdrSd
                      << " delay=" << std::setprecision(1) << agg[i].delaySd
                      << " delay99=" << std::setprecision(1) << agg[i].delay99Sd
                      << " nrl=" << std::setprecision(3) << agg[i].nrlSd
                      << " nrl_bytes=" << std::setprecision(3) << agg[i].nrlBytesSd << "\n";
        }
    }
    // #212 packet reordering. Deliberately a '# ' line rather than five more
    // fixed-width table columns: the table's field *positions* are a parsing
    // contract (bench_parse.py and the workflows' ##BENCH## awk read the left
    // columns by position), and reordering is a diagnostic of the multipath
    // mechanism rather than a headline comparison number. The CSV carries all
    // five columns by name. Expect ~0 for AODV/OLSR/DSDV and for AntHocNet with
    // EnableMultipath=false; a non-zero AntHocNet figure is the stochastic
    // multipath working as designed, not a fault (docs/benchmarks/metrics.md).
    //
    // #63: NOT emitted at all under TCP. RecordRxSeq is deliberately not
    // connected there (a SeqTsSizeHeader cannot be parsed off a byte stream),
    // so these accumulators never receive a sample and the line would print
    // all-zeros — asserting "no reordering occurred" when the truth is "nobody
    // measured". That is precisely the claim ##HOLD## and ##AIR## refuse to
    // make, and a probe caught this printing 0.0000 on a TCP cell after the
    // hook was already correctly skipped: disconnecting the source is only
    // half of encoding absence, the emission has to go too.
    if (P.transport != "tcp") {
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << std::fixed << "# reorder " << list[i]
                      << " ratio=" << std::setprecision(4) << agg[i].reordRatio
                      << " ratioWorstFlow=" << std::setprecision(4) << agg[i].reordRatioMax
                      << " extentMean=" << std::setprecision(2) << agg[i].reordExtMean
                      << " extentMax=" << std::setprecision(2) << agg[i].reordExtMax
                      << " bufMax=" << std::setprecision(2) << agg[i].reordBufMax << "\n";
        }
    }
    return 0;
}
