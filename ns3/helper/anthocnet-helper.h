/*
 * Helper to install the AntHocNet routing protocol on nodes, mirroring
 * AodvHelper.
 */
#ifndef ANTHOCNET_HELPER_H
#define ANTHOCNET_HELPER_H

#include "ns3/ipv4-routing-helper.h"
#include "ns3/object-factory.h"
#include "ns3/node-container.h"

namespace ns3 {

class AntHocNetHelper : public Ipv4RoutingHelper
{
public:
    AntHocNetHelper();

    AntHocNetHelper* Copy() const override;
    Ptr<Ipv4RoutingProtocol> Create(Ptr<Node> node) const override;

    /// Set an attribute on the routing protocol to be created.
    void Set(std::string name, const AttributeValue& value);

    /// Seed the protocol RNGs on the given nodes; returns streams used.
    int64_t AssignStreams(NodeContainer c, int64_t stream);

private:
    ObjectFactory m_agentFactory;
};

} // namespace ns3

#endif // ANTHOCNET_HELPER_H
