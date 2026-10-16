// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef AHN_WEB_XRAY_H
#define AHN_WEB_XRAY_H

/**
 * @file
 * The ant X-ray (#637): an ant's wire bytes decoded by the core's own codec
 * into a small JSON object. The game shows these fields beside the bytes; the
 * native build prints the same JSON for the same bytes (ahn-web-trace
 * --decode), and web/test/xray.test.mjs requires the two to agree.
 */
#include <cstdint>
#include <cstdio>
#include <string>
#include <vector>

#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/ant_message_codec.h"

namespace ahn_web {

/// `bytes` decoded by core::codec::deserialize, as JSON. Doubles print with 17
/// significant digits, so they parse back to the identical value.
inline std::string antJson(const std::vector<std::uint8_t>& bytes) {
    anthocnet::core::AntMessage m;
    if (bytes.empty() || !anthocnet::core::codec::deserialize(bytes, m)) return "{\"ok\":false}";
    char buf[96];
    std::string s = "{\"ok\":true";
    auto num = [&](const char* key, double v) {
        std::snprintf(buf, sizeof buf, ",\"%s\":%.17g", key, v);
        s += buf;
    };
    auto pairs = [&](const char* key, const auto& list, auto second) {
        s += ",\"";
        s += key;
        s += "\":[";
        bool first = true;
        for (const auto& e : list) {
            std::snprintf(buf, sizeof buf, "%s[%d,%.17g]", first ? "" : ",",
                          static_cast<int>(e.node), second(e));
            s += buf;
            first = false;
        }
        s += "]";
    };
    num("version", bytes[0]);
    num("type", static_cast<int>(m.type));
    num("direction", static_cast<int>(m.direction));
    num("src", m.src);
    num("dst", m.dst);
    num("seqNum", m.seqNum);
    num("timeStart", m.timeStart);
    num("lifeAnt", m.lifeAnt);
    num("broadcastBudget", m.broadcastBudget);
    num("length", static_cast<double>(bytes.size()));
    pairs("visited", m.visited, [](const anthocnet::core::AntHop& h) { return h.time; });
    pairs("history", m.history, [](const anthocnet::core::AntHop& h) { return h.time; });
    pairs("helloDests", m.helloDests,
          [](const anthocnet::core::HelloDest& d) { return d.pheromone; });
    return s + "}";
}

}  // namespace ahn_web

#endif  // AHN_WEB_XRAY_H
