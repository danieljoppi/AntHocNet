// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef ROUTING_BENCH_STOCK_ARMS_H
#define ROUTING_BENCH_STOCK_ARMS_H

namespace ns3 {
namespace bench {

/**
 * Register the arms that ship with stock ns-3: aodv, olsr, dsdv and hwmp
 * (ADR-0027 §1). Registration is an explicit call, never a static
 * initialiser (ADR-0027 §3). Call it once, before the first run.
 *
 * hwmp's 802.11s devices are still installed by the harness itself; they
 * move into the arm's InstallDevices hook with the extraction (#767).
 */
void RegisterStockArms();

}  // namespace bench
}  // namespace ns3

#endif  // ROUTING_BENCH_STOCK_ARMS_H
