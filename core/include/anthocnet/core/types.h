/**
 * Simulator-agnostic fundamental types for the AntHocNet algorithm core.
 *
 * Nothing in core/ may include an NS-2 or NS-3 header. Addresses are modelled
 * with a plain integer so both simulators (whose own address types are
 * integral) can pass values straight through their adapters.
 */
#ifndef ANTHOCNET_CORE_TYPES_H
#define ANTHOCNET_CORE_TYPES_H

#include <cstdint>

namespace anthocnet {
namespace core {

/// Network-layer node address. Matches the width of ns-2's nsaddr_t and
/// ns-3's 32-bit IPv4 address payload.
using NodeAddress = std::int32_t;

/// Simulation time, in seconds.
using Time = double;

/// "No such node / no route" sentinel, mirroring the legacy use of -1.
constexpr NodeAddress kInvalidAddress = -1;

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_TYPES_H
