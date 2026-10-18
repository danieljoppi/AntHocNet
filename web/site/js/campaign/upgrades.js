// Upgrades (#579, learn-campaign.md §4): each is a real default-off mechanism
// in core/, switched on as a labelled, mission-scoped knob -- never a world
// default (ADR-0019). An upgrade exists here only if its Config key or metric
// exists in the core; the text (what it does, what the v2.3.0 campaign
// measured) is i18n keys upgrade.<id>.{name,what,measured}. Quiet mode (#571)
// was the chapter 2 upgrade until v2.3.0's campaign moved it on by default:
// it is now the world default, not an upgrade.

import { t } from '../i18n.js';

const LIGHT = 299792458;  // m/s

export const UPGRADES = [
  // #574 + ADR-0025: hellos carry kinematics; a next hop is discounted by its
  // predicted remaining link lifetime, at the level's radio range.
  { id: 'lookahead', issue: 574, unlock: '3.3', helps: [3, 4],
    apply: (w, level) => {
      w.setConfig('shareKinematics', 1);
      w.setConfig('enableLinkLifetime', 1);
      w.setConfig('linkLifetimeRange', level.world.range ?? 250);
    } },
  // #145: the energy-aware link metric, priced from each node's battery.
  { id: 'battery', issue: 145, unlock: '4.2', helps: [4], apply: (w) => { if (!w.setLinkMetric('energy')) throw new Error('no energy metric in this core'); } },  // i18n-ok: a build error
  // #205: T_hop = the shell's in-plane ISL propagation delay, not Wi-Fi's 3 ms.
  { id: 'longhaul', issue: 205, unlock: '5.2', helps: [5], only: (level) => !!level.world.shell,
    apply: (w, level, radius) => {
      const s = level.world.shell.slots;
      w.setConfig('hopTimeSec', 2 * radius * Math.sin(Math.PI / s) / LIGHT);
    } },
];

/** The upgrades this player has earned (their unlock level cleared). */
export function unlockedUpgrades(progress) {
  return UPGRADES.filter((u) => (progress[u.unlock] || 0) > 0);
}

/** The upgrades a level can offer: earned, and meaningful in its world. */
export function upgradesFor(level, progress) {
  return unlockedUpgrades(progress).filter((u) => !u.only || u.only(level));
}

/** Switch the chosen upgrades on in a world that has not started. */
export function applyUpgrades(w, level, ids, shellRadius) {
  for (const u of UPGRADES) if (ids.includes(u.id) && (!u.only || u.only(level))) u.apply(w, level, shellRadius);
}

// Per level, which upgrades the player switched on (per browser).
const STORE = 'ahn-upgrades-v1';
export function loadChoices() {
  try { return JSON.parse(localStorage.getItem(STORE) || '{}'); } catch { return {}; }
}
export function saveChoice(levelId, ids) {
  const all = loadChoices();
  all[levelId] = ids;
  try { localStorage.setItem(STORE, JSON.stringify(all)); } catch { /* storage blocked: choices last this visit */ }
}

export const upgradeName = (u) => t(`upgrade.${u.id}.name`);
