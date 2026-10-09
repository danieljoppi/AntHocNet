---
name: learn-site
description: Build, test and screenshot AntHocNet's learn site (the WebAssembly game that is the GitHub Pages front page) — native-vs-WASM parity, the browser smoke + accessibility gate, local serving, and regenerating the README figures from the game. Use when changing anything under web/ (adapter, scenarios, worlds, missions, renderer, UI) or docs figures captured from it, and when working on the campaign (epic #562).
---

# learn-site

The site is an **adapter**, not a second implementation (ADR-0021): `core/`
compiled to WASM plus a browser-side scheduler, scenarios and renderer. Two CI
gates protect that claim — keep both green before pushing a `web/` change.

| Path | What |
|---|---|
| `web/src/`, `web/include/ahn_web/` | the C++ browser adapter (scheduler, radio, mobility, scenarios) |
| `web/site/` | the game: `index.html`, `js/app.js` (playground), `js/iso.js` (renderer), `js/worlds.js`, `js/missions-data.js`, `css/learn.css` |
| `web/build-site.sh` | assembles `web/build-site/` (WASM + site), the Pages root |
| `web/site-redirects.sh` | old-URL redirects (docs moved to `/docs/`) |
| `web/test/parity.sh` | native vs WASM decision traces — **byte-identical** |
| `web/test/smoke.mjs` | headless Chromium: every world delivers, a mission completes, axe finds nothing serious |
| `web/tools/readme-figures.mjs` | regenerates `docs/images/readme-*.png` from the game |
| `docs/learn-campaign.md` | the campaign design (chapters, UI, adapter features); §10 the whole site as the game; §11 the Workshop (API + ns-3) |

## Setup (once per container)

```bash
git clone --depth 1 --branch 4.0.10 https://github.com/emscripten-core/emsdk.git /tmp/emsdk
/tmp/emsdk/emsdk install 4.0.10 && /tmp/emsdk/emsdk activate 4.0.10
source /tmp/emsdk/emsdk_env.sh        # pin = ci.yml; the toolchain is part of the parity claim
mkdir -p /tmp/pw && cd /tmp/pw && npm install --no-audit --no-fund playwright-core@1.56.1 axe-core@4.10.2
```

Chromium is preinstalled in the cloud container (`/opt/pw-browsers`); the
scripts find it, or take `CHROMIUM=<path>`. Never run `playwright install` there.

## The loop

```bash
web/test/parity.sh 120 "1 2 7 42"                  # 1. parity (the gate CI runs)
web/build-site.sh                                   # 2. assemble web/build-site/
(cd /tmp/pw && node "$OLDPWD/web/test/smoke.mjs" "$OLDPWD/web/build-site")   # 3. smoke + a11y
```

`node` resolves `playwright-core` from the **current directory**, hence the `cd`.
Look at it yourself with any static server over `web/build-site/` (WASM needs
`application/wasm`; `python3 -m http.server` serves it). Worlds open by hash:
`#manet`, `#mesh`, `#vanet`, `#fanet`, `#satellite`, `#line`; `?seed=N` pins
the seed.

## Determinism rules (why parity breaks)

- **Never call a random draw inside a function argument list** — evaluation
  order differs between clang-native and emscripten. Draw into named locals.
- **Mobility is arithmetic only.** Orbits use `detSin`/`detCos`, not libm
  trig; libm differs between the native and WASM builds.
- Keep `-ffp-contract=off` (no fused multiply-add on one side only).
- No routing decision in `web/`: if a world needs a behaviour, it is a core
  `Config` switch (golden rule 8) or it does not happen.

A parity diff prints the first diverging trace line — read the event kind and
time, then find the draw or float op that differs.

## README figures

The two README figures are frames from the real game, not drawings:

```bash
web/build-site.sh
(cd /tmp/pw && node "$OLDPWD/web/tools/readme-figures.mjs" "$OLDPWD/web/build-site" "$OLDPWD/docs/images")
```

It pauses the line world just before the flow starts (t = 1.995 s) and steps
slowly to catch the three phases, then captures each world. Regenerate when a
world's look changes, and eyeball the PNGs before committing. The campaign tile
reuses `docs/images/learn-campaign-map.png` (captured from
`docs/images/learn-campaign-mockup.html`).

## Pages

`pages.yml` publishes: the game at `/`, mkdocs at `/docs/` (`site_url` ends in
`/docs/`), Doxygen at `/api/`. It redeploys after bot commits to `docs/`
(charts). After a merge, check the live site loads and the README images render.
