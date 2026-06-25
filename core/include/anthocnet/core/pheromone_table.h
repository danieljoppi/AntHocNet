/**
 * PheromoneTable: per-node routing state.
 *
 * Holds the regular and virtual pheromone maps keyed by (neighbor,
 * destination), the neighbour set, and the per-table destination sets. This
 * is a near-verbatim port of the original NS-2 class with two changes:
 *   - randomness is taken from an injected IRng (not libc rand());
 *   - the probabilistic selection helpers are const-correct and take the
 *     config so BETA is not a compile-time constant.
 */
#ifndef ANTHOCNET_CORE_PHEROMONE_TABLE_H
#define ANTHOCNET_CORE_PHEROMONE_TABLE_H

#include <map>
#include <set>
#include <utility>

#include "anthocnet/core/config.h"
#include "anthocnet/core/ports.h"
#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

class PheromoneTable {
public:
    using Key            = std::pair<NodeAddress, NodeAddress>;  // (neighbor, dest)
    using PheromoneMap   = std::map<Key, double>;
    using NeighborSet    = std::set<NodeAddress>;
    using DestinationSet = std::set<NodeAddress>;

    // --- entry management -------------------------------------------------
    void addPheromoneRegular(NodeAddress dest, NodeAddress neighbor, double value);
    void addPheromoneVirtual(NodeAddress dest, NodeAddress neighbor, double value);
    void removePheromoneRegular(NodeAddress dest, NodeAddress neighbor);
    void removePheromoneVirtual(NodeAddress dest, NodeAddress neighbor);
    double getPheromoneRegular(NodeAddress dest, NodeAddress neighbor) const;
    double getPheromoneVirtual(NodeAddress dest, NodeAddress neighbor) const;
    void setPheromoneRegular(NodeAddress dest, NodeAddress neighbor, double value);
    void setPheromoneVirtual(NodeAddress dest, NodeAddress neighbor, double value);

    bool isEmptyRegular() const { return pheromoneRegular_.empty(); }
    bool isEmptyVirtual() const { return pheromoneVirtual_.empty(); }

    // --- neighbour management --------------------------------------------
    void addNeighbor(NodeAddress neighbor);
    void removeNeighbor(NodeAddress neighbor);
    const NeighborSet& neighbors() const { return neighborTable_; }
    std::size_t numNeighbors() const { return neighborTable_.size(); }
    bool hasNeighbor() const { return !neighborTable_.empty(); }

    const DestinationSet& regularDestinations() const { return destRegular_; }
    const DestinationSet& virtualDestinations() const { return destVirtual_; }

    // --- routing ----------------------------------------------------------
    /// Stochastic next-hop choice. With isProactiveAnt the virtual table is
    /// blended in (max of regular/virtual); otherwise only regular is used.
    /// Returns kInvalidAddress when no route exists.
    NodeAddress nextNeighborNode(NodeAddress dest, bool isProactiveAnt, IRng& rng) const;

    /// Reactive lookup == nextNeighborNode(dest, false).
    NodeAddress lookup(NodeAddress dest, IRng& rng) const;

    /// Uniformly pick a known regular destination, or kInvalidAddress if none.
    NodeAddress randomDestination(IRng& rng) const;

private:
    double sumProbability(const PheromoneMap& table, NodeAddress dest) const;
    double sumMaxProbability(NodeAddress dest) const;

    PheromoneMap   pheromoneRegular_;
    PheromoneMap   pheromoneVirtual_;
    NeighborSet    neighborTable_;
    DestinationSet destRegular_;
    DestinationSet destVirtual_;
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_PHEROMONE_TABLE_H
