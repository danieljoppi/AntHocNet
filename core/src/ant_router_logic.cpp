#include "anthocnet/core/ant_router_logic.h"

#include <cmath>

namespace anthocnet {
namespace core {

AntRouterLogic::AntRouterLogic(NodeAddress address, const Config& config, IClock& clock,
                               IRng& rng, const ILinkMetric* metric,
                               const ILinkState* linkState)
    : address_(address),
      config_(config),
      clock_(clock),
      rng_(rng),
      engine_(config_),
      metric_(metric ? metric : &defaultMetric_),
      linkState_(linkState),
      history_(config_.maxHistory) {}

// --- neighbour learning -----------------------------------------------------

void AntRouterLogic::learnNeighbor(NodeAddress neighbor) {
    if (neighbor == address_ || neighbor == kInvalidAddress) return;
    const bool isNew = lastSeen_.find(neighbor) == lastSeen_.end();
    table_.addNeighbor(neighbor);
    // Seed an equal-weight regular entry, as the legacy recvAHN did.
    engine_.updateRegular(table_, neighbor, neighbor, 1.0);
    lastSeen_[neighbor] = clock_.now();  // liveness: any reception refreshes it
    txFailures_.erase(neighbor);         // a reception clears the tx-failure streak (#19)
    if (isNew && observer_) observer_->onRouteChanged(neighbor, neighbor, true);
}

void AntRouterLogic::loseNeighbor(NodeAddress neighbor) {
    const bool had = lastSeen_.find(neighbor) != lastSeen_.end();
    engine_.cleanNeighbor(table_, neighbor);
    lastSeen_.erase(neighbor);
    txFailures_.erase(neighbor);
    if (had && observer_) observer_->onRouteChanged(neighbor, neighbor, false);
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

    // Local-repair wait/discard ([1] §3.5, D6): a repair that got no backward
    // ant within its window has failed — tell the adapter to discard the
    // packets buffered for that destination (the paper trades PDR for a bounded
    // delay tail here) and send the deferred link-failure notification. If a
    // route reappeared some other way (reactive ant, diffusion), just forget
    // the deadline; the normal flush path handles the queue.
    for (auto it = repairDeadline_.begin(); it != repairDeadline_.end();) {
        if (now < it->second) { ++it; continue; }
        const NodeAddress dest = it->first;
        it = repairDeadline_.erase(it);
        if (table_.bestRegular(dest) > config_.minPheromone) continue;

        out.push_back({RouteAction::DiscardPending, dest, false, {}});

        // Same origin cooldown as reportNeighborLoss (issue #20): the break
        // that armed this repair usually already advertised dest's loss.
        if (config_.linkfailNotifyInterval > 0.0) {
            auto itN = lastLinkfailNotify_.find(dest);
            if (itN != lastLinkfailNotify_.end() &&
                now - itN->second < config_.linkfailNotifyInterval) {
                ++linkfailOriginsSuppressed_;
                continue;
            }
            lastLinkfailNotify_[dest] = now;
        }

        AntMessage note;
        note.type            = AntType::LinkFail;
        note.direction       = AntDirection::Up;
        note.src             = address_;
        note.dst             = kInvalidAddress;
        note.seqNum          = nextSeq();
        note.timeStart       = now;
        note.broadcastBudget = config_.repairMaxBroadcasts;
        note.helloDests.push_back({dest, 0.0});  // repair failed: no path left
        out.push_back(broadcastForward(note));
    }
    return out;
}

RouteDecision AntRouterLogic::broadcastForward(AntMessage& ant) {
    if (ant.broadcastBudget == 0) return RouteDecision::drop();  // budget exhausted
    if (ant.broadcastBudget > 0) ant.broadcastBudget -= 1;       // -1 == untracked
    return sendAnt(RouteAction::Broadcast, kInvalidAddress, ant);
}

RouteDecision AntRouterLogic::sendAnt(RouteAction action, NodeAddress nextHop,
                                      const AntMessage& ant) {
    antsSent_[ant.type] += 1;
    if (observer_) {
        observer_->onAntSent(ant.type, ant.direction, action == RouteAction::Broadcast);
    }
    return {action, nextHop, true, ant};
}

std::uint64_t AntRouterLogic::antsSent(AntType type) const {
    auto it = antsSent_.find(type);
    return it == antsSent_.end() ? 0 : it->second;
}

std::uint64_t AntRouterLogic::antsReceived(AntType type) const {
    auto it = antsReceived_.find(type);
    return it == antsReceived_.end() ? 0 : it->second;
}

std::uint64_t AntRouterLogic::controlPacketsSent() const {
    std::uint64_t total = 0;
    for (const auto& kv : antsSent_) total += kv.second;
    return total;
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
    const double now = clock_.now();
    for (const auto& pr : affected) {
        const double after = table_.bestRegular(pr.first);
        if (after >= pr.second) continue;  // no ground lost
        // Origin cooldown (issue #20): under link flapping, re-advertising the
        // same destination every evict/re-learn cycle is what turns breaks into
        // a notification storm; neighbours already applied the first note.
        if (config_.linkfailNotifyInterval > 0.0) {
            auto it = lastLinkfailNotify_.find(pr.first);
            if (it != lastLinkfailNotify_.end() &&
                now - it->second < config_.linkfailNotifyInterval) {
                ++linkfailOriginsSuppressed_;
                continue;
            }
            lastLinkfailNotify_[pr.first] = now;
        }
        note.helloDests.push_back({pr.first, after});
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

std::vector<RouteDecision> AntRouterLogic::reportTxFailure(NodeAddress next,
                                                          NodeAddress dataDest) {
    if (next == kInvalidAddress) return {};

    // Debounce (issue #19): a single retry-limit drop in a dense/contended
    // network is usually a collision, not a topology change. Evicting the
    // neighbour on it destroys valid routes and triggers rediscovery floods
    // (proactive ants re-broadcast unbounded when no route survives), which add
    // contention and cause more drops — a positive-feedback storm. So only treat
    // the link as broken after txFailureThreshold consecutive failures with no
    // intervening reception (any reception resets the counter via learnNeighbor).
    if (++txFailures_[next] < config_.txFailureThreshold) return {};
    txFailures_.erase(next);

    // Estimated end-to-end delay of the path we are about to lose, for the
    // repair wait window ([1] §3.5: wait ~5× that delay). Pheromone is inverse
    // goodness in time units (item 03), so delay ≈ 1/pheromone; captured before
    // the prune below removes the entry.
    double lostPathDelay = 0.0;
    if (dataDest != kInvalidAddress) {
        const double best = table_.bestRegular(dataDest);
        if (best > config_.minPheromone) lostPathDelay = 1.0 / best;
    }

    // Real break: prune `next` and emit any LinkFail notifications (detector A
    // and D converge on this path).
    std::vector<RouteDecision> out = reportNeighborLoss(next);

    // Bounded local repair ([1] §3.5): only "if there is no other path
    // available" — after the loss, if a route to dataDest survives via another
    // neighbour, skip the repair ant. Rate-limit per destination so a burst of
    // failures to one dest can't spawn a stream of repair ants. broadcastForward
    // counts the ant (--diag repair>0) and caps re-broadcasts (repairMaxBroadcasts).
    if (dataDest != kInvalidAddress && dataDest != address_ &&
        table_.bestRegular(dataDest) <= config_.minPheromone) {
        const double now = clock_.now();
        auto it = lastRepair_.find(dataDest);
        if (it == lastRepair_.end() || now - it->second >= config_.reactiveRetryInterval) {
            lastRepair_[dataDest] = now;
            AntMessage rrfa = createForwardAnt(AntType::Repair, dataDest);
            rrfa.lifeAnt = config_.lifeAnt;
            out.push_back(broadcastForward(rrfa));
            // Arm the wait/discard window (D6): a backward ant from dataDest
            // cancels it; onMaintenanceTick fires it.
            const double wait = lostPathDelay > 0.0
                                    ? config_.repairWaitFactor * lostPathDelay
                                    : config_.repairTimeout;
            repairDeadline_[dataDest] = now + wait;
        }
    }
    return out;
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
    RouteDecision d = broadcastForward(prop);
    if (d.action == RouteAction::Broadcast) ++linkfailPropagations_;
    else ++linkfailBudgetDrops_;
    return {d};
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
        // Origination: the adapter sends these directly (they don't pass
        // through a RouteDecision here), so count them at the source.
        antsSent_[AntType::Proactive] += 1;
        if (observer_) observer_->onAntSent(AntType::Proactive, AntDirection::Up, false);
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
    // Every forward-ant type caps its broadcasts: reactive/repair per
    // [1] §3.2/§3.5, and proactive too (issue #45) — an unbounded proactive
    // budget let route gaps turn the path monitor into a network-wide flood.
    if (type == AntType::Repair)        m.broadcastBudget = config_.repairMaxBroadcasts;
    else if (type == AntType::Reactive) m.broadcastBudget = config_.reactiveMaxBroadcasts;
    else                                m.broadcastBudget = config_.proactiveMaxBroadcasts;
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

    // Origination: the adapter broadcasts every hello on its timer, so count it
    // here (hellos are consumed locally at the receiver, never re-forwarded).
    antsSent_[AntType::Hello] += 1;
    if (observer_) observer_->onAntSent(AntType::Hello, AntDirection::Up, true);

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
    ant.visited.push_back({address_, localHopCost(ant)});
}

double AntRouterLogic::localHopCost(const AntMessage& ant) const {
    // Congestion-aware per-hop cost (item 10/A2, [1] §3.2): when the MAC metric
    // is enabled and a link-state signal is available, this node contributes its
    // *expected time to send one packet given its current queue* — (Q_mac+1) *
    // T̂_mac — so the summed path time T̂_d reflects sustained MAC load and data
    // shifts off congested nodes. The h*T_hop term in ClassicMetric stays the
    // unloaded-reference regulariser, so this only changes the T̂_d term.
    //
    // NOTE(#55): the exact (Q+1)*T̂_mac expression follows the repo's §3.2
    // interpretation in docs/improvements/10 plus a queue-occupancy refinement;
    // the primary source (Ducatelle thesis / ETT 2005) was network-blocked at
    // implementation time, so it is isolated here and flagged for a maintainer
    // cross-check. Any correction is a one-line change in this function.
    if (config_.enableMacMetric && linkState_) {
        const double tmac = linkState_->macServiceTime();
        if (tmac > 0.0) {
            const int q = linkState_->macQueueLength();
            return (static_cast<double>(q > 0 ? q : 0) + 1.0) * tmac;
        }
        return config_.hopTimeSec;  // no MAC sample yet: unloaded reference hop
    }

    // Fallback (unchanged, item 02): the ant's own wall-clock transit — this
    // hop's *delta* (seconds since the previous stamp), derived from the elapsed
    // time since generation minus the deltas already on the stack. The back-ant
    // metric sums these to recover the path time.
    const double cumulative = clock_.now() - ant.timeStart;
    double prior = 0.0;
    for (const AntHop& h : ant.visited) prior += h.time;
    return cumulative - prior;
}

NodeAddress AntRouterLogic::advanceBackAnt(AntMessage& ant) const {
    if (ant.visited.empty()) return kInvalidAddress;

    // Pure path management (ADR-0009): move this node from the still-to-retrace
    // `visited` stack onto `history`, and peek the next hop. The deposit state
    // (prevHop/hops/pathTime/pheromone) is recomputed at the receiver from
    // `history`, not carried on the wire.
    const AntHop current = ant.visited.back();
    ant.history.push_back(current);
    ant.visited.pop_back();

    if (ant.visited.empty()) return kInvalidAddress;
    return ant.visited.back().node;  // next hop (left for it to pop)
}

double AntRouterLogic::backAntPheromone(const AntMessage& ant) const {
    // Reconstruct T̂_d^i and the hop count from the retraced path carried in
    // `history` (the per-hop deltas summed = path time to the destination).
    LinkObservation obs;
    obs.hops = static_cast<int>(ant.history.size());
    double t = 0.0;
    for (const AntHop& h : ant.history) t += h.time;
    obs.pathTime = t;
    obs.hopTime = config_.hopTimeSec;
    return metric_->pheromone(obs);
}

void AntRouterLogic::computeBackAntState(AntMessage& ant) const {
    // The neighbour that forwarded this back ant is the last node it retraced.
    ant.prevHop  = ant.history.empty() ? kInvalidAddress : ant.history.back().node;
    ant.hops     = static_cast<int>(ant.history.size());
    double t = 0.0;
    for (const AntHop& h : ant.history) t += h.time;
    ant.pathTime = t;
    ant.pheromone = backAntPheromone(ant);
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

    // Count the non-duplicate reception (observability, item 15).
    antsReceived_[incoming.type] += 1;
    if (observer_) observer_->onAntReceived(incoming.type, incoming.direction);

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
            return {sendAnt(RouteAction::Unicast, next, back)};
        }
        if (ant.src == address_) {
            return {RouteDecision::drop()};  // our own forward ant looped back
        }

        NodeAddress next = selectNextHop(ant.dst, proactive);
        if (next == kInvalidAddress) {
            return {broadcastForward(ant)};  // bounded per type (drop at budget 0)
        }
        // A proactive ant with a route is normally unicast, but with a small
        // per-hop probability it is broadcast instead to explore new paths
        // ([1] §3.3). Gated by the proactive master switch (ADR-0007). With the
        // broadcast budget spent, keep following pheromone rather than dropping
        // a routable ant.
        if (proactive && config_.enableProactive && ant.broadcastBudget != 0 &&
            rng_.uniform() < config_.proactiveBroadcastProb) {
            return {broadcastForward(ant)};
        }
        return {sendAnt(RouteAction::Unicast, next, ant)};
    }

    // Backward ant: rebuild the deposit state from the carried path (the four
    // transient fields are off the wire now, ADR-0009), reinforce, then retrace.
    computeBackAntState(ant);
    reinforceFromBackAnt(ant);
    // A backward ant from `src` just restored a route to it, so any local
    // repair waiting on that destination has succeeded ([1] §3.5, D6).
    repairDeadline_.erase(ant.src);

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
    return {sendAnt(RouteAction::Unicast, next, ant)};
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
            out.push_back(sendAnt(RouteAction::Broadcast, kInvalidAddress, refa));
        }
        return out;
    }
    return {{RouteAction::Unicast, next, false, {}}};
}

} // namespace core
} // namespace anthocnet
