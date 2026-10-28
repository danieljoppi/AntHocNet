// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Termite (Roth & Wicker, GLOBECOM 2003), written from M. H. Roth, "Termite:
 * A Swarm Intelligent Routing Algorithm for Mobile Wireless Ad-Hoc Networks",
 * PhD dissertation, Cornell, 2005, chapter 4, for the v2.5.0 stigmergic
 * comparator (#587). Constants are Table 4.1's unless the fidelity sheet
 * (ns3/baselines/adaptive/README.md) says otherwise.
 *
 * - Pheromone accounting (§4.2): every packet arriving at node i from
 *   neighbour r with source s adds gamma to P(r, s), data and control alike,
 *   overheard packets included. Cells decay continuously,
 *   P <- P e^{-(t - t_last) tau}, and are bounded to [floor, ceiling]; a new
 *   destination or neighbour starts its cells at the initial pheromone.
 * - Forwarding (eq. 4.3): p(n, d) = (P(n, d) + K)^F / sum_{j in N - r}
 *   (P(j, d) + K)^F, never back to the arrival link r.
 * - Route request (§4.2.6): a node that does not know the destination
 *   buffers the packet and sends RREQs on a random walk (uniform, never back
 *   to the arrival link, pheromone ignored) until a node with pheromone for
 *   the destination answers. The route reply's source is the destination, so
 *   it lays that destination's trail back to the requester, routed by eq. 4.3.
 *   No reply within the rreq timeout: the buffered packets are dropped.
 * - Hello (§4.2.6): only an isolated node sends hellos, every hello period,
 *   until a reply arrives; every node that hears one replies.
 * - Seed (§4.2.6): every seed period a node advertises itself with a short
 *   random walk, so destinations that never send (a CBR sink) stay known.
 * - Neighbours: gained by hearing them; lost at once on a link failure (MAC
 *   retry limit or an unanswered ARP), or when their whole row has decayed to
 *   the floor (§4.2.3).
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
    void StartDiscovery(Ipv4Address dst) override;
    void RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address receiver) override;
    void OnLinkFailure(Ipv4Address neighbor) override;
    std::set<Ipv4Address> KnownNeighbors() const override;

private:
    double Now() const;
    /// A packet from `source` arrived over the link from `neighbor`.
    void Learn(Ipv4Address neighbor, Ipv4Address source);
    Ipv4Address RandomNeighbor(Ipv4Address exclude);
    void RreqTimeout(Ipv4Address dst);
    void HelloTimer();
    void SeedTimer();
    void PruneTimer();
    void Overhear(Ptr<NetDevice> device, Ptr<const Packet> packet, uint16_t protocol,
                  const Address& from, const Address& to, NetDevice::PacketType type);

    BoundedPheromoneTable<Ipv4Address> m_table;
    double m_gamma;
    double m_decay;
    double m_initial;
    double m_floor;
    double m_ceiling;
    double m_k;
    double m_f;
    Time m_rreqTimeout;
    uint8_t m_rreqTtl;
    uint32_t m_rreqsPerRequest;
    uint8_t m_seedTtl;
    Time m_seedPeriod;
    Time m_helloPeriod;
    bool m_overhear;

    std::map<Ipv4Address, EventId> m_pendingRreq;  // destination -> rreq timeout
    uint32_t m_seq;
    EventId m_helloTimer;
    EventId m_seedTimer;
    EventId m_pruneTimer;
    uint64_t m_rreqsSent;
    uint64_t m_overheard;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // TERMITE_ROUTING_PROTOCOL_H
