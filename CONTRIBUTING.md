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

#### DOI record

Because the badge and `CITATION.cff` intentionally carry the **concept** DOI,
the per-version DOIs are not recorded anywhere else — and those are what you
cite when referencing a *specific* version rather than "the software". This
table is that record.

| Target | DOI | Resolves to |
|---|---|---|
| **Concept ("all versions")** | `10.5281/zenodo.20981979` | always the latest release — this is the value in the README badge and `CITATION.cff` |
| v1.0.0 | `10.5281/zenodo.21502372` | [record 21502372](https://zenodo.org/records/21502372) |
| v1.1.0 | `10.5281/zenodo.21583731` | [record 21583731](https://zenodo.org/records/21583731) |

**Adding a row is the whole per-release chore.** Append the new version DOI
here; do **not** touch the README badge or `CITATION.cff`, which already point
at the concept DOI and therefore need no update. Pinning either of them to a
version DOI is the regression [#116](https://github.com/danieljoppi/AntHocNet/pull/116)
fixed — the badge had been left on an earlier release's version DOI and had
silently gone stale.

Cite the **concept** DOI for the software in general, and a **version** DOI when
reproducing a specific result — benchmark numbers in `docs/` are tied to a
release, so a paper reproducing them should cite that release's DOI.

## Supply-chain & trust signals

What a stranger can check about this repository without reading its code, and —
where a signal needs a human — exactly what the maintainer has to do. Landed in
[#337](https://github.com/danieljoppi/AntHocNet/issues/337), the last ticket of
the packaging epic [#328](https://github.com/danieljoppi/AntHocNet/issues/328).

### Automated: OpenSSF Scorecard

[`.github/workflows/scorecard.yml`](.github/workflows/scorecard.yml) runs
[OpenSSF Scorecard](https://scorecard.dev) weekly (Mondays 06:23 UTC), on every
merge to `main`, and on manual dispatch. It publishes three ways: the README
badge, GitHub's code-scanning dashboard (SARIF), and the public OpenSSF API.

It is a **report, not a gate** — a low check does not fail a build; it becomes
an issue (ADR-0013). The heaviest deductions (`Pinned-Dependencies`,
`Dangerous-Workflow`, `Token-Permissions`) were already paid down by
[#338](https://github.com/danieljoppi/AntHocNet/pull/338), which SHA-pinned
every action and added Dependabot, so the score reports a posture that already
exists.

**The badge is blank until the first run publishes.** After merging, run the
`Scorecard` workflow once by hand (Actions → Scorecard → *Run workflow*).

Two checks this repo will not score full marks on, by design, so nobody chases
them: `Signed-Releases` (see *Provenance* below) and `Fuzzing` (Scorecard only
recognises OSS-Fuzz / ClusterFuzzLite integrations, not the in-repo libFuzzer
job — see *OSS-Fuzz* below).

### Release integrity: SHA-256 checksums

Every release publishes `anthocnet-<version>.zip.sha256` alongside the bundle,
and the same digest is inlined in the release body — twice on purpose, so a
reader can verify a download against the release *page* without downloading and
trusting a second file. Verification:

```bash
sha256sum -c anthocnet-<version>.zip.sha256   # both files in one directory
```

This is generated by the `Checksum the bundle` step in
[`.github/workflows/release.yml`](.github/workflows/release.yml); there is
nothing for the maintainer to do per release.

### Provenance / build attestation — **not adopted (2026-08), revisit**

Signed [SLSA build provenance](https://slsa.dev) (`gh attestation verify`) was
evaluated for the install bundle and **deliberately not adopted yet**. The
reasoning, so the next person does not re-derive it:

1. **The action to use is mid-migration.** `actions/attest-build-provenance` is,
   as of v4, "simply a wrapper on top of `actions/attest`", and its own README
   says new implementations should use `actions/attest` instead. Adopting the
   wrapper today means rewriting it soon.
2. **`actions/attest` documents a third permission, `artifact-metadata: write`,
   that could not be validated from a sandbox.** An unrecognised key in a
   `permissions:` block makes the *whole workflow file* invalid, and
   `release.yml` is the worst place in the repo to discover that: it is manual,
   runs a few times a year, and **pushes the version bump and the tag before it
   assembles and publishes the bundle** — a workflow that dies after the tag
   push leaves a tagged-but-unreleased version to clean up by hand.
3. **It would not move the Scorecard needle on its own.** `Signed-Releases`
   inspects *release assets* for `*.sig` / `*.asc` / `*.sigstore.json` /
   `*.intoto.jsonl`; an attestation stored in GitHub's attestations API is not
   an asset, so crediting it also requires attaching the bundle file — and the
   check scores over the **last five releases**, so the score would ramp in
   over a year of releases rather than jump.
4. **The audience is thin.** The artefact is a source zip that researchers
   unzip onto an ns-3 tree; `gh attestation verify` is not in that workflow.
   The checksum covers the realistic failure (a truncated or mirrored
   download); attestation covers a forged-release threat that is real but
   remote for this project.

None of that is an argument that provenance is worthless — it is the one signal
that binds an artefact to *this* workflow's identity, which a self-published
checksum cannot. **Revisit condition:** adopt `actions/attest` once its
permission set has been exercised on a low-stakes workflow first (e.g. attesting
a benchmark artefact in `benchmarks.yml`, where a broken run costs nothing),
then move the proven block into `release.yml` and attach the bundle as
`anthocnet-<version>.intoto.jsonl` so `Signed-Releases` counts it. Add the
`gh attestation verify anthocnet-<version>.zip --repo danieljoppi/AntHocNet`
line to the release body in the same change.

### OSS-Fuzz — **not applying (2026-08)**

`core/tests/fuzz_codec.cpp` is already libFuzzer-shaped and CI fuzzes the
untrusted decode path for 60 s per run (`codec-fuzz` in `ci.yml`), so an
OSS-Fuzz integration would be nearly free to write. The blocker is not
technical: OSS-Fuzz's [acceptance
criterion](https://google.github.io/oss-fuzz/getting-started/accepting-new-projects/)
is that a project "must have a significant user base and/or be critical to the
global IT infrastructure", and a research MANET routing implementation that is
installed onto a simulator tree — never onto a production network — plainly
meets neither. Applying would consume reviewer time on a predictable rejection.

The proportionate answer if the 60 s CI budget ever proves too small is
[ClusterFuzzLite](https://google.github.io/clusterfuzzlite/): the same libFuzzer
target, run in this repo's own CI with a persisted corpus and longer batch runs,
no acceptance gate — and it is one of the two integrations Scorecard's `Fuzzing`
check recognises. Reopen the question if the protocol ever ships outside
simulation (the security profile of
[ADR-0020](docs/adr/0020-security-is-a-default-off-profile.md) would be the
trigger), since that is what would change the answer.

### OpenSSF Best Practices badge — **maintainer action required**

The repo very likely already qualifies for the *passing* level (CI on every PR,
a unit-test suite, sanitizer + fuzz jobs, `SECURITY.md`, a documented release
process, an OSI licence, a public issue tracker), but the badge is a
questionnaire tied to a **personal account** — an agent cannot obtain it, and
the badge URL embeds a project ID that does not exist until the project is
registered. **Do not invent one.** Steps:

1. Sign in at <https://www.bestpractices.dev/> with the GitHub account that owns
   the repository.
2. *Projects → Add a project*, entering
   `https://github.com/danieljoppi/AntHocNet` as the repository URL. The form
   pre-fills much of the metadata from GitHub.
3. Answer the criteria. The evidence links to reach *passing* are all in-tree:
   `README.md` (description, install), `CONTRIBUTING.md` (contribution process,
   this file), `SECURITY.md` (vulnerability reporting), `LICENSE` (GPL-2.0-only),
   `.github/workflows/ci.yml` (automated build + test on every change),
   `CHANGELOG.md` (release notes), and the release checksums documented above.
4. Note the numeric **project ID** shown in the project's URL
   (`https://www.bestpractices.dev/projects/<ID>`).
5. Add this line to the badge block at the top of `README.md`, directly after
   the OpenSSF Scorecard badge, substituting the real `<ID>`:

   ```markdown
   [![OpenSSF Best Practices](https://www.bestpractices.dev/projects/<ID>/badge)](https://www.bestpractices.dev/projects/<ID>)
   ```

## Pull requests

- Branch from `main`; keep PRs focused.
- Make sure CI is green. New tunables get NS-2 TCL binds and NS-3 `TypeId`
  attributes; update `CONTEXT.md` / `docs/porting-notes.md` if behaviour or the
  wire format changed.
- Picking up work? The backlog lives in GitHub issues (each ticket carries
  evidence, a fix sketch, and acceptance criteria).
- **A change to protocol behaviour needs an A/B benchmark verdict**, not a
  plausibility argument — the sweep → A/B → noise-verdict loop is
  [`docs/configuration.md` §5](docs/configuration.md#5-how-to-calibrate-a-parameter).
  Record the verdict and run IDs on the relevant issue.
- **Bugs and findings become GitHub issues** — including partial findings and
  dead ends. The discipline (and the label taxonomy: one type label, area
  label(s), a priority) is
  [ADR-0013](docs/adr/0013-track-bugs-and-findings-as-issues.md); it is what
  keeps investigations recoverable across sessions.

## Reporting issues

Bugs and parser/security concerns: see [`SECURITY.md`](SECURITY.md). For
behaviour questions, open a GitHub issue with the scenario and observed output
(the `--diag` flag on `anthocnet-compare` and the trace sources help).

By contributing you agree your work is licensed under the repository's
[LICENSE](LICENSE) (GPL-2.0), and to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md).
