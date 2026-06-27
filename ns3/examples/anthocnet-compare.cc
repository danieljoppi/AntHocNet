/*
 * AntHocNet vs. AODV / OLSR / DSDV comparison.
 *
 * Runs the SAME mobile-ad-hoc scenario (identical node layout, mobility and
 * CBR traffic, driven from the same RNG run) under each routing protocol and
 * reports the metrics from the AntHocNet paper [1, §4]: packet-delivery ratio,
 * mean and 99th-percentile end-to-end delay, throughput, and normalized routing
 * load (NRL = routing-control packets transmitted / data packets delivered).
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

#include "ns3/aodv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/dsdv-module.h"
#include "ns3/anthocnet-helper.h"

#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <map>
#include <vector>

using namespace ns3;

namespace {

// Data traffic uses this UDP port; every other UDP packet seen at the IP layer
// is routing control (AntHocNet 6900, AODV 654, OLSR 698, DSDV 269, ...), which
// is how we count routing overhead uniformly across protocols.
constexpr uint16_t kDataPort = 9;

uint64_t g_controlPkts = 0;  // routing-control packets transmitted this run

// Ipv4L3Protocol "Tx" trace: one call per IP packet sent out an interface (each
// hop). Count the non-data UDP packets as routing control.
void CountControlTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t) {
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return;
    if (ip.GetProtocol() != 17) return;  // not UDP; routing control here is UDP
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return;
    if (udp.GetDestinationPort() != kDataPort) ++g_controlPkts;
}

// --- diagnostics (--diag): ant-level introspection for AntHocNet -----------
// Answers "are routes forming and when?": per-type ant send/receive tallies
// (from the protocol's own item-15 Tx/Rx trace sources) and the time of the
// first delivered data packet (works for every protocol, from the sink's Rx).
bool g_diag = false;
std::map<uint8_t, uint64_t> g_antTx;   // by AntType byte
std::map<uint8_t, uint64_t> g_antRx;
double g_firstDeliveryS = -1.0;

void DiagAntTx(uint8_t type, uint8_t /*dir*/, bool /*broadcast*/) {
    if (g_diag) g_antTx[type] += 1;
}
void DiagAntRx(uint8_t type, uint8_t /*dir*/) {
    if (g_diag) g_antRx[type] += 1;
}
void DiagSinkRx(Ptr<const Packet>, const Address&) {
    if (g_firstDeliveryS < 0.0) g_firstDeliveryS = Simulator::Now().GetSeconds();
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
};

struct Result {
    std::string proto;
    uint64_t txPackets = 0;
    uint64_t rxPackets = 0;
    double pdr = 0.0;            // %
    double meanDelayMs = 0.0;
    double delay99Ms = 0.0;      // 99th percentile (the paper's QoS/jitter metric)
    double throughputKbps = 0.0;
    double nrl = 0.0;            // control pkts / delivered data pkts
};

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    // Reset the RNG run so every protocol sees the identical realisation.
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    g_controlPkts = 0;
    g_antTx.clear();
    g_antRx.clear();
    g_firstDeliveryS = -1.0;

    NodeContainer nodes;
    nodes.Create(P.nNodes);

    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
    YansWifiPhyHelper phy;
    YansWifiChannelHelper channel;
    if (P.range > 0.0) {
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
    for (uint32_t i = 0; i < P.nFlows && i < P.nNodes / 2; ++i) {
        uint32_t src = i;
        uint32_t dst = P.nNodes - 1 - i;
        OnOffHelper onoff("ns3::UdpSocketFactory",
                          InetSocketAddress(ifs.GetAddress(dst), port));
        onoff.SetAttribute("DataRate", StringValue(rate.str()));
        onoff.SetAttribute("PacketSize", UintegerValue(64));
        onoff.SetAttribute("StartTime", TimeValue(Seconds(startVar->GetValue())));
        onoff.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
        apps.Add(onoff.Install(nodes.Get(src)));

        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), port));
        sinks.Add(sink.Install(nodes.Get(dst)));
    }
    sinks.Start(Seconds(0.0));

    if (g_diag) {
        // First-delivery timestamp from every data sink (all protocols).
        for (uint32_t i = 0; i < sinks.GetN(); ++i) {
            sinks.Get(i)->TraceConnectWithoutContext("Rx", MakeCallback(&DiagSinkRx));
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

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();

    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();

    monitor->CheckForLostPackets();
    Result r;
    r.proto = proto;
    double totalDelay = 0.0;
    uint64_t rxForDelay = 0;
    double totalRxBytes = 0.0;
    std::map<uint32_t, uint64_t> delayBins;  // aggregated delay histogram
    double binWidth = 0.0;
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

    // Diagnostics line (prefixed "# " so CSV consumers ignore it). Shows whether
    // routes form (reactive ants sent vs received elsewhere; back-ant arrivals)
    // and when the first packet is delivered.
    if (g_diag) {
        std::cout << std::fixed << std::setprecision(2)
                  << "# diag " << proto << " seed=" << seed
                  << " pdr=" << r.pdr
                  << " firstDeliveryS=" << g_firstDeliveryS
                  << " ctrlTx=" << g_controlPkts;
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
        }
        std::cout << "\n";
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
    uint32_t runs = 1;
    bool csv = false;
    std::string protocols = "anthocnet,aodv,olsr,dsdv";

    CommandLine cmd(__FILE__);
    cmd.AddValue("scenario", "Preset: 'paper' for the AntHocNet base scenario", scenario);
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
    cmd.AddValue("runs", "Number of RNG runs to average (seeds 1..runs)", runs);
    cmd.AddValue("csv", "Emit machine-readable CSV instead of a table", csv);
    cmd.AddValue("protocols", "Comma-separated list", protocols);
    cmd.AddValue("diag", "Emit per-run '# diag' lines (ant tallies, first delivery)", g_diag);
    cmd.Parse(argc, argv);
    if (runs < 1) runs = 1;

    const bool paper = (scenario == "paper");
    Params P;
    P.nNodes  = nNodes > 0 ? static_cast<uint32_t>(nNodes) : (paper ? 50 : 20);
    P.simTime = simTime >= 0 ? simTime : (paper ? 900.0 : 40.0);
    P.areaX   = areaX >= 0 ? areaX : (area >= 0 ? area : (paper ? 1500.0 : 300.0));
    P.areaY   = areaY >= 0 ? areaY : (area >= 0 ? area : (paper ? 300.0 : 300.0));
    P.speed   = speed >= 0 ? speed : (paper ? 20.0 : 5.0);
    P.pause   = pause >= 0 ? pause : (paper ? 30.0 : 1.0);
    P.range   = range >= 0 ? range : (paper ? 300.0 : 0.0);
    P.nFlows  = nFlows > 0 ? static_cast<uint32_t>(nFlows) : (paper ? 20 : 5);
    P.cbrBps  = cbrBps >= 0 ? cbrBps : (paper ? 512.0 : 8000.0);
    P.startWindow = paper ? 180.0 : 5.0;

    // 1 ms delay bins for the 99th-percentile computation.
    Config::SetDefault("ns3::FlowMonitor::DelayBinWidth", DoubleValue(0.001));

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) {
        if (!item.empty()) list.push_back(item);
    }

    // Each protocol: mean over runs (every protocol sees the same seed set).
    struct Agg { double pdr = 0, delay = 0, delay99 = 0, thrput = 0, nrl = 0; };
    std::vector<Agg> agg(list.size());
    for (std::size_t i = 0; i < list.size(); ++i) {
        for (uint32_t s = 1; s <= runs; ++s) {
            Result r = RunOne(list[i], P, s);
            agg[i].pdr += r.pdr;
            agg[i].delay += r.meanDelayMs;
            agg[i].delay99 += r.delay99Ms;
            agg[i].thrput += r.throughputKbps;
            agg[i].nrl += r.nrl;
        }
        agg[i].pdr /= runs;
        agg[i].delay /= runs;
        agg[i].delay99 /= runs;
        agg[i].thrput /= runs;
        agg[i].nrl /= runs;
    }

    if (csv) {
        // Field order through throughput_kbps is stable (downstream parsers rely
        // on it); delay99_ms and nrl are appended.
        std::cout << "protocol,runs,nNodes,area,speed,flows,pdr_pct,delay_ms,"
                     "throughput_kbps,delay99_ms,nrl\n";
        std::cout << std::fixed;
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << list[i] << ',' << runs << ',' << P.nNodes << ','
                      << std::setprecision(0) << P.areaX << ','
                      << std::setprecision(0) << P.speed << ',' << P.nFlows << ','
                      << std::setprecision(1) << agg[i].pdr << ','
                      << std::setprecision(1) << agg[i].delay << ','
                      << std::setprecision(2) << agg[i].thrput << ','
                      << std::setprecision(1) << agg[i].delay99 << ','
                      << std::setprecision(3) << agg[i].nrl << '\n';
        }
        return 0;
    }

    std::cout << "AntHocNet protocol comparison (mean of " << runs << " run(s))\n"
              << "  nodes=" << P.nNodes << " time=" << P.simTime << "s area="
              << P.areaX << "x" << P.areaY << "m maxSpeed=" << P.speed
              << "m/s pause=" << P.pause << "s flows=" << P.nFlows << "\n\n";
    std::cout << std::left << std::setw(12) << "protocol"
              << std::right << std::setw(8) << "PDR%" << std::setw(11) << "delay(ms)"
              << std::setw(13) << "delay99(ms)" << std::setw(13) << "thrput(kbps)"
              << std::setw(8) << "NRL" << "\n";
    std::cout << std::string(65, '-') << "\n";
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::left << std::setw(12) << list[i] << std::right << std::fixed
                  << std::setw(8) << std::setprecision(1) << agg[i].pdr
                  << std::setw(11) << std::setprecision(1) << agg[i].delay
                  << std::setw(13) << std::setprecision(1) << agg[i].delay99
                  << std::setw(13) << std::setprecision(2) << agg[i].thrput
                  << std::setw(8) << std::setprecision(2) << agg[i].nrl << "\n";
    }
    return 0;
}
