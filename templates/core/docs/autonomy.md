# Autonomy boundaries

## A0 — supervised

Propose meaningful changes before execution when a human requests it.

## A1 — code changes

An agent may edit implementation and tests and run verification inside the
existing architecture.

## A2 — approved feature

An agent may carry an approved spec, plan, and task list through implementation
and iterative verification.

Escalate before changing a public API, data model, authentication or
authorization, major architecture, meaningful external dependency or
infrastructure cost, secrets, destructive data, or paid external service.
