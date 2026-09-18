# Profiles

Profiles are optional engineering-environment packs. Their payloads remain in
their source repositories; generated workspaces receive only local Catalog
metadata and fetch a payload after explicit selection.

Profiles do not scaffold applications. `environment/` contributions are flat,
allowlisted tooling configuration. `conventions/` contributions are flat
Markdown engineering rules materialized under `.mocca/profiles/`. Product
source is created later from the approved specification and architecture.

Read the normative [Profile Contract v1.1](../docs/profile-contract-v1.md) and
[Profile Catalog Contract v1](../docs/profile-catalog-contract-v1.md) before
creating or publishing a Profile. Official Profiles use two commits: commit
the payload first, then pin that payload commit in the Catalog. `python-django`
is the reference environment Profile. `docker` is a conventions-only payload
awaiting its Catalog Commit B; it contributes guidance only and will not
scaffold container artifacts.

The official source is public and can be fetched anonymously. Mocca never
implements or requests GitHub authentication. Private third-party sources
remain supported only where existing Git credentials authorize access.
