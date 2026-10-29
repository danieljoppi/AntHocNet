# Scenario validation: every rule and why it exists

Part of the `benchmark-results` skill; [SKILL.md](../SKILL.md) is the procedure. Read this file when the step you are on needs it.

## Scenario validation (`scenario_check.py`, #134)

Pre-flight a config before dispatching; sanity-check results after fetching.
Both exit non-zero on FAIL.

```bash
S=tools/bench/scenario_check.py
python3 $S preflight                              # paper base defaults, OK
python3 $S preflight --areaX 2500 --flows 40      # override what you'd dispatch
python3 $S preflight --areaX 1000 --areaY 1000 --areaZ 300 --range 250 \
    --speed 20 --pause 0 --mobility gaussmarkov --nodes 30 --pathWindowS 2  # 3-D cell (#481)
python3 $S preflight --areaX 1000 --areaY 1000 --mobility manhattan \
    --propagation urban --blocksX 5 --blocksY 5 --speed 20 --pause 0 \
    --nodes 60 --pathWindowS 2  # VANET street grid: road-network degree (#488)
python3 $S preflight --harness isl-grid --rows 4 --cols 4 --flows 8 \
    --time 900 --breakLink 0,0,3,0 --breakAt 450  # satellite cell (#444)
python3 $S results cell.txt                       # ##BENCH## cell or campaign CSV
python3 $S results --anchor broch-low-mobility cell.txt   # enforce #59 floor
```

`preflight` checks: expected mean node degree (strip-geometry aware) vs the
ln(n) connectivity threshold, offered load vs the pinned 2 Mbit/s channel
(#84), `range ≥ area` single-hop degeneracy, short-sim and static-field
warnings, and the #230 **diversity-window coherence** rule — `--pathWindowS`
against the `range / (2·speed)` link lifetime, since a window longer than a
route survives counts route *replacement* as concurrent multipath. That last
one FAILs the shipped 10 s default at the paper-base knobs, which is where
#230 should have been caught instead of after a 115-minute campaign.

With `--areaZ > 0`, `preflight` switches to 3-D rules (#481):
- the degree comes from a measured in-box pair probability, not the strip cap;
- the harness's five 3-D refusals FAIL here too (tworay, nakagami, ssrwp,
  gpsr, negative `--areaZ`);
- a standing WARN marks the cell as harness validation only until #482.

The hello-vs-link-lifetime rule (`--helloInterval`, default 1 s) applies to
every cell: FAIL below one hello period, WARN below three.

`preflight --harness isl-grid` validates a satellite cell instead (#444 — the
validator the #432 dispatch had to hand-build and discard, made permanent).
Knobs and defaults mirror `ns3/anthocnet/examples/isl-grid.cc`; the MANET interface is
untouched. It mirrors every dispatch-time `NS_ABORT` in the harness (topology
closed form, break-endpoint format/range/adjacency including torus wraps,
`breakAt` inside the window, corridor prerequisites, the #420
dsdv-on-multi-ISL rejection) plus the checks the harness cannot make at t=0:
a BFS proving the cut ISL lies on a configured flow's shortest path (flow
endpoints are the deterministic `i -> n-1-i` pairing plus the corridor probe,
so the check is exact — a break nobody routes over FAILs), the corridor's
ρ = load/capacity echoed so an overload is declared rather than accidental
(and the #280 `flows=0` probe contract enforced), and the #296/#362 arm notes
(oracle exact on the wired substrate; canonical `--protocols` order). `results` checks: PDR ∈ [0,100], delay99 ≥ mean delay, negative
metrics, dead cells (#28), the #209 energy invariants (total energy positive
and finite, energy-per-delivered-packet finite and non-negative — and non-zero
whenever PDR is, residual energy within [0, initial]; all skipped for inputs
predating energy instrumentation), the #212 reordering bounds (out-of-order
ratios in [0,1]; extents and reorder-buffer occupancies finite and
non-negative — all skipped for inputs predating reordering instrumentation),
the #215 drop-cause identity (PDR plus the
five protocol-agnostic causes must account for ~100% of offered packets: WARN
past 1 pp, FAIL past 5 pp — the tolerance is the data still queued when the run
stops; also FAILs a negative cause share, which means two causes count the same
packet; skipped for inputs predating drop instrumentation),
the #217 route-quality invariants (mean path
length ≥ 1 hop and ≤ `maxPathLength`, max ≥ mean; used-path diversity ≥ 1 and
≤ its own maximum; path entropy in [0, log2(max diversity)]; Jain's fairness
index ∈ [0,1] — each of them non-zero whenever PDR is, so a trace that silently
failed to connect reads as a FAIL rather than as "no multipath"; all skipped for
inputs predating route-quality instrumentation), and — with `--anchor` — the AODV floors read from
`ns3/tools/anchors.yml` (never duplicated). A `results` FAIL is a #51-class
harness regression: fix the harness before trusting any number from that run.

#### Path diversity is read as excess over the in-run churn floor (#230)

`path_div_used` counts distinct next hops that carried data for one
destination inside one `pathWindowS` window. A protocol that installs one route
per destination can only exceed 1.0 by having that route *replaced* inside the
window, so **whatever `aodv`/`olsr`/`dsdv` read above 1.0 is that scenario's
churn floor**, measured in-run by three protocols at once. `results` therefore
prints, once per cell (not once per protocol):

- floor ≤ 1.10 → `ok: … path diversity readable — anthocnet 1.229 vs
  single-path floor 1.133 (aodv) at windowS=2: excess +0.096`. That excess is
  the only quotable diversity claim.
- floor > 1.10 at a window above 2 s → one **WARN**: the diversity columns are
  churn-dominated and unquotable, with the floor, the protocol that set it and
  AntHocNet's excess in the message.
- AntHocNet at or below a *clean* floor → **WARN**: no concurrent spreading in
  a cell able to show it.
- a single-path baseline above 1.50 at a churn-free window (≤ 2 s), or any
  arithmetic break (diversity < 1, above its own maximum, zero at non-zero PDR,
  entropy above log2(max)) → **FAIL**, unchanged: those are broken
  instrumentation, not a mis-set threshold.

The absolute `> 1.10 ⇒ FAIL` rule this replaces was **not** calibratable. The
#230 sweeps show the floor is a function of the scenario knobs — olsr/aodv read
1.000/1.000 at `windowS=2`, 1.116/1.109 at 4, 1.198/1.190 at 6, 1.322/1.311 at
10, and 1.133 at `windowS=2` once the rate is raised to 8 pkt/s — while
`windowS ≤ 2` at paper traffic pins *every* protocol, AntHocNet included, at
~1.00 by sample starvation. No constant is both satisfiable and informative.
Worse, the rule passed the row least worth trusting: across the 14 cells of the
v1.5.0 campaign AntHocNet reads **below** the single-path floor every time
(excess −0.061 to −0.144), so the threshold failed the three controls and
cleared the arm they were controlling.

And the excess never invalidates a cell: `divUsed` is accumulated in its own
(node, dest, window) map off the WifiMac `AckedMpdu` trace
(`routing-bench-run.cc` `CountAckedDataHop`), while PDR/delay/delay99/
throughput/NRL/jitter come from FlowMonitor and the energy columns from the
energy model. A churn-inflated diversity figure cannot move a published number,
so it is a WARN about three columns, not a FAIL about the cell. It was a FAIL
for 14 consecutive campaign cells, every one of which was correctly waved
through — which is how a gate stops being read.

### Testing the gate itself (`test_scenario_check.py`)

```bash
python3 tools/bench/test_scenario_check.py
```

No pytest, no simulator, ~1 s; runs on every PR from `lint.yml`. Every rule
gets **two** cases — a crafted row where it must fire and one where it must
not. The second half is the point: the first cut of #229's queue diagnosis
keyed on "`drop_queue_pct` is zero" and flagged `anthocnet` and `aodv` rows
that were accounting correctly. A check that cries wolf gets ignored, and then
it is not a gate. Fixture values are the real campaign readings, so moving a
threshold has to confront the observation that set it.

## Adding a metric: the three things that ship with it (#229/#230)

Both the reordering and path-diversity defects were findable **before** any
campaign, in milliseconds, from a synthetic input. They survived six merged
campaigns because the metric shipped with a definition and a CSV column and
nothing that could fail. So a new metric family is not done until it has:

1. **A control arm with a value known a priori** — written down as a *number*,
   not as "should be small". `path_div_used` had exactly this in prose ("the
   single-path baselines are the instrumentation's self-check") and still
   shipped reading 1.428 for OLSR, because prose does not fail.
2. **An automated assertion of that control** in `scenario_check.py results`,
   with a case in `test_scenario_check.py` proving it fires and one proving it
   stays quiet. If the assertion cannot be written, the metric's claim is not
   yet falsifiable — and that is the finding, before the dispatch.
3. **A preflight coherence rule** for any parameter the metric depends on,
   checked against the scenario knobs. `--pathWindowS` is meaningless without
   the mobility it is compared against; the rule relating the two costs nothing
   and catches the defect at zero dispatches.

**Order of operations.** Run `preflight` (free), then *one cheap point* —
`benchmark-cell.yml` at `--runs=2 --time=300`, a `-opt` image — and run
`scenario_check.py results` on that before committing to a taxonomy sweep. A
control that reads wrong reads wrong in 20 minutes just as clearly as in 115.
