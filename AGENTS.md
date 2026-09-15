# Mocca agent map

Mocca itself is intentionally small. The bootstrap skill and its references
are the product brief and v0.1 scope. Keep implementation aligned with them.

- Use `./scripts/verify` before calling a change complete.
- Keep bootstrap behavior in `scripts/bootstrap`; generated-project policy is
  in `templates/core`.
- Ponytail and Graphify are integrations, not features to reimplement here.
- Add an ADR only for a consequential, lasting decision.
- Extend through `profiles/` or project-local skills before changing core.
  A change to `templates/core` or the bootstrap contract needs a documented
  reason it cannot live at an extension boundary.
