---
name: protocol-review
description: Run AntHocNet's AGENTS.md golden-rule checks on the current diff (no NS headers in core/, wire-format changes bump kWireVersion, core logic changes carry a core test, documented decisions get a doc/ADR update). Use when reviewing or preparing any change to core/ or the adapters, to catch the invariants that are cheap to miss before pushing.
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
- **Rule 4 (WARN):** `ant_message.h` / `ant_message_codec` changed without a
  `kWireVersion` bump in the diff; reminds you to also update both adapter
  headers, `test_codec.cpp`, and `docs/wire-format.md`.
- **Rule 7 (WARN):** `core/` logic changed but no `core/tests/` file changed.
- **Docs (WARN):** a core/adapter change with no `docs/` touch — confirm no
  ADR needs updating.

Exit code is non-zero only on a FAIL. WARN means "look and confirm", not "blocked".

This is a checklist accelerator, **not** a replacement for reading the diff or
for `/code-review`. It does not judge correctness — pair it with the actual
review. Always still run `make test` before committing a core change.
