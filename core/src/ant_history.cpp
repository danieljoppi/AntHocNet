#include "anthocnet/core/ant_history.h"

namespace anthocnet {
namespace core {

bool AntHistoryTracker::record(NodeAddress src, std::uint32_t seqNum) {
    const Key key{src, seqNum};
    auto inserted = entries_.insert(key);
    if (!inserted.second) {
        return false;  // already seen
    }
    insertionOrder_.push_back(key);

    // FIFO eviction once the cap is exceeded.
    if (maxEntries_ != 0) {
        while (insertionOrder_.size() > maxEntries_) {
            entries_.erase(insertionOrder_.front());
            insertionOrder_.pop_front();
        }
    }
    return true;
}

bool AntHistoryTracker::seen(NodeAddress src, std::uint32_t seqNum) const {
    return entries_.find({src, seqNum}) != entries_.end();
}

void AntHistoryTracker::clear() {
    entries_.clear();
    insertionOrder_.clear();
}

bool GenerationTracker::accept(NodeAddress src, std::uint32_t seqNum,
                               std::uint32_t hops, Time time, double factor) {
    const Key key{src, seqNum};
    auto it = best_.find(key);
    if (it == best_.end()) {
        // First ant of this generation: always forward and record its metrics.
        best_.emplace(key, Best{hops, time});
        insertionOrder_.push_back(key);
        if (maxEntries_ != 0) {
            while (insertionOrder_.size() > maxEntries_) {
                best_.erase(insertionOrder_.front());
                insertionOrder_.pop_front();
            }
        }
        return true;
    }
    // A later ant of a known generation: admit only if both its hop count and
    // its travel time are within `factor` of the best seen (a bad/looping path
    // exceeds this and is dropped). Admitted ants refresh the per-metric minima.
    Best& b = it->second;
    if (static_cast<double>(hops) <= factor * static_cast<double>(b.hops) &&
        time <= factor * b.time) {
        if (hops < b.hops) b.hops = hops;
        if (time < b.time) b.time = time;
        return true;
    }
    return false;
}

void GenerationTracker::clear() {
    best_.clear();
    insertionOrder_.clear();
}

} // namespace core
} // namespace anthocnet
