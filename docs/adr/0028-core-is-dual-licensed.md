# ADR-0028: `core/` is dual-licensed `MIT OR GPL-2.0-only`

- **Status:** Accepted (maintainer decision 2026-10-29; decides
  [#782](https://github.com/danieljoppi/AntHocNet/issues/782)). Implementation
  pending: the checklist under [Implementation](#implementation) lands as one PR.
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

## Decision

**`core/` is licensed `MIT OR GPL-2.0-only`, recipient's choice. Every other
directory stays GPL-2.0-only.**

1. **Scope.** Every tracked file under `core/` is covered, including
   `src/`, `include/`, `tests/` (and `tests/fuzz_corpus/`), `bench/` and
   `CMakeLists.txt`. The SPDX line becomes
   `SPDX-License-Identifier: MIT OR GPL-2.0-only`.
2. **Licence texts.** `core/LICENSE` holds the MIT text and says that the
   GPL-2.0 option is the root `LICENSE`. The root `LICENSE` stays the stock GPL
   text. A short `LICENSING.md` (or a README section) explains which licence
   applies to which directory.
3. **One-way dependency, enforced.** GPL code may depend on `core/`, but
   `core/` must never pull GPL-only code in. Golden rule 1 already makes this
   structural, since `core/` includes nothing from outside `core/`. A CI check
   makes it explicit: every file under `core/` must carry exactly
   `MIT OR GPL-2.0-only`, and no `core/` file may include a header from outside
   `core/` (`ns3/`, `web/`, or a vendored baseline).
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
- **Provenance is now a gate, not a courtesy.** Only the copyright holder can
  add a licence. Before the implementing PR merges:
  - confirm that every line under `core/` is the maintainer's own, using the
    **full** history (the agent checkouts are shallow), and that nothing was
    carried in from third-party GPL code;
  - in particular, confirm that the "original code" mentioned in
    `core/include/anthocnet/core/ports.h:31` (the libc `rand()` note) is the
    maintainer's own pre-core implementation.
- **AI-assisted commits.** Many `core/` commits carry a
  `Co-Authored-By: Claude …` trailer. They do not block relicensing by the
  sole human author: the author can license whatever rights they hold. The copyrightability of
  AI-generated code is legally unsettled, so the grant is "whatever rights the
  author holds", which is the same position as the existing GPL grant.
- **A new external contributor to `core/`** must agree to both licences, which
  the per-directory clause in `CONTRIBUTING.md` covers. A contribution that
  cannot be dual-licensed belongs outside `core/` or is declined.
- **Tooling learns per-directory licences.** `check-headers.py` still accepts
  any SPDX expression elsewhere, but under `core/` it requires the exact
  expression from Decision item 1. `CITATION.cff` gets an SPDX expression or a
  list. The release bundle gate (`tools/release/check-bundle.sh`) checks that
  both licence texts ship.
- **The adapters are untouched.** This ADR adds no licence option to
  `ns3/`, `web/`, `tools/`, `docs/` or `results/`.

## Implementation

Tracked in [#782](https://github.com/danieljoppi/AntHocNet/issues/782); one
`chore:` PR:

- [ ] Provenance confirmed on full history (Consequences, above).
- [ ] SPDX headers under `core/` set to `MIT OR GPL-2.0-only`.
- [ ] `core/LICENSE` added (MIT text plus a pointer to the root `LICENSE` for the
      GPL option); a `LICENSING.md` directory map added.
- [ ] `docs/tools/check-headers.py` requires the dual expression under `core/`
      (with self-test cases), and a check rejects `core/` includes from outside
      `core/`.
- [ ] `CITATION.cff`, the README licence section and badge, and the
      `CONTRIBUTING.md` contribution clause updated.
- [ ] `tools/release/check-bundle.sh` asserts both licence texts are in the
      package.

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
