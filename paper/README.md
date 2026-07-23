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

The **software repo** already meets JOSS criteria: OSI license (GPL-2.0),
documentation, automated tests, CI, and community guidelines
(`CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`). Remaining paper TODOs:

- [ ] Funding / acknowledgements, if any.
- [ ] Preview the PDF with `inara` and proof the citations.
- [ ] Tag a release to submit against (v1.0.0 is out) and have the Zenodo DOI
      ready (#107).
- [ ] Submit at <https://joss.theoj.org/papers/new> (points JOSS at the repo).

No ORCID/affiliation TODO: the author has no research-organization
affiliation or ORCID, so the byline is "Independent researcher" with no
`orcid` field — both are optional in the JOSS `paper.md` schema.

## Note

JOSS reviews the *software*; it explicitly does not require novel results.
The fuller reproducibility / cross-simulator **study** paper is a separate,
longer paper kept in the private `papers` repo
(`AntHocNet/icns3-anthocnet-reproducible-cross-simulator/`, targeting
ICNS3/SoftwareX) alongside the venue survey.
