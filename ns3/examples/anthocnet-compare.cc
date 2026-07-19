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
#include "ns3/anthocnet-routing-protocol.h"

#include <algorithm>
#include <cmath>
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
    // #57 paper-parity / survivorship-safe QoS metrics:
    double jitterMs = 0.0;       // mean delay jitter (the paper's QoS metric)
    double dOff50Ms = -1.0;      // delay at the 50th pct of *offered* (sent)
    double dOff90Ms = -1.0;      // packets, undelivered = inf; -1 encodes inf
};

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    // Reset the RNG run so every protocol sees the identical realisation.
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    g_controlPkts = 0;
    g_antTx.clear();
    g_antRx.clear();
    g_firstDeliveryS = -1.0;
    g_flowStart.clear();
    g_flowFirstRx.clear();
    g_qCount = g_qNonzero = g_qMax = 0;
    g_qSum = 0.0;

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
    Result r;
    r.proto = proto;
    double totalDelay = 0.0;
    uint64_t rxForDelay = 0;
    double totalRxBytes = 0.0;
    double totalJitter = 0.0;    // #57: FlowMonitor jitterSum over data flows
    uint64_t jitterSamples = 0;  // each flow contributes rx-1 jitter samples
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

    r.jitterMs = jitterSamples ? 1000.0 * totalJitter / jitterSamples : 0.0;

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
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<ns3::anthocnet::RoutingProtocol> ahn =
                    DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
                if (!ahn) continue;
                lfProp += ahn->LinkfailPropagations();
                lfBudget += ahn->LinkfailBudgetDrops();
                lfSuppressed += ahn->LinkfailOriginsSuppressed();
            }
            std::cout << " linkfailProp=" << lfProp
                      << " linkfailBudgetDrop=" << lfBudget
                      << " linkfailOrigSuppressed=" << lfSuppressed;

            // Issue #21: pending-queue hold-time attribution. dOff50 is ~3 ms
            // (#88) so the delay/jitter gap vs AODV is carried by queue-held
            // packets; this splits the delivered hold time (and the aged-out
            // drops) across the setup / reconvergence / repair hold paths so
            // the dominant one can be attacked. Summed across nodes.
            ns3::anthocnet::HoldStats hs;
            for (uint32_t i = 0; i < nodes.GetN(); ++i) {
                Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
                if (!ip) continue;
                Ptr<ns3::anthocnet::RoutingProtocol> ahn =
                    DynamicCast<ns3::anthocnet::RoutingProtocol>(ip->GetRoutingProtocol());
                if (!ahn) continue;
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
            std::cout << "]";
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
    uint32_t runs = 1;
    bool csv = false;
    std::string protocols = "anthocnet,aodv,olsr,dsdv";

    CommandLine cmd(__FILE__);
    cmd.AddValue("scenario", "Preset: 'paper' (Broch/CMU calibration field) or "
                             "'thesis' (the AntHocNet papers' own evaluation "
                             "field, provisional values — #58)", scenario);
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
    cmd.AddValue("runs", "Number of RNG runs to average (seeds 1..runs)", runs);
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
    cmd.Parse(argc, argv);
    if (runs < 1) runs = 1;

    // 'paper' = the Broch/CMU MobiCom'98 field (the literature *calibration*
    // anchor, #24). 'thesis' = the AntHocNet papers' own evaluation field
    // (ETT 2005 / Ducatelle PhD 2007): 100 nodes on 3000x1000 m, otherwise the
    // same radio/traffic/mobility regime. Fidelity claims run on 'thesis',
    // calibration on 'paper'. VALUES ARE PROVISIONAL (#58): reconstructed from
    // secondary knowledge because the primary PDFs are network-blocked here —
    // verify against the thesis parameter table before publishing.
    const bool thesis = (scenario == "thesis");
    const bool paper = (scenario == "paper") || thesis;
    Params P;
    P.nNodes  = nNodes > 0 ? static_cast<uint32_t>(nNodes)
                           : (thesis ? 100 : paper ? 50 : 20);
    P.simTime = simTime >= 0 ? simTime : (paper ? 900.0 : 40.0);
    P.areaX   = areaX >= 0 ? areaX
                           : (area >= 0 ? area : (thesis ? 3000.0 : paper ? 1500.0 : 300.0));
    P.areaY   = areaY >= 0 ? areaY
                           : (area >= 0 ? area : (thesis ? 1000.0 : paper ? 300.0 : 300.0));
    P.speed   = speed >= 0 ? speed : (paper ? 20.0 : 5.0);
    P.pause   = pause >= 0 ? pause : (paper ? 30.0 : 1.0);
    P.range   = range >= 0 ? range : (paper ? 300.0 : 0.0);
    P.nFlows  = nFlows > 0 ? static_cast<uint32_t>(nFlows) : (paper ? 20 : 5);
    P.cbrBps  = cbrBps >= 0 ? cbrBps : (paper ? 512.0 : 8000.0);
    P.startWindow = paper ? 180.0 : 5.0;
    P.propagation = propagation;
    P.rateManager = rateManager;
    P.sink = sink;

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
        double jitter = 0, dOff50 = 0, dOff90 = 0;
        double pdrSq = 0, delaySq = 0, delay99Sq = 0, nrlSq = 0;
        bool off50Inf = false, off90Inf = false;
        double pdrSd = 0, delaySd = 0, delay99Sd = 0, nrlSd = 0;
    };
    std::vector<Agg> agg(list.size());
    for (std::size_t i = 0; i < list.size(); ++i) {
        for (uint32_t s = 1; s <= runs; ++s) {
            Result r = RunOne(list[i], P, s);
            agg[i].pdr += r.pdr;
            agg[i].delay += r.meanDelayMs;
            agg[i].delay99 += r.delay99Ms;
            agg[i].thrput += r.throughputKbps;
            agg[i].nrl += r.nrl;
            agg[i].jitter += r.jitterMs;
            agg[i].pdrSq += r.pdr * r.pdr;
            agg[i].delaySq += r.meanDelayMs * r.meanDelayMs;
            agg[i].delay99Sq += r.delay99Ms * r.delay99Ms;
            agg[i].nrlSq += r.nrl * r.nrl;
            if (r.dOff50Ms < 0) agg[i].off50Inf = true; else agg[i].dOff50 += r.dOff50Ms;
            if (r.dOff90Ms < 0) agg[i].off90Inf = true; else agg[i].dOff90 += r.dOff90Ms;
        }
        agg[i].pdr /= runs;
        agg[i].delay /= runs;
        agg[i].delay99 /= runs;
        agg[i].thrput /= runs;
        agg[i].nrl /= runs;
        agg[i].jitter /= runs;
        agg[i].dOff50 = agg[i].off50Inf ? -1.0 : agg[i].dOff50 / runs;
        agg[i].dOff90 = agg[i].off90Inf ? -1.0 : agg[i].dOff90 / runs;
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
        }
    }

    if (csv) {
        // Field order through throughput_kbps is stable (downstream parsers rely
        // on it); later columns are append-only (consumers read by header name):
        // delay99_ms/nrl, then #57 jitter + offered-load percentiles (-1 = inf),
        // then #28 per-metric sample stddev across runs (0 when runs==1).
        std::cout << "protocol,runs,nNodes,area,speed,flows,pdr_pct,delay_ms,"
                     "throughput_kbps,delay99_ms,nrl,jitter_ms,delay_off50_ms,"
                     "delay_off90_ms,pdr_sd,delay_sd,delay99_sd,nrl_sd\n";
        std::cout << std::fixed;
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
                      << std::setprecision(3) << agg[i].nrlSd << '\n';
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
    // columns (jitter, offered-load 90th pct) are appended to the right.
    std::cout << std::left << std::setw(12) << "protocol"
              << std::right << std::setw(8) << "PDR%" << std::setw(11) << "delay(ms)"
              << std::setw(13) << "delay99(ms)" << std::setw(13) << "thrput(kbps)"
              << std::setw(8) << "NRL"
              << std::setw(12) << "jitter(ms)" << std::setw(12) << "dOff50(ms)"
              << std::setw(12) << "dOff90(ms)" << "\n";
    std::cout << std::string(101, '-') << "\n";
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
        std::cout << "\n";
    }
    // #28 dispersion: '# ' prefix keeps these out of the CSV/##BENCH## paths.
    if (runs > 1) {
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << std::fixed << "# stddev " << list[i]
                      << " pdr=" << std::setprecision(2) << agg[i].pdrSd
                      << " delay=" << std::setprecision(1) << agg[i].delaySd
                      << " delay99=" << std::setprecision(1) << agg[i].delay99Sd
                      << " nrl=" << std::setprecision(3) << agg[i].nrlSd << "\n";
        }
    }
    return 0;
}
