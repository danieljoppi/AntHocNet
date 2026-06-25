#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::ScriptedRng;

int main() {
    PheromoneTable table;

    // Two neighbours toward destination 9; neighbour 1 carries more pheromone.
    table.setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 1, 0.9);
    table.setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 2, 0.1);

    CHECK_EQ(table.numNeighbors(), static_cast<std::size_t>(2));
    CHECK(table.hasNeighbor());

    // r small -> first neighbour in set order (1) is chosen.
    {
        ScriptedRng rng({0.01});
        CHECK_EQ(table.lookup(9, rng), 1);
    }
    // r near 1 -> probability mass walks past neighbour 1 to neighbour 2.
    {
        ScriptedRng rng({0.99});
        CHECK_EQ(table.lookup(9, rng), 2);
    }

    // Unknown destination yields no route.
    {
        ScriptedRng rng({0.5});
        CHECK_EQ(table.lookup(42, rng), kInvalidAddress);
    }

    // randomDestination returns a known regular destination.
    {
        ScriptedRng rng({0.5});
        NodeAddress d = table.randomDestination(rng);
        CHECK(d == 1 || d == 2 || d == 9);
    }

    // Removal drops the link; a destination with no pheromone is unroutable.
    table.removePheromoneRegular(9, 1);
    table.removePheromoneRegular(9, 2);
    {
        ScriptedRng rng({0.5});
        CHECK_EQ(table.lookup(9, rng), kInvalidAddress);
    }

    return RUN_TESTS();
}
