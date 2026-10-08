// One world per network family (#547). A world changes the scenario --
// mobility, channel, size -- never the protocol defaults (ADR-0019). Every
// comparative claim is a link to the measured results page, never a number
// from this teaching radio.
const RESULTS = '../benchmarks/';
export const WORLDS = [
  {
    id: 'line', title: 'Six in a row',
    blurb: 'Six nodes that each hear only their neighbours, and one flow from end to end. The smallest network where routing is a question at all.',
    honest: 'Teaching radio: unit disk, 250 m range, 2 Mbit/s, no collisions.',
    results: null,
  },
  {
    id: 'manet', title: 'Ad hoc MANET (default)',
    blurb: '30 nodes moving by random waypoint over an open field: the network the AntHocNet papers were written for. Links appear and break as nodes move; the ants have to keep up.',
    honest: 'Teaching radio: unit disk, 250 m range. The measured MANET results use ns-3 two-ray and Nakagami channels.',
    results: { href: RESULTS + 'grid/', label: 'MANET grid results' },
  },
  {
    id: 'mesh', title: 'Static Wi-Fi mesh',
    blurb: 'A community mesh: nothing moves. Every link that exists stays. Watch what the ants keep spending once the routes are found.',
    honest: 'Teaching radio: unit disk, 250 m range.',
    results: { href: RESULTS + 'static-mesh/', label: 'Static mesh results' },
  },
  {
    id: 'fanet', title: 'FANET: a drone swarm',
    blurb: '20 drones flying a 3-D Gauss–Markov pattern at about 20 m/s. Links last seconds, not minutes. Altitude is shown as size and shade.',
    honest: 'Teaching radio: 3-D unit disk, 300 m range. The measured FANET results use ns-3 with 3-D Gauss–Markov mobility.',
    results: { href: RESULTS + 'scenarios/fanet/', label: 'FANET results' },
  },
  {
    id: 'vanet', title: 'VANET: cars in a city',
    blurb: '30 vehicles on a Manhattan street grid. Buildings block the radio, so a link dies the moment a car turns a corner.',
    honest: 'Teaching radio: unit disk cut by buildings. The measured VANET results use ns-3 two-ray plus building shadowing.',
    results: { href: RESULTS + 'scenarios/vanet/', label: 'VANET results' },
  },
  {
    id: 'satellite', title: 'Satellites: an ISL grid',
    blurb: 'A 6 × 6 constellation snapshot: every satellite links to its four +grid neighbours, wrapping around like a torus. Links are fixed; delay follows distance.',
    honest: 'Teaching radio: fixed inter-satellite links, 1000 km apart (≈3.3 ms per hop). The measured results use the ns-3 isl-grid harness.',
    results: { href: RESULTS + 'satellite/isl-grid/', label: 'Satellite results' },
  },
];
export const worldById = (id) => WORLDS.find((w) => w.id === id) || WORLDS[1];
