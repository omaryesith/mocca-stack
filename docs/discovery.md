# Discovery

## Vision

Mocca is a small, reusable, agent-ready engineering stack that helps humans
and coding agents define a project before selecting its implementation stack.

## Scope

Mocca provides a technology-neutral workspace, disciplined discovery and
specification workflow, bounded autonomy, deterministic verification, and
optional capability packs.

## Non-goals

Mocca is not an application framework, project generator, agent runtime,
custom CLI, MCP bundle, or replacement for framework tooling.

## Constraints

- Bootstrap remains destination-only and technology-neutral.
- Profiles follow an approved technology decision and do not modify core.
- Integrations, especially MCP, are opt-in; recommendations are not hard
  conceptual dependencies.
- Core changes need a universal need; enduring boundary changes need an ADR.
- `./scripts/verify` is the completion gate unless an environmental limitation
  is documented.
