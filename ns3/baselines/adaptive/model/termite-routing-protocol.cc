// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "termite-routing-protocol.h"

#include "adaptive-packet.h"

#include "ns3/boolean.h"
#include "ns3/double.h"
#include "ns3/ipv4-header.h"
#include "ns3/log.h"
#include "ns3/simulator.h"
#include "ns3/udp-header.h"
#include "ns3/uinteger.h"
#include "ns3/wifi-net-device.h"

#include <algorithm>

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("TermiteRoutingProtocol");

namespace adaptive {

NS_OBJECT_ENSURE_REGISTERED(TermiteRoutingProtocol);

TypeId TermiteRoutingProtocol::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::adaptive::TermiteRoutingProtocol")
            .SetParent<RoutingBase>()
            .SetGroupName("Adaptive")
            .AddConstructor<TermiteRoutingProtocol>()
            .AddAttribute("Gamma",
                          "Pheromone each arriving packet adds to the link toward its "
                          "source. Nominal 1 (secondary sources; the slides give none).",
                          DoubleValue(1.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_gamma),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Decay",
                          "tau, the continuous decay rate (1/s). The slides give no value, "
                          "only that moderate rates are preferred and that the best rate "
                          "grows with node speed: repo choice.",
                          DoubleValue(1.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_decay),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Threshold",
                          "K, the pheromone threshold of the forwarding equation. Not "
                          "given: 0, the value Termite-Hill (derived from Termite) uses.",
                          DoubleValue(0.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_k),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Sensitivity",
                          "F, the pheromone sensitivity exponent. Not given: 2, the value "
                          "Termite-Hill uses.",
                          DoubleValue(2.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_f),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Floor",
                          "Underflow guard: pheromone below this is treated as none. Termite "
                          "has no expiry (normalised probabilities route on any positive "
                          "value); trails end when a neighbour is lost.",
                          DoubleValue(1e-9), MakeDoubleAccessor(&TermiteRoutingProtocol::m_floor),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("HelloInterval",
                          "A node that transmitted nothing for this long broadcasts a hello, "
                          "so a silent node (a sink) stays someone's neighbour. Not in the "
                          "slides, which rely on overhearing alone: repo choice (AODV's "
                          "hello interval), suppressed whenever the node was overheard.",
                          TimeValue(Seconds(1)),
                          MakeTimeAccessor(&TermiteRoutingProtocol::m_helloInterval),
                          MakeTimeChecker())
            .AddAttribute("NeighborTimeout",
                          "A neighbour not heard for this long is forgotten (a lost one is also "
                          "removed at once on a MAC failure, the slides' route repair).",
                          TimeValue(Seconds(3)),
                          MakeTimeAccessor(&TermiteRoutingProtocol::m_neighborTimeout),
                          MakeTimeChecker())
            .AddAttribute("RreqTtl", "Steps a route request's random walk may take.",
                          UintegerValue(64),
                          MakeUintegerAccessor(&TermiteRoutingProtocol::m_rreqTtl),
                          MakeUintegerChecker<uint8_t>(1))
            .AddAttribute(
                "DiscoveryTimeout", "Wait for a route before a new random walk; doubles per retry.",
                TimeValue(Seconds(1)),
                MakeTimeAccessor(&TermiteRoutingProtocol::m_discoveryTimeout), MakeTimeChecker())
            .AddAttribute("DiscoveryRetries", "Walks re-sent before the held packets are dropped.",
                          UintegerValue(2),
                          MakeUintegerAccessor(&TermiteRoutingProtocol::m_discoveryRetries),
                          MakeUintegerChecker<uint32_t>())
            .AddAttribute("Overhear", "Learn from overheard transmissions (promiscuous reception).",
                          BooleanValue(true),
                          MakeBooleanAccessor(&TermiteRoutingProtocol::m_overhear),
                          MakeBooleanChecker());
    return tid;
}

TermiteRoutingProtocol::TermiteRoutingProtocol()
    : m_gamma(1.0),
      m_decay(1.0),
      m_k(0.0),
      m_f(2.0),
      m_floor(1e-9),
      m_helloInterval(Seconds(1)),
      m_neighborTimeout(Seconds(3)),
      m_rreqTtl(64),
      m_discoveryTimeout(Seconds(1)),
      m_discoveryRetries(2),
      m_overhear(true),
      m_seq(0),
      m_lastTx(Seconds(0)),
      m_rreqsSent(0),
      m_overheard(0) {}

TermiteRoutingProtocol::~TermiteRoutingProtocol() = default;

void TermiteRoutingProtocol::DoInitialize() {
    m_table.Configure(PheromoneTable<Ipv4Address>::Decay::Exponential, m_decay, 1.0, m_floor);
    Ptr<Node> node = GetObject<Node>();
    if (m_overhear && node) {
        for (uint32_t i = 0; i < node->GetNDevices(); ++i) {
            Ptr<NetDevice> dev = node->GetDevice(i);
            if (dev->GetObject<WifiNetDevice>()) {
                node->RegisterProtocolHandler(MakeCallback(&TermiteRoutingProtocol::Overhear, this),
                                              Ipv4L3Protocol::PROT_NUMBER, dev, true);
            }
        }
    }
    m_helloTimer = Simulator::Schedule(MicroSeconds(Rng()->GetInteger(0, 1000000)),
                                       &TermiteRoutingProtocol::HelloTimer, this);
    RoutingBase::DoInitialize();
}

void TermiteRoutingProtocol::DoDispose() {
    m_helloTimer.Cancel();
    for (auto& kv : m_discovery) {
        kv.second.timer.Cancel();
    }
    m_discovery.clear();
    RoutingBase::DoDispose();
}

double TermiteRoutingProtocol::Now() const { return Simulator::Now().GetSeconds(); }

void TermiteRoutingProtocol::Learn(Ipv4Address neighbor, Ipv4Address source) {
    if (neighbor == Ipv4Address() || IsMyAddress(neighbor)) {
        return;
    }
    m_neighbors[neighbor] = Simulator::Now();
    if (source != Ipv4Address() && !IsMyAddress(source)) {
        m_table.Add(source, neighbor, m_gamma, Now());
    }
}

std::vector<Ipv4Address> TermiteRoutingProtocol::LiveNeighbors() {
    const Time now = Simulator::Now();
    std::vector<Ipv4Address> out;
    for (auto it = m_neighbors.begin(); it != m_neighbors.end();) {
        if (now - it->second > m_neighborTimeout) {
            m_table.EraseNeighbor(it->first);
            it = m_neighbors.erase(it);
            continue;
        }
        out.push_back(it->first);
        ++it;
    }
    return out;
}

std::set<Ipv4Address> TermiteRoutingProtocol::KnownNeighbors() const {
    std::set<Ipv4Address> out;
    for (const auto& kv : m_neighbors) {
        out.insert(kv.first);
    }
    return out;
}

Ipv4Address TermiteRoutingProtocol::SelectNextHop(Ipv4Address dst, Ipv4Address, Ipv4Address prev,
                                                  Ptr<const Packet>) {
    const std::vector<Ipv4Address> nbs = LiveNeighbors();
    std::vector<Ipv4Address> hops;
    std::vector<double> weights;
    bool any = false;
    for (const Ipv4Address& n : nbs) {
        if (n == prev && nbs.size() > 1) {
            continue;  // never straight back while another neighbour exists
        }
        const double ph = m_table.Get(dst, n, Now());
        any = any || ph > m_floor;
        hops.push_back(n);
        weights.push_back(TermiteWeight(ph < m_floor ? 0.0 : ph, m_k, m_f));
    }
    if (!any) {
        return Ipv4Address();  // no pheromone for dst: route discovery
    }
    const int i = PickProportional(weights, Rng()->GetValue(0.0, 1.0));
    return i < 0 ? Ipv4Address() : hops[i];
}

bool TermiteRoutingProtocol::OnDataReceived(Ptr<const Packet>, const Ipv4Header& header,
                                            Ipv4Address prev, bool) {
    Learn(prev, header.GetSource());
    return true;
}

void TermiteRoutingProtocol::OnLinkFailure(Ipv4Address neighbor) {
    // Route repair: the lost neighbour leaves the table.
    m_neighbors.erase(neighbor);
    m_table.EraseNeighbor(neighbor);
}

Ipv4Address TermiteRoutingProtocol::RandomNeighbor(Ipv4Address exclude) {
    std::vector<Ipv4Address> nbs = LiveNeighbors();
    if (nbs.size() > 1) {
        nbs.erase(std::remove(nbs.begin(), nbs.end(), exclude), nbs.end());
    }
    if (nbs.empty()) {
        return Ipv4Address();
    }
    return nbs[Rng()->GetInteger(0, nbs.size() - 1)];
}

void TermiteRoutingProtocol::HelloTimer() {
    // Suppressed while the node transmits anyway: its neighbours overheard it.
    if (Simulator::Now() - m_lastTx >= m_helloInterval) {
        ControlHeader h;
        h.type = TERMITE_HELLO;
        h.origin = MainAddress();
        Ptr<Packet> p = Create<Packet>();
        p->AddHeader(h);
        BroadcastControl(p);
        m_lastTx = Simulator::Now();
    }
    // +-10 % jitter keeps neighbours' beacons from locking in phase.
    const double j = Rng()->GetValue(0.9, 1.1);
    m_helloTimer =
        Simulator::Schedule(m_helloInterval * j, &TermiteRoutingProtocol::HelloTimer, this);
}

void TermiteRoutingProtocol::OnDataForwarded(Ptr<const Packet>, const Ipv4Header&, Ipv4Address) {
    m_lastTx = Simulator::Now();
}

void TermiteRoutingProtocol::SendControl(Ptr<Packet> p, Ipv4Address next) {
    m_lastTx = Simulator::Now();
    UnicastControl(p, next);
}

void TermiteRoutingProtocol::StartDiscovery(Ipv4Address dst) {
    if (SelectNextHop(dst, Ipv4Address(), Ipv4Address(), nullptr) != Ipv4Address()) {
        FlushQueue(dst);
        return;
    }
    auto it = m_discovery.find(dst);
    if (it != m_discovery.end() && !it->second.timer.IsExpired()) {
        return;
    }
    m_discovery[dst].attempts = 0;
    SendRreq(dst);
}

void TermiteRoutingProtocol::SendRreq(Ipv4Address dst) {
    Discovery& d = m_discovery[dst];
    LiveNeighbors();
    const Ipv4Address next = m_neighbors.count(dst) ? dst : RandomNeighbor(Ipv4Address());
    if (next != Ipv4Address()) {
        ControlHeader h;
        h.type = TERMITE_RREQ;
        h.ttl = m_rreqTtl;
        h.seq = ++m_seq;
        h.origin = MainAddress();
        h.target = dst;
        Ptr<Packet> p = Create<Packet>();
        p->AddHeader(h);
        SendControl(p, next);
        ++m_rreqsSent;
    }
    const Time wait = m_discoveryTimeout * static_cast<double>(1u << std::min(d.attempts, 8u));
    d.timer = Simulator::Schedule(wait, &TermiteRoutingProtocol::DiscoveryTimeout, this, dst);
}

void TermiteRoutingProtocol::DiscoveryTimeout(Ipv4Address dst) {
    if (SelectNextHop(dst, Ipv4Address(), Ipv4Address(), nullptr) != Ipv4Address()) {
        m_discovery.erase(dst);
        FlushQueue(dst);
        return;
    }
    Discovery& d = m_discovery[dst];
    if (d.attempts < m_discoveryRetries && HasQueued(dst)) {
        ++d.attempts;
        SendRreq(dst);
        return;
    }
    m_discovery.erase(dst);
    DropQueued(dst);
}

void TermiteRoutingProtocol::RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address) {
    ControlHeader h;
    if (p->GetSize() < h.GetSerializedSize()) {
        return;
    }
    p->RemoveHeader(h);
    switch (h.type) {
        case TERMITE_HELLO:
            Learn(from, from);
            return;
        case TERMITE_RREQ: {
            // Like every packet, the request lays pheromone toward its source.
            Learn(from, h.origin);
            // A walk that passes back through its requester just keeps walking.
            const bool known =
                IsMyAddress(h.origin)
                    ? false
                    : IsMyAddress(h.target) ||
                          SelectNextHop(h.target, Ipv4Address(), from, nullptr) != Ipv4Address();
            if (known) {
                // Reply as the destination's trail: the RREP's source is the
                // destination, so every node it crosses learns the way there.
                ControlHeader r;
                r.type = TERMITE_RREP;
                r.ttl = m_rreqTtl;
                r.seq = h.seq;
                r.origin = h.target;
                r.target = h.origin;
                const Ipv4Address next =
                    SelectNextHop(h.origin, Ipv4Address(), Ipv4Address(), nullptr);
                if (next != Ipv4Address()) {
                    Ptr<Packet> q = Create<Packet>();
                    q->AddHeader(r);
                    SendControl(q, next);
                }
                return;
            }
            if (h.ttl > 1) {
                // The walk looks for the destination: a step straight to it when
                // it is a neighbour, a uniformly random neighbour otherwise.
                const Ipv4Address next =
                    m_neighbors.count(h.target) ? h.target : RandomNeighbor(from);
                if (next == Ipv4Address()) {
                    return;  // knows no one to walk to; the walk ends here
                }
                h.ttl -= 1;
                h.hops += 1;
                Ptr<Packet> q = Create<Packet>();
                q->AddHeader(h);
                SendControl(q, next);
            }
            return;
        }
        case TERMITE_RREP: {
            Learn(from, h.origin);
            FlushQueue(h.origin);
            if (IsMyAddress(h.target)) {
                auto it = m_discovery.find(h.origin);
                if (it != m_discovery.end()) {
                    it->second.timer.Cancel();
                    m_discovery.erase(it);
                }
                return;
            }
            if (h.ttl > 1) {
                const Ipv4Address next = SelectNextHop(h.target, Ipv4Address(), from, nullptr);
                if (next != Ipv4Address()) {
                    h.ttl -= 1;
                    h.hops += 1;
                    Ptr<Packet> q = Create<Packet>();
                    q->AddHeader(h);
                    SendControl(q, next);
                }
            }
            return;
        }
        default:
            return;
    }
}

void TermiteRoutingProtocol::Overhear(Ptr<NetDevice>, Ptr<const Packet> packet, uint16_t,
                                      const Address&, const Address&, NetDevice::PacketType type) {
    // Only frames addressed to someone else: the rest arrive through IP.
    if (type != NetDevice::PACKET_OTHERHOST) {
        return;
    }
    Ptr<Packet> p = packet->Copy();
    Ipv4Header ip;
    if (p->GetSize() < ip.GetSerializedSize()) {
        return;
    }
    p->RemoveHeader(ip);
    if (ip.GetProtocol() == 17) {
        UdpHeader udp;
        if (p->GetSize() >= udp.GetSerializedSize()) {
            p->PeekHeader(udp);
            if (udp.GetDestinationPort() == TERMITE_PORT) {
                // Overheard control: one hop, so the IP source is the sender.
                p->RemoveHeader(udp);
                ControlHeader h;
                if (p->GetSize() >= h.GetSerializedSize()) {
                    p->RemoveHeader(h);
                    ++m_overheard;
                    Learn(ip.GetSource(), h.type == TERMITE_RREQ || h.type == TERMITE_RREP
                                              ? h.origin
                                              : ip.GetSource());
                }
                return;
            }
        }
    }
    PrevHopTag tag;
    if (p->PeekPacketTag(tag)) {
        ++m_overheard;
        Learn(tag.Get(), ip.GetSource());
    }
}

}  // namespace adaptive
}  // namespace ns3
