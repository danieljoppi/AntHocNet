# routing-bench — the protocol-agnostic comparison harness module

`routing-bench` is the ns-3 module that will hold the comparison harness, so
the harness builds without AntHocNet
([ADR-0027](../../docs/adr/0027-the-comparison-harness-is-protocol-agnostic.md),
epic [#764](https://github.com/danieljoppi/AntHocNet/issues/764)). It links
only stock ns-3 and names no protocol of its own. Arm modules depend on it;
it depends on none of them.

## What is here (v2.6.0)

| file | what |
|---|---|
| `model/routing-bench-arm.h/.cc` | the `Arm` contract, `RunContext`, `RunCounts`, `Measurement` (what an arm may touch of the run's measurement) and the `ArmRegistry` (#766) |
| `model/routing-bench-run.cc` | one (seed, arm) run: the world (scenario presets, mobility, channels, devices, traffic), stream pinning, the measurement (FlowMonitor and the trace sinks, the drop book, route stability, the identity-matched set, energy) and `RunOne` (#767) |
| `model/routing-bench-harness.cc` | the command line, the runs over seeds and arms, and the summary and marker output: `bench::RunHarness()` |
| `model/routing-bench-internal.h` | what those two share (`Params`, `Result`, `RunOne`, the defaults); not part of the API |
| `model/urban-obstacle-loss-model.h/.cc` | the urban building-shadowing channel (#488, #580), Sommer et al.'s obstacle model |
| `model/source-refusal-counter.h/.cc` | the #510 fallback that counts the sends OLSR refuses at the source |
| `helper/stock-arms.h/.cc` | `RegisterStockArms()`: `aodv`, `olsr`, `dsdv` and `hwmp` (with its 802.11s devices) |
| `examples/routing-compare.cc` | the program |
| `examples/anthocnet-compare.cc` | the same program under its original name (ADR-0027 §4), kept at least through v3.x |
| `examples/CMakeLists.txt` | finds the arm modules installed beside it and generates `arms-generated.cc` (#768) |
| `test/routing-bench-test-suite.cc` | registry rules and the stock arms (`./test.py -s routing-bench`) |

The other arms live in their own modules, each in one
`helper/<module>-bench-arms.cc`: `anthocnet`, `aomdv`, `gpsr` (`gpsr`, `gpcr`,
`gpsr3d`), `oracle` and `adaptive` (`ara`, `termite`, `qrouting`, `beeadhoc`).

## Registering an arm

Registration is an explicit call, never a static initialiser (ADR-0027 §3).
A module adds its arms in one function, in a file named
`helper/<module>-bench-arms.cc`:

```cpp
#include "ns3/routing-bench-arm.h"

class MyArm : public ns3::bench::Arm {
  public:
    std::string Name() const override { return "myproto"; }
    void InstallRouting(ns3::InternetStackHelper& internet, ns3::bench::RunContext&) override {
        internet.SetRoutingHelper(m_helper);
    }
    int64_t AssignStreams(ns3::bench::RunContext& run, int64_t stream) override {
        return m_helper.AssignStreams(run.nodes, stream);
    }
  private:
    MyHelper m_helper;
};

ns3::Ptr<ns3::bench::Arm> MakeMyArm() { return ns3::Create<MyArm>(); }

namespace ns3 { namespace bench {
void RegisterArms_mymodule() { RegisterArm("myproto", "My protocol (Author 2026)", &MakeMyArm); }
}}
```

Compile the file only when `routing-bench` is installed and enabled, and name
its library through a variable: ns-3 scans module CMakeLists for library
tokens to resolve dependencies, and your module should still build alone. The
pattern, from `ns3/baselines/adaptive/CMakeLists.txt`:

```cmake
set(mymodule_bench_sources)
set(mymodule_bench_libs)
set(mymodule_bench_module routing-bench)
if(EXISTS ${PROJECT_SOURCE_DIR}/contrib/${mymodule_bench_module}/CMakeLists.txt
   AND mymodule_bench_module IN_LIST ns3-all-enabled-modules)
  set(mymodule_bench_sources helper/mymodule-bench-arms.cc)
  set(mymodule_bench_lib lib${mymodule_bench_module})
  set(mymodule_bench_libs ${${mymodule_bench_lib}})
endif()
# then ${mymodule_bench_sources} in SOURCE_FILES, ${mymodule_bench_libs} in LIBRARIES_TO_LINK
```

`routing-compare`'s CMake globs `contrib/*/helper/*-bench-arms.cc`, keeps the
enabled modules, and calls each `RegisterArms_<module>()` at start-up. A
duplicate or empty name aborts.

The optional hooks, in the order the harness calls them, are documented in
[`routing-bench-arm.h`](model/routing-bench-arm.h) and ADR-0027 §2.

## Compatibility

No published number may move: the byte-identical control on the committed
cells is #769. The user guide is
[comparison-harness.md](../../docs/comparison-harness.md).
