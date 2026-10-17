# ADR-0025: A kinematics port — position and velocity enter the core, absent when unknown

- **Status:** Accepted
- **Date:** 2026-10-17
- **Decides:** [#573](https://github.com/danieljoppi/AntHocNet/issues/573)
  (the position port). It is the prerequisite of link-lifetime prediction
  ([#574](https://github.com/danieljoppi/AntHocNet/issues/574)) and of any later
  geographic hint.

## Context

**What #574 needs.** VANET is the family where AntHocNet trails the oracle
most: 42.1 % against 81.7 % on VANET main. The v2.2.0 campaign measured every
timer knob there ([#537](https://github.com/danieljoppi/AntHocNet/issues/537)).
The best one, `ReconvHoldCap=1s`, recovers 5.3 of the 39.6 pp, and every knob
that helps VANET hurts another family. Each knob either waits out a break or
detects it sooner. None stops the protocol choosing a link that is about to
break. That is what link-lifetime prediction does, and it needs to know where a
node and its neighbours are and how they move. The core sees neither today.

**What it means for a port.** ADR-0003 keeps the core free of simulator
headers: everything it learns from the world comes through a port in
`core/.../ports.h`. So does `ILinkQuality`, the per-neighbour SINR
(ADR-0024). A position port has three questions the SINR port did not:

1. **Whose position.** A node knows its own position from its own mobility
   model, or in a real deployment from GPS. It does not know a neighbour's,
   unless the neighbour tells it.
2. **What "unknown" means.** Not every adapter can supply a position. The
   browser's teaching radio does; an ns-3 node with no `MobilityModel` does
   not; a real radio without GPS would not. A missing position must not read
   as the origin, `(0, 0, 0)`. Every node with no position would then sit on
   top of every other one, and a link-lifetime predictor would call their
   links immortal.
3. **The wire.** If neighbours' positions come from their hellos, the hello
   format changes. That bumps `kWireVersion` and extends the codec tests and
   the fuzz corpus (golden rule 4).

**The literature's answer to (1).** Mobility-prediction routing has worked
this way since Su, Lee and Gerla's link expiration time (LET), 2001: each node
beacons its own position and velocity, and a receiver predicts a link's life
from the two. VANET work keeps the pattern. Intersection-aware lifetime (iCAR)
and mobility-anticipated ETX both read position from beacons, not from an
oracle. A port that let the adapter hand the core every neighbour's true
position would be an oracle the protocol could never have in a real network.

## Decision

1. **A new port, `IKinematics`**, separate from the others:
   `bool self(Kinematics& out) const`.
   - It fills this node's position (m) and velocity (m/s), in the adapter's
     Cartesian frame, and returns true.
   - It returns **false** when the adapter does not know them. The out
     parameter is then untouched.
   - The core stays C++14, so this is a bool + out parameter, not
     `std::optional`.
   - `Kinematics` is six doubles: `x y z vx vy vz`.
2. **Absent, not zero, everywhere.**
   - A null port, or `self()` returning false, means "unknown".
   - The core never substitutes zeros. An unknown position contributes nothing
     to any prediction: a consumer that cannot predict leaves the link as it
     would have been without the feature.
3. **Neighbours' kinematics come from their hellos, not from the adapter.**
   - A hello may carry an optional trailing **kinematics section**: a tag byte
     `0x4B` ('K'), then the sender's six values as IEEE-754 float32,
     little-endian (25 bytes).
   - float32 keeps 0.5 m of resolution at 7 000 km, enough for satellites, at
     half the airtime of doubles.
   - A hello carries the section only when **both** hold: the gate
     `Config::shareKinematics` is on (default **false**), and `self()` returns
     true.
   - The receiver stores what it heard per neighbour, with the receive time,
     and extrapolates it as `p + v·(now − t_rx)`.
   - A neighbour's entry is dropped when the neighbour is lost
     (`loseNeighbor`), and when a later hello from it carries no section. So
     a neighbour that stops knowing its position stops being predicted.
   - Only hellos carry it. Other ant types are unchanged.
4. **The wire version bumps to 0x04.**
   - The section is optional and trailing. A 0x03 decoder would ignore it and
     a 0x04 decoder accepts hellos without it, but golden rule 4 still requires
     the bump: the format a decoder accepts has changed.
   - The decoder rejects a section with a wrong tag, a truncated section, or
     any non-finite value. It also rejects a section on a non-hello ant.
   - The codec round-trip tests and the fuzz corpus gain hellos with and
     without the section. The existing corpus files are re-stamped 0x04.
5. **The default path is byte-identical.**
   - With `shareKinematics` off, no hello carries the section, so every
     packet keeps its size. The wire-version byte changes value but not
     length, and nothing reads its value except the decoder's check.
   - No consumer reads the kinematics table, so every routing decision is
     unchanged.
   - The determinism check (the #129 pattern, ADR-0020) proves it: a default
     run before and after the change must produce identical rows.
6. **The adapters supply `self()`.**
   - **ns-3:** from the node's aggregated `MobilityModel`, `GetPosition()`
     and `GetVelocity()`. A node with no mobility model returns false.
   - **Browser:** from the trajectory its radio already uses. The velocity
     is the current leg's `(p1 − p0) / (t1 − t0)`, and zero during a pause or
     when a node is pinned. Orbits move along 0.25 s chords, so they report
     the chord's velocity. That is arithmetic only, so the native and WASM
     builds stay bit-identical (the parity rule).
   - Both adapters expose the gate as an attribute or setting; ns-3's is
     `ShareKinematics`.
7. **This ADR adds the port, the wire section and the table, and no
   consumer.**
   - Link-lifetime prediction (#574) is the first consumer, with its own
     gate. It turns `shareKinematics` on when it is enabled, and it owns the
     decisions about range, horizon and the pheromone discount.
   - Keeping them apart means this change can be proven inert on its own
     before any behaviour depends on it.

## Consequences

- **Overhead when on.** A hello grows by 25 bytes. Whoever measures a
  consumer of the port pays that overhead in its NRL. That is the honest
  price: a real deployment would beacon the same information.
- **No ground truth inside the protocol.** A predictor sees a neighbour as it
  was at its last hello, so its error grows with the hello interval and with
  turns since then. That is the error a deployed protocol would have. Any gap
  to the oracle that it leaves is a real result, not a modelling artefact.
- **Satellite ISLs.** These nodes have mobility models (the LEO shells), so
  they can supply kinematics. On the static `isl-grid` the velocity is zero
  and no link is predicted to end. That is correct for that harness.
- **Frames.** Positions are only ever compared between two nodes of the same
  simulation, so the frame needs no geodesy. ns-3's frame is Cartesian
  metres, and the browser's is metres east, north and up.
- **Spoofing.** A node can lie about its position. That is a v3.0.0 security
  concern ([ADR-0020](0020-security-is-a-default-off-profile.md)). The
  section's validation rejects malformed values, not false ones.
