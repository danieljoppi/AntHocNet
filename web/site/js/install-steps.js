// The install quest (#636): the ns-3 install guide as steps the game can tick.
// The user pastes command output; parsing is local, nothing is uploaded.
// tools/checks/check-site-links.py checks every step's command appears in the
// install docs (docs/places/workshop.md or ns3/README.md), so the two agree.

/** Parse `make doctor`'s machine-readable line (#605):
 *  ##DOCTOR## v=1 ns3=3.42 cmake=… cxx=… python=… contrib=… module=… baselines=a:ok,… built=… verdict=… */
export function parseDoctor(text) {
  const line = String(text).split(/\r?\n/).find((l) => l.startsWith('##DOCTOR## '));
  if (!line) return null;
  const out = {};
  for (const kv of line.slice(11).trim().split(/\s+/)) {
    const i = kv.indexOf('=');
    if (i > 0) out[kv.slice(0, i)] = kv.slice(i + 1);
  }
  out.baselineMap = Object.fromEntries((out.baselines || '').split(',').filter(Boolean).map((p) => p.split(':')));
  return out;
}

/** `./test.py -s anthocnet` prints "[i/n] PASS: TestSuite anthocnet". */
export const testsPassed = (text) => /PASS: TestSuite anthocnet\b/.test(String(text));
export const testsFailed = (text) => /FAIL: TestSuite anthocnet\b/.test(String(text));

import { localized, t } from './i18n.js';

const supported = (v) => { const m = /^3\.(\d+)$/.exec(v || ''); return m && +m[1] >= 36 && +m[1] <= 48; };

// Step titles and notes are i18n keys quest.<id>.* (#622); the commands stay
// here, where check-site-links.py reads them.
export const STEPS = [
  {
    id: 'tree', cmd: 'make doctor',
    status(d) {
      if (!d) return ['todo', t('quest.tree.note.todo')];
      if (d.ns3 === 'unknown' || d.contrib === 'missing') return ['fail', t('quest.tree.note.notTree')];
      if (!supported(d.ns3)) return ['warn', t('quest.tree.note.untested', { v: d.ns3 })];
      if (d.contrib !== 'writable') return ['fail', t('quest.tree.note.readonly')];
      return ['ok', t('quest.tree.note.ok', { v: d.ns3 })];
    },
  },
  {
    id: 'tools', cmd: 'make doctor',
    status(d) {
      if (!d) return ['todo', t('quest.tools.note.todo')];
      const missing = ['cmake', 'cxx', 'python'].filter((k) => !d[k] || d[k] === 'missing');
      if (missing.length) return ['fail', t('quest.tools.note.missing', { list: missing.join(', ') })];
      return ['ok', t('quest.tools.note.ok', { cmake: d.cmake, cxx: d.cxx, py: d.python })];
    },
  },
  {
    id: 'install', cmd: 'make install-ns3',
    status(d) {
      if (!d) return ['todo', t('quest.install.note.todo')];
      if (d.module !== 'installed') return ['todo', t('quest.install.note.notYet')];
      const miss = Object.entries(d.baselineMap).filter(([, s]) => s !== 'ok').map(([k]) => k);
      return miss.length ? ['ok', t('quest.install.note.without', { list: miss.join(', ') })]
                         : ['ok', t('quest.install.note.ok')];
    },
  },
  {
    id: 'build', cmd: './ns3 build',
    status(d) {
      if (!d || d.module !== 'installed') return ['todo', './ns3 configure --enable-examples --enable-tests && ./ns3 build']; // i18n-ok: a command
      return d.built === 'yes' ? ['ok', t('quest.build.note.ok')] : ['todo', t('quest.build.note.todo')];
    },
  },
  {
    id: 'test', cmd: './test.py -s anthocnet',
    status(d, text) {
      if (text && testsFailed(text)) return ['fail', t('quest.test.note.fail')];
      if (text && testsPassed(text)) return ['ok', t('quest.test.note.ok')];
      return ['todo', t('quest.test.note.todo')];
    },
  },
].map((x) => localized(x, `quest.${x.id}`, ['title']));
