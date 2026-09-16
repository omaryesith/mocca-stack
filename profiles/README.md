# Profiles

Profiles are local optional engineering-environment packs. They are selected
explicitly; Mocca never infers or applies one from technology text alone.

Profiles do not scaffold applications. Their `environment/` contributions are
flat, allowlisted tooling configuration; product source is created later from
the approved specification and architecture.

Read the normative [Profile Contract v1](../docs/profile-contract-v1.md)
before creating or applying a Profile. `python-django` is the reference
Profile. `docker-make` remains a future design, not an available Profile.
