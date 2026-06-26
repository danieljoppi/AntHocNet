// Item 01 — the Eq.1 exponent beta is wired through, and data uses a greedier
// exponent (betaData) than ants (betaAnts). Regression for deviation D1, where
// selection hard-coded beta = 1 and ignored Config entirely.
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// Two neighbours toward dest 9; neighbour 1 carries twice the pheromone of 2.
PheromoneTable twoNeighbourTable() {
    PheromoneTable table;
    table.setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 1, 2.0);
    table.setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 2, 1.0);
    return table;
}

// Count, over an r-sweep, how often the better neighbour (1) is chosen.
int countBetterChosen(const PheromoneTable& table, double beta) {
    const double rs[] = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9};
    int chosenBetter = 0;
    for (double r : rs) {
        ScriptedRng rng({r});
        if (table.lookup(9, beta, rng) == 1) ++chosenBetter;
    }
    return chosenBetter;
}

}  // namespace

int main() {
    PheromoneTable table = twoNeighbourTable();

    // 1. A greedier beta concentrates the choice on the better neighbour.
    //    With beta = 1 the split is ~2/3 (linear in pheromone); with beta = 20
    //    the better neighbour wins for the whole sweep.
    const int linear = countBetterChosen(table, /*beta=*/1.0);
    const int greedy = countBetterChosen(table, /*betaData=*/20.0);
    CHECK_EQ(linear, 6);   // 2.0 / (2.0 + 1.0) of nine draws
    CHECK_EQ(greedy, 9);   // 2^20 / (2^20 + 1) ~ 1.0
    CHECK(greedy > linear);

    // 2. Ants and data go through different exponents, so for a fixed r they can
    //    pick different next hops. betaAnts = 1 -> neighbour 2 at r = 0.8;
    //    betaData = 20 -> neighbour 1.
    {
        Config config;
        config.betaAnts = 1.0;
        config.betaData = 20.0;
        FakeClock clock;
        ScriptedRng rng({0.8});  // loops, so both calls see the same draw
        AntRouterLogic router(/*address*/ 7, config, clock, rng);
        router.table().setPheromoneRegular(9, 1, 2.0);
        router.table().setPheromoneRegular(9, 2, 1.0);

        NodeAddress antHop  = router.selectNextHop(9, /*proactive=*/false);
        NodeAddress dataHop = router.nextHopForData(9);
        CHECK_EQ(antHop, 2);
        CHECK_EQ(dataHop, 1);
        CHECK(antHop != dataHop);
    }

    // 3. betaData is actually read: changing it alone changes nextHopForData for
    //    a fixed RNG sequence (the D1 regression).
    {
        FakeClock clock;
        Config greedyCfg;
        greedyCfg.betaData = 20.0;
        ScriptedRng rngA({0.8});
        AntRouterLogic greedyRouter(7, greedyCfg, clock, rngA);
        greedyRouter.table().setPheromoneRegular(9, 1, 2.0);
        greedyRouter.table().setPheromoneRegular(9, 2, 1.0);

        Config flatCfg;
        flatCfg.betaData = 1.0;
        ScriptedRng rngB({0.8});
        AntRouterLogic flatRouter(7, flatCfg, clock, rngB);
        flatRouter.table().setPheromoneRegular(9, 1, 2.0);
        flatRouter.table().setPheromoneRegular(9, 2, 1.0);

        CHECK_EQ(greedyRouter.nextHopForData(9), 1);
        CHECK_EQ(flatRouter.nextHopForData(9), 2);
        CHECK(greedyRouter.nextHopForData(9) != flatRouter.nextHopForData(9));
    }

    return RUN_TESTS();
}
