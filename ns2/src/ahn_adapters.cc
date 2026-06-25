#include "anthocnet/ahn_adapters.h"

#include <scheduler.h>
#include <random.h>

namespace anthocnet {
namespace ns2 {

core::Time Ns2Clock::now() const {
    return (core::Time) Scheduler::instance().clock();
}

double Ns2Rng::uniform() {
    return Random::uniform();  // [0, 1)
}

int Ns2Rng::uniformInt(int n) {
    if (n <= 0) return 0;
    return Random::integer(n);
}

} // namespace ns2
} // namespace anthocnet
