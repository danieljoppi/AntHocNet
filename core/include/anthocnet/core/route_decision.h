/**
 * RouteDecision: the verb the algorithm hands back to an adapter.
 *
 * AntRouterLogic is pure: it never sends a packet or schedules a timer
 * itself. It returns RouteDecisions and the adapter carries them out against
 * its simulator (unicast to nextHop, link-layer broadcast, enqueue pending,
 * deliver to the local transport, or drop).
 */
#ifndef ANTHOCNET_CORE_ROUTE_DECISION_H
#define ANTHOCNET_CORE_ROUTE_DECISION_H

#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

enum class RouteAction {
    None,       ///< Nothing to do.
    Unicast,    ///< Send `message` to `nextHop`.
    Broadcast,  ///< Link-layer broadcast `message`.
    Queue,      ///< Hold the data packet pending a route to `nextHop`/dst.
    Deliver,    ///< Destination reached: hand to the local transport.
    Drop,       ///< Discard (loop, TTL, no route).
};

struct RouteDecision {
    RouteAction action  = RouteAction::None;
    NodeAddress nextHop = kInvalidAddress;
    bool        hasMessage = false;  ///< Whether `message` is populated.
    AntMessage  message;             ///< Ant to emit (Unicast/Broadcast).

    static RouteDecision drop() { return {RouteAction::Drop, kInvalidAddress, false, {}}; }
    static RouteDecision none() { return {RouteAction::None, kInvalidAddress, false, {}}; }
    static RouteDecision deliver() { return {RouteAction::Deliver, kInvalidAddress, false, {}}; }
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ROUTE_DECISION_H
