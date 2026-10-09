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

const supported = (v) => { const m = /^3\.(\d+)$/.exec(v || ''); return m && +m[1] >= 36 && +m[1] <= 48; };

export const STEPS = [
  {
    id: 'tree', title: 'An ns-3 tree to install into', cmd: 'make doctor',
    status(d) {
      if (!d) return ['todo', 'Run make doctor NS3DIR=/path/to/ns-3 and paste its output.'];
      if (d.ns3 === 'unknown' || d.contrib === 'missing') return ['fail', 'That path is not an ns-3 tree (no contrib/ or CMakeLists.txt).'];
      if (!supported(d.ns3)) return ['warn', `ns-3 ${d.ns3}: outside the tested range 3.36–3.48.`];
      if (d.contrib !== 'writable') return ['fail', 'contrib/ is not writable: install copies into it.'];
      return ['ok', `ns-3 ${d.ns3}, contrib/ writable.`];
    },
  },
  {
    id: 'tools', title: 'A toolchain: CMake, a C++17 compiler, Python', cmd: 'make doctor',
    status(d) {
      if (!d) return ['todo', 'make doctor checks these too.'];
      const missing = ['cmake', 'cxx', 'python'].filter((k) => !d[k] || d[k] === 'missing');
      if (missing.length) return ['fail', `Missing: ${missing.join(', ')}.`];
      return ['ok', `CMake ${d.cmake}, ${d.cxx}, Python ${d.python}.`];
    },
  },
  {
    id: 'install', title: 'AntHocNet in contrib/', cmd: 'make install-ns3',
    status(d) {
      if (!d) return ['todo', 'make install-ns3 NS3DIR=… (add BASELINES=0 for AntHocNet alone), then make doctor again.'];
      if (d.module !== 'installed') return ['todo', 'Not installed yet: make install-ns3 NS3DIR=…'];
      const miss = Object.entries(d.baselineMap).filter(([, s]) => s !== 'ok').map(([k]) => k);
      return miss.length ? ['ok', `Installed, without ${miss.join(', ')}: the comparison harnesses are skipped (BASELINES=0).`]
                         : ['ok', 'Installed, with the comparison modules.'];
    },
  },
  {
    id: 'build', title: 'Built', cmd: './ns3 build',
    status(d) {
      if (!d || d.module !== 'installed') return ['todo', './ns3 configure --enable-examples --enable-tests && ./ns3 build'];
      return d.built === 'yes' ? ['ok', 'The module library is built.'] : ['todo', 'Configure and build, then make doctor again.'];
    },
  },
  {
    id: 'test', title: 'The test suite passes', cmd: './test.py -s anthocnet',
    status(d, t) {
      if (t && testsFailed(t)) return ['fail', 'The anthocnet test suite failed: check the build log, or open an issue with the output.'];
      if (t && testsPassed(t)) return ['ok', 'Header round-trip and multi-hop delivery: PASS.'];
      return ['todo', 'Run ./test.py -s anthocnet and paste its output.'];
    },
  },
];
