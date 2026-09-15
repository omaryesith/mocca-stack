# ADR 0002: Keep bootstrap technology-neutral

**Status:** Accepted

## Context

Mocca began with a Django proving pack on the bootstrap path. That made a
technology decision before a project had defined requirements or constraints.

## Decision

`scripts/bootstrap` copies only `templates/core`. The Django pack lives under
`profiles/python-django/` and is considered only after an approved technology
decision.

## Consequences

Generated projects begin as engineering workspaces, not applications. Profile
application remains deferred until a demonstrated need establishes its minimum
mechanism.
