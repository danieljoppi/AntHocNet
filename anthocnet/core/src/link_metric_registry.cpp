// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "anthocnet/core/link_metric_registry.h"

#include <cstddef>
#include <stdexcept>
#include <vector>

namespace anthocnet {
namespace core {
namespace metrics {
namespace {

struct Entry {
    const char*        name;
    const ILinkMetric* metric;
};

/// The registry itself: a fixed table built on first use.
///
/// Function-local statics give one immutable instance per name, constructed
/// lazily (so there is no static-initialisation-order dependency between
/// translation units) and destroyed only at process exit — which is what makes
/// the non-owning pointers handed to AntRouterLogic safe for the lifetime of a
/// simulation. Registration is a compile-time table rather than a runtime
/// register() call because every metric lives in core/ anyway; adding one
/// (#145, #146) is one include plus one line here.
const std::vector<Entry>& table() {
    static const ClassicMetric classic;
    static const std::vector<Entry> entries = {
        {kClassic, &classic},
    };
    return entries;
}

}  // namespace

std::string registeredNames() {
    std::string out;
    for (std::size_t i = 0; i < table().size(); ++i) {
        if (i != 0) out += ", ";
        out += table()[i].name;
    }
    return out;
}

const ILinkMetric* find(const std::string& name) {
    for (std::size_t i = 0; i < table().size(); ++i) {
        if (name == table()[i].name) return table()[i].metric;
    }
    return nullptr;  // unknown: never fall back to ClassicMetric
}

const ILinkMetric& get(const std::string& name) {
    const ILinkMetric* metric = find(name);
    if (metric == nullptr) {
        throw std::invalid_argument("anthocnet: unknown link metric \"" + name +
                                    "\" (registered: " + registeredNames() + ")");
    }
    return *metric;
}

}  // namespace metrics
}  // namespace core
}  // namespace anthocnet
