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

} // namespace core
} // namespace anthocnet
