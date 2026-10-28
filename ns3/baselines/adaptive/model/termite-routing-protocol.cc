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
                          "Pheromone each arriving packet adds to the link toward its source "
                          "(§4.2.2). Table 4.1 gives no value; 1, the initial pheromone.",
                          DoubleValue(1.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_gamma),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Decay", "tau, the decay rate per second (Table 4.1: 0.105).",
                          DoubleValue(0.105), MakeDoubleAccessor(&TermiteRoutingProtocol::m_decay),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("InitialPheromone",
                          "Value of a new destination's or neighbour's cells (Table 4.1: 1).",
                          DoubleValue(1.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_initial),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Floor",
                          "Pheromone floor; a cell at the floor is unused (Table 4.1: 0.1).",
                          DoubleValue(0.1), MakeDoubleAccessor(&TermiteRoutingProtocol::m_floor),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Ceiling", "Pheromone ceiling (Table 4.1: 10000).", DoubleValue(10000.0),
                          MakeDoubleAccessor(&TermiteRoutingProtocol::m_ceiling),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Threshold", "K of eq. 4.3; nominal 0 (§4.2.5).", DoubleValue(0.0),
                          MakeDoubleAccessor(&TermiteRoutingProtocol::m_k),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Sensitivity",
                          "F of eq. 4.3. Table 4.1 gives none; 10: §5.4 finds high "
                          "sensitivities best and §7.3 runs F = 10.",
                          DoubleValue(10.0), MakeDoubleAccessor(&TermiteRoutingProtocol::m_f),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("RreqTimeout",
                          "Wait for a route reply before the held packets are dropped "
                          "(Table 4.1: 2 s).",
                          TimeValue(Seconds(2)),
                          MakeTimeAccessor(&TermiteRoutingProtocol::m_rreqTimeout),
                          MakeTimeChecker())
            .AddAttribute("RreqTtl", "Hops a route request or reply may travel (Table 4.1: 32).",
                          UintegerValue(32),
                          MakeUintegerAccessor(&TermiteRoutingProtocol::m_rreqTtl),
                          MakeUintegerChecker<uint8_t>(1))
            .AddAttribute("RreqsPerRequest", "Random walks sent per route request (Table 4.1: 2).",
                          UintegerValue(2),
                          MakeUintegerAccessor(&TermiteRoutingProtocol::m_rreqsPerRequest),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("SeedTtl", "Hops a seed's random walk travels (Table 4.1: 4).",
                          UintegerValue(4),
                          MakeUintegerAccessor(&TermiteRoutingProtocol::m_seedTtl),
                          MakeUintegerChecker<uint8_t>(1))
            .AddAttribute("SeedPeriod", "Interval between a node's seeds (Table 4.1: 30 s).",
                          TimeValue(Seconds(30)),
                          MakeTimeAccessor(&TermiteRoutingProtocol::m_seedPeriod),
                          MakeTimeChecker())
            .AddAttribute(
                "HelloPeriod", "Interval between an isolated node's hellos (Table 4.1: 1 s).",
                TimeValue(Seconds(1)), MakeTimeAccessor(&TermiteRoutingProtocol::m_helloPeriod),
                MakeTimeChecker())
            .AddAttribute("Overhear", "Learn from overheard transmissions (promiscuous reception).",
                          BooleanValue(true),
                          MakeBooleanAccessor(&TermiteRoutingProtocol::m_overhear),
                          MakeBooleanChecker());
    return tid;
}

TermiteRoutingProtocol::TermiteRoutingProtocol()
    : m_gamma(1.0),
      m_decay(0.105),
      m_initial(1.0),
      m_floor(0.1),
      m_ceiling(10000.0),
      m_k(0.0),
      m_f(10.0),
      m_rreqTimeout(Seconds(2)),
      m_rreqTtl(32),
      m_rreqsPerRequest(2),
      m_seedTtl(4),
      m_seedPeriod(Seconds(30)),
      m_helloPeriod(Seconds(1)),
      m_overhear(true),
      m_seq(0),
      m_rreqsSent(0),
      m_overheard(0) {}

TermiteRoutingProtocol::~TermiteRoutingProtocol() = default;

void TermiteRoutingProtocol::DoInitialize() {
    m_table.Configure(m_decay, m_initial, m_floor, m_ceiling);
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
    // Every node starts isolated: its first hellos find the neighbourhood.
    m_helloTimer = Simulator::Schedule(MicroSeconds(Rng()->GetInteger(0, 100000)),
                                       &TermiteRoutingProtocol::HelloTimer, this);
    m_seedTimer =
        Simulator::Schedule(MicroSeconds(Rng()->GetInteger(0, m_seedPeriod.GetMicroSeconds())),
                            &TermiteRoutingProtocol::SeedTimer, this);
    m_pruneTimer = Simulator::Schedule(Seconds(1), &TermiteRoutingProtocol::PruneTimer, this);
    RoutingBase::DoInitialize();
}

void TermiteRoutingProtocol::DoDispose() {
    m_helloTimer.Cancel();
    m_seedTimer.Cancel();
    m_pruneTimer.Cancel();
    for (auto& kv : m_pendingRreq) {
        kv.second.Cancel();
    }
    m_pendingRreq.clear();
    RoutingBase::DoDispose();
}

double TermiteRoutingProtocol::Now() const { return Simulator::Now().GetSeconds(); }

void TermiteRoutingProtocol::Learn(Ipv4Address neighbor, Ipv4Address source) {
    if (neighbor == Ipv4Address() || IsMyAddress(neighbor)) {
        return;
    }
    m_table.AddNeighbor(neighbor, Now());
    if (source != Ipv4Address() && !IsMyAddress(source)) {
        m_table.Deposit(source, neighbor, m_gamma, Now());
    }
}

std::set<Ipv4Address> TermiteRoutingProtocol::KnownNeighbors() const { return m_table.Neighbors(); }

Ipv4Address TermiteRoutingProtocol::SelectNextHop(Ipv4Address dst, Ipv4Address, Ipv4Address prev,
                                                  Ptr<const Packet>) {
    if (!m_table.HasDestination(dst)) {
        return Ipv4Address();  // unknown destination: route request
    }
    // eq. 4.3 over N - r: never back to the link the packet arrived on.
    std::vector<Ipv4Address> hops;
    std::vector<double> weights;
    for (const Ipv4Address& n : m_table.Neighbors()) {
        if (n == prev) {
            continue;
        }
        hops.push_back(n);
        weights.push_back(TermiteWeight(m_table.Get(dst, n, Now()), m_k, m_f));
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
    m_table.RemoveNeighbor(neighbor);  // lost neighbour: its row goes (§4.2.3)
}

Ipv4Address TermiteRoutingProtocol::RandomNeighbor(Ipv4Address exclude) {
    std::vector<Ipv4Address> nbs;
    for (const Ipv4Address& n : m_table.Neighbors()) {
        if (n != exclude) {
            nbs.push_back(n);
        }
    }
    if (nbs.empty()) {
        return Ipv4Address();
    }
    return nbs[Rng()->GetInteger(0, nbs.size() - 1)];
}

void TermiteRoutingProtocol::HelloTimer() {
    // §4.2.6: hellos only while the node knows no neighbour.
    if (m_table.Neighbors().empty()) {
        ControlHeader h;
        h.type = TERMITE_HELLO;
        h.origin = MainAddress();
        Ptr<Packet> p = Create<Packet>();
        p->AddHeader(h);
        BroadcastControl(p);
    }
    m_helloTimer = Simulator::Schedule(m_helloPeriod, &TermiteRoutingProtocol::HelloTimer, this);
}

void TermiteRoutingProtocol::SeedTimer() {
    const Ipv4Address next = RandomNeighbor(Ipv4Address());
    if (next != Ipv4Address()) {
        ControlHeader h;
        h.type = TERMITE_SEED;
        h.ttl = m_seedTtl;
        h.seq = ++m_seq;
        h.origin = MainAddress();
        Ptr<Packet> p = Create<Packet>();
        p->AddHeader(h);
        UnicastControl(p, next);
    }
    m_seedTimer = Simulator::Schedule(m_seedPeriod, &TermiteRoutingProtocol::SeedTimer, this);
}

void TermiteRoutingProtocol::PruneTimer() {
    m_table.Prune(Now());
    m_pruneTimer = Simulator::Schedule(Seconds(1), &TermiteRoutingProtocol::PruneTimer, this);
}

void TermiteRoutingProtocol::StartDiscovery(Ipv4Address dst) {
    if (m_table.HasDestination(dst)) {
        FlushQueue(dst);
        return;
    }
    if (m_pendingRreq.count(dst)) {
        return;  // one route request per destination at a time
    }
    for (uint32_t i = 0; i < m_rreqsPerRequest; ++i) {
        const Ipv4Address next = RandomNeighbor(Ipv4Address());
        if (next == Ipv4Address()) {
            break;
        }
        ControlHeader h;
        h.type = TERMITE_RREQ;
        h.ttl = m_rreqTtl;
        h.seq = ++m_seq;
        h.origin = MainAddress();
        h.target = dst;
        Ptr<Packet> p = Create<Packet>();
        p->AddHeader(h);
        UnicastControl(p, next);
        ++m_rreqsSent;
    }
    m_pendingRreq[dst] =
        Simulator::Schedule(m_rreqTimeout, &TermiteRoutingProtocol::RreqTimeout, this, dst);
}

void TermiteRoutingProtocol::RreqTimeout(Ipv4Address dst) {
    m_pendingRreq.erase(dst);
    if (m_table.HasDestination(dst)) {
        FlushQueue(dst);
        return;
    }
    DropQueued(dst);  // §4.2.6: no reply within the rreq timeout
}

void TermiteRoutingProtocol::RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address) {
    ControlHeader h;
    if (p->GetSize() < h.GetSerializedSize()) {
        return;
    }
    p->RemoveHeader(h);
    switch (h.type) {
        case TERMITE_HELLO: {
            Learn(from, from);
            ControlHeader r;
            r.type = TERMITE_HELLO_REPLY;
            r.origin = MainAddress();
            Ptr<Packet> q = Create<Packet>();
            q->AddHeader(r);
            // Every neighbour answers the same broadcast: spread the replies.
            Simulator::Schedule(MicroSeconds(Rng()->GetInteger(0, 10000)),
                                &TermiteRoutingProtocol::UnicastControl, this, q, from);
            return;
        }
        case TERMITE_HELLO_REPLY:
            Learn(from, from);
            return;
        case TERMITE_SEED: {
            Learn(from, h.origin);
            const Ipv4Address next = RandomNeighbor(from);
            if (h.ttl > 1 && next != Ipv4Address() && !IsMyAddress(h.origin)) {
                h.ttl -= 1;
                h.hops += 1;
                Ptr<Packet> q = Create<Packet>();
                q->AddHeader(h);
                UnicastControl(q, next);
            }
            return;
        }
        case TERMITE_RREQ: {
            // Like every packet, the request lays pheromone toward its source.
            Learn(from, h.origin);
            if (!IsMyAddress(h.origin) &&
                (IsMyAddress(h.target) || m_table.HasDestination(h.target))) {
                // §4.2.6: the reply's source is the requested destination.
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
                    UnicastControl(q, next);
                }
                return;
            }
            // The walk: uniform over the neighbours but the arrival link.
            const Ipv4Address next = RandomNeighbor(from);
            if (h.ttl > 1 && next != Ipv4Address()) {
                h.ttl -= 1;
                h.hops += 1;
                Ptr<Packet> q = Create<Packet>();
                q->AddHeader(h);
                UnicastControl(q, next);
            }
            return;
        }
        case TERMITE_RREP: {
            Learn(from, h.origin);
            FlushQueue(h.origin);
            if (IsMyAddress(h.target)) {
                auto it = m_pendingRreq.find(h.origin);
                if (it != m_pendingRreq.end()) {
                    it->second.Cancel();
                    m_pendingRreq.erase(it);
                }
                return;
            }
            const Ipv4Address next = SelectNextHop(h.target, Ipv4Address(), from, nullptr);
            if (h.ttl > 1 && next != Ipv4Address()) {
                h.ttl -= 1;
                h.hops += 1;
                Ptr<Packet> q = Create<Packet>();
                q->AddHeader(h);
                UnicastControl(q, next);
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
                    const bool walk =
                        h.type == TERMITE_RREQ || h.type == TERMITE_RREP || h.type == TERMITE_SEED;
                    Learn(ip.GetSource(), walk ? h.origin : ip.GetSource());
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
