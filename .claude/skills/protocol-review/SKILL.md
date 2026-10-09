---
name: protocol-review
description: Run AntHocNet's AGENTS.md golden-rule checks on the current diff (no NS or emscripten headers in core/, wire-format changes bump kWireVersion, core logic changes carry a core test, new mechanisms ship off, web/ changes run parity, nothing shipped depends on .claude/, new docs pages are in the nav). Use when reviewing or preparing any change to core/ or the adapters, to catch the invariants that are cheap to miss before pushing.
---

# protocol-review

`check_invariants.sh` (in this skill dir) runs the mechanical half of a protocol
review in one call, so you spend tokens on judgement, not on rediscovering the
invariants with a dozen greps.

```bash
bash .claude/skills/protocol-review/check_invariants.sh [BASE]   # BASE defaults to origin/main
```

It reports PASS/WARN/FAIL for:

- **Rule 1 (FAIL):** any `core/src` or `core/include` file that `#include`s an
  `ns2/` or `ns3/` header — breaks the simulator-agnostic core. Hard stop.
- **Rule 1, browser (FAIL):** a `core/` file includes an `emscripten` header —
  the WASM glue belongs in `web/`.
- **Rule 4 (WARN):** `ant_message.h` / `ant_message_codec` changed without a
  `kWireVersion` bump in the diff; reminds you to also update the ns-3 header
  (`ns3/anthocnet/model/anthocnet-packet`), `test_codec.cpp`, and `docs/wire-format.md`.
- **Rule 7 (WARN):** `core/` logic changed but no `core/tests/` file changed.
- **Docs (WARN):** a core/adapter change with no `docs/` touch — confirm no
  ADR needs updating.
- **Rule 8 (WARN):** a new `bool enable… = true` in the diff — new mechanisms
  ship default-off and are A/B'd in every family first (ADR-0019/0020).
- **Rule 9 (WARN):** `web/src` or `web/include` changed — run
  `web/test/parity.sh` and the smoke (`learn-site` skill).
- **Rule 10 (FAIL):** a shipped file references a `.claude/skills/…` script —
  move the script to `tools/` (#604; CI's `tools/release/check-bundle.sh`
  catches it too).
- **Docs nav (WARN):** a new `docs/*.md` page that `mkdocs.yml` does not list —
  it would be unreachable on the site.

Exit code is non-zero only on a FAIL. WARN means "look and confirm", not "blocked".

This is a checklist accelerator, **not** a replacement for reading the diff or
for `/code-review`. It does not judge correctness — pair it with the actual
review. Always still run `make test` before committing a core change.
