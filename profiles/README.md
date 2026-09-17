# Profiles

Profiles are optional engineering-environment packs. Their payloads remain in
their source repositories; generated workspaces receive only local Catalog
metadata and fetch a payload after explicit selection.

Profiles do not scaffold applications. Their `environment/` contributions are
flat, allowlisted tooling configuration; product source is created later from
the approved specification and architecture.

Read the normative [Profile Contract v1](../docs/profile-contract-v1.md) and
[Profile Catalog Contract v1](../docs/profile-catalog-contract-v1.md) before
creating or publishing a Profile. Official Profiles use two commits: commit
the payload first, then pin that payload commit in the Catalog. `python-django`
is the reference Profile. `docker-make` remains a future design.

The current official source is private. It can be applied only where existing
Git credentials authorize access; Mocca never implements or requests GitHub
authentication. Public distribution requires a publicly accessible official
source or a public Mocca repository.
