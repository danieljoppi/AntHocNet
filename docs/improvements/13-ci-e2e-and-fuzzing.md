# 13 — End-to-end simulation smoke in CI + codec fuzzing + property tests

- **Covers:** D1 (e2e smoke), D2 (fuzzing + property tests)
- **Priority:** P2
- **Effort:** M
- **Layer:** CI (`.github/workflows/`) + `core/tests/`
- **Depends on:** 12 (shares the fuzz target)

## Summary

CI currently runs only the core unit tests + the NS-2 patch apply/revert
self-test. `CONTEXT.md §8` explicitly flags that **no full simulation runs in
CI** and behavioural validation on real NS-2/NS-3 trees is manual. This item adds
(D1) a pinned end-to-end simulator smoke test and (D2) fuzzing + property tests,
so regressions in actual routing behaviour are caught automatically.

## Current state

```yaml
# .github/workflows/ci.yml runs: make test (core) + ns2/patch/selftest.sh
```

The NS-3 module is built only on manual dispatch; nothing runs a real
end-to-end simulation or asserts delivery.

## D1 — Pinned end-to-end smoke tests

### NS-3 smoke job

Add a CI job (manual dispatch + nightly; too heavy for every push) that:
1. Checks out a **pinned** ns-3 tag (e.g. `ns-3.40`) — pin the exact version so
   the job is reproducible and a future ns-3 change can't silently break it.
2. `make install-ns3 NS3DIR=...`, configures with the modules from
   `docs/benchmarks.md`, builds.
3. Runs `anthocnet-example` and asserts a **non-trivial delivery ratio** in a
   small connected scenario (e.g. PDR > 50% on a static 7-node line), parsing the
   FlowMonitor/CSV output.
4. Optionally runs `anthocnet-compare --runs=1 --time=20` and asserts AntHocNet
   delivers at all (sanity, not a performance gate).

### NS-2 smoke job

Add a job that builds a pinned ns-2 (e.g. `ns-2.35`) with the patch applied and
runs `ns2/tcl/1-simple.tcl`, asserting non-zero CBR delivery from the trace
(reuse the awk snippet in `docs/cross-validation.md`). ns-2 builds are slow/old —
gate behind manual dispatch or a weekly schedule and cache the built tree.

### Guardrails

- Pin simulator versions; record them in the workflow.
- Make the delivery thresholds **loose** (catch "delivers nothing" regressions,
  not performance noise — that's items 07/08's job).
- Keep these jobs off the per-push path (runtime); per-push stays `make test` +
  patch self-test.

## D2 — Fuzzing + property tests

### Codec fuzzing

Use the `fuzz_codec.cpp` target from item 12; add a short (≤60 s) libFuzzer run in
CI on PRs that touch `core/src/ant_message_codec.cpp` or the adapter headers.
Keep a small seed corpus (a few serialized valid ants) in
`core/tests/fuzz_corpus/`.

### Property / invariant tests

Add `core/tests/test_properties.cpp` asserting invariants over randomized inputs
(seeded `ScriptedRng`/generator):

- **Selection is a valid distribution:** for any non-empty pheromone table, the
  per-neighbour selection probabilities are ≥ 0 and the chosen hop always has
  pheromone > `minPheromone` (or is the only option).
- **Evaporation is monotonic non-increasing** for an un-reinforced link and
  converges below `minPheromone` (prune) in bounded steps.
- **Reinforce is a contraction toward the update:** `reinforce(v,u)` lies between
  `min(v,u)` and `max(v,u)` for `γ∈[0,1]`.
- **Codec round-trip:** `deserialize(serialize(m)) == m` for randomized valid
  `m` (extends the existing single-case `test_codec.cpp`).
- **Dedup bound:** `AntHistoryTracker` never exceeds `maxHistory` entries and
  evicts FIFO.

These are cheap, simulator-free, and run on every push with `make test`.

## Files to touch

- `.github/workflows/ci.yml` (codec fuzz job; property tests run via `make test`)
- `.github/workflows/e2e.yml` (new; manual + scheduled NS-2/NS-3 smoke)
- `core/tests/test_properties.cpp` + `core/tests/CMakeLists.txt`
- `core/tests/fuzz_corpus/` (seed inputs)

## Acceptance criteria

1. `make test` now includes property tests and stays green.
2. A manual-dispatch `e2e` workflow builds a pinned NS-3, runs
   `anthocnet-example`, and **fails** if PDR is ~0 in a connected scenario.
3. An NS-2 smoke job builds the patched ns-2.35 and asserts non-zero CBR delivery
   on `1-simple.tcl`.
4. The codec fuzz job runs on codec-touching PRs without crashes.
5. `CONTEXT.md §7/§8` updated to reflect that an e2e smoke now exists (with its
   cadence/limitations).

## Risks / notes

- ns-2/ns-3 builds are heavy and flaky in CI; cache aggressively, pin versions,
  and keep them off the blocking per-push path.
- Don't turn smoke thresholds into performance gates — noise will cause false
  failures; performance lives in items 07/08 (manual, multi-seed).
