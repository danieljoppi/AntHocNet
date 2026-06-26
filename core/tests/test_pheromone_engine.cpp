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

    // updateRegular reinforces ONLY the travelled link now; aging is
    // single-sourced into evaporateAll (ADR-0012), so the competitor is
    // untouched here (no reinforce-and-age coupling).
    engine.updateRegular(table, /*dest*/ 9, /*neighbor*/ 1, /*phUpdate*/ 1.0);
    CHECK_NEAR(table.getPheromoneRegular(9, 1), 0.65, 1e-9);  // 0.7*0.5 + 0.3*1.0
    CHECK_NEAR(table.getPheromoneRegular(9, 2), 0.5, 1e-9);   // unchanged

    // evaporateAll ages every link by alpha^(dt/interval); dt = interval -> *alpha.
    engine.evaporateAll(table, cfg.evaporationInterval);
    CHECK_NEAR(table.getPheromoneRegular(9, 1), 0.65 * 0.7, 1e-9);
    CHECK_NEAR(table.getPheromoneRegular(9, 2), 0.50 * 0.7, 1e-9);

    // dt scales the decay: half an interval ages by alpha^0.5.
    {
        PheromoneTable t;
        t.setPheromoneRegular(9, 1, 1.0);
        engine.evaporateAll(t, cfg.evaporationInterval * 0.5);
        CHECK_NEAR(t.getPheromoneRegular(9, 1), std::pow(0.7, 0.5), 1e-9);
    }

    // Repeated evaporation with no reinforcement decays an entry below the floor,
    // which prunes it (getPheromoneRegular then reads back 0); reinforcing keeps
    // the travelled link alive across the same churn.
    for (int i = 0; i < 60; ++i) {
        engine.evaporateAll(table, cfg.evaporationInterval);
        engine.updateRegular(table, 9, 1, 1.0);
    }
    CHECK(table.getPheromoneRegular(9, 1) > cfg.minPheromone);
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
