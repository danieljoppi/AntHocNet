// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Built-in teaching scenarios: one per network family, shaped like the repo's
 * presets but scaled down to what reads well on a screen. They change the
 * scenario only -- mobility, channel, size, traffic -- never the protocol
 * Config (ADR-0019). The parity test runs every one of them.
 */
#ifndef AHN_WEB_SCENARIOS_H
#define AHN_WEB_SCENARIOS_H

#include <string>
#include <vector>

#include "ahn_web/sim.h"

namespace ahn_web {

/// Names accepted by buildScenario(), in display order.
std::vector<std::string> scenarioNames();

/// Populate an empty World with the named scenario. Returns false if unknown.
bool buildScenario(World& w, const std::string& name);

}  // namespace ahn_web

#endif  // AHN_WEB_SCENARIOS_H
