/**
 * Ports the simulator adapters implement.
 *
 * The core depends only on these interfaces, never on a concrete simulator.
 * NS-2 implements them over Scheduler/Random/Node; NS-3 over
 * Simulator::Now/UniformRandomVariable/Ipv4 interfaces.
 */
#ifndef ANTHOCNET_CORE_PORTS_H
#define ANTHOCNET_CORE_PORTS_H

#include <functional>
#include <vector>

#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

/// Source of simulation time (seconds).
class IClock {
public:
    virtual ~IClock() = default;
    virtual Time now() const = 0;
};

/// Source of randomness. All algorithm randomness routes through this so runs
/// are reproducible from the adapter's RNG stream (the original code called
/// the libc rand() directly).
class IRng {
public:
    virtual ~IRng() = default;
    /// Uniform double in [0, 1).
    virtual double uniform() = 0;
    /// Uniform integer in [0, n). Caller guarantees n > 0.
    virtual int uniformInt(int n) = 0;
};

/// Current set of one-hop neighbours, as seen by the link layer.
class INeighborProvider {
public:
    virtual ~INeighborProvider() = default;
    virtual std::vector<NodeAddress> neighbors() const = 0;
};

/// Deferred-execution port for periodic ant generation / table maintenance.
class ITimerScheduler {
public:
    virtual ~ITimerScheduler() = default;
    virtual void schedule(Time delay, std::function<void()> callback) = 0;
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_PORTS_H
