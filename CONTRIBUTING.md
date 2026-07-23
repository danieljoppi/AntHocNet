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
inputs or carry out a new `RouteAction`. See `CONTEXT.md` for the deeper map.

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

## Commit / PR titles (Conventional Commits)

PRs are **squash-merged**, so the **PR title becomes the commit on `main`** and
drives release versioning. Titles must follow
[Conventional Commits](https://www.conventionalcommits.org) — CI enforces this:

```
<type>: <lowercase summary>      e.g.  feat: add the DSR baseline
                                       fix: stop the linkfail broadcast storm
```

Types: `feat` `fix` `docs` `style` `refactor` `perf` `test` `build` `ci`
`chore` `revert`. A `feat:` bumps the minor, `fix:` the patch; a
`BREAKING CHANGE:` footer (or a `!` after the type) bumps the minor while
pre-1.0.

Releases are cut by running the **Release** workflow (manual dispatch):
[Commitizen](https://commitizen-tools.github.io/commitizen/) computes the next
version from the commit history, updates `VERSION` / `CITATION.cff` / the CMake
version + `CHANGELOG.md`, tags it, and publishes the install bundle. Don't bump
the version by hand. (The `major_version_zero` gate in `.cz.toml` was flipped to
`false` at v1.0.0, so from 1.0 on a breaking `feat!`/`fix!` bumps the **major**.)

### Post-release: Zenodo DOI (manual — the release's second step)

The Release workflow does **not** set the DOI. With the repo linked to
[Zenodo](https://zenodo.org), Zenodo archives each published GitHub release
**asynchronously** and mints a new DOI a few minutes *after* publish. That value
must then be pasted, by hand, into two places:

1. the **README DOI badge** (top of `README.md`), and
2. the **`doi:`** field in `CITATION.cff`.

So a release is two steps: **(1)** run the Release workflow (automated), then
**(2)** once Zenodo has archived the tag, update the DOI in those two files via a
small `docs:` PR. Keep the two in sync — they have drifted apart before.

**Prefer the concept DOI.** Zenodo issues a per-version DOI *and* a stable
**concept DOI** ("all versions", which auto-resolves to the latest release).
Point the badge and `CITATION.cff` at the **concept DOI** so step 2 becomes a
one-time setup instead of a per-release chore.

**Note for AI agents:** you **cannot** do step 2 from the sandbox — `zenodo.org`
is blocked (the agent proxy returns 403), and the new DOI does not exist until
after publish anyway. Ask the maintainer for the DOI (concept preferred) and
open the `docs:` PR with the value they give you. **Never invent a DOI.**

## Pull requests

- Branch from `main`; keep PRs focused.
- Make sure CI is green. New tunables get NS-2 TCL binds and NS-3 `TypeId`
  attributes; update `CONTEXT.md` / `docs/porting-notes.md` if behaviour or the
  wire format changed.
- Picking up work? The backlog lives in GitHub issues (each ticket carries
  evidence, a fix sketch, and acceptance criteria).

## Reporting issues

Bugs and parser/security concerns: see [`SECURITY.md`](SECURITY.md). For
behaviour questions, open a GitHub issue with the scenario and observed output
(the `--diag` flag on `anthocnet-compare` and the trace sources help).

By contributing you agree your work is licensed under the repository's
[LICENSE](LICENSE) (GPL-2.0), and to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md).
