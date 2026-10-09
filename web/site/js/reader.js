// The in-game reader (#630): any docs page in a window over the running world.
// It fetches the same-origin page, keeps the article, rewrites its links and
// images against the page's own URL, and shows it docked to the right. Links
// to other docs pages stay in the reader; everything else opens normally. The
// reader is presentation only: it never touches the simulation (golden rule 9),
// which keeps running underneath.

const $ = (id) => document.getElementById(id);
let current = null; // URL of the page on show
let lastFocus = null;

function shell() {
  let el = $('reader');
  if (el) return el;
  el = document.createElement('aside');
  el.id = 'reader';
  el.className = 'reader window';
  el.setAttribute('role', 'dialog');
  el.setAttribute('aria-modal', 'false');
  el.setAttribute('aria-labelledby', 'readerTitle');
  el.hidden = true;
  el.innerHTML = `
    <div class="titlebar reader-bar">
      <span id="readerTitle">Field guide</span>
      <span class="reader-live" title="The simulation keeps running while you read">the world keeps running</span>
      <a class="bevel reader-out" id="readerOut" href="#" target="_blank" rel="noopener" aria-label="Open the full page">↗</a>
      <button type="button" class="bevel" id="readerClose" aria-label="Close the reader">✕</button>
    </div>
    <div class="reader-body" id="readerBody" tabindex="-1"></div>`;
  document.body.append(el);
  $('readerClose').addEventListener('click', closeReader);
  el.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeReader(); });
  return el;
}

export function closeReader() {
  const el = $('reader');
  if (!el || el.hidden) return;
  el.hidden = true;
  current = null;
  if (lastFocus && document.contains(lastFocus)) lastFocus.focus({ preventScroll: true });
}

export const readerOpen = () => !!$('reader') && !$('reader').hidden;

const isDocsUrl = (u) => u.origin === location.origin && /\/docs\//.test(u.pathname)
  && !/\.(png|svg|jpe?g|csv|txt|json|zip|gz)$/i.test(u.pathname);

/** Open a docs page: `href` is relative to the game page (e.g.
 *  'docs/network-regimes/') or an absolute same-origin URL. */
export async function openReader(href, title) {
  const el = shell();
  const url = new URL(href, location.href);
  if (!el.hidden && current === url.href) return;
  if (el.hidden) lastFocus = document.activeElement;
  current = url.href;
  el.hidden = false;
  const body = $('readerBody');
  $('readerTitle').textContent = title || 'Field guide';
  $('readerOut').href = url.href;
  body.innerHTML = '<p class="muted">Opening…</p>';
  let doc;
  try {
    const res = await fetch(url.href.split('#')[0]);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    doc = new DOMParser().parseFromString(await res.text(), 'text/html');
  } catch (err) {
    body.innerHTML = '';
    const p = document.createElement('p');
    p.append(`Could not open this page here (${err.message}). `);
    const a = Object.assign(document.createElement('a'), { href: url.href, textContent: 'Open it in a new tab →', target: '_blank' });
    p.append(a);
    body.append(p);
    return;
  }
  if (current !== url.href) return; // a newer open won the race
  const article = doc.querySelector('.md-content__inner') || doc.querySelector('main') || doc.body;
  article.querySelectorAll('.headerlink, .md-content__button, script, style').forEach((n) => n.remove());
  // Diagrams are drawn by Material's own script on the full page.
  article.querySelectorAll('pre.mermaid, .mermaid').forEach((n) => {
    const note = document.createElement('p');
    note.className = 'reader-note';
    const a = Object.assign(document.createElement('a'), { href: url.href, target: '_blank', rel: 'noopener', textContent: 'open the full page' });
    note.append('A diagram is drawn here on the full page: ', a, '.');
    n.replaceWith(note);
  });
  // The page's breadcrumb, without its first step (the site root: the reader is already there).
  const steps = [...article.querySelectorAll('.ahn-titlebar .ahn-crumb li')].slice(1);
  if (steps.length) $('readerTitle').textContent = steps.map((li) => li.textContent.trim()).join(' › ');
  article.querySelector('.ahn-titlebar')?.remove();
  for (const img of article.querySelectorAll('img[src]')) img.src = new URL(img.getAttribute('src'), url).href;
  for (const a of article.querySelectorAll('a[href]')) {
    const raw = a.getAttribute('href');
    if (raw.startsWith('#')) { a.href = url.href.split('#')[0] + raw; a.dataset.anchor = raw.slice(1); continue; }
    const target = new URL(raw, url);
    a.href = target.href;
    if (isDocsUrl(target)) {
      a.addEventListener('click', (e) => {
        if (e.ctrlKey || e.metaKey || e.shiftKey || e.button !== 0) return;
        e.preventDefault();
        openReader(target.href);
      });
    } else if (target.origin !== location.origin || !target.pathname.startsWith(new URL('.', location.href).pathname)) {
      a.target = '_blank';
      a.rel = 'noopener';
    }
  }
  for (const a of article.querySelectorAll('a[data-anchor]')) {
    a.addEventListener('click', (e) => {
      e.preventDefault();
      body.querySelector(`[id="${CSS.escape(a.dataset.anchor)}"]`)?.scrollIntoView({ block: 'start' });
    });
  }
  // Code blocks and wide tables scroll sideways: reachable by keyboard.
  for (const n of article.querySelectorAll('pre, table')) n.tabIndex = 0;
  body.replaceChildren(...article.childNodes);
  body.scrollTop = 0;
  const anchor = url.hash.slice(1);
  if (anchor) body.querySelector(`[id="${CSS.escape(decodeURIComponent(anchor))}"]`)?.scrollIntoView({ block: 'start' });
  body.focus({ preventScroll: true });
}

/** Docs links inside the game's own windows open in the reader instead of
 *  leaving the game (the top bar's places still navigate). */
export function interceptDocsLinks(root) {
  root.addEventListener('click', (e) => {
    const a = e.target.closest('a[href]');
    if (!a || e.ctrlKey || e.metaKey || e.shiftKey || e.button !== 0) return;
    if (a.closest('.ahn-bar, #reader, .hub')) return;
    const u = new URL(a.getAttribute('href'), location.href);
    if (!isDocsUrl(u)) return;
    e.preventDefault();
    openReader(u.href, a.textContent.replace(/\s*→\s*$/, ''));
  });
}
