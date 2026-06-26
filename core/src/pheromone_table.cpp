#include "anthocnet/core/pheromone_table.h"

#include <cmath>

namespace anthocnet {
namespace core {

void PheromoneTable::addNeighbor(NodeAddress neighbor) {
    // Insert only if absent (std::set handles that), and seed the destination
    // sets so the neighbour is itself reachable.
    neighborTable_.insert(neighbor);
    destRegular_.insert(neighbor);
    destVirtual_.insert(neighbor);
}

void PheromoneTable::removeNeighbor(NodeAddress neighbor) {
    neighborTable_.erase(neighbor);
}

void PheromoneTable::addPheromoneRegular(NodeAddress dest, NodeAddress neighbor, double value) {
    destRegular_.insert(dest);
    pheromoneRegular_[{neighbor, dest}] = value;
}

void PheromoneTable::addPheromoneVirtual(NodeAddress dest, NodeAddress neighbor, double value) {
    destVirtual_.insert(dest);
    pheromoneVirtual_[{neighbor, dest}] = value;
}

void PheromoneTable::removePheromoneRegular(NodeAddress dest, NodeAddress neighbor) {
    pheromoneRegular_.erase({neighbor, dest});
}

void PheromoneTable::removePheromoneVirtual(NodeAddress dest, NodeAddress neighbor) {
    pheromoneVirtual_.erase({neighbor, dest});
}

double PheromoneTable::getPheromoneRegular(NodeAddress dest, NodeAddress neighbor) const {
    auto it = pheromoneRegular_.find({neighbor, dest});
    return it != pheromoneRegular_.end() ? it->second : 0.0;
}

double PheromoneTable::getPheromoneVirtual(NodeAddress dest, NodeAddress neighbor) const {
    auto it = pheromoneVirtual_.find({neighbor, dest});
    return it != pheromoneVirtual_.end() ? it->second : 0.0;
}

double PheromoneTable::bestRegular(NodeAddress dest) const {
    double best = 0.0;
    for (NodeAddress neighbor : neighborTable_) {
        double ph = getPheromoneRegular(dest, neighbor);
        if (ph > best) best = ph;
    }
    return best;
}

void PheromoneTable::setPheromoneRegular(NodeAddress dest, NodeAddress neighbor, double value) {
    destRegular_.insert(dest);
    addNeighbor(neighbor);
    pheromoneRegular_[{neighbor, dest}] = value;
}

void PheromoneTable::setPheromoneVirtual(NodeAddress dest, NodeAddress neighbor, double value) {
    destVirtual_.insert(dest);
    pheromoneVirtual_[{neighbor, dest}] = value;
}

double PheromoneTable::sumProbability(const PheromoneMap& table, NodeAddress dest,
                                      double beta) const {
    double sum = 0.0;
    for (NodeAddress neighbor : neighborTable_) {
        auto it = table.find({neighbor, dest});
        if (it == table.end()) continue;
        sum += std::pow(it->second, beta);
    }
    return sum;
}

double PheromoneTable::sumMaxProbability(NodeAddress dest, double beta) const {
    double sum = 0.0;
    for (NodeAddress neighbor : neighborTable_) {
        auto itR = pheromoneRegular_.find({neighbor, dest});
        auto itV = pheromoneVirtual_.find({neighbor, dest});
        double phR = itR != pheromoneRegular_.end() ? itR->second : 0.0;
        double phV = itV != pheromoneVirtual_.end() ? itV->second : 0.0;
        sum += std::pow(phR > phV ? phR : phV, beta);
    }
    return sum;
}

NodeAddress PheromoneTable::nextNeighborNode(NodeAddress dest, bool isProactiveAnt,
                                             double beta, IRng& rng) const {
    // Unknown destination: no route. Data requires a regular entry; a proactive
    // ant may also route toward a purely-diffused (virtual-only) destination so
    // diffusion can extend reach (ADR-0007).
    const bool known = destRegular_.find(dest) != destRegular_.end() ||
                       (isProactiveAnt && destVirtual_.find(dest) != destVirtual_.end());
    if (!known) {
        return kInvalidAddress;
    }

    const double phSum = isProactiveAnt ? sumMaxProbability(dest, beta)
                                        : sumProbability(pheromoneRegular_, dest, beta);
    if (phSum == 0.0) {
        return kInvalidAddress;
    }

    double r = rng.uniform();
    NodeAddress chosen = kInvalidAddress;
    for (NodeAddress neighbor : neighborTable_) {
        auto itR = pheromoneRegular_.find({neighbor, dest});
        auto itV = pheromoneVirtual_.find({neighbor, dest});
        bool useR = itR != pheromoneRegular_.end();
        bool useV = (itV != pheromoneVirtual_.end()) && isProactiveAnt;
        double phR = useR ? itR->second : 0.0;
        double phV = useV ? itV->second : 0.0;

        chosen = neighbor;
        double weight = phR > phV ? phR : phV;
        r -= std::pow(weight, beta) / phSum;
        if (r <= 0.0) break;
    }
    return chosen;
}

NodeAddress PheromoneTable::lookup(NodeAddress dest, double beta, IRng& rng) const {
    return nextNeighborNode(dest, false, beta, rng);
}

NodeAddress PheromoneTable::randomDestination(IRng& rng) const {
    const std::size_t size = destRegular_.size();
    if (size == 0) return kInvalidAddress;

    // Uniform draw: each entry has weight 1/size.
    double r = rng.uniform();
    const double step = 1.0 / static_cast<double>(size);
    NodeAddress dest = kInvalidAddress;
    for (NodeAddress d : destRegular_) {
        dest = d;
        r -= step;
        if (r <= 0.0) break;
    }
    return dest;
}

} // namespace core
} // namespace anthocnet
