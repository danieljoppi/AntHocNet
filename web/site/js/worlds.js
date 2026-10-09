// One world per network family (#547). A world changes the scenario --
// mobility, channel, size -- never the protocol defaults (ADR-0019). Every
// comparative claim is a link to the measured results page, never a number
// from this teaching radio.
const RESULTS = 'docs/benchmarks/';
// read: the Field guide page each world illustrates (#631; checked both ways by
// tools/checks/check-site-links.py, with the docs pages' `try:` front matter).
const GUIDE = 'docs/';
export const WORLDS = [
  {
    id: 'line', title: 'Six in a row', sprite: 'phone', speed: 0.25,
    blurb: 'Six nodes that each hear only their neighbours, and one flow from end to end. The smallest network where routing is a question at all.',
    honest: 'Teaching radio: unit disk, 250 m range, 2 Mbit/s, no collisions.',
    results: null,
    read: { href: GUIDE + 'ant-types/', label: 'The five ant types' },
  },
  {
    id: 'manet', title: 'Ad hoc MANET (default)', sprite: 'phone', speed: 1,
    blurb: '30 phones on an open field: the network the AntHocNet papers were written for. Twenty are carried around (random waypoint, 3–15 m/s: walking to cycling) and leave footprints; ten stay put. Links appear and break as people move; the bold trail is each flow\'s strongest pheromone route, and you can watch it switch.',
    honest: 'Teaching radio: unit disk, 250 m range. The measured MANET results use ns-3 two-ray and Nakagami channels.',
    results: { href: RESULTS + 'grid/', label: 'MANET grid results' },
    read: { href: GUIDE + 'network-regimes/', label: 'Network regimes: the ad hoc field' },
  },
  {
    id: 'mesh', title: 'Static Wi-Fi mesh', sprite: 'tower', speed: 0.25,
    blurb: 'A community mesh: nothing moves. Every link that exists stays. Watch what the ants keep spending once the routes are found.',
    honest: 'Teaching radio: unit disk, 250 m range.',
    results: { href: RESULTS + 'static-mesh/', label: 'Static mesh results' },
    read: { href: GUIDE + 'network-regimes/', label: 'Network regimes: a mesh that never moves' },
  },
  {
    id: 'fanet', title: 'FANET: a drone swarm', speed: 1,
    blurb: '20 drones flying a 3-D Gauss–Markov pattern at about 20 m/s. Links last seconds, not minutes. Altitude is shown as size and shade.',
    honest: 'Teaching radio: 3-D unit disk, 300 m range. The measured FANET results use ns-3 with 3-D Gauss–Markov mobility.',
    results: { href: RESULTS + 'scenarios/fanet/', label: 'FANET results' },
    read: { href: GUIDE + 'network-regimes/', label: 'Network regimes: links that last seconds' },
  },
  {
    id: 'vanet', title: 'VANET: cars in a city', speed: 1,
    blurb: '30 vehicles on a Manhattan street grid. Buildings block the radio, so a link dies the moment a car turns a corner.',
    honest: 'Teaching radio: unit disk cut by buildings. The measured VANET results use ns-3 two-ray plus building shadowing.',
    results: { href: RESULTS + 'scenarios/vanet/', label: 'VANET results' },
    read: { href: GUIDE + 'network-regimes/', label: 'Network regimes: links cut by buildings' },
  },
  {
    id: 'satellite', title: 'Satellites: a Walker constellation', speed: 1,
    blurb: '64 satellites in 8 orbital planes, 1200 km up at 53°. Satellites in one plane share an orbit (a ring); the planes are turned 45° apart, so each ring is a different orbit. Every satellite keeps four +grid links — ahead and behind in its plane, and to the same slot in the next planes — and their delay changes as the orbits move.',
    honest: 'Teaching orbits: one revolution takes 120 s, about 55× faster than a real 1200 km orbit (109 min), so you can see it move; link delay is the real distance at light speed (≈19 ms in-plane). The measured results use ns-3 LEO mobility (walker16, Starlink shell 1).',
    results: { href: RESULTS + 'satellite/leo-walker/', label: 'Moving-constellation results' },
    read: { href: GUIDE + 'network-regimes/', label: 'Network regimes: why satellites differ' },
  },
];
export const worldById = (id) => WORLDS.find((w) => w.id === id) || WORLDS[1];
