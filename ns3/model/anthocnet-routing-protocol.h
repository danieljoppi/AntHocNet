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
#include "ns3/mac48-address.h"
#include "ns3/wifi-mac.h"

// ns-3 renamed WifiMacQueueItem -> WifiMpdu (and wifi-mac-queue-item.h ->
// wifi-mpdu.h) in ns-3.37; the WifiMac "DroppedMpdu" trace carries this type.
// ANTHOCNET_NS3_WIFI_QUEUE_ITEM is defined by the module's CMakeLists for
// ns-3 <= 3.36; default to the modern name.
#ifdef ANTHOCNET_NS3_WIFI_QUEUE_ITEM
#include "ns3/wifi-mac-queue-item.h"
#define AHN_WIFI_MPDU ns3::WifiMacQueueItem
#else
#include "ns3/wifi-mpdu.h"
#define AHN_WIFI_MPDU ns3::WifiMpdu
#endif

#include <map>
#include <memory>
#include <set>

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
                        public ::anthocnet::core::IRouterObserver,
                        public ::anthocnet::core::ILinkState
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

    // core::ILinkState (item 10/A2): supply MAC congestion signals for the
    // congestion-aware per-hop metric. Only meaningful when EnableMacMetric is
    // set; the core queries these while stamping a forward ant.
    int macQueueLength() const override;
    ::anthocnet::core::Time macServiceTime() const override;

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

    /// Issue #20 diagnostics: LinkFail origin/propagation split from the core
    /// (origins = antTx[linkfail] − propagations; budget drops = suppressed).
    uint64_t LinkfailPropagations() const {
        return m_logic ? m_logic->linkfailPropagations() : 0;
    }
    uint64_t LinkfailBudgetDrops() const {
        return m_logic ? m_logic->linkfailBudgetDrops() : 0;
    }
    uint64_t LinkfailOriginsSuppressed() const {
        return m_logic ? m_logic->linkfailOriginsSuppressed() : 0;
    }

    /// Issue #133 observability: per-node pheromone-table size gauge from the
    /// core — current (neighbor, dest) entry counts, split regular vs virtual.
    /// Read by the comparison harness under --diag to watch table growth.
    uint64_t PtableEntriesRegular() const {
        return m_logic ? m_logic->table().numEntriesRegular() : 0;
    }
    uint64_t PtableEntriesVirtual() const {
        return m_logic ? m_logic->table().numEntriesVirtual() : 0;
    }

    /// Issue #21 hold-time attribution: per-reason (setup / reconvergence /
    /// repair) pending-queue hold-time stats accumulated over the run, read by
    /// the comparison harness under --diag to locate the delay tail's dominant
    /// hold path.
    const HoldStats& HoldTimeStats() const { return m_queue.Stats(); }

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
    /// Repair wait expired ([1] §3.5, D6): drop the packets queued for
    /// `coreDest`, firing their error callbacks.
    void DiscardQueue(::anthocnet::core::NodeAddress coreDest);

    // timers
    void HelloTimerExpire();
    void ProactiveTimerExpire();
    /// Issue #21: re-flood a reactive forward ant for every destination with
    /// data still waiting in the pending queue but no route. onDataPacket only
    /// retries when a data packet arrives (~1 pkt/s at paper CBR), so a lost
    /// first re-discovery attempt otherwise waits a full second; this timer
    /// retries at a sub-second cadence, shortening the reconvergence hold that
    /// dominates the delay/jitter tail.
    void ReactiveRetryTimerExpire();

    // ADR-0008 detector D: MAC transmit-failure hook. The WifiMac "DroppedMpdu"
    // trace fires when a unicast frame is dropped after exhausting retries; we
    // treat a retry-limit drop as a broken link to that next hop and drive the
    // shared core reportTxFailure path (prune + bounded repair ant).
    void NotifyTxError(WifiMacDropReason reason, Ptr<const AHN_WIFI_MPDU> mpdu);
    /// Issue #68: successful-transmission hook — samples the measured
    /// per-packet MAC service time for the A2 congestion metric.
    void NotifyAckedMpdu(Ptr<const AHN_WIFI_MPDU> mpdu);
    // Resolve a failed next-hop MAC to a core address via the ARP caches.
    bool MapMacToCore(const Mac48Address& mac,
                      ::anthocnet::core::NodeAddress& out) const;

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
    Timer m_reactiveRetryTimer;  ///< issue #21: re-flood discovery for held data

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
    uint32_t m_txFailureThreshold;
    bool m_enableMacFailureDetector;
    double m_repairWaitFactor;
    double m_repairTimeout;
    double m_hopTime;                 ///< T_hop unloaded-hop reference (s), #88
    bool m_enableMultipath;           ///< multipath reactive setup gate, #96
    double m_antAcceptanceFactor;     ///< multipath 1.5x acceptance factor, #96
    double m_linkfailNotifyInterval;  ///< issue #20 origin cooldown (s), 0 = off
    Time m_queueTimeout;              ///< issue #21 pending-queue hold before drop
    Time m_reconvHoldCap;             ///< issue #21 L2: cap on reconv holds (0 = off)
    Time m_repairHoldCap;             ///< issue #21 L2: cap on repair holds (0 = off)
    Time m_reactiveRetryInterval;     ///< issue #21 timer-driven re-discovery cadence (0 = off)
    // Issue #68: measured per-packet MAC service time (EWMA of inter-ack
    // spacing while the MAC queue stays backlogged — pure service time, no
    // queue wait, so (Q+1)*T̂_mac does not double-count congestion).
    double m_macServiceAlpha;         ///< EWMA smoothing (old-value weight)
    double m_macServiceEwmaSec = 0.0; ///< 0 = no sample yet (core falls back)
    Time m_lastAckTime;               ///< previous AckedMpdu timestamp
    bool m_backlogAtLastAck = false;  ///< queue was non-empty at previous ack
    bool m_enableMacMetric;  ///< item 10/A2 congestion-aware per-hop metric

    // WifiMac handle for the item-10/A2 queue-occupancy signal (null on non-wifi
    // devices, where the metric falls back to the unloaded reference hop time).
    Ptr<WifiMac> m_wifiMac;

    // L3 forwarding callbacks cached from RouteInput (Ipv4L3Protocol passes the
    // same bound callbacks on every call). NotifyTxError needs them to re-inject
    // a MAC-dropped data packet it only sees as a raw MPDU (issue #46).
    UnicastForwardCallback m_cachedUcb;
    ErrorCallback m_cachedEcb;

    // Destinations this node has ever had a usable next hop for (issue #21):
    // separates a first-time reactive setup (never routed) from a
    // reconvergence wait (route was known and lost) when a data packet is
    // deferred, so the hold-time attribution can tell the two apart.
    std::set<::anthocnet::core::NodeAddress> m_everRouted;

    // trace sources (item 15): ant sent/received and route add/remove.
    TracedCallback<uint8_t, uint8_t, bool> m_txAntTrace;
    TracedCallback<uint8_t, uint8_t> m_rxAntTrace;
    TracedCallback<uint32_t, uint32_t, bool> m_routeChangedTrace;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_ROUTING_PROTOCOL_H
