/**
 * AntRouterLogic: the shared, simulator-agnostic AntHocNet state machine.
 *
 * This is the former AntNest + the decision parts of the AntHocNet agent,
 * with all NS-2 packet/scheduler coupling removed. It owns a node's routing
 * state (pheromone table, dedup history, sequence counter) and turns received
 * ants and local data demands into RouteDecisions for the adapter to execute.
 *
 * It is deliberately free of I/O: time and randomness come through ports, and
 * outputs are returned as values. That makes the routing behaviour identical
 * across NS-2 and NS-3 and testable on its own.
 */
#ifndef ANTHOCNET_CORE_ANT_ROUTER_LOGIC_H
#define ANTHOCNET_CORE_ANT_ROUTER_LOGIC_H

#include <map>
#include <vector>

#include "anthocnet/core/ant_history.h"
#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_engine.h"
#include "anthocnet/core/pheromone_table.h"
#include "anthocnet/core/ports.h"
#include "anthocnet/core/route_decision.h"
#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

class AntRouterLogic {
public:
    AntRouterLogic(NodeAddress address, const Config& config, IClock& clock, IRng& rng);

    NodeAddress address() const { return address_; }
    const Config& config() const { return config_; }
    PheromoneTable& table() { return table_; }
    const PheromoneTable& table() const { return table_; }
    PheromoneEngine& engine() { return engine_; }

    // --- neighbour learning ----------------------------------------------
    /// Record that `neighbor` is reachable (link-layer detection / hello),
    /// seeding an equal-weight regular pheromone entry as the legacy code did.
    void learnNeighbor(NodeAddress neighbor);
    void loseNeighbor(NodeAddress neighbor);

    /// Periodic liveness/maintenance tick (driven by the adapter hello timer):
    /// expire neighbours not heard from within helloInterval*allowedHelloLoss
    /// (the portable, NS-3-mandatory detector — ADR-0008) and return any
    /// link-failure notifications to broadcast.
    std::vector<RouteDecision> onMaintenanceTick();

    // --- active sessions (proactive monitoring, item 04) ------------------
    /// Record that this node just originated data for `dest`, making it an
    /// active session that proactive ants will monitor (call from the adapter
    /// data path when the packet is locally originated).
    void noteDataSession(NodeAddress dest);
    /// Destinations with data sent within `config_.sessionTtl` (const query).
    std::vector<NodeAddress> activeDestinations() const;
    /// One proactive forward ant per active destination (empty if none or if
    /// `!config_.enableProactive`). Also prunes expired sessions.
    std::vector<AntMessage> createProactiveAnts();

    // --- ant construction -------------------------------------------------
    AntMessage createForwardAnt(AntType type, NodeAddress dest);
    AntMessage createHelloAnt(std::size_t maxAdverts = 10);
    /// Build the backward ant for a forward ant that reached this node
    /// (this == dst). The returned message's `nextHop` is via firstBackHop().
    AntMessage createBackAnt(const AntMessage& forward);

    // --- routing primitives ----------------------------------------------
    /// Stochastic next hop for `dest` using the ant exponent betaAnts
    /// (kInvalidAddress if no route). Serves reactive and proactive ants.
    NodeAddress selectNextHop(NodeAddress dest, bool proactive);
    /// Stochastic next hop for a *data* packet, using the greedier data
    /// exponent betaData (kInvalidAddress if no route).
    NodeAddress nextHopForData(NodeAddress dest);
    /// Pick a random known destination for a proactive ant (or kInvalidAddress).
    NodeAddress randomDestination();

    /// Append this node to a forward ant's visited stack (trip time since the
    /// ant was generated). Bounded by Config::maxPathLength.
    void stampForward(AntMessage& ant) const;

    /// Advance a backward ant by one hop: pop the visited stack, push to
    /// history, recompute the pheromone estimate, and return the next hop.
    /// Mirrors AntBackPacket::findNextHop.
    NodeAddress advanceBackAnt(AntMessage& ant) const;

    /// Update the regular pheromone table from a backward ant that arrived
    /// here (reinforce the link it came from).
    void reinforceFromBackAnt(const AntMessage& ant);

    // --- consolidated receive --------------------------------------------
    /// Process a received ant arriving from `prevHop`. Performs (src,seq)
    /// dedup and neighbour learning, then dispatches by type/direction,
    /// returning the actions the adapter must carry out. May return an empty
    /// vector (nothing to do) or a single Drop.
    std::vector<RouteDecision> onReceiveAnt(const AntMessage& ant, NodeAddress prevHop);

    /// Decide what to do with a locally-originated or in-transit *data* packet
    /// destined for `dest`: route it (Unicast), or (no route) request one and
    /// Queue it. The adapter emits the returned reactive forward ant, if any.
    std::vector<RouteDecision> onDataPacket(NodeAddress dest);

private:
    std::uint32_t nextSeq() { return seqNum_++; }

    NodeAddress     address_;
    Config          config_;
    IClock&         clock_;
    IRng&           rng_;
    PheromoneTable  table_;
    PheromoneEngine engine_;
    AntHistoryTracker history_;
    std::uint32_t   seqNum_ = 0;
    std::map<NodeAddress, double> activeSessions_;  ///< dest -> last data-send time
    std::map<NodeAddress, double> lastSeen_;        ///< neighbor -> last reception time
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_ROUTER_LOGIC_H
