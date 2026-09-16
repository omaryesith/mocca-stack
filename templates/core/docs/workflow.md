# Workflow

Use the light path for trivial changes: understand, change, verify. For a new
project, work in this order:

`idea -> vision -> scope -> requirements -> constraints -> clarification -> technical options -> technology selection -> architecture -> ADRs -> implementation specs -> implementation`

GitHub Spec Kit is the Chef's Recommendation for a non-trivial specification,
not a required dependency. The native `docs/` and `specs/` workflow is
sufficient when Spec Kit is not installed or is not appropriate; its absence
must not block engineering work. Bootstrap never installs it.

Use Spec Kit only when clarified intent and requirements make a non-trivial
implementation specification likely to benefit from structured
specification, plan, and task decomposition. Do not initialize it during early
discovery merely because it is available.

When that threshold is met, initialize it with:

```sh
specify init --here --integration codex --integration-options="--skills"
```

Then converge through intent, specify, clarify, plan, tasks, implement, and
verify. Keep approved specs and plans as the source of truth; do not repeat
them in prompts.

## Graphify lifecycle

Initialize Graphify after the first meaningful codebase exists. Refresh it
after a feature changes architecture, modules, or important documentation.
When `graphify-out/graph.json` exists, query it before broad source-tree
exploration. Graphify is codebase intelligence, not a substitute for reading
the files directly involved in a change.

## Ponytail

Use Ponytail for the smallest correct implementation. Mocca owns project
constraints and verification, not generic simplification advice.
