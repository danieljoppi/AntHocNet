/**
 * The visited-node stack an ant carries.
 *
 * In the original NS-2 code this was a header-resident `AntTimeEntry**`
 * malloc'd array of heap pointers, which leaked, double-freed on broadcast
 * (the same header memory was reused by NS-2's packet pool), and serialized
 * as `sizeof(pointer)` bytes regardless of the real path length. Modelling it
 * as a value-type vector of PODs removes that entire class of bug.
 */
#ifndef ANTHOCNET_CORE_VISITED_PATH_H
#define ANTHOCNET_CORE_VISITED_PATH_H

#include <vector>

#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

/// One entry on an ant's visited-node stack: a node and the trip time the ant
/// took to reach it from the previous hop.
struct AntHop {
    NodeAddress node = kInvalidAddress;
    Time        time = 0.0;
};

using VisitedPath = std::vector<AntHop>;

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_VISITED_PATH_H
