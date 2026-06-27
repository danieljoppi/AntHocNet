// Item 15: ant/route counters and the optional IRouterObserver fire at the
// expected events, and are zero-cost (unset observer) by construction.
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

struct RecordingObserver : IRouterObserver {
    struct Sent { AntType type; AntDirection dir; bool broadcast; };
    std::vector<Sent> sent;
    std::vector<AntType> received;
    int routeAdds = 0;
    int routeRemoves = 0;

    void onAntSent(AntType t, AntDirection d, bool b) override {
        sent.push_back({t, d, b});
    }
    void onAntReceived(AntType t, AntDirection /*d*/) override {
        received.push_back(t);
    }
    void onRouteChanged(NodeAddress /*dest*/, NodeAddress /*nb*/, bool added) override {
        if (added) ++routeAdds; else ++routeRemoves;
    }
};

}  // namespace

int main() {
    Config cfg;

    // --- reactive broadcast on data with no route increments antsSent ------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);
        RecordingObserver obs;
        router.setObserver(&obs);

        router.onDataPacket(/*dest*/ 9);
        CHECK_EQ(router.antsSent(AntType::Reactive), static_cast<std::uint64_t>(1));
        CHECK_EQ(router.controlPacketsSent(), static_cast<std::uint64_t>(1));
        CHECK_EQ(obs.sent.size(), static_cast<std::size_t>(1));
        CHECK(obs.sent[0].type == AntType::Reactive);
        CHECK(obs.sent[0].dir == AntDirection::Up);
        CHECK(obs.sent[0].broadcast == true);

        // A second packet to the same dest within reactiveRetryInterval must
        // NOT launch another ant (rate-limited), so the counter is unchanged.
        router.onDataPacket(/*dest*/ 9);
        CHECK_EQ(router.antsSent(AntType::Reactive), static_cast<std::uint64_t>(1));
    }

    // --- received counter + route-added on neighbour learn -----------------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);
        RecordingObserver obs;
        router.setObserver(&obs);

        AntMessage hello;
        hello.type = AntType::Hello;
        hello.direction = AntDirection::Up;
        hello.src = 2;
        hello.seqNum = 1;
        hello.helloDests = {{9, 1.0}};

        router.onReceiveAnt(hello, /*prevHop*/ 2);
        CHECK_EQ(router.antsReceived(AntType::Hello), static_cast<std::uint64_t>(1));
        CHECK_EQ(obs.received.size(), static_cast<std::size_t>(1));
        CHECK(obs.received[0] == AntType::Hello);
        CHECK(obs.routeAdds >= 1);  // neighbour 2 was learned

        // Duplicate (same src,seq) is deduped: not counted as received again.
        router.onReceiveAnt(hello, /*prevHop*/ 2);
        CHECK_EQ(router.antsReceived(AntType::Hello), static_cast<std::uint64_t>(1));
    }

    // --- forwarding the spawned backward ant counts as a send --------------
    {
        FakeClock clock;
        clock.set(1.0);
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 9, cfg, clock, rng);
        RecordingObserver obs;
        router.setObserver(&obs);

        AntMessage fwd;
        fwd.type = AntType::Reactive;
        fwd.direction = AntDirection::Up;
        fwd.src = 3;
        fwd.dst = 9;  // this node is the destination
        fwd.seqNum = 1;
        fwd.timeStart = 0.0;
        fwd.visited = {{3, 0.0}, {4, 0.01}};

        router.onReceiveAnt(fwd, /*prevHop*/ 4);
        // The destination unicasts a backward ant home -> one send, direction Down.
        CHECK_EQ(router.antsSent(AntType::Reactive), static_cast<std::uint64_t>(1));
        CHECK_EQ(obs.sent.size(), static_cast<std::size_t>(1));
        CHECK(obs.sent[0].dir == AntDirection::Down);
        CHECK(obs.sent[0].broadcast == false);
    }

    // --- no observer set: counters still work, no crash --------------------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);
        router.onDataPacket(/*dest*/ 9);
        CHECK_EQ(router.antsSent(AntType::Reactive), static_cast<std::uint64_t>(1));
    }

    return RUN_TESTS();
}
