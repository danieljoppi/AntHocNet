# ADR-0028: `core/` is dual-licensed `MIT OR GPL-2.0-only`

- **Status:** Accepted (maintainer decision 2026-10-29; decides
  [#782](https://github.com/danieljoppi/AntHocNet/issues/782)). Implemented by
  the PR that closes #782 (checklist under [Implementation](#implementation));
  takes effect from the first release after v2.6.0. **Amended** the same day
  to extend the dual licence to the standalone tooling
  ([below](#amendment-2026-10-29-the-standalone-tooling)).
- **Date:** 2026-10-29
- **Amends:** the single repository licence (`LICENSE`, GPL-2.0-only) for the
  `core/` directory only. Every other directory is unchanged.

## Context

Until now the whole repository has been GPL-2.0-only. That covers `LICENSE`,
`CITATION.cff`, the README badge, the contribution clause in `CONTRIBUTING.md`,
and the SPDX header on every source file, which `docs/tools/check-headers.py`
requires.

The question came up on 2026-10-29, when an external code index asked for the
ns-3 `adaptive` comparator module (#754) to be released under MIT. That request
was declined. The module includes ns-3 headers, builds only inside a GPL-2.0
ns-3 tree, and anything shipped from it is GPL anyway, so an MIT licence would
change nothing in practice.

That request exposed an asymmetry, though. `core/` is different from everything
else in the repo:

- **It includes no simulator header** (golden rule 1, enforced by
  `check_invariants.sh`). It depends only on its ports (`IClock`, `IRng`,
  `INeighborProvider`, `ITimerScheduler`, and the optional `ILinkQuality` /
  `IKinematics`, ADR-0024/0025).
- **It is the part with uses outside ns-3.** These include another simulator
  (OMNeT++, #32), a real routing daemon, embedded firmware on a drone or
  vehicle, and the browser (ADR-0021). Some of those places cannot take GPL
  code: app stores that conflict with GPL, closed vendor SDKs, and
  permissively licensed simulators that will not mix licences.
- **Under GPL-2.0-only, that reuse is closed off.** Under MIT alone, the
  repository's history of copyleft would end for the one part that most needs
  it to stay open.

The adapters are in the opposite position. `ns3/anthocnet/`,
`ns3/routing-bench/` and `ns3/baselines/*` are ns-3 modules; GPL-2.0 is the
licence of their host. `aomdv` and `gpsr` are third-party GPLv2 code (Copyright
IITP RAS) and **cannot** be relicensed by this project at all.

**Why the repository was GPL in the first place.** Through v1.9.0 the repo
carried a full NS-2 integration (ADR-0005): files patched into, and built
inside, the GPL NS-2 tree. Keeping the whole repository on NS-2's licence was
the simple and correct choice then. ADR-0002 split the algorithm into a
simulator-free `core/`, and v2.0.0 removed the NS-2 adapter (#307, ADR-0023).
Since then nothing in `core/` comes from, or is built into, a simulator. The
licence was inherited from a constraint that no longer applies to this
directory.

## Decision

**`core/` is licensed `MIT OR GPL-2.0-only`, recipient's choice. Every other
directory stays GPL-2.0-only.**

1. **Scope.** Every tracked file under `core/` is covered, including
   `src/`, `include/`, `tests/` (and `tests/fuzz_corpus/`), `bench/` and
   the `CMakeLists.txt` files. Every C++ file carries
   `SPDX-License-Identifier: MIT OR GPL-2.0-only`. The build files and the
   binary fuzz corpus carry no header, as they never did; `core/LICENSE`
   covers them.
2. **Licence texts.** `core/LICENSE` holds the MIT text and says that the
   GPL-2.0 option is the root `LICENSE`. The root `LICENSE` stays the stock GPL
   text. `LICENSING.md` at the root maps each directory to its licence.
   `make install-ns3` (and so the module tarball) copies `core/LICENSE` next
   to the core sources it lays into `contrib/anthocnet/core/` and
   `contrib/oracle/core/`.
3. **One-way dependency, enforced.** GPL code may depend on `core/`, but
   `core/` must never pull GPL-only code in. Golden rule 1 already makes this
   structural, since `core/` includes nothing from outside `core/`.
   `docs/tools/check-headers.py` (CI, `lint.yml`) makes it explicit. Every
   `core/` C++ file must carry exactly `MIT OR GPL-2.0-only`. Its angle
   includes must be C++ standard-library headers, and its quote includes must
   resolve to a file under `core/`. So no `ns3/`, `web/` or vendored-baseline
   header can get in, and neither can a third-party library.
4. **Contributions.** Contributions to `core/` are accepted under both
   licences. Contributions elsewhere are accepted under GPL-2.0-only, as now.
   `CONTRIBUTING.md` states this per directory.
5. **Combined artifacts.** Combined artifacts are GPL-2.0, and that is
   intended:
   - The ns-3 module tarball and install bundle ship `core/` inside a GPL ns-3
     module.
   - The learn site ships `core/` linked with the GPL `web/` adapter as WASM.
   - In both cases the shipped whole is distributed under GPL-2.0, while each
     `core/` source file keeps its dual notice. Taking `core/` out of the tree
     gives it back its MIT option.
6. **No retroactive change.** Every release up to and including v2.6.0 (and
   its Zenodo version DOI) remains GPL-2.0-only. The dual licence applies from
   the first release that carries this change.

## Amendment (2026-10-29): the standalone tooling

**`tools/`, `ns3/tools/` and `docs/tools/` are also `MIT OR GPL-2.0-only`.
The one exception is `docs/tools/mkdocs_hooks.py`, which stays GPL-2.0-only.
The C++ comparison harness, `ns3/routing-bench/`, stays GPL-2.0-only.**
(Maintainer decision on #782, landed in the same PR as the core change.)

The tooling is in the same position as `core/`:

- **It is standalone.** These are 52 Python and shell programs that read logs,
  CSVs and plans: benchmark parsing, the paired statistics and noise verdicts
  (`tools/bench/stats_util.py`, `bench_parse.py`), the campaign runner, the
  chart and summary scripts, the CI checks and the release scripts. None of
  them imports ns-3 or its bindings. Their imports are the standard library,
  each other, and permissive third-party packages (matplotlib, PyYAML).
- **It is the maintainer's own code.** Every copyright line in those paths is
  the maintainer's.
- **It has uses outside this repo.** The noise verdicts and paired comparisons
  work for anyone benchmarking any protocol on any simulator.

**Why the exceptions:**

- `docs/tools/mkdocs_hooks.py` loads `web/shell/inject.py` (GPL-2.0-only) to
  render the site chrome. A dual-licensed file that loads GPL-only code has no
  usable MIT form, so the file stays GPL. It is listed in `GPL_ONLY` in
  `check-headers.py`.
- `ns3/routing-bench/` is an ns-3 module. Its provenance is clean
  (`anthocnet-compare.cc` at v1.2.0 carries no third-party header and does not
  derive from ns-3's `manet-routing-compare.cc`), so it *could* be relicensed.
  But it builds only inside a GPL ns-3 tree, so every artifact made from it
  is GPL-2.0 anyway. The same reasoning kept the `adaptive` module (#754)
  GPL-only.

**What the amendment adds to Decision item 3 (the one-way rule):** a
dual-licensed Python file that loads code by path (`sys.path`,
`spec_from_file_location`, `import_module`) must not name a GPL-only Python
root (`web/shell`, `.claude/skills`). The rule is narrow on purpose (#229).
It catches the way this repo actually loads code across directories, not every
possible indirection; review covers the rest. The data files in those roots
(campaign plans, anchors, fixtures, `lsan.supp`) carry no header, as before.
`LICENSE-MIT` at the root covers them, and `LICENSING.md` maps them.

## Why dual, not MIT alone, and not "leave it"

- **MIT is GPL-compatible**, so an MIT option costs the ns-3 adapter nothing.
  The adapter keeps linking `core/` exactly as it does today, and the ns-3 App
  Store listing (#613) only needs a GPLv2-compatible licence. JOSS (#625) only
  needs an OSI licence, and both options are OSI-approved.
- **The `OR GPL-2.0-only` half keeps the record intact.** Every downstream user
  who received `core/` under GPL-2.0 (all releases to date) keeps exactly those
  terms. GPL projects can take `core/` with no licence analysis at all.
- **MIT alone was rejected.** It is the same permissiveness with no
  continuity, and a single licence on a single directory with a different
  licence next to it reads as an accident. A disjunctive SPDX expression reads
  as a decision.
- **Status quo was rejected** because it leaves the reuse case above closed,
  which is the reason the core/adapter seam exists (ADR-0002, kept by
  ADR-0023).

## Consequences

- **Permanent.** Code released under the MIT option can be used in proprietary
  products, and that grant cannot be withdrawn for the versions that carry it.
  Later versions could drop the MIT option, but the released ones keep it.
- **Provenance is a gate, not a courtesy.** Only the copyright holder can add
  a licence. The maintainer confirmed on 2026-10-29 (#782) that every line
  under `core/` is their own, including the pre-core implementation that
  `core/include/anthocnet/core/ports.h:31` calls "the original code", and that
  nothing was carried in from NS-2 or any other third-party code. A spot check
  of `core/` at the v1.2.0 tag agrees. Every copyright line there is the
  maintainer's. The only third-party text is citations of the Ducatelle thesis
  and papers in comments (short quotations of the source the algorithm is
  built from, not code). Any future core file from someone else needs the same
  confirmation before it lands.
- **AI-assisted commits.** Many `core/` commits carry a
  `Co-Authored-By: Claude …` trailer. They do not block relicensing by the
  sole human author: the author can license whatever rights they hold. The copyrightability of
  AI-generated code is legally unsettled, so the grant is "whatever rights the
  author holds", which is the same position as the existing GPL grant.
- **A new external contributor to `core/`** must agree to both licences, which
  the per-directory clause in `CONTRIBUTING.md` covers. A contribution that
  cannot be dual-licensed belongs outside `core/` or is declined.
- **Tooling learns per-directory licences.** `check-headers.py` still accepts
  any SPDX expression elsewhere. Under the dual roots (`core/`, `tools/`,
  `ns3/tools/`, `docs/tools/`, minus `GPL_ONLY`) it requires the exact
  expression from Decision item 1, and it now also covers `.sh` files in the
  tooling roots. `CITATION.cff` lists both SPDX ids, because
  CFF takes a list, not an expression; the per-directory split is in a comment
  there and in `LICENSING.md`. The release bundle gate
  (`tools/release/check-bundle.sh`) checks that `LICENSE`, `LICENSE-MIT`,
  `LICENSING.md` and `core/LICENSE` all ship.
- **The adapters are untouched.** This ADR adds no licence option to the ns-3
  modules under `ns3/` (`anthocnet`, `routing-bench`, `baselines/*`), `web/`,
  `docs/` pages, `results/`, `api/` or `paper/`.

## Implementation

Tracked in [#782](https://github.com/danieljoppi/AntHocNet/issues/782); one
PR:

- [x] Provenance confirmed by the maintainer (Consequences, above).
- [x] SPDX headers on all 62 `core/` C++ files set to `MIT OR GPL-2.0-only`.
- [x] `core/LICENSE` added (MIT text plus a pointer to the root `LICENSE` for the
      GPL option); `LICENSING.md` directory map added; `make install-ns3`
      copies `core/LICENSE` with the core sources.
- [x] `docs/tools/check-headers.py` requires the dual expression under `core/`
      and rejects `core/` includes from outside `core/`, with self-test cases
      for each rule.
- [x] `CITATION.cff`, the README licence section and badge, and the
      `CONTRIBUTING.md` contribution clause updated.
- [x] `tools/release/check-bundle.sh` asserts the licence texts are in the
      package; `assemble-bundle.sh` ships `LICENSING.md`.
- [x] Amendment: 52 tooling scripts set to `MIT OR GPL-2.0-only` (38 Python and
      shell headers rewritten, plus a header added to the 14 `tools/checks/*.sh`
      and `ns3/tools/run-comparison.sh` scripts that had none). `LICENSE-MIT`
      added. `check-headers.py` extended: dual roots, `.sh` coverage, the
      `GPL_ONLY` exception and the Python load rule, each with self-test
      cases. `LICENSING.md`, README, `CONTRIBUTING.md`, `CITATION.cff`,
      `mkdocs.yml` and the bundle scripts updated.

## References

- [#782](https://github.com/danieljoppi/AntHocNet/issues/782): the decision issue.
- [ADR-0023](0023-one-core-one-simulator-adapter.md): one core, one simulator
  adapter, with the seam kept.
- [ADR-0021](0021-the-browser-is-an-adapter.md): the browser is an adapter.
- `ns3/baselines/aomdv/README.md`, `ns3/baselines/gpsr/README.md`: third-party
  GPLv2 provenance.
- [SPDX licence expressions](https://spdx.github.io/spdx-spec/v2.3/SPDX-license-expressions/);
  [GNU licence list, Expat](https://www.gnu.org/licenses/license-list.html#Expat)
  (GPL-compatible).
