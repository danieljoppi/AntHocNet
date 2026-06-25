/*
 * NS-3 implementations of the core ports.
 *
 * IClock -> Simulator::Now()
 * IRng   -> ns3::UniformRandomVariable (so AssignStreams() controls it)
 */
#ifndef ANTHOCNET_ADAPTERS_H
#define ANTHOCNET_ADAPTERS_H

#include "ns3/random-variable-stream.h"

#include "anthocnet/core/ports.h"

namespace ns3 {
namespace anthocnet {

class Ns3Clock : public ::anthocnet::core::IClock
{
public:
    ::anthocnet::core::Time now() const override;
};

class Ns3Rng : public ::anthocnet::core::IRng
{
public:
    Ns3Rng();
    double uniform() override;
    int uniformInt(int n) override;

    /// Expose the underlying stream so the protocol's AssignStreams() can seed
    /// it deterministically.
    Ptr<UniformRandomVariable> Stream() const { return m_rng; }

private:
    Ptr<UniformRandomVariable> m_rng;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_ADAPTERS_H
