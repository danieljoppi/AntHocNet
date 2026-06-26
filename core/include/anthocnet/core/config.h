/**
 * Tunable AntHocNet parameters.
 *
 * These were compile-time constants in AntHocNetUtils (ALFA/BETA/GAMA/...).
 * Promoting them to a value type lets each adapter expose them as TCL binds
 * (NS-2) or TypeId attributes (NS-3) without touching the algorithm code.
 * The defaults reproduce the original constants.
 */
#ifndef ANTHOCNET_CORE_CONFIG_H
#define ANTHOCNET_CORE_CONFIG_H

#include <cstddef>

namespace anthocnet {
namespace core {

struct Config {
    /// Pheromone reinforcement / evaporation weights.
    double alpha = 0.7;  ///< ALFA: evaporation retains alpha of the value.
    double gamma = 0.7;  ///< GAMA: weight of the old value when reinforcing.

    /// Eq.1 exponents for the stochastic next-hop choice. Ants explore with a
    /// small exponent; data is greedy with a larger one (betaData >= betaAnts).
    double betaAnts = 2.0;   ///< BETA1: exponent for ant next-hop choice (exploratory).
    double betaData = 20.0;  ///< BETA2: exponent for data next-hop choice (greedy).

    /// Per-hop time estimate used by the back-ant pheromone formula (Eq.2):
    /// the time to take one hop in unloaded conditions. In seconds, matching
    /// IClock, so it is comparable in magnitude to the measured path time.
    double hopTimeSec = 0.05;  ///< HOP_TIME (50 ms)

    /// Links whose pheromone drops below this are pruned.
    double minPheromone = 0.00001;  ///< MIN_PHEROMONE

    /// Timer intervals (seconds).
    double helloInterval     = 1.0;
    double proactiveInterval = 10.0;
    double lifeAnt           = 2.0;

    /// Conservative upper bound on path length for the expanding-ring search.
    int networkDiameter = 30;

    /// Bound the visited-node stack carried in a packet, and the (src,seq)
    /// dedup history, so a long-running simulation cannot grow them without
    /// limit (a latent issue in the original fixed-size malloc arrays).
    std::size_t maxPathLength = 100;
    std::size_t maxHistory    = 4096;
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_CONFIG_H
