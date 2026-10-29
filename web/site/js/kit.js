// Take it to ns-3 (#640): any world or level as a ready-to-run ns-3 kit. The
// game is the AntHocNet core on a teaching radio; this writes the scene --
// where every node was over the run, and the flows -- in the formats
// routing-compare replays (#639: --mobility=trace --traceFile, --flowsFile),
// with the command, so the same scene runs on ns-3's PHY and MAC. Built in
// the browser; nothing is uploaded. No DOM here: web/tools/export-kit.mjs
// builds the very same kit in Node for CI.
import { t } from './i18n.js';

/** Simulated seconds between position samples. */
export const SAMPLE_STEP = 0.5;
/** Samples kept (10 minutes at 0.5 s); a longer run exports its first 10. */
export const MAX_SAMPLES = 1200;
/** routing-compare's CBR packet size (bytes), so cbrBps = rate x 512. */
const PACKET_BYTES = 64;
const CHANNEL = ['disk', 'urban', 'isl'];

/** Records where every node is, every SAMPLE_STEP of simulated time. */
export class KitRecorder {
  constructor() { this.reset(); }
  reset() { this.samples = []; this.next = 0; }
  /** Call after every advance; samples each step boundary the clock passed. */
  tick(w) {
    const now = w.now();
    while (this.next <= now + 1e-9 && this.samples.length < MAX_SAMPLES) {
      this.samples.push({ t: this.next, pos: Array.from(w.positions()) });
      this.next += SAMPLE_STEP;
    }
  }
}

const fmt = (x) => String(Number(x.toPrecision(10)));

/** The ns-2 movement trace: start positions, then one setdest per leg. */
export function movements(samples, nodeCount) {
  const out = ['# AntHocNet learn-site export (#640): ns-2 movement trace, 2-D, one leg per 0.5 s sample']; // i18n-ok: a file-format comment
  if (!samples.length) return out.join('\n') + '\n';
  const first = samples[0].pos;
  for (let i = 0; i < nodeCount; i++) {
    // A node built mid-run is placed where it first appears, from t = 0.
    const s = samples.find((x) => 4 * i + 3 < x.pos.length) || samples[0];
    const p = 4 * i < first.length ? first : s.pos;
    out.push(`$node_(${i}) set X_ ${fmt(p[4 * i])}`, `$node_(${i}) set Y_ ${fmt(p[4 * i + 1])}`, `$node_(${i}) set Z_ 0`);
  }
  for (let k = 0; k + 1 < samples.length; k++) {
    const a = samples[k], b = samples[k + 1];
    for (let i = 0; i < nodeCount; i++) {
      if (4 * i + 1 >= a.pos.length || 4 * i + 1 >= b.pos.length) continue;
      const dx = b.pos[4 * i] - a.pos[4 * i], dy = b.pos[4 * i + 1] - a.pos[4 * i + 1];
      const d = Math.hypot(dx, dy);
      if (d < 1e-6) continue;
      out.push(`$ns_ at ${fmt(a.t)} "$node_(${i}) setdest ${fmt(b.pos[4 * i])} ${fmt(b.pos[4 * i + 1])} ${fmt(d / (b.t - a.t))}"`);
    }
  }
  return out.join('\n') + '\n';
}

/** The flows as routing-compare's --flowsFile: src dst start stop cbrBps. */
export function flowsFile(specs, horizon) {
  const out = ['# src dst start stop cbrBps (AntHocNet learn-site export, #640)']; // i18n-ok: a file-format comment
  for (let i = 0; i < specs.length; i += 5) {
    const [src, dst, rate, start, stop] = specs.slice(i, i + 5);
    if (start >= horizon) continue;
    out.push(`${src} ${dst} ${fmt(start)} ${fmt(Math.min(stop, horizon))} ${fmt(rate * PACKET_BYTES * 8)}`);
  }
  return out.join('\n') + '\n';
}

/** Where the measured pages live (the README is read outside the site). */
const SITE = 'https://danieljoppi.github.io/AntHocNet/';

/**
 * A scene from a running world and its recorder. `opts`: { worldId, seed,
 * title, results: { href, label } | null (the world's results page), attrs,
 * custom: true for a campaign level or an edited world, ranges: per-node radio
 * ranges differ }.
 */
export function sceneFrom(w, recorder, opts) {
  const notes = [];
  if (opts.ranges) notes.push(t('kit.oneRange', { range: w.range() }));
  if (w.areaZ() > 0 && w.channel() !== 2) notes.push(t('kit.flat'));
  return {
    title: opts.title, worldId: opts.worldId, seed: opts.seed, channel: w.channel(),
    areaX: w.areaX(), areaY: w.areaY(), range: w.range(), blocksX: w.blocksX(), blocksY: w.blocksY(),
    streetWidth: w.streetWidth(), nodeCount: w.nodeCount(), specs: Array.from(w.flowSpecs()),
    samples: recorder.samples, attrs: opts.attrs || '',
    published: !opts.custom && opts.seed === 1 && opts.results ? { label: opts.results.label, href: SITE + opts.results.href } : null,
    notes,
  };
}

/**
 * The kit for a scene. `scene`: { name, title, worldId (built-in world id or
 * 'level'), seed, channel (int), areaX, areaY, range, blocksX, blocksY,
 * streetWidth, nodeCount, specs (flowSpecs), samples, attrs (bench flags),
 * published: { href, label } | null, notes: [strings] }. Returns
 * { files: { name: text }, command }.
 */
export function buildKit(scene) {
  const horizon = scene.samples.length ? scene.samples.at(-1).t : 0;
  const time = Math.max(10, Math.floor(horizon));
  const kind = CHANNEL[scene.channel] || 'disk';
  let command;
  if (kind === 'isl') {
    // Satellites: the moving shell is leo-walker's (ns-3 >= 3.48), the shape of
    // the game's constellation; its flows are leo-walker's ground-station pairs.
    // 64 satellites are sparse for its cities at the default 25 deg mask (Sao
    // Paulo never sees one), so the kit lowers it to 10 deg.
    command = `./ns3 run "leo-walker --planes=8 --sats=8 --phasing=1 --altitude=1200 --inclination=53 --minElevation=10 --time=${time} --runs=1 --protocols=anthocnet,aodv,oracle${scene.attrs ? ' ' + scene.attrs : ''}"`;
  } else {
    const areaX = Math.ceil(scene.areaX), areaY = Math.ceil(scene.areaY);
    const channel = kind === 'urban'
      ? `--propagation=urban --blocksX=${scene.blocksX} --blocksY=${scene.blocksY} --streetWidth=${fmt(scene.streetWidth)}`
      : '--propagation=range';
    command = `./ns3 run "routing-compare --protocols=anthocnet,aodv,olsr --time=${time} --runs=1 `
      + `--areaX=${areaX} --areaY=${areaY} --range=${fmt(scene.range)} ${channel} `
      + `--mobility=trace --traceFile=$KIT/mobility.ns_movements --flowsFile=$KIT/flows.txt${scene.attrs ? ' ' + scene.attrs : ''}"`;
  }
  const files = {};
  if (kind !== 'isl') {
    files['mobility.ns_movements'] = movements(scene.samples, scene.nodeCount);
    files['flows.txt'] = flowsFile(scene.specs, horizon);
  }
  files['run.sh'] = [
    '#!/usr/bin/env bash', // i18n-ok: a shell script
    `# ${scene.title}: the AntHocNet learn-site scene, on ns-3 (#640).`, // i18n-ok: a shell script
    '# Usage: NS3DIR=/path/to/ns-3 bash run.sh   (AntHocNet installed in contrib/; see README.md)', // i18n-ok: a shell script
    'set -euo pipefail', // i18n-ok: a shell script
    'KIT=$(cd "$(dirname "$0")" && pwd)',
    'cd "${NS3DIR:?set NS3DIR to your ns-3 tree}"',
    command,
    '',
  ].join('\n');
  files['README.md'] = readme(scene, kind, command, time);
  return { files, command };
}

function readme(scene, kind, command, time) {
  const r = (k, v) => t(`kit.readme.${k}`, v);
  const L = [`# ${r('title', { title: scene.title })}`, '', r('from', { world: scene.worldId, seed: scene.seed, time }), r('intro'), '',
    `## ${r('runH')}`, '', `1. ${r('step1')}`, `   - ${r('step1a')}`, `   - ${r('step1b')}`, `   - ${r('step1c')}`,
    `2. ${r('step2')}`, `3. ${r('step3')}`, '', r('cmdIntro'), '', '```bash', command.replace(/\$KIT\//g, ''), '```', '',
    `## ${r('filesH')}`, ''];
  if (kind === 'isl') L.push(`- ${r('sat')}`);
  else L.push(`- ${r('mobility')}`, `- ${r('flows')}`, `- ${r('run')}`);
  if (scene.attrs) L.push(`- ${r('attrs', { attrs: scene.attrs })}`);
  L.push('', `## ${r('whyH')}`, '', r('why'), '', `- ${r('disk')}`, `- ${r('mac')}`, `- ${r('queue')}`, `- ${r('core')}`);
  for (const n of scene.notes || []) L.push(`- ${n}`);
  L.push('');
  if (scene.published) L.push(`## ${r('publishedH')}`, '', r('published', { label: scene.published.label, href: scene.published.href }), '');
  return L.join('\n');
}

// --- a zip, by hand (stored, no compression): small enough not to need a library.
const CRC = (() => {
  const t = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    t[n] = c >>> 0;
  }
  return t;
})();
function crc32(bytes) {
  let c = 0xffffffff;
  for (const b of bytes) c = CRC[(c ^ b) & 0xff] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
}

/** A .zip (stored) of { name: text } under `dir/`; returns a Uint8Array. */
export function zip(files, dir) {
  const enc = new TextEncoder();
  const parts = [], central = [];
  let offset = 0;
  const u16 = (v) => [v & 0xff, (v >>> 8) & 0xff];
  const u32 = (v) => [v & 0xff, (v >>> 8) & 0xff, (v >>> 16) & 0xff, (v >>> 24) & 0xff];
  for (const [name, text] of Object.entries(files)) {
    const data = enc.encode(text), path = enc.encode(`${dir}/${name}`), crc = crc32(data);
    const common = [...u16(20), ...u16(0x0800), ...u16(0), ...u16(0), ...u16(0x21), ...u32(crc), ...u32(data.length), ...u32(data.length), ...u16(path.length), ...u16(0)];
    const local = Uint8Array.from([...u32(0x04034b50), ...common, ...path]);
    parts.push(local, data);
    const mode = name.endsWith('.sh') ? 0o100755 : 0o100644;
    central.push(Uint8Array.from([...u32(0x02014b50), ...u16(0x0314), ...common, ...u16(0), ...u16(0), ...u16(0), ...u32((mode << 16) >>> 0), ...u32(offset), ...path]));
    offset += local.length + data.length;
  }
  const size = central.reduce((a, c) => a + c.length, 0);
  const end = Uint8Array.from([...u32(0x06054b50), ...u16(0), ...u16(0), ...u16(central.length), ...u16(central.length), ...u32(size), ...u32(offset), ...u16(0)]);
  const all = [...parts, ...central, end];
  const out = new Uint8Array(all.reduce((a, p) => a + p.length, 0));
  let at = 0;
  for (const p of all) { out.set(p, at); at += p.length; }
  return out;
}
