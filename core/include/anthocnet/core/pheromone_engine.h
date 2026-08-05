// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * PheromoneEngine: the reinforcement / evaporation math, lifted out of the
 * NS-2 AntNest class so both simulators share identical routing dynamics.
 *
 * Operates on a PheromoneTable by reference; carries no simulator state.
 */
#ifndef ANTHOCNET_CORE_PHEROMONE_ENGINE_H
#define ANTHOCNET_CORE_PHEROMONE_ENGINE_H

#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_table.h"
#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

class PheromoneEngine {
public:
    explicit PheromoneEngine(const Config& config) : config_(config) {}

    /// phValue - (1 - alpha) * phValue
    double evaporate(double phValue) const;
    /// gamma * phValue + (1 - gamma) * phUpdate
    double reinforce(double phValue, double phUpdate) const;

    /// Reinforce the (dest, neighbor) regular link travelled by an ant. Aging
    /// of other links is handled separately by evaporateAll (ADR-0012).
    void updateRegular(PheromoneTable& table, NodeAddress dest,
                       NodeAddress neighbor, double phUpdate) const;

    /// Time-proportional aging of every regular AND virtual link by
    /// alpha^(dt/interval), pruning links below minPheromone. Driven by the
    /// maintenance tick. One clock for both tables (#262) keeps them
    /// commensurable for virtual-vs-regular comparisons.
    void evaporateAll(PheromoneTable& table, double dtSeconds) const;

    /// Reinforce the virtual links advertised by a hello. Aging is handled by
    /// evaporateAll, same as the regular table (#262).
    void updateVirtual(PheromoneTable& table, const AntMessage& hello) const;

    /// Prune a vanished neighbour from both tables.
    void cleanNeighbor(PheromoneTable& table, NodeAddress neighbor) const;

    /// True if any neighbour still holds usable pheromone for this dest.
    bool hasRegularDestination(const PheromoneTable& table, NodeAddress dest) const;

private:
    void cleanNeighbor(PheromoneTable& table, NodeAddress neighbor, bool regular) const;

    const Config config_;
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_PHEROMONE_ENGINE_H
