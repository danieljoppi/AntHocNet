# ADR-0026: Baselines are family-native

- **Status:** Accepted (maintainer decision, 2026-10-18)
- **Date:** 2026-10-18
- **Complements:** [ADR-0019](0019-network-families-change-the-evaluation-not-the-protocol.md).
  That ADR keeps *AntHocNet* identical across families. This one decides
  what it is compared *against* in each.

## Context

Every family in the corpus grew its baselines by copying the MANET set. AODV,
OLSR and DSDV run on the MANET grid, where they belong. They also run on the
static mesh, the FANET cells, the VANET street grid and the satellite cells,
where nobody proposes them. AOMDV followed them into FANET and VANET.

That makes comparisons that look like results but answer the wrong question:

- **Satellite.** [satellite-routing-prior-art.md §2.2](../satellite-routing-prior-art.md)
  already says it: "AODV / OLSR / DSDV are not satellite protocols. Nobody
  proposes them for a constellation." Beating them on a LEO shell is a
  strawman. The comparator the field actually proposes, predictability-aware
  link state (OPSPF), is missing.
- **Cost without information.** walker16's OLSR control took 5 h 54 min of
  CI for 20 seeds in v2.2.0. In v2.3.0 it exceeded the 6 h job limit twice,
  to reproduce a row no reader of a satellite paper would ask for.
- **Misleading rankings.** "AntHocNet beats AODV in every family" reads as a
  cross-family claim. In the families where AODV is a migrant, it only says
  that AntHocNet beats a protocol no one would deploy there.

## Decision

**Each family is compared against the protocols designed for that family, or
standard as baselines in its own literature. A MANET protocol is not carried
into another family by default.**

Every family keeps two references that are not migrants:

- **the oracle**, its upper bound (exact on the ISL torus and the static mesh,
  approximate on fading channels, as each page states);
- **its native comparators**, from the table below.

| family | keep (native, or the family's own standard baseline) | add | retire from the next campaign |
|---|---|---|---|
| MANET grid | AODV, OLSR, DSDV, AOMDV (the family these protocols were built for) | — | — |
| static Wi-Fi mesh | OLSR (community meshes) | IEEE 802.11s HWMP ([#708](https://github.com/danieljoppi/AntHocNet/issues/708)) | AODV, DSDV |
| FANET | AODV, OLSR (the FANET literature's standard baselines) | a 3-D geographic arm ([#710](https://github.com/danieljoppi/AntHocNet/issues/710)) | DSDV, AOMDV |
| VANET | GPSR (position-based), AODV (the VANET literature's standard reactive baseline) | a junction-aware geographic arm, GPCR-style ([#709](https://github.com/danieljoppi/AntHocNet/issues/709)) | OLSR, DSDV, AOMDV |
| satellite ISL grid | the oracle (precomputed shortest path, the snapshot-routing family at its best case) | OPSPF-style predictable link state ([#707](https://github.com/danieljoppi/AntHocNet/issues/707)) | AODV, OLSR |
| LEO shells | geo-greedy (idealised position-based), oracle, oracle-delay (Hypatia-style) | OPSPF-style predictable link state ([#707](https://github.com/danieljoppi/AntHocNet/issues/707)) | AODV, OLSR (OLSR retired already from v2.3.0) |

"The family's own standard baseline" is a test, not a loophole. A protocol
stays only where the family's survey literature uses it as a baseline. AODV
on VANET and FANET passes; AODV on a constellation does not.

## Consequences

- **Published numbers stay.** Every migrant row already published remains, as
  the dated record of its campaign. The rule applies from the next campaign
  plan (v2.4.0's control). Pages say "retired" next to a migrant row; they do
  not delete it.
- **The cross-family view changes.** `families-vs-aodv` compares against a
  protocol that is no longer in every family. It is replaced by AntHocNet's
  gap to each family's oracle, plus AntHocNet against each family's best
  native baseline ([#711](https://github.com/danieljoppi/AntHocNet/issues/711)).
- **New comparators are real work.** HWMP is stock ns-3 (`mesh` module). The
  others are written in `ns3/baselines/`, beside GPSR, AOMDV and the oracle,
  each with an anchor and a preflight rule, and each must route
  ([#439](https://github.com/danieljoppi/AntHocNet/issues/439)).
- **Harness support for migrant protocols stays.** `--protocols=olsr` still
  works on every harness. A reader may run any protocol anywhere; the
  published comparison is just not built on it.
- **ADR-0019 is unchanged.** AntHocNet is still one binary with one set of
  defaults in every family. The comparators are what differ, never the
  protocol under test.

## Alternatives considered

- **Keep the MANET set everywhere, as a common yardstick.** Rejected: the
  yardstick is the oracle, which every family has. A common migrant only
  measures the distance to a protocol the family does not use.
- **Keep AODV alone as a cross-family sanity row.** Rejected for the satellite
  families: there, geo-greedy and the oracles already bound the naive and the
  ideal case. AODV stays where its family's literature uses it (MANET, FANET,
  VANET).
- **Drop the migrant rows from the published pages now.** Rejected: they were
  measured and published under the rules of their campaign. Rewriting them
  would erase the record; marking them retired keeps it honest.
