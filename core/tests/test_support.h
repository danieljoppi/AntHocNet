/**
 * Tiny dependency-free test scaffolding for the core unit tests, plus
 * deterministic fakes for the IClock / IRng / INeighborProvider ports.
 */
#ifndef ANTHOCNET_CORE_TEST_SUPPORT_H
#define ANTHOCNET_CORE_TEST_SUPPORT_H

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <vector>

#include "anthocnet/core/ports.h"

namespace anthocnet {
namespace test {

inline int& failureCount() {
    static int count = 0;
    return count;
}

#define CHECK(cond)                                                            \
    do {                                                                       \
        if (!(cond)) {                                                         \
            std::fprintf(stderr, "CHECK failed: %s (%s:%d)\n", #cond,          \
                         __FILE__, __LINE__);                                  \
            ++::anthocnet::test::failureCount();                               \
        }                                                                      \
    } while (0)

#define CHECK_EQ(a, b)                                                         \
    do {                                                                       \
        auto _va = (a);                                                        \
        auto _vb = (b);                                                        \
        if (!(_va == _vb)) {                                                   \
            std::fprintf(stderr, "CHECK_EQ failed: %s == %s (%s:%d)\n", #a,    \
                         #b, __FILE__, __LINE__);                              \
            ++::anthocnet::test::failureCount();                               \
        }                                                                      \
    } while (0)

#define CHECK_NEAR(a, b, eps)                                                  \
    do {                                                                       \
        if (std::fabs((a) - (b)) > (eps)) {                                    \
            std::fprintf(stderr, "CHECK_NEAR failed: |%s - %s| > %s (%s:%d)\n",\
                         #a, #b, #eps, __FILE__, __LINE__);                    \
            ++::anthocnet::test::failureCount();                               \
        }                                                                      \
    } while (0)

#define RUN_TESTS()                                                           \
    (::anthocnet::test::failureCount() == 0                                    \
         ? (std::printf("OK\n"), 0)                                            \
         : (std::fprintf(stderr, "%d failure(s)\n",                           \
                         ::anthocnet::test::failureCount()),                   \
            1))

/// Fixed clock the test can advance manually.
class FakeClock : public core::IClock {
public:
    core::Time now() const override { return now_; }
    void set(core::Time t) { now_ = t; }
    void advance(core::Time dt) { now_ += dt; }
private:
    core::Time now_ = 0.0;
};

/// RNG that replays a scripted sequence of uniforms (looping), so stochastic
/// selection is deterministic in tests.
class ScriptedRng : public core::IRng {
public:
    explicit ScriptedRng(std::deque<double> values) : values_(std::move(values)) {}
    double uniform() override {
        if (values_.empty()) return 0.0;
        double v = values_.front();
        values_.pop_front();
        values_.push_back(v);
        return v;
    }
    int uniformInt(int n) override {
        return n <= 0 ? 0 : static_cast<int>(uniform() * n) % n;
    }
private:
    std::deque<double> values_;
};

} // namespace test
} // namespace anthocnet

#endif // ANTHOCNET_CORE_TEST_SUPPORT_H
