# ADR 0004: Add local Profile Catalogs and on-demand application

**Status:** Accepted

## Context

A Core-only workspace can discover its workflow but cannot discover Profiles
stored only in the original Mocca checkout. Inferring Profiles from product
files is neither portable nor authoritative.

## Decision

Core includes local catalog metadata at `profiles/catalog/`; payloads remain
remote and are fetched only after explicit human selection. The workspace-owned
`scripts/apply-profile` validates catalog metadata, a pinned GitHub payload,
Profile Contract v1, parity, dependencies, conflicts, and collisions before
materializing a flat environment and recording Applied Profiles.

Normal application requires `IMPLEMENTATION_READY`. Bootstrap may call the
same applicator with its internal `--bootstrap-initialization` flag only while
a temporary staging marker exists, representing an explicit selection made
before workspace lifecycle initialization.

## Consequences

Workspaces remain portable and small. Git is required only when applying a
remote Profile; Core itself remains usable without it. GitHub access uses
existing environment credentials. A private source without access fails before
workspace writes. Catalog updates, registries, hooks, runtimes, and source
providers beyond GitHub remain deferred.
