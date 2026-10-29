// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * The comparison harness under its original name (ADR-0027 §4): the same
 * program as routing-compare, same arguments, same output, kept so committed
 * campaign plans, benchmark-cell dispatches and campaign.py keep working.
 * Kept at least through v3.x.
 */

#include "ns3/routing-bench-arm.h"

namespace ns3 {
namespace bench {
void RegisterInstalledArms();  // arms-generated.cc
}  // namespace bench
}  // namespace ns3

int main(int argc, char* argv[]) {
    ns3::bench::RegisterInstalledArms();
    return ns3::bench::RunHarness(argc, argv, "anthocnet-compare");
}
