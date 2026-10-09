// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "anthocnet/core/pheromone_engine.h"

#include <cmath>
#include <vector>

namespace anthocnet {
namespace core {

double PheromoneEngine::evaporate(double phValue) const {
    return phValue - (1.0 - config_.alpha) * phValue;
}

double PheromoneEngine::reinforce(double phValue, double phUpdate) const {
    return config_.gamma * phValue + (1.0 - config_.gamma) * phUpdate;
}

bool PheromoneEngine::hasRegularDestination(const PheromoneTable& table, NodeAddress dest) const {
    for (NodeAddress neighbor : table.neighbors()) {
        if (table.getPheromoneRegular(dest, neighbor) > config_.minPheromone) return true;
    }
    return false;
}

void PheromoneEngine::updateRegular(PheromoneTable& table, NodeAddress dest,
                                    NodeAddress neighbor, double phUpdate) const {
    // Reinforce only the travelled link. All aging is single-sourced into the
    // periodic, time-proportional evaporateAll (ADR-0012) — reinforcing no
    // longer ages competitors, which removes the reinforce-and-age coupling.
    const double phValue = table.getPheromoneRegular(dest, neighbor);
    table.setPheromoneRegular(dest, neighbor, reinforce(phValue, phUpdate));
}

void PheromoneEngine::evaporateAll(PheromoneTable& table, double dtSeconds) const {
    if (dtSeconds <= 0.0 || config_.evaporationInterval <= 0.0) return;
    // Time-proportional retention: alpha per evaporationInterval, scaled by the
    // actual elapsed time so the same tick that expires neighbours can age.
    const double factor = std::pow(config_.alpha, dtSeconds / config_.evaporationInterval);

    const std::vector<NodeAddress> dests(table.regularDestinations().begin(),
                                         table.regularDestinations().end());
    for (NodeAddress dest : dests) {
        const std::vector<NodeAddress> neighbors(table.neighbors().begin(),
                                                 table.neighbors().end());
        for (NodeAddress n : neighbors) {
            const double ph = table.getPheromoneRegular(dest, n);
            if (ph <= 0.0) continue;
            const double aged = ph * factor;
            if (aged < config_.minPheromone) {
                table.removePheromoneRegular(dest, n);
            } else {
                table.setPheromoneRegular(dest, n, aged);
            }
        }
    }

    // Virtual pheromone ages here too, on the identical clock (#262). The
    // thesis defines no virtual aging at all — per-hello replacement plus
    // eviction on neighbour loss — so any decay is our extension, and it must
    // at least be commensurable with the regular table: every virtual-vs-
    // regular comparison (the #180/#252 emission gate included) assumes the
    // two are in the same units. The old per-hello whole-table decay aged at
    // alpha^degree per second, a rate set by topology, not time.
    const std::vector<NodeAddress> vdests(table.virtualDestinations().begin(),
                                          table.virtualDestinations().end());
    for (NodeAddress dest : vdests) {
        const std::vector<NodeAddress> neighbors(table.neighbors().begin(),
                                                 table.neighbors().end());
        for (NodeAddress n : neighbors) {
            const double ph = table.getPheromoneVirtual(dest, n);
            if (ph <= 0.0) continue;
            const double aged = ph * factor;
            if (aged < config_.minPheromone) {
                table.removePheromoneVirtual(dest, n);
            } else {
                table.setPheromoneVirtual(dest, n, aged);
            }
        }
    }
}

void PheromoneEngine::updateVirtual(PheromoneTable& table, const AntMessage& hello) const {
    // Diffusion gated off (ADR-0007): keep the virtual table empty so proactive
    // selection degenerates to the regular-only sum.
    if (!config_.enableProactive || !config_.enableDiffusion) return;

    // Reinforce the destinations this hello advertised, via its sender. The
    // advert is the neighbour's best pheromone (an inverse cost) to advert.node;
    // bootstrap it for *this* node by adding one hop of cost, then re-inverting,
    // so a farther/worse advertised path yields a smaller virtual pheromone — a
    // real gradient, in the same units as regular pheromone (item 02/03).
    const NodeAddress neighbor = hello.src;
    for (const HelloDest& advert : hello.helloDests) {
        const double bootstrapped = (advert.pheromone > 0.0)
            ? 1.0 / (1.0 / advert.pheromone + config_.hopTimeSec)
            : 0.0;
        double phValue = table.getPheromoneVirtual(advert.node, neighbor);
        table.setPheromoneVirtual(advert.node, neighbor, reinforce(phValue, bootstrapped));
    }
}

void PheromoneEngine::cleanNeighbor(PheromoneTable& table, NodeAddress neighbor) const {
    cleanNeighbor(table, neighbor, true);
    cleanNeighbor(table, neighbor, false);
    table.removeNeighbor(neighbor);
}

void PheromoneEngine::cleanNeighbor(PheromoneTable& table, NodeAddress neighbor, bool regular) const {
    const std::vector<NodeAddress> dests(
        regular ? std::vector<NodeAddress>(table.regularDestinations().begin(),
                                           table.regularDestinations().end())
                : std::vector<NodeAddress>(table.virtualDestinations().begin(),
                                           table.virtualDestinations().end()));

    for (NodeAddress dest : dests) {
        if (regular) {
            if (table.getPheromoneRegular(dest, neighbor) < config_.minPheromone) continue;
            table.removePheromoneRegular(dest, neighbor);
        } else {
            if (table.getPheromoneVirtual(dest, neighbor) < config_.minPheromone) continue;
            table.removePheromoneVirtual(dest, neighbor);
        }
    }
}

} // namespace core
} // namespace anthocnet
