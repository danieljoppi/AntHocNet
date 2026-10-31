// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "adaptive-routing-base.h"

#include "ns3/arp-cache.h"
#include "ns3/arp-l3-protocol.h"
#include "ns3/inet-socket-address.h"
#include "ns3/ipv4-interface.h"
#include "ns3/ipv4-route.h"
#include "ns3/llc-snap-header.h"
#include "ns3/log.h"
#include "ns3/output-stream-wrapper.h"
#include "ns3/simulator.h"
#include "ns3/udp-header.h"
#include "ns3/udp-socket-factory.h"
#include "ns3/uinteger.h"
#include "ns3/wifi-net-device.h"

#include <algorithm>

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("AdaptiveRoutingBase");

namespace adaptive {

// --- tags --------------------------------------------------------------------

NS_OBJECT_ENSURE_REGISTERED(PrevHopTag);

TypeId PrevHopTag::GetTypeId() {
    static TypeId tid = TypeId("ns3::adaptive::PrevHopTag")
                            .SetParent<Tag>()
                            .SetGroupName("Adaptive")
                            .AddConstructor<PrevHopTag>();
    return tid;
}

TypeId PrevHopTag::GetInstanceTypeId() const { return GetTypeId(); }

uint32_t PrevHopTag::GetSerializedSize() const { return 12; }

void PrevHopTag::Serialize(TagBuffer i) const {
    i.WriteU32(m_addr.Get());
    i.WriteU32(m_upstream.Get());
    i.WriteU32(m_next.Get());
}

void PrevHopTag::Deserialize(TagBuffer i) {
    m_addr = Ipv4Address(i.ReadU32());
    m_upstream = Ipv4Address(i.ReadU32());
    m_next = Ipv4Address(i.ReadU32());
}

void PrevHopTag::Print(std::ostream& os) const {
    os << "prevHop=" << m_addr << " upstream=" << m_upstream << " next=" << m_next;
}

NS_OBJECT_ENSURE_REGISTERED(BacktrackTag);

TypeId BacktrackTag::GetTypeId() {
    static TypeId tid = TypeId("ns3::adaptive::BacktrackTag")
                            .SetParent<Tag>()
                            .SetGroupName("Adaptive")
                            .AddConstructor<BacktrackTag>();
    return tid;
}

TypeId BacktrackTag::GetInstanceTypeId() const { return GetTypeId(); }

uint32_t BacktrackTag::GetSerializedSize() const { return 0; }

void BacktrackTag::Serialize(TagBuffer) const {}

void BacktrackTag::Deserialize(TagBuffer) {}

void BacktrackTag::Print(std::ostream& os) const { os << "backtrack"; }

// --- RoutingBase -------------------------------------------------------------

NS_OBJECT_ENSURE_REGISTERED(RoutingBase);

TypeId RoutingBase::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::adaptive::RoutingBase")
            .SetParent<Ipv4RoutingProtocol>()
            .SetGroupName("Adaptive")
            .AddAttribute("MaxQueueLen",
                          "Packets a node holds while it has no next hop "
                          "(ns-3 AODV's default, so the arms buffer alike).",
                          UintegerValue(64), MakeUintegerAccessor(&RoutingBase::m_maxQueueLen),
                          MakeUintegerChecker<uint32_t>())
            .AddAttribute("MaxQueueTime",
                          "How long a held packet waits for a route before it is "
                          "dropped (ns-3 AODV's default).",
                          TimeValue(Seconds(30)), MakeTimeAccessor(&RoutingBase::m_maxQueueTime),
                          MakeTimeChecker())
            .AddTraceSource("MacReinject",
                            "A packet recovered from a MAC retry-limit drop and routed "
                            "again (IP header, packet without it).",
                            MakeTraceSourceAccessor(&RoutingBase::m_macReinjectTrace),
                            "ns3::adaptive::RoutingBase::MacReinjectCallback")
            .AddTraceSource("ArpReinject",
                            "A data packet recovered from an ARP drop (the next hop never "
                            "answered) and routed again (IP header, packet without it).",
                            MakeTraceSourceAccessor(&RoutingBase::m_arpReinjectTrace),
                            "ns3::adaptive::RoutingBase::MacReinjectCallback");
    return tid;
}

RoutingBase::RoutingBase()
    : m_maxQueueLen(64),
      m_maxQueueTime(Seconds(30)),
      m_purgeTimer(Timer::CANCEL_ON_DESTROY),
      m_rng(CreateObject<UniformRandomVariable>()),
      m_macReinjected(0),
      m_arpReinjected(0),
      m_arpHooked(false) {}

RoutingBase::~RoutingBase() = default;

int64_t RoutingBase::AssignStreams(int64_t stream) {
    m_rng->SetStream(stream);
    return 1;
}

void RoutingBase::DoInitialize() {
    m_purgeTimer.SetFunction(&RoutingBase::PurgeQueue, this);
    m_purgeTimer.Schedule(MilliSeconds(500));
    Ipv4RoutingProtocol::DoInitialize();
}

void RoutingBase::DoDispose() {
    for (auto& kv : m_sockets) {
        kv.first->Close();
    }
    for (auto& kv : m_bcastSockets) {
        kv.first->Close();
    }
    m_sockets.clear();
    m_bcastSockets.clear();
    m_queue.clear();
    m_purgeTimer.Cancel();
    m_ipv4 = nullptr;
    m_lo = nullptr;
    Ipv4RoutingProtocol::DoDispose();
}

void RoutingBase::SetIpv4(Ptr<Ipv4> ipv4) {
    NS_ASSERT(ipv4);
    NS_ASSERT(!m_ipv4);
    m_ipv4 = ipv4;
    // Interface 0 is the loopback device, added before any routing protocol.
    m_lo = m_ipv4->GetNetDevice(0);
}

Ipv4Address RoutingBase::MainAddress() const {
    if (m_sockets.empty()) {
        return Ipv4Address();
    }
    return m_sockets.begin()->second.GetLocal();
}

bool RoutingBase::IsMyAddress(Ipv4Address a) const {
    for (const auto& kv : m_sockets) {
        if (kv.second.GetLocal() == a) {
            return true;
        }
    }
    return false;
}

int32_t RoutingBase::InterfaceTowards(Ipv4Address next) const {
    for (const auto& kv : m_sockets) {
        const Ipv4InterfaceAddress& ifa = kv.second;
        if (next.CombineMask(ifa.GetMask()) == ifa.GetLocal().CombineMask(ifa.GetMask())) {
            return m_ipv4->GetInterfaceForAddress(ifa.GetLocal());
        }
    }
    if (!m_sockets.empty()) {
        return m_ipv4->GetInterfaceForAddress(m_sockets.begin()->second.GetLocal());
    }
    return -1;
}

Ptr<Ipv4Route> RoutingBase::DirectRoute(Ipv4Address dst, Ipv4Address next, Ipv4Address src) const {
    const int32_t ifIdx = InterfaceTowards(next);
    if (ifIdx < 0) {
        return nullptr;
    }
    Ptr<Ipv4Route> route = Create<Ipv4Route>();
    route->SetDestination(dst);
    route->SetGateway(next);
    route->SetSource(src == Ipv4Address() || src.IsAny() ? m_ipv4->GetAddress(ifIdx, 0).GetLocal()
                                                         : src);
    route->SetOutputDevice(m_ipv4->GetNetDevice(ifIdx));
    return route;
}

Ptr<Ipv4Route> RoutingBase::LoopbackRoute(const Ipv4Header& header, Ptr<NetDevice> oif) const {
    Ptr<Ipv4Route> route = Create<Ipv4Route>();
    route->SetDestination(header.GetDestination());
    route->SetGateway(Ipv4Address("127.0.0.1"));
    Ipv4Address src;
    for (const auto& kv : m_sockets) {
        if (!oif ||
            m_ipv4->GetInterfaceForDevice(oif) ==
                static_cast<int32_t>(m_ipv4->GetInterfaceForAddress(kv.second.GetLocal()))) {
            src = kv.second.GetLocal();
            break;
        }
    }
    if (src == Ipv4Address() && !m_sockets.empty()) {
        src = m_sockets.begin()->second.GetLocal();
    }
    route->SetSource(src);
    route->SetOutputDevice(m_lo);
    return route;
}

Ptr<Ipv4Route> RoutingBase::RouteOutput(Ptr<Packet> p, const Ipv4Header& header, Ptr<NetDevice> oif,
                                        Socket::SocketErrno& sockerr) {
    sockerr = Socket::ERROR_NOTERROR;
    if (m_sockets.empty()) {
        sockerr = Socket::ERROR_NOROUTETOHOST;
        return nullptr;
    }
    const Ipv4Address dst = header.GetDestination();
    // A control message to a one-hop neighbour (UnicastControl): direct route.
    if (m_directTo != Ipv4Address() && dst == m_directTo) {
        return DirectRoute(dst, dst, header.GetSource());
    }
    const Ipv4Address next = SelectNextHop(dst, MainAddress(), Ipv4Address(), p);
    if (next != Ipv4Address()) {
        Ptr<Ipv4Route> route = DirectRoute(dst, next, header.GetSource());
        if (route) {
            if (p) {
                PrevHopTag old;
                p->RemovePacketTag(old);
                p->AddPacketTag(PrevHopTag(route->GetSource(), Ipv4Address(), next));
            }
            m_routed.insert(dst);
            OnDataForwarded(p, header, next);
            return route;
        }
    }
    // No next hop yet: bounce through loopback so RouteInput can hold the
    // packet, with its callbacks, while the arm looks for a route.
    return LoopbackRoute(header, oif);
}

bool RoutingBase::RouteInput(Ptr<const Packet> p, const Ipv4Header& header,
                             Ptr<const NetDevice> idev, ADAPTIVE_RI_CB(UnicastForwardCallback) ucb,
                             ADAPTIVE_RI_CB(MulticastForwardCallback) mcb,
                             ADAPTIVE_RI_CB(LocalDeliverCallback) lcb,
                             ADAPTIVE_RI_CB(ErrorCallback) ecb) {
    if (m_sockets.empty()) {
        return false;
    }
    // Ipv4L3Protocol passes the same bound callbacks on every call; keep them
    // so a packet recovered from a MAC drop can be sent again.
    m_cachedUcb = ucb;
    m_cachedEcb = ecb;

    const Ipv4Address dst = header.GetDestination();
    const int32_t iif = m_ipv4->GetInterfaceForDevice(idev);

    bool control = false;
    if (header.GetProtocol() == 17) {
        UdpHeader udp;
        if (p->PeekHeader(udp) && udp.GetDestinationPort() == ControlPort()) {
            control = true;
        }
    }

    PrevHopTag prevTag;
    const Ipv4Address prev = p->PeekPacketTag(prevTag) ? prevTag.Get() : Ipv4Address();
    BacktrackTag bt;
    const bool backtracked = p->PeekPacketTag(bt);

    if (m_ipv4->IsDestinationAddress(dst, iif)) {
        if (!control && idev != m_lo && prev != Ipv4Address()) {
            OnDataReceived(p, header, prev, backtracked);
        }
        if (!lcb.IsNull()) {
            lcb(p, header, iif);
            return true;
        }
        return false;
    }
    if (dst.IsMulticast() || dst.IsBroadcast()) {
        return false;
    }

    // Came back through loopback: a locally originated packet with no route.
    if (idev == m_lo) {
        // The packet leaves through ucb -> IpForward, which decrements the TTL
        // for a hop no radio carried; add it back (ns-3 AODV does the same).
        Ipv4Header compensated = header;
        compensated.SetTtl(header.GetTtl() + 1);
        Enqueue(p, compensated, ucb, ecb);
        StartDiscovery(dst);
        return true;
    }

    if (control) {
        return false;  // our control is one-hop only; never forwarded
    }

    if (!OnDataReceived(p, header, prev, backtracked)) {
        return true;  // the arm disposed of it (sent it back, dropped it via ecb)
    }
    const Ipv4Address next = SelectNextHop(dst, header.GetSource(), prev, p);
    if (next != Ipv4Address()) {
        OnDataForwarded(p, header, next);
        ForwardData(p, header, next, ucb, false);
        return true;
    }
    if (OnNoRouteInTransit(p, header, prev, ucb, ecb)) {
        return true;
    }
    Enqueue(p, header, ucb, ecb);
    StartDiscovery(dst);
    return true;
}

void RoutingBase::ForwardData(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address next,
                              UnicastForwardCallback ucb, bool backtrack) {
    Ptr<Ipv4Route> route = DirectRoute(header.GetDestination(), next, header.GetSource());
    if (!route || ucb.IsNull()) {
        return;
    }
    m_routed.insert(header.GetDestination());
    Ptr<Packet> q = p->Copy();
    PrevHopTag oldPrev;
    const bool hadPrev = q->RemovePacketTag(oldPrev);
    const Ipv4Address me = m_ipv4->GetAddress(InterfaceTowards(next), 0).GetLocal();
    // Upstream is the node this packet came from; a packet that already carries
    // our own stamp (held, or recovered from the MAC) keeps the upstream it had.
    const Ipv4Address upstream =
        !hadPrev ? Ipv4Address()
                 : (IsMyAddress(oldPrev.Get()) ? oldPrev.Upstream() : oldPrev.Get());
    q->AddPacketTag(PrevHopTag(me, upstream, next));
    BacktrackTag oldBt;
    q->RemovePacketTag(oldBt);
    if (backtrack) {
        q->AddPacketTag(BacktrackTag());
    }
    ucb(route, q, header);
}

// --- the hold queue ------------------------------------------------------------

void RoutingBase::Enqueue(Ptr<const Packet> p, const Ipv4Header& header, UnicastForwardCallback ucb,
                          ErrorCallback ecb, bool recovered) {
    if (m_queue.size() >= m_maxQueueLen) {
        QueueEntry old = m_queue.front();
        m_queue.pop_front();
        if (!old.ecb.IsNull()) {
            old.ecb(old.packet, old.header, Socket::ERROR_NOROUTETOHOST);
        }
    }
    QueueEntry e;
    e.packet = p;
    e.header = header;
    e.ucb = ucb;
    e.ecb = ecb;
    e.expire = Simulator::Now() + m_maxQueueTime;
    e.queued = Simulator::Now();
    e.reason = recovered ? HOLD_REPAIR
                         : (m_routed.count(header.GetDestination()) ? HOLD_RECONV : HOLD_SETUP);
    m_queue.push_back(e);
}

void RoutingBase::PurgeQueue() {
    const Time now = Simulator::Now();
    std::deque<QueueEntry> keep;
    std::deque<QueueEntry> expired;
    for (auto& e : m_queue) {
        (e.expire <= now ? expired : keep).push_back(e);
    }
    m_queue.swap(keep);
    for (auto& e : expired) {
        if (!e.ecb.IsNull()) {
            e.ecb(e.packet, e.header, Socket::ERROR_NOROUTETOHOST);
        }
    }
    m_purgeTimer.Schedule(MilliSeconds(500));
}

bool RoutingBase::HasQueued(Ipv4Address dst) const {
    for (const auto& e : m_queue) {
        if (e.header.GetDestination() == dst) {
            return true;
        }
    }
    return false;
}

void RoutingBase::FlushQueue(Ipv4Address dst) {
    std::deque<QueueEntry> keep;
    std::deque<QueueEntry> send;
    for (auto& e : m_queue) {
        (e.header.GetDestination() == dst ? send : keep).push_back(e);
    }
    m_queue.swap(keep);
    for (auto& e : send) {
        PrevHopTag t;
        Ipv4Address prev;
        if (e.packet->PeekPacketTag(t)) {
            prev = IsMyAddress(t.Get()) ? t.Upstream() : t.Get();
        }
        const Ipv4Address next = SelectNextHop(dst, e.header.GetSource(), prev, e.packet);
        if (next == Ipv4Address()) {
            m_queue.push_back(e);
            continue;
        }
        // #805: the hold ends when the packet leaves toward a next hop. A
        // packet released in the instant it was queued (beeadhoc's own
        // packets pass the queue on their way out) was never held.
        const double held = (Simulator::Now() - e.queued).GetSeconds();
        if (held > 0.0) {
            HoldStats& h = m_hold[e.reason];
            ++h.count;
            h.sumS += held;
            h.maxS = std::max(h.maxS, held);
        }
        OnDataForwarded(e.packet, e.header, next);
        ForwardData(e.packet, e.header, next, e.ucb, false);
    }
}

void RoutingBase::FlushAll() {
    std::set<Ipv4Address> dsts;
    for (const auto& e : m_queue) {
        dsts.insert(e.header.GetDestination());
    }
    for (const Ipv4Address& d : dsts) {
        FlushQueue(d);
    }
}

void RoutingBase::DropQueued(Ipv4Address dst) {
    std::deque<QueueEntry> keep;
    std::deque<QueueEntry> drop;
    for (auto& e : m_queue) {
        (e.header.GetDestination() == dst ? drop : keep).push_back(e);
    }
    m_queue.swap(keep);
    for (auto& e : drop) {
        if (!e.ecb.IsNull()) {
            e.ecb(e.packet, e.header, Socket::ERROR_NOROUTETOHOST);
        }
    }
}

// --- control sockets -----------------------------------------------------------

void RoutingBase::NotifyInterfaceUp(uint32_t interface) {
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    if (l3->GetNAddresses(interface) == 0) {
        return;
    }
    Ipv4InterfaceAddress iface = l3->GetAddress(interface, 0);
    if (iface.GetLocal() == Ipv4Address("127.0.0.1")) {
        return;
    }
    Ptr<NetDevice> dev = l3->GetNetDevice(interface);

    Ptr<Socket> socket = Socket::CreateSocket(GetObject<Node>(), UdpSocketFactory::GetTypeId());
    socket->SetRecvCallback(MakeCallback(&RoutingBase::RecvSocket, this));
    socket->BindToNetDevice(dev);
    socket->Bind(InetSocketAddress(iface.GetLocal(), ControlPort()));
    socket->SetAllowBroadcast(true);
    socket->SetIpTtl(1);
    m_sockets[socket] = iface;

    // Bound to the subnet broadcast so this interface receives the floods.
    Ptr<Socket> bcast = Socket::CreateSocket(GetObject<Node>(), UdpSocketFactory::GetTypeId());
    bcast->SetRecvCallback(MakeCallback(&RoutingBase::RecvSocket, this));
    bcast->BindToNetDevice(dev);
    bcast->Bind(InetSocketAddress(iface.GetBroadcast(), ControlPort()));
    bcast->SetAllowBroadcast(true);
    bcast->SetIpTtl(1);
    m_bcastSockets[bcast] = iface;

    // MAC transmit failure (ARA §3.3 "missing acknowledgement"; Termite's
    // lost neighbour). Tolerated if the device is not wifi or the trace is
    // absent on this release: link loss then shows as route expiry only.
    Ptr<WifiNetDevice> wifi = dev ? dev->GetObject<WifiNetDevice>() : nullptr;
    if (wifi && wifi->GetMac()) {
        wifi->GetMac()->TraceConnectWithoutContext("DroppedMpdu",
                                                   MakeCallback(&RoutingBase::NotifyTxError, this));
    }

    // ARP drops: the cache's wait-reply expiry (the neighbour never answered)
    // and the node's ARP layer (dead entry, full pending queue).
    Ptr<ArpCache> cache = l3->GetInterface(interface)->GetArpCache();
    if (cache) {
        cache->TraceConnectWithoutContext("Drop", MakeCallback(&RoutingBase::NotifyArpDrop, this));
    }
    Ptr<ArpL3Protocol> arp = GetObject<Node>()->GetObject<ArpL3Protocol>();
    if (arp && !m_arpHooked) {
        arp->TraceConnectWithoutContext("Drop", MakeCallback(&RoutingBase::NotifyArpDrop, this));
        m_arpHooked = true;
    }
}

void RoutingBase::NotifyInterfaceDown(uint32_t interface) {
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    Ptr<NetDevice> dev = l3->GetNetDevice(interface);
    Ptr<WifiNetDevice> wifi = dev ? dev->GetObject<WifiNetDevice>() : nullptr;
    if (wifi && wifi->GetMac()) {
        wifi->GetMac()->TraceDisconnectWithoutContext(
            "DroppedMpdu", MakeCallback(&RoutingBase::NotifyTxError, this));
    }
    for (auto* m : {&m_sockets, &m_bcastSockets}) {
        for (auto it = m->begin(); it != m->end();) {
            if (m_ipv4->GetInterfaceForAddress(it->second.GetLocal()) ==
                static_cast<int32_t>(interface)) {
                it->first->Close();
                it = m->erase(it);
            } else {
                ++it;
            }
        }
    }
}

void RoutingBase::NotifyAddAddress(uint32_t, Ipv4InterfaceAddress) {}

void RoutingBase::NotifyRemoveAddress(uint32_t, Ipv4InterfaceAddress) {}

void RoutingBase::BroadcastControl(Ptr<Packet> p) {
    for (auto& kv : m_sockets) {
        kv.first->SendTo(p->Copy(), 0, InetSocketAddress(kv.second.GetBroadcast(), ControlPort()));
    }
}

void RoutingBase::BroadcastControlJittered(Ptr<Packet> p, Time maxJitter) {
    const Time d = MicroSeconds(m_rng->GetInteger(0, maxJitter.GetMicroSeconds()));
    Simulator::Schedule(d, &RoutingBase::BroadcastControl, this, p);
}

void RoutingBase::UnicastControl(Ptr<Packet> p, Ipv4Address neighbor) {
    const int32_t ifIdx = InterfaceTowards(neighbor);
    for (auto& kv : m_sockets) {
        if (m_ipv4->GetInterfaceForAddress(kv.second.GetLocal()) == ifIdx) {
            m_directTo = neighbor;
            kv.first->SendTo(p, 0, InetSocketAddress(neighbor, ControlPort()));
            m_directTo = Ipv4Address();
            return;
        }
    }
}

void RoutingBase::RecvSocket(Ptr<Socket> socket) {
    Address from;
    Ptr<Packet> p = socket->RecvFrom(from);
    if (!p) {
        return;
    }
    const Ipv4Address sender = InetSocketAddress::ConvertFrom(from).GetIpv4();
    if (IsMyAddress(sender)) {
        return;
    }
    Ipv4Address receiver;
    auto it = m_sockets.find(socket);
    if (it != m_sockets.end()) {
        receiver = it->second.GetLocal();
    } else {
        auto b = m_bcastSockets.find(socket);
        if (b != m_bcastSockets.end()) {
            receiver = b->second.GetLocal();
        }
    }
    RecvControl(p, sender, receiver);
}

// --- MAC failure -------------------------------------------------------------

bool RoutingBase::MapMacToIp(const Mac48Address& mac, Ipv4Address& out) const {
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    if (!l3) {
        return false;
    }
    // Forward ArpCache::Lookup per known neighbour: LookupInverse's return
    // type drifts across the ns-3 matrix (the gpsr/anthocnet pattern).
    const std::set<Ipv4Address> neighbours = KnownNeighbors();
    for (uint32_t i = 0; i < l3->GetNInterfaces(); ++i) {
        Ptr<ArpCache> cache = l3->GetInterface(i)->GetArpCache();
        if (!cache) {
            continue;
        }
        for (const Ipv4Address& nb : neighbours) {
            ArpCache::Entry* entry = cache->Lookup(nb);
            if (!entry) {
                continue;
            }
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

void RoutingBase::NotifyTxError(WifiMacDropReason reason, Ptr<const ADAPTIVE_WIFI_MPDU> mpdu) {
    if (m_sockets.empty() || !mpdu || reason != WIFI_MAC_DROP_REACHED_RETRY_LIMIT) {
        return;  // only a retry-limit drop is a broken link; the rest is congestion
    }
    const Mac48Address dstMac = mpdu->GetHeader().GetAddr1();
    if (dstMac.IsBroadcast() || dstMac.IsGroup()) {
        return;
    }
    Ipv4Address neighbor;
    if (!MapMacToIp(dstMac, neighbor)) {
        return;
    }

    // Recover the carried data packet (not our own control) before the arm
    // forgets the link, so it can be re-routed on what remains.
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    Ipv4Header ip;
    bool haveData = false;
    LlcSnapHeader llc;
    if (pkt->GetSize() >= llc.GetSerializedSize()) {
        pkt->RemoveHeader(llc);
        if (llc.GetType() == 0x0800 && pkt->GetSize() >= ip.GetSerializedSize()) {
            pkt->RemoveHeader(ip);
            bool control = false;
            if (ip.GetProtocol() == 17) {
                UdpHeader udp;
                if (pkt->GetSize() >= udp.GetSerializedSize()) {
                    pkt->PeekHeader(udp);
                    control = udp.GetDestinationPort() == ControlPort();
                }
            }
            haveData = !control && !ip.GetDestination().IsBroadcast();
        }
    }

    OnLinkFailure(neighbor);

    if (!haveData || ip.GetTtl() <= 1 || m_cachedUcb.IsNull()) {
        return;
    }
    ++m_macReinjected;  // the MAC drop was not terminal; the drop book nets it out
    m_macReinjectTrace(ip, pkt);
    Reroute(pkt, ip);
}

void RoutingBase::NotifyArpDrop(Ptr<const Packet> packet) {
    if (m_sockets.empty() || !packet || m_cachedUcb.IsNull()) {
        return;
    }
    // Only this node's own forwarded data carries our stamp; ARP's own
    // packets and control messages never do.
    PrevHopTag stamp;
    if (!packet->PeekPacketTag(stamp) || !IsMyAddress(stamp.Get()) ||
        stamp.Next() == Ipv4Address()) {
        return;
    }
    Ptr<Packet> pkt = packet->Copy();
    Ipv4Header ip;
    if (pkt->GetSize() < ip.GetSerializedSize()) {
        return;
    }
    pkt->RemoveHeader(ip);
    OnLinkFailure(stamp.Next());
    if (ip.GetTtl() <= 1) {
        return;
    }
    ++m_arpReinjected;
    m_arpReinjectTrace(ip, pkt);
    Reroute(pkt, ip);
}

void RoutingBase::Reroute(Ptr<Packet> pkt, const Ipv4Header& ip) {
    const Ipv4Address dst = ip.GetDestination();
    PrevHopTag stamp;  // our own stamp: its upstream is where the packet came from
    const Ipv4Address upstream = pkt->PeekPacketTag(stamp) ? stamp.Upstream() : Ipv4Address();
    const Ipv4Address next = SelectNextHop(dst, ip.GetSource(), upstream, pkt);
    if (next != Ipv4Address()) {
        OnDataForwarded(pkt, ip, next);
        ForwardData(pkt, ip, next, m_cachedUcb, false);
        return;
    }
    if (OnNoRouteInTransit(pkt, ip, upstream, m_cachedUcb, m_cachedEcb)) {
        return;
    }
    Enqueue(pkt, ip, m_cachedUcb, m_cachedEcb, true);
    StartDiscovery(dst);
}

void RoutingBase::PrintRoutingTable(Ptr<OutputStreamWrapper> stream, Time::Unit) const {
    *stream->GetStream() << "adaptive arm at " << MainAddress() << ", " << m_queue.size()
                         << " packet(s) held\n";
}

}  // namespace adaptive
}  // namespace ns3
