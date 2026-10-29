// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Q-routing (Boyan & Littman, "Packet routing in dynamically changing
 * networks: a reinforcement learning approach", NIPS 6, 1994), the tabular
 * learned comparator of v2.5.0 (#588), written from the paper.
 *
 * Q_x(d, y) is node x's estimate of the time to deliver a packet for d by way
 * of neighbour y, its own queueing included (§2). Upon sending a packet to y,
 * x gets back y's estimate of the remaining time, t = min_z Q_y(d, z), and
 * revises
 *
 *     Q_x(d, y) <- Q_x(d, y) + eta (q + s + t - Q_x(d, y)),    eta = 0.5,
 *
 * with q the time the packet waited at x and s its transmission time. The
 * policy is greedy: the neighbour with the smallest Q (§2; "full echo" and
 * random exploration are §3.2 variants, not the algorithm compared here).
 *
 * What a wireless network adds, each a declared deviation in
 * ns3/baselines/adaptive/README.md:
 * - the paper's neighbours are wired links known in advance; here they are
 *   learned from a periodic hello and lost on silence or a MAC failure;
 * - the paper's estimate comes back for free; here it is a one-hop control
 *   message per data hop, which the harness counts as routing overhead;
 * - q + s is measured locally, from handing the packet to the MAC until its
 *   acknowledgement (WifiMac "AckedMpdu"), which also folds in MAC retries;
 * - the initial Q value of an untried (d, y) is not given (QInit).
 */
#ifndef QROUTING_ROUTING_PROTOCOL_H
#define QROUTING_ROUTING_PROTOCOL_H

#include "adaptive-routing-base.h"

#include "ns3/event-id.h"

#include <map>
#include <tuple>

namespace ns3 {
namespace adaptive {

class QRoutingProtocol : public RoutingBase {
public:
    static TypeId GetTypeId();
    QRoutingProtocol();
    ~QRoutingProtocol() override;

    static const uint16_t QROUTING_PORT = 5543;

    uint64_t EstimatesSent() const { return m_estimatesSent; }

    uint64_t Updates() const { return m_updates; }

protected:
    void DoInitialize() override;
    void DoDispose() override;

    uint16_t ControlPort() const override { return QROUTING_PORT; }

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
    using PacketKey = std::tuple<uint32_t, uint32_t, uint16_t>;  // src, dst, IP id

    struct Pending {
        Ipv4Address next;
        Time sent;
        Time acked;  // zero until the MAC acknowledged it
    };

    std::vector<Ipv4Address> LiveNeighbors();
    double Q(Ipv4Address dst, Ipv4Address nb) const;
    /// t = min_z Q_x(d, z): what this node reports for d (0 at d itself).
    double BestEstimate(Ipv4Address dst);
    void HelloTimer();
    void NotifyAcked(Ptr<const ADAPTIVE_WIFI_MPDU> mpdu);
    void PurgePending();

    double m_eta;
    double m_qInit;
    Time m_helloInterval;
    Time m_neighborTimeout;

    std::map<Ipv4Address, Time> m_neighbors;
    std::map<Ipv4Address, std::map<Ipv4Address, double>> m_q;
    std::map<PacketKey, Pending> m_pending;
    std::map<uint64_t, PacketKey> m_pendingByUid;
    EventId m_helloTimer;
    EventId m_purge;
    uint64_t m_estimatesSent;
    uint64_t m_updates;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // QROUTING_ROUTING_PROTOCOL_H
