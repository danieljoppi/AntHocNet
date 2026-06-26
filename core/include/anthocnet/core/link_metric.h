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
    int    hops     = 0;    ///< hops from this node to the destination.
    double pathTime = 0.0;  ///< accumulated time estimate (seconds, item 02).
    double hopTime  = 0.0;  ///< config T_hop (seconds).
};

/// Maps an observation to a pheromone (goodness; higher == better).
struct ILinkMetric {
    virtual ~ILinkMetric() = default;
    virtual double pheromone(const LinkObservation& obs) const = 0;
};

/// The canonical AntHocNet metric (Eq.2): blend the path-time estimate with the
/// hop-count estimate and invert. Identical to the post-item-02 inline formula.
struct ClassicMetric : ILinkMetric {
    double pheromone(const LinkObservation& o) const override {
        return std::pow((o.pathTime + o.hops * o.hopTime) / 2.0, -1.0);
    }
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_LINK_METRIC_H
