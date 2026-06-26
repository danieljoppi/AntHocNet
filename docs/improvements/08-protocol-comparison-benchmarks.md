# 08 — Benchmark against other routing protocols (comparison matrix)

- **Deviation:** — (evaluation, not a protocol bug)
- **Priority:** P2 (run alongside 01–06 to quantify each change)
- **Effort:** M
- **Layer:** `ns3/` tooling (+ optional `ns2/` scripts)
- **Depends on:** complements [07](07-validation-and-benchmarks.md) — 07 defines
  the **scenarios**; this item defines the **protocol set + metrics + fairness**.

## Summary

The repo already compares AntHocNet against **AODV, OLSR, DSDV** in
`ns3/examples/anthocnet-compare.cc`, but (a) it omits **DSR** (a reactive
source-routing baseline the AntHocNet papers care about), (b) it reports only
PDR / delay / throughput and **no routing overhead** — the metric on which
AntHocNet deliberately trades off, so leaving it out makes the comparison
incomplete, and (c) it doesn't report dispersion (stddev / CI) across seeds. This
item turns the harness into a complete, fair multi-protocol comparison.

## Background / spec

> "We compare its performance with **AODV (with local route repair)**, a
> state-of-the-art MANET routing algorithm and a de facto standard." — [1] §4

> "AntHocNet outperforms AODV in terms of delivery ratio and delay ... **However,
> AntHocNet is less efficient in terms of routing overhead.**" — [1] §5

So a fair comparison **must** report routing overhead next to PDR/delay, or it
flatters AntHocNet's competitors and hides AntHocNet's actual trade-off. Standard
MANET-comparison metric set (Broch et al. / Perkins): PDR, average end-to-end
delay, **normalized routing load (NRL)**, throughput, and (optionally) path
optimality and jitter.

## Current behaviour

`anthocnet-compare.cc` selects the protocol via an `InternetStackHelper` routing
helper:

```77:91:ns3/examples/anthocnet-compare.cc
    InternetStackHelper internet;
    if (proto == "anthocnet") {
        AntHocNetHelper h;
        internet.SetRoutingHelper(h);
    } else if (proto == "aodv") {
        AodvHelper h;
        internet.SetRoutingHelper(h);
    } else if (proto == "olsr") {
        OlsrHelper h;
        internet.SetRoutingHelper(h);
    } else if (proto == "dsdv") {
        DsdvHelper h;
        internet.SetRoutingHelper(h);
    }
    internet.Install(nodes);
```

Metrics computed from FlowMonitor (data flows only) — PDR, mean delay,
throughput; no overhead:

```129:138:ns3/examples/anthocnet-compare.cc
    for (auto& kv : monitor->GetFlowStats()) {
        r.txPackets += kv.second.txPackets;
        r.rxPackets += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        rxForDelay += kv.second.rxPackets;
        totalRxBytes += kv.second.rxBytes;
    }
    r.pdr = r.txPackets ? 100.0 * r.rxPackets / r.txPackets : 0.0;
```

Fairness is already handled well: `RngSeedManager::SetSeed(1); SetRun(seed)` is
reset before each protocol so every protocol sees the **same** mobility/traffic
realisation (`anthocnet-compare.cc:44-46`). Keep that.

The **NS-2 side already has per-scenario AODV vs AntHocNet** scripts
(`ns2/tcl/scenario1/scenario1-AODV.sh`, `scenario1-AntHocNet.sh`, etc.) — extend
those for parity rather than starting over.

## Required change

### 1. Add DSR to the comparison set (special install path)

DSR in ns-3 is **not** an `Ipv4RoutingProtocol` and is **not** set via
`SetRoutingHelper`. Install the internet stack first, then layer DSR on top:

```cpp
// proto == "dsr"
DsrHelper dsr;
DsrMainHelper dsrMain;
internet.Install(nodes);          // install stack WITHOUT a routing helper
dsrMain.Install(dsr, nodes);      // DSR sits above
```

Guard the rest of the install so the `internet.Install(nodes)` isn't called twice
for DSR. Requires the `dsr` module:
`--enable-modules='...;dsr'` and `#include "ns3/dsr-module.h"`.

Update the default protocol list and the CSV/table grep filter accordingly
(`anthocnet,aodv,olsr,dsdv,dsr`). Note in the doc that **AOMDV** (the multipath
baseline some AntHocNet papers use) is **not** in mainline ns-3 — call it out as
optional/contrib, don't fake it.

### 1b. AntHocNet ablation variants (ADR-0007)

Per [ADR-0007](../adr/0007-proactive-diffusion-gated.md), the proactive/diffusion
subsystem is config-gated and the benchmark must **decide the shipped default**.
Add AntHocNet ablation variants driven by the `enableProactive` / `enableDiffusion`
attributes (exposed via the NS-3 helper / NS-2 bind):

- `anthocnet-full` — `enableProactive=1, enableDiffusion=1` (the default build).
- `anthocnet-reactive` — `enableProactive=0` (reactive route setup + maintenance
  only; the cheap, simple baseline).
- *(optional)* `anthocnet-blind` — `enableProactive=1, enableDiffusion=0`
  (proactive ants without virtual-pheromone guidance) to isolate diffusion's
  contribution from proactive exploration's.

Report these alongside the other protocols so the table shows whether diffusion
actually buys PDR/delay at its overhead cost **in our scenarios**. If
`anthocnet-full` does not beat `anthocnet-reactive` on `paper-base`, that is the
signal to ship `enableProactive=false` by default and record it (ADR-0007
consequence).

Add one more ablation knob from [ADR-0012](../adr/0012-evaporation-is-a-secondary-safety-net.md):
`enableEvaporation` (default on). A `*-no-evap` variant of the chosen default
yields the **paper-faithful** mode (running-average + explicit link-failure removal
only, no time-proportional decay). Report it so the safety-net's default-ON status
is justified by measured stability/overhead, not intuition — if it does not help,
that is the signal to ship `enableEvaporation=false`.

### 2. Add a routing-overhead / NRL metric (protocol-agnostic)

FlowMonitor classifies only the CBR data flows, so control traffic is invisible
to it. Measure overhead by tracing every IP packet handed to L3 for transmission
at **every** node and partitioning into data vs control:

- Connect to the `Ipv4L3Protocol` `Tx` trace source on all nodes
  (`ns3::Ipv4L3Protocol/Tx`), counting packets + bytes.
- A packet is **data** iff it is UDP to the CBR port (9) belonging to a flow;
  everything else transmitted by the routing layer (AODV RREQ/RREP/RERR on UDP
  654, OLSR on UDP 698, DSDV periodic updates, AntHocNet ants on UDP 6900, DSR
  option headers) is **control**. Counting at every hop (not just the source)
  gives the standard "per-hop control transmissions" figure.
- Report:
  - **NRL** = control packets transmitted / data packets **delivered**
    (dimensionless; lower is better).
  - **control overhead** = control bytes/s (kbps) for an absolute view.

DSR caveat: DSR piggybacks route information in option headers on data packets,
so its "control" is partly inside data packets. Document that NRL slightly
under-counts DSR overhead and that this is a known measurement limitation; the
per-packet L3 Tx count still captures DSR's RREQ/RREP control packets.

Add fields to `Result`/`Agg` and to the CSV/table output.

### 3. Report dispersion across seeds

Single-seed MANET runs are noisy (the docs already say so). Accumulate per-seed
values and report **mean ± sample stddev** (or 95% CI = `1.96·stddev/√runs`) for
each metric, not just the mean. Add `*_stddev` columns to the CSV.

### 4. Scenario presets (defer to 07)

Use the presets defined in [07](07-validation-and-benchmarks.md) — at minimum run
the comparison on both `dense-small` (current, AntHocNet's hard case) and
`paper-base` (large/sparse/mobile, AntHocNet's intended regime), plus the
mobility and size sweeps. Don't re-invent scenarios here.

### 5. Per-protocol fairness rules

- Use each protocol's ns-3 **default tuning** (don't hand-tune competitors);
  record the ns-3 version and any non-default attributes in the output header.
- Identical PHY/MAC/mobility/traffic for all protocols (already true).
- AODV: leave local route repair at its ns-3 default and **state it** (the papers
  compare against "AODV with local repair").
- Same warm-up: data starts at t=5 s (already), metrics computed over the whole
  run; consider discarding a warm-up window so proactive protocols (OLSR/DSDV)
  aren't penalised for their initial convergence — document whichever you choose.

### 6. Extend NS-2 comparison scripts (optional, parity)

The `ns2/tcl/scenarioN/*` shell scripts already run AODV and AntHocNet. Add DSR
and DSDV variants (both ship with ns-2) and a small awk/Perl post-processor to
emit the same metric set (PDR, delay, NRL) from the `.tr` traces, so NS-2 and
NS-3 comparisons line up qualitatively (see `docs/cross-validation.md` — absolute
numbers won't match across simulators).

### 7. Plumb new metrics through the pipeline

- `ns3/tools/run-comparison.sh`: widen the CSV grep filter for `dsr,` and pass any
  new flags; keep emitting only CSV lines.
- `ns3/tools/update-benchmarks.py`: add the new columns (NRL, overhead, stddev) to
  the generated table; keep it deterministic (no timestamps) so CI doesn't make
  empty commits.
- `docs/benchmarks.md`: the auto-generated table gains NRL + overhead columns;
  add the second (`paper-base`) table from 07.

## Target table shape

```
| protocol  | PDR %      | delay (ms)  | thrput (kbps) | NRL        | ctrl (kbps) |
|-----------|-----------:|------------:|--------------:|-----------:|------------:|
| anthocnet | 71.2 ± 3.1 | 41.5 ± 5.2  | 6.8 ± 0.3     | 4.10 ± 0.4 | 31.2        |
| aodv      | 64.8 ± 4.0 | 88.1 ± 9.7  | 6.1 ± 0.4     | 2.35 ± 0.3 | 12.7        |
| olsr      | 58.3 ± 5.5 | 12.0 ± 1.1  | 5.4 ± 0.5     | 9.80 ± 1.1 | 60.4        |
| dsdv      | 49.1 ± 6.2 | 120.4 ± 14  | 4.2 ± 0.6     | 7.55 ± 0.9 | 48.9        |
| dsr       | 60.0 ± 4.8 | 95.3 ± 11   | 5.8 ± 0.4     | 1.90 ± 0.2 | 9.8         |
```

(Illustrative numbers only — they show the *shape*; the NRL column is the point:
it exposes AntHocNet's higher overhead the papers acknowledge.)

## Files to touch

- `ns3/examples/anthocnet-compare.cc` (DSR case; L3-Tx overhead trace; NRL;
  per-seed stddev; CSV columns; version header)
- `ns3/examples/wscript` / `ns3/CMakeLists.txt` (ensure `dsr` module linked)
- `ns3/tools/run-comparison.sh` (grep filter, flags)
- `ns3/tools/update-benchmarks.py` (new columns)
- `docs/benchmarks.md` (regenerated table + paper-base table)
- `ns2/tcl/scenario*/...` + a trace post-processor (optional NS-2 parity)

## Acceptance criteria

1. `anthocnet-compare --protocols=anthocnet,aodv,olsr,dsdv,dsr` runs to completion
   with the `dsr` module and emits all five rows.
2. Output includes **NRL and control-overhead** columns and **mean ± stddev**
   over `runs` seeds.
3. The same RNG realisation is shared across protocols (regression: assert two
   protocols see identical node initial positions for a fixed seed — e.g. log and
   diff the first node's start position).
4. `update-benchmarks.py` regenerates `docs/benchmarks.md` with the new columns,
   deterministically (re-running with the same CSV is a no-op).
5. Both `dense-small` and `paper-base` tables present in `docs/benchmarks.md`.
6. NS-3 builds with `aodv;olsr;dsdv;dsr;flow-monitor;anthocnet` enabled.
7. **Ablation present (ADR-0007/0012):** `anthocnet-full` and `anthocnet-reactive`
   appear as separate rows, driven by the `enableProactive`/`enableDiffusion`
   attributes, plus a `*-no-evap` row (`enableEvaporation=0`), so the diffusion and
   evaporation defaults can be justified from measured numbers.

## Risks / notes

- **DSR install is the classic ns-3 gotcha** — it must not go through
  `SetRoutingHelper`, and `internet.Install` must run exactly once. Test the DSR
  path in isolation first.
- The `paper-base` preset × 5 protocols × 10 seeds is **expensive**; gate it
  behind manual workflow dispatch (see 07), keep `dense-small` on the per-merge
  job.
- Don't tune competitors to lose; use defaults and record them. The honest story
  (AntHocNet: better PDR/delay, worse overhead, advantage grows with
  scale/mobility) is the one the papers tell — the benchmark should be able to
  reproduce that story on `paper-base`, especially after items 01–05 land.
- Keep cross-simulator expectations qualitative (`docs/cross-validation.md`).
