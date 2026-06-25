#include "anthocnet/core/pheromone_engine.h"
#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;

int main() {
    Config cfg;  // alpha=gamma=0.7, minPheromone=1e-5
    PheromoneEngine engine(cfg);

    // evaporate(x) = x - (1-alpha)x = alpha*x
    CHECK_NEAR(engine.evaporate(1.0), 0.7, 1e-9);
    // reinforce(old,new) = gamma*old + (1-gamma)*new
    CHECK_NEAR(engine.reinforce(1.0, 0.0), 0.7, 1e-9);
    CHECK_NEAR(engine.reinforce(0.0, 1.0), 0.3, 1e-9);

    // Set up dest 9 reachable via neighbours 1 (travelled) and 2 (competing).
    PheromoneTable table;
    table.setPheromoneRegular(9, 1, 0.5);
    table.setPheromoneRegular(9, 2, 0.5);

    engine.updateRegular(table, /*dest*/ 9, /*neighbor*/ 1, /*phUpdate*/ 1.0);

    // Travelled link 1 is reinforced: 0.7*0.5 + 0.3*1.0 = 0.65.
    CHECK_NEAR(table.getPheromoneRegular(9, 1), 0.65, 1e-9);
    // Competing link 2 must decay (this is the evaporation bug fix): it should
    // be evaporate(0.5) = 0.35, NOT left at 0.5 and NOT applied to link 1.
    CHECK_NEAR(table.getPheromoneRegular(9, 2), 0.35, 1e-9);

    // Repeated reinforcement converges toward the update value (1.0).
    for (int i = 0; i < 40; ++i) engine.updateRegular(table, 9, 1, 1.0);
    CHECK(table.getPheromoneRegular(9, 1) > 0.95);
    // ...while the un-travelled link decays below the floor and is removed
    // (getPheromoneRegular then reads back 0).
    CHECK(table.getPheromoneRegular(9, 2) < cfg.minPheromone);

    // cleanNeighbor wipes a vanished neighbour from the table.
    PheromoneTable t2;
    t2.setPheromoneRegular(9, 3, 0.8);
    t2.addNeighbor(3);
    engine.cleanNeighbor(t2, 3);
    CHECK_EQ(t2.numNeighbors(), static_cast<std::size_t>(0));
    CHECK_NEAR(t2.getPheromoneRegular(9, 3), 0.0, 1e-9);

    return RUN_TESTS();
}
