// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * ILinkMetric: the strategy that turns a backward ant's path observation into a
 * pheromone value (Eq.2). Extracting it from advanceBackAnt makes the pure core
 * the natural home for both the canonical metric and pluggable research metrics
 * (fuzzy / energy / QoS), selected by config, without touching the state machine
 * (item 16, ADR-0003).
 *
 * The metric must be pure: it reads only the observation, never the simulator,
 * clock, or RNG. Adapter-supplied signals (energy, SNR, queue occupancy) enter
 * through LinkObservation, keeping the core free of simulator dependencies.
 */
#ifndef ANTHOCNET_CORE_LINK_METRIC_H
#define ANTHOCNET_CORE_LINK_METRIC_H

#include <cmath>

namespace anthocnet {
namespace core {

/// What a backward ant knows about the path from this node to the destination.
/// Carries path aggregates and node-local signals only — never per-hop
/// downstream vectors (the wire carries one scalar cost per hop, ADR-0009).
struct LinkObservation {
    double hops = 0.0;      ///< hops to the destination; fractional once smoothed (#185).
    double pathTime = 0.0;  ///< accumulated time estimate (seconds, item 02).
    double hopTime = 0.0;   ///< config T_hop (seconds).
};

/// Maps an observation to a pheromone (goodness; higher == better).
struct ILinkMetric {
    virtual ~ILinkMetric() = default;
    virtual double pheromone(const LinkObservation& obs) const = 0;
    /// True when the metric's per-hop cost is a link-quality cost (#181) rather
    /// than a time. The router then has each node put its own estimate of the
    /// link it received a backward ant over into that hop of the retraced path
    /// (thesis §4.2.2: "the reactive backward ant reads at each node i the local
    /// estimate c_i^n of the cost to go from i to the next hop n"), and uses
    /// the same link cost wherever it adds one hop to a path.
    virtual bool usesLinkQuality() const { return false; }
};

/// The canonical AntHocNet metric (Eq.2): blend the path-time estimate with the
/// hop-count estimate and invert. Identical to the post-item-02 inline formula.
struct ClassicMetric : ILinkMetric {
    double pheromone(const LinkObservation& o) const override {
        return std::pow((o.pathTime + o.hops * o.hopTime) / 2.0, -1.0);
    }
};

/// The SINR metric (#181), the one the 2007 thesis used for every headline
/// result: "we normally use the signal-to-interference-and-noise ratio metric,
/// as this gave the best results" (§4.2.6). Each link costs 1 when its SINR is
/// above SINR_c and c_const otherwise (eq. 4.11, sinrLinkCost); a route costs
/// the sum over its links, carried as the hops' per-hop values; and the
/// pheromone is the inverse of that cost (eq. 4.3).
struct SinrMetric : ILinkMetric {
    double pheromone(const LinkObservation& o) const override {
        // Every hop costs at least 1, so the cost is never below the hop count.
        const double cost = o.pathTime > o.hops ? o.pathTime : o.hops;
        return cost > 0.0 ? 1.0 / cost : 0.0;
    }
    bool usesLinkQuality() const override { return true; }
};

/// Eq. 4.11: 1 for a link whose SINR is above `criticalDb`, `penalty` for one
/// at or below it. No sample (NaN) counts as a good link (ILinkQuality).
inline double sinrLinkCost(double sinrDb, double criticalDb, double penalty) {
    return (std::isnan(sinrDb) || sinrDb > criticalDb) ? 1.0 : penalty;
}

}  // namespace core
}  // namespace anthocnet

#endif  // ANTHOCNET_CORE_LINK_METRIC_H
