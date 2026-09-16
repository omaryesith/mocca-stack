# Mocca

**Reusable Agentic Engineering Stack**

> Small footprint. Big attitude.

<p align="center">
  <img src="assets/mocca-yorkie.png" alt="Mocca, the Yorkie engineering mascot" width="300">
</p>

Mocca is a lightweight, opinionated engineering workspace for humans and
coding agents. It helps define a project before implementation technology is
chosen, so important decisions are explicit and work is verifiable.

**Mocca does not start technology projects. It starts engineering processes.**

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

The default path is Core only: no language, framework, database, container
stack, or product source tree is selected.

If a human has already explicitly selected an engineering environment, apply
local Profiles at bootstrap:

```sh
./scripts/bootstrap ../my-project \
  --profiles python-django
```

Profiles prepare the approved engineering environment. They do not generate,
select, or pre-shape the product source tree.

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

Profiles are local, declarative, optional, and composable capability packs.
After technology selection, compatible Profiles are offered to the engineer;
they are never applied automatically.

> Profiles prepare the approved engineering environment. They must not create,
> select, or pre-shape the product source tree.

`python-django` is the current official reference Profile. It prepares Python,
Django, `uv`, linting, and test tooling without copying an application.

Use the [Profile Contract v1](docs/profile-contract-v1.md) for the normative
contract, safety boundary, composition rules, and third-party authoring model.
The [Profiles guide](profiles/README.md) is the starting point for available
and future local Profiles.

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
| Confidence and autonomy | Deterministic verification and bounded autonomy |

> Mocca cares about responsibilities, not brands.

MCP integrations are opt-in. Use a recommended tool only when it improves the
responsibility at hand; bootstrap installs none of them.

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
| Profile metadata, safety, and composition | [Profile Contract v1](docs/profile-contract-v1.md) |
| Using or authoring local Profiles | [Profiles guide](profiles/README.md) |
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
