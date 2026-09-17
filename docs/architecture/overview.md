# Architecture overview

Mocca has three layers:

1. **Core:** `templates/core` and the destination-only `scripts/bootstrap`.
   They create a technology-neutral engineering workspace.
2. **Extensions:** `profiles/<name>/` and focused project-local skills. They
   add optional capabilities without modifying core.
3. **Development harness:** root `scripts/`, `tests/`, and CI verify Mocca's
   bootstrap contract.

Local Profile Catalog metadata is part of Core. Payloads are fetched only by a
workspace after explicit selection; see [ADR 0004](adr/0004-profile-catalog-and-application.md).

The Chef's Recommendation maps responsibilities to current preferred tools;
it is documentation, not an installed runtime dependency. The core boundary
is defined by [ADR 0001](adr/0001-extension-boundary.md). Technology-neutral
bootstrap and deferred profiles are defined by
[ADR 0002](adr/0002-technology-neutral-core.md).
