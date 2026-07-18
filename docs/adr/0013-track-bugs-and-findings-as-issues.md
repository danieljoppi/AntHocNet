# ADR-0013: Track every bug and finding as a GitHub issue

- **Status:** Accepted
- **Date:** 2026-06-28

## Context

This repository is developed by a mix of human and LLM contributors, often across
many short, **stateless** sessions (a new AI chat starts with no memory of the
last). [`AGENTS.md`](../../AGENTS.md) already points contributors to "pick up open
work" from GitHub issues, but it does not say how findings should be *recorded* as
work proceeds.

The #19 work made the cost of not having a rule concrete:

- A change was implemented, merged (#43), and only **afterwards** found — via the
  paper benchmark — to have **regressed** the protocol in its design regime (PDR
  22.7→19.7%, NRL 167.9→274.2). See
  [#19 root-cause comment](https://github.com/danieljoppi/AntHocNet/issues/19#issuecomment-4826657475).
- The investigation that produced the fix (#44) surfaced **several distinct,
  separable follow-ups** (a latent unbounded proactive broadcast; NS-2 data-reinject
  parity; two noisy benchmark cells) that had nothing to do with finishing #19.

If those findings live only in a chat transcript, they vanish when the session
ends, and the next contributor re-discovers the same bug or loses the benchmark
evidence that justified a decision.

## Decision

**Every bug, regression, or non-trivial finding becomes durable on GitHub before
the session ends** — as a new issue, or as a comment on the relevant existing one.

1. **New, separable problem → new issue.** Do not smuggle unrelated fixes into an
   in-flight PR or let them expand its scope; open a focused issue and cross-link
   it. (Examples from #19: #45, #46, #47.)
2. **Finding that extends a known problem → comment on that issue.** The issue is
   the **durable thread of record** for an investigation; append evidence as you
   go rather than keeping it in chat. (Examples: the root-cause, fix, and taxonomy
   comments on #19.)
3. **Each issue carries enough to act on without the chat:**
   - symptom + **evidence** (benchmark numbers, `--diag` lines, CI/job links);
   - root cause when known;
   - **code references** as `file:line`;
   - links to related issues / PRs / ADRs / benchmark runs.
4. **PRs reference the issue(s) they resolve**, and the squash-merge title is a
   Conventional Commit (see [`CONTRIBUTING.md`](../../CONTRIBUTING.md)). A merged PR
   is not the end of the record — post the post-merge outcome (e.g. benchmark
   result) back to the issue.
5. **Cross-session handoff** that spans several issues/PRs is captured under
   [`docs/handoffs/`](../handoffs/) so a fresh AI chat (or human) can bootstrap
   from one document with all the links, then drop into the issues for detail.

This formalises, rather than replaces, the existing "pick up open work from
issues" guidance in `AGENTS.md`.

### Labelling convention

Every issue carries three kinds of labels so the backlog can be scanned and
delegated without opening each ticket (`.github/ISSUE_TEMPLATE/` presets the
type; the creator applies the rest — template dropdowns are informational, they
do not auto-apply labels):

1. **Type** (exactly one): `bug` (defect/regression/wrong result),
   `enhancement` (new mechanism/capability), `chore` (mechanical maintenance),
   `documentation`, `verification` (benchmark re-run / noise confirmation).
   Umbrella issues add `epic` alongside their type.
2. **Area** (one or more): `protocol` (core algorithm, `core/`), `adapter`
   (translation layer), `ns2`, `ns3`, `benchmark` (harness/workflows),
   `observability`, `packaging`.
3. **Recommended model** (`model:*`, one): which Claude model class should
   implement it, chosen by what failure costs, not code volume:
   - `model:haiku-4.5` — mechanical chores (reformat, packaging, config).
   - `model:sonnet-5` — well-specified plumbing, harness/tooling, docs.
   - `model:opus-4.8` — protocol semantics, root-cause investigation, and
     adapter work validated only by slow CI loops (a wrong first pass costs a
     full matrix run).
   - `model:fable-5` — architectural / greenfield work (e.g. a new simulator
     adapter).
4. **Priority** (`priority:P1`/`priority:P2`/`priority:P3`, exactly one on
   non-epic issues; epics carry none — they aggregate their children):
   - `priority:P1` — fix first: a regression, or a blocker that invalidates
     published/benchmark numbers.
   - `priority:P2` — gates publishing a result or enabling a gated feature
     (verification runs, congestion-signal work, benchmark realism).
   - `priority:P3` — valuable but not blocking: bigger bets, realism
     extensions, mechanical chores.

## Alternatives considered

- **Rely on chat history / commit messages only.** Chats are stateless across
  sessions and not searchable by the next contributor; commit messages describe a
  change, not an open problem. Rejected — this is exactly what bit #19.
- **One mega-issue per area.** Becomes an unreadable catch-all and can't be closed;
  loses the one-focused-change-per-PR mapping. Rejected in favour of focused,
  cross-linked issues.

## Consequences

- Findings and their evidence survive session boundaries and are discoverable.
- A new AI chat can be primed from an issue (+ a handoff doc) instead of
  re-deriving context.
- Slightly more issue/comment bookkeeping per session — the cost the #19
  regression showed is worth paying.
