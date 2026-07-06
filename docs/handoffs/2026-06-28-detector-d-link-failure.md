# Handoff — Issue #19: NS-3 MAC tx-failure detector (detector D)

> **Purpose.** Prime a fresh session (AI or human) on the detector-D / link-failure
> work without replaying the chat. Per [ADR-0013](../adr/0013-track-bugs-and-findings-as-issues.md),
> the GitHub issues are the durable record; this file is the index + context.
>
> **Date:** 2026-06-28 · **Status:** #19 resolved on `main`; follow-ups #45/#46/#47 open.

## TL;DR

- **#19** asked to wire the NS-3 MAC transmit-failure repair hook (ADR-0008
  **detector D**) so route-repair ants fire (`repair=0` → `repair>0`).
- **#43** implemented it and was merged — then the paper benchmark showed it
  **regressed** AntHocNet in its design regime (the repair/notification machinery
  fired on every transient MAC drop → control-traffic storm).
- **#44** root-caused and fixed it (debounce + repair guard + rate-limit),
  **recovering** the regression while keeping `repair>0`. Merged.
- **Honest conclusion:** detector D is **neutral**, not the hoped-for win, vs the
  hello-timeout detector (A) that already existed. Net positive of the episode is
  the debounce + the follow-ups below.

## Timeline & artifacts

| What | Where | Outcome |
|---|---|---|
| Ticket | [#19](https://github.com/danieljoppi/AntHocNet/issues/19) | open until follow-ups land |
| Hook impl | PR [#43](https://github.com/danieljoppi/AntHocNet/pull/43) → `13e7d9a` | merged; **regressed** |
| Debounce fix | PR [#44](https://github.com/danieljoppi/AntHocNet/pull/44) → `83dd759` | merged; **recovered** |
| Root-cause writeup | [#19 comment](https://github.com/danieljoppi/AntHocNet/issues/19#issuecomment-4826657475) | — |
| Fix A/B writeup | [#19 comment](https://github.com/danieljoppi/AntHocNet/issues/19#issuecomment-4826694839) | — |
| Taxonomy A/B writeup | [#19 comment](https://github.com/danieljoppi/AntHocNet/issues/19#issuecomment-4826812073) | — |

Benchmark runs (manual `paper-benchmark.yml`, 50 nodes / 1500×300 m / 20 m/s / pause 30 / 3 seeds):
- baseline (pre-#43, `655e66d`): [run 28289586841](https://github.com/danieljoppi/AntHocNet/actions/runs/28289586841)
- regression (#43, `f05df76`): [run 28322221683](https://github.com/danieljoppi/AntHocNet/actions/runs/28322221683)
- fix (#44, `556193d`): [run 28328113554](https://github.com/danieljoppi/AntHocNet/actions/runs/28328113554)
- post-merge taxonomy (`benchmarks.yml`, `83dd759`): [run 28328544294](https://github.com/danieljoppi/AntHocNet/actions/runs/28328544294)

## The numbers (paper benchmark, mean of 3 seeds)

| metric | baseline (A only) | regression (#43, A+D) | fix (#44, debounced D) | AODV |
|---|---|---|---|---|
| PDR % | 22.7 | 19.7 | 21.9 | 22.4 |
| mean delay (ms) | 335 | 705 | 452 | 214 |
| delay99 (ms) | 8166 | 9172 | 8693 | 3602 |
| NRL | 167.9 | 274.2 | 175.8 | 220.7 |

Ant volumes that explained it (`antTx`, mean of 3): proactive **8.9k → 24.7k**
(+177%) and `antRx[linkfail]` 220k → 333k under #43; ctrlTx +42%.

## Root cause (one paragraph)

`AntRouterLogic::reportTxFailure` called `reportNeighborLoss` (full neighbour +
pheromone eviction) on **every** `WIFI_MAC_DROP_REACHED_RETRY_LIMIT`. In a dense /
contended network most retry-limit drops are transient collisions, not breaks, so
valid routes were destroyed; the resulting route gaps made **proactive forward
ants — which carry `broadcastBudget = -1` (unbounded) — flood-rebroadcast**, adding
contention → more drops → more evictions (positive-feedback storm). Detector A
(hello-timeout) already detected breaks authoritatively, and the protocol was
better with A alone.

## The fix (#44)

Core, shared by both adapters:
1. **Debounce D** — `Config::txFailureThreshold` (=3) consecutive failures with no
   reception in between (any reception via `learnNeighbor` resets the streak).
2. **Repair guard** — only repair if no alternate route survives ([1] §3.5).
3. **Rate-limit** repair ants per destination (`reactiveRetryInterval`).

## Key code locations

- Core decision logic: `core/src/ant_router_logic.cpp`
  — `reportTxFailure`, `reportNeighborLoss`, `loseNeighbor`/`learnNeighbor`
  (debounce reset), `createForwardAnt` (the `broadcastBudget = -1` for proactive),
  forward-ant dispatch / `broadcastForward`.
- Core config: `core/include/anthocnet/core/config.h` (`txFailureThreshold`,
  `repairMaxBroadcasts`, `allowedHelloLoss`).
- Core tests: `core/tests/test_link_failure.cpp` (cases 7–10: tx-failure, debounce,
  repair guard).
- NS-3 adapter: `ns3/model/anthocnet-routing-protocol.cc`
  — `NotifyTxError` (WifiMac `DroppedMpdu` hook), `MapMacToCore` (ARP), `NotifyInterfaceUp`.
- NS-3 test: `ns3/test/anthocnet-test-suite.cc` (`RepairAntOnLinkBreakTestCase`).
- NS-2 reference: `ns2/src/ahn_router.cc` (`linkFailed`).
- Design: ADR-0008 (two detectors), improvement item 05 (sub-step D).

## Open follow-ups

- **#45** — bound the proactive forward-ant broadcast (`broadcastBudget = -1`); the
  latent amplifier behind the storm. *P2, core.*
- **#46** — detector D: re-inject the failed data packet (NS-2 parity) + expose
  `txFailureThreshold` as an ns-3 attribute and decide whether D stays on by
  default (it's currently neutral). *P2, core + NS-3.*
- **#47** — confirm two noisy quick-taxonomy cells (dense-small mean delay,
  heavy-load delay99) with a higher run count. *P3, bench.*

## How to continue

1. Read [#19](https://github.com/danieljoppi/AntHocNet/issues/19) top-to-bottom
   (problem → root cause → fix → taxonomy), then the relevant follow-up issue.
2. `make test` (core) before any core change; adapter changes are validated by the
   CI matrix (ns-3.36–3.48) — see [`AGENTS.md`](../../AGENTS.md).
3. Re-benchmark protocol changes with the manual `paper-benchmark` workflow and
   post the A/B back to the issue (ADR-0013).
