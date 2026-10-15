// Offline play (#624). Precaches the game shell -- the two game pages, their
// scripts and styles, the top bar's assets and the WASM core -- so after one
// visit the game loads and runs with the network off. web/site-manifest.py
// fills in the file list and the build id when the site is assembled.
//
// Shell pages, scripts and styles are network-first: online, a visit always
// gets the deployed files (and refreshes the cache), so a deploy is never
// hidden behind a stale copy; offline, the cached copy answers. The core
// (anthocnet.js / .wasm) carries its content hash in the URL, so it is
// cache-first. Everything else -- the docs, the API, search -- is not touched.
const BUILD = '__AHN_BUILD__';
const SHELL = __AHN_SHELL__;
const CACHE = `ahn-game-${BUILD}`;
const scope = new URL(self.registration.scope);
const shellPaths = new Set(SHELL.map((p) => new URL(p, scope).pathname));

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys()
    .then((keys) => Promise.all(keys.filter((k) => k.startsWith('ahn-game-') && k !== CACHE).map((k) => caches.delete(k))))
    .then(() => self.clients.claim()));
});

self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== scope.origin) return;
  const path = url.pathname === scope.pathname ? scope.pathname + 'index.html' : url.pathname;
  if (!shellPaths.has(path)) return;  // docs, API, search: the network, untouched
  if (/anthocnet\.(js|wasm)$/.test(path) && url.search) {
    e.respondWith(caches.match(req).then((hit) => hit || fetch(req)));
    return;
  }
  e.respondWith(fetch(req)
    .then((res) => {
      if (res.ok) { const copy = res.clone(); caches.open(CACHE).then((c) => c.put(new URL(path, scope).href, copy)); }
      return res;
    })
    .catch(() => caches.match(new URL(path, scope).href, { ignoreSearch: true })));
});
