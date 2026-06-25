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

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_ANT_HISTORY_H
