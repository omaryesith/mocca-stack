# Workflow

Use the light path for trivial changes: understand, change, verify. For a new
project, work in this order:

`idea -> vision -> scope -> requirements -> constraints -> clarification -> technical options -> technology selection -> architecture -> ADRs -> implementation specs -> implementation`

For a non-trivial specification, GitHub Spec Kit is the Chef's Recommendation.
Initialize it only when the project is ready to use it:

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
