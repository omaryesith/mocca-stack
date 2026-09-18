# ADR 0006: Add the Environment Readiness Gate

**Status:** Accepted

## Context

Recommended engineering capabilities can be present in a maintainer's harness
without being portable to a new project. Silent fallback hides that loss, while
treating every recommendation as mandatory would make Core needlessly rigid.

## Decision

Environment Readiness is a precondition before `DISCOVERY`, not an Engineering
State. Core ships `.mocca/chef-recommendations.yaml` as structured metadata for
initial recommendations. Each evaluated capability is `available`, `missing`,
or `unknown`; deterministic, side-effect-free evidence takes priority, and
missing harness introspection remains `unknown`.

Recommended degradation requires human acknowledgement before Discovery, then
uses the documented fallback without repeated warnings. A capability becomes
required only for an operation that actually needs it; `missing` or `unknown`
then blocks that operation without relabeling `unknown` as missing. Readiness
snapshots in `MOCCA.md` are compact records, not permanent availability caches;
contextual operations reevaluate mechanically.

The active harness may provide explicit skill or MCP inventories. Core never
scans personal paths, `HOME`, sessions, history, or configuration to infer
availability, and never installs, provisions, enables, or modifies the host.
`bark_mode` in `MOCCA.md` controls only presentation of actionable gates.
Profiles remain separate: their application stays declarative and inert.

## Consequences

New workspaces surface relevant missing capability support once before
Discovery, while Core remains usable after acknowledged degradation. No global
scanner, doctor, daemon, installer, capability registry, or Profile behavior
change is introduced.
