// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "oracle-decode-budget.h"

#include <cmath>

namespace ns3 {
namespace oracle {

namespace {

// Same constant ns-3's TwoRayGroundPropagationLossModel::SetFrequency uses.
constexpr double kSpeedOfLight = 299792458.0;

double
Wavelength(const TwoRayBudget& b)
{
    return kSpeedOfLight / b.frequencyHz;
}

// dCross = 4*pi*ht*hr / lambda — below it the model is Friis, above it 1/d^4.
double
CrossoverM(const TwoRayBudget& b)
{
    return 4.0 * M_PI * b.heightM * b.heightM / Wavelength(b);
}

} // namespace

double
TwoRayRxPowerDbm(const TwoRayBudget& b, double distanceM)
{
    const double gains = b.txGainDb + b.rxGainDb;
    if (distanceM <= b.minDistanceM)
    {
        // The model returns txPowerDbm unattenuated below MinDistance.
        return b.txPowerDbm + gains;
    }
    const double lambda = Wavelength(b);
    if (distanceM <= CrossoverM(b))
    {
        // Friis: Pr = Pt + 10*log10(lambda^2 / (16*pi^2*d^2*L)).
        const double num = lambda * lambda;
        const double den = 16.0 * M_PI * M_PI * distanceM * distanceM * b.systemLoss;
        return b.txPowerDbm + gains + 10.0 * std::log10(num / den);
    }
    // Two-ray: Pr = Pt + 10*log10(ht^2*hr^2 / (d^4*L)), ht = hr = heightM.
    const double h2 = b.heightM * b.heightM;
    const double num = h2 * h2;
    const double d2 = distanceM * distanceM;
    const double den = d2 * d2 * b.systemLoss;
    return b.txPowerDbm + gains + 10.0 * std::log10(num / den);
}

double
TwoRayDecodeRadius(const TwoRayBudget& b, double thresholdDbm)
{
    // Budget available for path loss. Below zero not even a zero-distance
    // frame decodes, so there is no disk at all.
    const double budgetDb = b.txPowerDbm + b.txGainDb + b.rxGainDb - thresholdDbm;
    if (budgetDb < 0.0)
    {
        return 0.0;
    }
    // Invert the 1/d^4 regime first: loss(d) = 40*log10(d) - 20*log10(ht*hr)
    // + 10*log10(L) = budget. Valid if the crossing lies beyond dCross.
    const double h2 = b.heightM * b.heightM;
    const double rTwoRay = std::pow(
        10.0,
        (budgetDb + 20.0 * std::log10(h2) - 10.0 * std::log10(b.systemLoss)) / 40.0);
    if (rTwoRay > CrossoverM(b))
    {
        return rTwoRay;
    }
    // Otherwise the crossing is in the Friis regime: loss(d) =
    // 20*log10(4*pi*d/lambda) + 10*log10(L) = budget. The two regimes agree
    // exactly at dCross, so exactly one of the two inversions is in range.
    const double rFriis = (Wavelength(b) / (4.0 * M_PI)) *
                          std::pow(10.0, (budgetDb - 10.0 * std::log10(b.systemLoss)) / 20.0);
    // The model applies zero loss below MinDistance, so the disk never
    // shrinks below it while the budget is non-negative.
    return rFriis > b.minDistanceM ? rFriis : b.minDistanceM;
}

double
GammaUpperRegularized(double a, double x)
{
    // Numerical Recipes gammq: series for x < a+1, continued fraction beyond.
    // Both converge fast for the (a ~ 1, x ~ 1) region the Nakagami m-profile
    // lives in; 200 iterations is far past machine precision there.
    if (x <= 0.0)
    {
        return 1.0;
    }
    const double lgA = std::lgamma(a);
    if (x < a + 1.0)
    {
        // Lower series: P(a,x) = x^a e^-x / Gamma(a) * sum x^n / (a)_{n+1}.
        double ap = a;
        double sum = 1.0 / a;
        double del = sum;
        for (int i = 0; i < 200; ++i)
        {
            ap += 1.0;
            del *= x / ap;
            sum += del;
            if (std::fabs(del) < std::fabs(sum) * 1e-15)
            {
                break;
            }
        }
        const double p = sum * std::exp(-x + a * std::log(x) - lgA);
        return 1.0 - p;
    }
    // Upper continued fraction (modified Lentz).
    const double tiny = 1e-300;
    double bb = x + 1.0 - a;
    double c = 1.0 / tiny;
    double d = 1.0 / bb;
    double h = d;
    for (int i = 1; i <= 200; ++i)
    {
        const double an = -static_cast<double>(i) * (static_cast<double>(i) - a);
        bb += 2.0;
        d = an * d + bb;
        if (std::fabs(d) < tiny)
        {
            d = tiny;
        }
        c = bb + an / c;
        if (std::fabs(c) < tiny)
        {
            c = tiny;
        }
        d = 1.0 / d;
        const double delta = d * c;
        h *= delta;
        if (std::fabs(delta - 1.0) < 1e-15)
        {
            break;
        }
    }
    return std::exp(-x + a * std::log(x) - lgA) * h;
}

double
NakagamiLinkProbability(const TwoRayBudget& b,
                        const NakagamiProfile& n,
                        double thresholdDbm,
                        double distanceM)
{
    // Same m selection as NakagamiPropagationLossModel::DoCalcRxPower.
    const double m = distanceM < n.distance1M ? n.m0
                     : distanceM < n.distance2M ? n.m1
                                                : n.m2;
    // Received power W ~ Gamma(shape m, scale P_W/m), mean P_W = the
    // deterministic two-ray power. P(X >= T_W) = Q(m, T_W / (P_W/m)).
    const double pW = std::pow(10.0, (TwoRayRxPowerDbm(b, distanceM) - 30.0) / 10.0);
    const double tW = std::pow(10.0, (thresholdDbm - 30.0) / 10.0);
    if (pW <= 0.0)
    {
        return 0.0;
    }
    return GammaUpperRegularized(m, m * tW / pW);
}

double
NakagamiMedianRadius(const TwoRayBudget& b,
                     const NakagamiProfile& n,
                     double thresholdDbm)
{
    // The probability is monotone-decreasing in d inside each m band; the
    // band steps at Distance1/Distance2 sit where P ~ 1 for any budget that
    // reaches past them, so the 1/2 crossing is unique in practice. Bracket
    // it by doubling, then bisect: 100 iterations on a <= 1e7 m bracket is
    // sub-millimetre, and every step is pure arithmetic — no RNG draw (#352).
    double lo = 0.0;
    if (NakagamiLinkProbability(b, n, thresholdDbm, lo) < 0.5)
    {
        return 0.0;
    }
    double hi = b.minDistanceM > 1.0 ? 2.0 * b.minDistanceM : 2.0;
    while (NakagamiLinkProbability(b, n, thresholdDbm, hi) >= 0.5 && hi < 1e7)
    {
        lo = hi;
        hi *= 2.0;
    }
    for (int i = 0; i < 100; ++i)
    {
        const double mid = 0.5 * (lo + hi);
        if (NakagamiLinkProbability(b, n, thresholdDbm, mid) >= 0.5)
        {
            lo = mid;
        }
        else
        {
            hi = mid;
        }
    }
    return lo;
}

} // namespace oracle
} // namespace ns3
