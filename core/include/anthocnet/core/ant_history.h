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
/// travel time are within `factor` of that best — so several *good* paths get
/// laid down instead of only the first-arriving one. Bounded FIFO like
/// AntHistoryTracker (golden rule 5).
class GenerationTracker {
public:
    /// maxEntries == 0 means unbounded.
    explicit GenerationTracker(std::size_t maxEntries) : maxEntries_(maxEntries) {}

    /// Decide whether to forward a reactive forward ant carrying `hops`/`time`.
    /// The first ant of a generation is always admitted; a later one only if
    /// `hops <= factor*bestHops && time <= factor*bestTime`. Admitted ants
    /// refresh the per-metric minimums. Returns false to drop.
    bool accept(NodeAddress src, std::uint32_t seqNum, std::uint32_t hops,
                Time time, double factor);

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

    void clear();

private:
    struct Best { std::uint32_t hops; Time time; int broadcasts; };
    using Key = std::pair<NodeAddress, std::uint32_t>;

    std::size_t        maxEntries_;
    std::map<Key, Best> best_;
    std::deque<Key>    insertionOrder_;  // for FIFO eviction
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_HISTORY_H
