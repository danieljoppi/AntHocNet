// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Ground-truth topology + all-pairs next hops for the oracle control arm
 * (issue #296 item 1, #216).
 *
 * One Topology object is shared by every oracle::RoutingProtocol in a
 * simulation. It answers a single question — "at this instant, which of my
 * interfaces, and which next-hop address, starts a shortest path from node u
 * to address d?" — from the simulator's own objects. It sends nothing, it
 * receives nothing, and no node ever learns anything from another node: this
 * is a control, not a protocol.
 *
 * Where the edges come from (see ns3/oracle/README.md for the full argument)
 * -------------------------------------------------------------------------
 * Per interface, by device class, because the honest answer differs:
 *
 * - **Not a WifiNetDevice** (point-to-point ISLs, CSMA, ...): adjacency is
 *   channel co-membership, read from the ns-3 Channel. **Exact** — the graph
 *   IS the wiring. This is the satellite +Grid case.
 * - **WifiNetDevice** on a channel whose propagation loss is exactly one
 *   `RangePropagationLossModel` (the harness's `range` arm): adjacency is
 *   that model's own `MaxRange`, read off the live channel. **Exact** — a
 *   disk model has a crisp cutoff and this is it.
 * - **WifiNetDevice** on a lone `TwoRayGroundPropagationLossModel`
 *   (`tworay`): the decode disk, derived (#431) — the distance at which the
 *   deterministic two-ray received power crosses the PHY's decode floor
 *   `max(RxSensitivity, ThresholdPreambleDetectionModel::MinimumRssi)`,
 *   every parameter read off the installed objects. **Approximate** —
 *   propagation-exact, but decoding under load also depends on interference,
 *   which no disk carries.
 * - **WifiNetDevice** on two-ray + `NakagamiPropagationLossModel`
 *   (`nakagami`): the median disk, derived (#431) — under Nakagami the
 *   received power is Gamma-distributed, so P(decode | d) has a closed form
 *   and the P = 1/2 crossing is computed from it with zero RNG draws.
 *   **Approximate** — a probabilistic link has no true radius at all.
 * - **Any other wifi channel**: no derivation exists, so the topology
 *   refuses to invent one. It uses the explicit `LinkRangeM` radius, which
 *   the scenario must then set, and flags itself **approximate**; with no
 *   radius set it aborts rather than guessing. `LinkRangeM` also overrides
 *   the two derived rules above when set.
 *
 * Why the decode floor and not `RxSensitivity`? Because the budget rule was
 * tried at RxSensitivity and measured: `Prx >= -101 dBm` over ns-3's own
 * two-ray chain makes 2440 of the 2450 possible edges of the paper scenario
 * adjacent — a near-complete graph — because the -82 dBm preamble-detection
 * floor, not RxSensitivity, is what actually gates decoding. The resulting
 * "oracle" routed everything one hop and delivered 30.4 % PDR, below every
 * protocol it is supposed to bound. An upper bound that loses to the things
 * it bounds is not an upper bound; the numbers are recorded in
 * ns3/oracle/README.md so the next person does not re-derive them.
 *
 * No propagation model is ever *evaluated* — the derivations mirror ns-3's
 * closed forms in oracle-decode-budget.{h,cc} — which also means no draw is
 * ever taken from the channel's pinned RNG stream (#352): the oracle arm
 * sees the same fading realisation as every other arm, not a perturbed one.
 * And since `tworay` and `nakagami` radii both derive from the same decode
 * threshold through each channel's own law, the harness's controlled
 * {tworay, nakagami} contrast compares one rule under two channels, not two
 * unrelated rules.
 *
 * Down interfaces (`Ipv4::IsUp`) are excluded, which is what makes a
 * scripted ISL break (#260) visible to the oracle without any extra wiring.
 *
 * Recompute cadence
 * -----------------
 * Periodic, `RecomputeInterval` (default 1 s), starting at t = 0 before any
 * traffic. Rebuilding the edge set is the cheap half and always runs; the
 * all-pairs Dijkstra runs only when the edge set actually changed, so a
 * static topology (the ISL grid) costs exactly one solve for the whole run.
 * The tradeoff is stated in the README: an interval of T bounds the oracle's
 * staleness by T, so at the paper scenario's 20 m/s a 1 s interval can be
 * wrong about a link for up to 20 m of node travel.
 */
#ifndef ORACLE_TOPOLOGY_H
#define ORACLE_TOPOLOGY_H

#include "ns3/event-id.h"
#include "ns3/ipv4-address.h"
#include "ns3/net-device.h"
#include "ns3/nstime.h"
#include "ns3/object.h"
#include "ns3/propagation-loss-model.h"

#include <map>
#include <string>
#include <vector>

namespace ns3 {

class Node;
class WifiNetDevice;

namespace oracle {

/// Where a packet for some destination must go next, from some node.
struct NextHop
{
    bool valid = false;
    uint32_t iface = 0;   //!< outgoing Ipv4 interface index on the local node
    Ipv4Address gateway;  //!< the next hop's address on that link
};

class Topology : public Object
{
  public:
    static TypeId GetTypeId();
    Topology();
    ~Topology() override;

    /// Called once per node by OracleHelper::Create, before the stack is up.
    void Register(Ptr<Node> node);

    /// Idempotent: the first oracle protocol to initialise starts the cadence.
    void Start();

    /// Cancel the recompute timer (called when the last protocol is disposed).
    void Stop();

    /// Next hop from `node` towards `dst`, or an invalid NextHop.
    NextHop Lookup(Ptr<Node> node, Ipv4Address dst);

    // --- diagnostics the harnesses print, and the a-priori assertions read ---
    /// true when some link rule in this topology is an approximation.
    bool IsApproximate() const
    {
        return m_approx;
    }

    /// Tags of the adjacency rules in force, "+"-joined: "wired" (exact,
    /// channel co-membership), "disk" (exact, the channel's own MaxRange),
    /// "decode-approx" (two-ray decode disk derived from the PHY's decode
    /// threshold, #431), "p50-approx" (Nakagami closed-form median disk at
    /// the same threshold, #431) and "disk-approx" (the explicit LinkRangeM
    /// override). Every approximate tag carries the "approx" substring —
    /// scenario_check.py cross-checks the approx flag against it.
    std::string GetMode() const
    {
        return m_mode;
    }

    uint32_t GetNodeCount() const
    {
        return static_cast<uint32_t>(m_nodes.size());
    }

    uint32_t GetEdgeCount() const
    {
        return m_edgeCount;
    }

    uint32_t GetRecomputeCount() const
    {
        return m_recomputes;
    }

    /// Recomputes whose edge set differed from the previous one.
    uint32_t GetTopologyChanges() const
    {
        return m_changes;
    }

    /// Lookups that found no path — the oracle's own "network partitioned".
    /// This spans BOTH entry points, so it is a diagnostic rather than a
    /// packet count; use the two splits below for accounting (#464).
    uint64_t GetNoRouteCount() const
    {
        return m_noRoute;
    }

    /// #464: route lookups that failed for a **locally originated** packet, so
    /// RouteOutput returned nullptr, the socket send failed, and the packet
    /// never reached Ipv4L3Protocol::Send. FlowMonitor therefore never counted
    /// it as transmitted: these are offered packets that are absent from the
    /// PDR denominator unless a harness adds them back. Counted in packets.
    uint64_t GetNoRouteOriginCount() const
    {
        return m_noRouteOrigin;
    }

    /// #464: route lookups that failed for a packet **already in flight**, so
    /// RouteInput invoked the error callback. Ipv4FlowProbe books those as a
    /// route drop and the packet was already in the denominator, so unlike the
    /// count above they need no correction — reported so the split is
    /// auditable rather than inferred.
    uint64_t GetNoRouteForwardCount() const
    {
        return m_noRouteForward;
    }

    /// Called by RoutingProtocol on the two failure paths, so the split is
    /// recorded where the packet's fate is actually decided. Lookup() cannot
    /// make the distinction: it is reached from both.
    void NoteNoRouteOrigin()
    {
        ++m_noRouteOrigin;
    }

    void NoteNoRouteForward()
    {
        ++m_noRouteForward;
    }

    /// The shared-medium adjacency radius actually used, or -1 when the
    /// topology is entirely wired (the ISL grid).
    double GetLinkRange() const
    {
        return m_usedRange;
    }

  private:
    /// One directed adjacency, already resolved to what a route needs.
    struct Link
    {
        int to;               //!< index into m_nodes
        uint32_t iface;       //!< local Ipv4 interface index
        Ipv4Address gateway;  //!< peer address on that link
    };

    /// The adjacency rule derived for one shared-medium channel, built once.
    struct WifiChannelModel
    {
        double range = 0.0;   //!< cutoff radius in metres
        bool approx = false;  //!< true unless the channel itself defines the radius
        std::string tag;      //!< the mode tag this rule contributes (see GetMode)
    };

    void Recompute();
    /// Re-derive the adjacency from the simulator's own objects into `out`.
    void BuildLinks(std::vector<std::vector<Link>>& out);
    void AddWiredLinks(int u,
                       uint32_t iface,
                       Ptr<NetDevice> dev,
                       std::vector<std::vector<Link>>& out);
    /// Adjacency radius for one shared-medium channel (derived, or explicit).
    /// `dev` is a representative device on that channel — the PHY whose tx
    /// power / gains / decode threshold the #431 derivations read.
    const WifiChannelModel& ChannelModel(Ptr<Channel> channel, Ptr<WifiNetDevice> dev);
    /// max(RxSensitivity, preamble-detection MinimumRssi) off the installed PHY.
    static double DecodeThresholdDbm(Ptr<WifiNetDevice> dev);

    std::vector<Ptr<Node>> m_nodes;
    std::map<uint32_t, int> m_index;              //!< ns-3 node id -> index
    std::map<Ipv4Address, int> m_addr;            //!< any local address -> index
    std::vector<std::vector<Link>> m_links;       //!< per-node adjacency
    std::vector<std::vector<NextHop>> m_nextHop;  //!< [from][to]
    std::map<Ptr<Channel>, WifiChannelModel> m_channels;

    Time m_interval;
    double m_linkRangeM = 0.0;
    bool m_started = false;
    bool m_approx = false;
    std::string m_mode = "unset";
    uint32_t m_edgeCount = 0;
    uint32_t m_recomputes = 0;
    uint32_t m_changes = 0;
    uint64_t m_noRoute = 0;
    uint64_t m_noRouteOrigin = 0;   // #464
    uint64_t m_noRouteForward = 0;  // #464
    double m_usedRange = -1.0;
    EventId m_timer;
};

}  // namespace oracle
}  // namespace ns3

#endif  // ORACLE_TOPOLOGY_H
