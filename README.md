# Mocca

**Reusable Agentic Engineering Stack**

> Small footprint. Big attitude.

<p align="center">
  <img src="assets/mocca-yorkie.png" alt="Mocca, the Yorkie engineering mascot" width="360">
</p>

Mocca is a lightweight, opinionated engineering layer for defining and building software projects with coding agents.

It creates the engineering workspace **before** an implementation stack is chosen.

Mocca is not an application framework, not a project generator, and not an agent runtime.

Its goal is to provide a disciplined, reusable environment where humans and coding agents can move from an idea to a well-defined project, make explicit technical decisions, and only then begin implementation.

---

## Why Mocca?

Modern coding agents are powerful, but raw capability is not enough.

Without structure, they can:

- make assumptions that were never agreed upon,
- select technologies too early,
- introduce unnecessary complexity,
- drift from the original intent,
- make architectural decisions implicitly,
- and produce code that looks plausible without being properly verified.

Mocca exists to reduce that ambiguity.

Instead of starting with:

```text
idea
→ code
```

Mocca encourages:

```text
idea
→ vision
→ scope
→ requirements
→ constraints
→ clarification
→ technical options
→ technology selection
→ architecture
→ ADRs
→ implementation specs
→ code
→ verification
```

The project is defined before the implementation starts.

---

## Dogfooding Mocca

Mocca is developed using the same engineering approach it recommends.

The project maintains its own vision, scope, constraints, engineering
constitution, architecture decisions, autonomy policy, and verification
contract using the same structures and principles generated for Mocca-enabled
projects.

In other words, Mocca is one of its own first users.

This is intentional.

If a workflow becomes too heavy, unclear, repetitive, or difficult to maintain
while developing Mocca itself, that is evidence that the workflow probably
does not belong in Mocca Core.

Likewise, if an agent cannot effectively work on Mocca using Mocca's own
instructions, boundaries, and verification contract, the problem should be
fixed in the stack rather than worked around outside it.

Dogfooding acts as a permanent design constraint:

> **Mocca should be comfortable living in its own dog house.**

Or, more appropriately for a Yorkshire Terrier:

> **Eat your own dog food. Guard your own house.**

Mocca's development therefore follows the same core principle it recommends
to other projects:

```text
intent
→ explicit decisions
→ bounded execution
→ deterministic verification
→ learning
→ refinement
```

The goal is not to prove that Mocca can solve every engineering problem.

The goal is to continuously prove that Mocca remains useful, small, and
practical enough to use on itself.

---

## The Yorkie Philosophy

Mocca takes its personality from the Yorkshire Terrier.

Yorkies are small, energetic, focused, determined, fearless, and famously convinced that they are much larger than they really are.

A 3 kg Yorkshire Terrier may sincerely believe it can take on a 40 kg dog.

Mocca follows the same spirit.

It is intentionally small, but it is designed to support serious engineering workflows.

Mocca also practices what it proposes: the project is developed using its own
engineering process. A Yorkie should be willing to guard its own house.

> **Small footprint. Big attitude.**

Mocca does not aim to become the largest engineering framework in the room.

It aims to be the one that gets the job done.

---

## The Yorkie Principles

Mocca stays small, acts big, stays focused, guards protected boundaries, barks
early, enables bounded autonomy, trusts deterministic verification, and knows
when humans must own consequential decisions. The authoritative rules for
developing Mocca are the [Yorkie Principles](docs/constitution.md).

---

## Core Idea

Mocca bootstraps an **engineering workspace**, not an application.

For example:

```sh
./scripts/bootstrap ../foo
cd ../foo
```

At this point Mocca should not assume:

- Python,
- Django,
- React,
- Node.js,
- PostgreSQL,
- Docker,
- AWS,
- or any other implementation technology.

The initial workspace exists to help define what the project is before deciding how it will be implemented.

A newly bootstrapped project is a blank engineering canvas.

---

## Engineering Flow

A typical Mocca project evolves through stages similar to:

```text
Idea
  ↓
Vision
  ↓
Scope
  ↓
Requirements
  ↓
Constraints
  ↓
Clarification
  ↓
Technical Options
  ↓
Technology Selection
  ↓
Architecture
  ↓
ADRs
  ↓
Implementation Specs
  ↓
Profiles / Capabilities
  ↓
Implementation
  ↓
Verification
```

Technology follows requirements.

Not the other way around.

---

## Bootstrap

Start a project with:

```sh
./scripts/bootstrap ../my-project
```

Then:

```sh
cd ../my-project
./scripts/verify
```

The generated workspace is technology-neutral.

It provides places and workflows for:

- project vision,
- scope,
- requirements,
- constraints,
- specifications,
- technology evaluation,
- architecture,
- ADRs,
- autonomy policy,
- integrations,
- and verification.

Bootstrap deliberately does **not** install an application stack.

---

## Mocca Core

Mocca Core is technology-agnostic.

Its responsibilities include:

- agent instructions,
- engineering principles,
- project discovery,
- specification workflows,
- architecture decisions,
- autonomy boundaries,
- verification contracts,
- and integration points.

Mocca Core should remain useful regardless of whether a project eventually uses Django, Laravel, Go, Rust, React, PostgreSQL, or something else.

---

## Profiles

Profiles are optional capability packs applied **after** relevant technical decisions have been made.

A profile is not a project starter.

It may introduce things such as:

- framework-specific skills,
- language-specific guidance,
- linters,
- type checking,
- testing tools,
- security tooling,
- dependency auditing,
- and implementation verification.

For example:

```text
profiles/
├── python/
├── django/
├── postgres/
├── react/
└── aws/
```

A Django profile should only become relevant after the project has explicitly decided to use Django.

---

## Extension Model

Mocca is open to extension at its edges and closed to incidental core changes.
The core owns the technology-neutral workspace contract: `templates/core` and
the behavior of `scripts/bootstrap`. A new capability belongs outside that
boundary unless it changes every Mocca workspace.

| Extension point | Contract |
|---|---|
| `profiles/<name>/` | A `README.md` declares responsibility, prerequisites, contributions, and verification. A `template/` directory is optional. |
| Project-local skills | Add focused judgment or workflow without duplicating core responsibilities. |
| Chef's Recommendation | Maps responsibilities to preferred tools; it does not make them conceptual dependencies. |

There is intentionally no central profile registry, plugin runtime, manifest,
or installer in v0.1. Adding a profile must not require editing bootstrap or
the core template. A future profile applicator, if earned, should discover
these directory conventions rather than encode a list of profiles.

Changes to the core require a demonstrated universal need and an ADR when the
boundary changes. The first such decision is
[`0001-extension-boundary`](docs/architecture/adr/0001-extension-boundary.md).

---

## Chef's Recommendation

Mocca is technology-agnostic, but not opinion-less.

The current recommended agentic engineering environment is called the **Chef's Recommendation**.

It currently maps engineering capabilities to:

| Capability | Recommended implementation |
|---|---|
| Agent harness | Codex |
| Engineering discipline | Ponytail |
| Codebase intelligence | Graphify |
| Spec-driven workflow | GitHub Spec Kit |
| Repository integration | GitHub MCP |
| Current library/framework documentation | Context7 |
| Verification | Deterministic CLI/tooling |
| Autonomy | Progressive, bounded autonomy |

The important principle is:

> **Mocca cares about responsibilities, not brands.**

These tools are the current recommended implementations of specific capabilities.

They are not meant to become permanent conceptual dependencies.

If a better tool appears, the capability remains valid even if the implementation changes.

---

## First-Class Integrations

### Codex

Codex is the first-class agent harness for Mocca.

Mocca should provide Codex with:

- clear instructions,
- structured project context,
- explicit workflows,
- verification commands,
- autonomy boundaries,
- and project-specific capabilities.

Mocca does not attempt to replace the Codex harness.

### Ponytail

Ponytail provides engineering discipline and helps resist unnecessary complexity.

Its role is broader than any specific language or framework.

Framework-specific skills should complement Ponytail rather than duplicate general engineering judgment.

### Graphify

Graphify provides structured codebase intelligence.

Its role becomes more important once implementation begins and the project develops meaningful internal structure.

### GitHub Spec Kit

Spec Kit provides the primary spec-driven workflow.

Mocca integrates around the idea that substantial implementation should begin from explicit intent and specifications rather than directly from prompts.

---

## MCP

MCP integrations are **opt-in**.

Bootstrap does not automatically connect external systems.

Mocca recommends using MCP when an agent genuinely benefits from access to external context or capabilities.

Examples may include:

- GitHub,
- issue trackers,
- observability platforms,
- databases,
- infrastructure providers,
- or current documentation systems.

The preferred principle is:

> Use MCP when it adds a capability that the local toolchain does not already provide cleanly.

More tools are not automatically better.

---

## Skills

Mocca favors small, responsibility-specific skills.

A skill should add domain-specific judgment or workflow guidance without duplicating responsibilities already covered elsewhere.

For example:

```text
Ponytail
→ general engineering discipline

Django skill
→ Django-specific engineering judgment

Context7
→ current Django documentation
```

A Django skill should know how to work effectively inside Django.

It should not redefine generic software engineering principles already handled by Ponytail.

---

## Verification

Mocca uses a stable verification interface.

For the Mocca repository:

```sh
./scripts/verify
```

For generated workspaces, the same command verifies the current engineering contract.

Before an implementation stack exists, verification checks the integrity of the engineering workspace.

After profiles are applied, profiles may extend verification with:

- tests,
- linting,
- type checking,
- security analysis,
- dependency auditing,
- framework checks,
- or other deterministic validation.

The contract remains stable even when the underlying tooling changes.

---

## Autonomy

Mocca treats autonomy as progressive.

Agents should gain autonomy as the project gains stronger verification and clearer boundaries.

A conceptual progression is:

```text
A0 — supervised
A1 — implementation changes
A2 — feature execution
A3 — workflow execution
A4 — long-running autonomy
```

Mocca does not equate autonomy with trust.

> **Autonomy is earned through verification.**

---

## Repository Structure

Current structure:

```text
mocca-stack/
├── .github/
│   └── workflows/
├── assets/
├── docs/
│   └── architecture/
│       └── adr/
├── profiles/
├── scripts/
├── templates/
│   └── core/
├── tests/
├── AGENTS.md
├── LICENSE
└── README.md
```

Key responsibilities:

```text
templates/core
→ technology-neutral engineering workspace

profiles
→ optional capabilities applied later

docs/architecture/adr
→ lasting decisions about Mocca itself

scripts/bootstrap
→ create a new Mocca-enabled workspace

scripts/verify
→ verify Mocca itself

tests
→ protect Mocca's behavioral contract
```

---

## What Mocca Deliberately Does Not Do

Mocca does not aim to:

- become an application framework,
- replace Django, Laravel, React, or other frameworks,
- become an agent runtime,
- replace Codex,
- replace Ponytail,
- replace Graphify,
- replace Spec Kit,
- bundle every MCP server,
- prescribe a universal application architecture,
- or install a technology stack before requirements exist.

Mocca should remain small enough to understand.

---

## Verify Mocca

Run:

```sh
./scripts/verify
```

The same verification contract may be used by CI for the Mocca repository itself.

Generated projects remain independent of any particular CI provider.

---

## Current Status

Mocca is still early.

The current focus is building a small, coherent core before expanding integrations or adding more profiles.

Current direction:

```text
technology-neutral bootstrap
→ discovery workflows
→ specification
→ technology selection
→ architecture
→ profiles
→ implementation
```

Not:

```text
bootstrap
→ immediately scaffold a framework
```

---

## The Mocca Rule

When deciding whether something belongs in Mocca, ask:

> Does this capability make the engineering process substantially better without making Mocca unnecessarily larger?

If the answer is no, leave it out.

Yorkies do not need to weigh 40 kg to act like they do.

Neither does Mocca.
