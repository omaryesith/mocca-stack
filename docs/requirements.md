# v0.1 requirements

These requirements refine the approved [discovery brief](discovery.md). An
implementation-ready specification is approved through explicit human approval
under the current autonomy policy; v0.1 adds no approval metadata or workflow.

## Functional requirements

| ID | Requirement |
| --- | --- |
| FR-1 | `scripts/bootstrap DESTINATION` creates a technology-neutral Mocca workspace in an empty destination. |
| FR-2 | The workspace contains discoverable agent instructions, an operational index, discovery guidance, constitution, autonomy policy, architecture/ADR location, implementation-spec location, and `scripts/verify`. |
| FR-3 | The workspace provides explicit places to record vision, scope, requirements, constraints, clarification, technology selection, architecture decisions, and implementation-ready specifications. |
| FR-4 | Generated `./scripts/verify` validates the engineering-workspace contract before an implementation stack exists. |
| FR-5 | The workspace documents bounded autonomy and escalation boundaries so consequential decisions are recorded rather than silently assumed. |

## Non-functional requirements

| ID | Requirement |
| --- | --- |
| NFR-1 | Bootstrap selects no application framework, language runtime, database configuration or schema, container stack, or technology profile. |
| NFR-2 | A developer and coding agent can discover the workflow, rules, decision locations, and completion gate from workspace files without repeated out-of-band instructions. |
| NFR-3 | Workspace-contract verification is deterministic and callable through `./scripts/verify`; Mocca's own CI uses its root command. |
| NFR-4 | v0.1 requires no CLI, installer, runtime, orchestration layer, automatic external integration, or profile-application mechanism. |
| NFR-5 | Optional extensions remain outside core: adding one does not modify bootstrap or `templates/core` unless it serves every generated workspace. |

## Acceptance criteria

1. Bootstrap succeeds in a fresh empty destination and produces the artifacts
   required by FR-2.
2. The generated workspace contains no application manifest, framework
   project, runtime dependency declaration, database configuration or schema,
   CI configuration, or selected profile.
3. Generated `./scripts/verify` succeeds only when the required workspace
   artifacts exist.
4. A reviewer can locate the workflow, normative principles, discovery and
   decision locations, autonomy boundaries, and completion gate from generated
   workspace files.
5. Root `./scripts/verify` validates Mocca's bootstrap contract, and CI invokes
   that same root command.
6. A project can record discovery and consequential decisions before creating
   implementation specifications; bootstrap implies no technology selection.

## Traceability

| Requirements | Discovery evidence |
| --- | --- |
| FR-1, NFR-1, AC-1–2 | Vision, scope, technology-neutral bootstrap constraint, ADR 0002 |
| FR-2–3, NFR-2, AC-4 & AC-6 | Primary use case, discoverability goal, success criterion |
| FR-4, NFR-3, AC-3 & AC-5 | Verification constraint, success criterion, verification contract |
| FR-5 | Primary use case, explicit-decision goal, autonomy policy |
| NFR-4 | Stay Small; process-bloat and premature-automation risks |
| NFR-5 | Stay Focused, ADR 0001, instruction-drift and tool-coupling risks |

## Deferred requirements

- Existing-project adoption.
- Profile application and additional profiles.
- CLI, installers, registries, plugin runtime, and orchestration.
- MCP setup, external integrations, and new skills or tool adoption.
- Technology-specific requirements.
