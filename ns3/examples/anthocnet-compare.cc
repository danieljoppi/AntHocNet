/*
 * AntHocNet vs. AODV / OLSR / DSDV comparison.
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
 * Requires the aodv, olsr, dsdv and flow-monitor modules. Build with those
 * enabled, then e.g.:
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
#include "ns3/olsr-module.h"
#include "ns3/dsdv-module.h"
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

void RecordRxSeq(Ptr<const Packet> p, const Address& from) {
    SeqTsSizeHeader h;
    p->PeekHeader(h);
    g_rxSeq[from].push_back(h.GetSeq());
    const double now = Simulator::Now().GetSeconds();
    g_rxArrival[from].push_back(now);
    g_rxDelayBySeq[from][h.GetSeq()] = now - h.GetTs().GetSeconds();
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

// Is this a CBR *data* IP packet (as opposed to routing control)? Same test as
// CountControlTx, from the other side.
bool IsDataIp(Ptr<const Packet> p) {
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return false;
    if (ip.GetProtocol() != 17) return false;  // not UDP
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return false;
    return udp.GetDestinationPort() == kDataPort;
}

void CountDataHopTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t iface) {
    if (iface != 0 && IsDataIp(p)) ++g_dataHopTx;
}
void CountDataHopRx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t iface) {
    if (iface != 0 && IsDataIp(p)) ++g_dataHopRx;
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

void OnPhyState(uint32_t node, Time, Time duration, WifiPhyState state) {
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
    if (ip.GetProtocol() != 17) return;  // not UDP; routing control here is UDP
    UdpHeader udp;
    if (pkt->PeekHeader(udp) == 0) return;
    // Data only: routing control is exactly what must NOT count as a used path.
    if (udp.GetDestinationPort() != kDataPort) return;
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
    if (ip.GetProtocol() != 17) return;
    UdpHeader udp;
    if (p->PeekHeader(udp) == 0) return;
    if (udp.GetDestinationPort() != kDataPort) return;
    const uint8_t ttl = ip.GetTtl();
    const uint32_t hops =
        ttl < kIpDefaultTtl ? static_cast<uint32_t>(kIpDefaultTtl - ttl) + 1u : 1u;
    g_hopSum += hops;
    ++g_hopCount;
    if (hops > g_hopMax) g_hopMax = hops;
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
    // #209 energy:
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
    double dropQueuePct = 0.0;   // interface or qdisc queue overflow
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
    g_rxSeq.clear();
    g_rxArrival.clear();  // #89
    g_rxDelayBySeq.clear();  // #308
    g_dataHopTx = g_dataHopRx = g_macDataDrops = 0;  // #215
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
    } else if (P.range > 0.0) {
        // A clean disk model at the paper's transmission range (reproducible
        // connectivity, independent of tx-power/sensitivity defaults).
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::RangePropagationLossModel",
                                   "MaxRange", DoubleValue(P.range));
    } else {
        channel = YansWifiChannelHelper::Default();
    }
    phy.SetChannel(channel.Create());
    WifiMacHelper mac;
    mac.SetType("ns3::AdhocWifiMac");
    NetDeviceContainer devices = wifi.Install(phy, mac, nodes);

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
    mobility.SetMobilityModel("ns3::RandomWaypointMobilityModel",
                              "Speed", StringValue(speedStr.str()),
                              "Pause", StringValue(pauseStr.str()),
                              "PositionAllocator", PointerValue(pos));
    mobility.Install(nodes);

    InternetStackHelper internet;
    if (proto == "anthocnet") {
        AntHocNetHelper h;
        internet.SetRoutingHelper(h);
    } else if (proto == "aodv") {
        AodvHelper h;
        internet.SetRoutingHelper(h);
    } else if (proto == "olsr") {
        OlsrHelper h;
        internet.SetRoutingHelper(h);
    } else if (proto == "dsdv") {
        DsdvHelper h;
        internet.SetRoutingHelper(h);
    }
    internet.Install(nodes);

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
        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), port));
        sinks.Add(sink.Install(nodes.Get(P.sink)));
    }
    sinks.Start(Seconds(0.0));

    // #212: reordering is a reported metric for every protocol and every run, so
    // this hook is unconditional — unlike the --diag hooks below. The sink's
    // plain "Rx" trace hands over the whole datagram, header included, so the
    // sequence number is read here rather than through PacketSink's own
    // EnableSeqTsSizeHeader path (that one runs a TCP-oriented reassembly buffer
    // we have no use for on UDP).
    for (uint32_t i = 0; i < sinks.GetN(); ++i) {
        sinks.Get(i)->TraceConnectWithoutContext("Rx", MakeCallback(&RecordRxSeq));
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
        const double hopLoss = static_cast<double>(g_dataHopTx)
                             - static_cast<double>(g_dataHopRx);
        r.dropRoutePct = 100.0 * dropRoute / tx;
        r.dropTtlPct   = 100.0 * dropTtl / tx;
        r.dropQueuePct = 100.0 * dropQueue / tx;
        r.dropMacPct   = 100.0 * macTerminal / tx;
        r.dropChanPct  = 100.0 * (hopLoss - static_cast<double>(g_macDataDrops)
                                          - static_cast<double>(dropQueue)) / tx;
        // L3 drops in none of the buckets above (bad checksum, interface down,
        // fragment timeout — all structurally zero in this harness). Diagnostic
        // only: if it is ever non-zero it is the reason the identity misses.
        const uint64_t other = dropL3Total > dropRoute + dropTtl + dropQueue
            ? dropL3Total - dropRoute - dropTtl - dropQueue : 0;
        r.dropOtherPct = 100.0 * other / tx;
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
            ns3::anthocnet::HoldStats hs;
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
                const ns3::anthocnet::HoldStats& s = ahn->HoldTimeStats();
                for (uint8_t r = 0; r < ns3::anthocnet::kHoldReasons; ++r) {
                    hs.deliveredCount[r] += s.deliveredCount[r];
                    hs.deliveredSumS[r] += s.deliveredSumS[r];
                    if (s.deliveredMaxS[r] > hs.deliveredMaxS[r])
                        hs.deliveredMaxS[r] = s.deliveredMaxS[r];
                    hs.droppedCount[r] += s.droppedCount[r];
                    hs.droppedSumS[r] += s.droppedSumS[r];
                }
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
    cmd.AddValue("protocols", "Comma-separated list", protocols);
    cmd.AddValue("diag", "Emit per-run '# diag' lines (ant tallies, first delivery)", g_diag);
    cmd.AddValue("qdiag", "Emit per-run '# qdiag' lines: per-node MAC queue depth "
                          "distribution (meanQ/maxQ/pctNonzero) — does A2 have a "
                          "signal? (#73)", g_qdiag);
    std::string propagation = "range";
    cmd.AddValue("propagation", "Propagation loss model: 'range' (disk) or 'tworay'", propagation);
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
    P.propagation = propagation;
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
    };
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
                const double p99c = pct(inCommon, 0.99);
                const double meanc = inCommon.empty() ? -1.0 :
                    1000.0 * std::accumulate(inCommon.begin(), inCommon.end(), 0.0)
                    / inCommon.size();
                const double p99s = pct(surplus, 0.99);
                std::cout << std::fixed << "##COMMON## " << s << ' ' << list[i]
                          << ' ' << nSelf << ' ' << common.size()
                          << ' ' << std::setprecision(1) << p99c
                          << ' ' << std::setprecision(1) << meanc << ' ';
                if (p99s < 0) std::cout << "na";
                else std::cout << std::setprecision(1) << p99s;
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
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::fixed << "# reorder " << list[i]
                  << " ratio=" << std::setprecision(4) << agg[i].reordRatio
                  << " ratioWorstFlow=" << std::setprecision(4) << agg[i].reordRatioMax
                  << " extentMean=" << std::setprecision(2) << agg[i].reordExtMean
                  << " extentMax=" << std::setprecision(2) << agg[i].reordExtMax
                  << " bufMax=" << std::setprecision(2) << agg[i].reordBufMax << "\n";
    }
    return 0;
}
