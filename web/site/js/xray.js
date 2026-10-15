// The X-ray (#637): an ant in flight as the core's own codec sees it. The
// adapter keeps a copy of the last few hundred serialized ants (World.antBytes,
// a read-only ring: nothing decides on it, and the parity trace is unchanged);
// the fields shown are those bytes decoded by core::codec (decodeAnt), and
// web/test/xray.test.mjs holds a native build of the codec to the same fields.
// Each byte range is coloured per field and named after the frame layout in
// docs/wire-format.md.
import { t, num } from './i18n.js';

const WIRE = 'docs/wire-format/#frame-layout-current-code';
const CODEC = 'api/namespaceanthocnet_1_1core_1_1codec.html';
const HOP = 12; // int32 node + double

/** The frame's byte ranges, read from the bytes themselves (counts are u16 LE). */
export function segments(bytes) {
  const out = [];
  let at = 0;
  const take = (key, n, index) => { out.push({ key, from: at, to: at + n, index }); at += n; };
  for (const [key, n] of [['version', 1], ['type', 1], ['direction', 1], ['src', 4], ['dst', 4],
    ['seqNum', 4], ['timeStart', 8], ['lifeAnt', 8], ['broadcastBudget', 4]]) take(key, n);
  for (const list of ['visited', 'history', 'helloDests']) {
    if (at + 2 > bytes.length) break;
    const n = bytes[at] | (bytes[at + 1] << 8);
    take(`${list}Count`, 2);
    for (let k = 0; k < n; k++) take(list, HOP, k);
  }
  return out;
}

const hex = (b) => b.toString(16).padStart(2, '0');
const TYPE = { 1: 'hello', 2: 'reactive', 4: 'proactive', 8: 'repair', 16: 'linkfail' };

/** The X-ray of transmission `id` in world `w`, into `box`. Returns false if gone. */
export function renderAnt(M, w, id, box, openApi) {
  const bytes = w.antBytes(id);
  box.replaceChildren();
  const el = (tag, attrs = {}, ...kids) => {
    const e = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs)) {
      if (k === 'class') e.className = v;
      else if (k.startsWith('on')) e.addEventListener(k.slice(2), v);
      else e.setAttribute(k, v);
    }
    for (const k of kids) if (k !== null && k !== undefined) e.append(k);
    return e;
  };
  if (!bytes.length) { box.append(el('p', { class: 'muted small' }, t('xray.gone'))); return false; }
  const f = JSON.parse(M.decodeAnt(bytes));
  if (!f.ok) { box.append(el('p', { class: 'muted small' }, t('xray.bad'))); return false; }
  const segs = segments(bytes);
  const dir = f.direction === 18 ? 'backward' : 'forward';
  box.append(el('p', {}, el('strong', {}, t('xray.title', { id })), ' · ',
    t(`xray.type.${TYPE[f.type] || 'unknown'}`), ' · ', t(`xray.dir.${dir}`), ' · ', t('xray.bytes', { n: bytes.length })));
  // The fields, decoded by the core.
  const path = (list) => (list.length ? list.map(([n]) => 'n' + n).join(' → ') : '—');
  const rows = [
    ['src', 'n' + f.src], ['dst', f.dst < 0 ? '—' : 'n' + f.dst], ['seqNum', f.seqNum],
    ['timeStart', `${num(f.timeStart, 3)} s`], ['lifeAnt', `${num(f.lifeAnt, 3)} s`], ['broadcastBudget', f.broadcastBudget],
    ['visited', path(f.visited)], ['history', path(f.history)],
    ['helloDests', f.helloDests.length ? f.helloDests.map(([n, p]) => `n${n}: ${num(p, 3)}`).join(' · ') : '—'],
  ];
  box.append(el('table', { class: 'ph xray-fields' },
    el('caption', {}, t('xray.fieldsCaption')),
    el('tbody', {}, ...rows.map(([k, v]) => el('tr', {}, el('th', { scope: 'row' }, el('span', { class: `xr-sw xr-${k}`, 'aria-hidden': 'true' }), el('code', {}, k)), el('td', {}, String(v)))))));
  // The bytes, coloured per field.
  const pre = el('p', { class: 'xray-bytes', tabindex: '0', 'aria-label': t('xray.bytesLabel') });
  for (const s of segs) {
    const key = s.key.replace(/Count$/, '');
    const span = el('span', { class: `xr xr-${key}`, title: `${s.key}${s.index !== undefined ? ` [${s.index}]` : ''}: ${t('xray.offset', { from: s.from, to: s.to - 1 })}` });
    span.textContent = Array.from(bytes.slice(s.from, s.to), hex).join(' ');
    pre.append(span, ' ');
  }
  box.append(pre);
  const api = el('a', { href: CODEC, onclick: (e) => { if (openApi) { e.preventDefault(); openApi(CODEC, 'core::codec'); } } }, 'core::codec →');
  box.append(el('p', { class: 'small' }, el('a', { href: WIRE }, t('xray.wire')), ' · ', api));
  box.append(el('p', { class: 'muted small' }, t('xray.note')));
  return true;
}
