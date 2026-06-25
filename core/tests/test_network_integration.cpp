/*
 * End-to-end integration test: drive AntRouterLogic through a real multi-hop
 * route discovery using a tiny in-memory "network", with no simulator.
 *
 * Topology is a line  0 - 1 - 2 - 3.  Node 0 wants to reach node 3 and has no
 * route, so it floods a reactive forward ant; the ant reaches 3, a backward
 * ant retraces and reinforces the path, and afterwards every node on the path
 * has a unicast route toward 3. This exercises the forward-ant flooding,
 * (src,seq) dedup, neighbour learning, back-ant construction/advance, and
 * pheromone reinforcement all working together.
 */
#include <deque>
#include <map>
#include <memory>
#include <set>
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

struct Network {
    FakeClock clock;
    std::vector<std::unique_ptr<ScriptedRng>> rngs;
    std::vector<std::unique_ptr<AntRouterLogic>> nodes;
    std::map<int, std::set<int>> adj;  // physical adjacency

    struct Event {
        int to;
        AntMessage msg;
        int prevHop;
    };
    std::deque<Event> queue;
    bool delivered = false;  // a back ant reached its origin

    void addNode(int addr, const Config& cfg) {
        rngs.push_back(std::unique_ptr<ScriptedRng>(new ScriptedRng({0.5})));
        nodes.push_back(std::unique_ptr<AntRouterLogic>(
            new AntRouterLogic(addr, cfg, clock, *rngs.back())));
    }

    void link(int a, int b) { adj[a].insert(b); adj[b].insert(a); }

    void dispatch(int from, const std::vector<RouteDecision>& decisions) {
        for (const RouteDecision& d : decisions) {
            switch (d.action) {
                case RouteAction::Unicast:
                    queue.push_back({d.nextHop, d.message, from});
                    break;
                case RouteAction::Broadcast:
                    for (int nb : adj[from]) queue.push_back({nb, d.message, from});
                    break;
                case RouteAction::Deliver:
                    delivered = true;
                    break;
                default:
                    break;
            }
        }
    }

    void run(int maxSteps = 1000) {
        int steps = 0;
        while (!queue.empty() && steps++ < maxSteps) {
            Event e = queue.front();
            queue.pop_front();
            dispatch(e.to, nodes[e.to]->onReceiveAnt(e.msg, e.prevHop));
        }
    }
};

} // namespace

int main() {
    Config cfg;
    Network net;
    for (int i = 0; i < 4; ++i) net.addNode(i, cfg);
    net.link(0, 1);
    net.link(1, 2);
    net.link(2, 3);

    // Node 0 has data for node 3 but no route: it queues and floods a REFA.
    net.dispatch(0, net.nodes[0]->onDataPacket(/*dest*/ 3));
    net.run();

    // A backward ant made it home.
    CHECK(net.delivered);

    // Every node on the path now has a unicast route toward 3.
    CHECK_EQ(net.nodes[0]->selectNextHop(3, /*proactive=*/false), 1);
    CHECK_EQ(net.nodes[1]->selectNextHop(3, /*proactive=*/false), 2);
    CHECK_EQ(net.nodes[2]->selectNextHop(3, /*proactive=*/false), 3);

    // A second data packet at node 0 is now routed immediately (no flood).
    {
        auto decisions = net.nodes[0]->onDataPacket(3);
        CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
        CHECK(decisions[0].action == RouteAction::Unicast);
        CHECK_EQ(decisions[0].nextHop, 1);
    }

    return RUN_TESTS();
}
