// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * BeeAdHoc (Wedde, Farooq et al., GECCO 2005), the v2.7.0 comparator arm
 * (#589), written from the authors' group's Project Group 460 final report
 * (University of Dortmund, 2006, hdl 2003/22405): the Linux kernel module of
 * chapters 12-13, the most completely specified of the report's versions. The
 * GECCO paper itself was not available; README.md has the fidelity sheet.
 *
 * - Source routing (§12.1.2): every data packet carries its whole route,
 *   chosen at the source; intermediate nodes only follow it. A packet whose
 *   next link has failed is dropped (no salvage in the report).
 * - Foragers (§13.3, Listings 13.15-13.17): per destination a node keeps
 *   'own' foragers (routes it may use) and 'foreign' ones (routes back to a
 *   node that sent it data); every delivered data packet becomes a foreign
 *   forager at its destination. A packet takes a random forager: one still
 *   dancing (dances left, younger than the dance time) is copied, otherwise
 *   it is used up; one older than the forager lifetime is discarded unless it
 *   is the last. Own foragers are used first.
 * - Foragers return home (§13.7): piggybacked, one per data packet, on
 *   traffic toward their owner, or, when the flow is one-way, in a swarm:
 *   more than SwarmSize foreign foragers and fewer than SwarmSizeOwn own ones
 *   for a source send SwarmSize of them back in one source-routed packet.
 * - Scouts (§13.5): a source with no forager broadcasts a scout with a small
 *   TTL; each node appends itself and rebroadcasts it once (seen list); the
 *   destination reverses the route and unicasts the scout back hop by hop;
 *   the source turns it into a forager. No scout back within the resend
 *   interval: another scout with a larger TTL (expanding ring search).
 */
#ifndef BEEADHOC_ROUTING_PROTOCOL_H
#define BEEADHOC_ROUTING_PROTOCOL_H

#include "adaptive-routing-base.h"
#include "adaptive-tables.h"

#include "ns3/callback.h"
#include "ns3/event-id.h"
#include "ns3/header.h"
#include "ns3/trailer.h"

#include <deque>
#include <map>
#include <tuple>
#include <vector>

namespace ns3 {
namespace adaptive {

/**
 * The source route a BeeAdHoc data packet carries (the report's strict source
 * route IP option plus its 5-byte BeeAdHoc option, §12.1.2), with the one
 * forager it may piggyback home (§13.7.1). It rides as a trailer so the
 * application's header stays first (the harness classifies flows on it); the
 * destination strips it before local delivery. Its bytes are on the air.
 *
 *   path      4 bytes per node, source .. destination
 *   info      3 bytes, 3 bits per intermediate hop (§12.1.2)
 *   piggy     4 bytes per node of the piggybacked forager's route
 *   pinfo     3 bytes
 *   m         u8  nodes in piggy
 *   n         u8  nodes in path
 */
class BeeRouteTrailer : public Trailer {
public:
    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;
    uint32_t GetSerializedSize() const override;
    void Serialize(Buffer::Iterator end) const override;
    uint32_t Deserialize(Buffer::Iterator end) override;
    void Print(std::ostream& os) const override;

    std::vector<Ipv4Address> path;
    uint32_t info = 0;
    std::vector<Ipv4Address> piggy;
    uint32_t piggyInfo = 0;
};

/**
 * Marks a packet that carries a BeeRouteTrailer. A trailer is read from the
 * end of the packet, so it can only be parsed when it is known to be there;
 * the mark is simulator metadata and adds no bytes.
 */
class BeeRouteTag : public Tag {
public:
    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;
    uint32_t GetSerializedSize() const override { return 0; }
    void Serialize(TagBuffer) const override {}
    void Deserialize(TagBuffer) override {}
    void Print(std::ostream& os) const override { os << "bee-routed"; }
};

/**
 * BeeAdHoc's scout and swarm packets (§13.5, Listings 13.21 and 13.31): a
 * route under construction or to follow, one 3-bit value per intermediate
 * node, and a swarm's cargo of foragers.
 */
class BeeControlHeader : public Header {
public:
    enum Type : uint8_t {
        SCOUT_OUT = 1,   ///< flooding toward the destination (mode 1)
        SCOUT_BACK = 2,  ///< unicast back along the reversed route (mode 2)
        SWARM = 3,       ///< foragers returning home in one packet
    };

    struct Cargo {
        std::vector<Ipv4Address> path;
        std::vector<uint8_t> levels;
    };

    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;
    uint32_t GetSerializedSize() const override;
    void Serialize(Buffer::Iterator start) const override;
    uint32_t Deserialize(Buffer::Iterator start) override;
    void Print(std::ostream& os) const override;

    uint8_t type = SCOUT_OUT;
    uint8_t ttl = 0;
    uint32_t id = 0;
    Ipv4Address src;
    Ipv4Address dst;
    std::vector<Ipv4Address> path;
    std::vector<uint8_t> levels;
    std::vector<Cargo> cargo;
};

class BeeAdHocRoutingProtocol : public RoutingBase {
public:
    static TypeId GetTypeId();
    BeeAdHocRoutingProtocol();
    ~BeeAdHocRoutingProtocol() override;

    static const uint16_t BEEADHOC_PORT = 5544;

    // A packet this node originates is never routed here: the base bounces it
    // through loopback and it leaves from the hold queue (see the .cc).
    Ptr<Ipv4Route> RouteOutput(Ptr<Packet> p, const Ipv4Header& header, Ptr<NetDevice> oif,
                               Socket::SocketErrno& sockerr) override;

    uint64_t ScoutsSent() const { return m_scoutsSent; }

    uint64_t SwarmsSent() const { return m_swarmsSent; }

    /// Route-trailer bytes this node put on the air with data packets, one
    /// count per transmission (the source's and every forwarding hop's): the
    /// in-packet routing overhead that nrl_bytes does not see (#808).
    uint64_t RouteBytesSent() const { return m_routeBytesSent; }

    /// The node's residual battery fraction (0..1), from the harness's energy
    /// accounting (#801). Unset, or NaN: the node reports a full battery.
    void SetEnergyProbe(Callback<double> probe) { m_energyProbe = probe; }

protected:
    void DoDispose() override;

    uint16_t ControlPort() const override { return BEEADHOC_PORT; }

    Ipv4Address SelectNextHop(Ipv4Address dst, Ipv4Address src, Ipv4Address prev,
                              Ptr<const Packet> p) override;
    bool OnDataReceived(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address prev,
                        bool backtracked) override;
    void OnDataForwarded(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address next) override;
    bool OnNoRouteInTransit(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address prev,
                            UnicastForwardCallback ucb, ErrorCallback ecb) override;
    void StartDiscovery(Ipv4Address dst) override;
    void RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address receiver) override;
    void OnLinkFailure(Ipv4Address neighbor) override;
    std::set<Ipv4Address> KnownNeighbors() const override;

private:
    typedef ForagerStore<Ipv4Address>::Forager Forager;

    double Now() const;
    void Configure();
    /// The 3-bit value this node reports for itself as an intermediate hop.
    uint8_t HopLevel() const;
    /// Choose a forager for a packet this node originates and attach its route.
    Ipv4Address Originate(Ipv4Address dst, Ptr<const Packet> p);
    void SendScout(Ipv4Address dst);
    void ScoutTimeout(Ipv4Address dst);
    void MaybeSwarm(Ipv4Address source);
    void Heard(Ipv4Address neighbor);
    bool Failed(Ipv4Address neighbor) const;
    /// The node after this one on `path`, or Ipv4Address().
    Ipv4Address NextOnPath(const std::vector<Ipv4Address>& path) const;
    /// The node before this one on `path`, or Ipv4Address().
    Ipv4Address PrevOnPath(const std::vector<Ipv4Address>& path) const;

    struct PendingScout {
        EventId timer;
        uint8_t ttl = 0;
        uint32_t roundsAtMax = 0;
    };

    ForagerStore<Ipv4Address> m_store;
    bool m_configured;
    Time m_foragerLifetime;
    Time m_danceTime;
    uint32_t m_maxDances;
    bool m_capDances;
    bool m_removeOnLinkFailure;
    uint32_t m_maxHops;
    uint32_t m_arraySize;
    uint32_t m_swarmSize;
    uint32_t m_swarmSizeOwn;
    Time m_scoutResend;
    uint32_t m_scoutListLength;
    uint8_t m_initialScoutTtl;
    uint32_t m_maxRoundsAtMaxTtl;
    Time m_scoutJitter;

    std::map<Ipv4Address, PendingScout> m_pending;
    std::deque<std::tuple<Ipv4Address, Ipv4Address, uint32_t>> m_seen;  // (src, dst, id)
    std::map<Ipv4Address, Time> m_neighbors;                            // last heard
    std::map<Ipv4Address, Time> m_failed;                               // link down until
    Callback<double> m_energyProbe;
    bool m_inRouteOutput;
    uint32_t m_scoutId;
    uint64_t m_scoutsSent;
    uint64_t m_swarmsSent;
    uint64_t m_routeBytesSent;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // BEEADHOC_ROUTING_PROTOCOL_H
