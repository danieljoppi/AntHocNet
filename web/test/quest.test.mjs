// Unit test for the install quest's parser (#636): real `make doctor` output
// (ns3/doctor.sh, as CI runs it) and real `./test.py` lines, no browser.
// Usage: node web/test/quest.test.mjs
import { parseDoctor, testsPassed, testsFailed, STEPS } from '../site/js/install-steps.js';

let failed = 0;
const eq = (name, got, want) => {
  const ok = JSON.stringify(got) === JSON.stringify(want);
  if (!ok) failed++;
  console.log(`${ok ? 'ok  ' : 'FAIL'} ${name}${ok ? '' : `: got ${JSON.stringify(got)}, want ${JSON.stringify(want)}`}`);
};
const states = (doctor, text = '') => STEPS.map((s) => s.status(doctor, text)[0]);

// A full install on a supported tree, before building (doctor's own output).
const full = `ok    ns-3 tree: /opt/ns-3
ok    ns-3 3.42 (tested range 3.36-3.48)
ok    contrib/ is writable
ok    AntHocNet installed in contrib/anthocnet
ok    comparison baselines: aomdv:ok,gpsr:ok,oracle:ok
ok    CMake 3.28.3
ok    C++ compiler g++-13.3.0
ok    python3 3.11.15 (ns-3's ./ns3 driver)
----
verdict: ok
##DOCTOR## v=1 ns3=3.42 cmake=3.28.3 cxx=g++-13.3.0 python=3.11.15 contrib=writable module=installed baselines=aomdv:ok,gpsr:ok,oracle:ok built=no verdict=ok`;
const d = parseDoctor(full);
eq('doctor line parsed', [d.v, d.ns3, d.module, d.built, d.verdict], ['1', '3.42', 'installed', 'no', 'ok']);
eq('baselines parsed', d.baselineMap, { aomdv: 'ok', gpsr: 'ok', oracle: 'ok' });
eq('full install, not built', states(d), ['ok', 'ok', 'ok', 'todo', 'todo']);
eq('built + tests pass', states({ ...d, built: 'yes' }, '[1/1] PASS: TestSuite anthocnet'), ['ok', 'ok', 'ok', 'ok', 'ok']);

// BASELINES=0 install: still a pass, with a note.
const alone = parseDoctor('##DOCTOR## v=1 ns3=3.48 cmake=3.28.3 cxx=g++-13.3.0 python=3.11.15 contrib=writable module=installed baselines=aomdv:missing,gpsr:missing,oracle:missing built=yes verdict=warn');
eq('BASELINES=0 install', states(alone), ['ok', 'ok', 'ok', 'ok', 'todo']);
eq('BASELINES=0 note', /without aomdv, gpsr, oracle/.test(STEPS[2].status(alone)[1]), true);

// Not an ns-3 tree (doctor's fail case).
const bad = parseDoctor('##DOCTOR## v=1 ns3=unknown cmake=3.28.3 cxx=g++-13.3.0 python=3.11.15 contrib=missing module=missing baselines=none built=no verdict=fail');
eq('not a tree', states(bad), ['fail', 'ok', 'todo', 'todo', 'todo']);
// ns-3-dev and an old waf tree.
eq('ns-3-dev warns', STEPS[0].status(parseDoctor('##DOCTOR## v=1 ns3=3-dev contrib=writable'))[0], 'warn');
eq('ns-3.35 warns', STEPS[0].status(parseDoctor('##DOCTOR## v=1 ns3=3.35 contrib=writable'))[0], 'warn');
// A missing compiler.
eq('no compiler', STEPS[1].status(parseDoctor('##DOCTOR## v=1 ns3=3.42 cmake=3.28.3 cxx=missing python=3.11 contrib=writable'))[0], 'fail');
// Test output.
eq('test pass', [testsPassed('[1/1] PASS: TestSuite anthocnet'), testsFailed('[1/1] PASS: TestSuite anthocnet')], [true, false]);
eq('test fail', STEPS[4].status(null, '[1/1] FAIL: TestSuite anthocnet')[0], 'fail');
// Garbage in, nothing out.
eq('no doctor line', parseDoctor('hello'), null);

console.log(failed ? `quest parser: FAIL (${failed})` : 'quest parser: PASS');
process.exit(failed ? 1 : 0);
