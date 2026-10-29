// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef ROUTING_BENCH_URBAN_OBSTACLE_LOSS_MODEL_H
#define ROUTING_BENCH_URBAN_OBSTACLE_LOSS_MODEL_H

#include "ns3/double.h"
#include "ns3/mobility-model.h"
#include "ns3/propagation-loss-model.h"
#include "ns3/string.h"
#include "ns3/uinteger.h"

#include <algorithm>
#include <cmath>
#include <sstream>
#include <string>
#include <vector>

namespace ns3 {
namespace bench {

// --- Urban building shadowing (#488, the VANET family #301) ------------------
// The obstacle model of Sommer, Eckhoff, German & Dressler, "A computationally
// inexpensive empirical model of IEEE 802.11p radio shadowing in urban
// environments", WONS 2011 -- the model Veins ships. Each building the
// line of sight crosses adds
//     L_obs = DbPerCut * n + DbPerMeter * d_m
// where n is the number of building walls the line cuts and d_m the length of
// the line inside buildings. Defaults are Veins' shipped building type
// (db-per-cut 9, db-per-meter 0.4), the values the paper fitted at 5.9 GHz;
// this harness keeps its 2.4 GHz 802.11b radio (ADR-0019: a family changes the
// scenario, not the stack), which docs/benchmarks/scenarios/vanet.md records as a threat
// to validity.
//
// Buildings are the blocks of the Manhattan grid --mobility=manhattan drives
// on: BlocksX x BlocksY blocks over AreaX x AreaY, each inset by half a
// StreetWidth from the street centre lines the vehicles travel. #580: an
// explicit Buildings list (rectangles "xmin,ymin,xmax,ymax;...") replaces the
// grid, for a scene whose buildings are not a street grid (the disaster
// family). A node inside a building then pays for the walls and the metres
// between it and the outside, which is the indoor/outdoor shadowing. The model is
// deterministic (no RNG), so it pins no stream and the oracle may evaluate it
// per pair (ns3/baselines/oracle: "decode-los-approx").
class UrbanObstacleShadowingLossModel : public PropagationLossModel {
public:
    static TypeId GetTypeId() {
        static TypeId tid =
            TypeId("ns3::UrbanObstacleShadowingLossModel")
                .SetParent<PropagationLossModel>()
                .SetGroupName("Propagation")
                .AddConstructor<UrbanObstacleShadowingLossModel>()
                .AddAttribute("AreaX", "Field width (m)", DoubleValue(1000.0),
                              MakeDoubleAccessor(&UrbanObstacleShadowingLossModel::m_areaX),
                              MakeDoubleChecker<double>(0.0))
                .AddAttribute("AreaY", "Field height (m)", DoubleValue(1000.0),
                              MakeDoubleAccessor(&UrbanObstacleShadowingLossModel::m_areaY),
                              MakeDoubleChecker<double>(0.0))
                .AddAttribute("BlocksX", "Blocks along x", UintegerValue(5),
                              MakeUintegerAccessor(&UrbanObstacleShadowingLossModel::m_blocksX),
                              MakeUintegerChecker<uint32_t>(1))
                .AddAttribute("BlocksY", "Blocks along y", UintegerValue(5),
                              MakeUintegerAccessor(&UrbanObstacleShadowingLossModel::m_blocksY),
                              MakeUintegerChecker<uint32_t>(1))
                .AddAttribute("StreetWidth",
                              "Street width (m); buildings are "
                              "inset by half of it from each street centre line",
                              DoubleValue(20.0),
                              MakeDoubleAccessor(&UrbanObstacleShadowingLossModel::m_street),
                              MakeDoubleChecker<double>(0.0))
                .AddAttribute("DbPerCut", "Loss per building wall crossed (dB)", DoubleValue(9.0),
                              MakeDoubleAccessor(&UrbanObstacleShadowingLossModel::m_dbPerCut),
                              MakeDoubleChecker<double>(0.0))
                .AddAttribute("DbPerMeter", "Loss per metre inside buildings (dB)",
                              DoubleValue(0.4),
                              MakeDoubleAccessor(&UrbanObstacleShadowingLossModel::m_dbPerMeter),
                              MakeDoubleChecker<double>(0.0))
                .AddAttribute("Buildings",
                              "#580: explicit buildings 'xmin,ymin,xmax,ymax;...' "
                              "(m); empty = the street grid's blocks",
                              StringValue(""),
                              MakeStringAccessor(&UrbanObstacleShadowingLossModel::SetBuildings,
                                                 &UrbanObstacleShadowingLossModel::GetBuildings),
                              MakeStringChecker());
        return tid;
    }

    // Obstacle loss (dB) on the straight line a -> b. Public so the CI smoke
    // can print it; the channel only ever reaches it through DoCalcRxPower.
    double ObstacleLossDb(const Vector& a, const Vector& b) const {
        const double dx = b.x - a.x, dy = b.y - a.y;
        const double len = std::sqrt(dx * dx + dy * dy);
        if (len <= 0.0) return 0.0;
        if (!m_rects.empty()) {
            double loss = 0.0;
            for (const Rect& r : m_rects) loss += RectLossDb(a, dx, dy, len, r);
            return loss;
        }
        const double bx = m_areaX / m_blocksX, by = m_areaY / m_blocksY;
        const double h = m_street / 2.0;
        // Only the blocks the segment's bounding box touches can be crossed.
        auto clampIdx = [](double v, double size, uint32_t n) {
            const double k = std::floor(v / size);
            return static_cast<uint32_t>(std::min(std::max(k, 0.0), n - 1.0));
        };
        const uint32_t i0 = clampIdx(std::min(a.x, b.x), bx, m_blocksX);
        const uint32_t i1 = clampIdx(std::max(a.x, b.x), bx, m_blocksX);
        const uint32_t j0 = clampIdx(std::min(a.y, b.y), by, m_blocksY);
        const uint32_t j1 = clampIdx(std::max(a.y, b.y), by, m_blocksY);
        double loss = 0.0;
        for (uint32_t i = i0; i <= i1; ++i) {
            for (uint32_t j = j0; j <= j1; ++j) {
                const Rect r{i * bx + h, j * by + h, (i + 1) * bx - h, (j + 1) * by - h};
                if (r.xmin >= r.xmax || r.ymin >= r.ymax) continue;
                loss += RectLossDb(a, dx, dy, len, r);
            }
        }
        return loss;
    }

    void SetBuildings(std::string spec) {
        m_spec = spec;
        m_rects.clear();
        std::istringstream all(spec);
        std::string item;
        while (std::getline(all, item, ';')) {
            if (item.find_first_not_of(" ") == std::string::npos) continue;
            for (char& c : item) {
                if (c == ',') c = ' ';
            }
            std::istringstream one(item);
            Rect r{};
            NS_ABORT_MSG_UNLESS(
                (one >> r.xmin >> r.ymin >> r.xmax >> r.ymax) && r.xmin < r.xmax && r.ymin < r.ymax,
                "--buildings: '" << item
                                 << "' is not 'xmin,ymin,xmax,ymax' with "
                                    "xmin < xmax and ymin < ymax (#580)");
            m_rects.push_back(r);
        }
    }
    std::string GetBuildings() const { return m_spec; }

private:
    struct Rect {
        double xmin, ymin, xmax, ymax;
    };

    // One building's loss on the segment a -> a + (dx, dy): a Liang-Barsky
    // clip, then the walls cut and the metres inside.
    double RectLossDb(const Vector& a, double dx, double dy, double len, const Rect& r) const {
        double t0 = 0.0, t1 = 1.0;
        const double pq[4][2] = {
            {-dx, a.x - r.xmin}, {dx, r.xmax - a.x}, {-dy, a.y - r.ymin}, {dy, r.ymax - a.y}};
        for (const auto& e : pq) {
            if (e[0] == 0.0) {
                if (e[1] < 0.0) return 0.0;
            } else {
                const double t = e[1] / e[0];
                if (e[0] < 0.0)
                    t0 = std::max(t0, t);
                else
                    t1 = std::min(t1, t);
            }
        }
        if (t0 >= t1) return 0.0;
        const int cuts = (t0 > 0.0 ? 1 : 0) + (t1 < 1.0 ? 1 : 0);
        return m_dbPerCut * cuts + m_dbPerMeter * (t1 - t0) * len;
    }

    double DoCalcRxPower(double txPowerDbm, Ptr<MobilityModel> a,
                         Ptr<MobilityModel> b) const override {
        return txPowerDbm - ObstacleLossDb(a->GetPosition(), b->GetPosition());
    }
    int64_t DoAssignStreams(int64_t) override { return 0; }

    double m_areaX = 1000.0, m_areaY = 1000.0;
    uint32_t m_blocksX = 5, m_blocksY = 5;
    double m_street = 20.0, m_dbPerCut = 9.0, m_dbPerMeter = 0.4;
    std::string m_spec;
    std::vector<Rect> m_rects;  // #580: explicit buildings; empty = the grid
};

}  // namespace bench
}  // namespace ns3

#endif  // ROUTING_BENCH_URBAN_OBSTACLE_LOSS_MODEL_H
