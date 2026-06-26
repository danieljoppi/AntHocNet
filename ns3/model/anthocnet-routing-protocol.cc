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
      m_sessionTtl(5.0) {}

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
                          MakeDoubleChecker<double>());
    return tid;
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
        m_logic.reset(new ::anthocnet::core::AntRouterLogic(
            ToCore(iface.GetLocal()), m_config, m_clock, m_rng));
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
                                 const UnicastForwardCallback& ucb,
                                 const MulticastForwardCallback& mcb,
                                 const LocalDeliverCallback& lcb,
                                 const ErrorCallback& ecb) {
    if (!m_logic || m_socketAddresses.empty()) return false;

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

// --- timers -----------------------------------------------------------------

void RoutingProtocol::HelloTimerExpire() {
    if (m_logic) {
        // Liveness/maintenance tick first (ADR-0008 detector A) — the only way
        // NS-3 detects neighbour loss — then beacon a hello.
        for (RouteDecision& d : m_logic->onMaintenanceTick()) {
            if (d.action == RouteAction::Broadcast) {
                SendAnt(d.message, Ipv4Address("255.255.255.255"));
            }
        }
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
