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

    /// Best (largest) regular pheromone any neighbour holds for `dest`, or 0 if
    /// none. Used to advertise this node's path goodness in hello adverts.
    double bestRegular(NodeAddress dest) const;
    void setPheromoneRegular(NodeAddress dest, NodeAddress neighbor, double value);
    void setPheromoneVirtual(NodeAddress dest, NodeAddress neighbor, double value);

    bool isEmptyRegular() const { return pheromoneRegular_.empty(); }
    bool isEmptyVirtual() const { return pheromoneVirtual_.empty(); }

    /// Size gauge (issue #133): current (neighbor, dest) entry counts. The
    /// table grows with destinations x neighbours (regular + virtual) and only
    /// evaporation / link-failure removal shrink it, so adapters export these
    /// to observe growth over long runs. Read-only; no routing behaviour.
    std::size_t numEntriesRegular() const { return pheromoneRegular_.size(); }
    std::size_t numEntriesVirtual() const { return pheromoneVirtual_.size(); }
    std::size_t numEntries() const {
        return pheromoneRegular_.size() + pheromoneVirtual_.size();
    }

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
    /// `beta` is the Eq.1 exponent (caller passes betaAnts or betaData).
    /// `exclude` (e.g. the previous hop for data) is skipped unless it is the
    /// only option, so a packet isn't sent back the way it came (A1).
    /// Returns kInvalidAddress when no route exists.
    NodeAddress nextNeighborNode(NodeAddress dest, bool isProactiveAnt, double beta,
                                 IRng& rng, NodeAddress exclude = kInvalidAddress) const;

    /// Reactive lookup == nextNeighborNode(dest, false, beta).
    NodeAddress lookup(NodeAddress dest, double beta, IRng& rng,
                       NodeAddress exclude = kInvalidAddress) const;

    /// Uniformly pick a known regular destination, or kInvalidAddress if none.
    NodeAddress randomDestination(IRng& rng) const;

private:
    double sumProbability(const PheromoneMap& table, NodeAddress dest, double beta,
                          NodeAddress exclude) const;
    double sumMaxProbability(NodeAddress dest, double beta, NodeAddress exclude) const;

    PheromoneMap   pheromoneRegular_;
    PheromoneMap   pheromoneVirtual_;
    NeighborSet    neighborTable_;
    DestinationSet destRegular_;
    DestinationSet destVirtual_;
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_PHEROMONE_TABLE_H
