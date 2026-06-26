#include "anthocnet/core/ant_router_logic.h"

#include <cmath>

namespace anthocnet {
namespace core {

AntRouterLogic::AntRouterLogic(NodeAddress address, const Config& config, IClock& clock, IRng& rng)
    : address_(address),
      config_(config),
      clock_(clock),
      rng_(rng),
      engine_(config_),
      history_(config_.maxHistory) {}

// --- neighbour learning -----------------------------------------------------

void AntRouterLogic::learnNeighbor(NodeAddress neighbor) {
    if (neighbor == address_ || neighbor == kInvalidAddress) return;
    table_.addNeighbor(neighbor);
    // Seed an equal-weight regular entry, as the legacy recvAHN did.
    engine_.updateRegular(table_, neighbor, neighbor, 1.0);
}

void AntRouterLogic::loseNeighbor(NodeAddress neighbor) {
    engine_.cleanNeighbor(table_, neighbor);
}

// --- ant construction -------------------------------------------------------

AntMessage AntRouterLogic::createForwardAnt(AntType type, NodeAddress dest) {
    AntMessage m;
    m.type      = type;
    m.direction = AntDirection::Up;
    m.src       = address_;
    m.dst       = dest;
    m.seqNum    = nextSeq();
    m.timeStart = clock_.now();
    m.visited.push_back({address_, 0.0});  // source node enters the stack
    return m;
}

AntMessage AntRouterLogic::createHelloAnt(std::size_t maxAdverts) {
    AntMessage m;
    m.type      = AntType::Hello;
    m.direction = AntDirection::Up;
    m.src       = address_;
    m.dst       = kInvalidAddress;  // adapter maps to its broadcast address
    m.seqNum    = nextSeq();
    m.timeStart = clock_.now();

    const auto& dests = table_.regularDestinations();
    for (NodeAddress dest : dests) {
        if (dests.size() <= maxAdverts ||
            (rng_.uniform() > 0.5 && m.helloDests.size() < maxAdverts)) {
            m.helloDests.push_back({dest, 1.0});
        }
        if (m.helloDests.size() >= maxAdverts) break;
    }
    return m;
}

AntMessage AntRouterLogic::createBackAnt(const AntMessage& forward) {
    AntMessage b;
    b.type      = forward.type;
    b.direction = AntDirection::Down;
    b.src       = address_;          // swap: this node originates the back ant
    b.dst       = forward.src;       // ...heading to the forward ant's source
    b.seqNum    = nextSeq();
    b.timeStart = clock_.now();
    b.lifeAnt   = forward.lifeAnt;
    b.visited   = forward.visited;   // retrace the path
    return b;
}

// --- routing primitives -----------------------------------------------------

NodeAddress AntRouterLogic::selectNextHop(NodeAddress dest, bool proactive) {
    return table_.nextNeighborNode(dest, proactive, config_.betaAnts, rng_);
}

NodeAddress AntRouterLogic::nextHopForData(NodeAddress dest) {
    return table_.lookup(dest, config_.betaData, rng_);
}

NodeAddress AntRouterLogic::randomDestination() {
    return table_.randomDestination(rng_);
}

void AntRouterLogic::stampForward(AntMessage& ant) const {
    if (ant.visited.size() >= config_.maxPathLength) return;
    // Record this hop's *delta* (seconds since the previous stamp), not the
    // cumulative time since the ant was generated: the back-ant metric sums
    // these to recover the true path time. Derive the delta from the elapsed
    // time minus the deltas already on the stack (timeStart is on the wire).
    const double cumulative = clock_.now() - ant.timeStart;
    double prior = 0.0;
    for (const AntHop& h : ant.visited) prior += h.time;
    ant.visited.push_back({address_, cumulative - prior});
}

NodeAddress AntRouterLogic::advanceBackAnt(AntMessage& ant) const {
    if (ant.visited.empty()) return kInvalidAddress;

    const AntHop current = ant.visited.back();  // this node
    ant.prevHop = current.node;
    ant.hops += 1;
    // Sum the per-hop deltas walked so far: this is T̂_d^i, the estimated time
    // to reach the destination from here, in seconds (same units as hopTimeSec).
    ant.prevSINR += current.time;

    // Eq.2: blend the time estimate with the hop-count estimate h·T_hop.
    ant.pheromone = std::pow((ant.hops * config_.hopTimeSec + ant.prevSINR) / 2.0, -1.0);

    ant.history.push_back(current);
    ant.visited.pop_back();

    if (ant.visited.empty()) return kInvalidAddress;
    return ant.visited.back().node;  // peek next hop (left for it to pop)
}

void AntRouterLogic::reinforceFromBackAnt(const AntMessage& ant) {
    engine_.updateRegular(table_, ant.src, ant.prevHop, ant.pheromone);
}

// --- consolidated receive ---------------------------------------------------

std::vector<RouteDecision> AntRouterLogic::onReceiveAnt(const AntMessage& incoming,
                                                        NodeAddress prevHop) {
    // (src, seq) duplicate / loop detection.
    if (!history_.record(incoming.src, incoming.seqNum)) {
        return {RouteDecision::drop()};
    }

    // Link-layer neighbour detection from the previous hop.
    if (prevHop != kInvalidAddress) {
        learnNeighbor(prevHop);
    }

    if (incoming.type == AntType::Hello) {
        learnNeighbor(incoming.src);
        engine_.updateVirtual(table_, incoming);
        return {};  // hello is consumed locally
    }

    AntMessage ant = incoming;  // mutable working copy
    const bool proactive = (ant.type == AntType::Proactive);

    if (ant.isForward()) {
        stampForward(ant);

        if (ant.dst == address_) {
            // Destination reached: spawn the backward ant and send it home.
            AntMessage back = createBackAnt(ant);
            NodeAddress next = advanceBackAnt(back);
            if (next == kInvalidAddress) return {RouteDecision::drop()};
            return {{RouteAction::Unicast, next, true, back}};
        }
        if (ant.src == address_) {
            return {RouteDecision::drop()};  // our own forward ant looped back
        }

        NodeAddress next = selectNextHop(ant.dst, proactive);
        if (next == kInvalidAddress) {
            return {{RouteAction::Broadcast, kInvalidAddress, true, ant}};
        }
        return {{RouteAction::Unicast, next, true, ant}};
    }

    // Backward ant: reinforce the route it travelled, then keep retracing.
    reinforceFromBackAnt(ant);

    if (ant.dst == address_) {
        // Back at the origin: the adapter should flush any pending data for
        // the newly-discovered destination.
        return {RouteDecision::deliver()};
    }
    if (ant.src == address_) {
        return {RouteDecision::drop()};
    }

    NodeAddress next = advanceBackAnt(ant);
    if (next == kInvalidAddress) return {RouteDecision::drop()};
    return {{RouteAction::Unicast, next, true, ant}};
}

std::vector<RouteDecision> AntRouterLogic::onDataPacket(NodeAddress dest) {
    NodeAddress next = nextHopForData(dest);
    if (next == kInvalidAddress) {
        // No route: hold the data and launch a reactive forward ant.
        AntMessage refa = createForwardAnt(AntType::Reactive, dest);
        return {{RouteAction::Queue, dest, false, {}},
                {RouteAction::Broadcast, kInvalidAddress, true, refa}};
    }
    return {{RouteAction::Unicast, next, false, {}}};
}

} // namespace core
} // namespace anthocnet
