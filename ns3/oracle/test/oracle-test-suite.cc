// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Unit tests for the oracle's #431 fading-channel adjacency derivations
 * (oracle-decode-budget.{h,cc}). Every expected value below is hand-computed
 * from the stated closed form — never from running the code under test — so
 * a regression in the math cannot re-derive its own expectation.
 *
 * The recurring parameter set is the compare harness's effective PHY/channel
 * ("paper shape"): TxPowerEnd = 16.0206 dBm, TxGain = RxGain = 0,
 * two-ray Frequency = 2.4 GHz (lambda = c/f = 0.1249135 m),
 * HeightAboveZ = 1.5 m over z = 0 nodes (ht = hr = 1.5), SystemLoss = 1,
 * MinDistance = 0.5 m; decode threshold T = max(RxSensitivity -101,
 * preamble MinimumRssi -82) = -82 dBm. Crossover distance
 * dCross = 4*pi*ht*hr/lambda = 226.351 m.
 */

#include "ns3/oracle-decode-budget.h"
#include "ns3/test.h"

#include <cmath>

// TestSuite/TestCase enums became scoped (enum class) in ns-3.42 and the
// unscoped aliases were removed in ns-3.47. ORACLE_NS3_SCOPED_TEST_ENUMS is
// defined by the module's CMakeLists for ns-3 >= 3.42 (same pattern as the
// anthocnet and aomdv modules).
#ifdef ORACLE_NS3_SCOPED_TEST_ENUMS
#define ORACLE_TEST_TYPE_UNIT TestSuite::Type::UNIT
#define ORACLE_TEST_QUICK TestCase::Duration::QUICK
#else
#define ORACLE_TEST_TYPE_UNIT UNIT
#define ORACLE_TEST_QUICK TestCase::QUICK
#endif

namespace ns3
{
namespace oracle
{

namespace
{
/// The paper-shape budget every #431 number was derived at.
TwoRayBudget
PaperBudget()
{
    TwoRayBudget b;
    b.txPowerDbm = 16.0206;
    b.txGainDb = 0.0;
    b.rxGainDb = 0.0;
    b.frequencyHz = 2.4e9;
    b.heightM = 1.5;
    b.systemLoss = 1.0;
    b.minDistanceM = 0.5;
    return b;
}
} // namespace

/**
 * TwoRayDecodeRadius, both regimes.
 *
 * Two-ray regime (T = -82 dBm): budget B = 16.0206 - (-82) = 98.0206 dB;
 *   r = 10^((B + 20*log10(ht*hr))/40) = 10^((98.0206 + 7.0437)/40)
 *     = 10^2.626607 = 423.2591 m > dCross (226.351 m), so the 1/d^4
 *   inversion is the valid one. This is the #431 measurement study's
 *   tworay decode radius (its empirical probe put the delivery step
 *   between 400 and 450 m).
 *
 * Friis regime (T = -60 dBm): B = 76.0206 dB; the two-ray inversion gives
 *   10^((76.0206 + 7.0437)/40) = 119.29 m < dCross, so the crossing is
 *   below the crossover and Friis applies:
 *   r = (lambda/(4*pi)) * 10^(B/20) = 0.00993957 * 10^3.80103 = 62.8680 m.
 *
 * Degenerate: threshold above tx power + gains -> no distance decodes -> 0.
 */
class TwoRayDecodeRadiusTest : public TestCase
{
  public:
    TwoRayDecodeRadiusTest()
        : TestCase("two-ray decode radius: 1/d^4 and Friis regimes, hand-computed")
    {
    }

    void DoRun() override
    {
        TwoRayBudget b = PaperBudget();
        NS_TEST_ASSERT_MSG_EQ_TOL(TwoRayDecodeRadius(b, -82.0),
                                  423.2591,
                                  0.001,
                                  "two-ray-regime radius at the -82 dBm decode floor");
        NS_TEST_ASSERT_MSG_EQ_TOL(TwoRayDecodeRadius(b, -60.0),
                                  62.8680,
                                  0.001,
                                  "Friis-regime radius at a -60 dBm threshold");
        NS_TEST_ASSERT_MSG_EQ(TwoRayDecodeRadius(b, 20.0),
                              0.0,
                              "threshold above tx power: no disk at all");
        // The defining property, at the boundary: received power at the
        // derived radius equals the threshold.
        const double r = TwoRayDecodeRadius(b, -82.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(TwoRayRxPowerDbm(b, r),
                                  -82.0,
                                  1e-9,
                                  "power at the derived radius is the threshold");
    }
};

/**
 * TwoRayRxPowerDbm mirrors ns-3's TwoRayGroundPropagationLossModel exactly.
 *
 * At 300 m (beyond dCross): Pr = 16.0206 + 10*log10(2.25^2 / 300^4)
 *   = 16.0206 + 7.0437 - 40*log10(300) = -76.0206 dBm.
 * At 150 m (below dCross, Friis): Pr = 16.0206
 *   + 10*log10(lambda^2 / (16*pi^2*150^2)) = -67.5532 dBm.
 * At 0.4 m (below MinDistance 0.5): unattenuated, 16.0206 dBm.
 */
class TwoRayRxPowerTest : public TestCase
{
  public:
    TwoRayRxPowerTest()
        : TestCase("two-ray received power: both regimes + MinDistance, hand-computed")
    {
    }

    void DoRun() override
    {
        TwoRayBudget b = PaperBudget();
        NS_TEST_ASSERT_MSG_EQ_TOL(TwoRayRxPowerDbm(b, 300.0), -76.0206, 0.0005, "1/d^4 regime");
        NS_TEST_ASSERT_MSG_EQ_TOL(TwoRayRxPowerDbm(b, 150.0), -67.5532, 0.0005, "Friis regime");
        NS_TEST_ASSERT_MSG_EQ_TOL(TwoRayRxPowerDbm(b, 0.4), 16.0206, 1e-9, "below MinDistance");
    }
};

/**
 * GammaUpperRegularized against textbook closed forms:
 *   Q(1, x)   = e^-x          -> Q(1, 1) = 0.36787944
 *   Q(2, 1)   = e^-1 * (1+1)  = 0.73575888
 *   Q(0.5, x) = erfc(sqrt(x)) -> Q(0.5, 1) = erfc(1) = 0.15729921
 *   Q(a, 0)   = 1
 */
class GammaQTest : public TestCase
{
  public:
    GammaQTest()
        : TestCase("regularized upper incomplete gamma against closed forms")
    {
    }

    void DoRun() override
    {
        NS_TEST_ASSERT_MSG_EQ_TOL(GammaUpperRegularized(1.0, 1.0),
                                  0.3678794412,
                                  1e-9,
                                  "Q(1,1) = e^-1");
        NS_TEST_ASSERT_MSG_EQ_TOL(GammaUpperRegularized(2.0, 1.0),
                                  0.7357588823,
                                  1e-9,
                                  "Q(2,1) = 2/e");
        NS_TEST_ASSERT_MSG_EQ_TOL(GammaUpperRegularized(0.5, 1.0),
                                  0.1572992071,
                                  1e-9,
                                  "Q(0.5,1) = erfc(1)");
        NS_TEST_ASSERT_MSG_EQ(GammaUpperRegularized(0.75, 0.0), 1.0, "Q(a,0) = 1");
    }
};

/**
 * NakagamiLinkProbability and the median radius.
 *
 * Rayleigh cross-check (m = 1 everywhere, where Gamma(1, P) is exponential
 * and P(X >= T) = e^(-T_W/P_W) in elementary closed form): at d = 300 m the
 * two-ray power is -76.0206 dBm, so T_W/P_W = 10^((-82+76.0206)/10)
 * = 0.2523829 and the probability is e^-0.2523829 = 0.7769472.
 *
 * ns-3 default m-profile (m0/m1/m2 = 1.5/0.75/0.75, Distance1/2 = 80/200 m),
 * T = -82 dBm — the #431 study's numbers:
 *   P(link | 300 m) = Q(0.75, 0.75*0.2523829) = 0.711627 (the study's
 *   closed-form validation point; its empirical probe measured 73.5 % in the
 *   275-300 m bin, within ~2 pp).
 *   Median radius = 373.3747 m (the study's P50 disk, quoted as 373.4 m),
 *   which lies in the m2 band; by construction the probability there is 1/2.
 */
class NakagamiMedianTest : public TestCase
{
  public:
    NakagamiMedianTest()
        : TestCase("Nakagami closed-form link probability + median radius, hand-computed")
    {
    }

    void DoRun() override
    {
        TwoRayBudget b = PaperBudget();
        NakagamiProfile rayleigh;
        rayleigh.m0 = rayleigh.m1 = rayleigh.m2 = 1.0;
        NS_TEST_ASSERT_MSG_EQ_TOL(NakagamiLinkProbability(b, rayleigh, -82.0, 300.0),
                                  0.7769472,
                                  1e-6,
                                  "m=1 reduces to the exponential closed form");

        NakagamiProfile def; // ns-3 defaults: 1.5 / 0.75 / 0.75 at 80 / 200 m
        NS_TEST_ASSERT_MSG_EQ_TOL(NakagamiLinkProbability(b, def, -82.0, 300.0),
                                  0.711627,
                                  1e-6,
                                  "default-profile probability at 300 m");
        const double p50 = NakagamiMedianRadius(b, def, -82.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(p50, 373.3747, 0.001, "the #431 P50 disk radius");
        NS_TEST_ASSERT_MSG_EQ_TOL(NakagamiLinkProbability(b, def, -82.0, p50),
                                  0.5,
                                  1e-9,
                                  "probability at the median radius is 1/2");
        NS_TEST_ASSERT_MSG_EQ(NakagamiMedianRadius(b, def, 20.0),
                              0.0,
                              "threshold above tx power: no median disk");
    }
};

class OracleTestSuite : public TestSuite
{
  public:
    OracleTestSuite()
        : TestSuite("oracle", ORACLE_TEST_TYPE_UNIT)
    {
        AddTestCase(new TwoRayDecodeRadiusTest, ORACLE_TEST_QUICK);
        AddTestCase(new TwoRayRxPowerTest, ORACLE_TEST_QUICK);
        AddTestCase(new GammaQTest, ORACLE_TEST_QUICK);
        AddTestCase(new NakagamiMedianTest, ORACLE_TEST_QUICK);
    }
};

static OracleTestSuite g_oracleTestSuite;

} // namespace oracle
} // namespace ns3
