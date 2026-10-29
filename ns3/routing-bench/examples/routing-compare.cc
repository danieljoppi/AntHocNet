// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * The protocol-agnostic comparison harness (ADR-0027): every arm installed
 * beside routing-bench, on identical seeds. See docs/comparison-harness.md.
 */

#include "ns3/routing-bench-arm.h"

namespace ns3 {
namespace bench {
void RegisterInstalledArms();  // arms-generated.cc
}  // namespace bench
}  // namespace ns3

int main(int argc, char* argv[]) {
    ns3::bench::RegisterInstalledArms();
    return ns3::bench::RunHarness(argc, argv, "routing-compare");
}
