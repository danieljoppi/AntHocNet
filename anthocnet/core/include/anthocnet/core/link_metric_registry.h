// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Name -> ILinkMetric registry (issue #143, epic #142).
 *
 * The ILinkMetric seam exists but is unreachable: both adapters pass nullptr,
 * so ClassicMetric is the only formula that can ever run. Selecting a metric
 * needs a name -> instance mapping, and that mapping belongs in the core rather
 * than in each adapter — otherwise NS-2 and NS-3 grow two switch statements
 * that can disagree about what a name means.
 *
 * Ownership / lifetime
 * --------------------
 * Lookup hands back a NON-OWNING pointer/reference to a function-local static
 * instance, one per registered name, alive for the whole process. The caller
 * must not delete it and must not assume any per-node state.
 *
 * This is safe because a metric is a stateless strategy object: pheromone() is
 * const and reads only the LinkObservation it is handed, so a single instance
 * is shared by every node in a simulation without interference. It is also the
 * shape AntRouterLogic already wants — its constructor takes a bare
 * `const ILinkMetric*` and stores it without owning it, so a registry pointer
 * drops straight in and can never dangle. Handing out unique_ptr/shared_ptr
 * instead would push an ownership refactor through AntRouterLogic and both
 * adapters, buying nothing for an object that holds no state.
 *
 * Defaults and failure
 * --------------------
 * The default path does not go through here at all: with no explicit
 * selection, AntRouterLogic still falls back to its own ClassicMetric and
 * behaviour is byte-identical to before this file existed. An unknown name is
 * a loud error — never a quiet fall back to "classic" — because a mistyped
 * metric would otherwise produce plausible-looking results from the wrong
 * protocol.
 */
#ifndef ANTHOCNET_CORE_LINK_METRIC_REGISTRY_H
#define ANTHOCNET_CORE_LINK_METRIC_REGISTRY_H

#include <string>

#include "anthocnet/core/link_metric.h"

namespace anthocnet {
namespace core {
namespace metrics {

/// Registry name of the canonical AntHocNet metric (Eq.2, ClassicMetric).
/// This is the protocol default; the name is part of the adapter-facing
/// configuration surface, so it is stable.
constexpr char kClassic[] = "classic";

/// Every registered name, comma-separated — for diagnostics and for the
/// adapters' "valid values" help text (child #144).
std::string registeredNames();

/// Look up `name`; returns nullptr when it is not registered.
///
/// The non-throwing probe, for callers that prefer to raise the failure with
/// their own simulator's fatal-error mechanism. It never substitutes
/// ClassicMetric for an unknown name. Note that forwarding a nullptr on to
/// AntRouterLogic *would* silently mean "classic", so the null case must be
/// handled here, not passed along.
const ILinkMetric* find(const std::string& name);

/// Look up `name`, or throw std::invalid_argument naming the offending value
/// and the registered alternatives. Use this on configuration paths that must
/// not proceed on a typo.
///
/// The rest of the core is exception-free by convention (the codec reports
/// malformed input with a bool because it runs per packet on untrusted bytes).
/// This is one-shot configuration, not a hot path, and it must be impossible
/// to ignore — hence the throw.
const ILinkMetric& get(const std::string& name);

} // namespace metrics
} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_LINK_METRIC_REGISTRY_H
