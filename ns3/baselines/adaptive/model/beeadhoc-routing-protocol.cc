// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "beeadhoc-routing-protocol.h"

#include "ns3/boolean.h"
#include "ns3/log.h"
#include "ns3/simulator.h"
#include "ns3/uinteger.h"

#include <algorithm>
#include <cmath>

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("BeeAdHocRoutingProtocol");

namespace adaptive {

namespace {

// The report's BeeAdHoc option has a 24-bit info field, 3 bits per hop
// (§12.1.2): at most eight intermediate values survive.
const uint32_t kInfoMask = 0xFFFFFFu;
const uint32_t kInfoSlots = 8;

void WriteU24(Buffer::Iterator& i, uint32_t v) {
    i.WriteU8(static_cast<uint8_t>((v >> 16) & 0xFF));
    i.WriteU8(static_cast<uint8_t>((v >> 8) & 0xFF));
    i.WriteU8(static_cast<uint8_t>(v & 0xFF));
}

uint32_t ReadU24(Buffer::Iterator& i) {
    uint32_t v = static_cast<uint32_t>(i.ReadU8()) << 16;
    v |= static_cast<uint32_t>(i.ReadU8()) << 8;
    v |= i.ReadU8();
    return v;
}

/// The per-intermediate values of a route with `hops` links, from the info
/// field (the last intermediate's value is in the lowest bits, §12.1.2).
std::vector<uint8_t> DecodeLevels(uint32_t info, size_t hops) {
    std::vector<uint8_t> out;
    const size_t n = std::min<size_t>(hops > 0 ? hops - 1 : 0, kInfoSlots);
    for (size_t k = 0; k < n; ++k) {
        out.push_back(static_cast<uint8_t>((info >> (3 * k)) & 7u));
    }
    return out;
}

uint32_t EncodeLevels(const std::vector<uint8_t>& levels) {
    uint32_t info = 0;
    for (uint8_t v : levels) {
        info = ((info << 3) | (v & 7u)) & kInfoMask;
    }
    return info;
}

}  // namespace

// --- BeeRouteTrailer ----------------------------------------------------------

NS_OBJECT_ENSURE_REGISTERED(BeeRouteTrailer);

TypeId BeeRouteTrailer::GetTypeId() {
    static TypeId tid = TypeId("ns3::adaptive::BeeRouteTrailer")
                            .SetParent<Trailer>()
                            .SetGroupName("Adaptive")
                            .AddConstructor<BeeRouteTrailer>();
    return tid;
}

TypeId BeeRouteTrailer::GetInstanceTypeId() const { return GetTypeId(); }

uint32_t BeeRouteTrailer::GetSerializedSize() const {
    return static_cast<uint32_t>(4 * path.size() + 3 + 4 * piggy.size() + 3 + 2);
}

void BeeRouteTrailer::Serialize(Buffer::Iterator end) const {
    Buffer::Iterator i = end;
    i.Prev(GetSerializedSize());
    for (const Ipv4Address& a : path) {
        i.WriteHtonU32(a.Get());
    }
    WriteU24(i, info);
    for (const Ipv4Address& a : piggy) {
        i.WriteHtonU32(a.Get());
    }
    WriteU24(i, piggyInfo);
    i.WriteU8(static_cast<uint8_t>(piggy.size()));
    i.WriteU8(static_cast<uint8_t>(path.size()));
}

uint32_t BeeRouteTrailer::Deserialize(Buffer::Iterator end) {
    Buffer::Iterator i = end;
    i.Prev(2);
    const uint8_t m = i.ReadU8();
    const uint8_t n = i.ReadU8();
    const uint32_t size = 4u * n + 3 + 4u * m + 3 + 2;
    i = end;
    i.Prev(size);
    path.clear();
    for (uint8_t k = 0; k < n; ++k) {
        path.emplace_back(i.ReadNtohU32());
    }
    info = ReadU24(i);
    piggy.clear();
    for (uint8_t k = 0; k < m; ++k) {
        piggy.emplace_back(i.ReadNtohU32());
    }
    piggyInfo = ReadU24(i);
    return size;
}

void BeeRouteTrailer::Print(std::ostream& os) const {
    os << "route";
    for (const Ipv4Address& a : path) {
        os << " " << a;
    }
    if (!piggy.empty()) {
        os << " +forager(" << piggy.size() << ")";
    }
}

// --- BeeRouteTag ----------------------------------------------------------------

NS_OBJECT_ENSURE_REGISTERED(BeeRouteTag);

TypeId BeeRouteTag::GetTypeId() {
    static TypeId tid = TypeId("ns3::adaptive::BeeRouteTag")
                            .SetParent<Tag>()
                            .SetGroupName("Adaptive")
                            .AddConstructor<BeeRouteTag>();
    return tid;
}

TypeId BeeRouteTag::GetInstanceTypeId() const { return GetTypeId(); }

// --- BeeControlHeader ---------------------------------------------------------

NS_OBJECT_ENSURE_REGISTERED(BeeControlHeader);

TypeId BeeControlHeader::GetTypeId() {
    static TypeId tid = TypeId("ns3::adaptive::BeeControlHeader")
                            .SetParent<Header>()
                            .SetGroupName("Adaptive")
                            .AddConstructor<BeeControlHeader>();
    return tid;
}

TypeId BeeControlHeader::GetInstanceTypeId() const { return GetTypeId(); }

uint32_t BeeControlHeader::GetSerializedSize() const {
    // type, ttl, id, src, dst, |path|, path, |levels|, levels, |cargo|
    uint32_t size = 1 + 1 + 4 + 4 + 4 + 1 + 4 * path.size() + 1 + levels.size() + 1;
    for (const Cargo& c : cargo) {
        size += 1 + 4 * c.path.size() + 1 + c.levels.size();
    }
    return size;
}

void BeeControlHeader::Serialize(Buffer::Iterator i) const {
    i.WriteU8(type);
    i.WriteU8(ttl);
    i.WriteHtonU32(id);
    i.WriteHtonU32(src.Get());
    i.WriteHtonU32(dst.Get());
    i.WriteU8(static_cast<uint8_t>(path.size()));
    for (const Ipv4Address& a : path) {
        i.WriteHtonU32(a.Get());
    }
    i.WriteU8(static_cast<uint8_t>(levels.size()));
    for (uint8_t v : levels) {
        i.WriteU8(v);
    }
    i.WriteU8(static_cast<uint8_t>(cargo.size()));
    for (const Cargo& c : cargo) {
        i.WriteU8(static_cast<uint8_t>(c.path.size()));
        for (const Ipv4Address& a : c.path) {
            i.WriteHtonU32(a.Get());
        }
        i.WriteU8(static_cast<uint8_t>(c.levels.size()));
        for (uint8_t v : c.levels) {
            i.WriteU8(v);
        }
    }
}

uint32_t BeeControlHeader::Deserialize(Buffer::Iterator start) {
    Buffer::Iterator i = start;
    type = i.ReadU8();
    ttl = i.ReadU8();
    id = i.ReadNtohU32();
    src = Ipv4Address(i.ReadNtohU32());
    dst = Ipv4Address(i.ReadNtohU32());
    path.assign(i.ReadU8(), Ipv4Address());
    for (Ipv4Address& a : path) {
        a = Ipv4Address(i.ReadNtohU32());
    }
    levels.assign(i.ReadU8(), 0);
    for (uint8_t& v : levels) {
        v = i.ReadU8();
    }
    cargo.assign(i.ReadU8(), Cargo());
    for (Cargo& c : cargo) {
        c.path.assign(i.ReadU8(), Ipv4Address());
        for (Ipv4Address& a : c.path) {
            a = Ipv4Address(i.ReadNtohU32());
        }
        c.levels.assign(i.ReadU8(), 0);
        for (uint8_t& v : c.levels) {
            v = i.ReadU8();
        }
    }
    return i.GetDistanceFrom(start);
}

void BeeControlHeader::Print(std::ostream& os) const {
    os << "bee type=" << static_cast<int>(type) << " id=" << id << " " << src << "->" << dst
       << " hops=" << path.size() << " cargo=" << cargo.size();
}

// --- BeeAdHocRoutingProtocol ----------------------------------------------------

NS_OBJECT_ENSURE_REGISTERED(BeeAdHocRoutingProtocol);

TypeId BeeAdHocRoutingProtocol::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::adaptive::BeeAdHocRoutingProtocol")
            .SetParent<RoutingBase>()
            .SetGroupName("Adaptive")
            .AddConstructor<BeeAdHocRoutingProtocol>()
            .AddAttribute("ForagerLifetime",
                          "Age after which a forager is discarded unless it is the last "
                          "(PG 460 §14.3.2: IPT_BEEADHOC_FORAGER_LIFETIME 2).",
                          TimeValue(Seconds(2)),
                          MakeTimeAccessor(&BeeAdHocRoutingProtocol::m_foragerLifetime),
                          MakeTimeChecker())
            .AddAttribute("DanceTime",
                          "Age below which a forager with dances left recruits instead of "
                          "being used up (IPT_BEEADHOC_FORAGER_DANCETIME 2).",
                          TimeValue(Seconds(2)),
                          MakeTimeAccessor(&BeeAdHocRoutingProtocol::m_danceTime),
                          MakeTimeChecker())
            .AddAttribute("MaxDances",
                          "Dances of a forager on a direct link, and the cap of the "
                          "rating (IPT_BEEADHOC_MAX_DANCES 8).",
                          UintegerValue(8),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_maxDances),
                          MakeUintegerChecker<uint32_t>())
            .AddAttribute("CapDances",
                          "Cap the Listing 13.15 rating at MaxDances. The listing does not; "
                          "the cap is a repository reading (#807), false for the #806 "
                          "sensitivity.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&BeeAdHocRoutingProtocol::m_capDances),
                          MakeBooleanChecker())
            .AddAttribute("RemoveForagersOnLinkFailure",
                          "Drop every forager over a link the MAC reports failed. Not in the "
                          "report (repository choice); false for the #806 sensitivity.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&BeeAdHocRoutingProtocol::m_removeOnLinkFailure),
                          MakeBooleanChecker())
            .AddAttribute("MaxHops", "Longest route (§12.1.2: the IP option space allows 10 hops).",
                          UintegerValue(10),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_maxHops),
                          MakeUintegerChecker<uint32_t>(1, 40))
            .AddAttribute("ForagerArraySize",
                          "Foragers kept per destination and kind (own/foreign); the report "
                          "names IPT_BEEADHOC_ARRAYSIZE without a value. Repository choice.",
                          UintegerValue(64),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_arraySize),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("SwarmSize",
                          "Foragers a swarm carries; a swarm leaves when more than this many "
                          "foreign foragers wait (IPT_BEEADHOC_SWARMSIZE 20).",
                          UintegerValue(20),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_swarmSize),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("SwarmSizeOwn",
                          "A swarm leaves only while fewer own foragers than this exist "
                          "(IPT_BEEADHOC_SWARMSIZE_OWN 11).",
                          UintegerValue(11),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_swarmSizeOwn),
                          MakeUintegerChecker<uint32_t>())
            .AddAttribute("ScoutResendInterval",
                          "Wait for a scout to return before the next, wider one "
                          "(SCOUTRESENDRATE 500, in jiffies of a HZ=1000 kernel: 500 ms).",
                          TimeValue(MilliSeconds(500)),
                          MakeTimeAccessor(&BeeAdHocRoutingProtocol::m_scoutResend),
                          MakeTimeChecker())
            .AddAttribute("ScoutListLength", "Entries of the scout seen list (SCOUTLISTLENGTH 30).",
                          UintegerValue(30),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_scoutListLength),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("InitialScoutTtl",
                          "TTL of the first scout of an expanding ring search; the report gives "
                          "none. Repository choice; each resend doubles it up to MaxHops.",
                          UintegerValue(2),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_initialScoutTtl),
                          MakeUintegerChecker<uint8_t>(1))
            .AddAttribute("MaxRoundsAtMaxTtl",
                          "Scouts sent at the full TTL before the held packets are dropped; "
                          "the report gives no limit. Repository choice.",
                          UintegerValue(2),
                          MakeUintegerAccessor(&BeeAdHocRoutingProtocol::m_maxRoundsAtMaxTtl),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("ScoutJitter",
                          "Random delay before a scout is rebroadcast (§3.4 adds one to stop "
                          "synchronised collisions; no value given). Repository choice.",
                          TimeValue(MilliSeconds(10)),
                          MakeTimeAccessor(&BeeAdHocRoutingProtocol::m_scoutJitter),
                          MakeTimeChecker());
    return tid;
}

BeeAdHocRoutingProtocol::BeeAdHocRoutingProtocol()
    : m_configured(false),
      m_foragerLifetime(Seconds(2)),
      m_danceTime(Seconds(2)),
      m_maxDances(8),
      m_capDances(true),
      m_removeOnLinkFailure(true),
      m_maxHops(10),
      m_arraySize(64),
      m_swarmSize(20),
      m_swarmSizeOwn(11),
      m_scoutResend(MilliSeconds(500)),
      m_scoutListLength(30),
      m_initialScoutTtl(2),
      m_maxRoundsAtMaxTtl(2),
      m_scoutJitter(MilliSeconds(10)),
      m_inRouteOutput(false),
      m_scoutId(0),
      m_scoutsSent(0),
      m_swarmsSent(0),
      m_routeBytesSent(0) {}

BeeAdHocRoutingProtocol::~BeeAdHocRoutingProtocol() = default;

void BeeAdHocRoutingProtocol::DoDispose() {
    for (auto& kv : m_pending) {
        kv.second.timer.Cancel();
    }
    m_pending.clear();
    RoutingBase::DoDispose();
}

double BeeAdHocRoutingProtocol::Now() const { return Simulator::Now().GetSeconds(); }

void BeeAdHocRoutingProtocol::Configure() {
    if (!m_configured) {
        m_store.Configure(m_arraySize, m_foragerLifetime.GetSeconds(), m_danceTime.GetSeconds(),
                          m_maxHops, m_maxDances, m_capDances);
        m_configured = true;
    }
}

uint8_t BeeAdHocRoutingProtocol::HopLevel() const {
    // The Linux module reports the remaining battery, mapped to 0..7
    // (Listing 13.7). The battery is the harness's energy accounting (#801);
    // without it (no probe, or --energyJ=0) the node reports a full battery.
    if (m_energyProbe.IsNull()) {
        return 7;
    }
    const double f = m_energyProbe();
    return std::isnan(f) ? 7 : BeeBatteryLevel(100.0 * f);
}

void BeeAdHocRoutingProtocol::Heard(Ipv4Address neighbor) {
    if (neighbor != Ipv4Address() && !IsMyAddress(neighbor)) {
        m_neighbors[neighbor] = Simulator::Now();
        m_failed.erase(neighbor);
    }
}

bool BeeAdHocRoutingProtocol::Failed(Ipv4Address neighbor) const {
    auto it = m_failed.find(neighbor);
    return it != m_failed.end() && it->second > Simulator::Now();
}

Ipv4Address BeeAdHocRoutingProtocol::NextOnPath(const std::vector<Ipv4Address>& path) const {
    for (size_t k = 0; k + 1 < path.size(); ++k) {
        if (IsMyAddress(path[k])) {
            return path[k + 1];
        }
    }
    return Ipv4Address();
}

Ipv4Address BeeAdHocRoutingProtocol::PrevOnPath(const std::vector<Ipv4Address>& path) const {
    for (size_t k = 1; k < path.size(); ++k) {
        if (IsMyAddress(path[k])) {
            return path[k - 1];
        }
    }
    return Ipv4Address();
}

Ipv4Address BeeAdHocRoutingProtocol::Originate(Ipv4Address dst, Ptr<const Packet> p) {
    Configure();
    Forager f;
    auto pick = [this](uint32_t n) { return Rng()->GetInteger(0, n - 1); };
    while (m_store.Take(dst, Now(), pick, f)) {
        if (f.path.size() >= 2 && !Failed(f.path[1])) {
            break;
        }
        f.path.clear();
    }
    if (f.path.size() < 2) {
        return Ipv4Address();
    }
    if (p) {
        BeeRouteTrailer t;
        t.path = f.path;
        // §13.7.1: a node sends its 'foreign' foragers for this destination
        // home with its own traffic, one per packet.
        std::vector<Forager> home = m_store.TakeForeign(dst, 1);
        if (!home.empty()) {
            t.piggy = home.front().path;
            t.piggyInfo = EncodeLevels(home.front().levels);
        }
        // The packet's bytes are ours here: RouteOutput's packet, or one held
        // in the base's queue, before the forwarding copy is taken.
        Ptr<Packet> q = ConstCast<Packet>(p);
        q->AddTrailer(t);
        BeeRouteTag mark;
        if (!q->PeekPacketTag(mark)) {
            q->AddPacketTag(mark);
        }
    }
    return f.path[1];
}

Ipv4Address BeeAdHocRoutingProtocol::SelectNextHop(Ipv4Address dst, Ipv4Address src,
                                                   Ipv4Address prev, Ptr<const Packet> p) {
    BeeRouteTag mark;
    BeeRouteTrailer t;
    const bool routed = p && p->PeekPacketTag(mark) && ConstCast<Packet>(p)->PeekTrailer(t) > 0 &&
                        t.path.size() >= 2 && t.path.back() == dst;
    if (!routed) {
        // In RouteOutput the packet is the application's own: a trailer added
        // to it would change the size the socket reports back, and ns-3's
        // OnOffApplication then treats the send as failed and sends the same
        // packet again (duplicate deliveries, #800). Defer it: the base loops
        // it back, and the route is attached to IP's own copy when it leaves
        // the hold queue (StartDiscovery flushes at once if a forager exists).
        if (m_inRouteOutput) {
            return Ipv4Address();
        }
        return IsMyAddress(src) ? Originate(dst, p) : Ipv4Address();
    }
    const Ipv4Address next = NextOnPath(t.path);
    if (next != Ipv4Address() && !Failed(next)) {
        return next;
    }
    if (IsMyAddress(t.path.front())) {
        // A packet of ours whose first link failed (recovered from the MAC):
        // the source picks another route.
        Ptr<Packet> q = ConstCast<Packet>(p);
        q->RemoveTrailer(t);
        q->RemovePacketTag(mark);
        return Originate(dst, p);
    }
    return Ipv4Address();
}

bool BeeAdHocRoutingProtocol::OnDataReceived(Ptr<const Packet> p, const Ipv4Header& header,
                                             Ipv4Address prev, bool) {
    Configure();
    Heard(prev);
    BeeRouteTag mark;
    if (!p->PeekPacketTag(mark)) {
        return true;
    }
    if (!IsMyAddress(header.GetDestination())) {
        // An intermediate hop: write this node's value into the info field
        // (FORWARD chain, Listing 13.7).
        BeeRouteTrailer t;
        if (ConstCast<Packet>(p)->RemoveTrailer(t) > 0) {
            t.info = ((t.info << 3) | HopLevel()) & kInfoMask;
            ConstCast<Packet>(p)->AddTrailer(t);
        }
        return true;
    }
    // The destination: the route ends here; strip it before local delivery.
    BeeRouteTrailer t;
    Ptr<Packet> q = ConstCast<Packet>(p);
    q->RemovePacketTag(mark);
    if (q->RemoveTrailer(t) == 0 || t.path.size() < 2) {
        return true;
    }
    const Ipv4Address source = header.GetSource();
    // INPUT chain (§12.1.3): every delivered packet is a forager that can find
    // its way back to the source; it waits here as a 'foreign' forager.
    Forager back;
    back.path.assign(t.path.rbegin(), t.path.rend());
    back.levels = DecodeLevels(t.info, t.path.size() - 1);
    m_store.Put(source, back, true, Now());
    // A forager of ours that came home on this packet becomes 'own' again.
    if (t.piggy.size() >= 2 && IsMyAddress(t.piggy.back())) {
        Forager mine;
        mine.path.assign(t.piggy.rbegin(), t.piggy.rend());
        mine.levels = DecodeLevels(t.piggyInfo, t.piggy.size() - 1);
        m_store.Put(source, mine, false, Now());
        FlushQueue(source);
    }
    MaybeSwarm(source);
    return true;
}

void BeeAdHocRoutingProtocol::OnDataForwarded(Ptr<const Packet> p, const Ipv4Header& header,
                                              Ipv4Address) {
    // A packet held in the queue, or recovered from the MAC at its source,
    // gets (or changes) its route after its IP header was built: the header's
    // payload length must follow, or the next hop trims the trailer off as
    // frame padding. The header is the base's own copy (the queue entry, the
    // recovered packet's), about to be used for this transmission.
    BeeRouteTag mark;
    if (!p || !p->PeekPacketTag(mark)) {
        return;
    }
    if (IsMyAddress(header.GetSource())) {
        const_cast<Ipv4Header&>(header).SetPayloadSize(static_cast<uint16_t>(p->GetSize()));
    }
    // #808: this transmission carries the route trailer's bytes.
    BeeRouteTrailer t;
    m_routeBytesSent += ConstCast<Packet>(p)->PeekTrailer(t);
}

bool BeeAdHocRoutingProtocol::OnNoRouteInTransit(Ptr<const Packet> p, const Ipv4Header& header,
                                                 Ipv4Address, UnicastForwardCallback,
                                                 ErrorCallback ecb) {
    // Source routing: an intermediate node has no route of its own to offer.
    // The packet is lost, booked as a route drop.
    if (!ecb.IsNull()) {
        ecb(p, header, Socket::ERROR_NOROUTETOHOST);
    }
    return true;
}

void BeeAdHocRoutingProtocol::MaybeSwarm(Ipv4Address source) {
    // Listing 13.30: more than SWARMSIZE foreign foragers and fewer than
    // SWARMSIZE_OWN own ones for this source: the flow looks one-way.
    if (m_store.Count(source, true) <= m_swarmSize ||
        m_store.Count(source, false) >= m_swarmSizeOwn) {
        return;
    }
    std::vector<Forager> bees = m_store.TakeForeign(source, m_swarmSize);
    if (bees.empty()) {
        return;
    }
    BeeControlHeader h;
    h.type = BeeControlHeader::SWARM;
    h.src = MainAddress();
    h.dst = source;
    h.path = bees.front().path;  // this node .. the source
    for (const Forager& f : bees) {
        h.cargo.push_back({f.path, f.levels});
    }
    const Ipv4Address next = NextOnPath(h.path);
    if (next == Ipv4Address() || Failed(next)) {
        return;
    }
    Ptr<Packet> q = Create<Packet>();
    q->AddHeader(h);
    UnicastControl(q, next);
    ++m_swarmsSent;
}

Ptr<Ipv4Route> BeeAdHocRoutingProtocol::RouteOutput(Ptr<Packet> p, const Ipv4Header& header,
                                                    Ptr<NetDevice> oif,
                                                    Socket::SocketErrno& sockerr) {
    m_inRouteOutput = true;
    Ptr<Ipv4Route> route = RoutingBase::RouteOutput(p, header, oif, sockerr);
    m_inRouteOutput = false;
    return route;
}

void BeeAdHocRoutingProtocol::StartDiscovery(Ipv4Address dst) {
    // A packet of ours just came back through loopback: if a forager exists,
    // it leaves now; otherwise it waits for a scout.
    Configure();
    if (m_store.Count(dst, false) + m_store.Count(dst, true) > 0) {
        FlushQueue(dst);
        if (!HasQueued(dst)) {
            return;
        }
    }
    if (m_pending.count(dst)) {
        return;  // a scout is already out (§12.1.3)
    }
    PendingScout& s = m_pending[dst];
    s.ttl = m_initialScoutTtl;
    SendScout(dst);
}

void BeeAdHocRoutingProtocol::SendScout(Ipv4Address dst) {
    PendingScout& s = m_pending[dst];
    BeeControlHeader h;
    h.type = BeeControlHeader::SCOUT_OUT;
    h.ttl = s.ttl;
    h.id = ++m_scoutId;
    h.src = MainAddress();
    h.dst = dst;
    h.path.push_back(MainAddress());
    m_seen.emplace_back(h.src, h.dst, h.id);
    while (m_seen.size() > m_scoutListLength) {
        m_seen.pop_front();
    }
    Ptr<Packet> q = Create<Packet>();
    q->AddHeader(h);
    BroadcastControl(q);
    ++m_scoutsSent;
    s.timer = Simulator::Schedule(m_scoutResend, &BeeAdHocRoutingProtocol::ScoutTimeout, this, dst);
}

void BeeAdHocRoutingProtocol::ScoutTimeout(Ipv4Address dst) {
    auto it = m_pending.find(dst);
    if (it == m_pending.end()) {
        return;
    }
    if (!HasQueued(dst)) {
        m_pending.erase(it);
        return;
    }
    // Expanding ring search (§13.5): the next scout reaches further.
    PendingScout& s = it->second;
    if (s.ttl >= m_maxHops) {
        if (++s.roundsAtMax >= m_maxRoundsAtMaxTtl) {
            m_pending.erase(it);
            DropQueued(dst);
            return;
        }
    }
    s.ttl = static_cast<uint8_t>(std::min<uint32_t>(2u * s.ttl, m_maxHops));
    SendScout(dst);
}

void BeeAdHocRoutingProtocol::RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address) {
    Configure();
    BeeControlHeader h;
    if (p->GetSize() < 16) {
        return;
    }
    p->RemoveHeader(h);
    Heard(from);
    const Ipv4Address me = MainAddress();

    if (h.type == BeeControlHeader::SCOUT_OUT) {
        if (IsMyAddress(h.src) || h.path.empty()) {
            return;
        }
        const auto key = std::make_tuple(h.src, h.dst, h.id);
        if (std::find(m_seen.begin(), m_seen.end(), key) != m_seen.end()) {
            return;  // seen list (§13.5): each scout passes a node once
        }
        m_seen.push_back(key);
        while (m_seen.size() > m_scoutListLength) {
            m_seen.pop_front();
        }
        if (IsMyAddress(h.dst)) {
            // At the destination: the route is reversed and the scout flies
            // back hop by hop (mode 2).
            h.path.push_back(me);
            h.type = BeeControlHeader::SCOUT_BACK;
            const Ipv4Address back = h.path[h.path.size() - 2];
            Ptr<Packet> q = Create<Packet>();
            q->AddHeader(h);
            UnicastControl(q, back);
            return;
        }
        if (h.ttl <= 1 || h.path.size() >= m_maxHops) {
            return;
        }
        h.ttl--;
        h.path.push_back(me);
        h.levels.push_back(HopLevel());
        Ptr<Packet> q = Create<Packet>();
        q->AddHeader(h);
        BroadcastControlJittered(q, m_scoutJitter);
        return;
    }

    if (h.type == BeeControlHeader::SCOUT_BACK) {
        if (h.path.size() < 2) {
            return;
        }
        if (IsMyAddress(h.path.front())) {
            // Home: the scout becomes a forager (§13.5, makeforager).
            Forager f;
            f.path = h.path;
            f.levels = h.levels;
            m_store.Put(h.dst, f, false, Now());
            auto it = m_pending.find(h.dst);
            if (it != m_pending.end()) {
                it->second.timer.Cancel();
                m_pending.erase(it);
            }
            FlushQueue(h.dst);
            return;
        }
        const Ipv4Address back = PrevOnPath(h.path);
        if (back == Ipv4Address()) {
            return;
        }
        Ptr<Packet> q = Create<Packet>();
        q->AddHeader(h);
        UnicastControl(q, back);
        return;
    }

    if (h.type == BeeControlHeader::SWARM) {
        if (h.path.empty()) {
            return;
        }
        if (IsMyAddress(h.path.back())) {
            // Unpacked at home (§13.7.3): each forager is 'own' again, its
            // route reversed to lead from here to the swarm's sender.
            for (const BeeControlHeader::Cargo& c : h.cargo) {
                if (c.path.size() < 2) {
                    continue;
                }
                Forager f;
                f.path.assign(c.path.rbegin(), c.path.rend());
                f.levels.assign(c.levels.rbegin(), c.levels.rend());
                m_store.Put(h.src, f, false, Now());
            }
            FlushQueue(h.src);
            return;
        }
        const Ipv4Address next = NextOnPath(h.path);
        if (next == Ipv4Address() || Failed(next)) {
            return;
        }
        Ptr<Packet> q = Create<Packet>();
        q->AddHeader(h);
        UnicastControl(q, next);
    }
}

void BeeAdHocRoutingProtocol::OnLinkFailure(Ipv4Address neighbor) {
    Configure();
    m_neighbors.erase(neighbor);
    m_failed[neighbor] = Simulator::Now() + m_foragerLifetime;
    if (m_removeOnLinkFailure) {
        m_store.RemoveLink(MainAddress(), neighbor);
    }
}

std::set<Ipv4Address> BeeAdHocRoutingProtocol::KnownNeighbors() const {
    std::set<Ipv4Address> out = m_store.FirstHops();
    for (const auto& kv : m_neighbors) {
        out.insert(kv.first);
    }
    return out;
}

}  // namespace adaptive
}  // namespace ns3
