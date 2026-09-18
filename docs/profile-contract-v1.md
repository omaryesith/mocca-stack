# Profile Contract v1.1

A Profile is an optional, declarative capability pack. Its payload may be
fetched on demand from a local Catalog entry after explicit selection. It
never selects technology, changes Mocca Core, or runs hooks.

## Layout

```text
profiles/<name>/
├── profile.yaml
├── README.md
├── environment/     # optional
└── conventions/     # optional
```

Profiles prepare the approved engineering environment. They must not create,
select, or pre-shape the product source tree. Product source is created during
`IMPLEMENTATION` from approved specifications, architecture, ADRs, and
decisions.

`environment/` contains declarative engineering configuration only.
`conventions/` contains engineering practices for exercising an approved
capability. A Profile may contribute either directory or both.
`README.md` explains prerequisites, what is contributed, and how to verify it.
Commands documented there are not executed automatically by Mocca.

## Manifest

```yaml
schema_version: 1
name: example-profile
version: 1.0.0
description: One concise description.

capabilities:
  - language:example

lifecycle:
  apply_after: technology_selection
  apply_in: IMPLEMENTATION_READY

contributions:
  environment: environment/
  conventions: conventions/

matches: []
dependencies: []
conflicts: []
reapply: fail
```

Required fields are `schema_version`, `name`, `version`, `description`,
`capabilities`, `lifecycle`, and `contributions`. `matches`, `dependencies`,
and `conflicts` default to empty lists; `reapply` defaults to `fail`.
`capabilities` must contain at least one token. Within `contributions`,
`environment` and `conventions` are individually optional, but at least one
must be declared.

The v1 parser accepts this documented YAML subset only: top-level scalar
fields, two-space-indented list items, and the two mappings shown above. It
does not accept anchors, aliases, flow mappings, arbitrary nesting, or
expressions.

`schema_version` remains `1`; `name` must equal its directory name;
`lifecycle.apply_after` is `technology_selection` and
`lifecycle.apply_in` is `IMPLEMENTATION_READY`. When present,
`contributions.environment` is `environment/` and
`contributions.conventions` is `conventions/`. This is an additive v1.1
extension: Profiles using only `environment/` remain valid; older strict
parsers reject the unknown `conventions` key rather than applying it partially.

## Environment boundary

`environment/` is flat. It must contain at least one regular, non-executable
file and may not contain subdirectories or symbolic links. Its allowlist is
`pyproject.toml` and files ending in `.toml`, `.ini`, `.cfg`, `.yaml`, `.yml`,
or `.json`.

Generated or resolved project artifacts belonging to the consuming project
must not be contributed by a Profile. This includes dependency lockfiles such
as `uv.lock`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`,
`poetry.lock`, `Cargo.lock`, and `Gemfile.lock`. A project may generate and
version its own lockfile when its approved workflow requires it.

Profiles must not contribute source files, scripts, hooks, application trees,
routes, settings, models, migrations, views, forms, product templates, UI,
authentication, persistence behavior, or other product behavior. In
particular, `app/`, `src/`, `apps/`, `packages/`, `frontend/`, and `backend/`
do not belong in a v1 Profile contribution.

## Conventions boundary

`conventions/` is flat. It must contain at least one regular, non-executable
Markdown file (`.md`); subdirectories, symbolic links, hooks, scripts, source
files, product artifacts, and every other extension are rejected. Mocca does
not interpret or execute convention content.

When applied, convention files are materialized only at
`.mocca/profiles/<profile>/conventions/`. `.mocca/` is a reserved Core
namespace: Profiles cannot write conventions to the project root, `docs/`,
`specs/`, or product paths. Applied Profile conventions are active engineering
rules for their capabilities. A material deviation must be justified in the
relevant specification, architecture record, or ADR.

## Selection and matching

`matches` is a simple AND list of capability tokens. A Profile is compatible
when every `matches` token occurs literally in the Approved capabilities:

```text
profile.matches ⊆ approved_capabilities
```

Additional approved capabilities do not invalidate a Profile. For example, a
Profile matching `language:python` and `framework:django` remains compatible
when `database:sqlite` is also approved. Tokens use an open
`responsibility:value` namespace; matching is exact, with no fuzzy matching,
framework-specific inference, NLP, or closed taxonomy. An empty `matches` list
is not technology-filtered. Matching offers candidates; it never applies one
automatically.

After technology selection, inspect local Catalog entries and offer compatible ones
before the next lifecycle transition. This Profile Discovery is required after
technology approval, never applies a Profile automatically, and must be
resolved before `SPECIFICATION`; if technology is approved during
`SPECIFICATION`, it must be resolved immediately and before
`IMPLEMENTATION_READY`. If an engineer rejects a compatible Profile, clarify
and record the alternative materialization approach before implementation.

Passing `--profiles` to bootstrap is an explicit human selection. It may be
used for a project whose technology decision already exists outside the new
workspace; bootstrap does not infer that decision or write its rationale.
This selection occurs before the workspace lifecycle; `lifecycle.apply_in`
governs later application through `scripts/apply-profile` in an existing Core
workspace. The Catalog source is specified by
[Profile Catalog Contract v1](profile-catalog-contract-v1.md).

Applied Profiles are recorded operationally in `MOCCA.md` as a single ordered
list. They state that the listed Profiles were selected explicitly and their
engineering environments were materialized. An applied Profile's declared
capabilities do not need a second approval, but its rationale, product
architecture, persistence, authentication, deployment, security, and domain
decisions remain subject to their normal documentation and approval rules.

## Composition and safety

Profiles compose in the explicit `--profiles` order. There is no
dependency solver: every dependency must be selected and appear earlier in
that order. Missing or misordered dependencies, conflicts, duplicate Profiles,
and unsupported reapplication fail before destination writes.

All Profile environment and convention contributions, and Core-protected paths,
are inspected before writing. Any collision fails: there is no merge and no
last-profile-wins behavior.
`AGENTS.md`, `MOCCA.md`, `docs/`, `specs/`, and `scripts/verify` are protected
Core paths; any other existing path from `templates/core/` is protected too.
`reapply: fail` is the only v1 behavior.

`reapply: fail` first checks the Applied Profiles state; collisions remain an
independent second barrier.

Profile manifests contain no hooks or executable code. There is no registry,
plugin runtime, or automatic execution of third-party verification commands.
The workspace applicator fetches only explicitly selected, commit-pinned
GitHub payloads; it never executes their content. It validates every selected
contribution and plans all destinations before materializing either kind.
