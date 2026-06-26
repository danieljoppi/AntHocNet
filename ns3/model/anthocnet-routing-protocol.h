/*
 * AntHocNet routing protocol for NS-3.
 *
 * An additive Ipv4RoutingProtocol (mirroring src/aodv) that delegates all
 * routing decisions to the shared core::AntRouterLogic. Ant control packets
 * travel over a dedicated UDP port; data packets are routed/queued via
 * RouteOutput / RouteInput.
 */
#ifndef ANTHOCNET_ROUTING_PROTOCOL_H
#define ANTHOCNET_ROUTING_PROTOCOL_H

#include "ns3/ipv4-routing-protocol.h"
#include "ns3/ipv4-interface-address.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/socket.h"
#include "ns3/timer.h"

#include <map>
#include <memory>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet-adapters.h"
#include "anthocnet-rqueue.h"

namespace ns3 {
namespace anthocnet {

class RoutingProtocol : public Ipv4RoutingProtocol
{
public:
    static TypeId GetTypeId();
    static const uint16_t ANT_PORT;  ///< UDP port for ant control traffic.

    RoutingProtocol();
    ~RoutingProtocol() override;

    // Ipv4RoutingProtocol
    Ptr<Ipv4Route> RouteOutput(Ptr<Packet> p, const Ipv4Header& header,
                               Ptr<NetDevice> oif, Socket::SocketErrno& sockerr) override;
    bool RouteInput(Ptr<const Packet> p, const Ipv4Header& header, Ptr<const NetDevice> idev,
                    const UnicastForwardCallback& ucb, const MulticastForwardCallback& mcb,
                    const LocalDeliverCallback& lcb, const ErrorCallback& ecb) override;
    void NotifyInterfaceUp(uint32_t interface) override;
    void NotifyInterfaceDown(uint32_t interface) override;
    void NotifyAddAddress(uint32_t interface, Ipv4InterfaceAddress address) override;
    void NotifyRemoveAddress(uint32_t interface, Ipv4InterfaceAddress address) override;
    void SetIpv4(Ptr<Ipv4> ipv4) override;
    void PrintRoutingTable(Ptr<OutputStreamWrapper> stream,
                           Time::Unit unit = Time::S) const override;

    /// Seed the protocol's RNG; returns the number of streams used.
    int64_t AssignStreams(int64_t stream);

protected:
    void DoInitialize() override;
    void DoDispose() override;

private:
    // address mapping between core (int32) and ns-3
    static ::anthocnet::core::NodeAddress ToCore(Ipv4Address a) {
        return static_cast<::anthocnet::core::NodeAddress>(a.Get());
    }
    static Ipv4Address ToIpv4(::anthocnet::core::NodeAddress a) {
        return Ipv4Address(static_cast<uint32_t>(a));
    }

    void Start();
    Ptr<Ipv4Route> LoopbackRoute(const Ipv4Header& header, Ptr<NetDevice> oif) const;
    bool IsMyOwnAddress(Ipv4Address src) const;
    Ptr<Socket> FindSocketWithInterfaceAddress(Ipv4InterfaceAddress addr) const;

    // ant I/O
    void RecvAnt(Ptr<Socket> socket);
    void SendAnt(const ::anthocnet::core::AntMessage& msg, Ipv4Address dest);
    void ExecuteDecisions(const std::vector<::anthocnet::core::RouteDecision>& decisions,
                          ::anthocnet::core::NodeAddress flushDest);

    // data path
    void DeferredRouteOutput(Ptr<const Packet> p, const Ipv4Header& header,
                             UnicastForwardCallback ucb, ErrorCallback ecb);
    void FlushQueue(::anthocnet::core::NodeAddress coreDest);

    // timers
    void HelloTimerExpire();
    void ProactiveTimerExpire();

    // state
    Ptr<Ipv4> m_ipv4;
    // Per-interface sockets: one bound to the unicast address (receives
    // unicast ants), one bound to the subnet-broadcast address (receives
    // broadcast hello/forward ants). A socket bound only to the unicast
    // address does NOT receive broadcasts, so both are required.
    std::map<Ptr<Socket>, Ipv4InterfaceAddress> m_socketAddresses;
    std::map<Ptr<Socket>, Ipv4InterfaceAddress> m_socketSubnetBroadcast;

    ::anthocnet::core::Config m_config;
    Ns3Clock m_clock;
    Ns3Rng m_rng;
    std::unique_ptr<::anthocnet::core::AntRouterLogic> m_logic;
    bool m_started;

    RequestQueue m_queue;

    Timer m_helloTimer;
    Timer m_proactiveTimer;

    // attribute-backed parameters
    Time m_helloInterval;
    Time m_proactiveInterval;
    double m_alpha;
    double m_betaAnts;
    double m_betaData;
    double m_gamma;
    bool m_enableProactive;
    bool m_enableDiffusion;
    double m_proactiveBroadcastProb;
    double m_sessionTtl;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_ROUTING_PROTOCOL_H
