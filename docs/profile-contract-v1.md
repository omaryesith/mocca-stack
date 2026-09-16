# Profile Contract v1

A Profile is a local, optional, declarative capability pack. It materializes
an explicitly selected technology or workflow; it never selects technology,
changes Mocca Core, runs hooks, or installs remote content.

## Layout

```text
profiles/<name>/
├── profile.yaml
├── README.md
└── environment/
```

Profiles prepare the approved engineering environment. They must not create,
select, or pre-shape the product source tree. Product source is created during
`IMPLEMENTATION` from approved specifications, architecture, ADRs, and
decisions.

`environment/` contains only additive engineering configuration. `README.md` explains prerequisites,
what is contributed, and how to verify it. Commands documented there are not
executed automatically by Mocca.

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

matches: []
dependencies: []
conflicts: []
reapply: fail
```

Required fields are `schema_version`, `name`, `version`, `description`,
`capabilities`, `lifecycle`, and `contributions`. `matches`, `dependencies`,
and `conflicts` default to empty lists; `reapply` defaults to `fail`.
`capabilities` must contain at least one token.

The v1 parser accepts this documented YAML subset only: top-level scalar
fields, two-space-indented list items, and the two mappings shown above. It
does not accept anchors, aliases, flow mappings, arbitrary nesting, or
expressions.

`schema_version` is `1`; `name` must equal its directory name;
`lifecycle.apply_after` is `technology_selection` and
`lifecycle.apply_in` is `IMPLEMENTATION_READY`; and
`contributions.environment` is `environment/`.

## Environment boundary

`environment/` is flat. It must contain at least one regular, non-executable
file and may not contain subdirectories or symbolic links. Its allowlist is
`pyproject.toml`, `uv.lock`, and files ending in `.toml`, `.ini`, `.cfg`,
`.yaml`, `.yml`, or `.json`.

Profiles must not contribute source files, scripts, hooks, application trees,
routes, settings, models, migrations, views, forms, product templates, UI,
authentication, persistence behavior, or other product behavior. In
particular, `app/`, `src/`, `apps/`, `packages/`, `frontend/`, and `backend/`
do not belong in a v1 Profile contribution.

## Selection and matching

`matches` is a simple AND list of capability tokens. A profile with
`language:python` and `framework:django` matches only when both are part of
the approved technology direction. An empty list is not technology-filtered.
Matching offers candidates; it never applies one automatically.

After technology selection, inspect local Profiles and offer compatible ones
before implementation. If an engineer rejects a compatible Profile, clarify
and record the alternative materialization approach before implementation.

Passing `--profiles` to bootstrap is an explicit human selection. It may be
used for a project whose technology decision already exists outside the new
workspace; bootstrap does not infer that decision or write its rationale.

## Composition and safety

Profiles are local and compose in the explicit `--profiles` order. There is no
dependency solver: every dependency must be selected and appear earlier in
that order. Missing or misordered dependencies, conflicts, duplicate Profiles,
and unsupported reapplication fail before destination writes.

All Profile environments and Core-protected paths are inspected before writing.
Any collision fails: there is no merge and no last-profile-wins behavior.
`AGENTS.md`, `MOCCA.md`, `docs/`, `specs/`, and `scripts/verify` are protected
Core paths; any other existing path from `templates/core/` is protected too.
`reapply: fail` is the only v1 behavior.

Profile manifests contain no hooks or executable code. There is no registry,
remote downloader, plugin runtime, or automatic execution of third-party
verification commands.
