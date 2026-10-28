// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "qrouting-routing-protocol.h"

#include "adaptive-packet.h"
#include "adaptive-tables.h"

#include "ns3/double.h"
#include "ns3/log.h"
#include "ns3/simulator.h"
#include "ns3/wifi-net-device.h"

#include <cmath>
#include <limits>

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("QRoutingProtocol");

namespace adaptive {

NS_OBJECT_ENSURE_REGISTERED(QRoutingProtocol);

TypeId QRoutingProtocol::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::adaptive::QRoutingProtocol")
            .SetParent<RoutingBase>()
            .SetGroupName("Adaptive")
            .AddConstructor<QRoutingProtocol>()
            .AddAttribute("LearningRate",
                          "eta of the Q-routing update (\"usually 0.5 in our experiments\", "
                          "Boyan & Littman §2).",
                          DoubleValue(0.5), MakeDoubleAccessor(&QRoutingProtocol::m_eta),
                          MakeDoubleChecker<double>(0.0, 1.0))
            .AddAttribute("QInit",
                          "Initial estimate (s) of an untried (destination, neighbour) pair; "
                          "a neighbour that is the destination starts at 0. Not given in "
                          "the paper: 1 s, above any delivery time measured at the harness "
                          "loads, so greedy keeps a route that works and tries an unknown "
                          "neighbour only when every known one is worse (basic Q-routing "
                          "does not explore, §3.2). An optimistic 0 makes every node report "
                          "t = 0 while it has an untried neighbour, and no gradient forms.",
                          DoubleValue(1.0), MakeDoubleAccessor(&QRoutingProtocol::m_qInit),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("HelloInterval",
                          "Neighbour beacon period (the paper's links are known in advance; "
                          "AODV's hello interval).",
                          TimeValue(Seconds(1)),
                          MakeTimeAccessor(&QRoutingProtocol::m_helloInterval), MakeTimeChecker())
            .AddAttribute(
                "NeighborTimeout", "A neighbour not heard for this long is lost (AODV: 3 hellos).",
                TimeValue(Seconds(3)), MakeTimeAccessor(&QRoutingProtocol::m_neighborTimeout),
                MakeTimeChecker());
    return tid;
}

QRoutingProtocol::QRoutingProtocol()
    : m_eta(0.5),
      m_qInit(1.0),
      m_helloInterval(Seconds(1)),
      m_neighborTimeout(Seconds(3)),
      m_estimatesSent(0),
      m_updates(0) {}

QRoutingProtocol::~QRoutingProtocol() = default;

void QRoutingProtocol::DoInitialize() {
    Ptr<Node> node = GetObject<Node>();
    for (uint32_t i = 0; node && i < node->GetNDevices(); ++i) {
        Ptr<WifiNetDevice> wifi = node->GetDevice(i)->GetObject<WifiNetDevice>();
        if (wifi && wifi->GetMac()) {
            wifi->GetMac()->TraceConnectWithoutContext(
                "AckedMpdu", MakeCallback(&QRoutingProtocol::NotifyAcked, this));
        }
    }
    m_helloTimer = Simulator::Schedule(MicroSeconds(Rng()->GetInteger(0, 1000000)),
                                       &QRoutingProtocol::HelloTimer, this);
    m_purge = Simulator::Schedule(Seconds(1), &QRoutingProtocol::PurgePending, this);
    RoutingBase::DoInitialize();
}

void QRoutingProtocol::DoDispose() {
    m_helloTimer.Cancel();
    m_purge.Cancel();
    RoutingBase::DoDispose();
}

void QRoutingProtocol::HelloTimer() {
    ControlHeader h;
    h.type = QR_HELLO;
    h.origin = MainAddress();
    Ptr<Packet> p = Create<Packet>();
    p->AddHeader(h);
    BroadcastControl(p);
    const double j = Rng()->GetValue(0.9, 1.1);
    m_helloTimer = Simulator::Schedule(m_helloInterval * j, &QRoutingProtocol::HelloTimer, this);
}

std::vector<Ipv4Address> QRoutingProtocol::LiveNeighbors() {
    const Time now = Simulator::Now();
    std::vector<Ipv4Address> out;
    for (auto it = m_neighbors.begin(); it != m_neighbors.end();) {
        if (now - it->second > m_neighborTimeout) {
            OnLinkFailure((it++)->first);
            continue;
        }
        out.push_back(it->first);
        ++it;
    }
    return out;
}

std::set<Ipv4Address> QRoutingProtocol::KnownNeighbors() const {
    std::set<Ipv4Address> out;
    for (const auto& kv : m_neighbors) {
        out.insert(kv.first);
    }
    return out;
}

double QRoutingProtocol::Q(Ipv4Address dst, Ipv4Address nb) const {
    auto d = m_q.find(dst);
    if (d != m_q.end()) {
        auto n = d->second.find(nb);
        if (n != d->second.end()) {
            return n->second;
        }
    }
    return nb == dst ? 0.0 : m_qInit;
}

double QRoutingProtocol::BestEstimate(Ipv4Address dst) {
    if (IsMyAddress(dst)) {
        return 0.0;
    }
    double best = std::numeric_limits<double>::infinity();
    for (const Ipv4Address& n : LiveNeighbors()) {
        best = std::min(best, Q(dst, n));
    }
    return std::isinf(best) ? m_qInit : best;
}

Ipv4Address QRoutingProtocol::SelectNextHop(Ipv4Address dst, Ipv4Address, Ipv4Address,
                                            Ptr<const Packet>) {
    // Greedy: the smallest estimate; ties broken uniformly at random.
    const std::vector<Ipv4Address> nbs = LiveNeighbors();
    double best = std::numeric_limits<double>::infinity();
    std::vector<Ipv4Address> ties;
    for (const Ipv4Address& n : nbs) {
        const double q = Q(dst, n);
        if (q < best - 1e-12) {
            best = q;
            ties.assign(1, n);
        } else if (q <= best + 1e-12) {
            ties.push_back(n);
        }
    }
    if (ties.empty()) {
        return Ipv4Address();
    }
    return ties.size() == 1 ? ties[0] : ties[Rng()->GetInteger(0, ties.size() - 1)];
}

void QRoutingProtocol::OnDataForwarded(Ptr<const Packet> p, const Ipv4Header& header,
                                       Ipv4Address next) {
    const PacketKey key(header.GetSource().Get(), header.GetDestination().Get(),
                        header.GetIdentification());
    m_pending[key] = Pending{next, Simulator::Now(), Time(0)};
    if (p) {
        m_pendingByUid[p->GetUid()] = key;
    }
}

void QRoutingProtocol::NotifyAcked(Ptr<const ADAPTIVE_WIFI_MPDU> mpdu) {
    if (!mpdu) {
        return;
    }
    auto u = m_pendingByUid.find(mpdu->GetPacket()->GetUid());
    if (u == m_pendingByUid.end()) {
        return;
    }
    auto it = m_pending.find(u->second);
    if (it != m_pending.end() && it->second.acked.IsZero()) {
        it->second.acked = Simulator::Now();
    }
    m_pendingByUid.erase(u);
}

bool QRoutingProtocol::OnDataReceived(Ptr<const Packet>, const Ipv4Header& header, Ipv4Address prev,
                                      bool) {
    if (prev == Ipv4Address()) {
        return true;
    }
    m_neighbors[prev] = Simulator::Now();
    // §2: "upon sending P to y, x immediately gets back y's estimate".
    ControlHeader h;
    h.type = QR_ESTIMATE;
    h.origin = header.GetSource();
    h.target = header.GetDestination();
    h.seq = header.GetIdentification();
    h.value = BestEstimate(header.GetDestination());
    Ptr<Packet> p = Create<Packet>();
    p->AddHeader(h);
    UnicastControl(p, prev);
    ++m_estimatesSent;
    return true;
}

void QRoutingProtocol::RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address) {
    ControlHeader h;
    if (p->GetSize() < h.GetSerializedSize()) {
        return;
    }
    p->RemoveHeader(h);
    const bool isNew = m_neighbors.find(from) == m_neighbors.end();
    m_neighbors[from] = Simulator::Now();
    if (h.type == QR_HELLO) {
        if (isNew) {
            // Packets held while this node knew no neighbour can leave now.
            FlushAll();
        }
        return;
    }
    if (h.type != QR_ESTIMATE) {
        return;
    }
    const PacketKey key(h.origin.Get(), h.target.Get(), static_cast<uint16_t>(h.seq));
    auto it = m_pending.find(key);
    if (it == m_pending.end() || it->second.next != from) {
        return;
    }
    // q + s: from the hand-off to the MAC until its acknowledgement; if the
    // ack trace did not match, until the estimate arrived.
    const Time end = it->second.acked.IsZero() ? Simulator::Now() : it->second.acked;
    const double qs = (end - it->second.sent).GetSeconds();
    const double old = Q(h.target, from);
    m_q[h.target][from] = QUpdate(old, m_eta, 0.0, qs, h.value);
    ++m_updates;
    m_pending.erase(it);
}

void QRoutingProtocol::OnLinkFailure(Ipv4Address neighbor) {
    m_neighbors.erase(neighbor);
    for (auto& d : m_q) {
        d.second.erase(neighbor);
    }
}

void QRoutingProtocol::StartDiscovery(Ipv4Address) {
    // Q-routing has no discovery: a node with no neighbour holds the packet
    // until a hello arrives (FlushAll above).
}

void QRoutingProtocol::PurgePending() {
    const Time cutoff = Simulator::Now() - Seconds(1);
    for (auto it = m_pending.begin(); it != m_pending.end();) {
        it = it->second.sent < cutoff ? m_pending.erase(it) : std::next(it);
    }
    if (m_pendingByUid.size() > 4 * m_pending.size() + 1024) {
        m_pendingByUid.clear();  // acks for long-gone packets never come
    }
    m_purge = Simulator::Schedule(Seconds(1), &QRoutingProtocol::PurgePending, this);
}

}  // namespace adaptive
}  // namespace ns3
