// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * ISL-grid scenario (issue #214, satellite track #192).
 *
 * A LEO inter-satellite-link mesh is conventionally abstracted as a **+Grid
 * torus**: each satellite holds two intra-plane links (fore/aft, near-constant
 * length) and two cross-plane links (port/starboard, length varying with
 * latitude). Frozen at one instant that is simply a static torus of
 * point-to-point links, which stock ns-3 can build today — no orbital
 * mechanics, no third-party satellite module, and therefore no dependency on
 * the substrate decision in #193.
 *
 * That is deliberately enough to answer the questions the satellite track is
 * actually blocked on:
 *   - does AntHocNet route a 4-degree, high-diameter, non-random topology?
 *   - does the #203 multi-interface fix hold on a node with exactly the 4 ISLs
 *     it was written for (each on its own subnet)?
 *   - how does control-plane cost scale with n (#207)?
 *
 * This is a *scenario*, not a module. It adds no net devices and no mobility;
 * if it ever grows either, it belongs in #195 instead.
 *
 * Issue #260: one scripted ISL break is supported (--breakLink=r1,c1,r2,c2
 * --breakAt=<s>), cutting that link's two interfaces via Ipv4::SetDown at
 * breakAt and reporting the detect/reconverge split as a "# failcell" line —
 * see the comment at the failcell globals below for exactly what each number
 * measures (and what the reconverge proxy does NOT measure).
 *
 * Issue #216 cell 1: the asymmetric-congestion cell (--corridorLoad=<rate>
 * [--corridorLoadAt=<s>]) offers background load over one of two equal-length
 * row corridors between a probe pair, and reports per run how the probe's
 * traffic split across the corridors plus the probe's own PDR/delay as a
 * "# corridor" line — see the comment at the corridor globals below for the
 * exact construction and what each number means.
 *
 * Metrics mirror anthocnet-compare's definitions (PDR, mean and 99th-pct delay,
 * throughput, NRL as routing-control packets over delivered data packets, plus
 * #132 byte-NRL and #57 jitter) so numbers are comparable across the two
 * harnesses. The offered-load percentiles (dOff50/dOff90) are NOT computed
 * here: they exist to expose survivorship bias under mobility-driven route
 * loss, which this static topology does not have. They are omitted rather than
 * emitted as a placeholder so nothing downstream mistakes a filler for a
 * measurement.
 *
 * Requires the aodv, olsr, dsdv, point-to-point and flow-monitor modules:
 *   ./ns3 run "isl-grid --rows=10 --cols=10 --protocols=anthocnet,aodv,oracle"
 */
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/applications-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/flow-monitor-module.h"
#include "ns3/ipv4-flow-classifier.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/udp-header.h"

#include "ns3/aodv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/dsdv-module.h"
// #296 item 1 / #216: the global-knowledge shortest-path CONTROL. On a static
// ISL torus its adjacency is EXACT — the graph is the wiring, read straight off
// the point-to-point channels — which is why the satellite suite is where the
// oracle is first proved correct. Off unless named in --protocols.
#include "ns3/oracle-module.h"
#include "ns3/anthocnet-helper.h"
#include "ns3/anthocnet-routing-protocol.h"

#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <map>
#include <set>
#include <sstream>
#include <utility>
#include <vector>

using namespace ns3;

namespace {

// Same counting point and convention as anthocnet-compare: data traffic uses
// this UDP port, every other UDP packet seen at the IP layer is routing control.
constexpr uint16_t kDataPort = 9;
// #216 cell 1: the corridor cell's background load rides this port. It is
// offered load, not traffic under measurement and not routing control, so it
// is excluded from both the data metrics (the FlowMonitor loop keeps kDataPort
// only) and the control counter below.
constexpr uint16_t kLoadPort = 10;

// --- RNG stream pinning (#352) ----------------------------------------------
// Identical mechanism and identical stride to anthocnet-compare (the long
// comment there explains why): ns-3 takes a RandomVariableStream's index from a
// global counter at construction, RngSeedManager::SetSeed/SetRun do not reset
// it, and this harness builds a fresh topology per run inside one process — so
// without pinning a run's realisation depends on its position in the process
// (on --runs and on protocol order) instead of on its seed. Each seed gets the
// stream block [seed*kStreamStride, (seed+1)*kStreamStride); this grid consumes
// far fewer streams than the wifi field does, so the same 10^6 stride is
// generous. TakeStreams() aborts if a run ever overruns its block.
constexpr int64_t kStreamStride = 1000000;

void TakeStreams(int64_t& next, int64_t base, int64_t used, const char* what) {
    next += used;
    NS_ABORT_MSG_IF(next - base >= kStreamStride,
                    "RNG stream budget exhausted after assigning " << what
                    << ": this run has consumed " << (next - base)
                    << " streams but kStreamStride is " << kStreamStride
                    << " — seed blocks would overlap (#352). Raise the stride.");
}

// #352: DsdvHelper has no AssignStreams() wrapper in any ns-3 of the 3.36-3.48
// CI matrix, unlike the other three routing helpers, but dsdv::RoutingProtocol
// declares AssignStreams(int64_t) in all of them. Reach the installed protocol
// objects through the nodes and do what the missing wrapper would do; leaving
// the DSDV baseline unpinned would keep exactly the arm whose numbers must stay
// byte-identical across generations dependent on the split structure.
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

uint64_t g_controlPkts = 0;
uint64_t g_controlBytes = 0;
bool     g_diag = false;
std::map<uint8_t, uint64_t> g_antTx;
std::map<uint8_t, uint64_t> g_antRx;

void CountControlTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t) {
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return;
    if (ip.GetProtocol() != 17) return;  // not UDP; routing control here is UDP
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return;
    const uint16_t dport = udp.GetDestinationPort();
    if (dport != kDataPort && dport != kLoadPort) {
        ++g_controlPkts;
        g_controlBytes += p->GetSize();
    }
}

void DiagAntTx(uint8_t type, uint8_t /*dir*/, bool /*broadcast*/) {
    if (g_diag) g_antTx[type] += 1;
}
void DiagAntRx(uint8_t type, uint8_t /*dir*/) {
    if (g_diag) g_antRx[type] += 1;
}

// --- scripted ISL break, detect/reconverge split (#260) ----------------------
// tDetect: break -> the protocol's first neighbour-loss event for the severed
// peer at either endpoint, observed via anthocnet's RouteChanged trace source
// (a removal fires from the core's loseNeighbor). Only anthocnet exposes that
// trace, so tDetect prints "nan" for the baseline protocols. With the #260
// interface-down fast path this is ~0 by construction for a SetDown-scripted
// break; disabling it (EnableMacFailureDetector=false) makes the same number
// read the detector-A hello timeout instead — the instrumentation measures
// whichever detector actually fired.
// tReconverge: break -> the LAST of the per-flow first deliveries after the
// break, maximised over all flows. This is a PROXY, not path truth: the
// harness does not know which flows crossed the broken ISL, so an unaffected
// flow contributes roughly one CBR inter-packet gap (~125 ms at the default
// 64 B / 4096 bps) and the maximum is dominated by the slowest genuinely
// re-routed flow. If no flow crossed the broken ISL, the number degenerates to
// about that gap — read it as an upper bound on re-convergence, meaningful
// only when it clearly exceeds the inter-packet gap.
double g_breakAt = 0.0;                  // s; 0 = no scripted break this run
double g_tDetect = -1.0;                 // s after the break; -1 = never fired
std::set<uint32_t> g_breakPeerAddrs;     // every Ipv4 address of both endpoints
std::vector<double> g_flowFirstRxAfter;  // abs time; -1 = nothing after break

void FailcellRouteChanged(uint32_t /*dest*/, uint32_t neighbor, bool added) {
    if (added || g_tDetect >= 0.0 || g_breakAt <= 0.0) return;
    const double now = Simulator::Now().GetSeconds();
    if (now < g_breakAt) return;
    if (g_breakPeerAddrs.count(neighbor)) g_tDetect = now - g_breakAt;
}

void FailcellSinkRx(uint32_t flow, Ptr<const Packet>, const Address&) {
    const double now = Simulator::Now().GetSeconds();
    if (g_breakAt <= 0.0 || now < g_breakAt) return;
    if (flow < g_flowFirstRxAfter.size() && g_flowFirstRxAfter[flow] < 0.0) {
        g_flowFirstRxAfter[flow] = now;
    }
}

/// Cut one ISL: both endpoint interfaces go administratively down, which is
/// the event the adapter's non-wifi fast path (#260) keys on. A p2p device has
/// no other failure surface — its link never reports down and IP drops packets
/// to a down interface before any device trace fires.
void BreakIsl(Ptr<Ipv4> a, uint32_t ifA, Ptr<Ipv4> b, uint32_t ifB) {
    a->SetDown(ifA);
    b->SetDown(ifB);
}

// --- asymmetric-congestion cell, #216 cell 1 ---------------------------------
// "Congestion the precomputed control cannot see": two equal-length row
// corridors between probe src (0,0) and probe dst (0,cols/2) on the torus —
// east (0,0)->(0,1)->...->(0,cols/2) and west (0,0)->(0,cols-1)->...->
// (0,cols/2), each cols/2 hops. Any path leaving row 0 is at least 2 hops
// longer, so with cols even and >= 4 the shortest paths are EXACTLY the two
// corridors; a hop-count control is indifferent between them. A background
// OnOff flow (0,1) -> (0,2) on kLoadPort loads the east corridor's second
// link from corridorLoadAt onward (after route discovery has settled on the
// quiet net, so a reactive baseline has already committed).
// The path-shift signal is counted at the probe source's IP Tx trace: every
// probe data packet is classified by the interface it leaves (0,0) on —
// viaLoaded (toward (0,1)), viaClean (toward (0,cols-1)), viaOther (off-row)
// — from corridorLoadAt onward, so the pre-load phase does not dilute the
// steady-state read. Caveat: the background flow is itself routed by the
// protocol under test (real cross-traffic is), so an adaptive arm may spread
// the load as well as dodge it; the probe's counters and its own PDR/delay
// (probePdr/probeDelayMs on the "# corridor" line, whole-run) are the cell's
// verdict, not the background's path.
double      g_corridorLoadAt = 0.0;  // s; counters gate on this
Ipv4Address g_corridorDst;           // probe dst canonical (first-interface) addr
uint32_t    g_ifLoaded = 0;          // src interface entering the east corridor
uint32_t    g_ifClean = 0;           // src interface entering the west corridor
uint64_t    g_viaLoaded = 0, g_viaClean = 0, g_viaOther = 0;
uint64_t    g_probeTx = 0, g_probeRx = 0;
double      g_probeDelay = 0.0;      // s, summed over delivered probe packets

// #216 mechanism sampler: while the corridor cell is on, print the probe
// source's regular/virtual pheromone toward each corridor's first hop for the
// probe destination every 30 s — "# pher" diagnostic lines, invisible to the
// results parsers like "# corridor". This is the instrument the gate x metric
// interference investigation needed: on an arm that fails to shift, it shows
// whether a west (clean-corridor) gradient ever forms at the source, and
// whether diffusion (the virtual column) feeds it.
std::string g_pherProto;
uint32_t    g_pherSeed = 0;
Ipv4Address g_pherEast, g_pherWest;

void PherSample(Ptr<Node> src) {
    Ptr<ns3::anthocnet::RoutingProtocol> rp =
        src->GetObject<ns3::anthocnet::RoutingProtocol>();
    if (!rp) return;  // baselines carry no pheromone table
    double er, ev, wr, wv;
    rp->GetPheromoneDiag(g_corridorDst, g_pherEast, er, ev);
    rp->GetPheromoneDiag(g_corridorDst, g_pherWest, wr, wv);
    std::cout << std::fixed << std::setprecision(4) << "# pher " << g_pherProto
              << " seed=" << g_pherSeed << " t=" << Simulator::Now().GetSeconds()
              << " eastR=" << er << " eastV=" << ev << " westR=" << wr
              << " westV=" << wv << std::endl;
}

void CorridorTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t iface) {
    if (Simulator::Now().GetSeconds() < g_corridorLoadAt) return;
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return;
    if (ip.GetProtocol() != 17) return;
    if (ip.GetDestination() != g_corridorDst) return;
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return;
    if (udp.GetDestinationPort() != kDataPort) return;  // probe data only
    if (iface == g_ifLoaded)     ++g_viaLoaded;
    else if (iface == g_ifClean) ++g_viaClean;
    else                         ++g_viaOther;
}

struct Params {
    uint32_t rows;
    uint32_t cols;
    double   simTime;
    double   islDelayMs;
    std::string islRate;
    uint32_t nFlows;
    double   cbrBps;
    bool     torus;
    double   breakAt;   // #260: 0 = no scripted break
    uint32_t breakA;    // node index of one break endpoint
    uint32_t breakB;    // node index of the other
    std::string corridorLoad;   // #216 cell 1: background rate; "" = cell off
    double   corridorLoadAt;    // s; when the background load switches on
};

struct Result {
    std::string proto;
    uint64_t txPackets = 0;
    uint64_t rxPackets = 0;
    uint32_t links = 0;
    double pdr = 0.0;
    double meanDelayMs = 0.0;
    double delay99Ms = 0.0;
    double throughputKbps = 0.0;
    double nrl = 0.0;
    double nrlBytes = 0.0;
    double jitterMs = 0.0;
};

/// Grid index -> node index. Row = orbital plane, column = position in plane.
inline uint32_t Idx(uint32_t r, uint32_t c, const Params& P) { return r * P.cols + c; }

/// Links laid along one axis of length n: none for a single element, a ring
/// (n links) when the torus wraps it, a path (n-1) otherwise. An axis of
/// length 2 is never wrapped — the wrap would duplicate the forward link — so
/// it is a path. This is the closed form CheckTopology validates GridLinks
/// against; the two are written independently on purpose.
uint32_t AxisLinks(uint32_t n, bool torus) {
    if (n < 2) return 0;
    return (torus && n > 2) ? n : n - 1;
}

/// Link (r,c) to its +1 neighbour in each dimension, wrapping when torus is on.
/// Only the two "forward" directions are walked, so every link is created once
/// and each node ends up with degree 4 on a full torus. A dimension of size 2
/// is not wrapped even in torus mode: the forward and wrapped links would be
/// the same pair of nodes, and a duplicate parallel link is not a torus.
std::vector<std::pair<uint32_t, uint32_t>> GridLinks(const Params& P) {
    std::vector<std::pair<uint32_t, uint32_t>> links;
    for (uint32_t r = 0; r < P.rows; ++r) {
        for (uint32_t c = 0; c < P.cols; ++c) {
            // Intra-plane (along a row): the c -> c+1 link, or the wrap-around
            // that closes the ring at the last column when the torus is on.
            if (c + 1 < P.cols) {
                links.emplace_back(Idx(r, c, P), Idx(r, c + 1, P));
            } else if (P.torus && P.cols > 2) {
                links.emplace_back(Idx(r, c, P), Idx(r, 0, P));
            }
            // Cross-plane (along a column): same construction.
            if (r + 1 < P.rows) {
                links.emplace_back(Idx(r, c, P), Idx(r + 1, c, P));
            } else if (P.torus && P.rows > 2) {
                links.emplace_back(Idx(r, c, P), Idx(0, c, P));
            }
        }
    }
    return links;
}

/// Issue #226: assert the built graph *is* the topology claimed, before any
/// packet is sent.
///
/// Without this, changing the wrap logic silently changes the network being
/// measured and nothing fails — a slightly-wrong torus is still well connected,
/// so PDR keeps reading ~100% and the run emits a plausible CSV row for the
/// wrong graph. That is the harness-vs-algorithm confusion that cost several
/// benchmark cycles in #19/#43 vs #51, in a place where it is nearly free to
/// foreclose. Runs on every invocation, including the CI smoke on all five ns-3
/// matrix legs.
void CheckTopology(const std::vector<std::pair<uint32_t, uint32_t>>& links,
                   const Params& P) {
    const uint32_t n = P.rows * P.cols;
    const uint32_t expected =
        P.rows * AxisLinks(P.cols, P.torus) + P.cols * AxisLinks(P.rows, P.torus);
    NS_ABORT_MSG_UNLESS(links.size() == expected,
                        "isl-grid topology: built " << links.size() << " links, expected "
                        << expected << " for " << P.rows << "x" << P.cols
                        << " torus=" << P.torus);

    std::set<std::pair<uint32_t, uint32_t>> seen;
    std::vector<uint32_t> degree(n, 0);
    for (const auto& l : links) {
        NS_ABORT_MSG_IF(l.first == l.second,
                        "isl-grid topology: self-loop at node " << l.first);
        const uint32_t a = std::min(l.first, l.second);
        const uint32_t b = std::max(l.first, l.second);
        NS_ABORT_MSG_UNLESS(seen.insert(std::make_pair(a, b)).second,
                            "isl-grid topology: duplicate link " << a << "-" << b
                            << " (a parallel link is not a torus)");
        degree[l.first]++;
        degree[l.second]++;
    }

    // A full torus is regular: every satellite holds exactly 4 ISLs (fore/aft
    // intra-plane, port/starboard cross-plane). Smaller or open grids are not
    // regular, so the check applies only where the claim does.
    if (P.torus && P.rows > 2 && P.cols > 2) {
        for (uint32_t i = 0; i < n; ++i) {
            NS_ABORT_MSG_UNLESS(degree[i] == 4,
                                "isl-grid topology: node " << i << " has degree "
                                << degree[i] << ", expected 4 on a full torus");
        }
    }
}

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    // #352: pin this run's stream indices into the seed's own block, so the
    // realisation is a function of the seed alone. See kStreamStride.
    const int64_t streamBase = static_cast<int64_t>(seed) * kStreamStride;
    int64_t stream = streamBase;
    g_controlPkts = 0;
    g_controlBytes = 0;
    g_antTx.clear();
    g_antRx.clear();
    g_breakAt = P.breakAt;
    g_tDetect = -1.0;
    g_breakPeerAddrs.clear();
    g_flowFirstRxAfter.clear();
    g_corridorLoadAt = 0.0;
    g_viaLoaded = g_viaClean = g_viaOther = 0;
    g_probeTx = g_probeRx = 0;
    g_probeDelay = 0.0;

    const uint32_t nNodes = P.rows * P.cols;
    NodeContainer nodes;
    nodes.Create(nNodes);

    // #352: helpers hoisted out of the branches so AssignStreams() can be called
    // on them after Install() — see the same block in anthocnet-compare.
    InternetStackHelper internet;
    AntHocNetHelper ahnHelper;
    AodvHelper aodvHelper;
    OlsrHelper olsrHelper;
    DsdvHelper dsdvHelper;
    OracleHelper oracleHelper;
    if (proto == "anthocnet") {
        internet.SetRoutingHelper(ahnHelper);
    } else if (proto == "aodv") {
        internet.SetRoutingHelper(aodvHelper);
    } else if (proto == "olsr") {
        internet.SetRoutingHelper(olsrHelper);
    } else if (proto == "dsdv") {
        internet.SetRoutingHelper(dsdvHelper);
    } else if (proto == "oracle") {
        internet.SetRoutingHelper(oracleHelper);
    }
    internet.Install(nodes);
    // Pinned for the same reason as in anthocnet-compare: ArpL3Protocol owns a
    // RandomVariableStream. Point-to-point links do not use ARP, so this draws
    // nothing here — but it keeps the two harnesses' stream plumbing identical,
    // so a future ISL scenario on a broadcast medium is pinned by construction
    // rather than by someone remembering.
    TakeStreams(stream, streamBase, internet.AssignStreams(nodes, stream),
                "internet stack (arp request jitter)");
    if (proto == "anthocnet") {
        TakeStreams(stream, streamBase, ahnHelper.AssignStreams(nodes, stream),
                    "anthocnet routing");
    } else if (proto == "aodv") {
        TakeStreams(stream, streamBase, aodvHelper.AssignStreams(nodes, stream),
                    "aodv routing");
    } else if (proto == "olsr") {
        TakeStreams(stream, streamBase, olsrHelper.AssignStreams(nodes, stream),
                    "olsr routing");
    } else if (proto == "dsdv") {
        TakeStreams(stream, streamBase, AssignDsdvStreams(nodes, stream),
                    "dsdv routing");
    } else if (proto == "oracle") {
        // Returns 0 — the oracle draws nothing. Taken through the same path so
        // the zero is measured, not merely unwritten (#352).
        TakeStreams(stream, streamBase, oracleHelper.AssignStreams(nodes, stream),
                    "oracle routing");
    }

    // One point-to-point link per ISL, each on its own /30 — the addressing a
    // real ISL mesh has, and the shape that exercises #203.
    PointToPointHelper p2p;
    p2p.SetDeviceAttribute("DataRate", StringValue(P.islRate));
    // Seconds(), not MilliSeconds(): the latter takes an integer count, so a
    // fractional ISL delay would be silently truncated.
    p2p.SetChannelAttribute("Delay", TimeValue(Seconds(P.islDelayMs / 1000.0)));

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.255.252");
    const std::vector<std::pair<uint32_t, uint32_t>> links = GridLinks(P);
    CheckTopology(links, P);  // #226: fail loudly rather than measure a wrong graph
    std::vector<Ipv4InterfaceContainer> ifs;
    ifs.reserve(links.size());
    for (const auto& l : links) {
        NetDeviceContainer devs =
            p2p.Install(NodeContainer(nodes.Get(l.first), nodes.Get(l.second)));
        ifs.push_back(address.Assign(devs));
        address.NewNetwork();
    }

    // #260 scripted break: locate the named ISL among the built links and
    // schedule both of its interfaces down at breakAt.
    if (P.breakAt > 0.0) {
        int breakIdx = -1;
        for (std::size_t k = 0; k < links.size(); ++k) {
            if ((links[k].first == P.breakA && links[k].second == P.breakB) ||
                (links[k].first == P.breakB && links[k].second == P.breakA)) {
                breakIdx = static_cast<int>(k);
                break;
            }
        }
        NS_ABORT_MSG_IF(breakIdx < 0, "--breakLink names no built ISL: nodes "
                        << P.breakA << " and " << P.breakB << " are not adjacent");
        std::pair<Ptr<Ipv4>, uint32_t> endA = ifs[breakIdx].Get(0);
        std::pair<Ptr<Ipv4>, uint32_t> endB = ifs[breakIdx].Get(1);
        Simulator::Schedule(Seconds(P.breakAt), &BreakIsl, endA.first, endA.second,
                            endB.first, endB.second);
        // Every address of both endpoint satellites: the core may name the lost
        // neighbour by its canonical (first-interface) address or by the
        // link-local one its hellos arrive from, and a removal at either
        // endpoint identifies the break.
        for (uint32_t nodeIdx : {P.breakA, P.breakB}) {
            Ptr<Ipv4> ip = nodes.Get(nodeIdx)->GetObject<Ipv4>();
            for (uint32_t i = 0; ip && i < ip->GetNInterfaces(); ++i) {
                for (uint32_t j = 0; j < ip->GetNAddresses(i); ++j) {
                    g_breakPeerAddrs.insert(ip->GetAddress(i, j).GetLocal().Get());
                }
            }
            // tDetect from the RouteChanged trace at the two endpoints. Only
            // anthocnet has this trace source; the connect quietly fails for
            // the baselines and tDetect stays -1 (printed as nan).
            Ptr<Ipv4RoutingProtocol> rp = ip ? ip->GetRoutingProtocol() : nullptr;
            if (rp) {
                rp->TraceConnectWithoutContext(
                    "RouteChanged", MakeCallback(&FailcellRouteChanged));
            }
        }
    }

    // Routing overhead, counted at the IP layer exactly as anthocnet-compare
    // does, so NRL means the same thing in both harnesses.
    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnectWithoutContext("Tx", MakeCallback(&CountControlTx));
    }

    // Flows span the grid (i -> n-1-i), the pairing anthocnet-compare uses; on a
    // torus that is a genuinely multi-hop path rather than a neighbour exchange.
    // Every node's FIRST interface address is its canonical identity to the core
    // (see #218), so addressing the destination by ifs[0] of its first link is
    // what a real deployment would do — and is what forced the #203 fix.
    std::vector<Ipv4Address> nodeAddr(nNodes);
    std::vector<bool> haveAddr(nNodes, false);
    for (std::size_t k = 0; k < links.size(); ++k) {
        if (!haveAddr[links[k].first]) {
            nodeAddr[links[k].first] = ifs[k].GetAddress(0);
            haveAddr[links[k].first] = true;
        }
        if (!haveAddr[links[k].second]) {
            nodeAddr[links[k].second] = ifs[k].GetAddress(1);
            haveAddr[links[k].second] = true;
        }
    }

    // #216 cell 1: resolve the corridor endpoints and the source's two row
    // interfaces (construction and counter semantics at the corridor globals).
    const bool corridor = !P.corridorLoad.empty();
    uint32_t corridorDstIdx = 0;
    if (corridor) {
        corridorDstIdx = Idx(0, P.cols / 2, P);
        g_corridorDst = nodeAddr[corridorDstIdx];
        g_corridorLoadAt = P.corridorLoadAt;
        const uint32_t east = Idx(0, 1, P);           // first hop, loaded corridor
        const uint32_t west = Idx(0, P.cols - 1, P);  // first hop, clean corridor
        for (std::size_t k = 0; k < links.size(); ++k) {
            // The east link is built as (src, east); the west one is the row's
            // wrap link, built as (west, src) — see GridLinks.
            if (links[k].first == Idx(0, 0, P) && links[k].second == east) {
                g_ifLoaded = ifs[k].Get(0).second;
            }
            if (links[k].first == west && links[k].second == Idx(0, 0, P)) {
                g_ifClean = ifs[k].Get(1).second;
            }
        }
        Ptr<Ipv4L3Protocol> l3 = nodes.Get(Idx(0, 0, P))->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnectWithoutContext("Tx", MakeCallback(&CorridorTx));

        // #216 mechanism sampler (see the globals above): every 30 s from the
        // load start, read the source's pheromone toward each corridor. Only
        // anthocnet has a table — PherSample no-ops on the baselines.
        g_pherProto = proto;
        g_pherSeed = seed;
        g_pherEast = nodeAddr[east];
        g_pherWest = nodeAddr[west];
        for (double t = P.corridorLoadAt + 0.5; t < P.simTime - 1.0; t += 30.0) {
            Simulator::Schedule(Seconds(t), &PherSample, nodes.Get(Idx(0, 0, P)));
        }
    }

    std::ostringstream rate;
    rate << static_cast<uint64_t>(P.cbrBps) << "bps";
    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(1.0));
    startVar->SetAttribute("Max", DoubleValue(11.0));
    // #352: pinned before the flow loop reads it (start times are drawn there).
    // The point-to-point devices and channels configured above carry no error
    // model and draw no random numbers, so there is nothing to pin below IP.
    startVar->SetStream(stream);
    TakeStreams(stream, streamBase, 1, "flow start times");

    ApplicationContainer apps, sinks;
    for (uint32_t i = 0; i < P.nFlows && i < nNodes; ++i) {
        const uint32_t src = i;
        const uint32_t dst = nNodes - 1 - i;
        if (src == dst) continue;
        OnOffHelper onoff("ns3::UdpSocketFactory",
                          InetSocketAddress(nodeAddr[dst], kDataPort));
        onoff.SetAttribute("DataRate", StringValue(rate.str()));
        onoff.SetAttribute("PacketSize", UintegerValue(64));
        onoff.SetAttribute("StartTime", TimeValue(Seconds(startVar->GetValue())));
        onoff.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
        apps.Add(onoff.Install(nodes.Get(src)));

        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), kDataPort));
        sinks.Add(sink.Install(nodes.Get(dst)));
    }

    // #216 cell 1: the probe flow (a normal data flow, same rate/size as the
    // standard ones) plus the background load on kLoadPort.
    if (corridor) {
        OnOffHelper probe("ns3::UdpSocketFactory",
                          InetSocketAddress(nodeAddr[corridorDstIdx], kDataPort));
        probe.SetAttribute("DataRate", StringValue(rate.str()));
        probe.SetAttribute("PacketSize", UintegerValue(64));
        probe.SetAttribute("StartTime", TimeValue(Seconds(startVar->GetValue())));
        probe.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
        apps.Add(probe.Install(nodes.Get(Idx(0, 0, P))));
        PacketSinkHelper probeSink("ns3::UdpSocketFactory",
                                   InetSocketAddress(Ipv4Address::GetAny(), kDataPort));
        sinks.Add(probeSink.Install(nodes.Get(corridorDstIdx)));

        // Background: deterministic start (the load is scripted, like the #260
        // break), 1000 B packets so the loaded link's queue fills in bytes the
        // way real cross-traffic does.
        OnOffHelper load("ns3::UdpSocketFactory",
                         InetSocketAddress(nodeAddr[Idx(0, 2, P)], kLoadPort));
        load.SetAttribute("DataRate", StringValue(P.corridorLoad));
        load.SetAttribute("PacketSize", UintegerValue(1000));
        // Constant duty: the OnOff DEFAULT is 1 s on / 1 s off, under which a
        // 12 Mbps load on a 10 Mbps ISL oscillates the queue empty->full->empty
        // every 2 s — an ant sampling in the off-phase reads zero backlog, and
        // the first cell-1 dispatches measured exactly that (mac-metric arm
        // shifted only 2/5 seeds; see #216). Sustained congestion IS the cell,
        // so the background transmits continuously at corridorLoad.
        load.SetAttribute("OnTime", StringValue("ns3::ConstantRandomVariable[Constant=1]"));
        load.SetAttribute("OffTime", StringValue("ns3::ConstantRandomVariable[Constant=0]"));
        load.SetAttribute("StartTime", TimeValue(Seconds(P.corridorLoadAt)));
        load.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
        apps.Add(load.Install(nodes.Get(Idx(0, 1, P))));
        PacketSinkHelper loadSink("ns3::UdpSocketFactory",
                                  InetSocketAddress(Ipv4Address::GetAny(), kLoadPort));
        // Not in `sinks`: the failcell per-flow tracing is about data flows.
        ApplicationContainer loadSinkApp = loadSink.Install(nodes.Get(Idx(0, 2, P)));
        loadSinkApp.Start(Seconds(0.0));
    }
    sinks.Start(Seconds(0.0));

    // #352: the OnOff sources' on/off variables (constant here, pinned anyway so
    // a duty cycle added later cannot reintroduce the position dependence).
    for (uint32_t i = 0; i < apps.GetN(); ++i) {
        Ptr<OnOffApplication> onoffApp = DynamicCast<OnOffApplication>(apps.Get(i));
        if (onoffApp) {
            TakeStreams(stream, streamBase, onoffApp->AssignStreams(stream),
                        "onoff application");
        }
    }

    // #260: per-flow first delivery after the break, for the tReconverge proxy
    // (see the failcell comment above for what the maximum over flows means).
    if (P.breakAt > 0.0) {
        g_flowFirstRxAfter.assign(sinks.GetN(), -1.0);
        for (uint32_t f = 0; f < sinks.GetN(); ++f) {
            sinks.Get(f)->TraceConnectWithoutContext(
                "Rx", MakeBoundCallback(&FailcellSinkRx, f));
        }
    }

    if (g_diag && proto == "anthocnet") {
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
            if (!ip) continue;
            Ptr<Ipv4RoutingProtocol> rp = ip->GetRoutingProtocol();
            if (!rp) continue;
            rp->TraceConnectWithoutContext("Tx", MakeCallback(&DiagAntTx));
            rp->TraceConnectWithoutContext("Rx", MakeCallback(&DiagAntRx));
        }
    }

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();

    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();

    monitor->CheckForLostPackets();
    Result r;
    r.proto = proto;
    r.links = static_cast<uint32_t>(links.size());
    double totalDelay = 0.0, totalRxBytes = 0.0, totalJitter = 0.0, binWidth = 0.0;
    uint64_t rxForDelay = 0, jitterSamples = 0;
    std::map<uint32_t, uint64_t> delayBins;
    Ptr<Ipv4FlowClassifier> classifier =
        DynamicCast<Ipv4FlowClassifier>(fmHelper.GetClassifier());
    for (auto& kv : monitor->GetFlowStats()) {
        Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow(kv.first);
        if (t.destinationPort != kDataPort) continue;  // data flows only
        if (corridor && t.destinationAddress == g_corridorDst) {
            g_probeTx += kv.second.txPackets;
            g_probeRx += kv.second.rxPackets;
            g_probeDelay += kv.second.delaySum.GetSeconds();
        }
        r.txPackets += kv.second.txPackets;
        r.rxPackets += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        rxForDelay += kv.second.rxPackets;
        totalRxBytes += kv.second.rxBytes;
        totalJitter += kv.second.jitterSum.GetSeconds();
        if (kv.second.rxPackets > 0) jitterSamples += kv.second.rxPackets - 1;
        // Copy: Histogram's accessors are non-const in older ns-3 (<=3.36).
        Histogram h = kv.second.delayHistogram;
        for (uint32_t b = 0; b < h.GetNBins(); ++b) {
            if (binWidth == 0.0) binWidth = h.GetBinWidth(b);
            delayBins[b] += h.GetBinCount(b);
        }
    }
    r.pdr = r.txPackets ? 100.0 * r.rxPackets / r.txPackets : 0.0;
    r.meanDelayMs = rxForDelay ? 1000.0 * totalDelay / rxForDelay : 0.0;
    r.throughputKbps = (totalRxBytes * 8.0 / 1000.0) / P.simTime;
    r.nrl = r.rxPackets ? static_cast<double>(g_controlPkts) / r.rxPackets : 0.0;
    r.nrlBytes = totalRxBytes > 0.0
        ? static_cast<double>(g_controlBytes) / totalRxBytes : 0.0;
    r.jitterMs = jitterSamples ? 1000.0 * totalJitter / jitterSamples : 0.0;
    if (rxForDelay && binWidth > 0.0) {
        const uint64_t target = static_cast<uint64_t>(0.99 * rxForDelay);
        uint64_t cum = 0;
        for (const auto& b : delayBins) {
            cum += b.second;
            if (cum >= target) {
                r.delay99Ms = 1000.0 * (b.first + 1) * binWidth;
                break;
            }
        }
    }

    // #296 item 1: the control's defining property, asserted rather than
    // expected — zero packets on the wire, therefore NRL exactly 0. The
    // ##ORACLE## line records which adjacency rule was in force; on this
    // topology it must read mode=wired approx=0, i.e. exact.
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

} // namespace

int main(int argc, char* argv[]) {
    uint32_t rows = 6, cols = 6, nFlows = 4, runs = 1;
    double simTime = 60.0, islDelayMs = 5.0, cbrBps = 4096;
    bool torus = true, csv = false;
    std::string islRate = "10Mbps";
    std::string protocols = "anthocnet";
    std::string breakLink;
    double breakAt = 0.0;
    std::string corridorLoad;
    double corridorLoadAt = 15.0;

    CommandLine cmd(__FILE__);
    cmd.AddValue("rows", "Orbital planes (grid rows)", rows);
    cmd.AddValue("cols", "Satellites per plane (grid columns)", cols);
    cmd.AddValue("torus", "Wrap the grid edges (+Grid torus); false = open grid", torus);
    cmd.AddValue("islDelayMs", "One-way ISL propagation delay (ms). LEO ISLs are "
                               "3-18 ms depending on separation", islDelayMs);
    cmd.AddValue("islRate", "ISL data rate", islRate);
    cmd.AddValue("time", "Simulation time (s)", simTime);
    cmd.AddValue("flows", "Number of CBR flows", nFlows);
    cmd.AddValue("cbrBps", "Per-flow CBR rate (bits/s)", cbrBps);
    cmd.AddValue("runs", "Number of RNG runs to average (seeds 1..runs)", runs);
    cmd.AddValue("protocols",
                 "Comma-separated list (anthocnet,aodv,olsr,oracle). "
                 "`oracle` is the #296/#216 global-knowledge shortest-path "
                 "CONTROL — exact on this static torus, zero control traffic. "
                 "`dsdv` is rejected on any grid where a satellite holds more "
                 "than one ISL: ns-3's DSDV is single-interface-only (#420).",
                 protocols);
    cmd.AddValue("csv", "Emit machine-readable CSV instead of a table", csv);
    cmd.AddValue("diag", "Emit per-run '# diag' lines (ant tallies)", g_diag);
    cmd.AddValue("breakLink", "Scripted ISL break (#260): endpoints as r1,c1,r2,c2 "
                              "(must be adjacent); requires --breakAt", breakLink);
    cmd.AddValue("breakAt", "Time (s) to cut --breakLink's ISL (both interfaces "
                            "down via Ipv4::SetDown); 0 = no break", breakAt);
    cmd.AddValue("corridorLoad", "Asymmetric-congestion cell (#216 cell 1): "
                                 "background rate (e.g. 12Mbps) offered over one of "
                                 "two equal-length row corridors; needs a torus with "
                                 "even cols >= 4; empty = cell off", corridorLoad);
    cmd.AddValue("corridorLoadAt", "Time (s) the corridor background load starts "
                                   "(after route discovery settles)", corridorLoadAt);
    cmd.Parse(argc, argv);

    // Same 1 ms delay bin as anthocnet-compare, so delay99 is comparable.
    Config::SetDefault("ns3::FlowMonitor::DelayBinWidth", DoubleValue(0.001));

    Params P;
    P.rows = rows;
    P.cols = cols;
    P.simTime = simTime;
    P.islDelayMs = islDelayMs;
    P.islRate = islRate;
    P.nFlows = nFlows;
    P.cbrBps = cbrBps;
    P.torus = torus;
    P.breakAt = 0.0;
    P.breakA = P.breakB = 0;
    P.corridorLoad = corridorLoad;
    P.corridorLoadAt = corridorLoadAt;

    // #216 cell 1: validate the corridor construction before any run.
    if (!corridorLoad.empty()) {
        NS_ABORT_MSG_IF(!torus || cols < 4 || cols % 2 != 0,
                        "--corridorLoad needs a torus with an even number of columns "
                        ">= 4 (two equal-length row corridors)");
        NS_ABORT_MSG_IF(corridorLoadAt <= 0.0 || corridorLoadAt >= simTime - 1.0,
                        "--corridorLoadAt must fall inside the run");
        // The probe flow is identified in FlowMonitor by destination address +
        // kDataPort; a standard flow targeting the probe destination would be
        // counted into the probe's numbers unnoticed.
        const uint32_t dstIdx = cols / 2;  // Idx(0, cols/2)
        for (uint32_t i = 0; i < nFlows && i < rows * cols; ++i) {
            NS_ABORT_MSG_IF(rows * cols - 1 - i == dstIdx,
                            "--corridorLoad: standard flow " << i << " also targets "
                            "the probe destination; lower --flows or grow the grid");
        }
    }

    // #260: parse and validate the scripted break before any run.
    if (!breakLink.empty() || breakAt > 0.0) {
        NS_ABORT_MSG_IF(breakLink.empty() || breakAt <= 0.0,
                        "--breakLink and --breakAt must be given together");
        NS_ABORT_MSG_IF(breakAt >= simTime, "--breakAt is past --time");
        std::vector<uint32_t> rc;
        std::stringstream bs(breakLink);
        std::string tok;
        while (std::getline(bs, tok, ',')) {
            std::stringstream ts(tok);
            uint32_t v = 0;
            NS_ABORT_MSG_IF(!(ts >> v), "--breakLink expects r1,c1,r2,c2, got '"
                            << breakLink << "'");
            rc.push_back(v);
        }
        NS_ABORT_MSG_IF(rc.size() != 4, "--breakLink expects r1,c1,r2,c2, got '"
                        << breakLink << "'");
        NS_ABORT_MSG_IF(rc[0] >= rows || rc[2] >= rows || rc[1] >= cols || rc[3] >= cols,
                        "--breakLink endpoint outside the " << rows << "x" << cols
                        << " grid");
        P.breakA = Idx(rc[0], rc[1], P);
        P.breakB = Idx(rc[2], rc[3], P);
        NS_ABORT_MSG_IF(P.breakA == P.breakB, "--breakLink endpoints are the same node");
        P.breakAt = breakAt;
    }

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) {
        if (!item.empty()) list.push_back(item);
    }
    NS_ABORT_MSG_IF(list.empty(), "--protocols selected nothing");

    // #420: ns-3's dsdv::RoutingProtocol is written for a node with exactly one
    // non-loopback interface. It advertises only m_ipv4->GetAddress(1, 0) as its
    // own address, so on a satellite holding several ISLs the addresses of the
    // other interfaces are never announced. Peers still record *those* addresses
    // as next hops — a DSDV update's source address is the address of the /30 it
    // arrived on — so LookForQueuedPackets() cannot resolve the next hop, ignores
    // the failed LookupRoute(), and forwards on a default-constructed entry whose
    // Ipv4Route has a null output device. Ipv4L3Protocol::SendRealOut asserts on
    // that in a debug build and indexes the interface list with -1 in the -opt
    // profile the campaign runs, which is the empty-stderr SIGSEGV of #420.
    //
    // Nothing on this side fixes it: a point-to-point ISL mesh has one interface
    // per link by construction, which is the very shape #203 exists for. Reject
    // the combination up front instead of dying 15 s into the second arm. Gate on
    // the topology, not on the arm — the 1x2 single-ISL grid the #237 anchors use
    // gives every node one interface, and DSDV is genuinely correct there.
    if (std::find(list.begin(), list.end(), "dsdv") != list.end()) {
        std::vector<uint32_t> degree(rows * cols, 0);
        uint32_t maxDegree = 0;
        for (const auto& l : GridLinks(P)) {
            maxDegree = std::max(maxDegree, ++degree[l.first]);
            maxDegree = std::max(maxDegree, ++degree[l.second]);
        }
        NS_ABORT_MSG_IF(maxDegree > 1,
                        "dsdv cannot run on this ISL topology: ns-3's DSDV assumes one "
                        "non-loopback interface per node, but this " << rows << "x" << cols
                        << (torus ? " torus" : " open grid") << " gives a satellite up to "
                        << maxDegree << " ISLs, each on its own /30 — next hops learned on "
                        "the other interfaces are unresolvable and DSDV forwards on a null "
                        "output device (#420). Drop dsdv from --protocols; see "
                        "docs/benchmarks/satellite/isl-grid.md.");
    }

    std::vector<Result> agg(list.size());
    for (std::size_t i = 0; i < list.size(); ++i) {
        agg[i].proto = list[i];
        for (uint32_t s = 1; s <= runs; ++s) {
            Result r = RunOne(list[i], P, s);
            agg[i].links = r.links;
            agg[i].pdr += r.pdr;
            agg[i].meanDelayMs += r.meanDelayMs;
            agg[i].delay99Ms += r.delay99Ms;
            agg[i].throughputKbps += r.throughputKbps;
            agg[i].nrl += r.nrl;
            agg[i].nrlBytes += r.nrlBytes;
            agg[i].jitterMs += r.jitterMs;
            std::cout << std::fixed << std::setprecision(2)
                      << "##RUN## " << s << ' ' << list[i]
                      << ' ' << r.pdr << ' ' << r.meanDelayMs
                      << ' ' << r.delay99Ms << ' ' << r.throughputKbps
                      << ' ' << r.nrl << ' ' << r.nrlBytes
                      << ' ' << r.jitterMs << std::endl;
            if (g_diag && list[i] == "anthocnet") {
                std::cout << "# diag " << list[i] << " seed=" << s << " ctrlTx="
                          << g_controlPkts << " antTx[";
                for (const auto& kv : g_antTx) {
                    std::cout << static_cast<int>(kv.first) << '=' << kv.second << ',';
                }
                std::cout << "] antRx[";
                for (const auto& kv : g_antRx) {
                    std::cout << static_cast<int>(kv.first) << '=' << kv.second << ',';
                }
                std::cout << ']' << std::endl;
            }
            // #260 detect/reconverge split for the scripted break (definitions
            // and proxy caveats at the failcell globals above). "nan" = the
            // event was never observed (no RouteChanged trace on baselines /
            // no delivery after the break).
            if (P.breakAt > 0.0) {
                double tReconv = -1.0;
                for (double t : g_flowFirstRxAfter) {
                    if (t >= 0.0) tReconv = std::max(tReconv, t - P.breakAt);
                }
                std::cout << std::fixed << std::setprecision(4)
                          << "# failcell " << list[i] << " seed=" << s
                          << " breakAt=" << P.breakAt << " tDetect=";
                if (g_tDetect >= 0.0) std::cout << g_tDetect;
                else std::cout << "nan";
                std::cout << " tReconverge=";
                if (tReconv >= 0.0) std::cout << tReconv;
                else std::cout << "nan";
                std::cout << std::endl;
            }
            // #216 cell 1: the corridor split (counted from loadStart onward)
            // plus the probe flow's own whole-run PDR/delay — semantics at the
            // corridor globals in RunOne's file scope.
            if (!corridorLoad.empty()) {
                const double probePdr =
                    g_probeTx ? 100.0 * g_probeRx / g_probeTx : 0.0;
                const double probeDelayMs =
                    g_probeRx ? 1000.0 * g_probeDelay / g_probeRx : 0.0;
                std::cout << std::fixed << std::setprecision(2)
                          << "# corridor " << list[i] << " seed=" << s
                          << " loadStart=" << corridorLoadAt
                          << " viaLoaded=" << g_viaLoaded
                          << " viaClean=" << g_viaClean
                          << " viaOther=" << g_viaOther
                          << " probePdr=" << probePdr
                          << " probeDelayMs=" << probeDelayMs << std::endl;
            }
        }
        agg[i].pdr /= runs;
        agg[i].meanDelayMs /= runs;
        agg[i].delay99Ms /= runs;
        agg[i].throughputKbps /= runs;
        agg[i].nrl /= runs;
        agg[i].nrlBytes /= runs;
        agg[i].jitterMs /= runs;
    }

    const uint32_t nNodes = rows * cols;
    if (csv) {
        std::cout << "protocol,runs,rows,cols,nodes,links,isl_delay_ms,flows,"
                     "pdr_pct,delay_ms,delay99_ms,throughput_kbps,nrl,nrl_bytes,"
                     "jitter_ms\n";
        for (const auto& a : agg) {
            std::cout << std::fixed << a.proto << ',' << runs << ',' << rows << ','
                      << cols << ',' << nNodes << ',' << a.links << ','
                      << std::setprecision(1) << islDelayMs << ',' << nFlows << ','
                      << std::setprecision(1) << a.pdr << ','
                      << a.meanDelayMs << ',' << a.delay99Ms << ','
                      << std::setprecision(2) << a.throughputKbps << ','
                      << std::setprecision(3) << a.nrl << ',' << a.nrlBytes << ','
                      << std::setprecision(2) << a.jitterMs << '\n';
        }
        return 0;
    }

    // Print the mean degree alongside the link count (#226): a wrong topology is
    // visible here to anyone reading a run by eye, not only to the assertions.
    std::cout << std::fixed << std::setprecision(2)
              << "+Grid " << (torus ? "torus" : "open") << ' ' << rows << 'x' << cols
              << " = " << nNodes << " satellites, " << agg.front().links
              << " ISLs (mean degree "
              << (nNodes ? 2.0 * agg.front().links / nNodes : 0.0) << ")"
              << " @ " << islDelayMs << " ms " << islRate << ", " << nFlows
              << " flows, " << simTime << " s, mean of " << runs << " run(s)\n\n";
    std::cout << std::setw(14) << std::left << "protocol" << std::right
              << std::setw(8) << "PDR%" << std::setw(11) << "delay(ms)"
              << std::setw(13) << "delay99(ms)" << std::setw(14) << "thrput(kbps)"
              << std::setw(8) << "NRL" << std::setw(11) << "NRLbytes"
              << std::setw(12) << "jitter(ms)" << '\n';
    std::cout << std::string(91, '-') << '\n';
    for (const auto& a : agg) {
        std::cout << std::fixed << std::setw(14) << std::left << a.proto << std::right
                  << std::setw(8) << std::setprecision(1) << a.pdr
                  << std::setw(11) << a.meanDelayMs
                  << std::setw(13) << a.delay99Ms
                  << std::setw(14) << std::setprecision(2) << a.throughputKbps
                  << std::setw(8) << std::setprecision(2) << a.nrl
                  << std::setw(11) << a.nrlBytes
                  << std::setw(12) << a.jitterMs << '\n';
    }
    return 0;
}
