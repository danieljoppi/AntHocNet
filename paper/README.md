# AntHocNet — JOSS software paper

Submission draft for the [Journal of Open Source Software (JOSS)](https://joss.theoj.org).
JOSS papers are short and describe the *software*, not new results.

- `paper.md` — the paper (Markdown + YAML metadata; ~250–1000 words).
- `paper.bib` — references (cited with `[@key]`).

Lives in this repo (not the private `papers` repo) because JOSS review
targets the **software repository** directly and expects `paper.md` to live
in it.

## Preview the PDF locally

JOSS builds the PDF with Open Journals' `inara` container:

```bash
docker run --rm -v "$PWD":/data -u $(id -u):$(id -g) \
  openjournals/inara -o pdf,preprint paper.md
```

(Produces `paper.pdf`. No local LaTeX needed.)

## Before submitting

**Submission is currently deferred — do not submit yet.** JOSS updated its
scope/significance policy in January 2026, and the software repo fails two
of the updated criteria (independent of code quality):

1. **"Not concentrated bursts of work."** The repo was created in 2016, sat
   with zero commits for ~10 years, then had its entire current
   implementation written in a single ~4-week AI-assisted window
   (2026-06-25 → 2026-07-23).
2. **"Evidence of research impact."** No citations/adoption yet — the real
   implementation only went public days ago.

Revisit once the ICNS3 study paper is published (the citable reference that
seeds #2) and the repo shows a few months of ordinary, spaced-out post-v1.0
activity. Full reasoning: `danieljoppi/papers` repo,
`docs/adr/0002-venue-strategy.md` (update section) and
`AntHocNet/publication-options.md`.

The repo already meets JOSS's *mechanical* criteria: OSI license (GPL-2.0),
documentation, automated tests, CI, and community guidelines
(`CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`) — that was never the blocker.
Remaining paper TODOs, for whenever submission resumes:

- [ ] Funding / acknowledgements, if any.
- [ ] Preview the PDF with `inara` and proof the citations.
- [x] Tag a release to submit against (v1.0.0 is out) and have the Zenodo DOI
      ready: 10.5281/zenodo.20981979 (concept DOI, resolves to latest) — #107.
- [ ] Submit at <https://joss.theoj.org/papers/new> (points JOSS at the repo).

No affiliation TODO: the author has no research-organization affiliation,
so the byline is "Independent researcher" (affiliation is optional in the
JOSS `paper.md` schema). ORCID: 0009-0009-6436-8174.

## Note

JOSS reviews the *software*; it explicitly does not require novel results.
The fuller reproducibility / cross-simulator **study** paper is a separate,
longer paper kept in the private `papers` repo
(`AntHocNet/icns3-anthocnet-reproducible-cross-simulator/`, targeting
ICNS3/SoftwareX) alongside the venue survey.
