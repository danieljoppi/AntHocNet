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

    // ---------------------------------------------------------------------
    // GenerationTracker's bound (#166).
    //
    // Golden rule 5 applies to both trackers, but only AntHistoryTracker's cap
    // was exercised above. GenerationTracker has *two* eviction sites --
    // accept() and allowBroadcast() -- and neither was reachable from any test:
    // every scenario stayed far under the cap. The bound could have been
    // deleted, mis-ordered or made off-by-one with the whole suite still green,
    // which is the exact regression class the extraction already paid for once
    // (unbounded (src,seq) history, CONTEXT.md bug #4).
    //
    // A small cap keeps this in microseconds; the production default allocates
    // orders of magnitude more.
    // ---------------------------------------------------------------------
    const double a1 = 0.9, a2 = 2.0;   // the shipped acceptance factors (#177)

    // accept(): the cap holds, and eviction is FIFO.
    {
        GenerationTracker g(/*maxEntries*/ 3);
        for (std::uint32_t seq = 1; seq <= 3; ++seq) {
            CHECK(g.accept(/*src*/ 1, seq, /*hops*/ 2, /*time*/ 10.0,
                           /*firstHop*/ 9, a1, a2));
        }
        CHECK_EQ(g.size(), static_cast<std::size_t>(3));

        // A fourth generation evicts the first, and only the first.
        CHECK(g.accept(1, 4, 2, 10.0, 9, a1, a2));
        CHECK_EQ(g.size(), static_cast<std::size_t>(3));

        // Generation 1 is genuinely forgotten: an ant that would have been
        // rejected against its recorded best (20 hops vs a 0.9*2 band) is now
        // admitted as the first of a "new" generation. This is the side of the
        // memory-for-correctness trade the bound puts us on -- eviction reopens
        // a generation rather than permanently rejecting it -- and asserting it
        // is what makes the FIFO order observable at all.
        CHECK(g.accept(1, 1, /*hops*/ 20, /*time*/ 999.0, 9, a1, a2));

        // Generations 3 and 4 were never evicted, so their bands still bind:
        // 20 hops against a best of 2 is far outside a2=2.0.
        CHECK(!g.accept(1, 3, 20, 999.0, 9, a1, a2));
        CHECK(!g.accept(1, 4, 20, 999.0, 9, a1, a2));
        // ...and both bands still work on a surviving generation, so eviction
        // has not corrupted the entries it left alone. Note a1 = 0.9 < 1: over
        // an *already-admitted* first hop an equal-cost ant is rejected (2 hops
        // is not <= 0.9*2), and only a strictly better one gets in. Over an
        // unseen first hop the same equal-cost ant is admitted under a2 = 2.0.
        CHECK(!g.accept(1, 4, /*hops*/ 2, /*time*/ 10.0, /*firstHop*/ 9, a1, a2));
        CHECK(g.accept(1, 4, /*hops*/ 1, /*time*/ 5.0, /*firstHop*/ 9, a1, a2));
        CHECK(g.accept(1, 4, /*hops*/ 1, /*time*/ 5.0, /*firstHop*/ 8, a1, a2));
    }

    // allowBroadcast(): its own eviction site, reached when multipath is off or
    // the ant originates here, so accept() never recorded the generation.
    {
        GenerationTracker g(/*maxEntries*/ 2);
        CHECK(g.allowBroadcast(/*src*/ 7, /*seq*/ 1, /*maxBroadcasts*/ 2));
        CHECK(g.allowBroadcast(7, 2, 2));
        CHECK_EQ(g.size(), static_cast<std::size_t>(2));
        CHECK(g.allowBroadcast(7, 3, 2));          // evicts generation 1
        CHECK_EQ(g.size(), static_cast<std::size_t>(2));

        // The flood bound is per *resident* generation, not absolute: generation
        // 1 was evicted with one broadcast claimed, so it starts over and this
        // node can put it on the medium maxBroadcasts times again. That is a
        // real consequence of golden rule 5 for the #173/#174 bound -- worth
        // pinning, because it means the per-node guarantee degrades to
        // "maxBroadcasts per generation per residency" once a node sees more
        // than maxHistory concurrent generations. The shipped cap is large
        // enough that this does not arise in the evaluated scenarios; the test
        // exists so that a future reduction of maxHistory cannot silently
        // weaken the flood bound.
        CHECK(g.allowBroadcast(7, 1, 2));
        CHECK(g.allowBroadcast(7, 1, 2));
        CHECK(!g.allowBroadcast(7, 1, 2));         // count binds again at 2

        // A generation that never left keeps its accumulated count.
        CHECK(g.allowBroadcast(7, 3, 2));          // second claim
        CHECK(!g.allowBroadcast(7, 3, 2));         // third refused
    }

    // maxEntries == 0 means unbounded for GenerationTracker too, matching
    // AntHistoryTracker -- the `maxEntries_ != 0` guard, not a 0-sized cap that
    // would evict every entry immediately.
    {
        GenerationTracker g(/*maxEntries*/ 0);
        for (std::uint32_t seq = 1; seq <= 64; ++seq) {
            CHECK(g.accept(1, seq, 2, 10.0, 9, a1, a2));
        }
        CHECK_EQ(g.size(), static_cast<std::size_t>(64));
    }

    return RUN_TESTS();
}
