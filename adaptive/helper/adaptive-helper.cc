// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "adaptive-helper.h"

#include "ns3/adaptive-routing-base.h"
#include "ns3/ipv4-list-routing.h"
#include "ns3/ipv4.h"
#include "ns3/node.h"

namespace ns3 {

AdaptiveHelper::AdaptiveHelper(const std::string& typeId) { m_factory.SetTypeId(typeId); }

AdaptiveHelper* AdaptiveHelper::Copy() const { return new AdaptiveHelper(*this); }

Ptr<Ipv4RoutingProtocol> AdaptiveHelper::Create(Ptr<Node> node) const {
    Ptr<adaptive::RoutingBase> agent = m_factory.Create<adaptive::RoutingBase>();
    node->AggregateObject(agent);
    return agent;
}

void AdaptiveHelper::Set(const std::string& name, const AttributeValue& value) {
    m_factory.Set(name, value);
}

int64_t AdaptiveHelper::AssignStreams(NodeContainer c, int64_t stream) {
    int64_t current = stream;
    for (auto i = c.Begin(); i != c.End(); ++i) {
        Ptr<Ipv4> ipv4 = (*i)->GetObject<Ipv4>();
        NS_ASSERT_MSG(ipv4, "Ipv4 not installed on node");
        Ptr<Ipv4RoutingProtocol> proto = ipv4->GetRoutingProtocol();
        Ptr<adaptive::RoutingBase> agent = DynamicCast<adaptive::RoutingBase>(proto);
        if (agent) {
            current += agent->AssignStreams(current);
            continue;
        }
        Ptr<Ipv4ListRouting> list = DynamicCast<Ipv4ListRouting>(proto);
        if (list) {
            int16_t priority;
            for (uint32_t k = 0; k < list->GetNRoutingProtocols(); ++k) {
                agent = DynamicCast<adaptive::RoutingBase>(list->GetRoutingProtocol(k, priority));
                if (agent) {
                    current += agent->AssignStreams(current);
                }
            }
        }
    }
    return current - stream;
}

}  // namespace ns3
