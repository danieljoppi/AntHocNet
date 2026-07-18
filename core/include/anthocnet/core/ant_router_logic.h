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
#include "anthocnet/core/link_metric.h"
#include "anthocnet/core/pheromone_engine.h"
#include "anthocnet/core/pheromone_table.h"
#include "anthocnet/core/ports.h"
#include "anthocnet/core/route_decision.h"
#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

class AntRouterLogic {
public:
    /// `metric` selects the pheromone formula (item 16); nullptr uses the
    /// canonical ClassicMetric. `linkState` supplies MAC-layer congestion
    /// signals for the item-10/A2 metric (nullptr => wall-clock per-hop time).
    /// Both default to null, so existing adapter call sites are unchanged.
    AntRouterLogic(NodeAddress address, const Config& config, IClock& clock, IRng& rng,
                   const ILinkMetric* metric = nullptr,
                   const ILinkState* linkState = nullptr);

    NodeAddress address() const { return address_; }
    const Config& config() const { return config_; }
    PheromoneTable& table() { return table_; }
    const PheromoneTable& table() const { return table_; }
    PheromoneEngine& engine() { return engine_; }

    // --- observability (item 15) -----------------------------------------
    /// Attach an optional observer for ant/route events (nullptr to detach).
    /// Zero-overhead when unset; the observer only reports, never decides.
    void setObserver(IRouterObserver* observer) { observer_ = observer; }
    /// Ants of `type` this node has put on the medium (origination + forward).
    std::uint64_t antsSent(AntType type) const;
    /// Non-duplicate ants of `type` this node has received and processed.
    std::uint64_t antsReceived(AntType type) const;
    /// Total ant control packets sent across all types (routing overhead).
    std::uint64_t controlPacketsSent() const;
    /// LinkFail notes this node re-broadcast on another reporter's behalf
    /// (issue #20: origins = antsSent(LinkFail) − propagations).
    std::uint64_t linkfailPropagations() const { return linkfailPropagations_; }
    /// LinkFail propagations suppressed by an exhausted inherited
    /// broadcastBudget — how often the depth bound actually bites (issue #20).
    std::uint64_t linkfailBudgetDrops() const { return linkfailBudgetDrops_; }
    /// Per-destination advertisements dropped by the origin cooldown
    /// (config.linkfailNotifyInterval, issue #20).
    std::uint64_t linkfailOriginsSuppressed() const { return linkfailOriginsSuppressed_; }

    // --- neighbour learning ----------------------------------------------
    /// Record that `neighbor` is reachable (link-layer detection / hello),
    /// seeding an equal-weight regular pheromone entry as the legacy code did.
    void learnNeighbor(NodeAddress neighbor);
    void loseNeighbor(NodeAddress neighbor);

    /// Periodic liveness/maintenance tick (driven by the adapter hello timer):
    /// expire neighbours not heard from within helloInterval*allowedHelloLoss
    /// (the portable, NS-3-mandatory detector — ADR-0008) and return any
    /// link-failure notifications to broadcast. Also expires timed-out local
    /// repairs ([1] §3.5, D6): a repair with no backward ant within its wait
    /// window yields a DiscardPending for the destination's buffered packets
    /// plus a LinkFail notification.
    std::vector<RouteDecision> onMaintenanceTick();

    /// Remove neighbour `n` and, for every destination whose best path it
    /// carried, broadcast a LinkFail notification with the new best (0 if the
    /// route is gone). Used by both the maintenance tick and an adapter's
    /// MAC transmit-failure hook (ADR-0008 detectors A and D converge here).
    std::vector<RouteDecision> reportNeighborLoss(NodeAddress n);

    /// Adapter MAC transmit-failure hook (ADR-0008 detector D): a failed unicast
    /// to `next` means the link is down. Prune the neighbour (emitting any
    /// LinkFail notifications, exactly as detector A does) and, when the failed
    /// packet was *data* (`dataDest` set), broadcast a bounded, counted local
    /// repair ant toward it so the route is rebuilt immediately ([1] §3.5).
    /// Mirrors the NS-2 `ahn_router` linkFailed path; both adapters call this.
    std::vector<RouteDecision> reportTxFailure(NodeAddress next,
                                               NodeAddress dataDest = kInvalidAddress);

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
    /// exponent betaData (kInvalidAddress if no route). `prevHop` is excluded
    /// unless it is the only option, to suppress data loops (A1).
    NodeAddress nextHopForData(NodeAddress dest, NodeAddress prevHop = kInvalidAddress);
    /// Pick a random known destination for a proactive ant (or kInvalidAddress).
    NodeAddress randomDestination();

    /// Append this node to a forward ant's visited stack, recording this hop's
    /// cost (congestion-aware MAC estimate when enabled, else wall-clock delta).
    /// Bounded by Config::maxPathLength.
    void stampForward(AntMessage& ant) const;

    /// Advance a backward ant by one hop: move this node from the visited stack
    /// onto `history` and return the next hop (path management only; the deposit
    /// state is reconstructed at the receiver from `history`, ADR-0009).
    NodeAddress advanceBackAnt(AntMessage& ant) const;

    /// Pheromone this back ant would deposit at the current node, reconstructed
    /// from its `history` (hops + summed per-hop times) via the link metric.
    double backAntPheromone(const AntMessage& ant) const;

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
    std::vector<RouteDecision> onDataPacket(NodeAddress dest,
                                            NodeAddress prevHop = kInvalidAddress);

private:
    std::uint32_t nextSeq() { return seqNum_++; }

    /// Turn a forward/notification ant into a Broadcast decision, honouring its
    /// broadcastBudget: an untracked ant (-1) always broadcasts; a budgeted ant
    /// decrements and broadcasts while >0, and is Dropped once exhausted.
    RouteDecision broadcastForward(AntMessage& ant);
    /// Build a Unicast/Broadcast decision carrying `ant`, counting it as sent
    /// and notifying the observer (the single choke point for ant emission).
    RouteDecision sendAnt(RouteAction action, NodeAddress nextHop, const AntMessage& ant);
    /// Apply a received LinkFail notification and, if it costs this node its own
    /// best path, return a bounded propagated notification.
    std::vector<RouteDecision> handleLinkFail(const AntMessage& note, NodeAddress reporter);

    /// Fill the transient deposit state (prevHop/hops/pathTime/pheromone) of a
    /// received backward ant from its `history`, before reinforcement.
    void computeBackAntState(AntMessage& ant) const;

    /// This node's contribution to a forward ant's path-time estimate: the
    /// congestion-aware MAC cost (Q_mac+1)*T̂_mac when enabled and available,
    /// else the ant's wall-clock transit delta since the previous stamp.
    double localHopCost(const AntMessage& ant) const;

    NodeAddress     address_;
    Config          config_;
    IClock&         clock_;
    IRng&           rng_;
    PheromoneTable  table_;
    PheromoneEngine engine_;
    ClassicMetric   defaultMetric_;        ///< used when no metric is injected
    const ILinkMetric* metric_;            ///< pheromone strategy (item 16)
    const ILinkState* linkState_;          ///< MAC congestion signals (item 10/A2), optional
    AntHistoryTracker history_;
    std::uint32_t   seqNum_ = 0;
    std::map<NodeAddress, double> activeSessions_;  ///< dest -> last data-send time
    std::map<NodeAddress, double> lastSeen_;        ///< neighbor -> last reception time
    std::map<NodeAddress, double> lastReactive_;    ///< dest -> last reactive-ant time
    std::map<NodeAddress, double> lastRepair_;      ///< dest -> last repair-ant time
    std::map<NodeAddress, double> repairDeadline_;  ///< dest -> repair wait expiry (D6)
    std::map<NodeAddress, int>    txFailures_;      ///< next hop -> consecutive MAC tx-failures (detector D debounce)
    double lastEvaporation_ = 0.0;                  ///< last evaporateAll time

    IRouterObserver* observer_ = nullptr;           ///< optional, item 15
    std::map<AntType, std::uint64_t> antsSent_;     ///< sent counters by type
    std::map<AntType, std::uint64_t> antsReceived_; ///< received counters by type
    std::uint64_t linkfailPropagations_ = 0;        ///< re-broadcast LinkFails (issue #20)
    std::uint64_t linkfailBudgetDrops_  = 0;        ///< budget-suppressed propagations (issue #20)
    std::uint64_t linkfailOriginsSuppressed_ = 0;   ///< cooldown-suppressed advertisements (issue #20)
    std::map<NodeAddress, double> lastLinkfailNotify_;  ///< dest -> last originated LinkFail time
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_ROUTER_LOGIC_H
