# ADR 0005: Add Profile conventions contributions

**Status:** Accepted

## Context

Some approved capabilities need engineering rules without needing tooling
configuration or product scaffolding. The existing `environment/` contribution
cannot express that boundary clearly.

## Decision

Profile Contract v1.1 adds optional `contributions.conventions: conventions/`.
A Profile may contribute `environment/`, `conventions/`, or both; it does not
declare a rigid Profile type. `environment/` provides declarative engineering
configuration. `conventions/` provides active engineering practices for the
capability after explicit Profile application.

`conventions/` is flat and Markdown-only. It is materialized at
`.mocca/profiles/<profile>/conventions/`, a reserved Core namespace. Mocca
does not execute or interpret its content. Material deviations are documented
in the applicable specification, architecture record, or ADR.

`schema_version` remains `1`: existing environment-only Profiles remain valid.
Older strict parsers reject a new `conventions` key safely instead of applying
it partially.

## Consequences

Profiles can add engineering guidance without becoming application starters,
plugin runtimes, or template engines. The applicator validates and plans both
contribution types before writing, while dependencies, conflicts, explicit
composition order, and `reapply: fail` remain unchanged. Automated enforcement
of convention content is deliberately out of scope.
