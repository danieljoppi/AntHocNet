// Isometric city-builder renderer for the learn site (#545). The map is the
// world the WASM core simulates, seen at a 2:1 isometric angle: ground tiles,
// roads and buildings, phones / mesh routers / drones / cars / satellites as
// nodes, ants walking the pheromone trails, packets riding the radio beams.
// Moving nodes leave a fading trail and show their heading, so a MANET reads
// as people walking, not as a static plan.
//
// It draws what the core and the adapter report and decides nothing. All art
// is procedural (no image assets); colours come from the CSS tokens so the
// day (light) and night (dark) palettes stay the validated steps.

// Vehicle paints (decoration only, never an identity colour).
const CAR_PAINT = ['#c0392b', '#2e5aa8', '#e8e6df', '#3f4a59', '#d9a21b', '#2f7d5b'];

const KIND_VAR = {
  hello: '--c-hello', reactive: '--c-reactive', backward: '--c-backward',
  proactive: '--c-proactive', repair: '--c-repair', linkfail: '--c-linkfail',
  data: '--c-data',
};

/** Deterministic 0..1 hash of two integers (decoration placement). */
function hash2(i, j) {
  let h = (i * 374761393 + j * 668265263) ^ 0x5bd1e995;
  h = Math.imul(h ^ (h >>> 13), 1274126177);
  return ((h ^ (h >>> 16)) >>> 0) / 4294967296;
}

export class IsoRenderer {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.meta = null;
    this.rot = 0;       // view rotation, quarter turns
    this.zoom = 1;
    this.panX = 0;
    this.panY = 0;
    this.colors = {};
    this.still = window.matchMedia('(prefers-reduced-motion: reduce)').matches; // no rotor spin
    this.refreshColors();
  }

  refreshColors() {
    const cs = getComputedStyle(document.documentElement);
    const v = (n) => cs.getPropertyValue(n).trim();
    const c = {};
    for (const n of ['sky', 'sky-top', 'slab-right', 'phone', 'phone-edge', 'screen', 'trail', 'grass-a', 'grass-b', 'grass-edge', 'road', 'road-mark', 'tree',
      'tree-dark', 'trunk', 'bldg-top', 'bldg-left', 'bldg-right', 'window', 'window-lit',
      'space', 'star', 'tower', 'tower-dark', 'node-off', 'beam', 'ph', 'accent', 'good',
      'critical', 'text', 'text2', 'shadow', 'panel', 'panel-blue']) c[n] = v('--' + n);
    for (const [k, name] of Object.entries(KIND_VAR)) c[k] = v(name);
    c.night = document.documentElement.dataset.theme === 'dark' ||
      (!document.documentElement.dataset.theme && matchMedia('(prefers-color-scheme: dark)').matches);
    this.colors = c;
    this.groundCache = null;
  }

  /** World geometry, read once per world from the WASM World. */
  setWorld(meta) {
    this.meta = meta;
    this.motion = [];
    this.zoom = 1;
    this.panX = 0;
    this.panY = 0;
    this.groundCache = null;
    this.resize();
  }

  resize() {
    const dpr = window.devicePixelRatio || 1;
    const r = this.canvas.getBoundingClientRect();
    this.w = Math.max(1, r.width);
    this.h = Math.max(1, r.height);
    this.dpr = dpr;
    this.canvas.width = Math.round(this.w * dpr);
    this.canvas.height = Math.round(this.h * dpr);
    this.ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    this.groundCache = null;
    this.fit();
  }

  // --- camera ----------------------------------------------------------------
  /** Field size in the rotated frame. */
  dims() {
    const { areaX: W, areaY: H } = this.meta;
    return this.rot % 2 ? [H, W] : [W, H];
  }

  /** World (x, y) -> rotated (u, v). */
  rotate(x, y) {
    const { areaX: W, areaY: H } = this.meta;
    switch (this.rot) {
      case 1: return [y, W - x];
      case 2: return [W - x, H - y];
      case 3: return [H - y, x];
      default: return [x, y];
    }
  }

  unrotate(u, v) {
    const { areaX: W, areaY: H } = this.meta;
    switch (this.rot) {
      case 1: return [W - v, u];
      case 2: return [W - u, H - v];
      case 3: return [v, H - u];
      default: return [u, v];
    }
  }

  fit() {
    if (!this.meta) return;
    const [U, V] = this.dims();
    this.zf = 0.9; // vertical exaggeration of altitude
    const zmax = this.meta.areaZ || 0;
    const pad = 24;
    const top = 40;
    const base = Math.min((this.w - 2 * pad) / (U + V),
      (this.h - top - pad) / ((U + V) / 2 + zmax * this.zf + 40 / 1));
    this.c = base * this.zoom;
    this.ox = this.w / 2 + this.panX - (U - V) * this.c / 2;
    this.oy = top + zmax * this.zf * this.c + this.panY +
      ((this.h - top - pad) - ((U + V) / 2 + zmax * this.zf) * base) / 2 * this.zoom;
    this.groundCache = null;
  }

  /** World (x, y, z) -> screen [px, py]. */
  project(x, y, z = 0) {
    const [u, v] = this.rotate(x, y);
    return [this.ox + (u - v) * this.c, this.oy + (u + v) * this.c / 2 - z * this.zf * this.c];
  }

  /** Screen -> world (x, y) on the ground plane. */
  unproject(px, py) {
    const a = (px - this.ox) / this.c;
    const b = (py - this.oy) * 2 / this.c;
    return this.unrotate((a + b) / 2, (b - a) / 2);
  }

  depth(x, y) { const [u, v] = this.rotate(x, y); return u + v; }

  zoomAt(px, py, factor) {
    const z = Math.min(6, Math.max(0.5, this.zoom * factor));
    const f = z / this.zoom;
    this.panX = (this.panX - (px - this.w / 2)) * f + (px - this.w / 2);
    this.panY = (this.panY - (py - this.h / 2)) * f + (py - this.h / 2);
    this.zoom = z;
    this.fit();
  }

  pan(dx, dy) { this.panX += dx; this.panY += dy; this.fit(); }
  rotateView(dir = 1) { this.rot = (this.rot + 4 + dir) % 4; this.fit(); }
  resetView() { this.zoom = 1; this.panX = 0; this.panY = 0; this.fit(); }

  // --- world kind -------------------------------------------------------------
  get kind() {
    if (!this.meta) return 'field';
    if (this.meta.channel === 2) return 'space';
    if (this.meta.channel === 1) return 'city';
    return this.meta.areaZ > 0 ? 'sky' : 'field';
  }

  /** Where a node's antenna is: the point links and pulses attach to. */
  antenna(pos, i) {
    const x = pos[4 * i], y = pos[4 * i + 1], z = pos[4 * i + 2];
    const [px, py] = this.project(x, y, z);
    const k = this.kind;
    const lift = k === 'field' ? (this.meta.sprite === 'phone' ? 20 : 26) : k === 'city' ? 14 : 4;
    return [px, py - lift * this.spriteScale()];
  }

  /** Node icon size: grows with zoom, within limits, so devices stay legible. */
  spriteScale() { return 1.25 * Math.min(2.2, Math.max(0.8, this.zoom)); }

  /** Index of the node under (px, py), or -1. */
  hit(pos, px, py) {
    let best = -1, bestD = 20 * 20;
    for (let i = 0; i < pos.length / 4; i++) {
      for (const [x, y] of [this.project(pos[4 * i], pos[4 * i + 1], pos[4 * i + 2]), this.antenna(pos, i)]) {
        const d = (x - px) ** 2 + (y - py) ** 2;
        if (d < bestD) { bestD = d; best = i; }
      }
    }
    return best;
  }

  /** Link [a, b] under (px, py), or null (for cutting ISLs). */
  hitLink(pos, links, px, py) {
    let best = null, bestD = 8 * 8;
    for (let k = 0; k < links.length; k += 2) {
      const a = this.antenna(pos, links[k]), b = this.antenna(pos, links[k + 1]);
      if (this.wraps(links[k], links[k + 1], pos)) continue;
      const dx = b[0] - a[0], dy = b[1] - a[1];
      const t = Math.max(0, Math.min(1, ((px - a[0]) * dx + (py - a[1]) * dy) / (dx * dx + dy * dy || 1)));
      const d = (a[0] + t * dx - px) ** 2 + (a[1] + t * dy - py) ** 2;
      if (d < bestD) { bestD = d; best = [links[k], links[k + 1]]; }
    }
    return best;
  }

  wraps(a, b, pos) {
    if (this.meta.channel !== 2) return false;
    return Math.abs(pos[4 * a] - pos[4 * b]) > this.meta.areaX / 2 ||
      Math.abs(pos[4 * a + 1] - pos[4 * b + 1]) > this.meta.areaY / 2;
  }

  // --- motion (what the renderer infers from successive positions) ------------
  /** Track speed, heading and a short footprint trail per node, in sim time. */
  track(pos, simNow) {
    const n = pos.length / 4;
    const step = Math.max(this.meta.areaX, this.meta.areaY) / 70; // footprint spacing (m)
    for (let i = 0; i < n; i++) {
      const x = pos[4 * i], y = pos[4 * i + 1];
      let m = this.motion[i];
      if (!m || simNow < m.t) m = this.motion[i] = { x, y, t: simNow, speed: 0, dx: 0, dy: 0, trail: [] };
      const dx = x - m.x, dy = y - m.y, d = Math.hypot(dx, dy), dt = simNow - m.t;
      if (dt >= 0.25) {
        m.speed = d / dt;
        if (d > 1e-6) { m.dx = dx / d; m.dy = dy / d; }
        m.x = x; m.y = y; m.t = simNow;
      }
      const last = m.trail[m.trail.length - 1];
      if (!last || Math.hypot(x - last[0], y - last[1]) > step) {
        if (last && Math.hypot(x - last[0], y - last[1]) > step * 6) m.trail.length = 0; // a drag or a wrap
        m.trail.push([x, y]);
        if (m.trail.length > 12) m.trail.shift();
      }
    }
  }

  /** Last measured speed of node i (m/s of simulated time). */
  speedOf(i) { return this.motion?.[i]?.speed || 0; }

  // --- drawing ------------------------------------------------------------------
  draw(s) {
    const { ctx, colors: c } = this;
    if (!this.meta) return;
    this.t = s.time || 0;
    this.drawGround();
    const pos = s.positions;
    const n = pos.length / 4;
    if (this.kind !== 'space') this.track(pos, s.simNow || 0);

    // The selected node's radio range: who can hear it right now.
    if (s.selected >= 0 && s.selected < n && this.kind !== 'space' && this.meta.range > 0) {
      const [px, py] = this.project(pos[4 * s.selected], pos[4 * s.selected + 1], 0);
      const R = this.meta.range * this.c * Math.SQRT2;
      ctx.save();
      ctx.fillStyle = c.accent;
      ctx.globalAlpha = 0.08;
      ctx.beginPath(); ctx.ellipse(px, py, R, R / 2, 0, 0, 2 * Math.PI); ctx.fill();
      ctx.globalAlpha = 0.5;
      ctx.strokeStyle = c.accent;
      ctx.setLineDash([6, 5]);
      ctx.lineWidth = 1.2;
      ctx.stroke();
      ctx.restore();
    }

    // Footprints: where each moving node has just been.
    if (this.kind !== 'space') {
      ctx.save();
      ctx.fillStyle = c.trail;
      for (let i = 0; i < n; i++) {
        const m = this.motion[i];
        if (!m || m.speed < 0.05 || m.trail.length < 2) continue;
        const T = m.trail;
        for (let k = 0; k < T.length - 1; k++) {
          const [px, py] = this.project(T[k][0], T[k][1], 0);
          ctx.globalAlpha = 0.1 + 0.4 * (k / T.length);
          ctx.beginPath(); ctx.ellipse(px, py, 3, 1.5, 0, 0, 2 * Math.PI); ctx.fill();
        }
      }
      ctx.restore();
    }

    // Pheromone trails: glowing paths on the ground (in the air for drones and
    // satellites), one stroke per (node -> neighbour) toward the watched node.
    if (s.pheromone) {
      ctx.save();
      ctx.lineCap = 'round';
      ctx.strokeStyle = c.ph;
      if (c.night) { ctx.shadowColor = c.ph; ctx.shadowBlur = 8; }
      for (const e of s.pheromone) {
        if (this.wraps(e.from, e.to, pos)) continue;
        const [a, b] = this.trailEnds(pos, e.from, e.to);
        ctx.globalAlpha = 0.3 + 0.6 * e.share;
        ctx.lineWidth = (1.5 + 5 * e.share) * Math.min(1.5, this.zoom);
        ctx.beginPath();
        ctx.moveTo(a[0], a[1]);
        ctx.lineTo(a[0] + (b[0] - a[0]) * 0.75, a[1] + (b[1] - a[1]) * 0.75);
        ctx.stroke();
      }
      ctx.restore();
    }

    // Radio beams between antennas.
    if (s.showLinks) {
      ctx.save();
      ctx.strokeStyle = c.beam;
      ctx.globalAlpha = c.night ? 0.45 : 0.55;
      ctx.lineWidth = 1;
      ctx.beginPath();
      const L = s.links;
      for (let k = 0; k < L.length; k += 2) {
        if (this.wraps(L[k], L[k + 1], pos)) { this.wrapStub(pos, L[k], L[k + 1]); continue; }
        const a = this.antenna(pos, L[k]), b = this.antenna(pos, L[k + 1]);
        ctx.moveTo(a[0], a[1]);
        ctx.lineTo(b[0], b[1]);
      }
      ctx.stroke();
      ctx.restore();
    }

    // Broadcast rings on the ground (an isometric circle is a 2:1 ellipse).
    for (const r of s.rings) {
      const x = pos[4 * r.node], y = pos[4 * r.node + 1], z = pos[4 * r.node + 2];
      const [px, py] = this.project(x, y, this.kind === 'sky' ? z : 0);
      const R = (12 / this.c + r.progress * r.radius) * this.c * Math.SQRT2;
      ctx.save();
      ctx.globalAlpha = (1 - r.progress) * (r.kind === 'hello' ? 0.4 : 0.85);
      ctx.strokeStyle = c[r.kind];
      ctx.lineWidth = r.kind === 'hello' ? 1 : 2;
      ctx.beginPath();
      ctx.ellipse(px, py, R, R / 2, 0, 0, 2 * Math.PI);
      ctx.stroke();
      ctx.restore();
    }

    // Everything standing on the map, back to front: trees/buildings were in
    // the ground layer; nodes sort by depth so nearer ones overlap farther.
    const order = [...Array(n).keys()].sort((i, j) =>
      this.depth(pos[4 * i], pos[4 * i + 1]) - this.depth(pos[4 * j], pos[4 * j + 1]));
    const flowEnds = new Map();
    for (const f of s.flows) {
      flowEnds.set(f.src, (flowEnds.get(f.src) || '') + ` S${f.id}`);
      flowEnds.set(f.dst, (flowEnds.get(f.dst) || '') + ` D${f.id}`);
    }
    for (const i of order) {
      this.heading(pos, i);
      this.drawNode(pos, i, s, flowEnds.get(i));
    }

    // Ants and packets in transit.
    for (const f of s.flights) {
      if (this.wraps(f.from, f.to, pos)) continue;
      if (f.kind === 'data') {
        const a = this.antenna(pos, f.from), b = this.antenna(pos, f.to);
        this.crate(a[0] + (b[0] - a[0]) * f.progress, a[1] + (b[1] - a[1]) * f.progress, f.failed);
      } else {
        const [a, b] = this.trailEnds(pos, f.from, f.to);
        const x = a[0] + (b[0] - a[0]) * f.progress, y = a[1] + (b[1] - a[1]) * f.progress;
        this.ant(f.kind, x, y, Math.atan2(b[1] - a[1], b[0] - a[0]), f.progress, f.failed);
      }
    }

    // Floating marks: delivered (✓) and lost (✕), always with a symbol.
    for (const m of s.marks) {
      const [px, py] = this.antenna(pos, m.node);
      ctx.save();
      ctx.globalAlpha = 1 - m.progress;
      ctx.font = `700 ${Math.round(12 * Math.min(1.4, this.zoom))}px system-ui, sans-serif`;
      ctx.fillStyle = m.good ? c.good : c.critical;
      ctx.textAlign = 'center';
      ctx.fillText(m.good ? '✓' : '✕', px, py - 8 - 18 * m.progress);
      ctx.restore();
    }

    if (s.hover >= 0 && s.tool !== 'inspect') {
      const [px, py] = this.project(pos[4 * s.hover], pos[4 * s.hover + 1], 0);
      this.groundDiamond(px, py, 10, c.accent, 0.35);
    }
    if (s.ghost) { // build preview
      const [px, py] = this.project(s.ghost[0], s.ghost[1], 0);
      this.groundDiamond(px, py, 12, c.accent, 0.5);
    }
  }

  /** A small ground chevron ahead of a moving node, pointing where it walks. */
  heading(pos, i) {
    const m = this.motion[i];
    if (!m || m.speed < 0.05 || this.kind === 'space') return;
    const { ctx, colors: c } = this;
    const x = pos[4 * i], y = pos[4 * i + 1];
    const L = 16 / this.c, W = 5 / this.c;
    const tip = this.project(x + m.dx * (L + 6 / this.c), y + m.dy * (L + 6 / this.c), 0);
    const l = this.project(x + m.dx * L - m.dy * W, y + m.dy * L + m.dx * W, 0);
    const r = this.project(x + m.dx * L + m.dy * W, y + m.dy * L - m.dx * W, 0);
    ctx.save();
    ctx.globalAlpha = 0.7;
    ctx.fillStyle = c.accent;
    ctx.beginPath(); ctx.moveTo(tip[0], tip[1]); ctx.lineTo(l[0], l[1]); ctx.lineTo(r[0], r[1]); ctx.closePath(); ctx.fill();
    ctx.restore();
  }

  trailEnds(pos, a, b) {
    if (this.kind === 'sky' || this.kind === 'space') return [this.antenna(pos, a), this.antenna(pos, b)];
    return [this.project(pos[4 * a], pos[4 * a + 1], 0), this.project(pos[4 * b], pos[4 * b + 1], 0)];
  }

  wrapStub(pos, a, b) {
    const { ctx } = this;
    for (const [p, q] of [[a, b], [b, a]]) {
      const [x0, y0] = this.antenna(pos, p);
      let dx = pos[4 * q] - pos[4 * p], dy = pos[4 * q + 1] - pos[4 * p + 1];
      if (Math.abs(dx) > this.meta.areaX / 2) dx = -Math.sign(dx);
      else dx = 0;
      if (Math.abs(dy) > this.meta.areaY / 2) dy = -Math.sign(dy);
      else dy = 0;
      const [x1, y1] = this.project(pos[4 * p] + dx * this.meta.areaX * 0.06,
        pos[4 * p + 1] + dy * this.meta.areaY * 0.06, 0);
      const [bx, by] = this.project(pos[4 * p], pos[4 * p + 1], 0);
      ctx.moveTo(x0, y0);
      ctx.lineTo(x0 + (x1 - bx), y0 + (y1 - by));
    }
  }

  groundDiamond(px, py, r, color, alpha) {
    const { ctx } = this;
    ctx.save();
    ctx.globalAlpha = alpha;
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(px, py - r / 2); ctx.lineTo(px + r, py); ctx.lineTo(px, py + r / 2); ctx.lineTo(px - r, py);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }

  // --- ground layer (cached: it only changes with the camera) ------------------
  drawGround() {
    const { ctx } = this;
    if (!this.groundCache) {
      const off = document.createElement('canvas');
      off.width = this.canvas.width;
      off.height = this.canvas.height;
      const g = off.getContext('2d');
      g.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
      const saved = this.ctx;
      this.ctx = g;
      this.paintGround();
      this.ctx = saved;
      this.groundCache = off;
    }
    ctx.save();
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.drawImage(this.groundCache, 0, 0);
    ctx.restore();
  }

  tile(x0, y0, x1, y1, fill, edge) {
    const { ctx } = this;
    const p = [this.project(x0, y0), this.project(x1, y0), this.project(x1, y1), this.project(x0, y1)];
    ctx.beginPath();
    ctx.moveTo(p[0][0], p[0][1]);
    for (let k = 1; k < 4; k++) ctx.lineTo(p[k][0], p[k][1]);
    ctx.closePath();
    ctx.fillStyle = fill;
    ctx.fill();
    if (edge) { ctx.strokeStyle = edge; ctx.lineWidth = 0.5; ctx.stroke(); }
  }

  paintGround() {
    const { ctx, colors: c, meta } = this;
    const W = meta.areaX, H = meta.areaY;
    if (this.kind === 'space') {
      ctx.fillStyle = c.space;
    } else {
      const g = ctx.createLinearGradient(0, 0, 0, this.h);
      g.addColorStop(0, c['sky-top']);
      g.addColorStop(1, c.sky);
      ctx.fillStyle = g;
    }
    ctx.fillRect(0, 0, this.w, this.h);

    if (this.kind === 'space') {
      // Starfield, then the constellation's orbital grid.
      for (let k = 0; k < 220; k++) {
        const x = hash2(k, 1) * this.w, y = hash2(k, 2) * this.h, r = hash2(k, 3);
        ctx.fillStyle = c.star;
        ctx.globalAlpha = 0.3 + 0.7 * r;
        ctx.fillRect(x, y, r > 0.9 ? 2 : 1, r > 0.9 ? 2 : 1);
      }
      ctx.globalAlpha = 0.25;
      ctx.strokeStyle = c.beam;
      ctx.beginPath();
      const p = [this.project(0, 0), this.project(W, 0), this.project(W, H), this.project(0, H)];
      ctx.moveTo(p[0][0], p[0][1]);
      for (let k = 1; k < 4; k++) ctx.lineTo(p[k][0], p[k][1]);
      ctx.closePath();
      ctx.stroke();
      ctx.globalAlpha = 1;
      return;
    }

    // Grass tiles with a little per-tile variation and a faint build grid,
    // plus the slab edge for depth.
    const nT = 20;
    const tx = W / nT, ty = H / nT;
    this.slab();
    const grid = c.night ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.06)';
    for (let i = 0; i < nT; i++) {
      for (let j = 0; j < nT; j++) {
        this.tile(i * tx, j * ty, (i + 1) * tx, (j + 1) * ty, hash2(i + 3, j + 5) < 0.5 ? c['grass-a'] : c['grass-b'], grid);
      }
    }

    if (this.kind === 'city') {
      // Streets (centre lines of the block grid), then the buildings.
      // Roads are drawn wider than the radio model's street (and buildings
      // inset to match) so cars read at map scale; the radio still uses the
      // real street width for line of sight.
      const bw = W / meta.blocksX, bh = H / meta.blocksY, sw = Math.max(meta.streetWidth * 2.5, bw * 0.16);
      for (let i = 0; i <= meta.blocksX; i++) this.tile(i * bw - sw / 2, 0, i * bw + sw / 2, H, c.road);
      for (let j = 0; j <= meta.blocksY; j++) this.tile(0, j * bh - sw / 2, W, j * bh + sw / 2, c.road);
      const blocks = [];
      for (let i = 0; i < meta.blocksX; i++) for (let j = 0; j < meta.blocksY; j++) blocks.push([i, j]);
      blocks.sort((a, b) => this.depth(a[0] * bw, a[1] * bh) - this.depth(b[0] * bw, b[1] * bh));
      for (const [i, j] of blocks) {
        const h = 12 + 28 * hash2(i, j);
        this.box(i * bw + sw / 2, j * bh + sw / 2, (i + 1) * bw - sw / 2, (j + 1) * bh - sw / 2, h, hash2(j, i));
      }
      return;
    }

    // Trees on a deterministic sprinkle of tiles (decoration only).
    const trees = [];
    for (let i = 0; i < nT; i++) {
      for (let j = 0; j < nT; j++) {
        if (hash2(i + 7, j + 13) < 0.09) trees.push([(i + 0.3 + 0.4 * hash2(i, j)) * tx, (j + 0.3 + 0.4 * hash2(j, i)) * ty]);
      }
    }
    trees.sort((a, b) => this.depth(a[0], a[1]) - this.depth(b[0], b[1]));
    for (const [x, y] of trees) this.tree(x, y);
  }

  slab() {
    const { ctx, colors: c } = this;
    // The two visible sides depend on rotation; in (u, v) the near corner is (U, V).
    const [U, V] = this.dims();
    const near = this.project(...this.unrotate(U, V));
    const left = this.project(...this.unrotate(0, V));
    const right = this.project(...this.unrotate(U, 0));
    const th = 18; // slab thickness, constant on screen
    // Two faces, two shades: the light falls from the right.
    for (const [a, fill] of [[left, c['grass-edge']], [right, c['slab-right']]]) {
      ctx.fillStyle = fill;
      ctx.beginPath();
      ctx.moveTo(a[0], a[1]); ctx.lineTo(near[0], near[1]);
      ctx.lineTo(near[0], near[1] + th); ctx.lineTo(a[0], a[1] + th);
      ctx.closePath();
      ctx.fill();
    }
  }

  box(x0, y0, x1, y1, h, seed) {
    const { ctx, colors: c } = this;
    const P = (x, y, z) => this.project(x, y, z);
    // Faces facing the viewer depend on rotation: draw the two "front" walls.
    const corners = [[x0, y0], [x1, y0], [x1, y1], [x0, y1]];
    const rc = corners.map(([x, y]) => this.rotate(x, y));
    let iNear = 0;
    for (let k = 1; k < 4; k++) if (rc[k][0] + rc[k][1] > rc[iNear][0] + rc[iNear][1]) iNear = k;
    const prev = corners[(iNear + 3) % 4], near = corners[iNear], next = corners[(iNear + 1) % 4];
    const wall = (a, b, fill) => {
      const p0 = P(a[0], a[1], 0), p1 = P(b[0], b[1], 0), p2 = P(b[0], b[1], h), p3 = P(a[0], a[1], h);
      ctx.beginPath();
      ctx.moveTo(p0[0], p0[1]); ctx.lineTo(p1[0], p1[1]); ctx.lineTo(p2[0], p2[1]); ctx.lineTo(p3[0], p3[1]);
      ctx.closePath();
      ctx.fillStyle = fill;
      ctx.fill();
      // Window rows.
      const rows = Math.max(1, Math.floor(h / 8)), cols = 4;
      for (let r = 0; r < rows; r++) {
        for (let q = 0; q < cols; q++) {
          const lit = c.night && hash2(r * 7 + q, Math.floor(seed * 1000)) > 0.45;
          const fx = (q + 0.3) / cols, fz = (r + 0.35) / rows;
          const wx = a[0] + (b[0] - a[0]) * fx, wy = a[1] + (b[1] - a[1]) * fx;
          const [px, py] = P(wx, wy, h * fz);
          ctx.fillStyle = lit ? c['window-lit'] : c.window;
          ctx.fillRect(px - 1.2, py - 2, 2.4, 3);
        }
      }
    };
    wall(prev, near, c['bldg-left']);
    wall(near, next, c['bldg-right']);
    const top = corners.map(([x, y]) => P(x, y, h));
    ctx.beginPath();
    ctx.moveTo(top[0][0], top[0][1]);
    for (let k = 1; k < 4; k++) ctx.lineTo(top[k][0], top[k][1]);
    ctx.closePath();
    ctx.fillStyle = c['bldg-top'];
    ctx.fill();
  }

  tree(x, y) {
    const { ctx, colors: c } = this;
    const [px, py] = this.project(x, y);
    const s = Math.max(3, Math.min(9, this.c * 9));
    ctx.fillStyle = c.trunk;
    ctx.fillRect(px - 1, py - s * 0.6, 2, s * 0.6);
    ctx.fillStyle = c['tree-dark'];
    ctx.beginPath(); ctx.arc(px, py - s * 1.1, s * 0.7, 0, 2 * Math.PI); ctx.fill();
    ctx.fillStyle = c.tree;
    ctx.beginPath(); ctx.arc(px - s * 0.2, py - s * 1.25, s * 0.45, 0, 2 * Math.PI); ctx.fill();
  }

  // --- sprites -----------------------------------------------------------------
  drawNode(pos, i, s, label) {
    const { ctx, colors: c } = this;
    const x = pos[4 * i], y = pos[4 * i + 1], z = pos[4 * i + 2];
    const up = pos[4 * i + 3] > 0;
    const [bx, by] = this.project(x, y, 0);
    const [ax, ay] = this.antenna(pos, i);
    const k = this.kind;
    const zs = this.spriteScale();
    const body = up ? c.tower : c['node-off'];
    const flash = s.flash && s.flash.get(i);

    if (i === s.selected) this.groundDiamond(bx, by, 16 * zs, c.accent, 0.45);

    if (k === 'sky') this.drone(bx, by, ax, ay, up, zs, i);
    else if (k === 'space') this.satellite(ax, ay, up, zs);
    else if (k === 'city') this.car(pos, i, up, zs);
    else if (this.meta.sprite === 'phone') {
      // Mobile phone, standing upright: a slab with real thickness (the
      // right-hand edge), a lit screen, an earpiece and a home bar.
      this.shadowAt(bx, by, 7 * zs, 0.22);
      const w = 10 * zs, h = 17 * zs, t = 2.2 * zs, x0 = bx - w / 2, y0 = by - 2 * zs - h;
      ctx.fillStyle = up ? c.phone : c['node-off'];
      ctx.beginPath(); // side edge, receding up-right
      ctx.moveTo(x0 + w - 1, y0 + 2 * zs); ctx.lineTo(x0 + w + t, y0 + 2 * zs - t / 2);
      ctx.lineTo(x0 + w + t, y0 + h - 2 * zs - t / 2); ctx.lineTo(x0 + w - 1, y0 + h - 2 * zs);
      ctx.closePath(); ctx.fill();
      ctx.fillStyle = 'rgba(0,0,0,0.25)'; ctx.fill();
      ctx.beginPath();
      ctx.roundRect(x0, y0, w, h, 2.4 * zs);
      ctx.fillStyle = up ? c.phone : c['node-off'];
      ctx.fill();
      ctx.lineWidth = 1;
      ctx.strokeStyle = c['phone-edge'];
      ctx.globalAlpha = 0.6;
      ctx.stroke();
      ctx.globalAlpha = 1;
      ctx.beginPath();
      ctx.roundRect(x0 + 1.2 * zs, y0 + 2.6 * zs, w - 2.4 * zs, h - 5.4 * zs, 1.2 * zs);
      if (up) {
        const g = ctx.createLinearGradient(x0, y0, x0 + w, y0 + h);
        g.addColorStop(0, flash ? c[flash] : c.screen);
        g.addColorStop(1, c['panel-blue']);
        ctx.fillStyle = g;
      } else {
        ctx.fillStyle = c.phone;
      }
      ctx.fill();
      ctx.fillStyle = c['phone-edge'];
      ctx.globalAlpha = 0.7;
      ctx.fillRect(bx - 1.5 * zs, y0 + 1.1 * zs, 3 * zs, 0.7 * zs);       // earpiece
      ctx.fillRect(bx - 2 * zs, y0 + h - 1.8 * zs, 4 * zs, 0.7 * zs);    // home bar
      ctx.globalAlpha = 1;
    } else {
      this.router(bx, by, ay, up, zs);
    }

    // Antenna light: lit in the colour of whatever it just transmitted.
    ctx.beginPath();
    ctx.arc(ax, ay, (flash ? 2.8 : 1.6) * zs / 1.25, 0, 2 * Math.PI);
    ctx.fillStyle = flash ? c[flash] : (up ? c.critical : c['node-off']);
    ctx.fill();
    if (!up) {
      ctx.strokeStyle = c.critical;
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(bx - 4, by - 10); ctx.lineTo(bx + 4, by - 2);
      ctx.moveTo(bx + 4, by - 10); ctx.lineTo(bx - 4, by - 2);
      ctx.stroke();
    }

    if (s.labels || label || i === s.selected) {
      ctx.font = `${label ? 700 : 400} ${Math.round(10 * Math.min(1.3, zs))}px system-ui, sans-serif`;
      ctx.textAlign = 'left';
      const text = String(i) + (label || '');
      const tx = ax + 6, ty = ay - 4;
      ctx.lineWidth = 3;
      ctx.strokeStyle = c.night ? 'rgba(0,0,0,0.6)' : 'rgba(255,255,255,0.75)';
      ctx.strokeText(text, tx, ty);
      ctx.fillStyle = c.text;
      ctx.fillText(text, tx, ty);
    }
  }

  /** A screen-space isometric cube: ground centre (cx, cy), half-width a,
   *  height h, raised by e; faces top / left / right. */
  cube(cx, cy, a, h, e, top, left, right) {
    const { ctx } = this;
    const y0 = cy - e, y1 = cy - e - h;
    const face = (pts, fill) => {
      ctx.beginPath();
      ctx.moveTo(pts[0][0], pts[0][1]);
      for (let k = 1; k < pts.length; k++) ctx.lineTo(pts[k][0], pts[k][1]);
      ctx.closePath();
      ctx.fillStyle = fill;
      ctx.fill();
    };
    face([[cx - a, y1], [cx, y1 + a / 2], [cx, y0 + a / 2], [cx - a, y0]], left);
    face([[cx, y1 + a / 2], [cx + a, y1], [cx + a, y0], [cx, y0 + a / 2]], right);
    face([[cx, y1 - a / 2], [cx + a, y1], [cx, y1 + a / 2], [cx - a, y1]], top);
  }

  shadowAt(x, y, rx, alpha = 0.22) {
    const { ctx, colors: c } = this;
    ctx.save();
    ctx.globalAlpha = alpha;
    ctx.fillStyle = c.shadow;
    ctx.beginPath(); ctx.ellipse(x, y, rx, rx / 2, 0, 0, 2 * Math.PI); ctx.fill();
    ctx.restore();
  }

  /** Quadcopter: ground shadow and plumb line, X frame, four spinning rotors. */
  drone(bx, by, ax, ay, up, zs, i) {
    const { ctx, colors: c } = this;
    this.shadowAt(bx, by, 8 * zs, 0.25);
    ctx.save();
    ctx.globalAlpha = 0.18;
    ctx.strokeStyle = c.shadow;
    ctx.setLineDash([2, 3]);
    ctx.beginPath(); ctx.moveTo(bx, by); ctx.lineTo(ax, ay + 4 * zs); ctx.stroke();
    ctx.restore();
    const cy = ay + 4 * zs, body = up ? c.tower : c['node-off'];
    const arms = [[-8, -4], [8, -4], [8, 4], [-8, 4]];
    ctx.strokeStyle = body;
    ctx.lineWidth = 2 * zs;
    ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(ax + arms[0][0] * zs, cy + arms[0][1] * zs); ctx.lineTo(ax + arms[2][0] * zs, cy + arms[2][1] * zs);
    ctx.moveTo(ax + arms[1][0] * zs, cy + arms[1][1] * zs); ctx.lineTo(ax + arms[3][0] * zs, cy + arms[3][1] * zs);
    ctx.stroke();
    const spin = up && !this.still ? (this.t / 40 + i) % (2 * Math.PI) : 0.6;
    for (const [dx, dy] of arms) {
      const rx = ax + dx * zs, ry = cy + dy * zs - 1.5 * zs;
      ctx.fillStyle = body;
      ctx.globalAlpha = 0.18;
      ctx.beginPath(); ctx.ellipse(rx, ry, 5 * zs, 2.5 * zs, 0, 0, 2 * Math.PI); ctx.fill();
      ctx.globalAlpha = 0.9;
      ctx.lineWidth = 1.2 * zs;
      ctx.beginPath();
      ctx.moveTo(rx - Math.cos(spin) * 5 * zs, ry - Math.sin(spin) * 2.5 * zs);
      ctx.lineTo(rx + Math.cos(spin) * 5 * zs, ry + Math.sin(spin) * 2.5 * zs);
      ctx.stroke();
      ctx.globalAlpha = 1;
    }
    ctx.beginPath();
    ctx.roundRect(ax - 4 * zs, cy - 3 * zs, 8 * zs, 6 * zs, 2 * zs);
    ctx.fillStyle = body;
    ctx.fill();
    ctx.lineCap = 'butt';
  }

  /** Satellite: gold-foil bus, two ribbed solar wings on a boom, a dish. */
  satellite(ax, ay, up, zs) {
    const { ctx, colors: c } = this;
    const panel = up ? c['panel-blue'] : c['node-off'];
    ctx.strokeStyle = up ? c.star : c['node-off'];
    ctx.lineWidth = 1;
    ctx.beginPath(); ctx.moveTo(ax - 7 * zs, ay); ctx.lineTo(ax + 7 * zs, ay); ctx.stroke();
    for (const side of [-1, 1]) {
      // A wing: a parallelogram (the panel seen at the isometric angle) with cell ribs.
      const x0 = ax + side * 7 * zs, x1 = ax + side * 19 * zs;
      const P = [[x0, ay - 4 * zs], [x1, ay - 4 * zs + side * 2 * zs], [x1, ay + 4 * zs + side * 2 * zs], [x0, ay + 4 * zs]];
      ctx.beginPath();
      ctx.moveTo(P[0][0], P[0][1]);
      for (let k = 1; k < 4; k++) ctx.lineTo(P[k][0], P[k][1]);
      ctx.closePath();
      ctx.fillStyle = panel;
      ctx.fill();
      ctx.save();
      ctx.globalAlpha = 0.45;
      ctx.strokeStyle = c.star;
      ctx.lineWidth = 0.6;
      ctx.beginPath();
      for (let q = 1; q < 4; q++) {
        const f = q / 4;
        ctx.moveTo(P[0][0] + (P[1][0] - P[0][0]) * f, P[0][1] + (P[1][1] - P[0][1]) * f);
        ctx.lineTo(P[3][0] + (P[2][0] - P[3][0]) * f, P[3][1] + (P[2][1] - P[3][1]) * f);
      }
      ctx.moveTo((P[0][0] + P[3][0]) / 2, (P[0][1] + P[3][1]) / 2);
      ctx.lineTo((P[1][0] + P[2][0]) / 2, (P[1][1] + P[2][1]) / 2);
      ctx.stroke();
      ctx.restore();
    }
    const gold = up ? '#d4a72c' : c['node-off'];
    this.cube(ax, ay + 4 * zs, 5 * zs, 8 * zs, 0, up ? '#f0cf6a' : c['node-off'], gold, up ? '#a77f17' : c['node-off']);
    // Dish on top, facing the viewer.
    ctx.fillStyle = up ? '#f4f4f5' : c['node-off'];
    ctx.beginPath(); ctx.ellipse(ax + 1 * zs, ay - 6 * zs, 3.4 * zs, 1.8 * zs, -0.4, 0, 2 * Math.PI); ctx.fill();
  }

  /** Car: an oriented box with a glass cabin, coloured per vehicle, driving
   *  along its heading; a shark-fin antenna on the roof. */
  car(pos, i, up, zs) {
    const { colors: c } = this;
    const x = pos[4 * i], y = pos[4 * i + 1];
    const m = this.motion[i];
    const moved = m && (m.dx || m.dy);
    const dx = moved ? m.dx : 1, dy = moved ? m.dy : 0;
    const L = 8 * zs / this.c, W = 4 * zs / this.c; // half-length / half-width in metres (screen-sized)
    const corner = (fl, fw) => [x + dx * L * fl - dy * W * fw, y + dy * L * fl + dx * W * fw];
    const [gx, gy] = this.project(x, y, 0);
    this.shadowAt(gx, gy + 1, 10 * zs, 0.25);
    const paint = up ? CAR_PAINT[i % CAR_PAINT.length] : c['node-off'];
    this.prism([corner(1, 1), corner(1, -1), corner(-1, -1), corner(-1, 1)], 1 * zs, 4.5 * zs, paint);
    this.prism([corner(0.4, 0.8), corner(0.4, -0.8), corner(-0.6, -0.8), corner(-0.6, 0.8)], 4.5 * zs, 8 * zs,
      up ? (c.night ? '#1e293b' : '#334155') : c['node-off'], paint);
    const [ax, ay] = this.antenna(pos, i);
    this.ctx.strokeStyle = up ? c.tower : c['node-off'];
    this.ctx.lineWidth = 1;
    this.ctx.beginPath(); this.ctx.moveTo(gx, gy - 9 * zs); this.ctx.lineTo(ax, ay); this.ctx.stroke();
  }

  /** Extrude a ground polygon (world x, y) between screen heights h0 and h1. */
  prism(poly, h0, h1, fill, topFill) {
    const { ctx } = this;
    const pts = poly.map(([x, y]) => this.project(x, y, 0));
    const walls = pts.map((p, k) => [p, pts[(k + 1) % pts.length], this.depth(...poly[k]) + this.depth(...poly[(k + 1) % poly.length])]);
    walls.sort((a, b) => a[2] - b[2]);
    for (const [a, b] of walls) {
      ctx.beginPath();
      ctx.moveTo(a[0], a[1] - h0); ctx.lineTo(b[0], b[1] - h0); ctx.lineTo(b[0], b[1] - h1); ctx.lineTo(a[0], a[1] - h1);
      ctx.closePath();
      ctx.fillStyle = fill;
      ctx.fill();
      ctx.fillStyle = 'rgba(0,0,0,0.18)';
      ctx.fill();
    }
    ctx.beginPath();
    ctx.moveTo(pts[0][0], pts[0][1] - h1);
    for (let k = 1; k < pts.length; k++) ctx.lineTo(pts[k][0], pts[k][1] - h1);
    ctx.closePath();
    ctx.fillStyle = topFill || fill;
    ctx.fill();
  }

  /** Wi-Fi mesh router on a pole: a white box with two antennas. */
  router(bx, by, ay, up, zs) {
    const { ctx, colors: c } = this;
    this.shadowAt(bx, by, 6 * zs, 0.2);
    const pole = up ? c['tower-dark'] : c['node-off'];
    ctx.strokeStyle = pole;
    ctx.lineWidth = 2 * zs;
    ctx.beginPath(); ctx.moveTo(bx, by); ctx.lineTo(bx, by - 12 * zs); ctx.stroke();
    const e = 12 * zs;
    this.cube(bx, by, 6 * zs, 4 * zs, e, up ? '#f8fafc' : c['node-off'], up ? '#cbd5e1' : c['node-off'], up ? '#94a3b8' : c['node-off']);
    ctx.strokeStyle = up ? c.tower : c['node-off'];
    ctx.lineWidth = 1.4 * zs;
    ctx.lineCap = 'round';
    ctx.beginPath();
    ctx.moveTo(bx - 4 * zs, by - e - 3 * zs); ctx.lineTo(bx - 5 * zs, ay + 1 * zs);
    ctx.moveTo(bx + 4 * zs, by - e - 3 * zs); ctx.lineTo(bx + 5 * zs, ay + 1 * zs);
    ctx.stroke();
    ctx.lineCap = 'butt';
    if (up) { // status LEDs on the front face
      ctx.fillStyle = c.good;
      for (const q of [-2, 0, 2]) ctx.fillRect(bx + 1.5 * zs + q * zs, by - e - 1 * zs + q * 0.25 * zs, 1.1 * zs, 1.1 * zs);
    }
  }

  /** An ant: three body segments, six legs (animated), coloured by kind. */
  ant(kind, x, y, angle, phase, failed) {
    const { ctx, colors: c } = this;
    const s = Math.min(1.6, Math.max(0.8, this.zoom));
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(angle);
    ctx.scale(s, s);
    const col = c[kind];
    ctx.strokeStyle = col;
    ctx.lineWidth = 1;
    const swing = Math.sin(phase * Math.PI * 12) * 1.5;
    ctx.beginPath();
    for (const lx of [-2, 0.5, 3]) {
      ctx.moveTo(lx, 0); ctx.lineTo(lx - 1.5 + swing, -4);
      ctx.moveTo(lx, 0); ctx.lineTo(lx - 1.5 - swing, 4);
    }
    ctx.stroke();
    ctx.fillStyle = col;
    ctx.strokeStyle = c.night ? '#000' : '#fff';
    ctx.lineWidth = 1;
    for (const [cx, r] of [[-4, 2.6], [0.5, 1.8], [4.2, 2]]) {
      ctx.beginPath(); ctx.ellipse(cx, 0, r, r * 0.8, 0, 0, 2 * Math.PI); ctx.fill(); ctx.stroke();
    }
    if (kind === 'backward') { // carries a pheromone droplet home
      ctx.fillStyle = c.ph;
      ctx.beginPath(); ctx.arc(7.5, 0, 1.8, 0, 2 * Math.PI); ctx.fill();
    }
    if (failed) {
      ctx.strokeStyle = c.critical;
      ctx.lineWidth = 2;
      ctx.beginPath(); ctx.moveTo(-5, -5); ctx.lineTo(5, 5); ctx.moveTo(5, -5); ctx.lineTo(-5, 5); ctx.stroke();
    }
    ctx.restore();
  }

  /** A data packet: a small isometric crate. */
  crate(x, y, failed) {
    const { ctx, colors: c } = this;
    const s = 3.6 * Math.min(1.5, Math.max(0.8, this.zoom));
    ctx.save();
    ctx.fillStyle = c.data;
    ctx.beginPath();
    ctx.moveTo(x, y - s); ctx.lineTo(x + s, y - s / 2); ctx.lineTo(x + s, y + s / 2);
    ctx.lineTo(x, y + s); ctx.lineTo(x - s, y + s / 2); ctx.lineTo(x - s, y - s / 2);
    ctx.closePath();
    ctx.fill();
    ctx.strokeStyle = c.night ? '#000' : '#fff';
    ctx.lineWidth = 0.8;
    ctx.stroke();
    ctx.beginPath(); ctx.moveTo(x - s, y - s / 2); ctx.lineTo(x, y); ctx.lineTo(x + s, y - s / 2);
    ctx.moveTo(x, y); ctx.lineTo(x, y + s); ctx.stroke();
    if (failed) {
      ctx.strokeStyle = c.critical;
      ctx.lineWidth = 2;
      ctx.beginPath(); ctx.moveTo(x - 4, y - 4); ctx.lineTo(x + 4, y + 4); ctx.moveTo(x + 4, y - 4); ctx.lineTo(x - 4, y + 4); ctx.stroke();
    }
    ctx.restore();
  }

  /** A swatch canvas for the legend, drawn with the same sprites. */
  swatch(kind) {
    const cv = document.createElement('canvas');
    const dpr = window.devicePixelRatio || 1;
    cv.width = 22 * dpr; cv.height = 14 * dpr;
    cv.style.width = '22px'; cv.style.height = '14px';
    const saved = [this.ctx, this.zoom];
    this.ctx = cv.getContext('2d');
    this.ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    this.zoom = 1;
    if (kind === 'hello') {
      this.ctx.strokeStyle = this.colors.hello;
      this.ctx.beginPath(); this.ctx.ellipse(11, 7, 8, 4, 0, 0, 2 * Math.PI); this.ctx.stroke();
    } else if (kind === 'pheromone') {
      this.ctx.strokeStyle = this.colors.ph; this.ctx.lineWidth = 4; this.ctx.lineCap = 'round';
      this.ctx.beginPath(); this.ctx.moveTo(3, 10); this.ctx.lineTo(19, 4); this.ctx.stroke();
    } else if (kind === 'data') {
      this.crate(11, 7, false);
    } else {
      this.ant(kind, 11, 7, 0, 0.1, false);
    }
    [this.ctx, this.zoom] = saved;
    return cv;
  }
}
