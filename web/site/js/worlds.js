// One world per network family (#547). A world changes the scenario --
// mobility, channel, size -- never the protocol defaults (ADR-0019). Every
// comparative claim is a link to the measured results page, never a number
// from this teaching radio.
import { localized } from './i18n.js';

const RESULTS = 'docs/benchmarks/';
// read: the Field guide page each world illustrates (#631; checked both ways by
// tools/checks/check-site-links.py, with the docs pages' `try:` front matter).
const GUIDE = 'docs/';
// The words (title, blurb, honest, link labels) are in i18n/<lang>.json under
// world.<id> (#622).
export const WORLDS = [
  {
    id: 'line', sprite: 'phone', speed: 0.25,
    results: null,
    read: { href: GUIDE + 'ant-types/' },
  },
  {
    id: 'manet', sprite: 'phone', speed: 1,
    results: { href: RESULTS + 'grid/' },
    read: { href: GUIDE + 'network-regimes/' },
  },
  {
    id: 'town', sprite: 'phone', speed: 1,
    results: { href: RESULTS + 'grid/' },
    read: { href: GUIDE + 'network-regimes/' },
  },
  {
    id: 'mesh', sprite: 'tower', speed: 0.25,
    results: { href: RESULTS + 'static-mesh/' },
    read: { href: GUIDE + 'network-regimes/' },
  },
  {
    id: 'fanet', speed: 1,
    results: { href: RESULTS + 'scenarios/fanet/' },
    read: { href: GUIDE + 'network-regimes/' },
  },
  {
    id: 'vanet', speed: 1,
    results: { href: RESULTS + 'scenarios/vanet/' },
    read: { href: GUIDE + 'network-regimes/' },
  },
  {
    id: 'satellite', speed: 1,
    results: { href: RESULTS + 'satellite/leo-walker/' },
    read: { href: GUIDE + 'network-regimes/' },
  },
].map((w) => {
  localized(w, `world.${w.id}`, ['title', 'blurb', 'honest']);
  if (w.results) localized(w.results, `world.${w.id}.results`, ['label']);
  if (w.read) localized(w.read, `world.${w.id}.read`, ['label']);
  return w;
});
export const worldById = (id) => WORLDS.find((w) => w.id === id) || WORLDS[1];
