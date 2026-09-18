# Mocca v0.1 — Puppy requirements

These requirements refine the approved [discovery brief](discovery.md). An
implementation-ready specification is approved through explicit human approval
under the current autonomy policy; v0.1 adds no approval metadata or workflow.

## Functional requirements

| ID | Requirement |
| --- | --- |
| FR-1 | `scripts/bootstrap DESTINATION` creates a technology-neutral Mocca workspace in an empty destination. |
| FR-2 | The workspace exposes discoverable instructions, Engineering State, approval boundaries, Project Pulse, discovery and technology guidance, architecture/ADR and specification locations, and `scripts/verify`. |
| FR-3 | The workspace guides a project through Discovery, technology selection, required Profile Discovery, Specification, Implementation Ready, Implementation, and verification without product implementation in earlier phases. |
| FR-4 | Generated `./scripts/verify` validates the engineering-workspace contract before an implementation stack exists. |
| FR-5 | The workflow defines bounded implementation autonomy, test-first practice for reasonably testable behavior, vertical checkpoints, and verification-backed closure: a checkpoint closes only after its required command succeeds with exit status 0; a known verification failure invalidates closure and completion. |
| FR-6 | Core records Approved capabilities, discovers compatible local Catalog entries deterministically, and requires human selection before Profile Application. |
| FR-7 | `scripts/apply-profile` fetches an explicitly selected, commit-pinned GitHub Profile; validates Catalog/payload parity and Profile Contract v1.1; materializes only safe declared environment and conventions contributions; and updates Applied Profiles atomically. |
| FR-8 | `python-django` provides a Python/Django/uv engineering environment without product-source scaffolding. |
| FR-9 | `docker` provides only Docker engineering conventions for an approved `containerization:docker` capability; it does not install or execute Docker or contribute product artifacts. |

## Non-functional requirements

| ID | Requirement |
| --- | --- |
| NFR-1 | Bootstrap without `--profiles` selects no application framework, language runtime, database configuration or schema, container stack, or technology profile. Explicit `--profiles` selection is a human technology decision made before workspace lifecycle initialization. |
| NFR-2 | A developer and coding agent can discover the workflow, rules, decision locations, and completion gate from workspace files without repeated out-of-band instructions. |
| NFR-3 | Workspace-contract verification is deterministic and callable through `./scripts/verify`; Mocca's own CI uses its root command. |
| NFR-4 | Recommended and optional capabilities degrade gracefully: Core does not install, provision, or claim unavailable tools, and an unavailable capability blocks only an operation that truly requires it. |
| NFR-5 | Profile payloads remain optional extensions; Core owns only generic Catalog and application safeguards that serve every generated workspace. |

## Acceptance criteria

1. Bootstrap succeeds in a fresh empty destination and produces the artifacts
   required by FR-2.
2. A Core-only generated workspace contains no application manifest, framework
   project, runtime dependency declaration, database configuration or schema,
   CI configuration, Applied Profile, or product source tree.
3. Generated `./scripts/verify` succeeds only when the required workspace
   artifacts exist.
4. A reviewer can locate the workflow, normative principles, discovery and
   decision locations, autonomy boundaries, and completion gate from generated
   workspace files.
5. Root `./scripts/verify` validates Mocca's bootstrap contract, and CI invokes
   that same root command.
6. A project can record discovery and consequential decisions before creating
   implementation specifications; Core-only bootstrap implies no technology
   selection.
7. Approved capabilities use literal subset matching against local Catalog
   metadata; compatible Profiles are offered but never applied automatically.
8. Profile Application rejects unsafe, conflicting, duplicate, malformed, or
   mismatched inputs before workspace writes.
9. A generated workspace treats only required verification commands that exit
   0 as successful evidence; a known verification failure keeps the affected
   checkpoint open and prevents a completion claim or Project Pulse `done`.

## Traceability

| Requirements | Discovery evidence |
| --- | --- |
| FR-1, NFR-1, AC-1–2 | Vision, scope, technology-neutral bootstrap constraint, ADR 0002 |
| FR-2–3, NFR-2, AC-4 & AC-6 | Primary use case, discoverability goal, success criterion |
| FR-4, NFR-3, AC-3 & AC-5 | Verification constraint, success criterion, verification contract |
| FR-5 | Primary use case, explicit-decision goal, autonomy policy |
| FR-6–9, NFR-5, AC-7–8 | Approved Profile Contract and Catalog decisions, ADRs 0003–0005 |
| NFR-4 | Stay Small; tool-coupling and premature-automation risks |

## Puppy release gates

1. **PASS** — `./scripts/verify` passes locally.
2. **PASS** — CI invokes and passes `./scripts/verify`.
3. **PASS** — A clean-environment E2E reaches idea → implementation-ready specification
   → approved implementation → verification without hidden reliance on
   maintainer-installed integrations.
4. **PASS** — A no-Git E2E shows that Core and Profile Discovery work while Profile
   Application fails clearly and atomically.
5. **PASS** — A real remote Profile E2E fetches a pinned Profile, validates parity,
   materializes only its environment, and updates Applied Profiles.
6. **PASS** — Profile Contract security fixtures are exercised.
7. **PASS** — A full implementation E2E closes vertical checkpoints only after
   successful required verification, finishes with final verification green,
   and marks Project Pulse `done` only with no known failures.
8. **PENDING** — A real remote `docker` Profile E2E fetches its pinned payload,
   applies only conventions, and performs no Docker installation or execution.
9. **PENDING** — The Environment Readiness Gate demonstrates the approved
   capability-detection behavior without host provisioning.

## Deferred requirements

The [Puppy non-goals](discovery.md#non-goals) remain deferred. In particular,
v0.1 adds neither existing-project adoption nor a registry, solver, hooks,
runtime, installer, provisioning, `docker-make`, or multi-harness support.
