# Technology selection

List viable technical options only after discovery is sufficiently clear.
Evaluate each against requirements and constraints, then record the selected
direction and rationale in an ADR.

## Approved capabilities

- none

When approving a technology direction, propose and approve its structured
capabilities as the same decision. Replace `none` with one literal token per
line, using the open `responsibility:value` form:

```md
- language:python
- framework:django
- database:sqlite
```

Profile matching is exact and deterministic: a Profile is compatible when all
of its `matches` tokens are present in Approved capabilities. Extra approved
capabilities do not invalidate a compatible Profile. Do not use fuzzy matching,
framework-specific inference, or a closed taxonomy.

## Required Profile Discovery

After technology or a relevant capability is approved, and before the next
lifecycle transition, resolve Profile Discovery:

1. Review Applied Profiles in `MOCCA.md`.
2. Read Approved capabilities.
3. Inspect available local Catalog entries in `profiles/catalog/`.
4. For each Profile, verify that every `matches` token is present literally in
   Approved capabilities.
5. Present compatible candidates to the human; do not apply any Profile
   automatically.
6. Record one outcome before continuing:
   - no compatible local Catalog entry exists;
   - one or more Profiles were selected and then applied through
     `./scripts/apply-profile --profiles ...` at `IMPLEMENTATION_READY`; or
   - compatible Profiles were rejected and the alternative stack
     materialization was clarified.

With one candidate, state briefly which engineering environment it provides
and request human selection. With several, present alternatives and allow one,
several, or none to be selected. If none are compatible, record that brief
result. If all are rejected, record the alternative materialization in this
document, an ADR, or the relevant specification.

Catalog discovery and selection do not download or apply a Profile. A selected
Profile is fetched and applied only through `scripts/apply-profile`; do not
apply one automatically.

Check `MOCCA.md` before asking about a technology already represented by an
Applied Profile. Its declared capabilities are an explicitly selected
engineering environment and do not need a second approval. That status does
not decide product architecture, persistence, authentication, deployment,
security, or domain behavior.
