# Mocca v0.1 — Puppy discovery

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

## v0.1 scope

Puppy includes:

- A technology-neutral Core, workspace bootstrap, Engineering State, explicit
  approval gates, bounded autonomy, Project Pulse, and deterministic
  verification.
- Clarification exit guidance; Spec-Driven Development, test-first practice
  for reasonably testable behavior, and vertical checkpoints.
- Product source separation from Core, with `app/` as the default for simple
  applications.
- Profile Contract v1.1, Profile Catalog Contract v1, Approved capabilities,
  deterministic matching, Profile Discovery, human selection, Applied
  Profiles, remote Profile Application, and `scripts/apply-profile`.
- The official `python-django` environment Profile and `docker`
  conventions-only Profile, graceful degradation, and Chef's Recommendation.
- Environment Readiness before Discovery: deterministic-first capability
  evidence, explicit degraded-mode acknowledgement, contextual reevaluation,
  and no host provisioning.
- Dogfooding, an English canonical README with Spanish human onboarding, and
  CI verification.

## Non-goals

Puppy excludes:

- Existing-project adoption; a Profile registry, marketplace, multiple
  catalogs, automatic catalog updates, remote search, non-GitHub providers,
  dependency solver, or Profile upgrades.
- Executable hooks or plugins; an agent runtime or orchestrator; host
  provisioning, automatic tool installation, or a global doctor.
- `docker-make`, or Dockerfile, Compose, or Makefile support in Profile
  Contract v1.
- Full normative localization, official multi-harness support, or a formal
  CLI, installer, or package manager.

Mocca is not an application framework, project generator, agent runtime, MCP
bundle, or replacement for framework tooling.

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

For Puppy release, this must be demonstrated in a clean environment through
an approved implementation and verification, without hidden dependence on the
maintainer's installed integrations. The observable release gates live in
[requirements.md](requirements.md).

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

No material product question blocks Puppy. All Puppy release gates are
complete; v0.1 is ready for release review.
