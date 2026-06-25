/**
 * AntMessage: the simulator-agnostic, value-type representation of an ant.
 *
 * Both adapters convert their on-the-wire packet header to/from this struct
 * (see anthocnet/core/ant_message_codec.h for the canonical wire format), so
 * the algorithm never touches simulator memory directly.
 */
#ifndef ANTHOCNET_CORE_ANT_MESSAGE_H
#define ANTHOCNET_CORE_ANT_MESSAGE_H

#include <cstdint>
#include <vector>

#include "anthocnet/core/types.h"
#include "anthocnet/core/visited_path.h"

namespace anthocnet {
namespace core {

/// Ant role. Values match the legacy ANTTYPE* bit flags so existing traces
/// remain comparable.
enum class AntType : std::uint8_t {
    Hello     = 0x01,
    Reactive  = 0x02,
    Proactive = 0x04,
    Repair    = 0x08,
};

/// Travel direction. Up = forward (toward destination), Down = backward
/// (retracing the path to reinforce it).
enum class AntDirection : std::uint8_t {
    Up   = 0x11,
    Down = 0x12,
};

/// A (destination, pheromone) advert carried by a hello ant for building the
/// virtual pheromone table.
struct HelloDest {
    NodeAddress node      = kInvalidAddress;
    double      pheromone = 0.0;
};

/// Complete, copyable description of an ant packet.
struct AntMessage {
    AntType      type      = AntType::Reactive;
    AntDirection direction = AntDirection::Up;

    NodeAddress src = kInvalidAddress;  ///< Originating node.
    NodeAddress dst = kInvalidAddress;  ///< Final destination.

    /// Widened from the original u_int8_t so it does not wrap after 256 ants
    /// (which silently broke (src,seq) dedup on long runs).
    std::uint32_t seqNum = 0;

    double timeStart = 0.0;  ///< Generation time, for trip-time accounting.
    double lifeAnt   = 0.0;  ///< Repair-ant lifetime budget (seconds).

    VisitedPath visited;  ///< Forward stack: nodes seen on the way out.
    VisitedPath history;  ///< Back-ant stack: path being reinforced.

    std::vector<HelloDest> helloDests;  ///< Hello-ant adverts.

    // Fields computed while a backward ant retraces its path.
    NodeAddress prevHop   = kInvalidAddress;
    int         hops      = 0;
    double      prevSINR  = 0.0;
    double      pheromone = 0.0;

    bool isForward() const { return direction == AntDirection::Up; }
    bool isBackward() const { return direction == AntDirection::Down; }
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_MESSAGE_H
