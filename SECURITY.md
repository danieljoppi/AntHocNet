# Security Policy

AntHocNet is a **research routing protocol** for simulation (NS-3; the NS-2 adapter shipped through v1.9.0). This
document records its security posture honestly rather than promising guarantees
the protocol does not provide.

## Trust boundary

`core::codec::deserialize` is the **only** parser of untrusted bytes (an ant
frame arriving from the network). It is:

- **over-read safe** — every length-prefixed section is bounds-checked against
  the remaining buffer before it is read or allocated;
- **bound-enforcing** — declared element counts (`visited`, `history`,
  `helloDests`) are rejected if they exceed the protocol caps
  (`kMaxVisitedOnWire` / `kMaxHistoryOnWire` / `kMaxHelloOnWire`), so a peer
  cannot push 16-bit-max counts past the algorithm's invariants;
- **version- and enum-validating** — a frame whose offset-0 wire-version byte
  does not match `kWireVersion`, or whose `type`/`direction` byte is not a known
  enum value, is rejected in O(1) before any further parsing.

In scope for the implementation to guarantee: a single malformed packet cannot
crash, over-read, over-allocate, or violate the bounded-structure invariants.

## Known, by-design limitations (out of scope)

These are inherent to vanilla AntHocNet, not implementation bugs:

- **Ants are unauthenticated.** A malicious node can inject false pheromone
  (blackhole / greyhole), advertise bogus hello destinations, or mount wormhole
  attacks. Mitigations (signed control messages, trust / reputation systems) are
  research extensions, not protocol fixes.
- **Limited replay protection.** Replays are suppressed only by the bounded
  `(src, seq)` dedup history; once an entry is evicted, a replay is possible.

## Reporting a vulnerability

This is a research / educational codebase. If you find a memory-safety or
resource-exhaustion issue in the parser (the in-scope surface above), please
open an issue describing the malformed input and the observed behaviour.
Where enabled, GitHub's private vulnerability reporting (**Security → Report a
vulnerability** on the repo) is the preferred channel; the open-issue route
remains available.

## Verifying a release

Every release from v2.3.0 on can be checked three ways (#614). The release
workflow runs each check itself before it publishes, so a release whose
signatures do not verify never goes out.

**1. Integrity: the checksum.** It is published twice, in the release body
and as the `.sha256` asset.

```bash
sha256sum -c anthocnet-X.Y.Z.zip.sha256
```

**2. Origin: signed build provenance.** The install bundle and the drop-in
ns-3 module tarball carry SLSA build provenance. It is signed keylessly
(Sigstore) with the identity of `release.yml` in this repository, and it is
stored in GitHub's attestation store. With the [GitHub CLI](https://cli.github.com/):

```bash
gh attestation verify anthocnet-X.Y.Z.zip --repo danieljoppi/AntHocNet
gh attestation verify anthocnet-ns3-modules-X.Y.Z.tar.gz --repo danieljoppi/AntHocNet
```

The same Sigstore bundle is attached to the release as
`anthocnet-X.Y.Z.provenance.sigstore.json`, for offline checking or for
tools other than `gh`, such as `cosign verify-blob-attestation`.

**3. Contents: the SBOM.** `anthocnet-X.Y.Z.spdx.json` is an SPDX software
bill of materials of the unpacked bundle. It is attested against the zip, so
you can check that the SBOM belongs to the file you downloaded:

```bash
gh attestation verify anthocnet-X.Y.Z.zip --repo danieljoppi/AntHocNet \
  --predicate-type https://spdx.dev/Document/v2.3
```

**Container images.** `ghcr.io/danieljoppi/anthocnet-ns3` and
`ghcr.io/danieljoppi/ns3` are signed with cosign (keyless) by digest, so
every tag of an image is covered. The AntHocNet image also carries build
provenance in the registry.

```bash
cosign verify ghcr.io/danieljoppi/anthocnet-ns3:3.48 \
  --certificate-identity-regexp '^https://github.com/danieljoppi/AntHocNet/\.github/workflows/(images|release)\.yml@' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
gh attestation verify oci://ghcr.io/danieljoppi/anthocnet-ns3:3.48 --repo danieljoppi/AntHocNet
```

Releases before v2.3.0 have only the checksum.
