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

#include <cstdint>
#include <iomanip>
#include <map>
#include <sstream>
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

struct Params {
    uint32_t rows;
    uint32_t cols;
    double   simTime;
    double   islDelayMs;
    std::string islRate;
    uint32_t nFlows;
    double   cbrBps;
    bool     torus;
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

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    g_controlPkts = 0;
    g_controlBytes = 0;
    g_antTx.clear();
    g_antRx.clear();

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
    std::vector<Ipv4InterfaceContainer> ifs;
    ifs.reserve(links.size());
    for (const auto& l : links) {
        NetDeviceContainer devs =
            p2p.Install(NodeContainer(nodes.Get(l.first), nodes.Get(l.second)));
        ifs.push_back(address.Assign(devs));
        address.NewNetwork();
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

    std::cout << "+Grid " << (torus ? "torus" : "open") << ' ' << rows << 'x' << cols
              << " = " << nNodes << " satellites, " << agg.front().links
              << " ISLs @ " << islDelayMs << " ms " << islRate << ", " << nFlows
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
