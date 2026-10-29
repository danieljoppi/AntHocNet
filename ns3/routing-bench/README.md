# routing-bench — the protocol-agnostic comparison harness module

`routing-bench` is the ns-3 module that will hold the comparison harness, so
the harness builds without AntHocNet
([ADR-0027](../../docs/adr/0027-the-comparison-harness-is-protocol-agnostic.md),
epic [#764](https://github.com/danieljoppi/AntHocNet/issues/764)). It links
only stock ns-3 and names no protocol of its own. Arm modules depend on it;
it depends on none of them.

## What is here (v2.6.0, step 1: #766)

| file | what |
|---|---|
| `model/routing-bench-arm.h/.cc` | the `Arm` contract, `RunContext`, `RunCounts` and the `ArmRegistry` |
| `model/source-refusal-counter.h/.cc` | the #510 fallback that counts the sends OLSR refuses at the source |
| `helper/stock-arms.h/.cc` | `RegisterStockArms()`: `aodv`, `olsr`, `dsdv` and `hwmp` |
| `test/routing-bench-test-suite.cc` | registry rules and the stock arms (`./test.py -s routing-bench`) |

`anthocnet-compare` calls `RegisterStockArms()` at start-up and runs the four
stock arms through the registry. Every other arm still goes through its own
branch in the harness until the extraction (#767) and the arm modules
(#768). hwmp's 802.11s devices are still installed by the harness; they move
into the arm with #767.

## Registering an arm

Registration is an explicit call, never a static initialiser (ADR-0027 §3):

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

void RegisterMyArms() { ns3::bench::RegisterArm("myproto", "My protocol (Author 2026)", &MakeMyArm); }
```

A duplicate or empty name aborts. Until #768 generates the calls from the
installed modules, the harness's `main` calls each registration function.

## Compatibility

No published number may move: the byte-identical control on the committed
cells is #769. The user guide is
[comparison-harness.md](../../docs/comparison-harness.md).
