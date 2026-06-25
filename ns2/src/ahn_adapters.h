/*
 * NS-2 implementations of the core ports.
 *
 * IClock          -> Scheduler::instance().clock()
 * IRng            -> ns-2 Random / RNG stream
 * INeighborProvider -> the agent's pheromone-table neighbour view
 */
#ifndef ANTHOCNET_NS2_AHN_ADAPTERS_H
#define ANTHOCNET_NS2_AHN_ADAPTERS_H

#include "anthocnet/core/ports.h"

namespace anthocnet {
namespace ns2 {

/// Simulation clock backed by the NS-2 scheduler.
class Ns2Clock : public core::IClock {
public:
    core::Time now() const override;
};

/// Randomness backed by NS-2's Random facility (so runs follow the
/// simulation's configured RNG substream / seed).
class Ns2Rng : public core::IRng {
public:
    double uniform() override;
    int uniformInt(int n) override;
};

} // namespace ns2
} // namespace anthocnet

#endif // ANTHOCNET_NS2_AHN_ADAPTERS_H
