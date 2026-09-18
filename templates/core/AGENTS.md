# Agent map

Read `MOCCA.md` and `docs/constitution.md` before substantive work. Respect
the Engineering State declared in `MOCCA.md`; it determines which work is
permitted now. Follow `docs/workflow.md`; discovery and technology decisions
live in `docs/`, while implementation specifications live in `specs/`.
`docs/autonomy.md` defines what needs human approval.

Before substantive `DISCOVERY`, resolve Environment Readiness using
`.mocca/chef-recommendations.yaml` and `docs/integrations.md`. Use deterministic
evidence first; preserve `unknown` when the harness cannot expose deterministic
introspection. Do not infer availability from model behavior, prior
conversation, personal paths, `HOME`, sessions, or configuration files. Record
the compact result in `MOCCA.md`. A `DEGRADED` initial gate needs explicit human
acknowledgement before Discovery; after acknowledgement, use the documented
fallback without repeating the same warning. Recheck a capability
deterministically before an operation that requires it; `missing` or `unknown`
then blocks only that operation.

During `IMPLEMENTATION`, read and update Project Pulse in `MOCCA.md` as the
resume index for factual progress. Specifications remain authoritative; Pulse
does not change scope, architecture, approval, or Engineering State.

When work covers a capability represented by an Applied Profile, inspect that
Profile's conventions under `.mocca/profiles/<profile>/conventions/` before
making decisions or changes that affect the capability.

Run `./scripts/verify` before declaring work complete.
Do not declare verification success, checkpoint closure, spec completion, or
Project Pulse `done` unless all required verification commands completed with
exit status 0 and no known failures remain.

Use a recommended capability only when the active harness exposes it and it
materially improves the current operation. After required readiness
acknowledgement, use the documented Core fallback without repeated warnings.
Never claim an unavailable capability was used; probe personal installation
paths, `HOME`, or prior sessions; or install, provision, enable, or modify the
host automatically. Stop only an operation that truly requires a missing or
unverifiable capability, with one clear actionable error.
