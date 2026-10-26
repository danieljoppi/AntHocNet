# CLAUDE.md

**Project specifics live in [`AGENTS.md`](AGENTS.md)** (golden rules,
build/verify, where-to-look), imported below so it survives context
compaction. [`CONTEXT.md`](CONTEXT.md) is orientation and history (domain
background, current state, glossary, open questions): read the section the task
needs, not the whole file. The guidelines further down are general behavioural
defaults layered on top.

@AGENTS.md

**Skills** (`.claude/skills/`): `protocol-review` (golden-rule checks on a diff),
`benchmark-results` (dispatch → fetch → validate → compare), `learn-site`
(WASM parity, browser smoke, README figures). Skills are procedures only —
scripts that anything shipped depends on live in `tools/` (ADR-0014), and
nothing under `.claude/` reaches a release package (#604).

**Handoffs are always a ticket.** When a session ends with work in flight, or a
handoff is asked for, open a GitHub issue from the *Handoff* template (label
`handoff`). Never write a handoff file in the repo. Start a new session from
the newest open `handoff` issue, and close it when the work it hands off is
done ([ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md) item 5).

## Working defaults

Condensed from [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills).

- **Assumptions:** state the ones that matter. Ask only when the choice
  belongs to the maintainer: a default, a published number, a cell, the scope.
  Otherwise pick the sensible option, say which, and keep going. Long
  unattended runs, like campaigns, depend on that.
- **Simplicity:** the least code that solves the task. No speculative
  features, configurability or abstractions for one use.
- **Surgical diffs:** every changed line traces to the request. Match the
  surrounding style. Mention unrelated dead code rather than deleting it, and
  remove only the orphans your own change created.
- **Verifiable goals:** a bug gets a reproducing test first; a refactor passes
  before and after. Finish when the check passes, not when the code looks right.

## Response style — caveman (token economy)

<!-- Vendored from https://github.com/JuliusBrussee/caveman — adapted for this repo.
     "why use many token when few do trick." -->

Answer in tight, low-filler prose: drop hedging, pleasantries, and preamble; keep
the substance. Fewer output tokens on every reply, same information.

**Carve-out (this repo's record stays full).** Keep byte-for-byte exact — code,
commands, file paths, error text, benchmark numbers. And keep the *durable
record* detailed, never terse: commit messages, PR bodies, ADRs, `docs/`, and
issue / finding threads. This project's cross-session traceability
([ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md)) depends on those
being complete — the AC_BE_NQOS / A2 investigation was only recoverable because
the issue threads were thorough. Caveman the chat, not the record.
