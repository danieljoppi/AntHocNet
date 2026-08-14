// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "anthocnet/core/shortest_path.h"

#include <queue>
#include <stdexcept>
#include <utility>

namespace anthocnet {
namespace core {

const int ShortestPathGraph::kNoNode;

ShortestPathGraph::ShortestPathGraph(int nodeCount)
    : m_adj(nodeCount < 0 ? 0 : static_cast<std::size_t>(nodeCount)),
      m_dist(nodeCount < 0 ? 0 : static_cast<std::size_t>(nodeCount), unreachable()),
      m_firstHop(nodeCount < 0 ? 0 : static_cast<std::size_t>(nodeCount), kNoNode),
      m_edges(0),
      m_source(kNoNode) {
    if (nodeCount < 0) throw std::invalid_argument("shortest_path: negative nodeCount");
}

void ShortestPathGraph::addEdge(int from, int to, double weight) {
    if (from < 0 || from >= nodeCount() || to < 0 || to >= nodeCount())
        throw std::invalid_argument("shortest_path: edge endpoint out of range");
    if (!(weight >= 0.0)) throw std::invalid_argument("shortest_path: negative edge weight");
    Edge e;
    e.to = to;
    e.weight = weight;
    m_adj[static_cast<std::size_t>(from)].push_back(e);
    ++m_edges;
}

void ShortestPathGraph::computeFrom(int source) {
    if (source < 0 || source >= nodeCount())
        throw std::invalid_argument("shortest_path: source out of range");
    m_source = source;
    const std::size_t n = m_adj.size();
    m_dist.assign(n, unreachable());
    m_firstHop.assign(n, kNoNode);

    // (distance, node); std::greater turns the max-heap into a min-heap.
    typedef std::pair<double, int> QItem;
    std::priority_queue<QItem, std::vector<QItem>, std::greater<QItem> > pq;
    m_dist[static_cast<std::size_t>(source)] = 0.0;
    pq.push(QItem(0.0, source));

    while (!pq.empty()) {
        const QItem top = pq.top();
        pq.pop();
        const int u = top.second;
        // Stale entry: a strictly better distance for u was settled after this
        // one was pushed. An entry with the SAME distance is not stale — it can
        // still carry a smaller first hop (the tie-break below), which has to
        // propagate onwards.
        if (top.first > m_dist[static_cast<std::size_t>(u)]) continue;
        const std::vector<Edge>& out = m_adj[static_cast<std::size_t>(u)];
        for (std::size_t i = 0; i < out.size(); ++i) {
            const int v = out[i].to;
            // A node needs no first hop to reach itself, and a zero-weight
            // edge back into the source would otherwise install one.
            if (v == source) continue;
            const double cand = m_dist[static_cast<std::size_t>(u)] + out[i].weight;
            // The first hop this relaxation would give v: v itself when the
            // edge leaves the source, otherwise whatever u already uses.
            const int candHop = (u == source) ? v : m_firstHop[static_cast<std::size_t>(u)];
            if (candHop == kNoNode) continue;  // unreachable predecessor
            const double have = m_dist[static_cast<std::size_t>(v)];
            const int haveHop = m_firstHop[static_cast<std::size_t>(v)];
            // Strictly shorter, or the same length with a smaller first hop —
            // the documented canonical tie-break. Each accepted relaxation
            // strictly decreases (dist, firstHop) lexicographically for v, so
            // the loop terminates.
            const bool better = cand < have ||
                                (cand == have && (haveHop == kNoNode || candHop < haveHop));
            if (!better) continue;
            m_dist[static_cast<std::size_t>(v)] = cand;
            m_firstHop[static_cast<std::size_t>(v)] = candHop;
            pq.push(QItem(cand, v));
        }
    }
}

double ShortestPathGraph::distanceTo(int node) const {
    if (node < 0 || node >= nodeCount()) return unreachable();
    return m_dist[static_cast<std::size_t>(node)];
}

int ShortestPathGraph::firstHopTo(int node) const {
    if (node < 0 || node >= nodeCount()) return kNoNode;
    return m_firstHop[static_cast<std::size_t>(node)];
}

}  // namespace core
}  // namespace anthocnet
