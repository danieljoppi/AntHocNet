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
#include "ns3/traced-callback.h"

#include <map>
#include <memory>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet-adapters.h"
#include "anthocnet-rqueue.h"

// ns-3 changed Ipv4RoutingProtocol::RouteInput's forwarding-callback parameters
// from by-value (<= ns-3.36) to const-reference (ns-3.37+). The override must
// match exactly or the class stays abstract. ANTHOCNET_NS3_ROUTEINPUT_BYVALUE is
// defined by the module's CMakeLists for ns-3 <= 3.36; default to const-ref.
#ifdef ANTHOCNET_NS3_ROUTEINPUT_BYVALUE
#define AHN_RI_CB(T) T
#else
#define AHN_RI_CB(T) const T&
#endif

namespace ns3 {
namespace anthocnet {

// The protocol is also a core IRouterObserver (item 15): it forwards the core's
// ant/route events to ns-3 trace sources so users can Config::Connect and so the
// comparison harness can read ant-level diagnostics. The interface is all
// no-op-default virtuals, so this adds no state to the core.
class RoutingProtocol : public Ipv4RoutingProtocol,
                        public ::anthocnet::core::IRouterObserver
{
public:
    static TypeId GetTypeId();
    static const uint16_t ANT_PORT;  ///< UDP port for ant control traffic.

    RoutingProtocol();
    ~RoutingProtocol() override;

    // Trace-source callback signatures (introspection names used in GetTypeId).
    typedef void (*AntTxCallback)(uint8_t type, uint8_t direction, bool broadcast);
    typedef void (*AntRxCallback)(uint8_t type, uint8_t direction);
    typedef void (*RouteChangedCallback)(uint32_t dest, uint32_t neighbor, bool added);

    // core::IRouterObserver
    void onAntSent(::anthocnet::core::AntType type,
                   ::anthocnet::core::AntDirection dir, bool broadcast) override;
    void onAntReceived(::anthocnet::core::AntType type,
                       ::anthocnet::core::AntDirection dir) override;
    void onRouteChanged(::anthocnet::core::NodeAddress dest,
                        ::anthocnet::core::NodeAddress nb, bool added) override;

    // Ipv4RoutingProtocol
    Ptr<Ipv4Route> RouteOutput(Ptr<Packet> p, const Ipv4Header& header,
                               Ptr<NetDevice> oif, Socket::SocketErrno& sockerr) override;
    bool RouteInput(Ptr<const Packet> p, const Ipv4Header& header, Ptr<const NetDevice> idev,
                    AHN_RI_CB(UnicastForwardCallback) ucb, AHN_RI_CB(MulticastForwardCallback) mcb,
                    AHN_RI_CB(LocalDeliverCallback) lcb, AHN_RI_CB(ErrorCallback) ecb) override;
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

public:
    // Address mapping between core (int32 NodeAddress == the IP, opaque) and
    // ns-3 (ADR-0011). Broadcast is a RouteAction, never an identity, so the
    // all-ones address must never reach the core as a peer; guard it so it
    // cannot alias kInvalidAddress (-1 == 0xFFFFFFFF). MSB-set unicast IPs map
    // to negative ints and round-trip fine — only the all-ones value collides.
    // Public so the test suite can assert the round-trip / sentinel guard.
    static ::anthocnet::core::NodeAddress ToCore(Ipv4Address a) {
        const uint32_t raw = a.Get();
        if (raw == 0xFFFFFFFFu) return 0;  // limited broadcast: not an identity
        return static_cast<::anthocnet::core::NodeAddress>(raw);
    }
    static Ipv4Address ToIpv4(::anthocnet::core::NodeAddress a) {
        return Ipv4Address(static_cast<uint32_t>(a));
    }

private:
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

    // trace sources (item 15): ant sent/received and route add/remove.
    TracedCallback<uint8_t, uint8_t, bool> m_txAntTrace;
    TracedCallback<uint8_t, uint8_t> m_rxAntTrace;
    TracedCallback<uint32_t, uint32_t, bool> m_routeChangedTrace;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_ROUTING_PROTOCOL_H
