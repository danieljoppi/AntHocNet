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
 *   ./ns3 run "isl-grid --rows=10 --cols=10 --protocols=anthocnet,aodv"
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
#include "ns3/anthocnet-helper.h"

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
    if (udp.GetDestinationPort() != kDataPort) {
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
    g_controlPkts = 0;
    g_controlBytes = 0;
    g_antTx.clear();
    g_antRx.clear();
    g_breakAt = P.breakAt;
    g_tDetect = -1.0;
    g_breakPeerAddrs.clear();
    g_flowFirstRxAfter.clear();

    const uint32_t nNodes = P.rows * P.cols;
    NodeContainer nodes;
    nodes.Create(nNodes);

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

    std::ostringstream rate;
    rate << static_cast<uint64_t>(P.cbrBps) << "bps";
    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(1.0));
    startVar->SetAttribute("Max", DoubleValue(11.0));

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
    sinks.Start(Seconds(0.0));

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
    cmd.AddValue("protocols", "Comma-separated list", protocols);
    cmd.AddValue("csv", "Emit machine-readable CSV instead of a table", csv);
    cmd.AddValue("diag", "Emit per-run '# diag' lines (ant tallies)", g_diag);
    cmd.AddValue("breakLink", "Scripted ISL break (#260): endpoints as r1,c1,r2,c2 "
                              "(must be adjacent); requires --breakAt", breakLink);
    cmd.AddValue("breakAt", "Time (s) to cut --breakLink's ISL (both interfaces "
                            "down via Ipv4::SetDown); 0 = no break", breakAt);
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
