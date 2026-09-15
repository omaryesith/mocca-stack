# python-django profile

This optional capability pack is deliberately plain: Django with SQLite, one
health endpoint, Ruff, pytest, Bandit, and pip-audit. It is not a project
starter and bootstrap never applies it.

Apply it only after the project's technology selection is recorded in an ADR.
Its application workflow is intentionally deferred in v0.1; the pack lives in
`template/` so it is available without making Django a core dependency.

## Extension contract

- **Responsibility:** Django implementation and its deterministic checks.
- **Prerequisite:** an approved technology-selection ADR naming Django.
- **Contribution:** the files in `template/`, including Django verification
  scripts.
- **Verification:** Ruff, pytest, Bandit, and pip-audit after the pack is
  applied.

This pack must not require changes to `templates/core` or
`scripts/bootstrap`.

```sh
./scripts/check
./scripts/test
./scripts/security
./scripts/verify
```
