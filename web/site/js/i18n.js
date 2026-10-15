// The site's string layer (#622). Every user-visible word lives in
// i18n/<lang>.json; code asks for it by key. English is the fallback for a
// key a translation lacks (web/tools/i18n-check.py keeps that list empty).
// The choice is per viewer: localStorage 'ahn-lang', else the browser's
// languages, else English. Text only: nothing here reaches the core.

export const LANGS = Object.freeze({ en: 'English', 'pt-BR': 'Português (Brasil)' });

let lang = 'en';
let dict = {};
let fallback = {};

function store(op, value) {
  try {
    if (op === 'get') return localStorage.getItem('ahn-lang');
    localStorage.setItem('ahn-lang', value);
  } catch { /* storage blocked: the browser's language decides */ }
  return null;
}

function pick() {
  const saved = store('get');
  if (saved && LANGS[saved]) return saved;
  for (const l of navigator.languages || [navigator.language || 'en']) {
    if (/^pt\b/i.test(l)) return 'pt-BR';
    if (/^en\b/i.test(l)) return 'en';
  }
  return 'en';
}

async function fetchJson(name) {
  const r = await fetch(new URL(`../i18n/${name}.json`, import.meta.url));
  if (!r.ok) throw new Error(`i18n/${name}.json: HTTP ${r.status}`);
  return r.json();
}

/** Load the chosen language (and English under it), then translate the page. */
export async function initI18n(root = document) {
  lang = pick();
  fallback = await fetchJson('en');
  dict = lang === 'en' ? fallback : await fetchJson(lang).catch(() => fallback);
  document.documentElement.lang = lang;
  applyDom(root);
  return lang;
}

export function currentLang() { return lang; }

/** Use already-loaded strings (Node tests read the JSON files themselves). */
export function useStrings(strings, english = strings, code = 'en') {
  dict = strings;
  fallback = english;
  lang = code;
}

/** Persist a choice and reload, so every string is drawn again in it. */
export function setLang(l) {
  if (!LANGS[l] || l === lang) return;
  store('set', l);
  location.reload();
}

function lookup(d, key) {
  let v = d;
  for (const part of key.split('.')) {
    if (v == null || typeof v !== 'object') return undefined;
    v = v[part];
  }
  return v;
}

/** A number in the page's language: num(1234.5, 1) is "1,234.5" or "1.234,5". */
export function num(x, digits = 0) {
  return new Intl.NumberFormat(lang, { minimumFractionDigits: digits, maximumFractionDigits: digits }).format(x);
}

function fill(s, vars) {
  if (!vars) return s;
  return s.replace(/\{(\w+)\}/g, (m, k) => (k in vars ? String(vars[k]) : m));
}

/**
 * The text for `key`, with {name} placeholders filled from `vars`. A value
 * that is a list (hints) comes back as a list. An unknown key comes back as
 * the key itself, so a missing string is visible rather than blank.
 */
export function t(key, vars) {
  let v = lookup(dict, key);
  if (v === undefined) v = lookup(fallback, key);
  if (v === undefined) return key;
  if (Array.isArray(v)) return v.map((s) => fill(s, vars));
  return fill(v, vars);
}

/** True when `key` has text (in this language or in English). */
export function has(key) {
  return lookup(dict, key) !== undefined || lookup(fallback, key) !== undefined;
}

/**
 * Give a data object getters for its text: localized(obj, 'world.manet',
 * ['title', 'blurb']) makes obj.title read t('world.manet.title'). Data
 * files keep their shape; their words move to the language files.
 */
export function localized(obj, prefix, fields) {
  for (const f of fields) {
    Object.defineProperty(obj, f, { get: () => t(`${prefix}.${f}`), enumerable: true, configurable: true });
  }
  return obj;
}

/**
 * Translate marked markup: data-i18n (text), data-i18n-html (trusted markup
 * from our own files), data-i18n-attr="title:key;aria-label:key".
 */
export function applyDom(root = document) {
  for (const el of root.querySelectorAll('[data-i18n]')) el.textContent = t(el.dataset.i18n);
  for (const el of root.querySelectorAll('[data-i18n-html]')) el.innerHTML = t(el.dataset.i18nHtml);
  for (const el of root.querySelectorAll('[data-i18n-attr]')) {
    for (const pair of el.dataset.i18nAttr.split(';')) {
      const [attr, key] = pair.split(':');
      if (attr && key) el.setAttribute(attr.trim(), t(key.trim()));
    }
  }
}
