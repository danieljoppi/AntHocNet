// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "oracle-topology.h"

#include "oracle-decode-budget.h"

#include "ns3/abort.h"
#include "ns3/channel.h"
#include "ns3/double.h"
#include "ns3/ipv4.h"
#include "ns3/log.h"
#include "ns3/mobility-model.h"
#include "ns3/node.h"
#include "ns3/pointer.h"
#include "ns3/simulator.h"
#include "ns3/wifi-net-device.h"
#include "ns3/wifi-phy.h"

#include <algorithm>

#include "anthocnet/core/shortest_path.h"

#include <set>

namespace ns3
{

NS_LOG_COMPONENT_DEFINE("OracleTopology");

namespace oracle
{

NS_OBJECT_ENSURE_REGISTERED(Topology);

TypeId
Topology::GetTypeId()
{
    static TypeId tid =
        TypeId("ns3::oracle::Topology")
            .SetParent<Object>()
            .SetGroupName("Oracle")
            .AddConstructor<Topology>()
            .AddAttribute("RecomputeInterval",
                          "How often the ground-truth topology is re-derived and, if it "
                          "changed, re-solved. Bounds the oracle's staleness: at 20 m/s a "
                          "1 s interval can be wrong about a link for 20 m of travel. "
                          "Inert on a static topology beyond the rebuild cost, since the "
                          "Dijkstra solve is skipped when the edge set is unchanged.",
                          TimeValue(Seconds(1.0)),
                          MakeTimeAccessor(&Topology::m_interval),
                          MakeTimeChecker(Seconds(0.001)))
            .AddAttribute("LinkRangeM",
                          "EXPLICIT OVERRIDE of the shared-medium adjacency radius, in "
                          "metres. 0 (the default) derives the radius from the installed "
                          "objects instead: the channel's own MaxRange on a disk channel "
                          "(exact), the PHY decode threshold's crossing distance on "
                          "two-ray, and the closed-form median of the Gamma fading "
                          "distribution at that same threshold on two-ray+Nakagami (#431; "
                          "both derived rules stay APPROXIMATE). Setting it forces the "
                          "given radius on any channel with no crisp cutoff and marks the "
                          "topology APPROXIMATE; it is ignored on a channel that is "
                          "exactly a RangePropagationLossModel and on wired topologies. "
                          "On an underivable loss chain (neither disk, two-ray, nor "
                          "two-ray+Nakagami) it is REQUIRED — the oracle aborts rather "
                          "than guess.",
                          DoubleValue(0.0),
                          MakeDoubleAccessor(&Topology::m_linkRangeM),
                          MakeDoubleChecker<double>(0.0));
    return tid;
}

Topology::Topology()
    : m_interval(Seconds(1.0))
{
}

Topology::~Topology()
{
}

void
Topology::Register(Ptr<Node> node)
{
    NS_ABORT_MSG_IF(!node, "oracle::Topology::Register called with a null node");
    if (m_index.find(node->GetId()) != m_index.end())
    {
        return;
    }
    m_index[node->GetId()] = static_cast<int>(m_nodes.size());
    m_nodes.push_back(node);
}

void
Topology::Start()
{
    if (m_started)
    {
        return;
    }
    m_started = true;
    Recompute();
}

void
Topology::Stop()
{
    Simulator::Cancel(m_timer);
}

void
Topology::Recompute()
{
    ++m_recomputes;
    std::vector<std::vector<Link>> links;
    BuildLinks(links);

    // The rebuild above is the cheap half and always runs; the all-pairs solve
    // is the expensive half and only runs when the graph actually moved. On the
    // static ISL grid that is exactly one solve for the whole simulation.
    bool changed = links.size() != m_links.size();
    for (std::size_t u = 0; !changed && u < links.size(); ++u)
    {
        changed = links[u].size() != m_links[u].size();
        for (std::size_t i = 0; !changed && i < links[u].size(); ++i)
        {
            changed = links[u][i].to != m_links[u][i].to ||
                      links[u][i].iface != m_links[u][i].iface ||
                      links[u][i].gateway != m_links[u][i].gateway;
        }
    }

    if (changed)
    {
        ++m_changes;
        m_links.swap(links);
        const int n = static_cast<int>(m_nodes.size());
        anthocnet::core::ShortestPathGraph graph(n);
        for (int u = 0; u < n; ++u)
        {
            for (const Link& l : m_links[static_cast<std::size_t>(u)])
            {
                // Unit weight: the oracle minimises HOP COUNT, which is what
                // makes "the oracle's path is no longer than any protocol's"
                // an assertion rather than a hope.
                graph.addEdge(u, l.to, 1.0);
            }
        }
        m_nextHop.assign(static_cast<std::size_t>(n), std::vector<NextHop>(static_cast<std::size_t>(n)));
        for (int u = 0; u < n; ++u)
        {
            graph.computeFrom(u);
            for (int d = 0; d < n; ++d)
            {
                const int hop = graph.firstHopTo(d);
                if (hop == anthocnet::core::ShortestPathGraph::kNoNode)
                {
                    continue;
                }
                for (const Link& l : m_links[static_cast<std::size_t>(u)])
                {
                    if (l.to != hop)
                    {
                        continue;
                    }
                    NextHop& nh = m_nextHop[static_cast<std::size_t>(u)][static_cast<std::size_t>(d)];
                    nh.valid = true;
                    nh.iface = l.iface;
                    nh.gateway = l.gateway;
                    break; // parallel links to one peer: lowest interface wins
                }
            }
        }
    }

    m_timer = Simulator::Schedule(m_interval, &Topology::Recompute, this);
}

void
Topology::BuildLinks(std::vector<std::vector<Link>>& out)
{
    const std::size_t n = m_nodes.size();
    out.assign(n, std::vector<Link>());
    m_addr.clear();
    m_edgeCount = 0;

    // Address book first: every local address of every participating node, up
    // interfaces and down alike (a down interface's address is still delivered
    // locally, it just cannot carry traffic).
    for (std::size_t u = 0; u < n; ++u)
    {
        Ptr<Ipv4> ipv4 = m_nodes[u]->GetObject<Ipv4>();
        NS_ABORT_MSG_IF(!ipv4, "oracle: node " << m_nodes[u]->GetId() << " has no IPv4 stack");
        for (uint32_t i = 0; i < ipv4->GetNInterfaces(); ++i)
        {
            for (uint32_t a = 0; a < ipv4->GetNAddresses(i); ++a)
            {
                const Ipv4Address local = ipv4->GetAddress(i, a).GetLocal();
                if (local == Ipv4Address::GetLoopback())
                {
                    continue;
                }
                m_addr[local] = static_cast<int>(u);
            }
        }
    }

    // Wifi participants, grouped by channel: co-membership of a shared medium
    // is not adjacency (every node is on the one channel), so these go through
    // the per-channel radius rule below instead.
    struct WifiPart
    {
        int u;
        uint32_t iface;
        Ptr<MobilityModel> mob;
        Ipv4Address addr;
        Ptr<WifiNetDevice> dev; //!< the PHY the adjacency rule is derived from
    };
    std::map<Ptr<Channel>, std::vector<WifiPart>> wifi;
    std::set<std::string> tags;

    for (std::size_t u = 0; u < n; ++u)
    {
        Ptr<Ipv4> ipv4 = m_nodes[u]->GetObject<Ipv4>();
        for (uint32_t i = 0; i < ipv4->GetNInterfaces(); ++i)
        {
            if (!ipv4->IsUp(i) || ipv4->GetNAddresses(i) == 0)
            {
                continue;
            }
            const Ipv4Address local = ipv4->GetAddress(i, 0).GetLocal();
            if (local == Ipv4Address::GetLoopback())
            {
                continue;
            }
            Ptr<NetDevice> dev = ipv4->GetNetDevice(i);
            if (!dev)
            {
                continue;
            }
            Ptr<WifiNetDevice> wdev = DynamicCast<WifiNetDevice>(dev);
            if (!wdev)
            {
                AddWiredLinks(static_cast<int>(u), i, dev, out);
                tags.insert("wired");
                continue;
            }
            Ptr<MobilityModel> mob = m_nodes[u]->GetObject<MobilityModel>();
            NS_ABORT_MSG_IF(!mob,
                            "oracle: node " << m_nodes[u]->GetId()
                                            << " has a wifi device but no MobilityModel — "
                                               "adjacency on a shared medium is a function of "
                                               "position and cannot be derived without one");
            WifiPart p;
            p.u = static_cast<int>(u);
            p.iface = i;
            p.mob = mob;
            p.addr = local;
            p.dev = wdev;
            wifi[dev->GetChannel()].push_back(p);
        }
    }

    for (auto& kv : wifi)
    {
        const WifiChannelModel& model = ChannelModel(kv.first, kv.second.front().dev);
        tags.insert(model.tag);
        m_approx = m_approx || model.approx;
        m_usedRange = model.range;
        const double r2 = model.range * model.range;
        const std::vector<WifiPart>& parts = kv.second;
        for (std::size_t a = 0; a < parts.size(); ++a)
        {
            for (std::size_t b = 0; b < parts.size(); ++b)
            {
                if (a == b || parts[a].u == parts[b].u)
                {
                    continue;
                }
                // Symmetric by construction: a one-way radio link is not a
                // route, and both directions read the same distance.
                if (CalculateDistanceSquared(parts[a].mob->GetPosition(),
                                             parts[b].mob->GetPosition()) > r2)
                {
                    continue;
                }
                Link l;
                l.to = parts[b].u;
                l.iface = parts[a].iface;
                l.gateway = parts[b].addr;
                out[static_cast<std::size_t>(parts[a].u)].push_back(l);
                ++m_edgeCount;
            }
        }
    }

    std::string mode;
    for (const std::string& t : tags)
    {
        mode += (mode.empty() ? "" : "+") + t;
    }
    m_mode = mode.empty() ? "empty" : mode;
}

void
Topology::AddWiredLinks(int u,
                        uint32_t iface,
                        Ptr<NetDevice> dev,
                        std::vector<std::vector<Link>>& out)
{
    // Not a shared medium: the channel IS the wiring, so co-membership is
    // exact adjacency. This is the satellite +Grid ISL case (and CSMA, where
    // every device on the segment is genuinely one hop away).
    Ptr<Channel> ch = dev->GetChannel();
    if (!ch)
    {
        return;
    }
    for (std::size_t k = 0; k < ch->GetNDevices(); ++k)
    {
        Ptr<NetDevice> peer = ch->GetDevice(static_cast<uint32_t>(k));
        if (!peer || peer == dev)
        {
            continue;
        }
        auto it = m_index.find(peer->GetNode()->GetId());
        if (it == m_index.end())
        {
            continue; // a node outside the oracle's world
        }
        Ptr<Ipv4> pIpv4 = peer->GetNode()->GetObject<Ipv4>();
        if (!pIpv4)
        {
            continue;
        }
        const int32_t pIface = pIpv4->GetInterfaceForDevice(peer);
        if (pIface < 0 || !pIpv4->IsUp(static_cast<uint32_t>(pIface)) ||
            pIpv4->GetNAddresses(static_cast<uint32_t>(pIface)) == 0)
        {
            continue; // the far end is administratively down (#260 ISL break)
        }
        Link l;
        l.to = it->second;
        l.iface = iface;
        l.gateway = pIpv4->GetAddress(static_cast<uint32_t>(pIface), 0).GetLocal();
        out[static_cast<std::size_t>(u)].push_back(l);
        ++m_edgeCount;
    }
}

double
Topology::DecodeThresholdDbm(Ptr<WifiNetDevice> dev)
{
    // The power a frame needs for the PHY to decode it at all, read off the
    // installed PHY the way the disk rule reads MaxRange off the live channel.
    // Two floors gate reception, and the BINDING one is the higher:
    //
    //  - RxSensitivity (default -101 dBm): below it reception is not even
    //    attempted;
    //  - ThresholdPreambleDetectionModel::MinimumRssi (default -82 dBm,
    //    installed on every PHY by WifiPhyHelper): below it the preamble is
    //    dropped regardless of SNR, so no frame ever decodes.
    //
    // The withdrawn link-budget rule (README) used RxSensitivity alone — 19 dB
    // below the preamble floor — and derived a 1264 m near-complete graph of
    // links the PHY then refused to decode. Reading the *installed* preamble
    // model is what removes that 19 dB error without introducing a calibrated
    // constant (#431).
    Ptr<WifiPhy> phy = dev->GetPhy();
    NS_ABORT_MSG_IF(!phy, "oracle: wifi device with no PHY");
    DoubleValue sens;
    phy->GetAttribute("RxSensitivity", sens);
    double threshold = sens.Get();
    PointerValue pd;
    if (phy->GetAttributeFailSafe("PreambleDetectionModel", pd) && pd.Get<Object>())
    {
        DoubleValue rssiMin;
        if (pd.Get<Object>()->GetAttributeFailSafe("MinimumRssi", rssiMin))
        {
            threshold = std::max(threshold, rssiMin.Get());
        }
    }
    return threshold;
}

const Topology::WifiChannelModel&
Topology::ChannelModel(Ptr<Channel> channel, Ptr<WifiNetDevice> dev)
{
    auto it = m_channels.find(channel);
    if (it != m_channels.end())
    {
        return it->second;
    }
    PointerValue pv;
    NS_ABORT_MSG_IF(!channel || !channel->GetAttributeFailSafe("PropagationLossModel", pv),
                    "oracle: the wifi channel exposes no PropagationLossModel attribute, so "
                    "adjacency cannot be derived from the channel this scenario is actually "
                    "using. Set the oracle's LinkRangeM if you know the radius, or use a "
                    "channel the oracle can read.");
    Ptr<PropagationLossModel> head = pv.Get<PropagationLossModel>();
    NS_ABORT_MSG_IF(!head, "oracle: wifi channel has no propagation loss model attached");
    const std::string headType = head->GetInstanceTypeId().GetName();
    Ptr<PropagationLossModel> next = head->GetNext();
    const std::string nextType = next ? next->GetInstanceTypeId().GetName() : "";

    WifiChannelModel model;
    // A disk model has a crisp cutoff and the channel object knows it. This is
    // the ONE shared-medium case the oracle can be exact for.
    if (headType == "ns3::RangePropagationLossModel" && !next)
    {
        DoubleValue maxRange;
        head->GetAttribute("MaxRange", maxRange);
        model.range = maxRange.Get();
        model.approx = false;
        model.tag = "disk";
    }
    else if (m_linkRangeM > 0.0)
    {
        // Explicit override: the scenario pinned a radius, so the derived
        // rules below are bypassed and the topology is approximate by fiat.
        model.range = m_linkRangeM;
        model.approx = true;
        model.tag = "disk-approx";
    }
    else if (headType == "ns3::TwoRayGroundPropagationLossModel" &&
             (!next || (nextType == "ns3::NakagamiPropagationLossModel" && !next->GetNext())))
    {
        // #431: the fading channels' adjacency, derived — not guessed — from
        // the installed objects. Everything below is read off the live model
        // and PHY; there is no free constant (the withdrawn budget rule's
        // failure was reading the wrong attribute, not deriving per se).
        //
        // No propagation model is ever *evaluated* here — the closed forms in
        // oracle-decode-budget.cc mirror ns-3's formulas — so no draw is ever
        // taken from the channel's pinned RNG stream (#352): the oracle arm
        // still sees the same fading realisation as every other arm.
        oracle::TwoRayBudget budget;
        DoubleValue v;
        // TxPowerEnd is the transmit power of the default single power level
        // the harnesses use; a scenario doing per-packet TPC has no single
        // disk and should set LinkRangeM explicitly.
        Ptr<WifiPhy> phy = dev->GetPhy();
        phy->GetAttribute("TxPowerEnd", v);
        budget.txPowerDbm = v.Get();
        phy->GetAttribute("TxGain", v);
        budget.txGainDb = v.Get();
        phy->GetAttribute("RxGain", v);
        budget.rxGainDb = v.Get();
        head->GetAttribute("Frequency", v);
        budget.frequencyHz = v.Get();
        head->GetAttribute("SystemLoss", v);
        budget.systemLoss = v.Get();
        head->GetAttribute("MinDistance", v);
        budget.minDistanceM = v.Get();
        // The model adds each node's z to HeightAboveZ per endpoint. A single
        // disk radius needs one height, so the representative device's z is
        // used; on a mixed-height field the adjacency is not a disk at all —
        // set LinkRangeM (or improve this) rather than trust the derivation.
        head->GetAttribute("HeightAboveZ", v);
        Ptr<MobilityModel> mob = dev->GetNode()->GetObject<MobilityModel>();
        budget.heightM = v.Get() + (mob ? mob->GetPosition().z : 0.0);
        const double threshold = DecodeThresholdDbm(dev);

        if (!next)
        {
            // Deterministic two-ray: received power crosses the decode floor
            // at exactly one distance, so the decode disk IS the set of pairs
            // that can exchange a frame absent interference (measured on #431:
            // 99.8 % precision / 99.8 % recall against the probed delivery
            // graph at paper-shape parameters, where the radius is 423.3 m).
            // Still flagged approximate: decoding under load also depends on
            // interference and capture, which no disk can carry — exactness
            // stays reserved for adjacency the scenario itself configured.
            model.range = oracle::TwoRayDecodeRadius(budget, threshold);
            model.tag = "decode-approx";
        }
        else
        {
            // Two-ray + Nakagami: link existence is a probability, not a
            // radius — received power is Gamma(m(d), P(d)/m(d))-distributed,
            // so P(decode | d) = Q(m, m*T/P(d)) in closed form. The median
            // (P = 1/2) disk is the best single-radius approximation measured
            // on #431 (373.4 m at paper-shape parameters: delivery bound holds
            // in every seed, matched-hop gap an order of magnitude below the
            // naive --range disk's). The full probability-weighted graph is
            // direction 2 of #431 and deliberately not built here.
            oracle::NakagamiProfile prof;
            next->GetAttribute("Distance1", v);
            prof.distance1M = v.Get();
            next->GetAttribute("Distance2", v);
            prof.distance2M = v.Get();
            next->GetAttribute("m0", v);
            prof.m0 = v.Get();
            next->GetAttribute("m1", v);
            prof.m1 = v.Get();
            next->GetAttribute("m2", v);
            prof.m2 = v.Get();
            model.range = oracle::NakagamiMedianRadius(budget, prof, threshold);
            model.tag = "p50-approx";
        }
        model.approx = true;
        NS_ABORT_MSG_IF(model.range <= 0.0,
                        "oracle: the derived decode radius for " << headType
                            << " came out " << model.range
                            << " m — the PHY's decode threshold is above what any "
                               "distance delivers, so the ground-truth graph would be "
                               "empty. Set LinkRangeM explicitly if this is intended.");
    }
    else
    {
        // Any other chain has no derivation implemented, so there is nothing
        // to read. Refuse to guess; the scenario must state the radius it
        // wants the control held to, and the result is marked approximate for
        // the rest of its life.
        NS_ABORT_MSG("oracle: this channel's propagation chain (head "
                     << headType
                     << ") has no adjacency derivation — the oracle can derive a "
                        "radius only from a RangePropagationLossModel (exact), a lone "
                        "TwoRayGroundPropagationLossModel (decode disk, #431) or "
                        "two-ray + NakagamiPropagationLossModel (median disk, #431). "
                        "Set the LinkRangeM attribute to the radius the control "
                        "should be held to and the result will be flagged "
                        "approximate. The oracle will not invent one (#296).");
    }
    return m_channels.insert(std::make_pair(channel, model)).first->second;
}

NextHop
Topology::Lookup(Ptr<Node> node, Ipv4Address dst)
{
    NextHop none;
    auto u = m_index.find(node->GetId());
    auto d = m_addr.find(dst);
    if (u == m_index.end() || d == m_addr.end())
    {
        ++m_noRoute;
        return none;
    }
    if (m_nextHop.empty())
    {
        ++m_noRoute;
        return none;
    }
    const NextHop& nh = m_nextHop[static_cast<std::size_t>(u->second)][static_cast<std::size_t>(d->second)];
    if (!nh.valid)
    {
        ++m_noRoute;
    }
    return nh;
}

} // namespace oracle
} // namespace ns3
