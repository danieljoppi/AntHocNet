// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

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

void PheromoneTable::removeNeighbor(NodeAddress neighbor) { neighborTable_.erase(neighbor); }

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

double PheromoneTable::bestVirtual(NodeAddress dest) const {
    double best = 0.0;
    for (NodeAddress neighbor : neighborTable_) {
        double ph = getPheromoneVirtual(dest, neighbor);
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

// #655: both functions below used to look every neighbour's pheromone up and
// raise it to beta twice -- once in the normaliser (the former sumProbability /
// sumMaxProbability) and again in the sampling loop. They now do it once, into
// a small buffer, and sum and sample from it. The floating-point operations
// and their order are exactly the old ones: the normaliser adds the same
// pow() values in neighbour order (skipping, for data, the neighbours with no
// regular entry, as sumProbability did), and the sampler subtracts the same
// pow(w)/phSum. Selection is therefore bit-identical, which the WASM parity
// and determinism gates check.
void PheromoneTable::selectionTerms(NodeAddress dest, bool isProactiveAnt, double beta,
                                    NodeAddress exclude, std::vector<Term>& terms,
                                    double& phSum) const {
    terms.clear();
    phSum = 0.0;
    for (NodeAddress neighbor : neighborTable_) {
        if (neighbor == exclude) continue;
        auto itR = pheromoneRegular_.find({neighbor, dest});
        const bool useR = itR != pheromoneRegular_.end();
        double phV = 0.0;
        bool hasV = false;
        if (isProactiveAnt) {
            auto itV = pheromoneVirtual_.find({neighbor, dest});
            hasV = itV != pheromoneVirtual_.end();
            if (hasV) phV = itV->second;
        }
        const double phR = useR ? itR->second : 0.0;
        const double p = std::pow(weighted(neighbor, phR > phV ? phR : phV), beta);
        // sumMaxProbability counted every neighbour; sumProbability only those
        // with a regular entry.
        if (isProactiveAnt || useR) phSum += p;
        terms.push_back({neighbor, p});
    }
}

NodeAddress PheromoneTable::nextNeighborNode(NodeAddress dest, bool isProactiveAnt, double beta,
                                             IRng& rng, NodeAddress exclude) const {
    // Unknown destination: no route. Data requires a regular entry; a proactive
    // ant may also route toward a purely-diffused (virtual-only) destination so
    // diffusion can extend reach (ADR-0007).
    const bool known = destRegular_.find(dest) != destRegular_.end() ||
                       (isProactiveAnt && destVirtual_.find(dest) != destVirtual_.end());
    if (!known) {
        return kInvalidAddress;
    }

    double phSum;
    selectionTerms(dest, isProactiveAnt, beta, exclude, terms_, phSum);
    if (phSum == 0.0) {
        // Excluding the previous hop left no route: rather than black-hole, fall
        // back to considering it (A1 "only option" rule).
        if (exclude != kInvalidAddress) {
            return nextNeighborNode(dest, isProactiveAnt, beta, rng, kInvalidAddress);
        }
        return kInvalidAddress;
    }

    double r = rng.uniform();
    NodeAddress chosen = kInvalidAddress;
    for (const Term& t : terms_) {
        chosen = t.neighbor;
        r -= t.pow / phSum;
        if (r <= 0.0) break;
    }
    return chosen;
}

std::vector<std::pair<NodeAddress, double>> PheromoneTable::nextHopDistribution(
    NodeAddress dest, bool isProactiveAnt, double beta, NodeAddress exclude) const {
    // Mirrors nextNeighborNode() term for term: the same known-destination
    // rule, the same normaliser, the same per-neighbour weight, the same A1
    // fallback -- so p_i is exactly the step the sampler subtracts from r.
    std::vector<std::pair<NodeAddress, double>> out;
    const bool known = destRegular_.find(dest) != destRegular_.end() ||
                       (isProactiveAnt && destVirtual_.find(dest) != destVirtual_.end());
    if (!known) return out;
    double phSum;
    std::vector<Term> terms;
    selectionTerms(dest, isProactiveAnt, beta, exclude, terms, phSum);
    if (phSum == 0.0) {
        if (exclude != kInvalidAddress) {
            return nextHopDistribution(dest, isProactiveAnt, beta, kInvalidAddress);
        }
        return out;
    }
    for (const Term& t : terms) {
        const double p = t.pow / phSum;
        if (p > 0.0) out.emplace_back(t.neighbor, p);
    }
    return out;
}

NodeAddress PheromoneTable::lookup(NodeAddress dest, double beta, IRng& rng,
                                   NodeAddress exclude) const {
    return nextNeighborNode(dest, false, beta, rng, exclude);
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

}  // namespace core
}  // namespace anthocnet
