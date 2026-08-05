// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * AntHistoryTracker: (src, seqNum) duplicate detection.
 *
 * Replaces the unbounded std::set<AntHistory> that lived in AntNest. The set
 * grew for the entire run; here it is capped (FIFO eviction) so memory stays
 * bounded on long simulations.
 */
#ifndef ANTHOCNET_CORE_ANT_HISTORY_H
#define ANTHOCNET_CORE_ANT_HISTORY_H

#include <cstddef>
#include <cstdint>
#include <deque>
#include <map>
#include <set>
#include <utility>
#include <vector>

#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

class AntHistoryTracker {
public:
    /// maxEntries == 0 means unbounded.
    explicit AntHistoryTracker(std::size_t maxEntries) : maxEntries_(maxEntries) {}

    /// Record (src, seq). Returns true if it was new, false if already seen
    /// (i.e. a looping/duplicate ant that should be dropped).
    bool record(NodeAddress src, std::uint32_t seqNum);

    /// Read-only membership test.
    bool seen(NodeAddress src, std::uint32_t seqNum) const;

    std::size_t size() const { return entries_.size(); }
    void clear();

private:
    using Key = std::pair<NodeAddress, std::uint32_t>;

    std::size_t        maxEntries_;
    std::set<Key>      entries_;
    std::deque<Key>    insertionOrder_;  // for FIFO eviction
};

/// Multipath acceptance filter for reactive forward ants ([1] §3.1, issue #96).
/// Tracks, per (src, seq) generation, the best (fewest-hop / least-time) ant
/// seen, and admits a later same-generation ant only when both its hops and its
/// travel time are within an acceptance factor of that best — so several *good*
/// paths get laid down instead of only the first-arriving one. Bounded FIFO like
/// AntHistoryTracker (golden rule 5).
///
/// The factor is not a single number (#177). The 2007 thesis applies a
/// *low* base factor a1 (0.9) to ants whose first hop has already been seen, and
/// a *higher* factor a2 (2.0) to an ant arriving over a first hop no previously
/// accepted ant of that generation used — "to boost the creation of disjoint
/// paths" (thesis lines 4655-4659 and 4667-4671, quoted in config.h). So the
/// tracker also records, per generation, which first hops it has admitted.
class GenerationTracker {
public:
    /// Cap on the per-generation set of admitted first hops (golden rule 5).
    ///
    /// The set only has to answer "have I already admitted an ant that came in
    /// via this first hop?", and it is consulted only to *relax* the band, so a
    /// small cap costs nothing but bounds the memory a single generation can
    /// pin. 8 is the neighbourhood scale these grids/scenarios run at (the
    /// 8-connected testbench grid has interior degree 8), i.e. large enough
    /// that a node normally never reaches it.
    ///
    /// Behaviour at the cap is deliberately the *restrictive* one: once 8
    /// distinct first hops have been admitted for a generation, further unseen
    /// first hops are treated as already seen and judged against a1. The node
    /// has by then already granted the disjointness boost eight times, and the
    /// alternative — keep granting a2 to every new first hop forever — would
    /// make the relaxation the very unbounded term the cap exists to prevent.
    static const std::size_t kMaxFirstHops = 8;

    /// maxEntries == 0 means unbounded.
    explicit GenerationTracker(std::size_t maxEntries) : maxEntries_(maxEntries) {}

    /// Decide whether to forward a reactive forward ant carrying `hops`/`time`
    /// and whose path's first hop after the source is `firstHop`.
    ///
    /// The first ant of a generation is always admitted; a later one only if
    /// `hops <= f*bestHops && time <= f*bestTime`, where `f` is `factorNewHop`
    /// (a2) when `firstHop` is not among those already admitted for this
    /// generation and `factor` (a1) when it is. Admitted ants refresh the
    /// per-metric minimums and record their first hop. Returns false to drop.
    bool accept(NodeAddress src, std::uint32_t seqNum, std::uint32_t hops,
                Time time, NodeAddress firstHop, double factor,
                double factorNewHop);

    /// Claim one broadcast of this generation *at this node* (#173). Returns
    /// false once `maxBroadcasts` have already been claimed; `maxBroadcasts < 0`
    /// means unlimited.
    ///
    /// This is the flood bound for reactive forward ants. `accept()` cannot
    /// serve as one: it admits rather than suppresses, so in a dense graph a
    /// node keeps re-broadcasting the same generation as comparable copies
    /// arrive from each neighbour, and each re-broadcast seeds more admissible
    /// copies. Counting *per (node, generation)* bounds that without limiting
    /// reach — unlike a budget carried on the ant and decremented at each hop,
    /// which is a hop limit on discovery (#169).
    bool allowBroadcast(NodeAddress src, std::uint32_t seqNum, int maxBroadcasts);

    /// Generations currently resident. Mirrors AntHistoryTracker::size(); the
    /// cap it is checked against is the golden-rule-5 bound (#166).
    std::size_t size() const { return best_.size(); }

    void clear();

private:
    struct Best {
        std::uint32_t hops;
        Time          time;
        int           broadcasts;
        /// First hops of the ants admitted for this generation, capped at
        /// kMaxFirstHops. A vector, not a set: it holds <= 8 elements, so a
        /// linear scan beats a node-per-entry container.
        std::vector<NodeAddress> firstHops;
    };
    using Key = std::pair<NodeAddress, std::uint32_t>;

    std::size_t        maxEntries_;
    std::map<Key, Best> best_;
    std::deque<Key>    insertionOrder_;  // for FIFO eviction
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_HISTORY_H
