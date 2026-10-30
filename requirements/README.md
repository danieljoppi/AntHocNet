# Python tool pins

The Python tools CI uses, one pair of files per tool:

- `<tool>.in` holds the pin you edit (`ruff==0.16.10`);
- `<tool>.txt` is generated from it: the tool and every dependency, each pinned
  to an exact version **and** to its sha256 hashes.

Every install goes through the `.txt` files with `pip install --require-hashes`
([#787](https://github.com/danieljoppi/AntHocNet/issues/787)), so a dependency
cannot change under a pinned version without the install failing. Workflows
install with `.github/actions/python-tools` (`packages: ruff pyyaml` installs
`ruff.txt` and `pyyaml.txt`); `release.yml` installs `commitizen.txt` directly.

## Changing a pin

Edit the `.in` file, then regenerate its `.txt` with the command in that file's
header:

```bash
uv pip compile --universal --python-version 3.12 --generate-hashes \
    requirements/<tool>.in -o requirements/<tool>.txt
```

`--universal` resolves for every Python and platform at once, so the same file
installs on the runners' 3.12 and `3.x` interpreters. Dependabot (`pip`
ecosystem, `/requirements`) proposes the bumps; if one of its PRs changes a
`.in` without the matching `.txt`, regenerate the `.txt` in that PR. Adding a
tool means adding its `.in`, generating its `.txt` and naming it in the job.

## Why each pin is deliberate

- **ruff:** an upstream release that tightens default rules turns every open PR
  red on files nobody touched. That already happened once, on 0.16.0
  (I001/ISC004/PLW1510/EXE001).
- **gcovr:** its gcov parsing changes between versions, so an unpinned bump
  silently moves the coverage baseline that merges are compared against.
- **mkdocs-material:** the docs build runs `--strict`, so an upstream release
  turns a new warning into a red run on the default branch.
- **commitizen:** it computes the semver bump from commit history and rewrites
  `.cz.toml` and `CITATION.cff` during a release. An unpinned version can
  change your release numbering, and no PR CI exercises `release.yml`.
- **matplotlib:** `charts.yml` commits the PNGs it renders, so a release that
  moves a pixel would recommit every chart on `main`.
- **pyyaml:** the lint job self-tests `tools/bench/campaign.py` and its siblings, which read their YAML plans with it.
