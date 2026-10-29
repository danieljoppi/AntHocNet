// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * GPSR and its two family modes as arms of the comparison harness (ADR-0027,
 * #768), compiled in only when routing-bench is installed beside this module.
 * gpcr (#709, the VANET family's junction-aware arm) and gpsr3d (#710, the
 * FANET family's 3-D arm) are separate registrations of the one helper with
 * an attribute set: same beacons, same headers.
 */

#include "ns3/abort.h"
#include "ns3/boolean.h"
#include "ns3/gpsr-helper.h"
#include "ns3/routing-bench-arm.h"

namespace ns3 {
namespace {

class GpsrArm : public bench::Arm {
public:
    enum class Mode { Planar, Gpcr, ThreeD };
    explicit GpsrArm(Mode mode) : m_mode(mode) {}
    std::string Name() const override {
        return m_mode == Mode::Gpcr ? "gpcr" : m_mode == Mode::ThreeD ? "gpsr3d" : "gpsr";
    }
    // #480: the vendored GPSR carries only x/y in its hello and position
    // headers, and its perimeter mode planarizes a 2-D graph. Under
    // --areaZ > 0 it would route on projected positions -- a silent
    // degradation that would read as a protocol result. Refused; the 3-D
    // geographic arm is gpsr3d (#710), the same module's ThreeD mode.
    void Validate(const bench::RunContext& scenario) const override {
        NS_ABORT_MSG_UNLESS(m_mode == Mode::ThreeD || scenario.areaZ <= 0.0,
                            "--protocols includes " << Name() << " with --areaZ=" << scenario.areaZ
                                                    << ": the vendored GPSR is planar "
                                                       "(2-D headers, 2-D planarization) and would "
                                                       "route on projected positions. Use gpsr3d "
                                                       "for a 3-D field (#480, #710).");
    }
    void InstallRouting(InternetStackHelper& internet, bench::RunContext&) override {
        if (m_mode == Mode::Gpcr) m_helper.Set("Gpcr", BooleanValue(true));
        if (m_mode == Mode::ThreeD) m_helper.Set("ThreeD", BooleanValue(true));
        internet.SetRoutingHelper(m_helper);
    }
    // #296: GPSR's data packets carry a position header, injected by
    // re-pointing the UDP down target -- the helper wires that after the
    // stack exists, scoped to this run's nodes (not the global container,
    // so repeated runs can't cross-wire).
    void AfterStack(bench::RunContext& run) override { m_helper.Install(run.nodes); }
    int64_t AssignStreams(bench::RunContext& run, int64_t stream) override {
        return m_helper.AssignStreams(run.nodes, stream);
    }

private:
    Mode m_mode;
    GpsrHelper m_helper;
};

Ptr<bench::Arm> MakeGpsrArm() { return Create<GpsrArm>(GpsrArm::Mode::Planar); }
Ptr<bench::Arm> MakeGpcrArm() { return Create<GpsrArm>(GpsrArm::Mode::Gpcr); }
Ptr<bench::Arm> MakeGpsr3dArm() { return Create<GpsrArm>(GpsrArm::Mode::ThreeD); }

}  // namespace

namespace bench {
void RegisterArms_gpsr() {
    RegisterArm("gpsr", "GPSR (Karp & Kung 2000), vendored (#296)", &MakeGpsrArm);
    RegisterArm("gpcr", "GPCR, GPSR's junction-aware VANET mode (#709)", &MakeGpcrArm);
    RegisterArm("gpsr3d", "GPSR's 3-D FANET mode (#710)", &MakeGpsr3dArm);
}
}  // namespace bench
}  // namespace ns3
