# ADR 0001: Extend at the edges

**Status:** Accepted

## Context

Mocca must grow through optional capabilities without turning its
technology-neutral workspace into a framework or a central plugin system.

## Decision

The core owns `templates/core` and the destination-only bootstrap contract.
Profiles and focused skills are extension boundaries. A profile lives in
`profiles/<name>/`, documents its responsibility, prerequisites,
contributions, and verification, and may provide `template/` content.

Adding an extension must not modify core. Change core only for a demonstrated
need shared by every generated workspace; record lasting boundary changes in
an ADR.

## Consequences

Mocca gains new capabilities by adding directories, not registries or runtime
abstractions. Profile application remains deliberately deferred until a real
need proves the smallest mechanism.
