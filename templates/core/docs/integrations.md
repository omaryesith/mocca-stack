# Integrations

Mocca cares about responsibilities, not brands. The structured Chef's
Recommendations in `.mocca/chef-recommendations.yaml` define initial
recommendations; this document explains their purpose, fallback, and readiness
policy. Codex is the expected harness, documented but never detected by
Bootstrap.

## Environment Readiness

Before substantive `DISCOVERY`, evaluate the initial recommendations in the
structured catalog. Each result is exactly `available`, `missing`, or
`unknown`: a deterministic positive check is `available`; a deterministic
negative check is `missing`; absent deterministic introspection is `unknown`.
Never turn `unknown` into `missing`.

`READY` has no relevant degradation. `DEGRADED` has only recommended
capabilities that are `missing` or `unknown`; explain their purpose, impact,
fallback, and guidance, then obtain explicit acknowledgement before Discovery.
After acknowledgement, use the fallback without repeated warnings for that
same degradation. `BLOCKED` applies only when the current operation requires a
capability that is `missing` or `unknown`; say whether it is unavailable or
cannot be verified, and stop only that operation.

Readiness probes are observational and side-effect free. Supported detection
strategies are `command`, `path_file`, `path_directory`,
`environment_variable`, `harness_skill`, and `harness_mcp`. A `command` check
uses `command -v` followed by its defined version/probe: no executable is
`missing`; a failing probe after discovery is `unknown`. Harness skills and
MCPs use only explicit inventories exposed by the active harness; absent
introspection is `unknown`.

Do not probe personal skill paths, scan `HOME`, inspect old sessions, install,
provision, enable, or modify the host, or claim an unavailable capability was
used. Bootstrap performs no capability scan. Host changes require an explicit
human-requested task separate from Mocca's normal workflow.

| Responsibility | Chef's Recommendation | Readiness and fallback |
| --- | --- | --- |
| Engineering discipline | Ponytail | Initial recommended capability. If unavailable, Core rules, Yorkie Principles, specs, checkpoints, test-first, and verification remain the fallback; extended engineering guidance is unavailable. |
| Codebase intelligence | Graphify | Initial recommended capability. If unavailable, explore the repository normally; semantic graph exploration is unavailable. |
| Current library documentation | Context7 | Initial recommended capability. If unavailable, use repository context, available documentation, or explicitly requested external sources. |
| Repository context | GitHub MCP | Initial recommended capability. If unavailable, use local repository context and Git where applicable. |
| Spec-driven workflow | GitHub Spec Kit | Contextual only when the process intends to use it; use native `docs/` and `specs/` when unavailable. |
| Operational environment | Docker | Contextual only when an approved Docker-dependent operation needs it; native project operations remain the fallback until then. |
| Remote Profile transport | Git | Required only by remote Profile Application; Profile Discovery is local. |
| Confidence and autonomy | Deterministic verification | Core rule; `./scripts/verify` is the stable interface. |

## Docker consideration

During technical or operational design, consider whether Docker has a concrete
benefit or an unresolved containerization decision: multiple services,
reproducible dependencies, environment parity, onboarding consistency, or
CI/deployment needs. Offer it only when one of those signals exists. Record
acceptance, rejection, deferral, or clear irrelevance with the technical
direction; do not ask again unless architecture materially changes.

If containerization is accepted, propose tokens such as `containerization:docker`
or `operations:make` for explicit human approval. Docker is not required by Core,
Bootstrap, Discovery, Specification, or Profile Discovery. Docker may be
approved conceptually while absent; that absence does not block Discovery or
Specification. Before a Docker-dependent operation, reevaluate Docker
mechanically. Do not attempt installation, provisioning, privilege escalation,
service changes, user-group changes, or host configuration changes.

Block only an explicitly Docker-dependent operation such as `docker build`,
`docker compose up`, or containerized verification. State: "Docker is required for this operation but is not available in the current environment. Provide or install Docker before continuing with this operation." If Docker readiness cannot be verified, say so instead of calling it unavailable. `docker-make` is future work: v1 Profiles cannot contribute Dockerfiles, Compose files, or Makefiles.
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
