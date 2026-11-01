# Contributing to AntHocNet

Thanks for your interest. This is a research/educational implementation of the
AntHocNet MANET routing protocol with a simulator-agnostic core and a thin NS-3
adapter (the NS-2 adapter was removed in v2.0.0; see `docs/ns2-support.md`).
Please read this before opening a PR.

## Architecture invariant (do not break)

```
core/   simulator-agnostic algorithm. No simulator headers. Pure: returns
        RouteDecisions, performs no I/O. Time & randomness come via ports
        (IClock, IRng). THIS is where protocol logic lives.
ns3/    native Ipv4RoutingProtocol module. Translates header <-> AntMessage,
        executes RouteDecisions, owns timers + the pending-packet queue.
web/    browser adapter: the same core compiled to WebAssembly (learn site).
```

**If a change affects routing decisions, it belongs in `core/`** and must be
covered by a `core/tests/` unit test. Adapters change only to feed the core new
inputs or carry out a new `RouteAction`. See `CONTEXT.md` for the deeper map.

## Building & testing

```bash
# core library + unit tests (fast, no simulator needed)
make test

# NS-3 module (needs an ns-3 tree)
make install-ns3 NS3DIR=/path/to/ns-3-dev
cd /path/to/ns-3-dev && ./ns3 configure --enable-examples --enable-tests && ./ns3 build
./test.py -s anthocnet
```

`make test` must stay green, and any new behaviour needs a test. CI runs the
core tests (incl. ASan/UBSan), the codec fuzzer, the native-vs-WASM parity
gate, and the NS-3 build/test on the ns-3 release ns-3 supports (older
releases, back to ns-3.36, on demand through the CI workflow's manual run).

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
(`core/src/ant_message_codec.cpp`), the ns-3 packet header
(`ns3/anthocnet/model/anthocnet-packet.*`; the browser adapter uses the core codec), and
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
the version by hand. Run it once with `mode: dryrun` first. That run bumps,
builds, attests and verifies on the runner, and pushes nothing. Then run it
with `mode: bump`. (The `major_version_zero` gate in `.cz.toml` was flipped to
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

**Note for AI agents:** the new DOI does not exist until Zenodo has archived the
tag, a few minutes after publish. Read it from Zenodo's public API — no token
needed. The versions endpoint must be addressed through a **version** record:
the concept ID `20981979` returns HTTP 404 there, as measured 2026-10-02. Any
version record lists every version of the concept, for example v0.1.1's:

```
curl -sL "https://zenodo.org/api/records/20981980/versions/latest"   # the newest version only
curl -s "https://zenodo.org/api/records/20981980/versions?size=25&page=2"   # or page through all
```

(`sort=version` is ignored, as measured 2026-10-26: hits come oldest first, so
with more than 25 versions the newest are on the last page.)

Each hit carries `metadata.version` (the tag) and `doi`. `size` above 25 is
rejected unauthenticated (HTTP 400). `zenodo.org` has been proxy-blocked from
the agent sandbox before (HTTP 403, until 2026-09); if it is, ask the
maintainer for the DOI instead. Either way, open the `docs:` PR only with a
value read from Zenodo or supplied by the maintainer. **Never invent a DOI.**

#### DOI record

Because the badge and `CITATION.cff` intentionally carry the **concept** DOI,
the per-version DOIs are not recorded anywhere else — and those are what you
cite when referencing a *specific* version rather than "the software". This
table is that record.

| Target | DOI | Resolves to |
|---|---|---|
| **Concept ("all versions")** | `10.5281/zenodo.20981979` | always the latest release — this is the value in the README badge and `CITATION.cff` |
| v0.1.1 | `10.5281/zenodo.20981980` | [record 20981980](https://zenodo.org/records/20981980) — the first archived release |
| v0.2.0 | `10.5281/zenodo.21007725` | [record 21007725](https://zenodo.org/records/21007725) |
| v0.3.0 | `10.5281/zenodo.21219572` | [record 21219572](https://zenodo.org/records/21219572) |
| v0.4.0 | `10.5281/zenodo.21435553` | [record 21435553](https://zenodo.org/records/21435553) |
| v0.5.0 | `10.5281/zenodo.21453208` | [record 21453208](https://zenodo.org/records/21453208) |
| v1.0.0 | `10.5281/zenodo.21502372` | [record 21502372](https://zenodo.org/records/21502372) |
| v1.1.0 | `10.5281/zenodo.21583731` | [record 21583731](https://zenodo.org/records/21583731) |
| v1.2.0 | `10.5281/zenodo.21762983` | [record 21762983](https://zenodo.org/records/21762983) — the last release in which NS-2 was actively supported (also cited in [`docs/ns2-support.md`](docs/ns2-support.md)) |
| v1.3.0 | `10.5281/zenodo.21795253` | [record 21795253](https://zenodo.org/records/21795253) — the provenance pin for the published benchmark corpus (also in the README and `CITATION.cff`) |
| v1.4.0 | `10.5281/zenodo.21863774` | [record 21863774](https://zenodo.org/records/21863774) |
| v1.5.0 | `10.5281/zenodo.21956001` | [record 21956001](https://zenodo.org/records/21956001) |
| v1.6.0 | `10.5281/zenodo.22970218` | [record 22970218](https://zenodo.org/records/22970218) |
| v1.7.0 | `10.5281/zenodo.23108019` | [record 23108019](https://zenodo.org/records/23108019) — the FANET + static-mesh family release |
| v1.8.0 | `10.5281/zenodo.23187497` | [record 23187497](https://zenodo.org/records/23187497) — the CBR-source fix-and-restatement roll-up ([#521](https://github.com/danieljoppi/AntHocNet/issues/521)) |
| v1.9.0 | `10.5281/zenodo.23223132` | [record 23223132](https://zenodo.org/records/23223132) — the VANET family release ([#301](https://github.com/danieljoppi/AntHocNet/issues/301)) |
| v2.0.0 | `10.5281/zenodo.23250180` | [record 23250180](https://zenodo.org/records/23250180) — the moving-constellation result ([#297](https://github.com/danieljoppi/AntHocNet/issues/297)), the learn site, and the NS-2 removal ([#307](https://github.com/danieljoppi/AntHocNet/issues/307)) |
| v2.1.0 | `10.5281/zenodo.23265537` | [record 23265537](https://zenodo.org/records/23265537) — the restructure: the whole site is the game ([#626](https://github.com/danieljoppi/AntHocNet/issues/626)), the new `ns3/` layout ([#608](https://github.com/danieljoppi/AntHocNet/issues/608)) and the install path |
| v2.2.0 | `10.5281/zenodo.23423439` | [record 23423439](https://zenodo.org/records/23423439) — the v2.2.0 re-baseline campaign ([#565](https://github.com/danieljoppi/AntHocNet/issues/565): four knobs A/B'd in every family, no default moves), the learn-site campaign chapters 1–2 and the Workshop, the infrastructure track |
| v2.3.0 | `10.5281/zenodo.23456208` | [record 23456208](https://zenodo.org/records/23456208) — the v2.3.0 mechanism campaign (six regime-gated mechanisms in every family; quiet mode moves on by default, [#571](https://github.com/danieljoppi/AntHocNet/issues/571)), the restated v2.3.0 corpus, learn-site chapters 3–5, upgrades and the ns-3 replay, signed release artifacts and the bake recipe |
| v2.4.0 | `10.5281/zenodo.23653720` | [record 23653720](https://zenodo.org/records/23653720) — family-native baselines (ADR-0026: HWMP, GPCR, GPSR-3D, OPSPF), the disaster and SAGIN families, the 50–500-node scale sweep with its known limitation ([#740](https://github.com/danieljoppi/AntHocNet/issues/740)), learn-site chapters 6–8 |
| v2.5.0 | `10.5281/zenodo.23748858` | [record 23748858](https://zenodo.org/records/23748858) — the adaptive-routing comparators ([#563](https://github.com/danieljoppi/AntHocNet/issues/563): ARA passes its anchor and is compared on the grid; Termite and Q-routing ship as infeasibility verdicts), the #740 scale diagnosis (the adapter's retry flood; gated fix in [#760](https://github.com/danieljoppi/AntHocNet/issues/760)), campaigns on `benchmark-cell.yml` only ([#746](https://github.com/danieljoppi/AntHocNet/issues/746)) |
| v2.6.0 | `10.5281/zenodo.23777868` | [record 23777868](https://zenodo.org/records/23777868) — the protocol-agnostic comparison harness ([#764](https://github.com/danieljoppi/AntHocNet/issues/764), [ADR-0027](docs/adr/0027-the-comparison-harness-is-protocol-agnostic.md)): the `routing-bench` module and `routing-compare` program on stock ns-3, self-registering arms, a byte-identical control on every committed MANET-family cell ([#769](https://github.com/danieljoppi/AntHocNet/issues/769)), and the per-packet drop book for re-routing arms ([#761](https://github.com/danieljoppi/AntHocNet/issues/761)) |

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

Checks this repo will not score full marks on, by design, so nobody chases
them: `Code-Review` and `Contributors` (a solo project, #789). `Signed-Releases`
ramps up one release at a time over a five-release window (see *Provenance*
below).

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

### Provenance, signatures and SBOM — **adopted (2026-10, #614)**

Since v2.3.0, every release ships with three things. The verification
commands are in [SECURITY.md](SECURITY.md#verifying-a-release).
- **Build provenance.** Signed SLSA provenance for the install bundle and
  the module tarball, made by `actions/attest`. Its Sigstore bundle is also
  attached as `anthocnet-<version>.provenance.sigstore.json`. From v2.7.0
  the bundle's signed in-toto envelope is also attached as
  `anthocnet-<version>.intoto.jsonl`: the name Scorecard's
  `Signed-Releases` looks for to count a release as having provenance
  (#788).
- **An SBOM.** An SPDX file of the bundle (`anthocnet-<version>.spdx.json`),
  attested against the zip.
- **Image signatures.** cosign keyless signatures on the GHCR images, plus
  provenance for `anthocnet-ns3`.

In 2026-08 this was evaluated and **not adopted**. Here is each objection
from then, and how it is answered now, so the decision is not re-derived:

1. *"The action is mid-migration; the wrapper is about to be replaced."*
   The workflows use `actions/attest` itself (v4.2.2), not the
   `attest-build-provenance` wrapper. One action covers provenance and
   SBOM.
2. *"`actions/attest` documents a third permission, `artifact-metadata:
   write`, that could not be validated; an unknown key would invalidate
   `release.yml`, which pushes the tag before it publishes."*
   - That permission is only for registry *storage records*. Those need an
     organization-owned repository, and this one is user-owned. So the
     workflows never declare it, and the image attestation sets
     `create-storage-record: false`.
   - `release.yml` now pushes the bump commit and the tag **after** the
     bundle is built, attested and verified. A failure in the new steps
     leaves nothing to clean up by hand.
   - `release.yml` also has a `dryrun` mode: bump, build, attest and verify
     on the runner, then stop. Run it once before a real release. It is the
     "exercise it somewhere harmless first" step the old revisit condition
     asked for.
3. *"It would not count for Scorecard's `Signed-Releases`: the attestation
   is not a release asset."* The Sigstore bundle is now attached as a
   `*.sigstore.json` asset, which the check recognises. The score ramps in
   over the next five releases, as predicted.
4. *"The audience is thin: researchers unzip a source tree."* Still true,
   and the checksum stays the first line of defence. Provenance is the one
   signal that binds a download to *this* workflow's identity, and it now
   costs nothing per release.

Each check runs inside the workflow that makes the signature, before
anything is published:
- `gh attestation verify` on both downloads and on the SBOM;
- `cosign verify` on both images.

That is the "checked in CI" acceptance criterion of #614.

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
   this file), `SECURITY.md` (vulnerability reporting), `LICENSE` (GPL-2.0-only) and
   `LICENSING.md` (`core/` and the tooling are `MIT OR GPL-2.0-only`, ADR-0028),
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
- Make sure CI is green. New tunables get NS-3 `TypeId`
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

By contributing you agree your work is licensed under the licence of the
directory it lands in ([LICENSING.md](LICENSING.md), ADR-0028): under
`MIT OR GPL-2.0-only` for anything in `core/`, `tools/`, `ns3/tools/` or
`docs/tools/` (the one exception is `docs/tools/mkdocs_hooks.py`), and under
the repository's [LICENSE](LICENSE) (GPL-2.0-only) everywhere else. A change
to those paths that cannot be offered under both licences belongs elsewhere. You also agree
to abide by our
[Code of Conduct](CODE_OF_CONDUCT.md).
