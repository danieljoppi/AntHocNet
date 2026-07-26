#include "anthocnet/core/ant_history.h"

#include <algorithm>

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

const std::size_t GenerationTracker::kMaxFirstHops;

namespace {

/// Is `firstHop` one this generation has not admitted before? At the cap the
/// answer is "no" regardless — the restrictive factor applies, see kMaxFirstHops.
bool isNewFirstHop(const std::vector<NodeAddress>& seen, NodeAddress firstHop) {
    if (firstHop == kInvalidAddress) return false;
    if (seen.size() >= GenerationTracker::kMaxFirstHops) return false;
    return std::find(seen.begin(), seen.end(), firstHop) == seen.end();
}

/// Record `firstHop` as admitted for this generation, up to the cap.
void noteFirstHop(std::vector<NodeAddress>& seen, NodeAddress firstHop) {
    if (!isNewFirstHop(seen, firstHop)) return;
    seen.push_back(firstHop);
}

}  // namespace

bool GenerationTracker::accept(NodeAddress src, std::uint32_t seqNum,
                               std::uint32_t hops, Time time,
                               NodeAddress firstHop, double factor,
                               double factorNewHop) {
    const Key key{src, seqNum};
    auto it = best_.find(key);
    if (it == best_.end()) {
        // First ant of this generation: always forward and record its metrics
        // (and its first hop, so the next ant can tell whether it is disjoint).
        Best fresh{hops, time, 0, {}};
        noteFirstHop(fresh.firstHops, firstHop);
        best_.emplace(key, std::move(fresh));
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
    // its travel time are within the applicable factor of the best seen (a
    // bad/looping path exceeds this and is dropped). Which factor applies is
    // decided by the ant's first hop (#177 arm B, 2007 thesis lines 4667-4671):
    // an unseen first hop means a disjoint branch, and earns the less
    // restrictive a2; a repeated one is judged against the strict a1. Admitted
    // ants refresh the per-metric minima.
    Best& b = it->second;
    const double f = isNewFirstHop(b.firstHops, firstHop) ? factorNewHop : factor;
    if (static_cast<double>(hops) <= f * static_cast<double>(b.hops) &&
        time <= f * b.time) {
        if (hops < b.hops) b.hops = hops;
        if (time < b.time) b.time = time;
        noteFirstHop(b.firstHops, firstHop);
        return true;
    }
    return false;
}

bool GenerationTracker::allowBroadcast(NodeAddress src, std::uint32_t seqNum,
                                      int maxBroadcasts) {
    if (maxBroadcasts < 0) return true;               // unlimited
    const Key key{src, seqNum};
    auto it = best_.find(key);
    if (it == best_.end()) {
        // No accept() record (multipath off, or an originating ant): track the
        // generation so its broadcasts are still counted.
        best_.emplace(key, Best{0, 0.0, 0, {}});
        insertionOrder_.push_back(key);
        if (maxEntries_ != 0) {
            while (insertionOrder_.size() > maxEntries_) {
                best_.erase(insertionOrder_.front());
                insertionOrder_.pop_front();
            }
        }
        it = best_.find(key);
    }
    if (it->second.broadcasts >= maxBroadcasts) return false;
    it->second.broadcasts += 1;
    return true;
}

void GenerationTracker::clear() {
    best_.clear();
    insertionOrder_.clear();
}

} // namespace core
} // namespace anthocnet
