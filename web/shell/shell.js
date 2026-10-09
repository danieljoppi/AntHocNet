// The site shell's behaviour (#627): day/night shared through the 'ahn-theme'
// key, and search over the docs' own index (mkdocs writes
// docs/search/search_index.json). Loaded by the docs and the API reference;
// the game runs the same search through this module and keeps its own theme
// button handler (app.js), which writes the same key.
//
// Plain ES module, no dependencies; every storage access is guarded.

const store = {
  get(k) { try { return localStorage.getItem(k); } catch { return null; } },
  set(k, v) { try { localStorage.setItem(k, v); } catch { /* private mode */ } },
};

function prefersDark() {
  return matchMedia('(prefers-color-scheme: dark)').matches;
}

/** Apply day/night to a docs or API page: html[data-theme] for the shell and
 *  our API stylesheet, and Material's own scheme attribute for the docs. */
export function applyTheme(t) {
  const html = document.documentElement;
  if (t) html.dataset.theme = t; else delete html.dataset.theme;
  const night = t ? t === 'dark' : prefersDark();
  html.dataset.night = night ? '1' : '0';
  if (document.body && document.body.hasAttribute('data-md-color-scheme')) {
    document.body.setAttribute('data-md-color-scheme', night ? 'slate' : 'default');
  }
  const btn = document.getElementById('theme');
  if (btn) btn.textContent = night ? '☀' : '☾';
}

export function initTheme() {
  const saved = store.get('ahn-theme');
  applyTheme(saved === 'light' || saved === 'dark' ? saved : null);
  const btn = document.getElementById('theme');
  if (btn) btn.addEventListener('click', () => {
    const night = document.documentElement.dataset.theme
      ? document.documentElement.dataset.theme === 'dark' : prefersDark();
    const next = night ? 'light' : 'dark';
    store.set('ahn-theme', next);
    applyTheme(next);
  });
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change',
    () => applyTheme(document.documentElement.dataset.theme || null));
}

// --- search ------------------------------------------------------------------
const PLACE_OF = [
  [/^benchmarks|^places\/lab/, 'Lab'],
  [/^(configuration|wire-format|porting-notes|ns2-support|cross-validation)|^places\/workshop/, 'Workshop'],
  [/^(adr|handoffs|publications|roadmap|research-landscape|learn-campaign|fidelity|satellite-routing)|^places\/archive/, 'Archive'],
];
export function placeOf(location) {
  for (const [re, name] of PLACE_OF) if (re.test(location)) return name;
  return 'Field guide';
}

let index = null;
async function loadIndex(root) {
  if (!index) {
    index = fetch(`${root}docs/search/search_index.json`).then((r) => r.json())
      .then((j) => j.docs.filter((d) => d.location && d.title));
  }
  return index;
}

// The index holds HTML (and escaped HTML inside code): drop tags, then decode
// entities twice so '&amp;lt;' in a code block reads as '<' too.
const decoder = typeof document !== 'undefined' ? document.createElement('textarea') : null;
function decode(s) {
  if (!decoder) return s;
  for (let i = 0; i < 2; i++) { decoder.innerHTML = s; s = decoder.value; }
  return s;
}
const strip = (html) => decode(html.replace(/<[^>]+>/g, ' ')).replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();

/** Rank docs sections for a query: every term must appear; title hits
 *  outweigh body hits; whole pages beat their own sections on ties. */
export async function search(root, q, limit = 8) {
  const terms = q.toLowerCase().split(/\s+/).filter((t) => t.length > 1);
  if (!terms.length) return [];
  const docs = await loadIndex(root);
  const hits = [];
  for (const d of docs) {
    const title = d.title.toLowerCase();
    const text = (d.text || '').toLowerCase();
    let score = 0;
    let all = true;
    for (const t of terms) {
      const inTitle = title.includes(t);
      const inText = text.includes(t);
      if (!inTitle && !inText) { all = false; break; }
      score += (inTitle ? 10 : 0) + (inText ? 1 : 0);
    }
    if (!all) continue;
    if (!d.location.includes('#')) score += 0.5;
    const plain = strip(d.text || '');
    const at = plain.toLowerCase().indexOf(terms[0]);
    const snippet = at < 0 ? plain.slice(0, 120) : plain.slice(Math.max(0, at - 40), at + 100);
    hits.push({ score, title: strip(d.title), location: d.location, snippet });
  }
  hits.sort((a, b) => b.score - a.score);
  return hits.slice(0, limit);
}

/** Wire the top bar's search box to a dropdown of results. `open` decides
 *  what a click does (the game opens the in-game reader; pages navigate). */
export function initSearch(open) {
  const form = document.querySelector('.ahn-search');
  if (!form) return;
  const root = form.dataset.root || './';
  const input = form.querySelector('input');
  const list = form.querySelector('.ahn-results');
  let seq = 0;
  const hide = () => { list.hidden = true; };
  input.addEventListener('input', async () => {
    const my = ++seq;
    const q = input.value.trim();
    if (q.length < 2) { hide(); return; }
    let hits;
    try { hits = await search(root, q); } catch { hits = []; }
    if (my !== seq) return;
    list.replaceChildren(...(hits.length ? hits : [null]).map((h) => {
      const li = document.createElement('li');
      if (!h) { li.innerHTML = '<small>No page mentions that.</small>'; return li; }
      const a = document.createElement('a');
      a.href = `${root}docs/${h.location}`;
      a.innerHTML = '<span class="ahn-place-tag"></span><b></b><small></small>';
      a.querySelector('.ahn-place-tag').textContent = placeOf(h.location);
      a.querySelector('b').textContent = ' ' + h.title;
      a.querySelector('small').textContent = h.snippet;
      if (open) a.addEventListener('click', (e) => { e.preventDefault(); hide(); open(h.location, h.title); });
      li.append(a);
      return li;
    }));
    list.hidden = false;
  });
  form.addEventListener('submit', (e) => {
    const first = list.querySelector('a');
    if (first) { e.preventDefault(); first.click(); }
  });
  input.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') { hide(); input.blur(); }
    if (e.key === 'ArrowDown') { const a = list.querySelector('a'); if (a) { e.preventDefault(); a.focus(); } }
  });
  document.addEventListener('click', (e) => { if (!form.contains(e.target)) hide(); });
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && document.activeElement === document.body) { e.preventDefault(); input.focus(); }
  });
}

/** The no-script-friendly search page (docs/places/search.md): renders the
 *  results for ?q= into #ahn-search-page. */
export async function initSearchPage() {
  const host = document.getElementById('ahn-search-page');
  const q = new URLSearchParams(location.search).get('q');
  const form = document.querySelector('.ahn-search');
  if (!host || !q || !form) return;
  const root = form.dataset.root || './';
  form.querySelector('input').value = q;
  let hits = [];
  try { hits = await search(root, q, 30); } catch { /* index unavailable */ }
  const ol = document.createElement('ol');
  for (const h of hits) {
    const li = document.createElement('li');
    const a = document.createElement('a');
    a.href = `${root}docs/${h.location}`;
    a.textContent = `${placeOf(h.location)} · ${h.title}`;
    const p = document.createElement('div');
    p.textContent = h.snippet;
    li.append(a, p);
    ol.append(li);
  }
  host.replaceChildren(hits.length ? ol : Object.assign(document.createElement('p'), { textContent: `Nothing matches "${q}".` }));
}

/** Everything a docs or API page needs from the shell, in one call. */
export function initPage() {
  initTheme();
  initSearch();
  initSearchPage();
  // Scrollable tables must be reachable by keyboard (axe scrollable-region-
  // focusable): Material wraps wide tables in a scroll container.
  // Material adds the wrappers from its own script, possibly after this runs.
  const fix = () => {
    for (const el of document.querySelectorAll('.md-typeset__scrollwrap:not([tabindex])')) {
      el.tabIndex = 0;
      el.setAttribute('role', 'region');
      el.setAttribute('aria-label', 'Table (scrolls sideways)');
    }
  };
  fix();
  new MutationObserver(fix).observe(document.body, { childList: true, subtree: true });
}
