// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi
//
// Core speed benchmarks (#620): the cost of the core's hot paths with no
// simulator around them, so a core change that makes AntHocNet slower is
// visible on its own. The harness's ##PERF## (#131) cannot tell: it mixes the
// core with ns-3's PHY/MAC and moves with every scenario knob.
//
// Hand-rolled timer loop, no dependency (golden rule 1 keeps core/ standalone).
// Each case is calibrated to run for about kTargetSeconds, then measured
// kRounds times; the median ns/op is reported, the spread with it.
//
//   bench_core            human-readable table
//   bench_core --csv      case,ns_per_op,min_ns,max_ns  (what CI records)
//   bench_core --quick    shorter rounds, for a smoke run
//
// The numbers are only comparable on one machine: CI compares a PR against its
// base on the same runner (core-bench.yml), never against another runner's
// history.

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <string>
#include <vector>

#include "anthocnet/core/ant_history.h"
#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/ant_message_codec.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_table.h"
#include "anthocnet/core/ports.h"

using namespace anthocnet::core;

namespace {

// Deterministic xorshift64*, so every run draws the same sequence.
class XorShiftRng : public IRng {
public:
    double uniform() override { return (next() >> 11) * (1.0 / 9007199254740992.0); }
    int uniformInt(int n) override {
        return static_cast<int>(next() % static_cast<std::uint64_t>(n));
    }
    std::uint64_t next() {
        s_ ^= s_ >> 12;
        s_ ^= s_ << 25;
        s_ ^= s_ >> 27;
        return s_ * 0x2545F4914F6CDD1DULL;
    }

private:
    std::uint64_t s_ = 0x9E3779B97F4A7C15ULL;
};

// Keeps the optimiser from deleting the work being timed.
volatile std::uint64_t g_sink = 0;

struct Result {
    std::string name;
    double median, min, max;  // ns per op
};

double g_target = 0.2;  // seconds per round
int g_rounds = 7;

// body(n) runs the operation n times.
Result measure(const std::string& name, const std::function<void(std::uint64_t)>& body) {
    using Clock = std::chrono::steady_clock;
    auto seconds = [](Clock::time_point a, Clock::time_point b) {
        return std::chrono::duration<double>(b - a).count();
    };
    std::uint64_t n = 1;
    for (;;) {  // calibrate: grow n until one batch takes a tenth of a round
        auto t0 = Clock::now();
        body(n);
        double s = seconds(t0, Clock::now());
        if (s >= g_target / 10 || n >= (1ULL << 40)) {
            n = std::max<std::uint64_t>(
                1, static_cast<std::uint64_t>(n * (g_target / std::max(s, 1e-9))));
            break;
        }
        n *= 4;
    }
    std::vector<double> ns;
    for (int r = 0; r < g_rounds; ++r) {
        auto t0 = Clock::now();
        body(n);
        ns.push_back(seconds(t0, Clock::now()) * 1e9 / static_cast<double>(n));
    }
    std::sort(ns.begin(), ns.end());
    return {name, ns[ns.size() / 2], ns.front(), ns.back()};
}

// A table at a node with `degree` neighbours and `dests` destinations, every
// neighbour holding regular and virtual pheromone toward every destination.
PheromoneTable makeTable(int degree, int dests, XorShiftRng& rng) {
    PheromoneTable t;
    for (int nb = 1; nb <= degree; ++nb) t.addNeighbor(static_cast<NodeAddress>(nb));
    for (int d = 0; d < dests; ++d) {
        auto dest = static_cast<NodeAddress>(1000 + d);
        for (int nb = 1; nb <= degree; ++nb) {
            t.setPheromoneRegular(dest, static_cast<NodeAddress>(nb), 0.1 + rng.uniform());
            t.setPheromoneVirtual(dest, static_cast<NodeAddress>(nb), 0.1 + rng.uniform());
        }
    }
    return t;
}

// A forward ant at the wire bound: kMaxVisitedOnWire hops on its stack.
AntMessage fullForwardAnt() {
    AntMessage m;
    m.type = AntType::Reactive;
    m.direction = AntDirection::Up;
    m.src = 1;
    m.dst = 2;
    m.seqNum = 123456;
    m.timeStart = 1.5;
    for (std::uint16_t i = 0; i < codec::kMaxVisitedOnWire; ++i) {
        AntHop h;
        h.node = static_cast<NodeAddress>(100 + i);
        h.time = 0.001 * i;
        m.visited.push_back(h);
    }
    return m;
}

}  // namespace

int main(int argc, char** argv) {
    bool csv = false;
    for (int i = 1; i < argc; ++i) {
        if (std::strcmp(argv[i], "--csv") == 0)
            csv = true;
        else if (std::strcmp(argv[i], "--quick") == 0) {
            g_target = 0.02;
            g_rounds = 3;
        } else {
            std::fprintf(stderr, "usage: %s [--csv] [--quick]\n", argv[0]);
            return 2;
        }
    }

    const Config cfg;
    std::vector<Result> results;

    // 1. Pheromone update: the deposit a backward ant makes at each node,
    //    on a 16-neighbour, 64-destination table.
    {
        XorShiftRng rng;
        PheromoneTable t = makeTable(16, 64, rng);
        results.push_back(measure("pheromone_update", [&](std::uint64_t n) {
            for (std::uint64_t i = 0; i < n; ++i) {
                std::uint64_t r = rng.next();
                auto nb = static_cast<NodeAddress>(1 + r % 16);
                auto dest = static_cast<NodeAddress>(1000 + (r >> 8) % 64);
                t.addPheromoneRegular(dest, nb, 0.5);
            }
            g_sink = g_sink + t.numEntriesRegular();
        }));
    }

    // 2. Stochastic next-hop selection (data, beta = betaData) at three
    //    neighbourhood sizes: the per-packet decision.
    for (int degree : {4, 16, 64}) {
        XorShiftRng rng;
        PheromoneTable t = makeTable(degree, 8, rng);
        results.push_back(
            measure("select_next_hop_" + std::to_string(degree), [&](std::uint64_t n) {
                std::uint64_t acc = 0;
                for (std::uint64_t i = 0; i < n; ++i) {
                    auto dest = static_cast<NodeAddress>(1000 + i % 8);
                    acc += t.nextNeighborNode(dest, false, cfg.betaData, rng);
                }
                g_sink = g_sink + acc;
            }));
    }

    // 3. Codec of a full forward ant (kMaxVisitedOnWire hops).
    {
        const AntMessage m = fullForwardAnt();
        std::vector<std::uint8_t> buf;
        results.push_back(measure("codec_encode_full_ant", [&](std::uint64_t n) {
            for (std::uint64_t i = 0; i < n; ++i) codec::serialize(m, buf);
            g_sink = g_sink + buf.size();
        }));
        const std::vector<std::uint8_t> wire = codec::serialize(m);
        AntMessage out;
        results.push_back(measure("codec_decode_full_ant", [&](std::uint64_t n) {
            std::uint64_t ok = 0;
            for (std::uint64_t i = 0; i < n; ++i) ok += codec::deserialize(wire, out) ? 1 : 0;
            g_sink = g_sink + ok + out.visited.size();
        }));
    }

    // 4. History dedup at steady state: a full tracker (Config::maxHistory)
    //    recording a new (src, seq) evicts the oldest one each time.
    {
        AntHistoryTracker h(cfg.maxHistory);
        std::uint32_t seq = 0;
        for (std::size_t i = 0; i < cfg.maxHistory; ++i)
            h.record(static_cast<NodeAddress>(i % 32), seq++);
        results.push_back(measure("history_dedup", [&](std::uint64_t n) {
            std::uint64_t fresh = 0;
            for (std::uint64_t i = 0; i < n; ++i) {
                fresh += h.record(static_cast<NodeAddress>(seq % 32), seq) ? 1 : 0;
                ++seq;
            }
            g_sink = g_sink + fresh;
        }));
    }

    if (csv) {
        std::printf("case,ns_per_op,min_ns,max_ns\n");
        for (const auto& r : results)
            std::printf("%s,%.2f,%.2f,%.2f\n", r.name.c_str(), r.median, r.min, r.max);
    } else {
        std::printf("%-24s %12s %12s %12s\n", "case", "ns/op", "min", "max");
        for (const auto& r : results)
            std::printf("%-24s %12.1f %12.1f %12.1f\n", r.name.c_str(), r.median, r.min, r.max);
    }
    return 0;
}
