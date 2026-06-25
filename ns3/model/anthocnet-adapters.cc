#include "anthocnet-adapters.h"

#include "ns3/simulator.h"
#include "ns3/nstime.h"

namespace ns3 {
namespace anthocnet {

::anthocnet::core::Time Ns3Clock::now() const {
    return Simulator::Now().GetSeconds();
}

Ns3Rng::Ns3Rng() : m_rng(CreateObject<UniformRandomVariable>()) {}

double Ns3Rng::uniform() {
    return m_rng->GetValue(0.0, 1.0);
}

int Ns3Rng::uniformInt(int n) {
    if (n <= 0) return 0;
    return static_cast<int>(m_rng->GetInteger(0, n - 1));
}

} // namespace anthocnet
} // namespace ns3
