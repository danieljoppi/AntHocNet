// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Pure closed-form derivations behind the oracle's fading-channel adjacency
 * (#431). No ns-3 headers on purpose: every function here is a deterministic
 * function of numbers read off the installed ns-3 objects by
 * oracle-topology.cc, which keeps the math independently unit-testable
 * (test/oracle-test-suite.cc) against hand-computed values.
 *
 * Two derivations, both anchored on the same decode threshold:
 *
 * 1. TwoRayDecodeRadius — the distance at which the deterministic two-ray
 *    received power crosses the PHY's decode floor. Mirrors
 *    ns3::TwoRayGroundPropagationLossModel::DoCalcRxPower exactly, both
 *    regimes: Friis below the crossover distance dCross = 4*pi*ht*hr/lambda,
 *    1/d^4 two-ray beyond it (the two agree at dCross, so the loss curve is
 *    continuous and the inversion is unambiguous).
 *
 * 2. NakagamiMedianRadius — under NakagamiPropagationLossModel the received
 *    power in W is Gamma-distributed with shape m(d) and mean P_W(d) (the
 *    deterministic two-ray power), so the per-frame decode probability has
 *    the closed form P(link | d) = Q(m, m*T_W/P_W(d)) with Q the regularized
 *    upper incomplete gamma function. The median-disk radius is the d where
 *    that probability crosses 1/2 — computed by bisection on the closed
 *    form, with ZERO draws from any RNG (the #352 property: the oracle must
 *    never perturb the channel's pinned fading realisation). Validated on
 *    #431: the closed form matches the empirically probed delivery curve
 *    within ~2 pp everywhere.
 *
 * The threshold both derivations use is NOT a free calibration constant: it
 * is max(RxSensitivity, ThresholdPreambleDetectionModel::MinimumRssi), read
 * off the installed PHY. The withdrawn link-budget rule (ns3/oracle/README.md)
 * died of using RxSensitivity (-101 dBm) alone — 19 dB below the -82 dBm
 * preamble-detection floor that actually gates decoding, giving a
 * 1264 m near-complete graph. Same idea, wrong attribute.
 */
#ifndef ORACLE_DECODE_BUDGET_H
#define ORACLE_DECODE_BUDGET_H

namespace ns3 {
namespace oracle {

/// The deterministic two-ray channel + PHY budget, every field read off the
/// installed ns-3 objects (TwoRayGroundPropagationLossModel + WifiPhy).
struct TwoRayBudget
{
    double txPowerDbm = 0.0;    //!< WifiPhy TxPowerEnd
    double txGainDb = 0.0;      //!< WifiPhy TxGain
    double rxGainDb = 0.0;      //!< WifiPhy RxGain
    double frequencyHz = 0.0;   //!< TwoRayGround Frequency
    double heightM = 0.0;       //!< TwoRayGround HeightAboveZ (+ node z, see .cc)
    double systemLoss = 1.0;    //!< TwoRayGround SystemLoss (linear, >= 1)
    double minDistanceM = 0.5;  //!< TwoRayGround MinDistance (zero loss below it)
};

/// The Nakagami m-profile, read off the installed NakagamiPropagationLossModel.
struct NakagamiProfile
{
    double distance1M = 80.0;  //!< Distance1: end of the m0 band
    double distance2M = 200.0; //!< Distance2: end of the m1 band
    double m0 = 1.5;
    double m1 = 0.75;
    double m2 = 0.75;
};

/// Received power in dBm at distance d, exactly as ns-3's two-ray model
/// computes it (zero loss below MinDistance; Friis below the crossover;
/// ht^2*hr^2/d^4 beyond), plus the PHY's tx/rx gains.
double TwoRayRxPowerDbm(const TwoRayBudget& b, double distanceM);

/// The largest distance at which TwoRayRxPowerDbm >= thresholdDbm.
/// 0 when even a zero-distance frame is below the threshold.
double TwoRayDecodeRadius(const TwoRayBudget& b, double thresholdDbm);

/// Regularized upper incomplete gamma function Q(a, x) = Gamma(a,x)/Gamma(a),
/// a > 0, x >= 0. Series + continued-fraction evaluation (no libc RNG, no
/// special-function dependency).
double GammaUpperRegularized(double a, double x);

/// P(received power >= threshold | distance) under two-ray + Nakagami-m:
/// the closed form Q(m(d), m(d)*T_W/P_W(d)). Deterministic — no RNG draw.
double NakagamiLinkProbability(const TwoRayBudget& b,
                               const NakagamiProfile& n,
                               double thresholdDbm,
                               double distanceM);

/// The distance at which NakagamiLinkProbability crosses 1/2 (the median
/// disk), by bisection. 0 when no distance clears 1/2.
double NakagamiMedianRadius(const TwoRayBudget& b,
                            const NakagamiProfile& n,
                            double thresholdDbm);

} // namespace oracle
} // namespace ns3

#endif // ORACLE_DECODE_BUDGET_H
