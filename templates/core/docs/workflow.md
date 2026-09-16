# Workflow

Use the light path for trivial changes: understand, change, verify. For a new
project, work in this order:

`idea -> vision -> scope -> requirements -> constraints -> clarification -> technical options -> technology selection -> architecture -> ADRs -> implementation specs -> implementation`

## Clarification exit

Clarify until the remaining ambiguity would change approved architecture,
security or authorization, data integrity, or observable acceptance criteria.
Defer local implementation tactics and low-frequency edge cases to the
specification or implementation unless they create such a conflict.

## Engineering state

`MOCCA.md` declares the current phase. The phase determines the kind of work
that is appropriate; autonomy and approval gates remain in
`docs/autonomy.md`, and verification remains `./scripts/verify`.

| Phase | Allowed work | Prohibited work | Exit |
| --- | --- | --- | --- |
| `DISCOVERY` | Intent, scope, high-level requirements, constraints, clarification, and technical direction. | Product implementation, deployment or infrastructure changes, and production migrations. | A human explicitly approves `SPECIFICATION` after blocking ambiguity is resolved enough to create a non-trivial specification. |
| `SPECIFICATION` | Implementation-ready behavior, acceptance criteria, architecture drafts/ADRs, and blocking clarification. | Product implementation, deployment or infrastructure changes, and production migrations. | A human explicitly approves `IMPLEMENTATION_READY` after the specification is implementation-ready, consequential decisions are recorded, and verification passes. |
| `IMPLEMENTATION_READY` | Review or correct the approved specification. | Product implementation, deployment or infrastructure changes, and production migrations. | An explicit human instruction to begin implementation approves `IMPLEMENTATION`. |
| `IMPLEMENTATION` | Implement and verify within approved specifications, subject to autonomy and approval gates. | Work outside approved specifications. | No further transition is defined yet. |

An unambiguous human instruction to advance a phase is explicit approval; a
question, request for status, or request to describe possible implementation
is not. After approval, an agent may update `MOCCA.md` as part of the
authorized work. If a blocking ambiguity appears later, stop prohibited work;
with explicit human approval, return to `DISCOVERY` or `SPECIFICATION`.

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
