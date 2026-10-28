// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Termite (Roth & Wicker, GLOBECOM 2003; Roth's 2005 Cornell dissertation),
 * written from the dissertation-defence slides for the v2.5.0 stigmergic
 * comparator (#587). The GLOBECOM paper and the dissertation could not be
 * obtained (#587); what the slides specify is implemented as written, and
 * every constant they leave open is an attribute and a declared deviation in
 * ns3/baselines/adaptive/README.md.
 *
 * - Pheromone update: every packet that arrives at node i from previous hop r
 *   with source s adds gamma to P(r, s), data and control alike. Routing
 *   state rides on the traffic itself; there is no periodic control.
 * - Continuous decay: P <- P e^{-(t - t_last) tau}.
 * - Forwarding equation: p(n, d) = (P(n, d) + K)^F / sum_j (P(j, d) + K)^F
 *   over the neighbours, never straight back to the previous hop.
 * - Route discovery: a route request (RREQ) makes a random walk, not a
 *   flood, until it reaches the destination or a node with pheromone for it;
 *   the route reply (RREP) is routed to the requester by the forwarding
 *   equation, like data.
 * - Route repair: a lost neighbour is removed from the table and the packet
 *   is resent on a remaining link.
 * - Neighbours are gained by overhearing transmissions (promiscuous
 *   reception). A node that transmitted nothing for a HelloInterval sends a
 *   hello, so a silent destination stays known (a declared addition).
 */
#ifndef TERMITE_ROUTING_PROTOCOL_H
#define TERMITE_ROUTING_PROTOCOL_H

#include "adaptive-routing-base.h"
#include "adaptive-tables.h"

#include "ns3/event-id.h"

#include <map>

namespace ns3 {
namespace adaptive {

class TermiteRoutingProtocol : public RoutingBase {
public:
    static TypeId GetTypeId();
    TermiteRoutingProtocol();
    ~TermiteRoutingProtocol() override;

    static const uint16_t TERMITE_PORT = 5542;

    uint64_t RreqsSent() const { return m_rreqsSent; }

    uint64_t Overheard() const { return m_overheard; }

protected:
    void DoInitialize() override;
    void DoDispose() override;

    uint16_t ControlPort() const override { return TERMITE_PORT; }

    Ipv4Address SelectNextHop(Ipv4Address dst, Ipv4Address src, Ipv4Address prev,
                              Ptr<const Packet> p) override;
    bool OnDataReceived(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address prev,
                        bool backtracked) override;
    void OnDataForwarded(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address next) override;
    void StartDiscovery(Ipv4Address dst) override;
    void RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address receiver) override;
    void OnLinkFailure(Ipv4Address neighbor) override;
    std::set<Ipv4Address> KnownNeighbors() const override;

private:
    double Now() const;
    /// A packet from `source` arrived over the link from `neighbor`.
    void Learn(Ipv4Address neighbor, Ipv4Address source);
    std::vector<Ipv4Address> LiveNeighbors();
    Ipv4Address RandomNeighbor(Ipv4Address exclude);
    void SendRreq(Ipv4Address dst);
    void DiscoveryTimeout(Ipv4Address dst);
    void HelloTimer();
    void SendControl(Ptr<Packet> p, Ipv4Address next);
    void Overhear(Ptr<NetDevice> device, Ptr<const Packet> packet, uint16_t protocol,
                  const Address& from, const Address& to, NetDevice::PacketType type);

    PheromoneTable<Ipv4Address> m_table;
    double m_gamma;
    double m_decay;
    double m_k;
    double m_f;
    double m_floor;
    Time m_helloInterval;
    Time m_neighborTimeout;
    uint8_t m_rreqTtl;
    Time m_discoveryTimeout;
    uint32_t m_discoveryRetries;
    bool m_overhear;

    std::map<Ipv4Address, Time> m_neighbors;  // last heard

    struct Discovery {
        uint32_t attempts = 0;
        EventId timer;
    };

    std::map<Ipv4Address, Discovery> m_discovery;
    uint32_t m_seq;
    Time m_lastTx;
    EventId m_helloTimer;
    uint64_t m_rreqsSent;
    uint64_t m_overheard;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // TERMITE_ROUTING_PROTOCOL_H
