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
| `DISCOVERY` | Intent, scope, high-level requirements, constraints, clarification, and technical direction. | Product implementation, deployment or infrastructure changes, and production migrations. | A human explicitly approves `SPECIFICATION` after blocking ambiguity is resolved enough to create a non-trivial specification and Profile Discovery is resolved for every approved technology or relevant capability. |
| `SPECIFICATION` | Implementation-ready behavior, acceptance criteria, architecture drafts/ADRs, and blocking clarification. | Product implementation, deployment or infrastructure changes, and production migrations. | A human explicitly approves `IMPLEMENTATION_READY` after the specification is implementation-ready, consequential decisions are recorded, Profile Discovery is resolved and documented for every approved technology or relevant capability, and verification passes. |
| `IMPLEMENTATION_READY` | Review or correct the approved specification. | Product implementation, deployment or infrastructure changes, and production migrations. | An explicit human instruction to begin implementation approves `IMPLEMENTATION`. |
| `IMPLEMENTATION` | Implement and verify within approved specifications, subject to autonomy and approval gates. | Work outside approved specifications. | Complete checkpoints, surface stop conditions, and continue within approved scope as defined by `docs/autonomy.md`. |

An unambiguous human instruction to advance a phase is explicit approval; a
question, request for status, or request to describe possible implementation
is not. After approval, an agent may update `MOCCA.md` as part of the
authorized work. If a blocking ambiguity appears later, stop prohibited work;
with explicit human approval, return to `DISCOVERY` or `SPECIFICATION`.

## Profile Discovery gate

After technology or a relevant capability is approved, resolve Profile
Discovery before asking for the `DISCOVERY` to `SPECIFICATION` transition:
inspect local Catalog entries, identify compatible candidates, present them to
the human, and resolve selection or rejection. Discovery never applies a
Profile. Selection resolves the gate; normal application happens later in
`IMPLEMENTATION_READY` through `scripts/apply-profile`.
If technology is approved during `SPECIFICATION`, resolve this gate immediately
before further architecture work and always before `IMPLEMENTATION_READY`.
Follow `docs/technology.md` for the procedure and record its outcome there,
in an ADR, or in the relevant specification.

## Project Pulse

Project Pulse is a compact section in `MOCCA.md`, separate from Engineering
State. It is an operational resume index, not a source of behavior, scope,
acceptance criteria, architecture, or approval. Specifications remain
authoritative when Pulse disagrees with a spec.

Leave Pulse inactive before `IMPLEMENTATION`; `IMPLEMENTATION_READY` does not
activate progress. During `IMPLEMENTATION`, use this compact shape:

```md
## Project Pulse

**Current focus:** `specs/<spec>.md` — checkpoint 2 / 4
**Next:** verify checkpoint 2

| Spec | Status | Checkpoints | Current checkpoint | Blocked |
| --- | --- | --- | --- | --- |
| `specs/<spec>.md` | in_progress | 2 / 4 | <short checkpoint name> | — |
```

Add an `External dependency` column when one becomes relevant:

```md
| Spec | Status | Checkpoints | Current checkpoint | External dependency | Blocked |
| --- | --- | --- | --- | --- |
| `specs/<spec>.md` | ready_for_verification | 2 / 4 | payment posting | Supabase project for RLS verification | — |
```

Use only `pending`, `in_progress`, `blocked`, `ready_for_verification`, and
`done` for the spec's state within `IMPLEMENTATION`, not for an individual
checkpoint. `Current checkpoint` identifies active work; `Checkpoints X / Y`
shows checkpoint progress. `ready_for_verification` means work planned for the
current cut is implemented but required verification evidence remains pending.
`done` means all defined checkpoints for that spec are complete and all
required verification has passed.

Verification evidence is valid only when the required command completed with
exit status 0. A checkpoint may close only after its required verification
passes. A known non-zero result keeps the affected checkpoint open or reopens
it: record the failed command and concrete result, keep Pulse `in_progress`
while safe corrective work remains, or use `blocked` only when work cannot
safely continue. Never leave Pulse `done`, declare the spec complete, claim
verification success, or claim implementation completion while any required
verification failure is known. Do not infer verification success from prior
successful runs, partial output, documentation state, expected state, or an
intent to run verification.

Pulse may be `done` only when all checkpoints are closed, every required
verification command completed with exit status 0, and no known failing test
or verification remains.

Define coarse checkpoints from the spec or implementation plan before
`IMPLEMENTATION` begins; do not use percentages, task history, estimates, or
invented detail. Each checkpoint represents an observable capability and needs
a definition of closure and verification evidence; favor vertical capabilities
over accumulated layer-only work. A spec with no meaningful breakdown uses one
checkpoint. Treat the current checkpoint as the execution unit. At each
verifiable closure—or when required verification becomes explicitly
pending—update Pulse before advancing to later checkpoints. Do not silently
skip several checkpoints in Pulse. `Current focus` identifies active work
only: it does not certify prior checkpoints as fully verified when an external
dependency or pending verification is explicitly recorded.

Do not begin implementation work for checkpoint N+1 until checkpoint N has
reached verified closure or `ready_for_verification` with its pending evidence
explicitly recorded in Pulse. Update Pulse at that boundary before starting the
next checkpoint; do not silently jump from `0 / N` to `N / N`. Multiple
checkpoints may proceed autonomously in one agent turn after each boundary is
recorded. No human approval or handoff is required between ordinary
checkpoints.

An external dependency is visible when it becomes relevant, even if useful
local work can continue. Use `blocked` only when no significant progress can
continue until a concrete actionable reason is resolved, such as awaiting an
approval, unavailable test environment, missing dependency, or unresolved
architecture decision. Neither `blocked` nor `done` accepts a spec, authorizes
a new phase, or changes Engineering State.

Within approved implementation scope, an agent may update Pulse to reflect
completed checkpoints or blockers without separate approval. Pulse never
changes scope, specs, architecture, approval, or Engineering State.

## Product source layout

Keep Mocca-owned paths at the workspace root. For a simple application,
`app/` is the default product source directory. Use another layout only when
approved architecture or established stack conventions provide a concrete
benefit; record the brief reason in the relevant specification or architecture
note before implementation. Layouts such as `apps/web`, `apps/api`,
`packages`, `frontend`, or `backend` remain valid when justified. Do not move,
overwrite, or reuse Mocca-owned paths only to satisfy an external scaffold.

## Implementation practice

Use spec-driven development as the default. For each reasonably testable
product behavior, create at least one relevant acceptance or behavior test
before implementing that behavior. Run it and confirm that it fails for the
expected reason; then implement the minimum needed to make it pass, refactor
with tests green, and run the required verification. Create only the minimum
scaffolding needed to write and run the first test; scaffolding must not
implement the product behavior itself. If test-first is not appropriate, state
the reason and alternative verification strategy in the spec before
implementation. Do not close a checkpoint without its required verification
evidence.

GitHub Spec Kit is the Chef's Recommendation for a non-trivial specification,
not a required dependency. The native `docs/` and `specs/` workflow is
sufficient when Spec Kit is not installed or is not appropriate; its absence
must not block engineering work. Bootstrap never installs it.

Use Spec Kit only when it is available and clarified intent and requirements
make a non-trivial implementation specification likely to benefit from
structured specification, plan, and task decomposition. Do not initialize it
during early discovery merely because it is available.

When that threshold is met and Spec Kit is available, initialize it with:

```sh
specify init --here --integration codex --integration-options="--skills"
```

Then converge through intent, specify, clarify, plan, tasks, implement, and
verify. Keep approved specs and plans as the source of truth; do not repeat
them in prompts.

## Graphify lifecycle

Use Graphify after the first meaningful codebase exists only when the active
harness exposes it and it materially improves exploration. Refresh it after a
feature changes architecture, modules, or important documentation. When
Graphify is available and `graphify-out/graph.json` exists, query it before
broad source-tree exploration. Otherwise explore the relevant repository files normally.
Graphify is codebase intelligence, not a substitute for reading the files
directly involved in a change.

## Ponytail

Use Ponytail for the smallest correct implementation only when the active
harness exposes it and it materially improves the work. Otherwise apply the
Yorkie Principles, specifications, checkpoints, test-first practice, and
verification directly. Mocca owns project constraints and verification, not
generic simplification advice.
