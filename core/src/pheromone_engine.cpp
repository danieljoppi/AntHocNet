#include "anthocnet/core/pheromone_engine.h"

#include <set>
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

bool PheromoneEngine::hasVirtualDestination(const PheromoneTable& table, NodeAddress dest) const {
    for (NodeAddress neighbor : table.neighbors()) {
        if (table.getPheromoneVirtual(dest, neighbor) > config_.minPheromone) return true;
    }
    return false;
}

void PheromoneEngine::updateRegular(PheromoneTable& table, NodeAddress dest,
                                    NodeAddress neighbor, double phUpdate) const {
    bool destVanished = false;

    // Snapshot neighbours: setPheromoneRegular can mutate the neighbour set.
    const std::vector<NodeAddress> neighbors(table.neighbors().begin(), table.neighbors().end());

    for (NodeAddress n : neighbors) {
        double phValue = table.getPheromoneRegular(dest, n);

        if (n == neighbor) {
            // Reinforce the link the ant travelled.
            table.setPheromoneRegular(dest, neighbor, reinforce(phValue, phUpdate));
        } else if (phValue > 0.0) {
            if (phValue < config_.minPheromone) {
                // BUGFIX: the original evaporated/removed `neighbor` (the
                // travelled link) here instead of `n` (the link actually being
                // aged), so competing links never decayed. Operate on `n`.
                table.removePheromoneRegular(dest, n);
                if (!hasRegularDestination(table, dest)) destVanished = true;
            } else {
                table.setPheromoneRegular(dest, n, evaporate(phValue));
            }
        }
    }

    if (destVanished) {
        for (NodeAddress n : neighbors) {
            table.removePheromoneRegular(dest, n);
        }
        if (table.neighbors().find(dest) != table.neighbors().end()) {
            table.removeNeighbor(dest);
        }
    }
}

void PheromoneEngine::updateVirtual(PheromoneTable& table, const AntMessage& hello) const {
    // Diffusion gated off (ADR-0007): keep the virtual table empty so proactive
    // selection degenerates to the regular-only sum.
    if (!config_.enableProactive || !config_.enableDiffusion) return;

    std::set<NodeAddress> destsRem;

    // Evaporate every virtual link; prune those that fall below the floor.
    const std::vector<NodeAddress> dests(table.virtualDestinations().begin(),
                                         table.virtualDestinations().end());
    for (NodeAddress dest : dests) {
        const std::vector<NodeAddress> neighbors(table.neighbors().begin(),
                                                 table.neighbors().end());
        for (NodeAddress neighbor : neighbors) {
            double phValue = table.getPheromoneVirtual(dest, neighbor);
            if (phValue < config_.minPheromone) {
                table.removePheromoneVirtual(dest, neighbor);
                if (!hasVirtualDestination(table, dest)) destsRem.insert(dest);
            } else {
                table.setPheromoneVirtual(dest, neighbor, evaporate(phValue));
            }
        }
    }

    for (NodeAddress dest : destsRem) {
        const std::vector<NodeAddress> neighbors(table.neighbors().begin(),
                                                 table.neighbors().end());
        for (NodeAddress neighbor : neighbors) {
            table.removePheromoneVirtual(dest, neighbor);
        }
    }

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
