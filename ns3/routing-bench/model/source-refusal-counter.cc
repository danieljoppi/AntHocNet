// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "source-refusal-counter.h"

namespace ns3 {
namespace bench {

NS_OBJECT_ENSURE_REGISTERED(SourceRefusalCounter);

TypeId SourceRefusalCounter::GetTypeId() {
    static TypeId tid = TypeId("ns3::bench::SourceRefusalCounter")
                            .SetParent<Ipv4RoutingProtocol>()
                            .SetGroupName("RoutingBench")
                            .AddConstructor<SourceRefusalCounter>();
    return tid;
}

Ptr<Ipv4Route> SourceRefusalCounter::RouteOutput(Ptr<Packet>, const Ipv4Header& header,
                                                 Ptr<NetDevice>, Socket::SocketErrno& sockerr) {
    // Broadcast control never reaches RouteOutput (the UDP socket sends a
    // limited broadcast straight out of the interface), so a unicast refusal
    // here is a data send.
    const Ipv4Address dst = header.GetDestination();
    if (m_tally && !dst.IsBroadcast() && !dst.IsMulticast() && !dst.IsLocalhost()) {
        ++*m_tally;
    }
    sockerr = Socket::ERROR_NOROUTETOHOST;
    return nullptr;
}

Ptr<Ipv4RoutingProtocol> SourceRefusalCounterHelper::Create(Ptr<Node>) const {
    Ptr<SourceRefusalCounter> counter = CreateObject<SourceRefusalCounter>();
    counter->SetTally(m_tally);
    return counter;
}

}  // namespace bench
}  // namespace ns3
