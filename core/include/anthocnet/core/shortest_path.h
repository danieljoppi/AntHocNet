// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Single-source shortest paths over an explicit graph (issue #296 item 1,
 * #216).
 *
 * This is NOT part of the AntHocNet protocol and no protocol code calls it.
 * It is the computation behind the **oracle control arm** — the
 * global-knowledge upper bound the benchmark suites lack: Dijkstra over the
 * ground-truth topology, replayed as an ns-3 routing protocol
 * (`ns3/oracle/`). It lives in `core/` for one reason: it is
 * simulator-agnostic logic, and AGENTS.md rule 7 wants logic covered by a
 * core unit test rather than only by a simulator run.
 *
 * What it computes
 * ----------------
 * `computeFrom(source)` runs Dijkstra and stores, for every node, the
 * distance from the source and the **first hop** on a shortest path — the
 * neighbour the source must hand the packet to. First-hop-from-source is
 * exactly what a routing table needs, and propagating it during relaxation
 * (`firstHop[v] = (u == source) ? v : firstHop[u]`) avoids walking a
 * predecessor chain per destination.
 *
 * Determinism
 * -----------
 * Equal-cost shortest paths are ubiquitous in the topologies this serves (a
 * +Grid ISL torus is almost nothing but ties, and a dense wifi field has
 * many). An arbitrary tie-break would make the oracle's routes depend on
 * container iteration order, i.e. on the ns-3 build — the reproducibility
 * failure #352 was about, in a different guise. So the tie-break is part of
 * the contract: **among equal-cost shortest paths the one with the
 * numerically smallest first hop wins**, which makes the whole next-hop table
 * a pure function of the edge set.
 *
 * Weights are non-negative doubles; the oracle uses 1.0 per edge (hop count),
 * which is what makes "the oracle's hop count is a lower bound on every
 * protocol's" an assertion rather than an expectation.
 */
#ifndef ANTHOCNET_CORE_SHORTEST_PATH_H
#define ANTHOCNET_CORE_SHORTEST_PATH_H

#include <cstddef>
#include <limits>
#include <vector>

namespace anthocnet {
namespace core {

class ShortestPathGraph {
  public:
    /// Returned by firstHopTo() when there is no path (and for the source).
    static const int kNoNode = -1;
    /// Returned by distanceTo() when there is no path.
    static double unreachable() { return std::numeric_limits<double>::infinity(); }

    /// A graph over node ids [0, nodeCount).
    explicit ShortestPathGraph(int nodeCount);

    int nodeCount() const { return static_cast<int>(m_adj.size()); }

    /**
     * Add a DIRECTED edge. Callers modelling a bidirectional radio/ISL link
     * add both directions; the oracle does, because a one-way link is not a
     * usable route.
     *
     * Throws std::invalid_argument on an out-of-range endpoint or a negative
     * weight — both are caller bugs that would otherwise surface as a wrong
     * route rather than as a failure.
     */
    void addEdge(int from, int to, double weight = 1.0);

    /// Number of directed edges added (the oracle reports it as a diagnostic).
    std::size_t edgeCount() const { return m_edges; }

    /// Run Dijkstra from `source`. Results are readable until the next call.
    void computeFrom(int source);

    /// The source of the last computeFrom(), or kNoNode before the first.
    int source() const { return m_source; }

    /// Cost of the shortest path source -> node, or unreachable().
    double distanceTo(int node) const;

    /**
     * The node after `source` on the chosen shortest path to `node`:
     * kNoNode when unreachable, and kNoNode for the source itself (a node
     * needs no first hop to reach itself).
     */
    int firstHopTo(int node) const;

  private:
    struct Edge {
        int to;
        double weight;
    };

    std::vector<std::vector<Edge> > m_adj;
    std::vector<double> m_dist;
    std::vector<int> m_firstHop;
    std::size_t m_edges;
    int m_source;
};

}  // namespace core
}  // namespace anthocnet

#endif  // ANTHOCNET_CORE_SHORTEST_PATH_H
