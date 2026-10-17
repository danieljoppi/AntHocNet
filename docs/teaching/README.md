# Classroom pack

Five lab sheets for a networking course, built on the [learn site](https://danieljoppi.github.io/AntHocNet/).
The site is a game, but every device in it runs the real AntHocNet routing
core compiled to WebAssembly, so what students observe is what the protocol
does. Each sheet follows one format:
1. **predict** the outcome and write it down;
2. **run** it in the browser;
3. **explain** the gap between prediction and result;
4. **compare** with the ns-3 measurement on the results pages.

[← Docs home](../README.md) · [Answer keys](answer-keys.md) · [Learn campaign](../learn-campaign.md)

| lab | topic | where in the site | time |
|---|---|---|---|
| [1](lab-1-reactive-proactive.md) | Reactive vs proactive route maintenance | MANET world, seed 6 + the tuning bench | 45 min |
| [2](lab-2-mesh-overhead.md) | Why a static mesh costs AntHocNet more control traffic than OLSR | Mesh world, seed 8 + the tuning bench | 45 min |
| [3](lab-3-vanet-reconvergence.md) | VANET: buildings, corners and reconvergence | Campaign levels 3.1 and 3.4 | 60 min |
| [4](lab-4-satellite-handover.md) | Satellites: handover and a failed link | Campaign levels 5.1 and 5.3 | 60 min |
| [5](lab-5-multipath.md) | Stochastic multipath and the pheromone exponent β | Mesh world, seed 4 + the tuning bench | 45 min |

A sixth lab, on an attack and its defence, follows the security profile in
v3.0.0.

## Before the class

- **Browser.** Any current desktop browser runs the site. After the first
  visit it also works offline.
- **Links.** Every link in a sheet pins a world and a seed, for example
  `#manet?seed=6`. The same seed gives the same run on every machine. The
  world, the movement and the random draws are deterministic, so the whole
  class sees the same thing and the answer keys hold.
- **Campaign levels.** Labs 3 and 4 use the campaign. Normally a chapter
  opens only after the previous one is cleared. The classroom link
  [`#campaign?open=all`](https://danieljoppi.github.io/AntHocNet/#campaign?open=all)
  opens every level for that visit and records no progress.
- **The tuning bench.** Labs 1, 2 and 5 change one protocol parameter with
  the **Tuning bench** panel (*Change a protocol parameter*). The bench
  restarts the world with the change and runs a faint "ghost" of the same
  seed at the default settings beside it. Its table compares the two runs.
- **Reading numbers.** The status bar under the map shows the simulated
  time `t`, data delivered / sent (`✓`) and ant transmissions (`ants`). Pause
  (❚❚) at the time the sheet names; one or two seconds either side changes
  the last digit, not the answer.

## How the answer keys are checked

Every number in [answer-keys.md](answer-keys.md) is measured by
[`web/test/labs.mjs`](https://github.com/danieljoppi/AntHocNet/blob/main/web/test/labs.mjs)
on the same WebAssembly core the site runs, at the seed the sheet names.
The script also checks the claim each key makes, such as "quiet mode spends
fewer ants per delivered packet". If a change to the core moves a number,
the script fails, and the key is updated in the same change:

```bash
web/build-site.sh && node web/test/labs.mjs web/build-site
```

## From the browser to ns-3

The browser's radio is a teaching model: a disk, or a disk with buildings,
canopy or orbits. Each sheet ends with a *Compare* step that links the ns-3
results page for the same network family. Those numbers come from 20-seed
runs with a full PHY/MAC. Students who want to re-run them can:
- copy the bench's *ns-3 line*: the same parameter change as an
  `anthocnet-compare` flag;
- follow the reproduce section of the results page.

*Translations:* the sheets are in English. A pt-BR version follows, as the
game's own strings did (#622).
