# Autonomy boundaries

## A0 — supervised

Propose meaningful changes before execution when a human requests it.

An explicit human request authorizes creation or updates to documentation,
discovery artifacts, requirements, architecture drafts, or specifications
within an already agreed scope. Separate approval remains required before
technology selection, authentication or authorization changes, persistent data
model changes, security boundaries, public interfaces, destructive operations,
external services or cost, or infrastructure topology.

## A1 — code changes

An agent may edit implementation and tests and run verification inside the
existing architecture.

## A2 — approved feature

An agent may carry an approved spec, plan, and task list through implementation
and iterative verification. Within explicitly approved implementation scope,
that authorization persists across ordinary steps and checkpoints: continue
with substantive work and verification rather than returning control after a
micro-step or responding only with intent.

Stop when a checkpoint is complete, a real blocker or approval gate appears, a
material conflict affects scope, architecture, data model, or security, an
external or destructive action lacks authorization, or a verification failure
cannot be resolved safely.

A verification failure invalidates checkpoint closure and completion until the
required verification is green. An agent may fix it autonomously when safely
within approved scope, but the checkpoint remains open and Pulse remains
`in_progress` while it does so. If it cannot be resolved safely, Pulse becomes
`blocked` with the concrete failure. A resolvable failure is still not a closed
checkpoint while verification remains red.
