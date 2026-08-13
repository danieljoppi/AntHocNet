# Re-injection: the MAC-failure detector arm

**Varies:** the [#46](https://github.com/danieljoppi/AntHocNet/issues/46)
re-injection path alone — `EnableMacFailureDetector` on/off, and
`MaxReinjectPerPacket` ∈ {∞, 1, 2} while it is on. Four arms × two mobility
models on the fading channel, everything else pinned. This is the publishable
**detector A/B** at the [#293](https://github.com/danieljoppi/AntHocNet/issues/293)
20-seed floor, plus the cap sweep that shares its ON arm.

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md) · [Campaign plan](v1.5.0-campaign.md)

> **Provenance — measured at `7471447`, the v1.5.0 post-flip default
> (`ReconvHoldCap = 200 ms`).** Like the [grid](grid.md), this page does **not**
> follow the [`v1.3.0` pin](methodology.md#provenance-which-version-a-number-was-measured-at):
> it is phase 2 of the [v1.5.0 campaign](v1.5.0-campaign.md) and is measured at
> the same commit and default as the re-baselined grid, so it is comparable with
> that corpus and with nothing older. Run IDs in [Provenance](#provenance)
> below; the full readout is
> [#386 (comment)](https://github.com/danieljoppi/AntHocNet/issues/386#issuecomment-5279088201).

## What it varies

**Detector D** is the Wi-Fi MAC transmit-failure detector
([ADR-0008](../adr/0008-neighbour-liveness-two-detectors.md)): when a unicast
hits the 802.11 retry limit, the adapter calls `loseNeighbor` immediately
instead of waiting for the hello-timeout detector A to expire the neighbour.
Detector A is mandatory and always runs; D is a *latency optimisation* over it,
and `EnableMacFailureDetector=false` ablates D alone — the protocol still
detects the dead link, just later.

**Re-injection** is the second half of the same hook, and the half this page is
really about. On a retry-limit drop of a *data* packet, the adapter does not
only prune the dead neighbour: it puts the failed packet back into the pending
queue so it is retransmitted once a route exists (NS-2 parity, #46). Without
it, only the *route* recovers and the in-flight packet is lost. Two properties
make it worth measuring rather than assuming:

- **A retry-limit drop is not proof the frame was lost.** 802.11 unicast is
  data → ACK; the *ACK* can be the thing that failed, in which case the packet
  arrived and the re-injection is a duplicate
  ([metrics.md](metrics.md#why-a-retry-limit-drop-is-not-a-lost-packet)).
- **`MaxReinjectPerPacket`** caps how many times one packet copy may be
  re-injected across its whole path, and existed precisely to buy the rescue
  without the waste — if the waste turned out to be separable.

The arms:

| arm | `MaxReinjectPerPacket` | `EnableMacFailureDetector` | role |
|---|---|---|---|
| **A** | 0 (unlimited) | `true` | the shipped default — the ∞ arm **and** the A/B's ON arm |
| **B** | 1 | `true` | cap sweep |
| **C** | 2 | `true` | cap sweep |
| **D** | — | **`false`** | the A/B's OFF arm |

Arm A being shared is what made the publishable comparison free: A vs D is the
detector A/B, A vs B vs C is the cap frontier, one dispatch set.

**Fading cells only.** Both mobility models run against `nakagami`; the
mechanism does not engage under two-ray, where the reorder ratio is already
0.0004 and retry-limit drops are rare
([reading 2](https://github.com/danieljoppi/AntHocNet/issues/386#issuecomment-5234323092)).

## How it is produced

Eight manual `paper-benchmark.yml` dispatches on `main` @ `7471447`, image
`ghcr.io/danieljoppi/ns3:3.42-opt`, `time=900`, `runs=20 firstRun=1`,
`propagation=nakagami`, `gaussmarkov` at `pause=0`. Every cell's `##PROV##`
reads `commit=7471447` and `ReconvHoldCap=+2e+08ns`.

Each cell **self-identifies from its own `##CONFIG##`** (mobility, cap,
detector) rather than from dispatch order — which is how the run-ID table in
the dispatch comment was caught being wrong for 4 of 8 cells (the dispatches
ran all four `rwp` arms first, then all four `gaussmarkov` arms; the table
assumed they interleaved). The design was complete and balanced throughout;
only the labelling was wrong. The corrected mapping is in
[Provenance](#provenance) and is the one used everywhere on this page.

**Validation before any comparison.** `scenario_check.py results` on all 8
cells: **zero anthocnet FAILs anywhere** — every FAIL is the known
non-blocking [#230](https://github.com/danieljoppi/AntHocNet/issues/230)
path-diversity FAIL on the three baselines. The baselines are **byte-identical
across arms A/B/C/D within each mobility (all 63 rows)**, so the #51-class
control passes and every anthocnet delta is attributable to the knob. The cap's
own self-check passes by construction: `skips` is exactly 0 in arm A
(unlimited) and arm D (no events at all), non-zero in B/C with cap=1 > cap=2.

**Drop-cause columns are readable on every arm here**, including the capped
ones, only because
[#402](https://github.com/danieljoppi/AntHocNet/issues/402)/[#407](https://github.com/danieljoppi/AntHocNet/pull/407)
landed first: anthocnet drop-cause `sum` residues are +1.29 (A-rwp), +0.69
(B-rwp), +0.89 (C-rwp), +0.00 (D-rwp), +2.22 (A-gm), +1.22 (B-gm), +1.60
(C-gm), +0.00 (D-gm). The capped arms are now *tighter* than the uncapped ones
— cap=1 rwp went 108.49 pre-#407 → 101.57 post-#407 → **100.69** here at 20
seeds. No arm's drop columns are withheld.

## Results

### The detector A/B — A vs D

| cell | pdr ±95 | delay | delay99 boot [lo, hi] | nrl | reorder ratio |
|---|---:|---:|---|---:|---:|
| A-rwp (detector ON) | 89.78 ±0.86 | 59.64 | 920.0 [868.4, 964.2] | 46.89 | **0.1745** |
| D-rwp (OFF) | 84.23 ±0.71 | 46.35 | 820.4 [734.6, 903.7] | 46.74 | **0.0010** |
| A-gm (ON) | 85.87 ±1.11 | 69.76 | 1022.9 [987.5, 1055.6] | 52.44 | **0.2301** |
| D-gm (OFF) | 79.33 ±1.33 | 51.28 | 893.0 [816.0, 963.0] | 51.41 | **0.0009** |

Paired per-seed on identical realisations, n = 20:

| mobility | ΔPDR (ON − OFF) | p | seeds positive |
|---|---|---|---|
| rwp | **+5.55 [+4.78, +6.32] pp** | 9.54 × 10⁻⁵ | 20/20 |
| gaussmarkov | **+6.54 [+5.79, +7.29] pp** | 1.91 × 10⁻⁶ | 20/20 |

The n = 5 "+6.4 pp" diagnostic reading replicates at n = 20 and sits inside the
gaussmarkov CI. **The detector's delivery win is confirmed, not withdrawn** —
this was a pre-registered withdrawal condition and it did not fire.

Read the delay rows with the same survivorship caution the metrics page states:
the OFF arm's better mean delay and tail are measured over a delivered set that
is 5–7 pp smaller, and the packets it is missing are the ones re-injection
eventually delivers late.

### What the re-injections are: ~65–67 % duplicates

The `##REINJ##` counter measures, per re-injection event, whether that
`(flow, seq)` had **already been delivered to the sink** at the moment the
detector fired. At 20 seeds, on the ON arm:

| cell | `ofDelivered / events` | 95 % CI |
|---|---|---|
| A-rwp | **0.6519 ±0.0114** | [0.6405, 0.6633] |
| A-gaussmarkov | **0.6683 ±0.0147** | [0.6536, 0.6830] |

Roughly two of every three re-injections re-send a packet the destination
already has. The measurement is conservative by construction — a copy that
passed the failing hop but had not yet reached the sink counts as
not-yet-delivered — so the true duplicate share is at least this.

**This retires a caveat.** The ≥ 59 % figure this arm was built to test was a
*floor*, derived by inclusion–exclusion from two aggregates (`unackedRx` vs
`reinjected`) at 5 seeds, and it carried an explicit caveat: a downstream
`(src,seq)` suppression would have made "re-sent into the network" too strong,
and only a counter on the `NotifyTxError` path could settle it. That counter
now exists and both CIs lie **entirely above 0.59**, clearing the floor by
~6 pp — exactly how a conservative bound should behave. The direct measurement
supersedes the bound; the caveat is retired.

### The reorder collapse — duplicates drive the fading reordering

This is the part that could have collapsed, and the test was designed so it
could. Turning the detector off takes the fading `reorder_ratio` from **0.1745
/ 0.2301** (rwp / gaussmarkov) to **0.0010 / 0.0009** — a **175× / 256×**
collapse from the single knob that creates duplicates, with the baselines
byte-identical across the arms. 0.001 is the pre-registered "0.001-class": two-ray
and AODV territory (0.0004 / 0.0003).

The cap arms interpolate monotonically — the same mechanism at partial
strength:

| rwp arm | reorder ratio |
|---|---:|
| A (unlimited) | 0.1745 |
| C (cap 2) | 0.1320 |
| B (cap 1) | 0.0939 |
| D (detector off) | 0.0010 |

A duplicate arrives with a sequence number below the running maximum and is
therefore counted as reordered by RFC 4737's criterion, so this is not a
surprise mechanism — it is the predicted one, measured. **Duplicates, not
multipath spreading, are what AntHocNet's fading reorder ratio measures.** The
attribution and the [#399](https://github.com/danieljoppi/AntHocNet/issues/399)
`metrics.md` gloss correction do not reopen; see
[metrics.md § Packet reordering](metrics.md#packet-reordering-212-ns-3-only).

### The cap frontier — arms A / B / C

| cell | pdr ±95 | delay | delay99 boot [lo, hi] | nrl | reorder |
|---|---:|---:|---|---:|---:|
| A-rwp (unlimited) | 89.78 ±0.86 | 59.64 | 920.0 [868.4, 964.2] | 46.89 | 0.1745 |
| B-rwp (cap 1) | 87.89 ±0.68 | 52.70 | 853.5 [792.5, 913.3] | 45.77 | 0.0939 |
| C-rwp (cap 2) | 89.34 ±0.71 | 55.19 | 885.0 [840.0, 930.3] | 45.75 | 0.1320 |
| A-gm (unlimited) | 85.87 ±1.11 | 69.76 | 1022.9 [987.5, 1055.6] | 52.44 | 0.2301 |
| B-gm (cap 1) | 84.48 ±1.07 | 59.74 | 968.0 [916.4, 1008.9] | 49.92 | 0.1181 |
| C-gm (cap 2) | 84.96 ±1.01 | 65.14 | 1007.6 [959.6, 1039.0] | 51.05 | 0.1737 |

Against the pre-registered criteria, **neither auto-branch fires**:

- **Auto-adopt cap=1 — does not fire.** It requires dominance: the ΔPDR (A − B)
  upper CI bound must be < 1 pp, and it is **+2.62** (rwp) / **+1.80** (gm).
  The other two conditions do pass — the `postTx` cut is 48.20 % / 49.61 %
  (≥ 30 % required), and delay99 and NRL both improve.
- **Auto-reject all caps — does not fire.** The worst PDR loss is 1.89 pp
  (below the 2 pp threshold), C-rwp's CI includes zero (p = 0.0668), and there
  are compensating d99 / NRL / reorder gains.
- **→ the pre-registered "no auto-decision, frontier table to the maintainer"
  branch is TRIGGERED.** The sweep measures; it does not decide.

**Mechanism: the cap converts *delivered-after-only* into *never*.** On rwp,
`pktsNever` — re-injected keys never delivered at all — goes **2.66 % → 13.41 %
at cap=1** → 7.11 % at cap=2. The re-injections a cap discards are
disproportionately the ones that were *delivering* packets, and that is the
entire PDR loss. Three consequences, each of which is a reason not to read a
cap arm's improvements at face value:

1. **Every cap arm costs PDR, and PDR is the only thing the detector exists to
   buy.** cap=1 hands back **34 %** of the detector's +5.55 pp win on rwp and
   21 % on gaussmarkov; cap=2 hands back 8 % / 14 %.
2. **The overhead saving does not land where it is published.** A 48–50 %
   `postTx` cut yields only **−2.4 % / −4.8 % NRL** and −1.4 / −2.0 pp
   channel-busy (20.6 → 19.2 rwp, 21.0 → 19.0 gm). Re-injected *data* frames
   are not routing load, so NRL never counted them
   ([metrics.md](metrics.md#the-metric-families-at-a-glance)); the cap buys
   airtime, out of a ~20 pp budget nowhere near saturation.
3. **The capped arms' delay gains are survivorship-confounded.** A −11.6 % mean
   delay bought by not delivering 13 % of re-injected packets is not a latency
   improvement. Capped-arm delay and delay99 must not be quoted without the
   `pktsNever` context.

**If a cap is wanted anyway, cap=2 is the frontier point, not cap=1** — it is
the only arm whose rwp PDR loss is not significant (−0.44 pp, p = 0.0668, noise
by sign) while still cutting `postTx` ~27 %. cap=1 is strictly the worse buy:
2–4× the PDR cost for ~1.8× the transmission cut.

## What ships

**`MaxReinjectPerPacket = 0` (unlimited) — unchanged**, and
`EnableMacFailureDetector = true`. Per the pre-registration this is a maintainer
decision rather than an auto-adopt, and the recommendation with its reasoning is
on the [issue](https://github.com/danieljoppi/AntHocNet/issues/386#issuecomment-5279088201).
The sweep above is that default's documentation: the cost of the shipped
configuration is now measured (two thirds of re-injections are duplicates, and
they are what the fading reorder ratio is made of), and so is the cost of every
alternative that was on the table.

## Caveats

- **Fading only.** Nothing here transfers to a two-ray cell, where the detector
  fires rarely and the reorder ratio is already at multipath scale. The
  published two-ray numbers are unaffected by any of these arms.
- **Detector A is never ablated.** Arm D removes detector D only; neighbour
  loss is still detected, by hello timeout. This page says nothing about
  running with no failure detection at all.
- **The A/B is an operating-point comparison, not a defect verdict.** The
  duplicate traffic these counters expose is currently *paid for* in delivery:
  +5.55 / +6.54 pp of PDR. A cheaper way to buy the same delivery would be a
  protocol change, and would have to be measured against arm A.
- **`postTx` and the `##REINJ##` books are AntHocNet-and-UDP only**, and absent
  (not zero) on the baselines and on TCP cells — see
  [metrics.md](metrics.md#re-injection-identity--fate-reinj-386-ns-3-only-anthocnet--udp-only).
- **The uncapped drop-cause residue came in below its forecast** (+1.29 / +2.22
  against a pre-registered ≈ +3.3). Benign, and expected to differ: that
  forecast was calibrated at the 1 s hold cap while these cells ran at the
  200 ms post-flip default.

## Provenance

`main` @ `747144761c3662737e7402644b56de5e9774ef13`, image
`ghcr.io/danieljoppi/ns3:3.42-opt`, `time=900`, `runs=20 firstRun=1`
(seeds 1–20), `propagation=nakagami`, `protocols=anthocnet,aodv,olsr,dsdv`;
`ReconvHoldCap=+2e+08ns` on all 8.

| arm | cap | detector | mobility | run ID |
|---|---|---|---|---|
| A | 0 (unlimited) | `true` | rwp | [`31662269404`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662269404) |
| B | 1 | `true` | rwp | [`31662271976`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662271976) |
| C | 2 | `true` | rwp | [`31662274139`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662274139) |
| D | — | **`false`** | rwp | [`31662275527`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662275527) |
| A | 0 (unlimited) | `true` | gaussmarkov | [`31662277724`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662277724) |
| B | 1 | `true` | gaussmarkov | [`31662280223`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662280223) |
| C | 2 | `true` | gaussmarkov | [`31662282155`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662282155) |
| D | — | **`false`** | gaussmarkov | [`31662284121`](https://github.com/danieljoppi/AntHocNet/actions/runs/31662284121) |

> **The dispatch comment's run-ID table is wrong for 4 of these 8 rows** (the
> four middle ones) and must not be used: it assigned `31662275527` to A-gaussmarkov, `31662277724`
> to B-gaussmarkov, `31662280223` to C-gaussmarkov and `31662282155` to D-rwp.
> Analysing against it would compare a detector-off `rwp` cell against a cap=2
> `gaussmarkov` cell. The correction, with the per-cell `##CONFIG##` evidence,
> is at the top of
> [#386 (comment)](https://github.com/danieljoppi/AntHocNet/issues/386#issuecomment-5279088201).

One further deviation from the pre-registration is recorded for the same
reason: it planned 32 dispatches via
[#126](https://github.com/danieljoppi/AntHocNet/issues/126) four-way `firstRun`
splits, and what ran was 8 dispatches of `runs=20 firstRun=1`. Seeds 1–20 are
present in every cell, so validity is unaffected — but plan and artefact
disagree, and the artefact is what these tables are read from.
