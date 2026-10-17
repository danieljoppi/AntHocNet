// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * --vizTrace (#641): a compact record of one ns-3 run that the learn site
 * replays with its own renderer. Shared by anthocnet-compare, isl-grid and
 * leo-walker. One JSON object per line:
 *
 *   {"v":1,"kind":"header", ...the harness's fields..., "nodes":N,
 *    "step":s, "scale":m}                       first line
 *   {"t":s, "p":[[x,y,z],...], "tx":n, "rx":n, "ants":n,
 *    "drop":{"route":n,"ttl":n,"queue":n}, "paths":[{"f":[src,dst],"p":[src,...]},...]}
 *                                               one per step
 *   {"kind":"end","tx":n,"rx":n,"pdr":pct}      the run's own PDR books
 *
 * p is each node's position in units of `scale` metres, rounded (omitted
 * when the nodes have no mobility model: the isl-grid torus). tx/rx are
 * cumulative data packets on the data port, read live from the run's
 * FlowMonitor -- the same counters the run's PDR is computed from, so the
 * last step and the end line agree (tools/bench/check-viz-trace.py checks it).
 * ants counts AntHocNet control transmissions in the step. paths holds, per
 * data flow seen so far, the strongest route: from the source, the
 * neighbour with the most regular pheromone toward the destination, hop by
 * hop (RoutingProtocol::StrongestNextHop, the game's rule).
 *
 * Off unless the flag is given; it schedules read-only sampling events and
 * draws no random numbers, so a run's results are the same with it on.
 */
#ifndef ANTHOCNET_VIZ_TRACE_H
#define ANTHOCNET_VIZ_TRACE_H

#include "ns3/anthocnet-routing-protocol.h"
#include "ns3/flow-monitor-module.h"
#include "ns3/ipv4-flow-classifier.h"
#include "ns3/ipv4.h"
#include "ns3/mobility-model.h"
#include "ns3/node-container.h"
#include "ns3/simulator.h"

#include <cmath>
#include <cstdint>
#include <fstream>
#include <map>
#include <set>
#include <string>
#include <utility>
#include <vector>

namespace ns3 {
namespace vizt {

class VizTrace {
public:
    bool Active() const { return m_out.is_open(); }

    /// Start recording. `header` is the harness's JSON fields without braces
    /// (e.g. "\"harness\":\"anthocnet-compare\",\"cell\":\"paper\""). Call
    /// after the routing protocols and applications are installed and before
    /// Simulator::Run(); one recorded run per process.
    void Start(const std::string& path, const std::string& header, const NodeContainer& nodes,
               Ptr<FlowMonitor> monitor, Ptr<Ipv4FlowClassifier> classifier, uint16_t dataPort,
               double step, double stop, double scale) {
        m_out.open(path);
        if (!m_out) return;
        m_nodes = nodes;
        m_monitor = monitor;
        m_classifier = classifier;
        m_port = dataPort;
        m_step = step;
        m_stop = stop;
        m_scale = scale;
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = nodes.Get(i)->GetObject<Ipv4>();
            for (uint32_t k = 0; ip && k < ip->GetNInterfaces(); ++k) {
                for (uint32_t a = 0; a < ip->GetNAddresses(k); ++a) {
                    const Ipv4Address addr = ip->GetAddress(k, a).GetLocal();
                    if (addr != Ipv4Address::GetLoopback()) m_index[addr.Get()] = i;
                }
            }
            Ptr<anthocnet::RoutingProtocol> rp =
                ip ? DynamicCast<anthocnet::RoutingProtocol>(ip->GetRoutingProtocol()) : nullptr;
            m_rp.push_back(rp);
            if (rp) rp->TraceConnectWithoutContext("Tx", MakeCallback(&VizTrace::AntTx, this));
        }
        m_out << "{\"v\":1,\"kind\":\"header\"," << header << ",\"nodes\":" << nodes.GetN()
              << ",\"step\":" << step << ",\"time\":" << stop << ",\"scale\":" << scale << "}\n";
        Simulator::Schedule(Seconds(step), &VizTrace::Sample, this);
    }

    /// The run's own books, after the harness computed its PDR.
    void Finish(uint64_t tx, uint64_t rx, double pdr) {
        if (!Active()) return;
        m_out << "{\"kind\":\"end\",\"tx\":" << tx << ",\"rx\":" << rx << ",\"pdr\":" << pdr
              << "}\n";
        m_out.close();
        m_done = true;
    }

    bool Done() const { return m_done; }

private:
    void AntTx(uint8_t, uint8_t, bool) { ++m_ants; }

    int IndexOf(Ipv4Address a) const {
        auto it = m_index.find(a.Get());
        return it == m_index.end() ? -1 : static_cast<int>(it->second);
    }

    void Sample() {
        const double now = Simulator::Now().GetSeconds();
        m_out << "{\"t\":" << now;
        // Positions, if the nodes move at all.
        bool any = false;
        for (uint32_t i = 0; i < m_nodes.GetN(); ++i) {
            if (m_nodes.Get(i)->GetObject<MobilityModel>()) any = true;
        }
        if (any) {
            m_out << ",\"p\":[";
            for (uint32_t i = 0; i < m_nodes.GetN(); ++i) {
                Ptr<MobilityModel> m = m_nodes.Get(i)->GetObject<MobilityModel>();
                const Vector v = m ? m->GetPosition() : Vector();
                m_out << (i ? "," : "") << '[' << std::lround(v.x / m_scale) << ','
                      << std::lround(v.y / m_scale) << ',' << std::lround(v.z / m_scale) << ']';
            }
            m_out << ']';
        }
        // Data books and drop causes, from the live FlowMonitor counters.
        uint64_t tx = 0, rx = 0, dRoute = 0, dTtl = 0, dQueue = 0;
        std::vector<std::pair<std::pair<int, int>, Ipv4Address>> flows;
        for (const auto& kv : m_monitor->GetFlowStats()) {
            const Ipv4FlowClassifier::FiveTuple t = m_classifier->FindFlow(kv.first);
            if (t.destinationPort != m_port) continue;
            tx += kv.second.txPackets;
            rx += kv.second.rxPackets;
            const std::vector<uint32_t>& pd = kv.second.packetsDropped;
            auto reason = [&pd](std::size_t i) -> uint64_t { return i < pd.size() ? pd[i] : 0u; };
            dRoute +=
                reason(Ipv4FlowProbe::DROP_NO_ROUTE) + reason(Ipv4FlowProbe::DROP_ROUTE_ERROR);
            dTtl += reason(Ipv4FlowProbe::DROP_TTL_EXPIRE);
            dQueue += reason(Ipv4FlowProbe::DROP_QUEUE) + reason(Ipv4FlowProbe::DROP_QUEUE_DISC);
            const int s = IndexOf(t.sourceAddress), d = IndexOf(t.destinationAddress);
            if (s >= 0 && d >= 0) flows.push_back({{s, d}, t.destinationAddress});
        }
        m_out << ",\"tx\":" << tx << ",\"rx\":" << rx << ",\"ants\":" << m_ants
              << ",\"drop\":{\"route\":" << dRoute << ",\"ttl\":" << dTtl << ",\"queue\":" << dQueue
              << '}';
        m_ants = 0;
        // Strongest routes, one per (source, destination) pair.
        std::set<std::pair<int, int>> seen;
        m_out << ",\"paths\":[";
        bool first = true;
        for (const auto& fl : flows) {
            const std::pair<int, int>& f = fl.first;
            if (!seen.insert(f).second) continue;
            m_out << (first ? "" : ",") << "{\"f\":[" << f.first << ',' << f.second << "],\"p\":["
                  << f.first;
            first = false;
            int cur = f.first;
            std::set<int> visited{cur};
            // The address data packets are routed on: the core's destination key.
            const Ipv4Address dest = fl.second;
            for (int hop = 0; hop < 64 && cur != f.second; ++hop) {
                Ptr<anthocnet::RoutingProtocol> rp = m_rp[cur];
                const int nb = rp ? IndexOf(rp->StrongestNextHop(dest)) : -1;
                if (nb < 0 || !visited.insert(nb).second) break;
                m_out << ',' << nb;
                cur = nb;
            }
            m_out << "]}";
        }
        m_out << "]}\n";
        if (now + m_step <= m_stop + 1e-9)
            Simulator::Schedule(Seconds(m_step), &VizTrace::Sample, this);
    }

    std::ofstream m_out;
    NodeContainer m_nodes;
    Ptr<FlowMonitor> m_monitor;
    Ptr<Ipv4FlowClassifier> m_classifier;
    uint16_t m_port = 9;
    double m_step = 1.0, m_stop = 0.0, m_scale = 1.0;
    std::map<uint32_t, uint32_t> m_index;
    std::vector<Ptr<anthocnet::RoutingProtocol>> m_rp;
    uint64_t m_ants = 0;
    bool m_done = false;
};

}  // namespace vizt
}  // namespace ns3

#endif  // ANTHOCNET_VIZ_TRACE_H
