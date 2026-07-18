#include "anthocnet-routing-protocol.h"
#include "anthocnet-packet.h"

#include "ns3/log.h"
#include "ns3/node.h"
#include "ns3/boolean.h"
#include "ns3/double.h"
#include "ns3/uinteger.h"
#include "ns3/inet-socket-address.h"
#include "ns3/udp-socket-factory.h"
#include "ns3/ipv4-route.h"
#include "ns3/simulator.h"
#include "ns3/trace-source-accessor.h"
#include "ns3/wifi-net-device.h"
#include "ns3/wifi-mac-queue.h"
#include "ns3/qos-utils.h"
#include "ns3/ipv4-interface.h"
#include "ns3/arp-cache.h"
#include "ns3/llc-snap-header.h"
#include "ns3/udp-header.h"

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("AntHocNetRoutingProtocol");

namespace anthocnet {

using ::anthocnet::core::AntMessage;
using ::anthocnet::core::AntType;
using ::anthocnet::core::RouteAction;
using ::anthocnet::core::RouteDecision;
using ::anthocnet::core::NodeAddress;
using ::anthocnet::core::kInvalidAddress;

NS_OBJECT_ENSURE_REGISTERED(RoutingProtocol);

const uint16_t RoutingProtocol::ANT_PORT = 6900;

RoutingProtocol::RoutingProtocol()
    : m_started(false),
      m_queue(64, Seconds(30)),
      m_helloInterval(Seconds(1.0)),
      m_proactiveInterval(Seconds(10.0)),
      m_alpha(0.7),
      m_betaAnts(2.0),
      m_betaData(20.0),
      m_gamma(0.7),
      m_enableProactive(true),
      m_enableDiffusion(true),
      m_proactiveBroadcastProb(0.1),
      m_sessionTtl(5.0),
      m_txFailureThreshold(3),
      m_enableMacFailureDetector(true),
      m_repairWaitFactor(5.0),
      m_repairTimeout(1.0),
      m_linkfailNotifyInterval(5.0),
      m_enableMacMetric(false) {}

RoutingProtocol::~RoutingProtocol() = default;

TypeId RoutingProtocol::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::anthocnet::RoutingProtocol")
            .SetParent<Ipv4RoutingProtocol>()
            .SetGroupName("AntHocNet")
            .AddConstructor<RoutingProtocol>()
            .AddAttribute("HelloInterval", "Hello-ant beacon interval.",
                          TimeValue(Seconds(1.0)),
                          MakeTimeAccessor(&RoutingProtocol::m_helloInterval),
                          MakeTimeChecker())
            .AddAttribute("ProactiveInterval", "Proactive forward-ant interval.",
                          TimeValue(Seconds(10.0)),
                          MakeTimeAccessor(&RoutingProtocol::m_proactiveInterval),
                          MakeTimeChecker())
            .AddAttribute("Alpha", "Pheromone evaporation weight (ALFA).",
                          DoubleValue(0.7),
                          MakeDoubleAccessor(&RoutingProtocol::m_alpha),
                          MakeDoubleChecker<double>())
            .AddAttribute("BetaAnts", "Eq.1 exponent for ant next-hop choice (BETA1).",
                          DoubleValue(2.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_betaAnts),
                          MakeDoubleChecker<double>())
            .AddAttribute("BetaData", "Eq.1 exponent for greedy data routing (BETA2).",
                          DoubleValue(20.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_betaData),
                          MakeDoubleChecker<double>())
            .AddAttribute("Gamma", "Reinforcement weight (GAMA).",
                          DoubleValue(0.7),
                          MakeDoubleAccessor(&RoutingProtocol::m_gamma),
                          MakeDoubleChecker<double>())
            .AddAttribute("EnableProactive",
                          "Master switch for proactive ants + diffusion.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableProactive),
                          MakeBooleanChecker())
            .AddAttribute("EnableDiffusion",
                          "Hello pheromone adverts + virtual table.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableDiffusion),
                          MakeBooleanChecker())
            .AddAttribute("ProactiveBroadcastProb",
                          "Per-hop explore-broadcast probability for proactive ants.",
                          DoubleValue(0.1),
                          MakeDoubleAccessor(&RoutingProtocol::m_proactiveBroadcastProb),
                          MakeDoubleChecker<double>())
            .AddAttribute("SessionTtl",
                          "Seconds a data session stays active for proactive probing.",
                          DoubleValue(5.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_sessionTtl),
                          MakeDoubleChecker<double>())
            .AddAttribute("TxFailureThreshold",
                          "Consecutive MAC transmit-failures to the same next hop "
                          "before detector D treats the link as broken (issue #19 "
                          "debounce).",
                          UintegerValue(3),
                          MakeUintegerAccessor(&RoutingProtocol::m_txFailureThreshold),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("EnableMacFailureDetector",
                          "Enable the WifiMac transmit-failure detector (ADR-0008 "
                          "detector D). The hello-timeout detector (A) always runs.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableMacFailureDetector),
                          MakeBooleanChecker())
            .AddAttribute("RepairWaitFactor",
                          "Local-repair wait as a multiple of the lost path's "
                          "estimated end-to-end delay ([1] section 3.5, D6).",
                          DoubleValue(5.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_repairWaitFactor),
                          MakeDoubleChecker<double>())
            .AddAttribute("RepairTimeout",
                          "Flat local-repair wait (s) when the lost path has no "
                          "usable delay estimate.",
                          DoubleValue(1.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_repairTimeout),
                          MakeDoubleChecker<double>())
            .AddAttribute("LinkfailNotifyInterval",
                          "Minimum spacing (s) between LinkFail notifications "
                          "originated about the same destination (issue #20); "
                          "0 disables the cooldown.",
                          DoubleValue(5.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_linkfailNotifyInterval),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("EnableMacMetric",
                          "Congestion-aware per-hop cost (item 10/A2): forward ants "
                          "record (MAC-queue+1)*hop-time instead of wall-clock "
                          "transit, so paths shift off loaded nodes.",
                          BooleanValue(false),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableMacMetric),
                          MakeBooleanChecker())
            .AddTraceSource("Tx",
                            "An ant control packet was put on the medium by this "
                            "node (type, direction, broadcast).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_txAntTrace),
                            "ns3::anthocnet::RoutingProtocol::AntTxCallback")
            .AddTraceSource("Rx",
                            "A non-duplicate ant control packet was received and "
                            "processed (type, direction).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_rxAntTrace),
                            "ns3::anthocnet::RoutingProtocol::AntRxCallback")
            .AddTraceSource("RouteChanged",
                            "A neighbour/route entry was added or removed "
                            "(dest, neighbour, added).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_routeChangedTrace),
                            "ns3::anthocnet::RoutingProtocol::RouteChangedCallback");
    return tid;
}

// --- observability: forward core events to ns-3 trace sources (item 15) ------

void RoutingProtocol::onAntSent(::anthocnet::core::AntType type,
                                ::anthocnet::core::AntDirection dir, bool broadcast) {
    m_txAntTrace(static_cast<uint8_t>(type), static_cast<uint8_t>(dir), broadcast);
}

void RoutingProtocol::onAntReceived(::anthocnet::core::AntType type,
                                    ::anthocnet::core::AntDirection dir) {
    m_rxAntTrace(static_cast<uint8_t>(type), static_cast<uint8_t>(dir));
}

void RoutingProtocol::onRouteChanged(::anthocnet::core::NodeAddress dest,
                                     ::anthocnet::core::NodeAddress nb, bool added) {
    m_routeChangedTrace(static_cast<uint32_t>(dest), static_cast<uint32_t>(nb), added);
}

// --- item 10/A2: MAC congestion signals (core::ILinkState) ------------------

int RoutingProtocol::macQueueLength() const {
    // Packets currently backlogged at the wifi MAC across all access categories
    // — the queue a newly-forwarded packet would wait behind. Summed over the
    // per-AC txop queues (unified since ns-3.36, the CI-matrix floor). Returns 0
    // on non-wifi devices, so the metric degrades to the unloaded hop time.
    if (!m_wifiMac) return 0;
    uint32_t total = 0;
    // AC_BE_NQOS is essential: a non-QoS mac (AdhocWifiMac, the MANET default)
    // keeps its single DCF queue under AC_BE_NQOS, not AC_BE — without it
    // GetTxopQueue returns nullptr and the backlog always reads 0, so the whole
    // A2 signal was silently absent (issue #73).
    for (AcIndex ac : {AC_BE_NQOS, AC_BE, AC_BK, AC_VI, AC_VO}) {
        Ptr<WifiMacQueue> q = m_wifiMac->GetTxopQueue(ac);
        if (q) total += q->GetNPackets();
    }
    return static_cast<int>(total);
}

::anthocnet::core::Time RoutingProtocol::macServiceTime() const {
    // Nominal per-packet MAC service time. The congestion signal in this pass is
    // the *measured queue occupancy* (macQueueLength); the service-time unit is
    // the unloaded reference hop time, so per-hop cost = (Q+1)*hopTime. Upgrading
    // this to a measured tx-time EWMA is a follow-up (see #55 / item 10/A2).
    return m_config.hopTimeSec;
}

// --- lifecycle --------------------------------------------------------------

void RoutingProtocol::SetIpv4(Ptr<Ipv4> ipv4) {
    NS_ASSERT(ipv4);
    m_ipv4 = ipv4;
}

void RoutingProtocol::DoInitialize() {
    m_config.alpha = m_alpha;
    m_config.betaAnts = m_betaAnts;
    m_config.betaData = m_betaData;
    m_config.gamma = m_gamma;
    m_config.enableProactive = m_enableProactive;
    m_config.enableDiffusion = m_enableDiffusion;
    m_config.proactiveBroadcastProb = m_proactiveBroadcastProb;
    m_config.sessionTtl = m_sessionTtl;
    m_config.helloInterval = m_helloInterval.GetSeconds();
    m_config.proactiveInterval = m_proactiveInterval.GetSeconds();
    m_config.txFailureThreshold = static_cast<int>(m_txFailureThreshold);
    m_config.repairWaitFactor = m_repairWaitFactor;
    m_config.repairTimeout = m_repairTimeout;
    m_config.linkfailNotifyInterval = m_linkfailNotifyInterval;
    m_config.enableMacMetric = m_enableMacMetric;
    Ipv4RoutingProtocol::DoInitialize();
}

void RoutingProtocol::DoDispose() {
    m_ipv4 = nullptr;
    for (auto& kv : m_socketAddresses) {
        kv.first->Close();
    }
    m_socketAddresses.clear();
    for (auto& kv : m_socketSubnetBroadcast) {
        kv.first->Close();
    }
    m_socketSubnetBroadcast.clear();
    m_logic.reset();
    Ipv4RoutingProtocol::DoDispose();
}

void RoutingProtocol::Start() {
    if (m_started) return;
    m_started = true;

    m_helloTimer.SetFunction(&RoutingProtocol::HelloTimerExpire, this);
    m_proactiveTimer.SetFunction(&RoutingProtocol::ProactiveTimerExpire, this);
    m_helloTimer.Schedule(m_helloInterval);
    m_proactiveTimer.Schedule(m_proactiveInterval);
}

// --- interface notifications ------------------------------------------------

void RoutingProtocol::NotifyInterfaceUp(uint32_t interface) {
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    if (l3->GetNAddresses(interface) == 0) return;
    Ipv4InterfaceAddress iface = m_ipv4->GetAddress(interface, 0);
    if (iface.GetLocal() == Ipv4Address("127.0.0.1")) return;

    // Create the core logic on the first real interface, keyed by its address.
    if (!m_logic) {
        m_config.alpha = m_alpha;
        m_config.betaAnts = m_betaAnts;
        m_config.betaData = m_betaData;
        m_config.gamma = m_gamma;
        m_config.enableProactive = m_enableProactive;
        m_config.enableDiffusion = m_enableDiffusion;
        m_config.proactiveBroadcastProb = m_proactiveBroadcastProb;
        m_config.sessionTtl = m_sessionTtl;
        m_config.helloInterval = m_helloInterval.GetSeconds();
        m_config.proactiveInterval = m_proactiveInterval.GetSeconds();
        m_config.txFailureThreshold = static_cast<int>(m_txFailureThreshold);
        m_config.repairWaitFactor = m_repairWaitFactor;
        m_config.repairTimeout = m_repairTimeout;
        m_config.linkfailNotifyInterval = m_linkfailNotifyInterval;
        m_config.enableMacMetric = m_enableMacMetric;
        m_logic.reset(new ::anthocnet::core::AntRouterLogic(
            ToCore(iface.GetLocal()), m_config, m_clock, m_rng,
            /*metric*/ nullptr, /*linkState*/ this));
        m_logic->setObserver(this);  // fan core events to the trace sources
    }

    // One UDP socket per interface for ant control traffic.
    Ptr<Socket> socket = Socket::CreateSocket(GetObject<Node>(),
                                              UdpSocketFactory::GetTypeId());
    NS_ASSERT(socket);
    socket->SetRecvCallback(MakeCallback(&RoutingProtocol::RecvAnt, this));
    socket->BindToNetDevice(l3->GetNetDevice(interface));
    socket->Bind(InetSocketAddress(iface.GetLocal(), ANT_PORT));
    socket->SetAllowBroadcast(true);
    socket->SetIpRecvTtl(true);
    m_socketAddresses[socket] = iface;

    // Second socket bound to the subnet-broadcast address so this interface
    // actually receives the broadcast hello / forward ants.
    Ptr<Socket> bcast = Socket::CreateSocket(GetObject<Node>(),
                                             UdpSocketFactory::GetTypeId());
    NS_ASSERT(bcast);
    bcast->SetRecvCallback(MakeCallback(&RoutingProtocol::RecvAnt, this));
    bcast->BindToNetDevice(l3->GetNetDevice(interface));
    bcast->Bind(InetSocketAddress(iface.GetBroadcast(), ANT_PORT));
    bcast->SetAllowBroadcast(true);
    bcast->SetIpRecvTtl(true);
    m_socketSubnetBroadcast[bcast] = iface;

    // ADR-0008 detector D: subscribe to the WifiMac transmit-failure trace so a
    // failed unicast to a next hop is reported immediately (NS-2 parity). Only
    // wifi devices expose this; for others (e.g. SimpleNetDevice) detector A
    // (the hello-timeout maintenance tick) remains the sole, mandatory detector.
    // TraceConnect returns false if the source is absent on this ns-3 version,
    // which we tolerate — detection then falls back to detector A.
    Ptr<NetDevice> dev = l3->GetNetDevice(interface);
    Ptr<WifiNetDevice> wifi = dev ? dev->GetObject<WifiNetDevice>() : nullptr;
    if (wifi) {
        Ptr<WifiMac> wmac = wifi->GetMac();
        if (wmac) {
            wmac->TraceConnectWithoutContext(
                "DroppedMpdu", MakeCallback(&RoutingProtocol::NotifyTxError, this));
            // Keep the first wifi MAC for the item-10/A2 queue-occupancy signal.
            if (!m_wifiMac) m_wifiMac = wmac;
        }
    }

    Start();
}

void RoutingProtocol::NotifyInterfaceDown(uint32_t interface) {
    Ipv4InterfaceAddress iface = m_ipv4->GetAddress(interface, 0);
    Ptr<Socket> socket = FindSocketWithInterfaceAddress(iface);
    if (socket) {
        socket->Close();
        m_socketAddresses.erase(socket);
    }
    for (auto it = m_socketSubnetBroadcast.begin(); it != m_socketSubnetBroadcast.end(); ++it) {
        if (it->second == iface) {
            it->first->Close();
            m_socketSubnetBroadcast.erase(it);
            break;
        }
    }
}

void RoutingProtocol::NotifyAddAddress(uint32_t, Ipv4InterfaceAddress) {}
void RoutingProtocol::NotifyRemoveAddress(uint32_t, Ipv4InterfaceAddress) {}

// --- routing ----------------------------------------------------------------

Ptr<Ipv4Route> RoutingProtocol::LoopbackRoute(const Ipv4Header& header, Ptr<NetDevice> oif) const {
    Ptr<Ipv4Route> route = Create<Ipv4Route>();
    route->SetDestination(header.GetDestination());
    route->SetGateway(Ipv4Address("127.0.0.1"));
    // Pick a source address on an available interface.
    for (const auto& kv : m_socketAddresses) {
        Ipv4InterfaceAddress addr = kv.second;
        if (!oif || m_ipv4->GetInterfaceForDevice(oif) ==
                        (int) m_ipv4->GetInterfaceForAddress(addr.GetLocal())) {
            route->SetSource(addr.GetLocal());
            break;
        }
    }
    if (route->GetSource() == Ipv4Address()) {
        if (!m_socketAddresses.empty())
            route->SetSource(m_socketAddresses.begin()->second.GetLocal());
    }
    route->SetOutputDevice(m_ipv4->GetNetDevice(0));  // loopback device
    return route;
}

Ptr<Ipv4Route> RoutingProtocol::RouteOutput(Ptr<Packet> p, const Ipv4Header& header,
                                            Ptr<NetDevice> oif,
                                            Socket::SocketErrno& sockerr) {
    sockerr = Socket::ERROR_NOTERROR;
    if (!m_logic || m_socketAddresses.empty()) {
        sockerr = Socket::ERROR_NOROUTETOHOST;
        return nullptr;
    }

    Ipv4Address dst = header.GetDestination();
    // Locally-originated data: mark this destination as an active session so
    // proactive ants monitor its path (item 04).
    m_logic->noteDataSession(ToCore(dst));
    NodeAddress next = m_logic->nextHopForData(ToCore(dst));
    if (next != kInvalidAddress) {
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(ToIpv4(next));
        Ipv4InterfaceAddress ifaceAddr = m_socketAddresses.begin()->second;
        route->SetSource(m_ipv4->SourceAddressSelection(
            m_ipv4->GetInterfaceForAddress(ifaceAddr.GetLocal()), dst));
        route->SetOutputDevice(m_ipv4->GetNetDevice(
            m_ipv4->GetInterfaceForAddress(ifaceAddr.GetLocal())));
        return route;
    }

    // No route yet: bounce through loopback so RouteInput can queue it and we
    // launch a reactive forward ant.
    return LoopbackRoute(header, oif);
}

bool RoutingProtocol::RouteInput(Ptr<const Packet> p, const Ipv4Header& header,
                                 Ptr<const NetDevice> idev,
                                 AHN_RI_CB(UnicastForwardCallback) ucb,
                                 AHN_RI_CB(MulticastForwardCallback) mcb,
                                 AHN_RI_CB(LocalDeliverCallback) lcb,
                                 AHN_RI_CB(ErrorCallback) ecb) {
    if (!m_logic || m_socketAddresses.empty()) return false;

    // Ipv4L3Protocol passes the same bound callbacks on every call; cache them
    // so NotifyTxError can re-inject a MAC-dropped data packet (issue #46).
    m_cachedUcb = ucb;
    m_cachedEcb = ecb;

    Ipv4Address dst = header.GetDestination();

    // Locally destined?
    int32_t iif = m_ipv4->GetInterfaceForDevice(idev);
    if (m_ipv4->IsDestinationAddress(dst, iif)) {
        if (!lcb.IsNull()) lcb(p, header, iif);
        return true;
    }

    // Deferred (came back via loopback): queue and request a route.
    if (idev == m_ipv4->GetNetDevice(0)) {
        DeferredRouteOutput(p, header, ucb, ecb);
        return true;
    }

    // In-transit forwarding.
    // TODO(A1): pass the L2 previous hop to exclude it (loop suppression). NS-3
    // RouteInput does not expose it cleanly (the IP source is the origin, not the
    // prev hop), so exclusion is NS-2-only for now; NS-3 still relies on TTL.
    NodeAddress next = m_logic->nextHopForData(ToCore(dst));
    if (next != kInvalidAddress) {
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(ToIpv4(next));
        route->SetSource(header.GetSource());
        route->SetOutputDevice(m_ipv4->GetNetDevice(
            m_ipv4->GetInterfaceForAddress(m_socketAddresses.begin()->second.GetLocal())));
        ucb(route, p, header);
        return true;
    }

    // No route: queue and emit a reactive forward ant.
    DeferredRouteOutput(p, header, ucb, ecb);
    return true;
}

void RoutingProtocol::DeferredRouteOutput(Ptr<const Packet> p, const Ipv4Header& header,
                                          UnicastForwardCallback ucb, ErrorCallback ecb) {
    QueueEntry entry;
    entry.packet = p;
    entry.header = header;
    entry.ucb = ucb;
    entry.ecb = ecb;
    m_queue.Enqueue(entry);

    // Ask the core what to do; it returns Queue + a reactive forward ant.
    std::vector<RouteDecision> decisions = m_logic->onDataPacket(ToCore(header.GetDestination()));
    ExecuteDecisions(decisions, kInvalidAddress);
}

// --- ant I/O ----------------------------------------------------------------

void RoutingProtocol::SendAnt(const AntMessage& msg, Ipv4Address dest) {
    if (m_socketAddresses.empty()) return;
    Ptr<Packet> packet = Create<Packet>();
    AntHeader header(msg);
    packet->AddHeader(header);

    for (auto& kv : m_socketAddresses) {
        Ptr<Socket> socket = kv.first;
        Ipv4Address iface = kv.second.GetLocal();
        Ipv4Address destination =
            (dest == Ipv4Address("255.255.255.255"))
                ? kv.second.GetBroadcast()
                : dest;
        socket->SendTo(packet->Copy(), 0, InetSocketAddress(destination, ANT_PORT));
        // For unicast we only need to send out once.
        if (dest != Ipv4Address("255.255.255.255")) break;
        (void) iface;
    }
}

void RoutingProtocol::ExecuteDecisions(const std::vector<RouteDecision>& decisions,
                                       NodeAddress /*flushDest*/) {
    for (const RouteDecision& d : decisions) {
        switch (d.action) {
            case RouteAction::Unicast:
                SendAnt(d.message, ToIpv4(d.nextHop));
                break;
            case RouteAction::Broadcast:
                SendAnt(d.message, Ipv4Address("255.255.255.255"));
                break;
            case RouteAction::Deliver:
                // handled by caller (FlushQueue), nothing to send
                break;
            case RouteAction::DiscardPending:
                // Local repair timed out (D6): release the buffered packets.
                DiscardQueue(d.nextHop);
                break;
            case RouteAction::Queue:
            case RouteAction::Drop:
            case RouteAction::None:
                break;
        }
    }
}

void RoutingProtocol::RecvAnt(Ptr<Socket> socket) {
    Address sourceAddress;
    Ptr<Packet> packet = socket->RecvFrom(sourceAddress);
    InetSocketAddress inetSource = InetSocketAddress::ConvertFrom(sourceAddress);
    Ipv4Address sender = inetSource.GetIpv4();

    AntHeader header;
    packet->RemoveHeader(header);
    AntMessage incoming = header.Message();

    NodeAddress prevHop = ToCore(sender);
    std::vector<RouteDecision> decisions = m_logic->onReceiveAnt(incoming, prevHop);

    // A Deliver means a route to incoming.src was just discovered.
    for (const RouteDecision& d : decisions) {
        if (d.action == RouteAction::Deliver) {
            FlushQueue(incoming.src);
        }
    }
    ExecuteDecisions(decisions, incoming.src);
}

void RoutingProtocol::FlushQueue(NodeAddress coreDest) {
    Ipv4Address dst = ToIpv4(coreDest);
    std::vector<QueueEntry> pending;
    m_queue.DequeueAll(dst, pending);

    for (QueueEntry& e : pending) {
        NodeAddress next = m_logic->nextHopForData(coreDest);
        if (next == kInvalidAddress) {
            // Route vanished again; re-queue.
            m_queue.Enqueue(e);
            continue;
        }
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(ToIpv4(next));
        route->SetSource(e.header.GetSource());
        route->SetOutputDevice(m_ipv4->GetNetDevice(
            m_ipv4->GetInterfaceForAddress(m_socketAddresses.begin()->second.GetLocal())));
        if (!e.ucb.IsNull()) e.ucb(route, e.packet, e.header);
    }
}

void RoutingProtocol::DiscardQueue(NodeAddress coreDest) {
    std::vector<QueueEntry> pending;
    m_queue.DequeueAll(ToIpv4(coreDest), pending);
    for (QueueEntry& e : pending) {
        if (!e.ecb.IsNull()) e.ecb(e.packet, e.header, Socket::ERROR_NOROUTETOHOST);
    }
}

// --- timers -----------------------------------------------------------------

void RoutingProtocol::HelloTimerExpire() {
    if (m_logic) {
        // Liveness/maintenance tick first (ADR-0008 detector A) — the only way
        // NS-3 detects neighbour loss — then beacon a hello. The tick returns
        // LinkFail broadcasts and repair-timeout DiscardPending actions (D6).
        ExecuteDecisions(m_logic->onMaintenanceTick(), kInvalidAddress);
        AntMessage hello = m_logic->createHelloAnt();
        SendAnt(hello, Ipv4Address("255.255.255.255"));
    }
    m_helloTimer.Schedule(m_helloInterval);
}

void RoutingProtocol::ProactiveTimerExpire() {
    if (m_logic) {
        // One proactive ant per active data session (empty when proactive is
        // gated off or no session is active), each routed by combined pheromone.
        for (AntMessage& prfa : m_logic->createProactiveAnts()) {
            NodeAddress next = m_logic->selectNextHop(prfa.dst, /*proactive=*/true);
            if (next == kInvalidAddress) {
                SendAnt(prfa, Ipv4Address("255.255.255.255"));
            } else {
                SendAnt(prfa, ToIpv4(next));
            }
        }
    }
    m_proactiveTimer.Schedule(m_proactiveInterval);
}

// --- MAC transmit-failure hook (ADR-0008 detector D) ------------------------

void RoutingProtocol::NotifyTxError(WifiMacDropReason reason, Ptr<const AHN_WIFI_MPDU> mpdu) {
    // Detector D is a latency optimisation over the mandatory hello-timeout
    // detector A (ADR-0008); it can be gated off for ablation (issue #46).
    if (!m_enableMacFailureDetector) return;
    if (!m_logic || m_socketAddresses.empty() || !mpdu) return;
    // Only a retry-limit drop is a real broken link; other drop reasons
    // (queue full, lifetime expiry) are congestion, not topology.
    if (reason != WIFI_MAC_DROP_REACHED_RETRY_LIMIT) return;

    const Mac48Address dstMac = mpdu->GetHeader().GetAddr1();
    if (dstMac.IsBroadcast() || dstMac.IsGroup()) return;  // no single next hop

    NodeAddress next;
    if (!MapMacToCore(dstMac, next)) return;  // unknown peer — nothing to prune

    // Peek the carried L3 packet: only a failed *data* packet triggers a repair
    // ant (ant control traffic is UDP to ANT_PORT — mirror NS-2, which repairs
    // only non-ant packets). dataDest stays kInvalidAddress if we can't parse it,
    // so we still prune the dead neighbour even when the payload is opaque.
    NodeAddress dataDest = kInvalidAddress;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    Ipv4Header ipHeader;   // kept for re-injection (#46)
    bool haveData = false;
    LlcSnapHeader llc;
    if (pkt->GetSize() >= llc.GetSerializedSize()) {
        pkt->RemoveHeader(llc);
        if (llc.GetType() == 0x0800) {  // IPv4 EtherType
            Ipv4Header ip;
            if (pkt->GetSize() >= ip.GetSerializedSize()) {
                pkt->RemoveHeader(ip);
                bool isAnt = false;
                if (ip.GetProtocol() == 17) {  // UDP
                    UdpHeader udp;
                    if (pkt->GetSize() >= udp.GetSerializedSize()) {
                        pkt->PeekHeader(udp);
                        isAnt = (udp.GetDestinationPort() == ANT_PORT);
                    }
                }
                if (!isAnt) {
                    dataDest = ToCore(ip.GetDestination());
                    ipHeader = ip;
                    haveData = true;
                }
            }
        }
    }

    // Converge on the shared core path: prune + LinkFail notifications + (for
    // data) a bounded, counted repair ant. ExecuteDecisions broadcasts them.
    ExecuteDecisions(m_logic->reportTxFailure(next, dataDest), kInvalidAddress);

    // NS-2 parity (issue #46): re-inject the failed data packet through the
    // pending queue so it is retransmitted once a route exists, instead of
    // being lost with only the *route* recovering. The MAC trace fires without
    // the routing callbacks, so resume it with the ones cached from RouteInput;
    // queue entries hold the packet without its IP header, matching RouteInput's
    // convention. The immediate flush retries right away when an alternate
    // route survived the prune (FlushQueue re-queues if none did). The retry
    // costs one extra TTL decrement, like any real retransmission path.
    if (haveData && ipHeader.GetTtl() > 1 && !m_cachedUcb.IsNull()) {
        QueueEntry entry;
        entry.packet = pkt;
        entry.header = ipHeader;
        entry.ucb = m_cachedUcb;
        entry.ecb = m_cachedEcb;
        m_queue.Enqueue(entry);
        FlushQueue(dataDest);
    }
}

bool RoutingProtocol::MapMacToCore(const Mac48Address& mac, NodeAddress& out) const {
    if (!m_ipv4 || !m_logic) return false;
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    if (!l3) return false;

    // Resolve the failed next-hop MAC to a core address by forward-looking each
    // known neighbour's IP in the per-interface ARP cache and matching its MAC.
    // We use the public Ipv4Interface::GetArpCache() + the stable 1:1 forward
    // Lookup(Ipv4Address) — ArpL3Protocol::FindCache is private and
    // ArpCache::LookupInverse's return type drifts across ns-3 versions.
    const auto& neighbors = m_logic->table().neighbors();
    for (uint32_t i = 0; i < l3->GetNInterfaces(); ++i) {
        Ptr<ArpCache> cache = l3->GetInterface(i)->GetArpCache();
        if (!cache) continue;
        for (NodeAddress nb : neighbors) {
            ArpCache::Entry* entry = cache->Lookup(ToIpv4(nb));
            if (!entry) continue;
            // An entry still resolving (WAIT_REPLY) carries no MAC yet; guard
            // ConvertFrom, which asserts on a non-48-bit address.
            const Address resolved = entry->GetMacAddress();
            if (Mac48Address::IsMatchingType(resolved) &&
                Mac48Address::ConvertFrom(resolved) == mac) {
                out = nb;
                return true;
            }
        }
    }
    return false;
}

// --- helpers ----------------------------------------------------------------

bool RoutingProtocol::IsMyOwnAddress(Ipv4Address src) const {
    for (const auto& kv : m_socketAddresses) {
        if (kv.second.GetLocal() == src) return true;
    }
    return false;
}

Ptr<Socket> RoutingProtocol::FindSocketWithInterfaceAddress(Ipv4InterfaceAddress addr) const {
    for (const auto& kv : m_socketAddresses) {
        if (kv.second == addr) return kv.first;
    }
    return nullptr;
}

int64_t RoutingProtocol::AssignStreams(int64_t stream) {
    m_rng.Stream()->SetStream(stream);
    return 1;
}

void RoutingProtocol::PrintRoutingTable(Ptr<OutputStreamWrapper> stream, Time::Unit) const {
    std::ostream* os = stream->GetStream();
    *os << "AntHocNet routing table for node "
        << (m_ipv4 ? m_ipv4->GetObject<Node>()->GetId() : 0) << "\n";
    if (m_logic) {
        const auto& table = m_logic->table();
        for (NodeAddress dest : table.regularDestinations()) {
            *os << "  dest " << ToIpv4(dest) << " neighbours:";
            for (NodeAddress nb : table.neighbors()) {
                double ph = table.getPheromoneRegular(dest, nb);
                if (ph > 0) *os << " " << ToIpv4(nb) << "(" << ph << ")";
            }
            *os << "\n";
        }
    }
}

} // namespace anthocnet
} // namespace ns3
