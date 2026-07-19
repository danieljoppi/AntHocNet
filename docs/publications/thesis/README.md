# Thesis — pending

Target document: F. Ducatelle, *Adaptive Routing in Ad Hoc Wireless Multi-hop
Networks*, PhD thesis, Università della Svizzera Italiana / IDSIA, 2007. The
maintainer decision of record (#58/#70, 2026-07-19) designates it the
**primary source** for parameter verification; the 2004 PPSN paper
([`../papers/2004-ppsn-anthocnet.md`](../papers/2004-ppsn-anthocnet.md))
confirms formulas and several constants but leaves the items below open.

No PDF has been supplied yet (this environment cannot fetch academic PDFs —
proxy-blocked). When one is uploaded, digest it here in the same reference
form as the papers directory (no full-text reproduction; see
[`../README.md`](../README.md)).

## Open questions waiting on this document

| Ticket | Question |
|---|---|
| #88 | Numeric `T_hop` (repo provisional: 50 ms; sweep suggests few-ms is better) |
| #58 | The full parameter table (intervals, bounds, any values the 2004 paper leaves as "e.g.") |
| #89 | The exact "average delay jitter" estimator used in the thesis/journal evaluations |
| #70 | Confirm the A2 `(Q_mac+1)·T̂_mac` details match the thesis version (2004 paper already confirms the formula and α = γ = 0.7) |
| — | Pheromone diffusion / bootstrapping constants (repo ADR-0007 gates), any evaporation the thesis may add |
