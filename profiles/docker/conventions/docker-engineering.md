# Docker Engineering Conventions

These conventions govern work where `containerization:docker` is approved and
the `docker` Profile is applied. They define engineering practice, not product
implementation. Material deviations MUST be justified in the relevant
specification, architecture record, or ADR.

## 1. Docker-first development

When Docker is approved, development SHOULD run primarily through Docker. The
host SHOULD need only Docker or a compatible runtime, Docker Compose, source
control, and an editor or IDE. Application runtimes, framework dependencies,
databases, caches, queues, and similar services SHOULD run in the containerized
environment unless a documented engineering reason requires otherwise.

## 2. Host-editable source

The project working directory MUST remain authoritative on the host and SHOULD
be shared with development containers through bind mounts when appropriate.
Developers SHOULD be able to edit on the host while running application
commands, tests, linters, migrations, and stack-specific tooling in containers.

## 3. Service responsibilities

Independent runtime responsibilities SHOULD normally use separate containers:
application, database, cache, broker or queue, worker, scheduler, development
mail service, or supporting infrastructure. A Dockerfile defines image build;
Compose defines multi-service composition and interaction when it is needed.

## 4. Approved technology leads

This Profile MUST NOT select a base image, operating system, runtime,
framework, package manager, application command, ports, persistence mechanism,
or service topology. Those choices derive from approved requirements,
technology decisions, architecture, ADRs, and specifications. Docker adapts to
the project; the project does not adapt to a generic Docker template.

## 5. Development and production

Development convenience MUST NOT silently define the production runtime. Build
stages, layers, and configuration MAY be shared where appropriate, but their
development and production purposes MUST remain explicit.

## 6. Disposable containers

Application containers SHOULD be safe to destroy and recreate. Persistent
state MUST NOT depend on a container writable layer; use an approved volume,
bind mount, external storage, or external service as appropriate.

## 7. Runtime configuration and secrets

Environment-specific configuration SHOULD be supplied at runtime. Secrets MUST
NOT be embedded in images, Dockerfiles, Compose files, or versioned files with
real credentials. Secret management remains an approved security and deployment
decision.

## 8. Explicit readiness

Startup order MUST NOT be treated as readiness. Use appropriate health checks,
retries, or application-level connection handling when a dependency needs a
readiness guarantee. Arbitrary sleep-based coordination SHOULD be avoided.

## 9. Reproducible builds

Builds SHOULD use explicit base-image versions, project dependency locking,
useful cache structure, minimal build context, and avoid environment-dependent
behavior where appropriate. Projects remain responsible for their own
dependency lockfiles.

## 10. Minimal runtime images

Runtime images SHOULD exclude unnecessary tools, files, caches, credentials,
and build dependencies. Multi-stage builds MAY be used when they materially
improve separation or reduce runtime contents. Image size MUST NOT take
priority over maintainability, security, or reproducibility.

## 11. Least privilege

Application processes SHOULD run as non-root where practical; root requires a
concrete technical reason.

## 12. Host permissions

Bind-mounted development directories MUST NOT leave the host developer unable
to edit generated files. UID and GID handling SHOULD fit the host environment
and MUST NOT assume fixed values without an explicit environment guarantee.

## 13. Infrastructure is not product architecture

Docker MUST NOT introduce services, distributed boundaries, or infrastructure
complexity merely because containers make them easy. Service boundaries should
represent useful operational responsibilities.

## 14. Privileged access

Privileged containers, Docker-in-Docker, and host Docker socket mounts MUST
NOT be defaults. A project that genuinely needs one requires an explicit
engineering decision and security analysis.

## 15. Standard operation

The project SHOULD remain understandable and operable through standard Docker
and Docker Compose tooling. Future convenience wrappers MAY help, but MUST NOT
be an undocumented requirement for basic operation.

## 16. Verification in the intended environment

When Docker defines the approved development environment, relevant tests,
linters, checks, and verification SHOULD be executable there without hidden
host application dependencies. `./scripts/verify` remains the authoritative
entry point and MAY delegate into Docker when the approved implementation
requires it.

## 17. Profile application is inert

Applying this Profile MUST NOT install or configure Docker, start containers,
build images, or create Dockerfile, Compose, `.dockerignore`, or other product
artifacts. Those artifacts are created only during `IMPLEMENTATION` from the
approved project direction.
