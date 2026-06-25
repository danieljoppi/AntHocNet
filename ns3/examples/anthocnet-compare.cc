/*
 * AntHocNet vs. AODV / OLSR / DSDV comparison.
 *
 * Runs the SAME mobile-ad-hoc scenario (identical node layout, mobility and
 * CBR traffic, driven from the same RNG run) under each routing protocol and
 * prints packet-delivery ratio, mean end-to-end delay and throughput from a
 * FlowMonitor. Fair comparison: the RNG run is reset before each protocol so
 * every protocol sees the identical mobility/traffic realisation.
 *
 * Requires the aodv, olsr, dsdv and flow-monitor modules (in addition to
 * anthocnet, wifi, mobility, applications). Build with those enabled:
 *   ./ns3 configure --enable-modules='anthocnet;wifi;mobility;applications;aodv;olsr;dsdv;flow-monitor' --enable-examples
 *   ./ns3 run "anthocnet-compare --nNodes=20 --time=40"
 */
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/mobility-module.h"
#include "ns3/wifi-module.h"
#include "ns3/internet-module.h"
#include "ns3/applications-module.h"
#include "ns3/flow-monitor-module.h"

#include "ns3/aodv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/dsdv-module.h"
#include "ns3/anthocnet-helper.h"

#include <iomanip>
#include <vector>

using namespace ns3;

struct Result {
    std::string proto;
    uint64_t txPackets = 0;
    uint64_t rxPackets = 0;
    double pdr = 0.0;          // %
    double meanDelayMs = 0.0;
    double throughputKbps = 0.0;
};

static Result RunOne(const std::string& proto, uint32_t nNodes, double simTime,
                     double area, double speed, uint32_t nFlows, uint32_t seed) {
    // Reset the RNG run so every protocol sees the identical realisation.
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);

    NodeContainer nodes;
    nodes.Create(nNodes);

    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
    YansWifiPhyHelper phy;
    YansWifiChannelHelper channel = YansWifiChannelHelper::Default();
    phy.SetChannel(channel.Create());
    WifiMacHelper mac;
    mac.SetType("ns3::AdhocWifiMac");
    NetDeviceContainer devices = wifi.Install(phy, mac, nodes);

    MobilityHelper mobility;
    Ptr<UniformRandomVariable> u = CreateObject<UniformRandomVariable>();
    u->SetAttribute("Min", DoubleValue(0.0));
    u->SetAttribute("Max", DoubleValue(area));
    Ptr<RandomRectanglePositionAllocator> pos =
        CreateObject<RandomRectanglePositionAllocator>();
    pos->SetX(u);
    pos->SetY(u);
    mobility.SetPositionAllocator(pos);
    std::ostringstream speedStr;
    speedStr << "ns3::UniformRandomVariable[Min=1.0|Max=" << speed << "]";
    mobility.SetMobilityModel("ns3::RandomWaypointMobilityModel",
                              "Speed", StringValue(speedStr.str()),
                              "Pause", StringValue("ns3::ConstantRandomVariable[Constant=1.0]"),
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

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer ifs = address.Assign(devices);

    // nFlows CBR flows from node i to node (nNodes-1-i).
    uint16_t port = 9;
    ApplicationContainer apps, sinks;
    for (uint32_t i = 0; i < nFlows && i < nNodes / 2; ++i) {
        uint32_t src = i;
        uint32_t dst = nNodes - 1 - i;
        OnOffHelper onoff("ns3::UdpSocketFactory",
                          InetSocketAddress(ifs.GetAddress(dst), port));
        onoff.SetAttribute("DataRate", StringValue("8kbps"));
        onoff.SetAttribute("PacketSize", UintegerValue(64));
        onoff.SetAttribute("StartTime", TimeValue(Seconds(5.0 + i * 0.1)));
        onoff.SetAttribute("StopTime", TimeValue(Seconds(simTime - 1.0)));
        apps.Add(onoff.Install(nodes.Get(src)));

        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), port));
        sinks.Add(sink.Install(nodes.Get(dst)));
    }
    sinks.Start(Seconds(0.0));

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();

    Simulator::Stop(Seconds(simTime));
    Simulator::Run();

    monitor->CheckForLostPackets();
    Result r;
    r.proto = proto;
    double totalDelay = 0.0;
    uint64_t rxForDelay = 0;
    double totalRxBytes = 0.0;
    for (auto& kv : monitor->GetFlowStats()) {
        r.txPackets += kv.second.txPackets;
        r.rxPackets += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        rxForDelay += kv.second.rxPackets;
        totalRxBytes += kv.second.rxBytes;
    }
    r.pdr = r.txPackets ? 100.0 * r.rxPackets / r.txPackets : 0.0;
    r.meanDelayMs = rxForDelay ? 1000.0 * totalDelay / rxForDelay : 0.0;
    r.throughputKbps = (totalRxBytes * 8.0 / 1000.0) / simTime;

    Simulator::Destroy();
    return r;
}

int main(int argc, char* argv[]) {
    uint32_t nNodes = 20;
    double simTime = 40.0;
    double area = 300.0;
    double speed = 5.0;
    uint32_t nFlows = 5;
    uint32_t seed = 1;
    std::string protocols = "anthocnet,aodv,olsr,dsdv";

    CommandLine cmd(__FILE__);
    cmd.AddValue("nNodes", "Number of nodes", nNodes);
    cmd.AddValue("time", "Simulation time (s)", simTime);
    cmd.AddValue("area", "Square area side (m)", area);
    cmd.AddValue("speed", "Max node speed (m/s)", speed);
    cmd.AddValue("flows", "Number of CBR flows", nFlows);
    cmd.AddValue("seed", "RNG run", seed);
    cmd.AddValue("protocols", "Comma-separated list", protocols);
    cmd.Parse(argc, argv);

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) {
        if (!item.empty()) list.push_back(item);
    }

    std::cout << "AntHocNet protocol comparison\n"
              << "  nodes=" << nNodes << " time=" << simTime << "s area=" << area
              << "m maxSpeed=" << speed << "m/s flows=" << nFlows
              << " seed=" << seed << "\n\n";
    std::cout << std::left << std::setw(12) << "protocol"
              << std::right << std::setw(8) << "tx" << std::setw(8) << "rx"
              << std::setw(9) << "PDR%" << std::setw(12) << "delay(ms)"
              << std::setw(14) << "thrput(kbps)" << "\n";
    std::cout << std::string(63, '-') << "\n";

    for (const std::string& p : list) {
        Result r = RunOne(p, nNodes, simTime, area, speed, nFlows, seed);
        std::cout << std::left << std::setw(12) << r.proto
                  << std::right << std::setw(8) << r.txPackets
                  << std::setw(8) << r.rxPackets
                  << std::setw(9) << std::fixed << std::setprecision(1) << r.pdr
                  << std::setw(12) << std::setprecision(1) << r.meanDelayMs
                  << std::setw(14) << std::setprecision(2) << r.throughputKbps << "\n";
    }
    return 0;
}
