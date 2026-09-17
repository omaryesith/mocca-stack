# Integrations

Mocca cares about responsibilities, not brands. Use a recommended capability
only when the active harness exposes it and it materially improves the current
operation. Otherwise use the Core fallback without repeated warnings.

| Responsibility | Chef's Recommendation | Posture and fallback |
| --- | --- | --- |
| Agent harness | Codex | Expected harness; documented, never installed or detected by Bootstrap. |
| Engineering discipline | Ponytail | Recommended; use Yorkie Principles, specs, checkpoints, test-first, and verification when unavailable. |
| Codebase intelligence | Graphify | Recommended; explore the repository normally when unavailable. |
| Spec-driven workflow | GitHub Spec Kit | Optional; use native `docs/` and `specs/` when unavailable. |
| Repository context | GitHub MCP | Optional; use local repository context and Git where applicable. |
| Current library documentation | Context7 | Optional; use available documentation or ask for an external source only when needed. |
| Operational environment | Docker | Recommended when concrete operational value exists; native commands remain the fallback. |
| Remote Profile transport | Git | Required only by remote Profile Application; Profile Discovery is local. |
| Confidence and autonomy | Deterministic verification | Core rule; `./scripts/verify` is the stable interface. |

Use deterministic checks for deterministic questions. Replace a recommended
tool only when another implementation meets the same responsibility better.

Do not probe personal skill paths, scan `HOME`, inspect old sessions, install,
provision, enable, or modify the host, or claim an unavailable capability was
used. A missing capability stops only an operation that requires it;
`scripts/apply-profile` owns the Git check for remote Profile Application.
Bootstrap performs no global capability scan. Host changes require an explicit
human-requested task separate from Mocca's normal workflow.

## Docker consideration

During technical or operational design, consider whether Docker has a concrete
benefit or an unresolved containerization decision: multiple services,
reproducible dependencies, environment parity, onboarding consistency, or
CI/deployment needs. Offer it only when one of those signals exists. Record
acceptance, rejection, deferral, or clear irrelevance with the technical
direction; do not ask again unless architecture materially changes.

If containerization is accepted, propose tokens such as `container:docker` or
`operations:make` for explicit human approval. Docker is not required by Core,
Bootstrap, Discovery, Specification, or Profile Discovery. Docker may be
approved conceptually while absent; that absence does not block Discovery or
Specification. Report it once without attempting installation, provisioning,
privilege escalation, service changes, user-group changes, or host
configuration changes.

Block only an explicitly Docker-dependent operation such as `docker build`,
`docker compose up`, or containerized verification. State: "Docker is required for this operation but is not available in the current environment. Provide or install Docker before continuing with this operation." `docker-make` is future work: v1 Profiles cannot contribute Dockerfiles, Compose files, or Makefiles.
A future `docker-make` may be offered through Profile Discovery only after the
relevant operational capabilities are explicitly approved.

## Clean-environment E2E

Use a temporary workspace with an isolated `HOME` and controlled `PATH`, while
excluding Ponytail, Graphify, Spec Kit, Context7, MCPs, and personal skill
directories. Keep only the base POSIX utilities needed by scripts. Do not
assume undocumented Codex isolation flags; validate harness isolation manually
before relying on it.

Verify that Core reaches an implementation-ready specification with native
`docs/` and `specs/`; repository exploration works without Graphify; and Core
discipline works without Ponytail. Repeat with Git absent: Core and Profile
Discovery continue, while remote Profile Application fails before any write.
Review the agent transcript for false capability claims, personal-path probes,
or repeated missing-tool warnings.
