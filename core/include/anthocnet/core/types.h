// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

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

/// A node's position (m) and velocity (m/s) in the adapter's Cartesian frame
/// (ADR-0025). Only ever compared between nodes of one simulation, so the
/// frame needs no geodesy.
struct Kinematics {
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;
    double vx = 0.0;
    double vy = 0.0;
    double vz = 0.0;
};

}  // namespace core
}  // namespace anthocnet

#endif  // ANTHOCNET_CORE_TYPES_H
