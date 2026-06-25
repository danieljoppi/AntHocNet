#include "anthocnet/core/ant_history.h"
#include "test_support.h"

using namespace anthocnet::core;

int main() {
    // Dedup: first sighting is new, repeats are not.
    AntHistoryTracker h(/*maxEntries*/ 0);  // unbounded
    CHECK(h.record(5, 1));
    CHECK(!h.record(5, 1));       // duplicate
    CHECK(h.seen(5, 1));
    CHECK(h.record(5, 2));        // different seq
    CHECK(h.record(6, 1));        // different src
    CHECK(!h.seen(7, 1));
    CHECK_EQ(h.size(), static_cast<std::size_t>(3));

    // Sequence numbers beyond 255 stay distinct (the original u_int8_t wrapped
    // here and aliased ant 256 onto ant 0).
    CHECK(h.record(5, 256));
    CHECK(h.seen(5, 256));
    CHECK(!h.seen(5, 0));

    // Bounded tracker evicts oldest entries (FIFO) once over capacity.
    AntHistoryTracker bounded(/*maxEntries*/ 3);
    bounded.record(1, 1);
    bounded.record(1, 2);
    bounded.record(1, 3);
    CHECK_EQ(bounded.size(), static_cast<std::size_t>(3));
    bounded.record(1, 4);                  // evicts (1,1)
    CHECK_EQ(bounded.size(), static_cast<std::size_t>(3));
    CHECK(!bounded.seen(1, 1));             // evicted
    CHECK(bounded.seen(1, 4));
    // The evicted entry is treated as new again.
    CHECK(bounded.record(1, 1));

    return RUN_TESTS();
}
