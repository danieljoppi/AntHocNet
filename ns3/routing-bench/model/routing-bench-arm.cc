// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "routing-bench-arm.h"

#include "ns3/abort.h"

namespace ns3 {
namespace bench {

bool ArmRegistry::Add(const std::string& name, const std::string& summary, ArmFactory make) {
    if (name.empty() || make == nullptr || m_arms.count(name) != 0) return false;
    m_arms.emplace(name, Entry{summary, make});
    return true;
}

Ptr<Arm> ArmRegistry::Make(const std::string& name) const {
    auto it = m_arms.find(name);
    return it == m_arms.end() ? nullptr : it->second.make();
}

bool ArmRegistry::Has(const std::string& name) const { return m_arms.count(name) != 0; }

std::vector<std::string> ArmRegistry::Names() const {
    std::vector<std::string> names;
    for (const auto& kv : m_arms) names.push_back(kv.first);
    return names;
}

std::string ArmRegistry::Summary(const std::string& name) const {
    auto it = m_arms.find(name);
    return it == m_arms.end() ? std::string() : it->second.summary;
}

ArmRegistry& Registry() {
    static ArmRegistry registry;
    return registry;
}

void RegisterArm(const std::string& name, const std::string& summary, ArmFactory make) {
    NS_ABORT_MSG_UNLESS(Registry().Add(name, summary, make),
                        "routing-bench: cannot register arm '"
                            << name << "' (empty name, null factory, or the name is taken)");
}

}  // namespace bench
}  // namespace ns3
