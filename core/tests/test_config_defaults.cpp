// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Pins every documented default of anthocnet::core::Config, verbatim and in
 * declaration order, against docs/configuration.md §3.1 (issue #258).
 *
 * A default that changes without this test changing is a silent leak: PR #252
 * shipped proactiveInterval 10 -> 2 while claiming not to, and the resulting
 * NRL x4.7 / PDR -12 pp took a two-day benchmark hunt to trace (#254). With
 * this test, `make test` fails at the offending commit and names the field.
 *
 * If a default is changed *deliberately*, update the assertion here, the table
 * in docs/configuration.md §3.1, and the adapter defaults checked by
 * ns3/tools/check-default-parity.py in the same commit.
 */
#include "anthocnet/core/config.h"
#include "test_support.h"

using anthocnet::core::Config;

int main() {
    const Config c;

    CHECK_EQ(c.alpha, 0.7);                     // legacy ALFA; meaning per ADR-0012
    CHECK_EQ(c.gamma, 0.7);                     // legacy GAMA; [1] §3.1
    CHECK_EQ(c.betaAnts, 20.0);                 // thesis beta1/beta2 (#179)
    CHECK_EQ(c.betaData, 20.0);                 // thesis beta3 (#179)
    CHECK_EQ(c.hopTimeSec, 0.003);              // #88 thesis 3ms
    CHECK_EQ(c.enableMacMetric, false);         // A2 gate, default off
    CHECK_EQ(c.minPheromone, 0.00001);          // legacy MIN_PHEROMONE
    CHECK_EQ(c.enableEvaporation, true);        // ADR-0012
    CHECK_EQ(c.evaporationInterval, 1.0);       // ADR-0012
    CHECK_EQ(c.reactiveRetryInterval, 1.0);     // mechanism [1] §4.2 cite (thesis §4.1.2)
    CHECK_EQ(c.enableProactive, true);          // ADR-0007
    CHECK_EQ(c.enableDiffusion, true);          // ADR-0007
    CHECK_EQ(c.enableReactive, true);           // ant-type ablation gate
    CHECK_EQ(c.enableRepair, true);             // [1] §3.5 gate
    CHECK_EQ(c.enableLinkFail, true);           // [1] §3.5 gate
    CHECK_EQ(c.enableDirectedReactive, false);  // repo choice, deviation from [1] §3.1, off
    CHECK_EQ(c.proactiveBroadcastProb, 0.1);    // [1] §3.3
    CHECK_EQ(c.sessionTtl, 5.0);                // repo choice
    CHECK_EQ(c.proactiveVirtualMargin, 0.0);    // #180 gate OFF — deliberately NOT thesis 0.10
    CHECK_EQ(c.helloInterval, 1.0);             // [1] §3.3 fn.1
    CHECK_EQ(c.proactiveInterval, 10.0);        // #182 repo value; thesis 2s is #248's A/B (#252/#254 leak)
    CHECK_EQ(c.lifeAnt, 2.0);                   // legacy constant (inert, #182)
    CHECK_EQ(c.allowedHelloLoss, 2);            // [1] §3.5 (digest: §3.3 fn.1)
    CHECK_EQ(c.repairMaxBroadcasts, 2);         // [1] §3.5 (digest: §3.4)
    CHECK_EQ(c.linkfailNotifyInterval, 5.0);    // #20 sweep
    CHECK_EQ(c.txFailureThreshold, 3);          // #19 / ADR-0008 detector D
    CHECK_EQ(c.reactiveMaxBroadcasts, -1);      // #177 unbounded (band self-limits; unit history #169/#173)
    CHECK_EQ(c.enableMultipath, true);          // [1] §3.1 / #96
    CHECK_EQ(c.antAcceptanceFactor, 0.9);       // thesis a1 (#177)
    CHECK_EQ(c.antAcceptanceFactorNewHop, 2.0); // thesis a2 (#177)
    CHECK_EQ(c.proactiveMaxBroadcasts, 2);      // [1] §3.3 / #45
    CHECK_EQ(c.repairWaitFactor, 5.0);          // [1] §3.5 (digest: §3.4)
    CHECK_EQ(c.repairTimeout, 1.0);             // repo fallback, unsourced
    CHECK_EQ(c.networkDiameter, 30);            // legacy constant (dead in core/, #182)
    CHECK_EQ(c.maxPathLength, static_cast<std::size_t>(100));  // golden rule 5; wire kMaxVisitedOnWire
    CHECK_EQ(c.maxHistory, static_cast<std::size_t>(4096));    // golden rule 5

    return RUN_TESTS();
}
