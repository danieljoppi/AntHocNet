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
    lastSeen_[neighbor] = clock_.now();  // liveness: any reception refreshes it
}

void AntRouterLogic::loseNeighbor(NodeAddress neighbor) {
    engine_.cleanNeighbor(table_, neighbor);
    lastSeen_.erase(neighbor);
}

std::vector<RouteDecision> AntRouterLogic::onMaintenanceTick() {
    std::vector<RouteDecision> out;
    const double now = clock_.now();

    // Single-sourced, time-proportional aging (ADR-0012), gated for the
    // paper-faithful ablation. dt is taken from the clock, never wall time.
    if (config_.enableEvaporation) {
        engine_.evaporateAll(table_, now - lastEvaporation_);
        lastEvaporation_ = now;
    }

    const double maxIdle = config_.helloInterval * config_.allowedHelloLoss;

    std::vector<NodeAddress> expired;
    for (const auto& kv : lastSeen_) {
        if (now - kv.second > maxIdle) expired.push_back(kv.first);
    }
    for (NodeAddress n : expired) {
        std::vector<RouteDecision> notes = reportNeighborLoss(n);
        out.insert(out.end(), notes.begin(), notes.end());
    }
    return out;
}

RouteDecision AntRouterLogic::broadcastForward(AntMessage& ant) const {
    if (ant.broadcastBudget == 0) return RouteDecision::drop();  // budget exhausted
    if (ant.broadcastBudget > 0) ant.broadcastBudget -= 1;       // -1 == untracked
    return {RouteAction::Broadcast, kInvalidAddress, true, ant};
}

std::vector<RouteDecision> AntRouterLogic::reportNeighborLoss(NodeAddress n) {
    // Snapshot the destinations whose best path ran through n (pre-removal).
    std::vector<std::pair<NodeAddress, double>> affected;  // (dest, best-before)
    for (NodeAddress d : table_.regularDestinations()) {
        const double viaN = table_.getPheromoneRegular(d, n);
        if (viaN <= config_.minPheromone) continue;
        const double before = table_.bestRegular(d);
        if (viaN >= before - 1e-12) affected.push_back({d, before});  // n was (a) best
    }

    loseNeighbor(n);  // prune n from the table + last-seen

    AntMessage note;
    for (const auto& pr : affected) {
        const double after = table_.bestRegular(pr.first);
        if (after < pr.second) note.helloDests.push_back({pr.first, after});  // we lost ground
    }
    if (note.helloDests.empty()) return {};

    note.type           = AntType::LinkFail;
    note.direction      = AntDirection::Up;
    note.src            = address_;
    note.dst            = kInvalidAddress;
    note.seqNum         = nextSeq();
    note.timeStart      = clock_.now();
    note.broadcastBudget = config_.repairMaxBroadcasts;
    return {broadcastForward(note)};
}

std::vector<RouteDecision> AntRouterLogic::handleLinkFail(const AntMessage& note,
                                                          NodeAddress reporter) {
    AntMessage prop;
    prop.broadcastBudget = note.broadcastBudget;  // broadcastForward decrements
    for (const HelloDest& adv : note.helloDests) {
        const NodeAddress d = adv.node;
        if (d == address_) continue;  // not about routes to ourselves
        const double before = table_.bestRegular(d);
        const bool viaReporter = table_.getPheromoneRegular(d, reporter) > config_.minPheromone;

        if (adv.pheromone <= config_.minPheromone) {
            table_.removePheromoneRegular(d, reporter);  // reporter has no path now
        } else {
            // Reporter's new best, discounted one hop to this node (item 03 units).
            const double bootstrapped = 1.0 / (1.0 / adv.pheromone + config_.hopTimeSec);
            table_.setPheromoneRegular(d, reporter, bootstrapped);
        }

        const double after = table_.bestRegular(d);
        if (viaReporter && after < before) prop.helloDests.push_back({d, after});
    }
    if (prop.helloDests.empty()) return {};  // absorbed: our best path is intact

    prop.type      = AntType::LinkFail;
    prop.direction = AntDirection::Up;
    prop.src       = address_;
    prop.dst       = kInvalidAddress;
    prop.seqNum    = nextSeq();
    prop.timeStart = clock_.now();
    return {broadcastForward(prop)};
}

// --- active sessions (item 04) ----------------------------------------------

void AntRouterLogic::noteDataSession(NodeAddress dest) {
    if (dest == kInvalidAddress || dest == address_) return;
    activeSessions_[dest] = clock_.now();
}

std::vector<NodeAddress> AntRouterLogic::activeDestinations() const {
    std::vector<NodeAddress> dests;
    const double now = clock_.now();
    for (const auto& kv : activeSessions_) {
        if (now - kv.second <= config_.sessionTtl) dests.push_back(kv.first);
    }
    return dests;
}

std::vector<AntMessage> AntRouterLogic::createProactiveAnts() {
    std::vector<AntMessage> ants;
    if (!config_.enableProactive) return ants;
    const double now = clock_.now();
    for (auto it = activeSessions_.begin(); it != activeSessions_.end();) {
        if (now - it->second > config_.sessionTtl) {
            it = activeSessions_.erase(it);  // expired session
            continue;
        }
        ants.push_back(createForwardAnt(AntType::Proactive, it->first));
        ++it;
    }
    return ants;
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
    // Reactive and repair ants cap their broadcasts ([1] §3.2/§3.5); proactive
    // ants are untracked (their per-hop explore prob + dedup bound them).
    if (type == AntType::Repair)        m.broadcastBudget = config_.repairMaxBroadcasts;
    else if (type == AntType::Reactive) m.broadcastBudget = config_.reactiveMaxBroadcasts;
    else                                m.broadcastBudget = -1;
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

    // Diffusion adverts are gated (ADR-0007); a hello with no adverts still
    // serves neighbour discovery / liveness.
    if (!config_.enableProactive || !config_.enableDiffusion) return m;

    // Advertise this node's *best real pheromone* per destination so the
    // receiver can bootstrap a goodness-ordered virtual table (D3), skipping
    // destinations we have no usable path to.
    for (NodeAddress dest : table_.regularDestinations()) {
        const double best = table_.bestRegular(dest);
        if (best <= config_.minPheromone) continue;
        m.helloDests.push_back({dest, best});
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

NodeAddress AntRouterLogic::nextHopForData(NodeAddress dest, NodeAddress prevHop) {
    return table_.lookup(dest, config_.betaData, rng_, prevHop);
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

    if (incoming.type == AntType::LinkFail) {
        return handleLinkFail(incoming, prevHop);  // apply + maybe propagate
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
            return {broadcastForward(ant)};  // bounded for repair ants
        }
        // A proactive ant with a route is normally unicast, but with a small
        // per-hop probability it is broadcast instead to explore new paths
        // ([1] §3.3). Gated by the proactive master switch (ADR-0007).
        if (proactive && config_.enableProactive &&
            rng_.uniform() < config_.proactiveBroadcastProb) {
            return {broadcastForward(ant)};
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

std::vector<RouteDecision> AntRouterLogic::onDataPacket(NodeAddress dest,
                                                        NodeAddress prevHop) {
    NodeAddress next = nextHopForData(dest, prevHop);
    if (next == kInvalidAddress) {
        // No route: always hold the data, but launch at most one reactive ant
        // per destination per reactiveRetryInterval so a stream of packets to an
        // unreachable destination doesn't flood ants ([1] §4.2).
        std::vector<RouteDecision> out{{RouteAction::Queue, dest, false, {}}};
        const double now = clock_.now();
        auto it = lastReactive_.find(dest);
        if (it == lastReactive_.end() || now - it->second >= config_.reactiveRetryInterval) {
            lastReactive_[dest] = now;
            AntMessage refa = createForwardAnt(AntType::Reactive, dest);
            out.push_back({RouteAction::Broadcast, kInvalidAddress, true, refa});
        }
        return out;
    }
    return {{RouteAction::Unicast, next, false, {}}};
}

} // namespace core
} // namespace anthocnet
