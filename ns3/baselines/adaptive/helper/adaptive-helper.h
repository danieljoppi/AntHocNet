// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Installs one of the adaptive comparator arms (#563) like AodvHelper:
 *
 *     AdaptiveHelper ara("ns3::adaptive::AraRoutingProtocol");
 *     internet.SetRoutingHelper(ara);
 *     internet.Install(nodes);
 *     ara.AssignStreams(nodes, stream);
 */
#ifndef ADAPTIVE_HELPER_H
#define ADAPTIVE_HELPER_H

#include "ns3/ipv4-routing-helper.h"
#include "ns3/node-container.h"
#include "ns3/object-factory.h"

#include <string>

namespace ns3 {

class AdaptiveHelper : public Ipv4RoutingHelper {
public:
    /// `typeId`: ns3::adaptive::{Ara,Termite,QRouting,BeeAdHoc}RoutingProtocol.
    explicit AdaptiveHelper(const std::string& typeId);

    AdaptiveHelper* Copy() const override;
    Ptr<Ipv4RoutingProtocol> Create(Ptr<Node> node) const override;
    void Set(const std::string& name, const AttributeValue& value);

    /// Pins each installed protocol's random streams (#352); returns the count.
    int64_t AssignStreams(NodeContainer c, int64_t stream);

private:
    ObjectFactory m_factory;
};

}  // namespace ns3

#endif  // ADAPTIVE_HELPER_H
