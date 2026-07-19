// Item 03 — real pheromone diffusion. Hellos advertise the sender's best real
// pheromone (not a constant 1.0); the receiver bootstraps a one-hop-discounted
// virtual pheromone that guides proactive ants only (never data). Regression
// for deviation D3, plus the ADR-0007 gating and reach-guard relaxation.
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_engine.h"
#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

double advertFor(const AntMessage& m, NodeAddress dest) {
    for (const HelloDest& d : m.helloDests) {
        if (d.node == dest) return d.pheromone;
    }
    return -1.0;  // not advertised
}

AntMessage helloFrom(NodeAddress src, NodeAddress dest, double pheromone) {
    AntMessage h;
    h.type = AntType::Hello;
    h.direction = AntDirection::Up;
    h.src = src;
    h.helloDests = {{dest, pheromone}};
    return h;
}

}  // namespace

int main() {
    // 1. Adverts carry real goodness, and destinations with no usable pheromone
    //    are skipped (not advertised as 1.0).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 10, /*neighbor*/ 1, 0.8);
        router.table().setPheromoneRegular(/*dest*/ 11, /*neighbor*/ 2, 0.3);

        AntMessage hello = router.createHelloAnt(/*maxAdverts*/ 10);
        CHECK_NEAR(advertFor(hello, 10), 0.8, 1e-12);
        CHECK_NEAR(advertFor(hello, 11), 0.3, 1e-12);
        CHECK(advertFor(hello, 10) != 1.0);
        // Neighbours 1/2 are also "destinations" but carry no path pheromone.
        CHECK(advertFor(hello, 1) < 0.0);
        CHECK_EQ(hello.helloDests.size(), static_cast<std::size_t>(2));
    }

    // 2. Diffusion produces a gradient: two neighbours advertise the same dest
    //    with different pheromones; the virtual value via the better one is higher.
    {
        Config cfg;
        PheromoneEngine engine(cfg);
        PheromoneTable table;
        engine.updateVirtual(table, helloFrom(/*src*/ 1, /*dest*/ 9, 0.8));
        engine.updateVirtual(table, helloFrom(/*src*/ 2, /*dest*/ 9, 0.2));
        CHECK(table.getPheromoneVirtual(9, 1) > table.getPheromoneVirtual(9, 2));
    }

    // 3. One-hop discount: the virtual pheromone is below even (1-gamma)*advert,
    //    which it would equal exactly if the advert were used undiscounted.
    {
        Config cfg;
        PheromoneEngine engine(cfg);
        PheromoneTable table;
        const double advert = 0.8;
        engine.updateVirtual(table, helloFrom(1, 9, advert));
        const double v = table.getPheromoneVirtual(9, 1);
        CHECK(v > 0.0);
        CHECK(v < (1.0 - cfg.gamma) * advert);  // strictly discounted by the hop
    }

    // 4. Data ignores virtual pheromone; a proactive ant reaches a virtual-only
    //    destination (validates the relaxed reach-guard AND the data invariant).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().addNeighbor(7);
        router.table().setPheromoneVirtual(/*dest*/ 9, /*neighbor*/ 7, 0.5);

        CHECK_EQ(router.nextHopForData(9), kInvalidAddress);   // data: regular only
        CHECK_EQ(router.selectNextHop(9, /*proactive=*/true), 7);
    }

    // 5. Gate off => no adverts, updateVirtual is a no-op, virtual-only dests
    //    stay unreachable.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableDiffusion = false;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(9, 1, 0.8);

        AntMessage hello = router.createHelloAnt(10);
        CHECK(hello.helloDests.empty());

        router.engine().updateVirtual(router.table(), helloFrom(2, 99, 0.8));
        CHECK_NEAR(router.table().getPheromoneVirtual(99, 2), 0.0, 1e-12);
        CHECK_EQ(router.selectNextHop(99, /*proactive=*/true), kInvalidAddress);
    }

    // 6. Advert slots over maxAdverts are filled deterministically: active
    //    sessions first, the remainder by best pheromone — never a coin flip
    //    (issue #26, item 6.5).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 10, /*neighbor*/ 1, 0.2);
        router.table().setPheromoneRegular(/*dest*/ 11, /*neighbor*/ 1, 0.9);
        router.table().setPheromoneRegular(/*dest*/ 12, /*neighbor*/ 1, 0.5);

        // No active session: the two strongest destinations win the slots.
        AntMessage hello = router.createHelloAnt(/*maxAdverts*/ 2);
        CHECK_EQ(hello.helloDests.size(), static_cast<std::size_t>(2));
        CHECK_NEAR(advertFor(hello, 11), 0.9, 1e-12);
        CHECK_NEAR(advertFor(hello, 12), 0.5, 1e-12);
        CHECK(advertFor(hello, 10) < 0.0);

        // The weakest destination becomes an active session: it takes a slot
        // ahead of stronger, inactive ones.
        router.noteDataSession(10);
        hello = router.createHelloAnt(/*maxAdverts*/ 2);
        CHECK_EQ(hello.helloDests.size(), static_cast<std::size_t>(2));
        CHECK_NEAR(advertFor(hello, 10), 0.2, 1e-12);
        CHECK_NEAR(advertFor(hello, 11), 0.9, 1e-12);
        CHECK(advertFor(hello, 12) < 0.0);
    }

    return RUN_TESTS();
}
