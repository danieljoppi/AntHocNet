// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * A tiny discrete-event testbench for multi-node core tests (issue #154).
 *
 * It generalises the hand-stepped "Network" in test_network_integration.cpp:
 * an event queue drives the shared FakeClock, N AntRouterLogic nodes, their
 * hello/proactive timers, and an *ideal lossless MAC* over a scriptable,
 * time-varying adjacency graph:
 *
 *   - Broadcast reaches exactly the sender's current neighbours;
 *   - Unicast reaches the target iff the two are currently adjacent —
 *     otherwise the send is reported back as a MAC transmit failure, which is
 *     what both real adapters do (ADR-0008 detector D);
 *   - links go up/down at scripted times via at(T, ...).
 *
 * The RouteDecisions the core returns are executed the way a thin adapter
 * executes them (Unicast / Broadcast / Queue / Deliver / DiscardPending /
 * Drop), so the core is driven through its real interface instead of being
 * poked internally.
 *
 * Deliberately NOT a simulator: no PHY, no contention, no propagation model,
 * no loss. Anything whose answer depends on the channel belongs in the ns-3
 * harness. This exists so *algorithmic* trends can be asserted in `make test`.
 */
#ifndef ANTHOCNET_CORE_TESTBENCH_H
#define ANTHOCNET_CORE_TESTBENCH_H

#include <cstdint>
#include <cstdio>
#include <functional>
#include <map>
#include <memory>
#include <queue>
#include <set>
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "test_support.h"

namespace anthocnet {
namespace test {

/// Fixed one-hop transfer delay. Not a propagation model — just enough to
/// order causally dependent events on the queue.
constexpr core::Time kHopDelay = 0.001;
/// Safety net so a control storm fails the test instead of hanging CI.
constexpr std::uint64_t kMaxSteps = 200000;

class Testbench {
public:
    Testbench(int numNodes, const core::Config& cfg) : cfg_(cfg) {
        for (int i = 0; i < numNodes; ++i) {
            rngs_.push_back(std::unique_ptr<ScriptedRng>(new ScriptedRng({0.5})));
            nodes_.push_back(std::unique_ptr<core::AntRouterLogic>(
                new core::AntRouterLogic(i, cfg_, clock_, *rngs_.back())));
            // Stagger the per-node timers so their order is deterministic but
            // they do not all fire in the same instant.
            const core::Time skew = kHopDelay * i;
            at(cfg_.helloInterval + skew, [this, i] { helloTick(i); });
            at(cfg_.proactiveInterval + skew, [this, i] { proactiveTick(i); });
        }
    }

    core::AntRouterLogic& node(int i) { return *nodes_[static_cast<std::size_t>(i)]; }
    core::Time now() const { return clock_.now(); }

    // --- scriptable time-varying graph ------------------------------------
    void linkUp(int a, int b) { adj_[a].insert(b); adj_[b].insert(a); }
    void linkDown(int a, int b) { adj_[a].erase(b); adj_[b].erase(a); }
    bool adjacent(int a, int b) const {
        auto it = adj_.find(a);
        return it != adj_.end() && it->second.count(b) != 0;
    }

    /// Run `fn` at absolute time `t` (scripts link changes, data sends, or
    /// mid-run assertions).
    void at(core::Time t, std::function<void()> fn) {
        events_.push(Event{t, seq_++, std::move(fn)});
    }

    /// Originate a data packet for `dest` at node `from`, right now.
    void sendData(int from, core::NodeAddress dest) {
        node(from).noteDataSession(dest);
        execute(from, node(from).onDataPacket(dest), dest);
    }

    // --- driver ------------------------------------------------------------
    /// Run the event queue up to (and including) time `horizon`.
    void runUntil(core::Time horizon) {
        while (!events_.empty() && events_.top().time <= horizon) {
            if (++steps_ > kMaxSteps) {
                std::fprintf(stderr, "testbench: event budget exhausted\n");
                ++failureCount();
                return;
            }
            Event e = events_.top();
            events_.pop();
            clock_.set(e.time);
            e.fn();
        }
        clock_.set(horizon);
    }

    // --- counters (what trend scenarios assert on) -------------------------
    int dataDelivered = 0;   ///< data packets that reached their destination
    int dataDiscarded = 0;   ///< pending packets released by a repair timeout
    /// Data packets still buffered at `n` awaiting a route to `dest`.
    int pending(int n, core::NodeAddress dest) const {
        auto it = pending_.find(n);
        if (it == pending_.end()) return 0;
        auto jt = it->second.find(dest);
        return jt == it->second.end() ? 0 : jt->second;
    }
    /// Total ant control packets put on the medium by every node.
    std::uint64_t controlSent() const {
        std::uint64_t total = 0;
        for (const auto& n : nodes_) total += n->controlPacketsSent();
        return total;
    }

private:
    struct Event {
        core::Time            time;
        std::uint64_t         seq;   ///< FIFO tie-break, for determinism
        std::function<void()> fn;
        bool operator<(const Event& o) const {  // priority_queue = max-heap
            return time != o.time ? time > o.time : seq > o.seq;
        }
    };

    // --- ideal MAC ---------------------------------------------------------
    void macBroadcast(int from, const core::AntMessage& msg) {
        for (int nb : adj_[from]) {
            at(now() + kHopDelay, [this, nb, msg, from] { recvAnt(nb, msg, from); });
        }
    }

    void macUnicast(int from, int to, const core::AntMessage& msg) {
        if (!adjacent(from, to)) { txFailure(from, to, core::kInvalidAddress); return; }
        at(now() + kHopDelay, [this, to, msg, from] { recvAnt(to, msg, from); });
    }

    void macSendData(int from, int to, core::NodeAddress dest) {
        if (!adjacent(from, to)) { txFailure(from, to, dest); return; }
        at(now() + kHopDelay, [this, to, from, dest] { recvData(to, from, dest); });
    }

    /// A send to a non-adjacent node is lost and reported to the core exactly
    /// as an adapter reports a MAC retry-limit drop.
    void txFailure(int from, int to, core::NodeAddress dataDest) {
        execute(from, node(from).reportTxFailure(to, dataDest), dataDest);
    }

    // --- adapter-equivalent decision execution -----------------------------
    /// `dataDest` is the destination of the data packet being handled, if any:
    /// a Unicast carrying no message is a data forward, and Queue/DiscardPending
    /// address the pending-packet queue an adapter owns.
    void execute(int at_node, const std::vector<core::RouteDecision>& decisions,
                 core::NodeAddress dataDest = core::kInvalidAddress) {
        for (const core::RouteDecision& d : decisions) {
            switch (d.action) {
                case core::RouteAction::Unicast:
                    if (d.hasMessage) macUnicast(at_node, d.nextHop, d.message);
                    else              macSendData(at_node, d.nextHop, dataDest);
                    break;
                case core::RouteAction::Broadcast:
                    macBroadcast(at_node, d.message);
                    break;
                case core::RouteAction::Queue:
                    ++pending_[at_node][d.nextHop];  // nextHop carries the dest
                    break;
                case core::RouteAction::DiscardPending:
                    dataDiscarded += pending(at_node, d.nextHop);
                    pending_[at_node].erase(d.nextHop);
                    break;
                case core::RouteAction::Deliver:   // handled by recvAnt
                case core::RouteAction::Drop:
                case core::RouteAction::None:
                    break;
            }
        }
    }

    void recvAnt(int at_node, const core::AntMessage& msg, int prevHop) {
        execute(at_node, node(at_node).onReceiveAnt(msg, prevHop));
        // Any backward ant installs a route toward its origin at every hop it
        // retraces, so release whatever was waiting for it (as the adapters do).
        if (msg.isBackward()) flush(at_node, msg.src);
    }

    void recvData(int at_node, int prevHop, core::NodeAddress dest) {
        if (at_node == dest) { ++dataDelivered; return; }
        execute(at_node, node(at_node).onDataPacket(dest, prevHop), dest);
    }

    /// Re-offer buffered packets for `dest` now that a route may exist.
    void flush(int at_node, core::NodeAddress dest) {
        int held = pending(at_node, dest);
        while (held > 0) {
            core::NodeAddress next = node(at_node).nextHopForData(dest);
            if (next == core::kInvalidAddress) break;
            --held;
            pending_[at_node][dest] = held;
            macSendData(at_node, next, dest);
        }
    }

    // --- timers (the adapters' hello / proactive timers) -------------------
    void helloTick(int i) {
        execute(i, node(i).onMaintenanceTick());
        macBroadcast(i, node(i).createHelloAnt());
        at(now() + cfg_.helloInterval, [this, i] { helloTick(i); });
    }

    void proactiveTick(int i) {
        for (core::AntMessage& ant : node(i).createProactiveAnts()) {
            core::NodeAddress next = node(i).selectNextHop(ant.dst, /*proactive=*/true);
            if (next == core::kInvalidAddress) macBroadcast(i, ant);
            else                                macUnicast(i, next, ant);
        }
        at(now() + cfg_.proactiveInterval, [this, i] { proactiveTick(i); });
    }

    core::Config cfg_;
    FakeClock    clock_;
    std::vector<std::unique_ptr<ScriptedRng>>           rngs_;
    std::vector<std::unique_ptr<core::AntRouterLogic>>  nodes_;
    std::map<int, std::set<int>>                        adj_;
    std::priority_queue<Event>                          events_;
    std::map<int, std::map<core::NodeAddress, int>>     pending_;
    std::uint64_t seq_   = 0;
    std::uint64_t steps_ = 0;
};

} // namespace test
} // namespace anthocnet

#endif // ANTHOCNET_CORE_TESTBENCH_H
