# Mocca agent map

Read `MOCCA.md` first; it is the operational index for developing Mocca.

- `README.md` is the public product narrative.
- `docs/discovery.md` defines current vision, scope, non-goals, and
  constraints.
- `docs/constitution.md` is normative; `docs/architecture/` holds the
  architecture overview and lasting decisions.
- `docs/autonomy.md` defines delegation boundaries; `docs/verification.md`
  defines the completion gate: run `./scripts/verify` before declaring work
  complete.
- `templates/core/` is the source of truth for generated workspaces, not for
  developing Mocca itself. `profiles/` holds optional extensions.
- Extend through `profiles/` or project-local skills before changing core. A
  change to `templates/core` or the bootstrap contract needs a documented
  reason it cannot live at an extension boundary.
