// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "source-refusal-counter.h"

#include "ns3/ipv4-routing-protocol.h"

// RouteInput callbacks went from by-value to const-reference in ns-3.37.
#ifdef ROUTING_BENCH_NS3_ROUTEINPUT_BYVALUE
#define BENCH_RI_CB(T) T
#else
#define BENCH_RI_CB(T) const T&
#endif

namespace ns3 {
namespace bench {

class SourceRefusalCounter : public Ipv4RoutingProtocol {
public:
    static TypeId GetTypeId();
    void SetTally(std::shared_ptr<uint64_t> tally) { m_tally = tally; }

    Ptr<Ipv4Route> RouteOutput(Ptr<Packet>, const Ipv4Header& header, Ptr<NetDevice>,
                               Socket::SocketErrno& sockerr) override;
    bool RouteInput(Ptr<const Packet>, const Ipv4Header&, Ptr<const NetDevice>,
                    BENCH_RI_CB(UnicastForwardCallback), BENCH_RI_CB(MulticastForwardCallback),
                    BENCH_RI_CB(LocalDeliverCallback), BENCH_RI_CB(ErrorCallback)) override {
        return false;
    }
    void NotifyInterfaceUp(uint32_t) override {}
    void NotifyInterfaceDown(uint32_t) override {}
    void NotifyAddAddress(uint32_t, Ipv4InterfaceAddress) override {}
    void NotifyRemoveAddress(uint32_t, Ipv4InterfaceAddress) override {}
    void SetIpv4(Ptr<Ipv4>) override {}
    void PrintRoutingTable(Ptr<OutputStreamWrapper>, Time::Unit = Time::S) const override {}

private:
    std::shared_ptr<uint64_t> m_tally;
};

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
