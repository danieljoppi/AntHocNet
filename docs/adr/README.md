# Architecture Decision Records

The "why" behind the repository's structure and the protocol's deliberate
deviations, one decision per file ([ADR-0001](0001-record-architecture-decisions.md)
explains the practice). All ADRs below are **Accepted**; where one has been
partly superseded or updated, the note says so — the ADR itself carries the
detail.

| ADR | Decision |
|---|---|
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions as ADRs in `docs/adr/`. |
| [0002](0002-one-core-two-adapters.md) | One simulator-agnostic algorithm core; thin per-simulator adapters (NS-2, NS-3). The repo's load-bearing invariant. |
| [0003](0003-pure-core-returns-route-decisions.md) | The core is pure: it returns `RouteDecision`s and performs no I/O; adapters execute them. |
| [0004](0004-pod-ant-messages-and-codec.md) | Ants are POD value types (`AntMessage`) with a single canonical wire codec — no header-resident pointers. |
| [0005](0005-ns2-idempotent-anchor-patch.md) | NS-2 installation is an idempotent, anchor-based source patch — never a forked simulator tree or line-numbered diff. |
| [0006](0006-on-wire-protocol-version.md) | A 1-byte on-wire protocol version (`kWireVersion`), no negotiation — golden rule 4's foundation. |
| [0007](0007-proactive-diffusion-gated.md) | Keep virtual pheromone / proactive diffusion, but config-gate it so the ablation is runnable. *Partly superseded on one point by ADR-0016.* |
| [0008](0008-neighbour-liveness-two-detectors.md) | Neighbour liveness via two detectors (hello timeout + MAC transmit-failure fast path); `INeighborProvider` is advisory. |
| [0009](0009-backward-ants-carry-path-not-state.md) | The wire carries path observations, not computed state — backward ants carry the path, nodes compute pheromone locally. |
| [0010](0010-data-forwarding-prevhop-excluded-stochastic.md) | Data forwarding is prev-hop-excluded stochastic; per-flow stickiness is gated and default off. |
| [0011](0011-nodeaddress-is-ip-broadcast-is-an-action.md) | `NodeAddress` is the node's IP, treated opaquely; broadcast is a `RouteAction`, never an address. |
| [0012](0012-evaporation-is-a-secondary-safety-net.md) | Evaporation is a secondary, time-proportional safety net — the sources have no evaporation term. *Updated 2026-08-01 (#262): virtual aging moved onto the same tick/factor as regular.* |
| [0013](0013-track-bugs-and-findings-as-issues.md) | Track every bug and finding as a GitHub issue (label taxonomy, evidence, acceptance criteria) — the cross-session traceability discipline. |
| [0014](0014-agent-skills-are-script-first.md) | Agent skills are script-first: analysis and validation run in scripts, raw data stays out of LLM context. |
| [0015](0015-satellite-substrate-lives-in-the-image.md) | One AntHocNet build; the satellite substrate lives in the container image — no separate satellite binary. |
| [0016](0016-directed-reactive-discovery-is-gated-and-off.md) | Reactive ants may follow the diffusion gradient (directed discovery), gated and default **off**. |
| [0017](0017-linkstate-is-per-next-hop-and-regime-selected.md) | The congestion signal (`ILinkState`) is per-next-hop; its implementation is selected by what the build instantiates (wifi vs point-to-point/ISL). |
| [0018](0018-emission-gate-compares-per-link.md) | The proactive emission gate compares virtual and regular pheromone per link, not best-vs-best — cancels the h/(h−1) hop ceiling. |
| [0019](0019-network-families-change-the-evaluation-not-the-protocol.md) | A network family (FANET, VANET, …) is a scenario concern: mobility models, presets, preflight rules, anchors and metrics — never family-specific protocol defaults. |
| [0020](0020-security-is-a-default-off-profile.md) | Security ships inside the same implementation behind attributes, default **off**, with the default path provably byte-identical — no fork, no second binary. |

## Adding an ADR

Number sequentially (`NNNN-short-slug.md`), follow the existing
Context / Decision / Alternatives / Consequences shape, and add a row here.
When a change alters a documented decision, update the ADR (or supersede it
with a new one) in the same PR — see [`AGENTS.md`](../../AGENTS.md)
"Conventions".
