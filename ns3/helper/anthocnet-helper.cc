#include "anthocnet-helper.h"

#include "ns3/anthocnet-routing-protocol.h"
#include "ns3/node-list.h"
#include "ns3/names.h"
#include "ns3/ipv4-list-routing.h"

namespace ns3 {

AntHocNetHelper::AntHocNetHelper() {
    m_agentFactory.SetTypeId("ns3::anthocnet::RoutingProtocol");
}

AntHocNetHelper* AntHocNetHelper::Copy() const {
    return new AntHocNetHelper(*this);
}

Ptr<Ipv4RoutingProtocol> AntHocNetHelper::Create(Ptr<Node> node) const {
    Ptr<anthocnet::RoutingProtocol> agent =
        m_agentFactory.Create<anthocnet::RoutingProtocol>();
    node->AggregateObject(agent);
    return agent;
}

void AntHocNetHelper::Set(std::string name, const AttributeValue& value) {
    m_agentFactory.Set(name, value);
}

int64_t AntHocNetHelper::AssignStreams(NodeContainer c, int64_t stream) {
    int64_t currentStream = stream;
    for (auto i = c.Begin(); i != c.End(); ++i) {
        Ptr<Node> node = *i;
        Ptr<Ipv4> ipv4 = node->GetObject<Ipv4>();
        NS_ASSERT_MSG(ipv4, "AntHocNetHelper::AssignStreams(): node has no Ipv4");
        Ptr<Ipv4RoutingProtocol> proto = ipv4->GetRoutingProtocol();
        Ptr<anthocnet::RoutingProtocol> ahn =
            DynamicCast<anthocnet::RoutingProtocol>(proto);
        if (ahn) {
            currentStream += ahn->AssignStreams(currentStream);
        }
    }
    return (currentStream - stream);
}

} // namespace ns3
