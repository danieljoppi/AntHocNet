#include "anthocnet/core/pheromone_engine.h"
#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::ScriptedRng;

int main() {
    PheromoneTable table;

    // Size gauge (#133): empty table reports zero everywhere.
    CHECK_EQ(table.numEntriesRegular(), static_cast<std::size_t>(0));
    CHECK_EQ(table.numEntriesVirtual(), static_cast<std::size_t>(0));
    CHECK_EQ(table.numEntries(), static_cast<std::size_t>(0));

    // Two neighbours toward destination 9; neighbour 1 carries more pheromone.
    table.setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 1, 0.9);
    table.setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 2, 0.1);

    // Gauge tracks the two regular entries; virtual untouched.
    CHECK_EQ(table.numEntriesRegular(), static_cast<std::size_t>(2));
    CHECK_EQ(table.numEntriesVirtual(), static_cast<std::size_t>(0));
    CHECK_EQ(table.numEntries(), static_cast<std::size_t>(2));

    // Overwriting an existing (neighbor, dest) key must not grow the gauge.
    table.setPheromoneRegular(9, 1, 0.8);
    CHECK_EQ(table.numEntriesRegular(), static_cast<std::size_t>(2));

    // Virtual entries count separately from regular.
    table.addPheromoneVirtual(/*dest*/ 9, /*neighbor*/ 1, 0.5);
    table.addPheromoneVirtual(/*dest*/ 10, /*neighbor*/ 2, 0.4);
    CHECK_EQ(table.numEntriesRegular(), static_cast<std::size_t>(2));
    CHECK_EQ(table.numEntriesVirtual(), static_cast<std::size_t>(2));
    CHECK_EQ(table.numEntries(), static_cast<std::size_t>(4));

    CHECK_EQ(table.numNeighbors(), static_cast<std::size_t>(2));
    CHECK(table.hasNeighbor());

    // r small -> first neighbour in set order (1) is chosen.
    {
        ScriptedRng rng({0.01});
        CHECK_EQ(table.lookup(9, /*beta=*/1.0, rng), 1);
    }
    // r near 1 -> probability mass walks past neighbour 1 to neighbour 2.
    {
        ScriptedRng rng({0.99});
        CHECK_EQ(table.lookup(9, /*beta=*/1.0, rng), 2);
    }

    // Unknown destination yields no route.
    {
        ScriptedRng rng({0.5});
        CHECK_EQ(table.lookup(42, /*beta=*/1.0, rng), kInvalidAddress);
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
        CHECK_EQ(table.lookup(9, /*beta=*/1.0, rng), kInvalidAddress);
    }

    // Gauge tracks removal exactly; removing an absent key is a no-op.
    CHECK_EQ(table.numEntriesRegular(), static_cast<std::size_t>(0));
    CHECK_EQ(table.numEntriesVirtual(), static_cast<std::size_t>(2));
    table.removePheromoneRegular(9, 1);
    CHECK_EQ(table.numEntriesRegular(), static_cast<std::size_t>(0));
    CHECK_EQ(table.numEntries(), static_cast<std::size_t>(2));

    // Neighbour removal (link failure path): cleanNeighbor prunes every entry
    // via that neighbour from both maps and the gauge follows.
    Config cfg;
    PheromoneEngine engine(cfg);
    engine.cleanNeighbor(table, /*neighbor*/ 2);   // drops virtual (dest 10 via 2)
    CHECK_EQ(table.numEntriesVirtual(), static_cast<std::size_t>(1));
    CHECK_EQ(table.numEntries(), static_cast<std::size_t>(1));
    engine.cleanNeighbor(table, /*neighbor*/ 1);   // drops virtual (dest 9 via 1)
    CHECK_EQ(table.numEntriesVirtual(), static_cast<std::size_t>(0));
    CHECK_EQ(table.numEntries(), static_cast<std::size_t>(0));

    return RUN_TESTS();
}
