# Discovery

## Problem statement

Coding agents can accelerate engineering, but without a discoverable process
they encourage unagreed assumptions, premature technology choices, implicit
architecture decisions, unnecessary complexity, and unverified output.

## Target users

Mocca v0.1 serves individual software developers and small software teams
that actively use coding agents in their engineering workflow. Consultants and
independent engineers are relevant, but large platform teams and enterprise
governance are not optimization targets for v0.1.

## Primary use case

Start a new software project from an idea and guide it through discovery,
requirements, clarification, technical decisions, architecture, ADRs, and an
approved implementation-ready specification before significant coding begins.

## Vision

Mocca is a small, reusable, agent-ready engineering stack that helps humans
and coding agents define a project before selecting its implementation stack.

## Goals

- Make the project rules and workflow discoverable from the workspace itself.
- Support explicit consequential decisions before implementation.
- Keep the process small enough to be useful to its own maintainers and other
  developers using coding agents.

## Scope

Mocca provides a technology-neutral workspace, disciplined discovery and
specification workflow, bounded autonomy, deterministic verification, and
optional capability packs.

## Non-goals

Mocca is not an application framework, project generator, agent runtime,
custom CLI, MCP bundle, or replacement for framework tooling. Adopting Mocca
into an existing project is also out of scope for v0.1.

## Constraints

- Bootstrap remains destination-only and technology-neutral.
- Profiles follow an approved technology decision and do not modify core.
- Integrations, especially MCP, are opt-in; recommendations are not hard
  conceptual dependencies.
- Core changes need a universal need; enduring boundary changes need an ADR.
- `./scripts/verify` is the completion gate unless an environmental limitation
  is documented.

## Success criterion

> A developer and coding agent can bootstrap a Mocca workspace, complete
> discovery, make and record consequential decisions, reach an approved
> implementation-ready specification, and verify the workspace without
> repeated out-of-band instructions.

## Risks

1. **Process bloat:** Mocca becomes more ceremonial than useful.
2. **Instruction duplication and drift:** README, AGENTS, docs, templates,
   and future skills diverge.
3. **Tool coupling:** Chef's Recommendation becomes a hard dependency rather
   than a capability mapping.
4. **Premature automation:** CLI, installers, orchestration, MCP setup, or
   other machinery is added before repeated use demonstrates the need.
5. **False confidence from agents:** deterministic verification remains too
   weak to justify confidence in the process.
6. **Dogfooding bias:** Mocca overfits the maintainer's workflow instead of
   remaining useful to other developers and small teams.

## Open questions

No material question blocks v0.1 discovery. Existing-project adoption and a
profile-application mechanism are deliberately deferred rather than implied
by this scope.
