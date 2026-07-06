# 14 — Reproducibility (Docker), citeability (CITATION/releases/DOI), version matrix

- **Covers:** E1 (Docker repro), E2 (CITATION + releases + DOI), E3 (ns-3 version
  matrix)
- **Priority:** P2
- **Effort:** M
- **Layer:** packaging / CI / docs
- **Depends on:** complements 07/08 (benchmarks) and 09 (positioning)

## Summary

The project is research software whose audience is people writing papers and
comparing protocols. Three packaging gaps make it harder to *use* and *cite* than
it should be: there is no one-command way to reproduce the benchmark environment,
no machine-readable citation/release metadata, and the "ns-3.36+" support claim
isn't verified across versions. These are cheap and high-leverage for adoption.

## E1 — Dockerized reproduction environment

### Problem

Running the benchmarks (items 07/08) requires the user to install a specific
ns-3, enable the right modules, install the AntHocNet module, and build —
documented, but many steps and version-sensitive. Reviewers usually won't.

### Required change

Add a `docker/` setup that pins everything:
- A `Dockerfile` based on a known-good toolchain that:
  - fetches a **pinned** ns-3 tag,
  - `make install-ns3 NS3DIR=...`,
  - configures with the benchmark module set,
  - builds.
- A `docker/run-benchmarks.sh` that runs `anthocnet-compare`/`run-comparison.sh`
  and writes the CSV to a mounted volume.
- (Optional) a separate image for the pinned ns-2.35 + patch.

Document a one-liner in the README:
```bash
docker build -t anthocnet-bench -f docker/Dockerfile .
docker run --rm -v "$PWD/out:/out" anthocnet-bench run-benchmarks.sh
```

### Acceptance

- `docker build` + `docker run` reproduces a `docs/benchmarks.md`-style CSV on a
  clean machine with no host ns-3.

### Release-pinned images (shipped, #77)

The `Images` workflow publishes the rolling `anthocnet-ns{2,3}:<sim-version>`
tags on every `main` push, so they track `main` and are **not** reproducible for
a citation. The `Release` workflow therefore reuses `images.yml` via
`workflow_call` to additionally publish immutable **release-pinned** tags that
keep the simulator version and pin the release —
`anthocnet-ns3:3.42-v0.3.0`, `anthocnet-ns2:2.35-v0.3.0`, and the plain
`ns{2,3}:<sim-version>-<release>` baselines. Reuse (not a tag `push` event) is
deliberate: the release job pushes its tag with the default `GITHUB_TOKEN`,
which does not trigger other workflows, whereas a `workflow_call` job dependency
runs in the same release and needs no PAT.

## E2 — Citeability: CITATION.cff, tagged releases, DOI

### Problem

No `CITATION.cff`, no tagged releases, no DOI. Academic users can't cite the
software cleanly, and there's no stable "this is the version I used" reference for
reproducibility.

### Required change

1. Add `CITATION.cff` (GitHub renders a "Cite this repository" button) with
   author (Daniel Henrique Joppi), title, the AntHocNet paper references
   ([1]–[3] in `docs/improvements/README.md`), license, and repo URL.
2. Adopt **semantic version tags** (e.g. `v0.1.0` for the current refactored
   baseline) and cut a GitHub Release with notes summarizing the
   core-+-adapters architecture and the fixes vs the legacy module.
3. (Optional) Connect the repo to **Zenodo** so each release mints a DOI; add the
   DOI badge to the README.

### Acceptance

- "Cite this repository" appears on GitHub; a `v0.x.0` release exists; (optional)
  a Zenodo DOI badge resolves.

## E3 — ns-3 version compatibility matrix

### Problem

`README`/`porting-notes` claim ns-3.36+ (CMake) with a `wscript` for older waf
builds, but nothing verifies the module actually builds across those versions;
ns-3 changes its module/build API between releases.

### Required change

- Pick a small set of pinned ns-3 versions to support (e.g. `3.36`, the latest
  LTS, and `ns-3-dev` as best-effort) and **build the module against each** in a
  manual-dispatch CI matrix (reuse the e2e workflow from item 13).
- Record the verified versions in a small table in `ns3/README.md` (and note
  known breakages), instead of an unbacked "3.36+".

### Acceptance

- A CI matrix builds the NS-3 module against the listed versions; `ns3/README.md`
  shows the verified-versions table; unsupported versions are stated, not implied.

## Files to touch

- `docker/Dockerfile`, `docker/run-benchmarks.sh` (new)
- `CITATION.cff` (new, repo root)
- `ns3/README.md` (version matrix table)
- `.github/workflows/e2e.yml` (version matrix build; from item 13)
- `README.md` (Docker one-liner; DOI/cite badges)

## Acceptance criteria (summary)

1. One-command Docker reproduction of the benchmark CSV.
2. `CITATION.cff` + at least one tagged release (+ optional DOI badge).
3. CI builds the NS-3 module across the declared supported versions; the matrix
   is documented.

## Risks / notes

- Pin **everything** (ns-3 tag, base image, compiler) or the "reproducible"
  environment will drift.
- Keep the heavy matrix/e2e on manual or scheduled triggers (shared with item 13)
  — not the per-push path.
- Version support is a maintenance commitment; list only what CI actually checks.
