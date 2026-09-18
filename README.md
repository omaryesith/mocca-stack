<div align="center">

# Mocca

**Reusable Agentic Engineering Stack**

> Small footprint. Big attitude.

**Current version:** `v0.1 — Puppy`

*Learning not to chew the furniture yet.* 🐶

English | [Español](README.es.md)

</div>

<p align="center">
  <img src="assets/mocca-yorkie.png" alt="Mocca, the Yorkie engineering mascot" width="300">
</p>

Mocca is a lightweight, opinionated engineering workspace for humans and
coding agents. It helps define a project before implementation technology is
chosen, so important decisions are explicit and work is verifiable.

**Mocca does not start technology projects. It starts engineering processes.**

Puppy establishes the technology-neutral Core and its safe Profile lifecycle.
Its normative [scope](docs/discovery.md) and
[release gates](docs/requirements.md) record the current v0.1 evidence and
remaining release work.

## Quick Start

Clone Mocca and bootstrap a technology-neutral workspace:

```sh
git clone https://github.com/omaryesith/mocca-stack.git
cd mocca-stack

./scripts/bootstrap ../my-project
cd ../my-project
./scripts/verify
```

Open your coding-agent harness and start with:

```text
I want to build a software project.

The idea is:

<describe the idea here>

Use this workspace to guide the project from this idea to an
implementation-ready specification.

Ask only what you need to resolve relevant ambiguity.
```

Mocca then guides the project through discovery, specification, approved
decisions, and implementation readiness.

### Starting with a known engineering environment

Core only is the default path: no language, framework, database, container
stack, or product source tree is selected.

If a human has already explicitly selected an engineering environment, apply
Catalog-backed Profiles at bootstrap:

```sh
./scripts/bootstrap ../my-project \
  --profiles python-django
```

Profiles prepare the approved engineering environment. They do not generate,
select, or pre-shape the product source tree.

`--profiles` is an explicit human selection. Inside an existing workspace,
apply a selected Profile through the canonical applicator:

```sh
./scripts/apply-profile --profiles python-django
```

## What Mocca is

Mocca creates an agent-ready engineering workspace before a project becomes an
application. It gives humans and agents a shared place for intent, decisions,
boundaries, specifications, and deterministic verification.

It exists because raw agent capability alone can lead to unagreed assumptions,
premature technology choices, implicit architecture, and plausible-looking
code without adequate evidence.

Mocca is intentionally not:

- an application framework;
- a project starter or product generator;
- an agent runtime;
- a workflow engine or orchestration platform;
- a replacement for a framework, coding harness, or deterministic tooling.

Technology follows requirements.

## How it works

```text
idea
→ discovery
→ requirements and clarification
→ technology selection
→ architecture and ADRs
→ implementation specification
→ implementation
→ verification
```

The workspace has four global engineering states:

```text
DISCOVERY → SPECIFICATION → IMPLEMENTATION_READY → IMPLEMENTATION
```

They make the allowed work, approval boundaries, and completion criteria
discoverable from the workspace itself. Read the generated
[workflow guide](templates/core/docs/workflow.md) for the lifecycle and state
semantics.

Profile lifecycle remains separate from Engineering State:

```text
Approved capabilities
→ local Profile Catalog
→ compatible Profile
→ human selection
→ remote fetch
→ validation
→ Profile Application
→ Applied Profiles
```

The Catalog contains local metadata; an explicitly selected Profile payload is
fetched on demand from a source pinned to an immutable commit SHA. Read the
[Profile Catalog Contract v1](docs/profile-catalog-contract-v1.md) for details.

## Core concepts

Mocca Core is technology-neutral. It owns the reusable engineering process,
not a preferred application stack.

- **Engineering State** declares the current global phase and prevents process
  drift without repeated prompt instructions.
- **Project Pulse** is active only during `IMPLEMENTATION`; it records current
  focus and observable checkpoint progress. It is not a backlog or project
  manager.
- **Implementation practice** favors Spec-Driven Development, test-first for
  reasonably testable behavior, vertical checkpoints, and verification-backed
  closure.
- **Product layout** defaults to `app/` for a simple application. Another
  layout is valid when the approved architecture or stack convention justifies
  it.
- **Autonomy** remains bounded by approved scope and consequential decision
  gates. Autonomy is earned through verification.

The detailed lifecycle, Pulse semantics, layout rules, and implementation
practice live in the [workflow guide](templates/core/docs/workflow.md).

## Profiles

Profiles are declarative, optional, and composable capability packs. Core
ships local Catalog metadata; compatible payloads are fetched on demand after
human selection from sources pinned to immutable commit SHAs.

> Profiles prepare the approved engineering environment. They must not create,
> select, or pre-shape the product source tree.

Normal application happens in `IMPLEMENTATION_READY` through
`scripts/apply-profile`. Profiles do not generate application scaffolds.

Available Profiles:

| Profile | Engineering environment | Does not add |
| --- | --- | --- |
| `python-django` | Python, Django, `uv`, `pyproject.toml`, lint/testing baseline | `app/`, `manage.py`, models, views, routes, auth, or product behavior |
| `docker` | Docker engineering conventions for approved containerization | Dockerfiles, Compose, `.dockerignore`, Docker execution, or product behavior |

Use the [Profile Contract v1](docs/profile-contract-v1.md) for payload safety
and composition, and the [Profile Catalog Contract v1](docs/profile-catalog-contract-v1.md)
for discovery and pinned sources. The [Profiles guide](profiles/README.md) is
the starting point for available and future Profiles.

## Chef's Recommendation

Mocca is technology-agnostic, but not opinion-less. It maps responsibilities
to current preferred implementations without turning them into conceptual
dependencies.

| Responsibility | Current recommendation |
| --- | --- |
| Agent harness | Codex |
| Engineering discipline | Ponytail |
| Codebase intelligence | Graphify |
| Spec-driven workflow | GitHub Spec Kit |
| Current library documentation | Context7 |
| Repository context | GitHub MCP, when useful |
| Operational environment | Docker, when it provides concrete value |
| Confidence and autonomy | Deterministic verification and bounded autonomy |

> Mocca cares about responsibilities, not brands.

MCP integrations are opt-in. Use a recommended tool only when the active
harness exposes it and it materially improves the responsibility at hand;
otherwise use Mocca's Core fallback. Bootstrap installs and probes none of
them. Core remains usable without Ponytail, Graphify, Spec Kit, Context7, or
MCPs; Mocca never claims an unavailable capability was used or provisions one.

Docker is recommended when it provides operational value, not required by
Core, Bootstrap, Discovery, or Specification. If unavailable, it blocks only
an operation that actually requires Docker; Mocca never installs, provisions,
or modifies the host. Its future materialization belongs to an optional Profile,
not Core.

## Dogfooding

Mocca develops Mocca. Its own vision, scope, constraints, constitution,
decisions, autonomy policy, and verification contract use the same approach it
recommends to generated workspaces.

If that process becomes heavy, unclear, repetitive, or impractical while
building Mocca, that is evidence the design belongs outside Core.

> Mocca should be comfortable living in its own dog house.

> Eat your own dog food. Guard your own house.

The Yorkie spirit is small, focused, fearless, and serious about boundaries.
The authoritative [Yorkie Principles](docs/constitution.md) govern Mocca's
development.

## Documentation map

| Need | Read |
| --- | --- |
| Yorkie Principles | [Constitution](docs/constitution.md) |
| Lifecycle, Engineering State, Pulse, layout, and implementation practice | [Workflow](templates/core/docs/workflow.md) |
| Approval boundaries and autonomy | [Autonomy policy](docs/autonomy.md) |
| Mocca verification contract | [Verification](docs/verification.md) |
| Profile payload safety and composition | [Profile Contract v1](docs/profile-contract-v1.md) |
| Profile availability and pinned remote sources | [Profile Catalog Contract v1](docs/profile-catalog-contract-v1.md) |
| Capability fallbacks and Docker posture | [Integrations](templates/core/docs/integrations.md) |
| Using or authoring Profiles | [Profiles guide](profiles/README.md) |
| Mocca's layers and extension boundary | [Architecture overview](docs/architecture/overview.md) |
| What an implementation-ready spec owns | [Specs guide](templates/core/specs/README.md) |

Generated workspaces carry their own operational instructions in `AGENTS.md`,
`MOCCA.md`, `docs/`, and `specs/`.

## Develop Mocca

Mocca itself is verified with:

```sh
./scripts/verify
```

Keep the core small. Extend at Profiles or project-local skills before changing
Core; a universal, lasting boundary needs demonstrated evidence and an ADR.

Mocca does not need to weigh 40 kg to guard the house.
