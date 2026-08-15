/*
 * Minimal standalone reproducer for an ns-3 DSDV defect.
 *
 * Stock ns-3 modules only: core, network, internet, point-to-point,
 * applications, dsdv.  No external contrib code.
 *
 * Topology: a three-node point-to-point chain.
 *
 *      n0 ---- 10.1.1.0/30 ---- n1 ---- 10.1.2.0/30 ---- n2
 *   10.1.1.1              10.1.1.2  10.1.2.1              10.1.2.2
 *
 * n1 is the only node with more than one non-loopback interface.
 */

#include "ns3/applications-module.h"
#include "ns3/core-module.h"
#include "ns3/csma-module.h"
#include "ns3/aodv-module.h"
#include "ns3/dsdv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/internet-module.h"
#include "ns3/network-module.h"
#include "ns3/point-to-point-module.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE("DsdvMultiInterfaceCrash");

int
main(int argc, char* argv[])
{
    uint32_t nNodes = 3;
    double stopTime = 40.0;
    bool useCsma = false;
    std::string protocol = "dsdv";

    CommandLine cmd(__FILE__);
    cmd.AddValue("nNodes", "Number of nodes in the chain (>=3 gives a multi-interface node)", nNodes);
    cmd.AddValue("stopTime", "Simulation stop time in seconds", stopTime);
    cmd.AddValue("csma", "Use CSMA links instead of point-to-point", useCsma);
    cmd.AddValue("protocol", "Routing protocol: dsdv | aodv | olsr | rip", protocol);
    cmd.Parse(argc, argv);

    NS_ABORT_MSG_IF(nNodes < 2, "need at least 2 nodes");

    NodeContainer nodes;
    nodes.Create(nNodes);

    PointToPointHelper p2p;
    p2p.SetDeviceAttribute("DataRate", StringValue("5Mbps"));
    p2p.SetChannelAttribute("Delay", StringValue("2ms"));

    CsmaHelper csma;
    csma.SetChannelAttribute("DataRate", StringValue("5Mbps"));
    csma.SetChannelAttribute("Delay", StringValue("2ms"));

    // One device per link. The interior nodes of the chain therefore each hold
    // two non-loopback interfaces -- exactly the shape of a satellite with
    // several inter-satellite links. The device type is irrelevant to the bug;
    // --csma selects CSMA to demonstrate that.
    std::vector<NetDeviceContainer> links;
    for (uint32_t i = 0; i + 1 < nNodes; ++i)
    {
        NodeContainer pair(nodes.Get(i), nodes.Get(i + 1));
        links.push_back(useCsma ? csma.Install(pair) : p2p.Install(pair));
    }

    // The routing protocol is selectable purely so the same topology can be
    // used to show that the sibling protocols survive it. Default is dsdv.
    InternetStackHelper internet;
    DsdvHelper dsdv;
    AodvHelper aodv;
    OlsrHelper olsr;
    RipHelper rip;
    if (protocol == "dsdv")
    {
        internet.SetRoutingHelper(dsdv);
    }
    else if (protocol == "aodv")
    {
        internet.SetRoutingHelper(aodv);
    }
    else if (protocol == "olsr")
    {
        internet.SetRoutingHelper(olsr);
    }
    else if (protocol == "rip")
    {
        internet.SetRoutingHelper(rip);
    }
    else
    {
        NS_ABORT_MSG("unknown protocol " << protocol);
    }
    internet.Install(nodes);

    // A distinct /30 per link, as an ISL mesh would use.
    Ipv4AddressHelper ipv4;
    std::vector<Ipv4InterfaceContainer> ifaces;
    for (uint32_t i = 0; i + 1 < nNodes; ++i)
    {
        std::ostringstream base;
        base << "10.1." << (i + 1) << ".0";
        ipv4.SetBase(base.str().c_str(), "255.255.255.252");
        ifaces.push_back(ipv4.Assign(links[i]));
    }

    // Report the interface count per node, so the run output shows the trigger
    // condition directly.
    for (uint32_t i = 0; i < nNodes; ++i)
    {
        Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
        std::cout << "node " << i << " has " << (ip->GetNInterfaces() - 1)
                  << " non-loopback interface(s):";
        for (uint32_t k = 1; k < ip->GetNInterfaces(); ++k)
        {
            std::cout << " " << ip->GetAddress(k, 0).GetLocal();
        }
        std::cout << std::endl;
    }

    // Traffic from the last node to the first: a path of (nNodes-1) hops, so
    // the route entry at the sender has hop count > 1.
    Ipv4Address dstAddr = ifaces.front().GetAddress(0); // 10.1.1.1, on n0
    uint16_t port = 9;

    PacketSinkHelper sink("ns3::UdpSocketFactory",
                          InetSocketAddress(Ipv4Address::GetAny(), port));
    ApplicationContainer sinkApp = sink.Install(nodes.Get(0));
    sinkApp.Start(Seconds(0.0));
    sinkApp.Stop(Seconds(stopTime));

    OnOffHelper onoff("ns3::UdpSocketFactory", InetSocketAddress(dstAddr, port));
    onoff.SetAttribute("OnTime", StringValue("ns3::ConstantRandomVariable[Constant=1]"));
    onoff.SetAttribute("OffTime", StringValue("ns3::ConstantRandomVariable[Constant=0]"));
    onoff.SetAttribute("DataRate", StringValue("2kbps"));
    onoff.SetAttribute("PacketSize", UintegerValue(64));
    ApplicationContainer srcApp = onoff.Install(nodes.Get(nNodes - 1));
    srcApp.Start(Seconds(1.0));
    srcApp.Stop(Seconds(stopTime));

    std::cout << "sending from node " << (nNodes - 1) << " to " << dstAddr << std::endl;
    std::cout << "--- starting simulator ---" << std::endl;

    Simulator::Stop(Seconds(stopTime));
    Simulator::Run();
    Simulator::Destroy();

    uint64_t rx = DynamicCast<PacketSink>(sinkApp.Get(0))->GetTotalRx();
    std::cout << "--- simulator finished without crashing; sink received " << rx << " bytes ---"
              << std::endl;
    return 0;
}
