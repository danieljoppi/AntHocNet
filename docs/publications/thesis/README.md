# Thesis — supplied, partially digested

Source document: F. Ducatelle, *Adaptive Routing in Ad Hoc Wireless Multi-hop
Networks*, PhD thesis, Università della Svizzera Italiana / IDSIA, **May 2007**
(218 pp). The maintainer decision of record (#58/#70, 2026-07-19) designates it
the **primary source** for parameter verification; the 2004 PPSN paper
([`../papers/2004-ppsn-anthocnet.md`](../papers/2004-ppsn-anthocnet.md))
confirms formulas and several constants but left the items below open.

**The PDF was supplied on 2026-07-25** and lives in the *private* papers repo at
`AntHocNet/library/2007-ducatelle-thesis.pdf`. It is not in this repository and
must not be: this repo keeps digests and citations only (papers-repo golden
rule 4). Search it with the `pdf-extract` skill rather than reading it into
context — it is ~570k characters:

```bash
python3 .claude/skills/pdf-extract/pdfx.py grep \
  AntHocNet/library/2007-ducatelle-thesis.pdf 'unloaded' -C 3
```

Glyph caveat: the thesis renders the constant as `thop` (no underscore) and
keeps ligatures (`ﬁxed`, `diﬀerent`), so search prose fragments ("unloaded",
"we kept") rather than typeset symbols.

## Status of the questions that were waiting on it

| Ticket | Question | Status |
|---|---|---|
| #88 | Numeric `T_hop` | ✅ **Answered and shipped.** `t_hop = 0.003 s` (§ "we kept thop on 0.003 sec"). The repo's provisional 50 ms was **16.7× too large**; `Config::hopTimeSec` now carries the thesis value. Issue closed 2026-07-25 |
| #58 | The full scenario/parameter table | ✅ **Mined and encoded.** `--scenario=thesis` in `ns3/examples/anthocnet-compare.cc` now carries §5.1.3's values verbatim (below). Issue stays open for its *remaining* half — documenting the calibration-vs-fidelity distinction and actually running the preset |
| #89 | The "average delay jitter" estimator | ✅ **Definition recovered** (§5.1.5, equation 5.1 — below). ⚠️ It does **not** match what the harness measures; the issue stays open on that mismatch, which is now a decision rather than a lookup |
| #70 | A2 `(Q_mac+1)·T̂_mac` details vs the thesis version | ⏳ still to check against the source |
| — | Pheromone diffusion / bootstrapping constants; any evaporation the thesis adds | ⏳ still to check (ADR-0007, ADR-0012 gates) |

## §5.1.3 — the base scenario (#58)

Quoted from the source, and the reason `--scenario=thesis` is no longer a
reconstruction:

| Parameter | Thesis value |
|---|---|
| Nodes | 100 |
| Area | 2400 × 800 m, open (no obstacles) |
| Mobility | Random waypoint; speed **0–10 m/s**; pause **30 s** |
| Duration | 900 s, **repeated 20 times** |
| Traffic | 20 CBR sessions, random source/destination |
| Session start | between 0 and 180 s, running to the end |
| Packet rate / size | **4 packets/s**, **64 bytes** (= 2048 bit/s per session) |
| Propagation | **Two-ray** ground reflection |
| PHY | IEEE 802.11 at **2 Mbit/s**; estimated radio range **250 m** |
| MAC | IEEE 802.11 DCF |
| Transport | UDP |

Note the harness default is the disk propagation model, not two-ray; a thesis
reproduction must pass `--propagation=tworay` explicitly. See
`docs/benchmarks/methodology.md`.

## §5.1.5 — the evaluation measures (#89)

The thesis derives its measures from the IETF MANET group's recommendations and
defines **average delay jitter** as *the variation in the time interval between
the arrivals of subsequent packets*, calculated as (equation 5.1):

```
jitter = Σ(i=2..n) |(tᵢ − tᵢ₋₁) − (tᵢ₋₁ − tᵢ₋₂)|
```

where `tᵢ` is the arrival time of the *i*-th packet and `n` the total number of
packets received by a destination during a session.

**Two consequences, both recorded on #89:**

1. The estimator is a function of **arrival times only** — it never references
   per-packet end-to-end delay. Our harness's jitter column comes from ns-3
   FlowMonitor's `jitterSum`, which is the RFC 3550 estimator: it subtracts the
   *sender's* packet spacing and applies exponential smoothing. These are
   different quantities, so "reproduces the paper's jitter result" is not
   currently a claim this repo can make.
2. Equation 5.1 as printed is a **sum**, while the surrounding text and every
   figure axis say *average* delay jitter — so a normalisation (presumably by
   the number of terms) is implied but not written. Anyone reproducing a thesis
   jitter figure has to pick one; say which.

(The printed index also starts the sum at `i = 2` while the summand needs
`tᵢ₋₂`, so the first valid term is really `i = 3`. Immaterial for large `n`,
worth knowing if you implement it literally.)
