# ADR 0003: Add a local declarative Profile Contract v1

**Status:** Accepted

## Context

E2E #6 showed that an undocumented Django pack is neither discoverable nor
reliably applied after technology selection. Profiles need a small public
contract without turning Mocca into a plugin runtime or technology framework.

## Decision

Profiles live locally at `profiles/<name>/` and use the declarative Profile
Contract v1. Bootstrap accepts repeated explicit `--profiles NAME` selections
and preflights manifests, dependencies, conflicts, Core protection, and all
file collisions before writing. Profiles compose only in their declared order;
there is no solver, merge, or last-profile-wins rule.

Profiles are offered after approved technology selection and before
implementation, never applied automatically. Their manifests contain no hooks
or executable runtime. Core paths remain protected, and third-party
verification commands are documented rather than executed automatically.
Profiles contribute only a flat, allowlisted engineering environment; they do
not scaffold or pre-shape product source.

## Consequences

Core remains technology-neutral without `--profiles`. A human may explicitly
bootstrap a known stack with Profiles. Remote registries, downloads, hooks,
automatic verification execution, and `docker-make` are deliberately deferred.
