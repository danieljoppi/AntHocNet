# ADR-0027: The comparison harness is a protocol-agnostic module

- **Status:** Accepted (maintainer request 2026-10-29, epic [#764](https://github.com/danieljoppi/AntHocNet/issues/764); decides [#765](https://github.com/danieljoppi/AntHocNet/issues/765)). Implemented in v2.6.0 (#766, #767, #768); amended 2026-10-29 with the hooks the extraction needed (below)
- **Date:** 2026-10-29
- **Builds on:** [ADR-0023](0023-one-core-one-simulator-adapter.md) (one simulator), [ADR-0026](0026-baselines-are-family-native.md) (family-native baselines)

## Context

`anthocnet-compare` produces every MANET-family number in the corpus. It runs
several routing protocols ("arms") on identical seeds and emits per-seed
marker lines that pair across arms ([comparison-harness.md](../comparison-harness.md)).
Outside developers want to use it for their own protocols: an undergraduate
asked on [#589](https://github.com/danieljoppi/AntHocNet/issues/589). The
maintainer asked for it to be agnostic and packaged on its own.

Three facts stand in the way.

**1. It lives inside AntHocNet.** It is one 5,083-line example in
`ns3/anthocnet/examples/` and links `libanthocnet` and every comparison
module. It cannot build without AntHocNet.

**2. It names every arm.** Counted on `main` at v2.5.0, the harness branches
on the protocol name in about 25 places:

| kind of special case | where (`anthocnet-compare.cc`, v2.5.0) | arms |
|---|---|---|
| devices instead of ad-hoc Wi-Fi | mesh devices, mesh stream offset, ARP prefill (≈ lines 1788, 1941, 1965, 2489) | hwmp |
| routing install | the `proto == …` chain (≈ 2265) | all |
| post-stack install | GPSR's UDP re-wiring (2329); the energy probe (2318) | gpsr/gpcr/gpsr3d; anthocnet |
| stream pinning | the second `proto == …` chain (≈ 2344) | all |
| trace connections | MAC re-injection and its skip trace (2414); ant Tx/Rx tallies (2727); the pending-queue tracker (2437); mesh management frames (2465) | anthocnet; dsdv/aodv; hwmp |
| offered-load corrections | packets refused at the source (2866, 2880) | oracle, olsr |
| extra output | `##REINJ##`, `##HOLD##` and the ant tallies (3143, 3375, 3551); `# hwmp` (2894); `pqSilent`/`pqEcb` appended to `##DROPID##` (3344); `##ORACLE##` (3675) | anthocnet; hwmp; dsdv/aodv; oracle |
| self-checks | the oracle must put nothing on the wire (3675) | oracle |
| replay trace | `--vizTrace` (2748) | anthocnet |

**3. Adding an arm is a scavenger hunt.** It means editing three places in
the `.cc`, the help literal, the CMake link list, the module lists and
`check-determinism.sh`'s alternation.
`tools/checks/check-allowlists.sh` ([#435](https://github.com/danieljoppi/AntHocNet/issues/435))
exists only to catch the edits people forget.

The arms themselves are already separable. The v2.5.0 `adaptive` module links
only stock ns-3.

## Decision

**The harness becomes its own ns-3 module, `routing-bench`, which links only
stock ns-3 and names no arm. Each arm reaches it through one registration
function in the arm's own module. Arm modules depend on `routing-bench`;
`routing-bench` depends on none of them.**

### 1. The module boundary

`ns3/routing-bench/` (`LIBNAME routing-bench`) holds everything that is the
same for every arm:

- the scenario presets;
- mobility, channels and buildings;
- traffic (CBR, TCP, `--flowsFile`);
- stream pinning;
- FlowMonitor and the harness's trace sinks;
- the drop book, route stability and the identity-matched set;
- energy accounting;
- the marker output.

Its program is `routing-compare`. The stock ns-3 arms (`aodv`, `olsr`,
`dsdv`, `hwmp`) register from inside `routing-bench`, so it is useful alone.

The `anthocnet` module keeps no harness code. `isl-grid` and `leo-walker` stay
where they are for now ([#773](https://github.com/danieljoppi/AntHocNet/issues/773)).

### 2. The arm contract

An arm is a class, instantiated fresh for every (seed, arm) run, as every
helper already is. The oracle owns per-run ground truth, so state must not
leak between runs. Every hook except the first three is optional, and the
default does nothing:

```cpp
namespace ns3 { namespace bench {

class Arm : public SimpleRefCount<Arm> {
  public:
    virtual ~Arm() = default;
    virtual std::string Name() const = 0;      // "--protocols" token
    virtual void InstallRouting(InternetStackHelper& internet, RunContext& run) = 0;
    virtual int64_t AssignStreams(RunContext& run, int64_t stream) = 0;  // count taken

    virtual bool ProvidesDevices() const { return false; }                 // hwmp
    virtual NetDeviceContainer InstallDevices(RunContext& run);           // if ProvidesDevices
    virtual void AfterStack(RunContext& run) {}            // gpsr re-wiring, energy probe, ARP prefill
    virtual void ConnectTraces(RunContext& run, Measurement& m) {}   // re-injection, ant tallies, pq, mesh frames
    virtual void AdjustCounts(RunContext& run, RunCounts& c) {}      // source refusals (oracle, olsr)
    virtual void AppendDropId(RunContext& run, std::ostream& line) {} // extra ##DROPID## fields (pq)
    virtual void EmitDiagnostics(RunContext& run, std::ostream& out) {} // ##REINJ##, ##HOLD##, ##ORACLE##, # hwmp
    virtual void Check(RunContext& run, const RunCounts& c) {}       // abort on a broken invariant
    virtual bool SupportsReplay() const { return false; }             // --vizTrace
};

using ArmFactory = Ptr<Arm> (*)();
void RegisterArm(const std::string& name, const std::string& summary, ArmFactory make);

}}  // namespace ns3::bench
```

`RunContext` carries the run's scenario parameters, nodes, devices, channel,
seed and stream base, plus the `--diag`/`--qdiag` switches. `Measurement` is
the harness's sinks, which an arm may feed: data re-injections, control
packets and bytes, held packets. `RunCounts` is the run's offered, delivered
and dropped tallies before the marker lines are printed.

Every special case in the table above maps onto exactly one hook. #766 and
#767 implement the classes. They may rename or add a field, but not change a
hook's call point.

**Hook order is fixed** and equals today's order of stream draws:

1. channel streams;
2. `InstallDevices` or the stock ad-hoc Wi-Fi;
3. the internet stack's own streams;
4. `InstallRouting`;
5. `AfterStack`;
6. `AssignStreams`;
7. `ConnectTraces`;
8. the run;
9. `AdjustCounts`;
10. the markers, with `AppendDropId`;
11. `EmitDiagnostics`;
12. `Check`.

Any reordering changes a stream offset and therefore every number. The
byte-identical control (#769) is what catches it.

### 3. Registration is explicit, not static initialisation

A module adds its arms in one function:

```cpp
// ns3/baselines/adaptive/helper/adaptive-arms.cc
void ns3::bench::RegisterAdaptiveArms() {
    RegisterArm("ara", "ARA (Günes et al. 2002)", &MakeAraArm);
    RegisterArm("termite", "Termite (Roth 2005, ch. 4)", &MakeTermiteArm);
    RegisterArm("qrouting", "tabular Q-routing (Boyan & Littman 1994)", &MakeQRoutingArm);
}
```

`routing-compare`'s CMake looks for the arm modules installed beside it. It
generates `arms-generated.cc`, which calls each present module's function at
start-up.

Registering from a static initialiser was rejected. ns-3 builds modules as
shared libraries, and two risks follow:

- a link with `--as-needed` drops a library nothing references by symbol, so
  its arms would vanish silently;
- initialisation order across libraries is unspecified.

An explicit call is deterministic and visible in the build.

The `--protocols` help, the `--PrintHelp` arm list, `check-arm-delivery.sh`,
`check-determinism.sh` and the arm half of `check-allowlists.sh` all derive
from the registry (#768). An unknown arm still aborts
([#448](https://github.com/danieljoppi/AntHocNet/issues/448)).

### 4. The compatibility promise

- **No published number moves.** The move is accepted only when one cheap
  block of every committed v2.4.0/v2.5.0 MANET-family cell reproduces its
  `##RUN##`, `##ROUTE##` and `##COMMON##` rows byte for byte through
  `routing-compare` ([#769](https://github.com/danieljoppi/AntHocNet/issues/769)).
  The precedent is the #746 path control.
- **The old name keeps working.** `anthocnet-compare` stays as a second
  program in `routing-bench/examples/`. It takes the same arguments and gives
  the same output, built from the same sources with every present arm
  registered. That keeps committed campaign plans, `benchmark-cell` dispatches
  and `campaign.py`'s legacy translation working.

  It is kept at least through v3.x. Its removal, if ever, is a major-version
  change announced one release ahead.
- **The marker lines are an interface.**
  - Their layout is the one [metrics.md](../benchmarks/metrics.md) defines
    today.
  - v2.7.0 versions it with a leading `##HARNESS## version=<n>` line, so the
    readers refuse layouts they do not know
    ([#771](https://github.com/danieljoppi/AntHocNet/issues/771)).
  - Until then, adding a marker or a field is allowed; reordering or removing
    one is not.

### 5. Out of scope

- **Other simulators.** ADR-0023 stands: the harness is ns-3.
- **The satellite harnesses.** They come later, on the same registry (#773).
- **Distribution.** The separate release packages and the readers' Python
  package are v2.7.0 (#770, #771). This ADR fixes only the boundary they
  package.

## Amendment (2026-10-29, #767/#768): the hooks the extraction needed

The move added hooks; it changed no call point of the original ones. In call
order, the full set the harness now calls (see `routing-bench-arm.h`):

| hook | when | first user |
|---|---|---|
| `Configure(scenario)` | once per listed arm, while the scenario is resolved | the oracle's per-family recompute cadence (#506, #488, #580) |
| `Validate(scenario)` | once per listed arm, before any run | planar GPSR on a 3-D field (#480); 802.11s off 802.11a (#708) |
| `EmitConfig(out)` | once per listed arm, in the `##CONFIG##` block | the oracle's off-default recompute cadence |
| `ProvidesDevices` / `InstallDevices` / `AssignDeviceStreams` | step 2; device streams from the fixed device sub-block | hwmp |
| `InstallRouting` | step 4 | every arm |
| `AfterStack` | step 5 | GPSR's UDP re-wiring; AntHocNet's energy probe |
| `AssignStreams` | step 6 | every arm |
| `ConnectTraces(run, m)` | step 7 | the opt-in books below; hwmp's mesh frames; AntHocNet's ant tallies |
| `AfterAddresses(run, ifs)` | after IPv4 addresses | hwmp's ARP prefill |
| `StartReplay` / `FinishReplay` | around the run | AntHocNet's `--vizTrace` (#641) |
| `AdjustCounts` | step 9 | sends refused at the source (oracle #464, OLSR #510) |
| `EmitRunNote` | after the counts | `# hwmp` |
| `FillDropDetail` | the drop book | AntHocNet's pending-queue causes and its own re-injection count |
| `CollectHoldTimes` | for `##HOLD##` | AntHocNet (#308) |
| `AppendDiag` | the `# diag` line | AntHocNet's ant, linkfail, ptable and hold fields |
| `EmitDiagnostics` | step 11 | `##ORACLE##` |
| `Check` | step 12 | the oracle puts nothing on the wire (#296) |

`Measurement` is what an arm may touch of the run's measurement: the sinks it
connects its protocol's traces to, and three **opt-in books** whose lines are
printed only for the arms that ask (#382: absence, not zero):
`TrackReinjectionIdentity` (`##REINJ##`, #386), `TrackPendingQueue`
(`pqSilent`/`pqEcb` on `##DROPID##`, #229) and `TrackPacketFate` (the
per-packet drop book of the re-routing arms, #761).

Two settled details:

- **Naming.** A module's registration file is `helper/<module>-bench-arms.cc`
  and defines `ns3::bench::RegisterArms_<module>()`, hyphens as underscores.
  `routing-compare`'s CMake globs for the file and keeps the modules in
  `ns3-all-enabled-modules`.
- **No library token.** An arm module names `routing-bench`'s library through a
  variable, compiled in only when it is installed and enabled: ns-3 resolves
  module dependencies by scanning CMakeLists for `${lib…}` tokens, and every
  arm module must still build alone (`BASELINES=0`, bake).

Verified byte-identical against the pre-move harness on the ns-3.42 image:
MANET (aodv, olsr, dsdv, anthocnet, oracle), mesh (hwmp), every vendored arm,
FANET and VANET presets (the oracle's family cadence), TCP, Nakagami with
energy, `--seriesEvery` and `--qdiag`, and the replay file. The committed-cell
control is #769.

## Amendment (2026-10-31, #770): packaged on its own

The harness and the adaptive arms ship as their own release assets,
`routing-bench-<ver>.tar.gz` and `adaptive-<ver>.tar.gz`, beside
`anthocnet-ns3-modules-<ver>.tar.gz`. `tools/release/module-tarball.sh` cuts
all three from one `make install-ns3` run, so the layouts cannot drift. Each
unpacks into `contrib/` with its README, the licence and an install note, and
the release's provenance attestation covers both.

**Versioning:** the packages carry the AntHocNet release version. One version
line keeps "which harness produced this cell" answerable from the release tag
alone. The packages get their own version line only if an outside user needs
to pin the harness independently of AntHocNet; then the marker contract
version (`##HARNESS## version=`, #771) is what that user pins, not the
package version.

CI (`ci-ns3.yml`, job `packages`) builds each package from its tarball on a
clean stock ns-3 tree, with `tools/checks/check-packages.sh`:
- the harness alone, and the harness with the adaptive arms, on ns-3.36 to 3.48;
- adaptive alone on the newest release.

The harness must offer exactly the expected arms, and every arm must deliver
over more than one hop.

## Consequences

- **An arm becomes a module plus one function.** The wiring checklist in
  [comparison-harness.md](../comparison-harness.md) shrinks to "register your
  arm". #435's allowlist gate keeps only the module lists.
- **AntHocNet becomes one arm among others.** Its diagnostics (`##REINJ##`,
  `##HOLD##`, the ant tallies, the replay trace) move into its arm class.
  That is where they belong: they describe AntHocNet, not the comparison.
- **The harness can ship alone** (v2.7.0, #770), with the stock arms, and the
  `adaptive` module beside it.
- **Cost:** a large mechanical move across an ns-3 example that every
  campaign depends on. The byte-identical control is the gate, and the move
  lands in reviewable steps: registry (#766), extraction (#767), arm modules
  (#768), control (#769).
- **A new dependency edge:** every arm module links `routing-bench`. A user
  who wants only an arm, for example the `adaptive` protocols in their own
  program, still gets it. `routing-bench` is small, and the arm's protocol
  classes do not use it.

## Alternatives considered

- **Keep the monolith and document the wiring.** That is what
  [comparison-harness.md](../comparison-harness.md) does today. It still
  needs AntHocNet installed, so it does not let anyone use the harness alone.
- **Plugins loaded at run time (`dlopen`).** Rejected: it adds a second build
  and load path per platform. The CMake-generated registration achieves the
  same "drop a module in and it appears" with nothing to load at run time.
- **A Python driver that composes ns-3 programs.** Rejected: one binary per
  arm loses the single-process, same-seed pairing, and duplicates the
  scenario code in two languages.

## References

- [comparison-harness.md](../comparison-harness.md), [metrics.md](../benchmarks/metrics.md), [methodology.md](../benchmarks/methodology.md)
- #764 (epic), #766 to #769 (v2.6.0 steps), #770 to #773 (v2.7.0 and later)
- #352 (pinned streams), #435 (allowlists), #439 (delivery smoke), #448 (unknown arm aborts), #746 (the path-control precedent)
