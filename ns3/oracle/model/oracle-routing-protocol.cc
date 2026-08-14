// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "oracle-routing-protocol.h"

#include "ns3/abort.h"
#include "ns3/log.h"
#include "ns3/output-stream-wrapper.h"
#include "ns3/simulator.h"

namespace ns3
{

NS_LOG_COMPONENT_DEFINE("OracleRoutingProtocol");

namespace oracle
{

NS_OBJECT_ENSURE_REGISTERED(RoutingProtocol);

TypeId
RoutingProtocol::GetTypeId()
{
    static TypeId tid = TypeId("ns3::oracle::RoutingProtocol")
                            .SetParent<Ipv4RoutingProtocol>()
                            .SetGroupName("Oracle")
                            .AddConstructor<RoutingProtocol>();
    return tid;
}

RoutingProtocol::RoutingProtocol()
{
}

RoutingProtocol::~RoutingProtocol()
{
}

void
RoutingProtocol::SetTopology(Ptr<Topology> topology)
{
    m_topology = topology;
}

Ptr<Topology>
RoutingProtocol::GetTopology() const
{
    return m_topology;
}

int64_t
RoutingProtocol::AssignStreams(int64_t)
{
    // Deliberately zero: the oracle draws no random numbers. See the header.
    return 0;
}

void
RoutingProtocol::SetIpv4(Ptr<Ipv4> ipv4)
{
    NS_ABORT_MSG_IF(!ipv4, "oracle: SetIpv4 with a null stack");
    m_ipv4 = ipv4;
}

void
RoutingProtocol::DoInitialize()
{
    NS_ABORT_MSG_IF(!m_topology,
                    "oracle::RoutingProtocol has no Topology — it must be installed through "
                    "OracleHelper, which is what shares one ground-truth graph across nodes");
    // The first node to initialise starts the recompute cadence; Start() is
    // idempotent, so the other nodes' calls are no-ops. Doing it here rather
    // than in the helper means the first solve happens at t = 0 inside the
    // running simulation, when every address has been assigned.
    m_topology->Start();
    Ipv4RoutingProtocol::DoInitialize();
}

void
RoutingProtocol::DoDispose()
{
    if (m_topology)
    {
        m_topology->Stop();
        m_topology = nullptr;
    }
    m_ipv4 = nullptr;
    Ipv4RoutingProtocol::DoDispose();
}

Ptr<Ipv4Route>
RoutingProtocol::Resolve(Ipv4Address dst, Ptr<NetDevice> oif)
{
    const NextHop nh = m_topology->Lookup(m_ipv4->GetObject<Node>(), dst);
    if (!nh.valid)
    {
        return nullptr;
    }
    Ptr<NetDevice> dev = m_ipv4->GetNetDevice(nh.iface);
    if (oif && oif != dev)
    {
        return nullptr; // the caller pinned an interface the shortest path does not use
    }
    Ptr<Ipv4Route> route = Create<Ipv4Route>();
    route->SetDestination(dst);
    route->SetGateway(nh.gateway);
    route->SetSource(m_ipv4->GetAddress(nh.iface, 0).GetLocal());
    route->SetOutputDevice(dev);
    return route;
}

Ptr<Ipv4Route>
RoutingProtocol::RouteOutput(Ptr<Packet> p,
                             const Ipv4Header& header,
                             Ptr<NetDevice> oif,
                             Socket::SocketErrno& sockerr)
{
    sockerr = Socket::ERROR_NOTERROR;
    const Ipv4Address dst = header.GetDestination();

    // Traffic to one of our own addresses goes round the loopback, as in every
    // other ns-3 routing protocol.
    if (m_ipv4->GetInterfaceForAddress(dst) >= 0 || dst == Ipv4Address::GetLoopback())
    {
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(Ipv4Address::GetLoopback());
        route->SetSource(dst == Ipv4Address::GetLoopback() ? Ipv4Address::GetLoopback() : dst);
        route->SetOutputDevice(m_ipv4->GetNetDevice(0));
        return route;
    }

    // Broadcast/multicast is not routed: a shortest path is a unicast concept,
    // and nothing in either harness's measured traffic is broadcast. Sending it
    // out one arbitrary interface would be a silent invention.
    if (dst.IsBroadcast() || dst.IsMulticast())
    {
        sockerr = Socket::ERROR_NOROUTETOHOST;
        return nullptr;
    }

    Ptr<Ipv4Route> route = Resolve(dst, oif);
    if (!route)
    {
        // No queue, no discovery, no retry: the oracle either knows the path
        // now or there is none. That is what keeps its delay pure.
        NS_LOG_LOGIC("oracle: no path to " << dst << ", dropping " << p);
        sockerr = Socket::ERROR_NOROUTETOHOST;
    }
    return route;
}

bool
RoutingProtocol::RouteInput(Ptr<const Packet> p,
                            const Ipv4Header& header,
                            Ptr<const NetDevice> idev,
                            ORACLE_RI_CB(UnicastForwardCallback) ucb,
                            ORACLE_RI_CB(MulticastForwardCallback) mcb,
                            ORACLE_RI_CB(LocalDeliverCallback) lcb,
                            ORACLE_RI_CB(ErrorCallback) ecb)
{
    NS_ABORT_MSG_IF(!m_ipv4, "oracle: RouteInput before SetIpv4");
    (void)mcb;
    const int32_t iif = m_ipv4->GetInterfaceForDevice(idev);
    if (iif < 0)
    {
        return false;
    }
    const Ipv4Address dst = header.GetDestination();
    if (m_ipv4->IsDestinationAddress(dst, static_cast<uint32_t>(iif)))
    {
        if (!lcb.IsNull())
        {
            lcb(p, header, static_cast<uint32_t>(iif));
        }
        return true;
    }
    if (dst.IsMulticast())
    {
        return false; // not ours to route (see RouteOutput)
    }
    if (!m_ipv4->IsForwarding(static_cast<uint32_t>(iif)))
    {
        ecb(p, header, Socket::ERROR_NOROUTETOHOST);
        return true;
    }
    Ptr<Ipv4Route> route = Resolve(dst, nullptr);
    if (route)
    {
        ucb(route, p, header);
        return true;
    }
    ecb(p, header, Socket::ERROR_NOROUTETOHOST);
    return true;
}

// The topology is re-derived from the simulator's own objects on a timer, and
// Ipv4::IsUp() is one of the things it reads — so an interface going up or down
// needs no bookkeeping here, and a scripted ISL break (#260) is picked up by
// the next recompute without any protocol-specific plumbing.
void
RoutingProtocol::NotifyInterfaceUp(uint32_t)
{
}

void
RoutingProtocol::NotifyInterfaceDown(uint32_t)
{
}

void
RoutingProtocol::NotifyAddAddress(uint32_t, Ipv4InterfaceAddress)
{
}

void
RoutingProtocol::NotifyRemoveAddress(uint32_t, Ipv4InterfaceAddress)
{
}

void
RoutingProtocol::PrintRoutingTable(Ptr<OutputStreamWrapper> stream, Time::Unit unit) const
{
    std::ostream* os = stream->GetStream();
    *os << "Node: " << m_ipv4->GetObject<Node>()->GetId() << ", Time: " << Simulator::Now().As(unit)
        << ", oracle shortest-path control (no routing table is exchanged; next hops are "
           "derived from the ground-truth topology)";
    if (m_topology)
    {
        *os << " mode=" << m_topology->GetMode() << " approx=" << (m_topology->IsApproximate() ? 1 : 0)
            << " nodes=" << m_topology->GetNodeCount() << " edges=" << m_topology->GetEdgeCount();
    }
    *os << "\n";
}

} // namespace oracle
} // namespace ns3
