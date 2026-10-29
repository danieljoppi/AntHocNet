// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Link-lifetime prediction (#574): how long two nodes stay within radio range
 * if both keep their current velocity -- the link expiration time (LET) of Su,
 * Lee and Gerla, "Mobility prediction and routing in ad hoc wireless networks"
 * (2001), in 3-D. Pure arithmetic over Kinematics (ADR-0025); the router turns
 * it into a next-hop discount.
 */
#ifndef ANTHOCNET_CORE_LINK_LIFETIME_H
#define ANTHOCNET_CORE_LINK_LIFETIME_H

#include <cmath>
#include <limits>

#include "anthocnet/core/types.h"

namespace anthocnet {
namespace core {

/// Seconds until `a` and `b` are `range` metres apart, moving as they move
/// now. +inf when they never separate (same velocity, or approaching for
/// ever is impossible: a quadratic with a > 0 always has a root, so +inf
/// means zero relative velocity inside range). 0 when they are already out
/// of range.
inline double linkExpiryTime(const Kinematics& a, const Kinematics& b, double range) {
    const double dx = b.x - a.x, dy = b.y - a.y, dz = b.z - a.z;
    const double vx = b.vx - a.vx, vy = b.vy - a.vy, vz = b.vz - a.vz;
    const double c = dx * dx + dy * dy + dz * dz - range * range;
    if (c > 0.0) return 0.0;  // already beyond range
    const double qa = vx * vx + vy * vy + vz * vz;
    if (qa <= 0.0) return std::numeric_limits<double>::infinity();
    const double qb = 2.0 * (dx * vx + dy * vy + dz * vz);
    // c <= 0 and qa > 0: the discriminant is >= qb^2, so the larger root is
    // the non-negative time the separation reaches `range`.
    return (-qb + std::sqrt(qb * qb - 4.0 * qa * c)) / (2.0 * qa);
}

/// The next-hop weight for a link expected to live `let` seconds: 1 at or
/// beyond `horizon`, falling linearly below it, never under `floor` (a short
/// link is discouraged, not removed: if every link is short the choice among
/// them is the pheromone's).
inline double linkLifetimeWeight(double let, double horizon, double floor) {
    if (!(horizon > 0.0) || let >= horizon) return 1.0;
    const double w = let / horizon;
    return w < floor ? floor : w;
}

}  // namespace core
}  // namespace anthocnet

#endif  // ANTHOCNET_CORE_LINK_LIFETIME_H
