// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "ara-routing-protocol.h"

#include "adaptive-packet.h"

#include "ns3/double.h"
#include "ns3/log.h"
#include "ns3/simulator.h"
#include "ns3/uinteger.h"

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("AraRoutingProtocol");

namespace adaptive {

NS_OBJECT_ENSURE_REGISTERED(AraRoutingProtocol);

TypeId AraRoutingProtocol::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::adaptive::AraRoutingProtocol")
            .SetParent<RoutingBase>()
            .SetGroupName("Adaptive")
            .AddConstructor<AraRoutingProtocol>()
            .AddAttribute("Delta",
                          "Pheromone a data packet deposits per hop (§3.2, eq. 1). "
                          "Not given in the paper: repo choice.",
                          DoubleValue(0.1), MakeDoubleAccessor(&AraRoutingProtocol::m_delta),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("Evaporation",
                          "q of eq. 2: the fraction evaporated per EvaporationPeriod. "
                          "Not given in the paper: repo choice.",
                          DoubleValue(0.1), MakeDoubleAccessor(&AraRoutingProtocol::m_evaporation),
                          MakeDoubleChecker<double>(0.0, 1.0))
            .AddAttribute(
                "EvaporationPeriod", "The period eq. 2 is applied over (evaluated continuously).",
                TimeValue(Seconds(1)), MakeTimeAccessor(&AraRoutingProtocol::m_evaporationPeriod),
                MakeTimeChecker())
            .AddAttribute("Floor", "Pheromone below which an entry has evaporated (route gone).",
                          DoubleValue(0.01), MakeDoubleAccessor(&AraRoutingProtocol::m_floor),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("AntTtl", "Hops a FANT/BANT flood may travel (ns-3 AODV's NetDiameter).",
                          UintegerValue(35), MakeUintegerAccessor(&AraRoutingProtocol::m_antTtl),
                          MakeUintegerChecker<uint8_t>(1))
            .AddAttribute("DiscoveryTimeout",
                          "Wait for a BANT before re-sending the FANT; doubles per retry "
                          "(ns-3 AODV's NetTraversalTime, so both arms wait alike).",
                          TimeValue(Seconds(2.8)),
                          MakeTimeAccessor(&AraRoutingProtocol::m_discoveryTimeout),
                          MakeTimeChecker())
            .AddAttribute("DiscoveryRetries",
                          "FANT re-sends before the held packets are dropped (AODV's "
                          "RreqRetries).",
                          UintegerValue(2),
                          MakeUintegerAccessor(&AraRoutingProtocol::m_discoveryRetries),
                          MakeUintegerChecker<uint32_t>())
            .AddAttribute("FloodJitter",
                          "Upper bound of the random delay before relaying a flood "
                          "(de-synchronises neighbours; AODV's broadcast jitter).",
                          TimeValue(MilliSeconds(10)),
                          MakeTimeAccessor(&AraRoutingProtocol::m_floodJitter), MakeTimeChecker());
    return tid;
}

AraRoutingProtocol::AraRoutingProtocol()
    : m_delta(0.1),
      m_evaporation(0.1),
      m_evaporationPeriod(Seconds(1)),
      m_floor(0.01),
      m_antTtl(35),
      m_discoveryTimeout(Seconds(2.8)),
      m_discoveryRetries(2),
      m_floodJitter(MilliSeconds(10)),
      m_seq(0),
      m_seenLifetime(Seconds(30)),
      m_fantsSent(0),
      m_duplicateErrors(0),
      m_backtracks(0) {}

AraRoutingProtocol::~AraRoutingProtocol() = default;

void AraRoutingProtocol::DoInitialize() {
    m_table.Configure(PheromoneTable<Ipv4Address>::Decay::Geometric, m_evaporation,
                      m_evaporationPeriod.GetSeconds(), m_floor);
    m_purge = Simulator::Schedule(Seconds(1), &AraRoutingProtocol::PurgeSeen, this);
    RoutingBase::DoInitialize();
}

void AraRoutingProtocol::DoDispose() {
    for (auto& kv : m_discovery) {
        kv.second.timer.Cancel();
    }
    m_discovery.clear();
    m_purge.Cancel();
    RoutingBase::DoDispose();
}

double AraRoutingProtocol::Now() const { return Simulator::Now().GetSeconds(); }

double AraRoutingProtocol::InitialPheromone(uint8_t hops) const {
    // §3.1: "computes the pheromone value depending on the number of hops".
    // The function is not given; the inverse hop count is the simplest that
    // makes a shorter trail the stronger one.
    return 1.0 / std::max<uint8_t>(hops, 1);
}

std::set<Ipv4Address> AraRoutingProtocol::KnownNeighbors() const { return m_table.Neighbors(); }

Ipv4Address AraRoutingProtocol::SelectNextHop(Ipv4Address dst, Ipv4Address, Ipv4Address prev,
                                              Ptr<const Packet>) {
    const auto entries = m_table.Entries(dst, Now());
    std::vector<Ipv4Address> hops;
    std::vector<double> weights;
    for (const auto& e : entries) {
        // Not straight back to the previous hop while another trail exists:
        // that is a certain DUPLICATE_ERROR, which costs a hop to learn.
        if (e.first == prev && entries.size() > 1) {
            continue;
        }
        hops.push_back(e.first);
        weights.push_back(e.second);
    }
    const int i = PickProportional(weights, Rng()->GetValue(0.0, 1.0));
    return i < 0 ? Ipv4Address() : hops[i];
}

bool AraRoutingProtocol::SeenData(const DataKey& key) {
    const Time now = Simulator::Now();
    auto it = m_seenData.find(key);
    if (it != m_seenData.end() && it->second > now) {
        return true;
    }
    m_seenData[key] = now + m_seenLifetime;
    return false;
}

bool AraRoutingProtocol::OnDataReceived(Ptr<const Packet> p, const Ipv4Header& header,
                                        Ipv4Address prev, bool backtracked) {
    const Ipv4Address src = header.GetSource();
    const Ipv4Address dst = header.GetDestination();
    if (backtracked) {
        // §3.2/§3.3: a packet sent back over the link from `prev` (duplicate
        // error, or no route beyond it). Deactivate that link for this
        // destination and route the packet again on what remains.
        m_table.Erase(dst, prev);
        return true;
    }
    if (!IsMyAddress(dst) && SeenData(DataKey(src.Get(), dst.Get(), header.GetIdentification()))) {
        // §3.2 loop prevention: back to the previous node with the flag set.
        ++m_duplicateErrors;
        ForwardData(p, header, prev, LastUcb(), true);
        return false;
    }
    // §3.2: the receiver strengthens the trail toward the source.
    m_table.Add(src, prev, m_delta, Now());
    return true;
}

void AraRoutingProtocol::OnDataForwarded(Ptr<const Packet>, const Ipv4Header& header,
                                         Ipv4Address next) {
    // §3.2: relaying toward D over j strengthens (D, j).
    m_table.Add(header.GetDestination(), next, m_delta, Now());
    if (IsMyAddress(header.GetSource())) {
        // The source remembers its own packets too, so one that loops back to
        // it is recognised as a duplicate like anywhere else on the path.
        SeenData(DataKey(header.GetSource().Get(), header.GetDestination().Get(),
                         header.GetIdentification()));
    }
}

bool AraRoutingProtocol::OnNoRouteInTransit(Ptr<const Packet> p, const Ipv4Header& header,
                                            Ipv4Address prev, UnicastForwardCallback ucb,
                                            ErrorCallback) {
    // §3.3: no alternative link — back toward the source. Only the source
    // re-discovers; it holds the packet (return false) like a new one.
    if (IsMyAddress(header.GetSource()) || prev == Ipv4Address() || IsMyAddress(prev)) {
        return false;
    }
    ++m_backtracks;
    ForwardData(p, header, prev, ucb, true);
    return true;
}

void AraRoutingProtocol::OnLinkFailure(Ipv4Address neighbor) {
    // §3.3: a missing acknowledgement deactivates the link (pheromone 0).
    m_table.EraseNeighbor(neighbor);
}

void AraRoutingProtocol::StartDiscovery(Ipv4Address dst) {
    if (m_table.HasRoute(dst, Now())) {
        FlushQueue(dst);
        return;
    }
    auto it = m_discovery.find(dst);
    if (it != m_discovery.end() && !it->second.timer.IsExpired()) {
        return;  // one discovery per destination at a time
    }
    m_discovery[dst].attempts = 0;
    SendFant(dst);
}

void AraRoutingProtocol::SendFant(Ipv4Address dst) {
    Discovery& d = m_discovery[dst];
    ControlHeader h;
    h.type = ARA_FANT;
    h.hops = 0;
    h.ttl = m_antTtl;
    h.seq = ++m_seq;
    h.origin = MainAddress();
    h.target = dst;
    SeenAnt(h.origin, h.seq, ARA_FANT);
    Ptr<Packet> p = Create<Packet>();
    p->AddHeader(h);
    BroadcastControl(p);
    ++m_fantsSent;
    const Time wait = m_discoveryTimeout * static_cast<double>(1u << std::min(d.attempts, 8u));
    d.timer = Simulator::Schedule(wait, &AraRoutingProtocol::DiscoveryTimeout, this, dst);
}

void AraRoutingProtocol::DiscoveryTimeout(Ipv4Address dst) {
    if (m_table.HasRoute(dst, Now())) {
        m_discovery.erase(dst);
        FlushQueue(dst);
        return;
    }
    Discovery& d = m_discovery[dst];
    if (d.attempts < m_discoveryRetries && HasQueued(dst)) {
        ++d.attempts;
        SendFant(dst);
        return;
    }
    m_discovery.erase(dst);
    DropQueued(dst);
}

bool AraRoutingProtocol::SeenAnt(Ipv4Address origin, uint32_t seq, uint8_t type) {
    const auto key = std::make_tuple(origin.Get(), seq, type);
    const Time now = Simulator::Now();
    auto it = m_seenAnts.find(key);
    if (it != m_seenAnts.end() && it->second > now) {
        return true;
    }
    m_seenAnts[key] = now + m_seenLifetime;
    return false;
}

void AraRoutingProtocol::PurgeSeen() {
    const Time now = Simulator::Now();
    for (auto it = m_seenAnts.begin(); it != m_seenAnts.end();) {
        it = it->second <= now ? m_seenAnts.erase(it) : std::next(it);
    }
    for (auto it = m_seenData.begin(); it != m_seenData.end();) {
        it = it->second <= now ? m_seenData.erase(it) : std::next(it);
    }
    // FANT reverse hops only matter while that discovery's BANT can come back.
    if (m_fantFrom.size() > 4096) {
        m_fantFrom.clear();
    }
    m_table.Prune(Now());
    m_purge = Simulator::Schedule(Seconds(1), &AraRoutingProtocol::PurgeSeen, this);
}

void AraRoutingProtocol::RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address) {
    ControlHeader h;
    if (p->GetSize() < h.GetSerializedSize()) {
        return;
    }
    p->RemoveHeader(h);
    if (h.type != ARA_FANT && h.type != ARA_BANT) {
        return;
    }
    if (IsMyAddress(h.origin)) {
        return;
    }
    const uint8_t hops = h.hops + 1;
    const bool first = !SeenAnt(h.origin, h.seq, h.type);

    if (h.type == ARA_FANT) {
        // §3.1: duplicate FANTs are destroyed; the first one records the
        // trail toward its source and is relayed. The node remembers which
        // neighbour the FANT came from, so the BANT can retrace the path.
        if (!first) {
            return;
        }
        m_table.SetAtLeast(h.origin, from, InitialPheromone(hops), Now());
        m_fantFrom[std::make_pair(h.origin.Get(), h.seq)] = from;
        FlushQueue(h.origin);
        if (IsMyAddress(h.target)) {
            // §3.1: the destination answers with a BANT, sent back along the
            // path the FANT came (the reading of the ARA reviews; the 2002
            // paper's Fig. 3 does not say how the BANT travels). It carries
            // the FANT's sequence number so each hop finds its way back.
            ControlHeader b;
            b.type = ARA_BANT;
            b.hops = 0;
            b.ttl = m_antTtl;
            b.seq = h.seq;
            b.origin = MainAddress();
            b.target = h.origin;
            Ptr<Packet> q = Create<Packet>();
            q->AddHeader(b);
            UnicastControl(q, from);
            return;
        }
        if (h.ttl > 1) {
            h.hops = hops;
            h.ttl -= 1;
            Ptr<Packet> q = Create<Packet>();
            q->AddHeader(h);
            BroadcastControlJittered(q, m_floodJitter);
        }
        return;
    }

    // BANT: lays the trail toward the destination over the neighbour it came
    // from, then retraces the FANT's path toward the source.
    m_table.SetAtLeast(h.origin, from, InitialPheromone(hops), Now());
    FlushQueue(h.origin);
    if (IsMyAddress(h.target)) {
        auto it = m_discovery.find(h.origin);
        if (it != m_discovery.end()) {
            it->second.timer.Cancel();
            m_discovery.erase(it);
        }
        return;
    }
    auto back = m_fantFrom.find(std::make_pair(h.target.Get(), h.seq));
    if (back == m_fantFrom.end() || h.ttl <= 1) {
        return;  // this node never relayed that FANT, or the BANT ran out of hops
    }
    h.hops = hops;
    h.ttl -= 1;
    Ptr<Packet> q = Create<Packet>();
    q->AddHeader(h);
    UnicastControl(q, back->second);
}

}  // namespace adaptive
}  // namespace ns3
