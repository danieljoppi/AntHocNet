# TCP: the transport arm

**Varies:** the transport layer alone — the paper base scenario's 20 CBR/UDP
flows replaced by 20 TCP flows (saturating `BulkSend` sources over
`ns3::TcpCubic`), everything else pinned. One arm, plus a 20-seed UDP control.

[← Benchmark index](../benchmarks.md) · [Metrics](metrics.md) · [Methodology](methodology.md)

> **Provenance — measured at `0b42c89`, *after* `v1.3.0`.** Like the
> [mobility × channel grid](grid.md), this page does **not** follow the
> [`v1.3.0` pin](methodology.md#provenance-which-version-a-number-was-measured-at):
> it was measured after
> [#327](https://github.com/danieljoppi/AntHocNet/issues/327) and
> [#352](https://github.com/danieljoppi/AntHocNet/issues/352), so its numbers
> are not comparable with the sweep or headline pages. The campaign also
> predates [#383](https://github.com/danieljoppi/AntHocNet/issues/383)/
> [#384](https://github.com/danieljoppi/AntHocNet/issues/384), so the commit is
> recorded **by hand** here rather than by the workflow — the last campaign
> that needs to be. Reproduce at commit
> `0b42c896b8969081a7b0ba160a9a7f4082461803`; run IDs in
> [Provenance](#provenance) below.

## What it varies

Every delivery number this project had published before this page —
the headline taxonomy, the sweeps, the [grid](grid.md) — is a **UDP/CBR**
number: an open-loop source that keeps offering packets no matter what the
network does. TCP closes the loop. Congestion control paces the source off the
path the routing protocol picked, losses become retransmissions rather than
missing packets, and the metric that matters becomes **goodput** (application
bytes delivered per second) rather than PDR. A routing protocol that looks
good under CBR can starve a TCP flow — route flaps that cost a CBR stream a
few packets cost a TCP stream an RTO. Whether the published ordering survives
the transport swap is therefore a real question, not a formality — and the
answer is that it does not survive intact.

The arm changes exactly two knobs against the paper base scenario
(50 nodes, 1500 × 300 m, 900 s, speed 20, pause 30, `rwp` × `tworay`):
`transport=tcp` and `ns3::TcpL4Protocol::SocketType=ns3::TcpCubic`. Both are
echoed by the cells' `##CONFIG##` rows.

## How it is produced

Five manual `paper-benchmark.yml` dispatches at commit `0b42c89`, image
`ghcr.io/danieljoppi/ns3:3.42-opt`, all four protocols on identical
realisations inside each cell:

- **Four TCP cells** of 5 seeds each (`firstRun` 1 / 6 / 11 / 16), pooled to
  **n = 20**. A single 20-seed TCP job would have run ~10 h against the 6 h
  ceiling, so this arm used
  [#126](https://github.com/danieljoppi/AntHocNet/issues/126) seed-splitting;
  [#352](https://github.com/danieljoppi/AntHocNet/issues/352) per-seed RNG
  stream assignment is what makes the four cells poolable as one 20-seed
  sample.
- **One UDP control** at 20 seeds, identical in every knob except
  `transport=udp` — the kill condition (below).

Per-seed goodput comes from the jobs' `##GOODPUT##` marker rows. The pooled
tables below are hand-written (independent dispatches, no generated block —
same as [grid.md](grid.md)); the underlying data is committed so they can be
re-derived: [`campaign/tcp-goodput.csv`](campaign/tcp-goodput.csv)
(80 rows: 20 seeds × 4 protocols). The per-cell column mapping was validated
against the harness's `# stddev` lines before any number here was read
(20 checks per cell, all OK).

## Results

### Goodput — kbps, mean with t-based 95 % CI, n = 20

| protocol | goodput (kbps) |
|---|---|
| anthocnet | **1346.0** [1301.9, 1390.0] |
| olsr | 1335.8 [1253.1, 1418.6] |
| dsdv | 1147.5 [1070.8, 1224.1] |
| aodv | 1026.7 [977.4, 1076.0] |

### Paired per-seed differences

All four protocols run on identical realisations per seed, so differences are
paired (t-CI on the per-seed difference, two-sided **exact** Wilcoxon
signed-rank, n = 20). This is the test of record; the per-arm intervals above
are for orientation.

| comparison | Δgoodput (kbps) | Wilcoxon p | seeds positive |
|---|---|---|---|
| anthocnet − aodv | **+319.2** [+256.4, +382.1] | 1.9 × 10⁻⁶ | 20/20 |
| olsr − aodv | **+309.1** [+211.0, +407.2] | 1.7 × 10⁻⁴ | 18/20 |
| dsdv − aodv | **+120.7** [+48.6, +192.9] | 3.7 × 10⁻³ | 15/20 |
| anthocnet − olsr | +10.1 [−74.9, +95.2] | 0.43 | 6/20 |

## The ranking-inversion statement

Under UDP/CBR the delivery ordering is `anthocnet > olsr > aodv > dsdv` — in
all six [grid](grid.md) cells, including the `rwp × tworay` cell this arm
re-ran as its control. Under TCP the goodput ordering is
`anthocnet ≈ olsr > dsdv > aodv`:

- **AODV falls from 3rd to last**, and the fall is not marginal — every one of
  the 20 seeds delivers more TCP goodput under AntHocNet than under AODV, and
  18/20 do under OLSR.
- **DSDV rises past AODV** (15/20 seeds, p = 3.7 × 10⁻³) after being the worst
  deliverer in every UDP cell.
- **AntHocNet vs OLSR becomes a statistical tie** (+10.1 kbps,
  CI [−74.9, +95.2], p = 0.43, 6/20 seeds) — under UDP the same pair is
  separated by ~7 pp of PDR in AntHocNet's favour.

**Consequence: a transport-layer claim that does not name its transport is
unsupported.** The published delivery ordering is a UDP/CBR ordering. This
project's headline "AntHocNet delivers more" is intact under TCP only in the
paired AntHocNet-vs-AODV sense; against OLSR the delivery advantage does not
transfer to TCP goodput at this scenario. This is the same scoping rule the
grid page had to adopt for the tail — there the ranking inverted with the
channel, here it reorders with the transport.

## The kill condition — UDP control

A transport contrast is only attributable to the transport if nothing else
moved. The 20-seed UDP control ran at `0b42c89` — a **different commit** from
the v1.4.0 grid's `4cdfb96`, both at the then-shipped `ReconvHoldCap = 1 s`
(this whole page predates the [#411](https://github.com/danieljoppi/AntHocNet/pull/411)
flip and the [grid re-baseline](grid.md); its numbers are 1 s-vintage) — with
the grid's `rwp × tworay` knobs, and reproduced that cell exactly:

- **Per-seed, field-for-field:** all 80 `##RUN##` rows (20 seeds × 4
  protocols) match the committed
  [`campaign/pooled-grid-mobility-channel-20260808-runs.csv`](campaign/pooled-grid-mobility-channel-20260808-runs.csv)
  rwp-tworay rows on every compared metric (pdr, delay, delay99, throughput,
  NRL, jitter, dOff50, dOff90) — zero mismatches, the only textual difference
  being the undefined-quantile sentinel (`inf` in the log, `−1` in the CSV).
- **Pooled, to printed precision:** mean PDR 97.43 / 85.92 / 90.59 / 84.99
  for anthocnet / aodv / olsr / dsdv — the v1.4.0 grid page's row verbatim
  (`git show v1.4.0:docs/benchmarks/grid.md`; the re-baselined page's
  baseline rows are unchanged, its anthocnet row is the 200 ms one). (The
  packet-pooled `# drops` aggregate reads 97.43 / 85.93 / 90.59 / 84.99; the
  0.01 on AODV is mean-of-seeds vs pooled-packets, not a reproduction gap.)

So [#352](https://github.com/danieljoppi/AntHocNet/issues/352) stream pinning
holds across the two commits: identical seeds produce bit-identical
realisations, and the TCP−UDP contrast on this page is a transport effect,
not code drift between `4cdfb96` and `0b42c89`.

## Caveats

- **`drop_mac`/`drop_chan` and the
  [#217](https://github.com/danieljoppi/AntHocNet/issues/217) route-quality
  family are structurally zero in these cells.** They predate
  [#389](https://github.com/danieljoppi/AntHocNet/issues/389), which widened
  the data-packet predicate to accept TCP on the data port; before it, the
  counters behind both families never incremented on a TCP cell. In every cell
  here the `# paths` lines read all-zero and the `# drops` lines carry 3–6 pp
  unaccounted with `mac`/`chan` pinned at 0.00, so `scenario_check.py results`
  FAILs the [#215](https://github.com/danieljoppi/AntHocNet/issues/215)
  drop-cause identity on the AODV rows. Neither family is published here, for
  the same reason the grid page withheld its fading-cell drop columns:
  present-and-wrong is worse than absent.

  **#389 has since merged**, and its
  [pre-registered A/B probe](https://github.com/danieljoppi/AntHocNet/issues/389#issuecomment-5232649715)
  confirmed on identical seeds that the UDP arm is byte-identical across the
  change while a TCP cell's `mac`/`chan` and `# paths` go live (drop-cause
  `sum` 93.3–96.0 → 97.2–100.0). **Re-running this arm at a post-#389 commit
  would populate both families** — the numbers on this page would not move
  (every goodput figure here is FlowMonitor- or `PacketSink`-derived, and the
  probe showed those byte-identical across the predicate change), but the two
  withheld families would become readable. Two things stay open even then: the
  drop-cause **identity** is still unvalidated under TCP — it was closed on
  per-packet UDP books, and TCP counts segments and retransmits them, which is
  why `##DROPID##` remains suppressed on TCP cells — and the probe left AODV
  with a −2.78 pp residual (down from −6.71 pp) that is the concrete work item
  for that validation.
- **`pdr` and `delay` change meaning under a saturating `BulkSend` source**
  and are deliberately not tabled. The logged TCP-cell "PDR" (~93–97 %) counts
  segments of a stream TCP itself paces and retransmits, and the per-seed
  `delay99` sits within ~3 ms of 500 ms for every protocol and every seed — a
  queueing plateau of the saturated source, not a routing tail. Goodput is the
  metric of record for this arm; the UDP pages' PDR/delay numbers are not
  comparable with anything in these cells.
- **Reorder columns are absent by design**
  ([#382](https://github.com/danieljoppi/AntHocNet/issues/382)): TCP consumes
  reordering internally, so the harness does not emit the family for TCP
  cells.
- **n = 5 per cell, n = 20 only pooled.** Each individual TCP cell is below
  the [#293](https://github.com/danieljoppi/AntHocNet/issues/293)
  published-point floor on its own; only the pooled 20-seed sample is quoted
  here, and every interval above is computed on the pooled rows.

## Provenance

`main` @ `0b42c896b8969081a7b0ba160a9a7f4082461803`, image
`ghcr.io/danieljoppi/ns3:3.42-opt`, `time=900`, paper base scenario knobs
(`nNodes=50`, `areaX=1500`, `speed=20`, `pause=30`, `rwp` × `tworay`,
`flows=20`), `protocols=anthocnet,aodv,olsr,dsdv`. TCP cells add
`transport=tcp` and `ns3::TcpL4Protocol::SocketType=ns3::TcpCubic`.

| cell | seeds | run ID | wall clock |
|---|---|---|---|
| TCP a | 1–5 | [`31284265709`](https://github.com/danieljoppi/AntHocNet/actions/runs/31284265709) | 1 h 51 m |
| TCP b | 6–10 | [`31284270170`](https://github.com/danieljoppi/AntHocNet/actions/runs/31284270170) | 2 h 27 m |
| TCP c | 11–15 | [`31284274799`](https://github.com/danieljoppi/AntHocNet/actions/runs/31284274799) | 2 h 29 m |
| TCP d | 16–20 | [`31284280268`](https://github.com/danieljoppi/AntHocNet/actions/runs/31284280268) | 2 h 34 m |
| UDP control | 1–20 | [`31284366759`](https://github.com/danieljoppi/AntHocNet/actions/runs/31284366759) | 4 h 00 m |

Every cell self-identifies through its `##CONFIG##` rows (`firstRun`,
`transport`, `SocketType`), so the seed mapping is read from the data rather
than from dispatch order. The result was measured and read against its
pre-registration in
[#63](https://github.com/danieljoppi/AntHocNet/issues/63#issuecomment-5229655110);
per-seed extraction and every statistic on this page were re-derived from the
job logs and reproduce the #63 numbers to printed precision.
