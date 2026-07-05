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

#include "anthocnet/core/ant_message.h"
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

/// Node-local MAC-layer signals for the congestion-aware per-hop metric
/// (item 10/A2, [1] §3.2). Advisory *measurement* only: the adapter owns the
/// MAC, so it measures; the core turns these into a per-hop cost. Optional —
/// when no ILinkState is injected (or the feature is gated off) the core falls
/// back to the forward ant's wall-clock transit time, i.e. unchanged behaviour.
class ILinkState {
public:
    virtual ~ILinkState() = default;
    /// Packets currently queued for transmission at this node's interface (those
    /// a newly-enqueued packet would wait behind). Returns >= 0; negative is
    /// treated as 0.
    virtual int macQueueLength() const = 0;
    /// Smoothed per-packet MAC service time (seconds): a running average of the
    /// time from a packet reaching the head of the interface queue to a
    /// successful transmission, including contention/retransmission. Returns
    /// <= 0 when no sample has been observed yet (the core then uses the
    /// unloaded reference hop time for that hop).
    virtual Time macServiceTime() const = 0;
};

/// Optional observer the core notifies of routing events (item 15). It only
/// *reports* — it never makes routing decisions or does I/O, so the core stays
/// pure. Adapters implement it to fan events out to their native trace
/// machinery (ns-3 TracedCallback, ns-2 trace lines). All methods default to
/// no-ops; when no observer is set the core pays only a null-pointer check.
class IRouterObserver {
public:
    virtual ~IRouterObserver() = default;
    /// This node put an ant on the medium (origination or forwarding).
    virtual void onAntSent(AntType /*type*/, AntDirection /*dir*/, bool /*broadcast*/) {}
    /// This node processed a (non-duplicate) received ant.
    virtual void onAntReceived(AntType /*type*/, AntDirection /*dir*/) {}
    /// A neighbour/route entry was added (true) or removed (false).
    virtual void onRouteChanged(NodeAddress /*dest*/, NodeAddress /*nb*/, bool /*added*/) {}
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_PORTS_H
