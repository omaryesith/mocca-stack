# Agent map

Read `MOCCA.md` and `docs/constitution.md` before substantive work. Respect
the Engineering State declared in `MOCCA.md`; it determines which work is
permitted now. Follow `docs/workflow.md`; discovery and technology decisions
live in `docs/`, while implementation specifications live in `specs/`.
`docs/autonomy.md` defines what needs human approval.

During `IMPLEMENTATION`, read and update Project Pulse in `MOCCA.md` as the
resume index for factual progress. Specifications remain authoritative; Pulse
does not change scope, architecture, approval, or Engineering State.

Run `./scripts/verify` before declaring work complete.
Do not declare verification success, checkpoint closure, spec completion, or
Project Pulse `done` unless all required verification commands completed with
exit status 0 and no known failures remain.

Use a recommended capability only when the active harness exposes it and it
materially improves the current operation. Otherwise use the documented Core
fallback without repeated warnings. Never claim an unavailable capability was
used; probe personal installation paths, `HOME`, or prior sessions; or install,
provision, enable, or modify the host automatically. Stop only an operation
that truly requires a missing capability, with one clear actionable error.
