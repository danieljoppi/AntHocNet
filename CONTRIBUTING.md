# Contributing to AntHocNet

Thanks for your interest. This is a research/educational implementation of the
AntHocNet MANET routing protocol with a simulator-agnostic core and thin NS-2 /
NS-3 adapters. Please read this before opening a PR.

## Architecture invariant (do not break)

```
core/   simulator-agnostic algorithm. No NS-2/NS-3 headers. Pure: returns
        RouteDecisions, performs no I/O. Time & randomness come via ports
        (IClock, IRng). THIS is where protocol logic lives.
ns2/    thin Agent adapter + source patch. Translates header <-> AntMessage,
        executes RouteDecisions, owns timers + link-failure callback.
ns3/    native Ipv4RoutingProtocol module. Same responsibilities as ns2.
```

**If a change affects routing decisions, it belongs in `core/`** and must be
covered by a `core/tests/` unit test. Adapters change only to feed the core new
inputs or carry out a new `RouteAction`. See `CONTEXT.md` and
[`docs/improvements/README.md`](docs/improvements/README.md) for the deeper map.

## Building & testing

```bash
# core library + unit tests (fast, no simulator needed)
make test

# NS-2 source patch self-test
bash ns2/patch/selftest.sh

# NS-3 module (needs an ns-3 tree)
make install-ns3 NS3DIR=/path/to/ns-3-dev
cd /path/to/ns-3-dev && ./ns3 configure --enable-examples --enable-tests && ./ns3 build
./test.py -s anthocnet
```

`make test` must stay green, and any new behaviour needs a test. CI runs the
core tests (incl. ASan/UBSan), the codec fuzzer, the NS-2 patch + compile + e2e
delivery smoke, and the NS-3 build/test matrix across ns-3.36–3.48.

## Code style

- **C++14.** Match the surrounding code: 4-space indent, `lowerCamelCase`
  members with a trailing `_`, `namespace anthocnet::core`. An `.editorconfig`
  encodes the whitespace rules.
- Comment **non-obvious intent**, not the obvious; don't add narrating comments.
- Prefer extending `Config` over new magic constants.
- **Python tooling** (`ns3/tools/*.py`) is linted with [ruff](https://docs.astral.sh/ruff/);
  run `ruff check ns3/tools` before pushing (CI enforces it).

## Wire format

Any new `AntMessage` field must be added to **all** of: the struct
(`core/include/anthocnet/core/ant_message.h`), the codec
(`core/src/ant_message_codec.cpp`), both adapter headers, and
`core/tests/test_codec.cpp` — and the round-trip test must still pass. Bump the
wire-version byte per [`docs/wire-format.md`](docs/wire-format.md) (ADR-0006).

## Pull requests

- Branch from `main`; keep PRs focused.
- Make sure CI is green. New tunables get NS-2 TCL binds and NS-3 `TypeId`
  attributes; update `CONTEXT.md` / `docs/porting-notes.md` if behaviour or the
  wire format changed.
- Picking up work? The backlog lives in GitHub issues and
  [`docs/improvements/`](docs/improvements/) (each numbered spec is a
  self-contained, implementable item with acceptance criteria).

## Reporting issues

Bugs and parser/security concerns: see [`SECURITY.md`](SECURITY.md). For
behaviour questions, open a GitHub issue with the scenario and observed output
(the `--diag` flag on `anthocnet-compare` and the trace sources help).

By contributing you agree your work is licensed under the repository's
[LICENSE](LICENSE) (GPL-2.0), and to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md).
