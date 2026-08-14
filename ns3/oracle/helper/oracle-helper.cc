// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "oracle-helper.h"

#include "ns3/oracle-routing-protocol.h"

#include "ns3/node.h"

namespace ns3
{

OracleHelper::OracleHelper()
    : m_topology(CreateObject<oracle::Topology>())
{
}

OracleHelper*
OracleHelper::Copy() const
{
    // Shallow by design: InternetStackHelper::SetRoutingHelper stores a Copy(),
    // and it is that copy whose Create() runs per node. The copy must therefore
    // point at the SAME Topology, or every node would get a private graph.
    return new OracleHelper(*this);
}

Ptr<Ipv4RoutingProtocol>
OracleHelper::Create(Ptr<Node> node) const
{
    Ptr<oracle::RoutingProtocol> proto = CreateObject<oracle::RoutingProtocol>();
    proto->SetTopology(m_topology);
    m_topology->Register(node);
    node->AggregateObject(proto);
    return proto;
}

void
OracleHelper::Set(const std::string& name, const AttributeValue& value)
{
    m_topology->SetAttribute(name, value);
}

int64_t
OracleHelper::AssignStreams(NodeContainer, int64_t)
{
    return 0;
}

Ptr<oracle::Topology>
OracleHelper::GetTopology() const
{
    return m_topology;
}

} // namespace ns3
