/*
 * Single-interface DSDV stress harness.
 *
 * Purpose: test whether ns-3 DSDV defect (a) -- LookForQueuedPackets()
 * discarding LookupRoute()'s return value and forwarding on a route whose
 * output device is null -- is reachable WITHOUT the multi-interface
 * advertisement defect (b).
 *
 * Every node here has exactly ONE non-loopback interface (wifi ad hoc), so
 * DSDV's hardcoded m_ipv4->GetAddress(1, 0) advertisement is correct by
 * construction and defect (b) is inert.
 *
 * This mirrors the configuration of ns-3 issue #503 (wifi ad hoc, DSDV,
 * intermittent at ~0.27% of runs) and of examples/routing/manet-routing-compare.
 *
 * Mobility drives route churn, which drives RoutingTable::Purge(). Purge
 * erases a dependent entry j only when
 *     j.GetNextHop() == i.GetDestination() && i.GetHop() != j.GetHop()
 * (dsdv-rtable.cc:225-227), so a dependent whose hop count EQUALS the purged
 * entry's survives with a next hop that no longer resolves -- the state that
 * makes the unchecked lookup at dsdv-routing-protocol.cc:1161 return a
 * default-constructed entry.
 */

#include "ns3/applications-module.h"
#include "ns3/core-module.h"
#include "ns3/dsdv-module.h"
#include "ns3/internet-module.h"
#include "ns3/mobility-module.h"
#include "ns3/network-module.h"
#include "ns3/wifi-module.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE("DsdvSingleInterfaceStress");

int
main(int argc, char* argv[])
{
    uint32_t nNodes = 30;
    uint32_t nFlows = 10;
    double stopTime = 60.0;
    double speed = 20.0;
    // 400 m is deliberate: at 1500 m the 30 nodes are out of wifi range of one
    // another, every run delivers 0 bytes, and a clean sweep would prove
    // nothing. Keep this small enough that multi-hop routes actually form.
    double area = 400.0;

    CommandLine cmd(__FILE__);
    cmd.AddValue("nNodes", "Number of nodes", nNodes);
    cmd.AddValue("nFlows", "Number of CBR flows", nFlows);
    cmd.AddValue("stopTime", "Simulation stop time", stopTime);
    cmd.AddValue("speed", "Max node speed (m/s)", speed);
    cmd.AddValue("area", "Square side length (m)", area);
    cmd.Parse(argc, argv);

    NodeContainer nodes;
    nodes.Create(nNodes);

    // One wifi ad hoc device per node -> exactly one non-loopback interface.
    WifiHelper wifi;
    wifi.SetStandard(WIFI_STANDARD_80211b);
    wifi.SetRemoteStationManager("ns3::ConstantRateWifiManager",
                                 "DataMode",
                                 StringValue("DsssRate11Mbps"),
                                 "ControlMode",
                                 StringValue("DsssRate1Mbps"));

    YansWifiChannelHelper channel = YansWifiChannelHelper::Default();
    YansWifiPhyHelper phy;
    phy.SetChannel(channel.Create());

    WifiMacHelper mac;
    mac.SetType("ns3::AdhocWifiMac");
    NetDeviceContainer devices = wifi.Install(phy, mac, nodes);

    // Random waypoint mobility: forces continual route churn and therefore
    // continual RoutingTable::Purge() activity.
    MobilityHelper mobility;
    ObjectFactory pos;
    pos.SetTypeId("ns3::RandomRectanglePositionAllocator");
    std::ostringstream xs;
    xs << "ns3::UniformRandomVariable[Min=0.0|Max=" << area << "]";
    pos.Set("X", StringValue(xs.str()));
    pos.Set("Y", StringValue(xs.str()));
    Ptr<PositionAllocator> posAlloc = pos.Create()->GetObject<PositionAllocator>();

    std::ostringstream ss;
    ss << "ns3::UniformRandomVariable[Min=1.0|Max=" << speed << "]";
    mobility.SetMobilityModel("ns3::RandomWaypointMobilityModel",
                              "Speed",
                              StringValue(ss.str()),
                              "Pause",
                              StringValue("ns3::ConstantRandomVariable[Constant=0.2]"),
                              "PositionAllocator",
                              PointerValue(posAlloc));
    mobility.SetPositionAllocator(posAlloc);
    mobility.Install(nodes);

    DsdvHelper dsdv;
    InternetStackHelper internet;
    internet.SetRoutingHelper(dsdv);
    internet.Install(nodes);

    Ipv4AddressHelper ipv4;
    ipv4.SetBase("10.1.0.0", "255.255.0.0");
    Ipv4InterfaceContainer ifaces = ipv4.Assign(devices);

    // Assert the single-interface precondition holds for every node.
    for (uint32_t i = 0; i < nNodes; ++i)
    {
        Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
        NS_ABORT_MSG_IF(ip->GetNInterfaces() != 2,
                        "node " << i << " does not have exactly one non-loopback interface");
    }

    uint16_t port = 9;
    ApplicationContainer allSinks;
    for (uint32_t f = 0; f < nFlows && f < nNodes / 2; ++f)
    {
        uint32_t src = f;
        uint32_t dst = nNodes - 1 - f;

        PacketSinkHelper sink("ns3::UdpSocketFactory",
                              InetSocketAddress(Ipv4Address::GetAny(), port + f));
        ApplicationContainer sinkApp = sink.Install(nodes.Get(dst));
        allSinks.Add(sinkApp);
        sinkApp.Start(Seconds(0.0));
        sinkApp.Stop(Seconds(stopTime));

        OnOffHelper onoff("ns3::UdpSocketFactory",
                          InetSocketAddress(ifaces.GetAddress(dst), port + f));
        onoff.SetAttribute("OnTime", StringValue("ns3::ConstantRandomVariable[Constant=1]"));
        onoff.SetAttribute("OffTime", StringValue("ns3::ConstantRandomVariable[Constant=0]"));
        onoff.SetAttribute("DataRate", StringValue("4kbps"));
        onoff.SetAttribute("PacketSize", UintegerValue(64));
        ApplicationContainer srcApp = onoff.Install(nodes.Get(src));
        srcApp.Start(Seconds(1.0 + 0.1 * f));
        srcApp.Stop(Seconds(stopTime));
    }

    Simulator::Stop(Seconds(stopTime));
    Simulator::Run();
    Simulator::Destroy();

    uint64_t rx = 0;
    for (uint32_t i = 0; i < allSinks.GetN(); ++i)
    {
        rx += DynamicCast<PacketSink>(allSinks.Get(i))->GetTotalRx();
    }
    // A run that delivered nothing proves nothing: report the byte count so a
    // clean sweep cannot be mistaken for a sweep that never routed anything.
    std::cout << "OK run completed; delivered " << rx << " bytes" << std::endl;
    return 0;
}
