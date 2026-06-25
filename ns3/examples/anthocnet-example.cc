/*
 * Minimal AntHocNet (NS-3) example: a small wifi ad-hoc network where one node
 * sends UDP traffic to another, routed by AntHocNet. Prints the delivery
 * ratio at the end.
 *
 * Run:
 *   ./ns3 run anthocnet-example
 *   ./ns3 run "anthocnet-example --nNodes=15 --time=30"
 */
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/mobility-module.h"
#include "ns3/wifi-module.h"
#include "ns3/internet-module.h"
#include "ns3/applications-module.h"

#include "ns3/anthocnet-helper.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE("AntHocNetExample");

int main(int argc, char* argv[]) {
    uint32_t nNodes = 10;
    double simTime = 20.0;
    // Keep the area small enough that nodes are within the default YansWifi
    // range (~50 m) and form a connected multi-hop mesh; a larger area simply
    // partitions the network and nothing (any protocol) is delivered.
    double areaSize = 100.0;

    CommandLine cmd(__FILE__);
    cmd.AddValue("nNodes", "Number of nodes", nNodes);
    cmd.AddValue("time", "Simulation time (s)", simTime);
    cmd.AddValue("area", "Square area side (m)", areaSize);
    cmd.Parse(argc, argv);

    NodeContainer nodes;
    nodes.Create(nNodes);

    // Wifi ad-hoc PHY/MAC.
    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
    YansWifiPhyHelper phy;
    YansWifiChannelHelper channel = YansWifiChannelHelper::Default();
    phy.SetChannel(channel.Create());
    WifiMacHelper mac;
    mac.SetType("ns3::AdhocWifiMac");
    NetDeviceContainer devices = wifi.Install(phy, mac, nodes);

    // Random placement + random waypoint mobility.
    MobilityHelper mobility;
    Ptr<UniformRandomVariable> x = CreateObject<UniformRandomVariable>();
    x->SetAttribute("Min", DoubleValue(0.0));
    x->SetAttribute("Max", DoubleValue(areaSize));
    Ptr<RandomRectanglePositionAllocator> pos =
        CreateObject<RandomRectanglePositionAllocator>();
    pos->SetX(x);
    pos->SetY(x);
    mobility.SetPositionAllocator(pos);
    mobility.SetMobilityModel("ns3::RandomWaypointMobilityModel",
                              "Speed", StringValue("ns3::UniformRandomVariable[Min=1.0|Max=5.0]"),
                              "Pause", StringValue("ns3::ConstantRandomVariable[Constant=2.0]"),
                              "PositionAllocator", PointerValue(pos));
    mobility.Install(nodes);

    // AntHocNet routing.
    AntHocNetHelper anthocnet;
    InternetStackHelper internet;
    internet.SetRoutingHelper(anthocnet);
    internet.Install(nodes);

    Ipv4AddressHelper address;
    address.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer interfaces = address.Assign(devices);

    // One CBR flow node0 -> node(last).
    uint16_t port = 9;
    OnOffHelper onoff("ns3::UdpSocketFactory",
                      InetSocketAddress(interfaces.GetAddress(nNodes - 1), port));
    onoff.SetAttribute("DataRate", StringValue("8kbps"));
    onoff.SetAttribute("PacketSize", UintegerValue(64));
    onoff.SetAttribute("StartTime", TimeValue(Seconds(5.0)));
    onoff.SetAttribute("StopTime", TimeValue(Seconds(simTime - 1.0)));
    ApplicationContainer apps = onoff.Install(nodes.Get(0));

    PacketSinkHelper sink("ns3::UdpSocketFactory",
                          InetSocketAddress(Ipv4Address::GetAny(), port));
    ApplicationContainer sinkApps = sink.Install(nodes.Get(nNodes - 1));
    sinkApps.Start(Seconds(0.0));

    Simulator::Stop(Seconds(simTime));
    Simulator::Run();

    Ptr<PacketSink> sinkPtr = DynamicCast<PacketSink>(sinkApps.Get(0));
    std::cout << "AntHocNet example: " << nNodes << " nodes, " << simTime << "s\n";
    std::cout << "  bytes received at sink: " << sinkPtr->GetTotalRx() << "\n";

    Simulator::Destroy();
    return 0;
}
