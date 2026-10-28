// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * ARA, the Ant-Colony-Based Routing Algorithm (Güneş, Sorges, Bouazizi,
 * IWAHN 2002), written from the paper for the v2.5.0 swarm comparator (#586).
 *
 * Purely reactive ACO. Section references are to the paper:
 *
 * - §3.1 route discovery: a forward ant (FANT) is flooded from the source;
 *   a node seeing it for the first time records pheromone toward the source
 *   over the neighbour it came from, valued by the hops it travelled.
 *   Duplicate FANTs are destroyed. The destination answers with a backward
 *   ant (BANT) that lays the trail toward the destination the same way; per
 *   Fig. 3 it can lay more than one (duplicates update, are not relayed).
 * - §3.2 route maintenance: data packets are the only maintenance traffic.
 *   Relaying a packet for D to neighbour j adds Delta to (D, j); the receiver
 *   adds Delta to (S, previous hop). Pheromone evaporates (eq. 2). A node
 *   that receives a data packet it already relayed sends it back with the
 *   DUPLICATE_ERROR flag; the previous node then stops using that link.
 * - §3.3 route failure: a missing MAC acknowledgement deactivates the link
 *   (pheromone 0), the packet goes on an alternative link, or else back to
 *   the previous node, backtracking toward the source, which re-discovers.
 * - next hop: drawn with probability proportional to pheromone (§2.2, §3.4).
 *
 * The paper gives no numeric value for Delta, q, the evaporation period, the
 * initial-pheromone function or the expiry threshold; every one is an
 * attribute here and a declared deviation in ns3/baselines/adaptive/README.md.
 */
#ifndef ARA_ROUTING_PROTOCOL_H
#define ARA_ROUTING_PROTOCOL_H

#include "adaptive-routing-base.h"
#include "adaptive-tables.h"

#include "ns3/event-id.h"

#include <map>
#include <tuple>

namespace ns3 {
namespace adaptive {

class AraRoutingProtocol : public RoutingBase {
public:
    static TypeId GetTypeId();
    AraRoutingProtocol();
    ~AraRoutingProtocol() override;

    static const uint16_t ARA_PORT = 5541;

    /// Discovery tallies for the harness's --diag line.
    uint64_t FantsSent() const { return m_fantsSent; }

    uint64_t DuplicateErrors() const { return m_duplicateErrors; }

    uint64_t Backtracks() const { return m_backtracks; }

protected:
    void DoInitialize() override;
    void DoDispose() override;

    uint16_t ControlPort() const override { return ARA_PORT; }

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
    using DataKey = std::tuple<uint32_t, uint32_t, uint16_t>;  // src, dst, IP id

    double Now() const;
    double InitialPheromone(uint8_t hops) const;
    void SendFant(Ipv4Address dst);
    void DiscoveryTimeout(Ipv4Address dst);
    bool SeenAnt(Ipv4Address origin, uint32_t seq, uint8_t type);
    bool SeenData(const DataKey& key);
    void PurgeSeen();

    PheromoneTable<Ipv4Address> m_table;
    double m_delta;
    double m_evaporation;
    Time m_evaporationPeriod;
    double m_floor;
    uint8_t m_antTtl;
    Time m_discoveryTimeout;
    uint32_t m_discoveryRetries;
    Time m_floodJitter;

    struct Discovery {
        uint32_t attempts = 0;
        EventId timer;
    };

    std::map<Ipv4Address, Discovery> m_discovery;
    uint32_t m_seq;
    std::map<std::tuple<uint32_t, uint32_t, uint8_t>, Time> m_seenAnts;
    std::map<DataKey, Time> m_seenData;
    std::map<std::pair<uint32_t, uint32_t>, uint8_t> m_bantHops;  // (origin, seq) -> first hops
    Time m_seenLifetime;
    EventId m_purge;
    uint64_t m_fantsSent;
    uint64_t m_duplicateErrors;
    uint64_t m_backtracks;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // ARA_ROUTING_PROTOCOL_H
