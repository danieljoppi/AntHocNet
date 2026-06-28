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
uint64_t g_controlPkts = 0;
void CountTx(Ptr<const Packet>, Ptr<Ipv4>, uint32_t) { ++g_controlPkts; }

struct Params {
    uint32_t nNodes;
    double   simTime;
    double   areaX, areaY;
    double   speed, pause, range;
    uint32_t nFlows;
    double   cbrBps, startWindow;
    std::string propagation;
};

struct Result {
    std::string proto;
    double pdr = 0, meanDelayMs = 0, delay99Ms = 0, nrl = 0;
};

Result RunOne(const std::string& proto, const Params& P, uint32_t seed) {
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    g_controlPkts = 0;

    NodeContainer nodes;
    nodes.Create(P.nNodes);

    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
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
    if (proto == "aodv") {
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

    for (uint32_t i = 0; i < nodes.GetN(); ++i) {
        Ptr<Ipv4L3Protocol> l3 = nodes.Get(i)->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnectWithoutContext("Tx", MakeCallback(&CountTx));
    }

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer ifs = address.Assign(devices);

    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(0.0));
    startVar->SetAttribute("Max", DoubleValue(std::min(P.startWindow, P.simTime * 0.5)));
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
        onoff.Install(nodes.Get(src));
        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), kDataPort));
        sinks.Add(sink.Install(nodes.Get(dst)));
    }
    sinks.Start(Seconds(0.0));

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();
    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();
    monitor->CheckForLostPackets();

    Result r;
    r.proto = proto;
    uint64_t tx = 0, rx = 0;
    double totalDelay = 0.0;
    std::map<uint32_t, uint64_t> delayBins;
    double binWidth = 0.0;
    Ptr<Ipv4FlowClassifier> classifier =
        DynamicCast<Ipv4FlowClassifier>(fmHelper.GetClassifier());
    for (auto& kv : monitor->GetFlowStats()) {
        Ipv4FlowClassifier::FiveTuple t = classifier->FindFlow(kv.first);
        if (t.destinationPort != kDataPort) continue;  // data flows only
        tx += kv.second.txPackets;
        rx += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        Histogram h = kv.second.delayHistogram;
        for (uint32_t b = 0; b < h.GetNBins(); ++b) {
            if (binWidth == 0.0) binWidth = h.GetBinWidth(b);
            delayBins[b] += h.GetBinCount(b);
        }
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

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) if (!item.empty()) list.push_back(item);

    std::cout << "STOCK ns-3 baseline control (no AntHocNet) — mean of " << runs
              << " run(s)\n  nodes=" << P.nNodes << " time=" << P.simTime
              << "s area=" << P.areaX << "x" << P.areaY << "m speed=" << P.speed
              << "m/s pause=" << P.pause << "s range=" << P.range
              << "m flows=" << P.nFlows << " propagation=" << P.propagation << "\n\n"
              << "protocol        PDR%  delay(ms)  delay99(ms)     NRL\n"
              << "--------------------------------------------------------\n";
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
    }
    return 0;
}
