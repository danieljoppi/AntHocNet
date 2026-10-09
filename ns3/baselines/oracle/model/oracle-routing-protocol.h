// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * The oracle control arm (issue #296 item 1, #216): a global-knowledge
 * shortest-path "protocol".
 *
 * It is a control, not a protocol, and the difference is the point:
 *
 * - **Zero control traffic.** It opens no socket, sends no hello, no request
 *   and no reply. Its normalized routing load is exactly 0 by construction,
 *   which is why both harnesses assert `NRL == 0` on this arm rather than
 *   merely expecting it.
 * - **Zero discovery latency.** There is no pending-packet queue: the next
 *   hop is known the instant the first packet is offered, so the measured
 *   delay is pure queueing plus propagation over a shortest path. A packet
 *   with no path is dropped immediately (ERROR_NOROUTETOHOST) instead of
 *   waiting for a route that no mechanism is looking for.
 * - **Zero learning.** Every node reads the same ground-truth topology
 *   (oracle::Topology), derived from the simulator's channels, positions and
 *   interface states — never from anything another node told it.
 *
 * What it is FOR: the upper bound both suites lack. AODV/OLSR/DSDV are
 * replication anchors and GPSR is a competitive-frontier baseline; none of
 * them answers "how much of the gap is the protocol's fault and how much is
 * the network's?". The oracle does, and on the satellite +Grid it is the
 * baseline the LEO literature holds every result to (#216).
 *
 * The oracle is expected to WIN and that is not the interesting part — the
 * interesting cells are the ones where its assumptions fail (congestion it
 * cannot see, unpredicted failures, endpoint churn: #216).
 */
#ifndef ORACLE_ROUTING_PROTOCOL_H
#define ORACLE_ROUTING_PROTOCOL_H

#include "oracle-topology.h"

#include "ns3/ipv4-interface.h"
#include "ns3/ipv4-routing-protocol.h"
#include "ns3/node.h"

// ns-3 changed Ipv4RoutingProtocol::RouteInput's forwarding-callback parameters
// from by-value (<= ns-3.36) to const-reference (ns-3.37+). The override must
// match exactly or the class stays abstract. ORACLE_NS3_ROUTEINPUT_BYVALUE is
// defined by the module's CMakeLists for ns-3 <= 3.36, but that definition is
// directory-scoped: an out-of-module includer (anthocnet-compare, isl-grid)
// does not see it and would fail to compile this header on 3.36. So fall back
// to the same ns3/wifi-mpdu.h probe the gpsr module uses — WifiMacQueueItem
// became WifiMpdu in ns-3.37, the same release that changed RouteInput.
#if defined(ORACLE_NS3_ROUTEINPUT_BYVALUE) || !__has_include("ns3/wifi-mpdu.h")
#define ORACLE_RI_CB(T) T
#else
#define ORACLE_RI_CB(T) const T&
#endif

namespace ns3
{
namespace oracle
{

class RoutingProtocol : public Ipv4RoutingProtocol
{
  public:
    static TypeId GetTypeId();
    RoutingProtocol();
    ~RoutingProtocol() override;

    /// Set by OracleHelper: the topology shared by every node in this run.
    void SetTopology(Ptr<Topology> topology);
    Ptr<Topology> GetTopology() const;

    /**
     * The oracle consumes no randomness at all — no jitter, no backoff, no
     * probabilistic forwarding. This exists so the harness's #352 stream
     * pinning can cover every arm uniformly, and so "0" is a measured
     * statement rather than an omission.
     */
    int64_t AssignStreams(int64_t stream);

    // Ipv4RoutingProtocol
    Ptr<Ipv4Route> RouteOutput(Ptr<Packet> p,
                               const Ipv4Header& header,
                               Ptr<NetDevice> oif,
                               Socket::SocketErrno& sockerr) override;
    bool RouteInput(Ptr<const Packet> p,
                    const Ipv4Header& header,
                    Ptr<const NetDevice> idev,
                    ORACLE_RI_CB(UnicastForwardCallback) ucb,
                    ORACLE_RI_CB(MulticastForwardCallback) mcb,
                    ORACLE_RI_CB(LocalDeliverCallback) lcb,
                    ORACLE_RI_CB(ErrorCallback) ecb) override;
    void NotifyInterfaceUp(uint32_t interface) override;
    void NotifyInterfaceDown(uint32_t interface) override;
    void NotifyAddAddress(uint32_t interface, Ipv4InterfaceAddress address) override;
    void NotifyRemoveAddress(uint32_t interface, Ipv4InterfaceAddress address) override;
    void SetIpv4(Ptr<Ipv4> ipv4) override;
    void PrintRoutingTable(Ptr<OutputStreamWrapper> stream,
                           Time::Unit unit = Time::S) const override;

  protected:
    void DoInitialize() override;
    void DoDispose() override;

  private:
    /// Build a route for `dst`, or null when the topology knows no path.
    Ptr<Ipv4Route> Resolve(Ipv4Address dst, Ptr<NetDevice> oif);

    Ptr<Ipv4> m_ipv4;
    Ptr<Topology> m_topology;
};

} // namespace oracle
} // namespace ns3

#endif // ORACLE_ROUTING_PROTOCOL_H
