# python-django Profile

The reference Profile for Profile Contract v1. It provides Django dependency
configuration through `uv`, `pyproject.toml`, Ruff, and a Pytest baseline. It
is not a product starter and contributes no application source.

Apply it after an approved Python + Django technology decision, or select it
explicitly at bootstrap when that decision already exists. Its environment is
additive and never replaces Mocca Core paths.

## Verification

After `uv sync`, run:

```sh
uv run ruff check .
uv run pytest
```

These commands are documented evidence for this Profile. Mocca does not run
them automatically from `scripts/verify`. During `IMPLEMENTATION`, the agent
creates `app/` when appropriate, Django settings, apps, tests, routes, models,
and other product structure from the approved architecture and specification.

The consuming workspace generates `uv.lock` later at its root with `uv lock`
or `uv sync`, when the workflow and required authorization permit it.
`uv.lock` belongs to the workspace, never to `app/` or this Profile.
