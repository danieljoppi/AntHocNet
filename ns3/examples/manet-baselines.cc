// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * Control benchmark for #24 — STOCK ns-3 baselines only (AODV / OLSR / DSDV),
 * with NO AntHocNet code in the binary (this translation unit does not include
 * anthocnet-helper.h, and its build target does not link libanthocnet). It
 * reproduces the exact scenario of anthocnet-compare (nodes / area / mobility /
 * traffic / propagation) so we can answer one question: are the low absolute PDRs
 * a property of the scenario+ns-3, or an artefact of our harness/module?
 *
 * If this control reports the same ~20-40% PDR as anthocnet-compare's baselines,
 * the AntHocNet module is NOT depressing the stock protocols — the scenario is
 * simply hard (the #24 hypothesis). If it reports much higher PDR, our harness is
 * the culprit.
 *
 *   ./ns3 run "manet-baselines --scenario=paper --runs=3"
 *   ./ns3 run "manet-baselines --scenario=paper --propagation=tworay --runs=3"
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

#include "ns3/aodv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/dsdv-module.h"

#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <map>
#include <string>
#include <vector>

using namespace ns3;

namespace {

constexpr uint16_t kDataPort = 9;

// --- RNG stream pinning (#352) ----------------------------------------------
// The same fix, for the same reason, as ns3/examples/anthocnet-compare.cc and
// ns3/examples/isl-grid.cc: ns-3 hands every RandomVariableStream its stream
// index from a *global* counter at CONSTRUCTION time, and neither
// RngSeedManager::SetSeed/SetRun nor Simulator::Destroy resets that counter.
// This harness has the same shape as the other two — a whole scenario built per
// run, many runs per process, in a protocol-major loop — so without pinning,
// run N draws from whatever stream indices runs 1..N-1 left behind and a run's
// realisation becomes a function of its *position* in the process (--runs, and
// the --protocols order) rather than of its seed.
//
// manet-baselines is the anchor harness (ns3/tools/check-anchors.sh) and the
// #24 stock-baseline control. Both uses compare across invocations, which is
// exactly what position dependence breaks: the anchor floors happen to be safe
// only because check-anchors.sh always passes a fixed --runs, and the #24
// control is only meaningful if its DSDV/AODV/OLSR numbers mean the same thing
// as the ones anthocnet-compare reports for the same seed. Leaving one of the
// three harnesses unpinned would keep exactly that comparison unsound.
//
// Same stride and same runtime budget check as the other two — see the longer
// derivation in anthocnet-compare.cc.
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
// AodvHelper and OlsrHelper both have one, DsdvHelper has none anywhere in the
// 3.36-3.48 CI matrix. dsdv::RoutingProtocol itself does declare
// AssignStreams(int64_t) in every one of those versions, so reach the installed
// protocol objects through the nodes and do what the missing wrapper would do.
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
void CountTx(Ptr<const Packet>, Ptr<Ipv4>, uint32_t) { ++g_controlPkts; }

// #24 ground truth, independent of FlowMonitor: count what the OnOff apps
// actually send and what the PacketSinks actually receive.
uint64_t g_appTx = 0, g_appRx = 0;
void AppTx(Ptr<const Packet>);
void AppRx(Ptr<const Packet>, const Address&) { ++g_appRx; }

// #51 drop localization (gated by --dropdiag): per-node counters for every
// drop point between the sender's L3 and the receiver's L3 — PHY rx (with
// reason), PHY tx, MAC tx/rx, retry exhaustion, ARP pending-queue, IP L3 —
// plus PhyTxBegin/MacRx activity counts, to find where the #51 ~50% dies.
bool g_dropDiag = false;
std::map<std::string, uint64_t> g_drops;
uint32_t g_dropLines = 0;
constexpr uint32_t kMaxDropLines = 60;
// First two nodes' mobility, so drop events can report the live distance
// (discriminates "receiver out of range per the loss model" from everything
// else — YansWifiChannel silently skips receivers below sensitivity).
Ptr<MobilityModel> g_mobA, g_mobB;

std::string PosStr() {
    if (!g_mobA || !g_mobB) return "";
    Vector a = g_mobA->GetPosition(), b = g_mobB->GetPosition();
    std::ostringstream os;
    os << " d=" << g_mobA->GetDistanceFrom(g_mobB)
       << " a=(" << a.x << "," << a.y << ") b=(" << b.x << "," << b.y << ")";
    return os.str();
}

void NoteDrop(const std::string& what, uint32_t size, const std::string& extra = "") {
    ++g_drops[what];
    if (g_dropLines < kMaxDropLines) {
        std::cout << "  [dropdiag] t=" << Simulator::Now().GetSeconds()
                  << " " << what << " size=" << size << extra << "\n";
        ++g_dropLines;
    }
}
void PacketDropCb(std::string ctx, Ptr<const Packet> p) { NoteDrop(ctx, p->GetSize()); }
void PacketCountCb(std::string ctx, Ptr<const Packet>) { ++g_drops[ctx]; }
void PhyTxBeginCb(std::string ctx, Ptr<const Packet>, double) { ++g_drops[ctx]; }
void PhyRxDropCb(std::string ctx, Ptr<const Packet> p, WifiPhyRxfailureReason reason) {
    std::ostringstream what;
    what << ctx << ":" << reason;
    NoteDrop(what.str(), p->GetSize());
}
void StaFailCb(std::string ctx, Mac48Address) { NoteDrop(ctx, 0, PosStr()); }
void DistanceProbe() {
    std::cout << "  [dropdiag] t=" << Simulator::Now().GetSeconds()
              << " probe" << PosStr() << "\n";
}
void Ipv4DropCb(std::string ctx, const Ipv4Header&, Ptr<const Packet> p,
                Ipv4L3Protocol::DropReason reason, Ptr<Ipv4>, uint32_t) {
    const char* name = nullptr;
    switch (reason) {
        case Ipv4L3Protocol::DROP_TTL_EXPIRED:      name = "TTL_EXPIRED"; break;
        case Ipv4L3Protocol::DROP_NO_ROUTE:         name = "NO_ROUTE"; break;
        case Ipv4L3Protocol::DROP_BAD_CHECKSUM:     name = "BAD_CHECKSUM"; break;
        case Ipv4L3Protocol::DROP_INTERFACE_DOWN:   name = "INTERFACE_DOWN"; break;
        case Ipv4L3Protocol::DROP_ROUTE_ERROR:      name = "ROUTE_ERROR"; break;
        case Ipv4L3Protocol::DROP_FRAGMENT_TIMEOUT: name = "FRAGMENT_TIMEOUT"; break;
        default: break;
    }
    std::ostringstream what;
    what << ctx << ":";
    if (name) what << name; else what << static_cast<int>(reason);
    NoteDrop(what.str(), p->GetSize());
}

// Defined after the dropdiag helpers so it can report the send-time distance.
void AppTx(Ptr<const Packet>) {
    ++g_appTx;
    if (g_dropDiag && g_appTx <= 16) {
        std::cout << "  [dropdiag] t=" << Simulator::Now().GetSeconds()
                  << " appTx#" << g_appTx << PosStr() << "\n";
    }
}

void ConnectDropDiag(const NodeContainer& nodes, const NetDeviceContainer& devices) {
    g_mobA = nodes.GetN() > 0 ? nodes.Get(0)->GetObject<MobilityModel>() : nullptr;
    g_mobB = nodes.GetN() > 1 ? nodes.Get(1)->GetObject<MobilityModel>() : nullptr;
    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        std::string n = "n" + std::to_string(i);
        Ptr<WifiNetDevice> wd = DynamicCast<WifiNetDevice>(devices.Get(i));
        if (wd) {
            wd->GetPhy()->TraceConnect("PhyRxDrop", n + "/phyRxDrop",
                                       MakeCallback(&PhyRxDropCb));
            wd->GetPhy()->TraceConnect("PhyTxDrop", n + "/phyTxDrop",
                                       MakeCallback(&PacketDropCb));
            wd->GetPhy()->TraceConnect("PhyTxBegin", n + "/phyTxBegin",
                                       MakeCallback(&PhyTxBeginCb));
            wd->GetMac()->TraceConnect("MacTxDrop", n + "/macTxDrop",
                                       MakeCallback(&PacketDropCb));
            wd->GetMac()->TraceConnect("MacRxDrop", n + "/macRxDrop",
                                       MakeCallback(&PacketDropCb));
            wd->GetMac()->TraceConnect("MacRx", n + "/macRx",
                                       MakeCallback(&PacketCountCb));
            wd->GetRemoteStationManager()->TraceConnect(
                "MacTxDataFailed", n + "/staTxDataFailed", MakeCallback(&StaFailCb));
            wd->GetRemoteStationManager()->TraceConnect(
                "MacTxFinalDataFailed", n + "/staTxFinalDataFailed",
                MakeCallback(&StaFailCb));
        }
        Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnect("Drop", n + "/ipDrop", MakeCallback(&Ipv4DropCb));
        Ptr<ArpL3Protocol> arp = nodes.Get(i)->GetObject<ArpL3Protocol>();
        if (arp) arp->TraceConnect("Drop", n + "/arpDrop", MakeCallback(&PacketDropCb));
    }
}

struct Params {
    uint32_t nNodes;
    double   simTime;
    double   areaX, areaY;
    double   speed, pause, range;
    uint32_t nFlows;
    double   cbrBps, startWindow;
    std::string propagation;
    std::string rateManager;
};

struct Result {
    std::string proto;
    double pdr = 0, meanDelayMs = 0, delay99Ms = 0, nrl = 0;
};

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    // #352: and pin the stream indices into this seed's own block, so the
    // realisation depends on the seed alone and not on how many runs (or which
    // protocols) preceded this one in the process. See kStreamStride.
    const int64_t streamBase = static_cast<int64_t>(seed) * kStreamStride;
    int64_t stream = streamBase;
    g_controlPkts = 0;
    g_appTx = 0;
    g_appRx = 0;
    g_drops.clear();
    g_dropLines = 0;

    NodeContainer nodes;
    nodes.Create(P.nNodes);

    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
    // #51: the ns-3 default (IdealWifiManager) oscillates 1<->11 Mbps and loses
    // every second unicast to retry exhaustion (DSSS 11 Mbps never delivers in
    // this setup). Default is the paper's fixed 2 Mbit/s radio; --rateManager
    // reaches the alternatives (including the old behaviour, 'ideal') for A/B.
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
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::TwoRayGroundPropagationLossModel",
                                   "Frequency", DoubleValue(2.4e9),
                                   "HeightAboveZ", DoubleValue(1.5));
    } else if (P.range > 0.0) {
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
    // MAC/Txop backoff and the rate manager in one call — and this harness can
    // select ArfWifiManager or IdealWifiManager via --rateManager, both of which
    // are stateful, so that last one is not hypothetical here.
    TakeStreams(stream, streamBase, channel.AssignStreams(wifiChannel, stream),
                "wifi channel");
    TakeStreams(stream, streamBase, wifi.AssignStreams(devices, stream), "wifi");

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
    // #352: the initial positions are drawn during Install(), so the allocator
    // has to be pinned BEFORE it — MobilityHelper::AssignStreams can only reach
    // the models (and, through RandomWaypoint, the allocator's later waypoint
    // draws) once they exist. Pinning `pos` covers both `ux` and `uy`.
    TakeStreams(stream, streamBase, pos->AssignStreams(stream),
                "position allocator");
    mobility.Install(nodes);
    TakeStreams(stream, streamBase, mobility.AssignStreams(nodes, stream),
                "mobility");

    // #352: the three routing helpers are hoisted out of the branches so their
    // AssignStreams() can run after Install() (SetRoutingHelper stores a Copy(),
    // but AssignStreams reaches the *installed* protocols through the nodes, so
    // the local helper is the right handle). Constructing all three is free —
    // each is an ObjectFactory and instantiates nothing.
    InternetStackHelper internet;
    AodvHelper aodvHelper;
    OlsrHelper olsrHelper;
    DsdvHelper dsdvHelper;
    if (proto == "aodv") {
        internet.SetRoutingHelper(aodvHelper);
    } else if (proto == "olsr") {
        internet.SetRoutingHelper(olsrHelper);
    } else if (proto == "dsdv") {
        internet.SetRoutingHelper(dsdvHelper);
    }
    internet.Install(nodes);
    // The IPv4 stack is not stream-free: ArpL3Protocol owns m_requestJitter, a
    // RandomVariableStream that de-syncs ARP requests, and on a wifi MANET every
    // next-hop change resolves through ARP. This is the entry that kept the
    // seed-independence gate red in anthocnet-compare after everything else was
    // pinned; the same stack is installed here.
    TakeStreams(stream, streamBase, internet.AssignStreams(nodes, stream),
                "internet stack (arp request jitter)");
    // Each of these protocols builds a UniformRandomVariable per node (RREQ
    // jitter, hello jitter) at construction; pin them.
    if (proto == "aodv") {
        TakeStreams(stream, streamBase, aodvHelper.AssignStreams(nodes, stream),
                    "aodv routing");
    } else if (proto == "olsr") {
        TakeStreams(stream, streamBase, olsrHelper.AssignStreams(nodes, stream),
                    "olsr routing");
    } else if (proto == "dsdv") {
        TakeStreams(stream, streamBase, AssignDsdvStreams(nodes, stream),
                    "dsdv routing");
    }

    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnectWithoutContext("Tx", MakeCallback(&CountTx));
    }

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer ifs = address.Assign(devices);

    if (g_dropDiag) {
        ConnectDropDiag(nodes, devices);
        for (double t = 0.0; t < P.simTime; t += 20.0)
            Simulator::Schedule(Seconds(t), &DistanceProbe);
    }

    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(0.0));
    startVar->SetAttribute("Max", DoubleValue(std::min(P.startWindow, P.simTime * 0.5)));
    // #352: pinned before the flow loop below reads it — the start times are
    // drawn there, not at Simulator::Run().
    startVar->SetStream(stream);
    TakeStreams(stream, streamBase, 1, "flow start times");
    std::ostringstream rate;
    rate << static_cast<uint64_t>(P.cbrBps) << "bps";
    ApplicationContainer sinks;
    for (uint32_t i = 0; i < P.nFlows && i < P.nNodes / 2; ++i) {
        uint32_t src = i, dst = P.nNodes - 1 - i;
        OnOffHelper onoff("ns3::UdpSocketFactory",
                          InetSocketAddress(ifs.GetAddress(dst), kDataPort));
        onoff.SetAttribute("DataRate", StringValue(rate.str()));
        onoff.SetAttribute("PacketSize", UintegerValue(64));
        onoff.SetAttribute("StartTime", TimeValue(Seconds(startVar->GetValue())));
        onoff.SetAttribute("StopTime", TimeValue(Seconds(P.simTime - 1.0)));
        ApplicationContainer srcApp = onoff.Install(nodes.Get(src));
        // #352: the OnOff source's on/off variables. They are
        // ConstantRandomVariable in this harness (a CBR source is always on), so
        // they consume streams without drawing from them — pinned regardless, so
        // an on/off duty cycle added later cannot reintroduce the position
        // dependence. PacketSink draws nothing. The DynamicCast is deliberate:
        // AssignStreams only reached the Application base class in a later ns-3
        // than 3.36, but OnOffApplication has declared it throughout the matrix.
        Ptr<OnOffApplication> onoffApp = DynamicCast<OnOffApplication>(srcApp.Get(0));
        NS_ABORT_MSG_IF(!onoffApp, "expected an OnOffApplication to pin (#352)");
        TakeStreams(stream, streamBase, onoffApp->AssignStreams(stream),
                    "onoff application");
        srcApp.Get(0)->TraceConnectWithoutContext("Tx", MakeCallback(&AppTx));
        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), kDataPort));
        ApplicationContainer sinkApp = sink.Install(nodes.Get(dst));
        sinkApp.Get(0)->TraceConnectWithoutContext("Rx", MakeCallback(&AppRx));
        sinks.Add(sinkApp);
    }
    sinks.Start(Seconds(0.0));

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();
    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();
    monitor->CheckForLostPackets();

    Result r;
    r.proto = proto;
    // tx/rx as doubles: the ratio below already does float division (100.0 *
    // promotes first), this just keeps the accumulators explicit.
    double tx = 0, rx = 0;
    double totalDelay = 0.0;
    std::map<uint32_t, uint64_t> delayBins;
    double binWidth = 0.0;
    Ptr<Ipv4FlowClassifier> classifier =
        DynamicCast<Ipv4FlowClassifier>(fmHelper.GetClassifier());
    for (auto& kv : monitor->GetFlowStats()) {
        Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow(kv.first);
        if (t.destinationPort != kDataPort) continue;  // data flows only
        // #24 diag: per-flow raw counts so we can see whether the ~50% is a
        // halved metric vs. a real loss (printed to stdout; stderr is dropped).
        std::cout << "  [diag " << proto << " seed=" << seed << "] flow "
                  << t.sourceAddress << ":" << t.sourcePort << " -> "
                  << t.destinationAddress << ":" << t.destinationPort
                  << " tx=" << kv.second.txPackets << " rx=" << kv.second.rxPackets
                  << " lost=" << kv.second.lostPackets << "\n";
        tx += kv.second.txPackets;
        rx += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        Histogram h = kv.second.delayHistogram;
        for (uint32_t b = 0; b < h.GetNBins(); ++b) {
            if (binWidth == 0.0) binWidth = h.GetBinWidth(b);
            delayBins[b] += h.GetBinCount(b);
        }
    }
    // #24 ground truth: app-level sent vs sink-level received, independent of
    // FlowMonitor. If appTx≈appRx but FlowMonitor tx≈2*rx, FlowMonitor tx is
    // double-counted; if appRx≈appTx/2, the loss is real.
    std::cout << "  [diag " << proto << " seed=" << seed << "] TOTALS"
              << " fmTx=" << tx << " fmRx=" << rx
              << " appTx=" << g_appTx << " appRx=" << g_appRx << "\n";
    if (g_dropDiag) {
        std::cout << "  [dropdiag " << proto << " seed=" << seed << "] TOTALS";
        for (const auto& kv : g_drops) std::cout << " " << kv.first << "=" << kv.second;
        std::cout << "\n";
    }
    r.pdr = tx ? 100.0 * rx / tx : 0.0;
    r.meanDelayMs = rx ? 1000.0 * totalDelay / rx : 0.0;
    r.nrl = rx ? static_cast<double>(g_controlPkts) / rx : 0.0;
    if (rx && binWidth > 0.0) {
        uint64_t target = static_cast<uint64_t>(0.99 * rx), cum = 0;
        for (auto& kv : delayBins) {
            cum += kv.second;
            if (cum >= target) { r.delay99Ms = 1000.0 * (kv.first + 0.5) * binWidth; break; }
        }
    }
    Simulator::Destroy();
    return r;
}

}  // namespace

int main(int argc, char* argv[]) {
    std::string scenario, protocols = "aodv,olsr,dsdv", propagation = "range";
    std::string rateManager = "constant2";
    int32_t nNodes = 0;
    double simTime = -1, area = -1, areaX = -1, areaY = -1;
    double speed = -1, pause = -1, range = -1, cbrBps = -1;
    int32_t nFlows = 0;
    uint32_t runs = 1;

    CommandLine cmd(__FILE__);
    cmd.AddValue("scenario", "Preset: 'paper' for the AntHocNet base scenario", scenario);
    cmd.AddValue("nNodes", "Number of nodes", nNodes);
    cmd.AddValue("time", "Simulation time (s)", simTime);
    cmd.AddValue("area", "Square area side (m)", area);
    cmd.AddValue("areaX", "Area width (m)", areaX);
    cmd.AddValue("areaY", "Area height (m)", areaY);
    cmd.AddValue("speed", "Max node speed (m/s)", speed);
    cmd.AddValue("pause", "Random-waypoint pause time (s)", pause);
    cmd.AddValue("range", "Transmission range (m) for the disk model", range);
    cmd.AddValue("flows", "Number of CBR flows", nFlows);
    cmd.AddValue("cbrBps", "Per-flow CBR rate (bits/s)", cbrBps);
    cmd.AddValue("runs", "Number of RNG runs to average (seeds 1..runs)", runs);
    cmd.AddValue("protocols", "Comma-separated list (aodv,olsr,dsdv)", protocols);
    cmd.AddValue("propagation", "Propagation loss model: 'range' (disk) or 'tworay'", propagation);
    cmd.AddValue("dropdiag", "Trace PHY/MAC/ARP/IP drop points per node (#51)", g_dropDiag);
    cmd.AddValue("rateManager",
                 "Rate control: constant1|constant2|constant5|constant11 (fixed "
                 "DSSS rate; default constant2, the paper's radio) | arf | ideal "
                 "(ns-3 default; loses ~50% single-hop, #51)", rateManager);
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
    P.propagation = propagation;
    P.rateManager = rateManager;

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) if (!item.empty()) list.push_back(item);

    std::cout << "STOCK ns-3 baseline control (no AntHocNet) — mean of " << runs
              << " run(s)\n  nodes=" << P.nNodes << " time=" << P.simTime
              << "s area=" << P.areaX << "x" << P.areaY << "m speed=" << P.speed
              << "m/s pause=" << P.pause << "s range=" << P.range
              << "m flows=" << P.nFlows << " propagation=" << P.propagation
              << " rateManager=" << P.rateManager << "\n\n"
              << "protocol        PDR%  delay(ms)  delay99(ms)     NRL\n"
              << "--------------------------------------------------------\n";
    // std::fixed / setprecision are STICKY on std::cout, and the summary row
    // below sets them between one protocol's runs and the next's. RunOne's
    // per-seed "[diag ...] TOTALS" line prints its packet counts as doubles
    // (tx/rx are accumulators), so the first protocol printed "fmTx=405" and
    // every later one "fmTx=405.00" for the identical value — the output, not
    // the simulation, depended on the protocol's position in --protocols. The
    // #352 seed-independence gate flagged it correctly on its first run against
    // this harness. Save the state once and restore it after each row.
    const std::ios_base::fmtflags coutFlags = std::cout.flags();
    const std::streamsize coutPrec = std::cout.precision();
    for (const std::string& proto : list) {
        double pdr = 0, d = 0, d99 = 0, nrl = 0;
        for (uint32_t s = 1; s <= runs; ++s) {
            Result r = RunOne(proto, P, s);
            pdr += r.pdr; d += r.meanDelayMs; d99 += r.delay99Ms; nrl += r.nrl;
        }
        std::cout << std::left << std::setw(14) << proto << std::right << std::fixed
                  << std::setprecision(1)
                  << std::setw(7) << pdr / runs
                  << std::setw(11) << d / runs
                  << std::setw(13) << d99 / runs
                  << std::setw(9) << std::setprecision(2) << nrl / runs << "\n";
        std::cout.flags(coutFlags);
        std::cout.precision(coutPrec);
    }
    return 0;
}
