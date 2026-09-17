# Profile Catalog Contract v1

A Profile Catalog is local Core metadata used to discover available Profiles
without copying their payloads into a workspace.

## Layout

```text
profiles/catalog/<profile>.yaml
```

Each entry is an availability record, not a Profile. The payload remains
remote and must satisfy [Profile Contract v1](profile-contract-v1.md) after it
is fetched.

## Entry

```yaml
schema_version: 1
name: example-profile
version: 1.0.0
description: One concise description.

capabilities:
  - capability:example

matches:
  - capability:example

source:
  provider: github
  repository: owner/repository
  path: profiles/example-profile
  ref: <full immutable commit SHA>
```

All fields are required. `provider` is `github` in v1. `repository` is an
`owner/repository` identifier; `path` is a relative repository path without
`..`; and `ref` is a full immutable commit SHA.

`matches` uses the same exact subset rule as Profile Contract v1. An entry is
available when it exists locally and compatible when all its `matches` tokens
occur in Approved capabilities.

## Fetch and parity

After explicit human selection, `scripts/apply-profile` fetches the source to
a temporary location, validates Profile Contract v1, and requires exact parity
for `name`, `version`, `description`, `capabilities`, and `matches`. No
Profile receives a trusted bypass.

The catalog is authoritative for availability, discovery, source location,
and immutable ref. The fetched `profile.yaml` is authoritative for lifecycle,
dependencies, conflicts, contributions, and reapplication behavior.

## Publishing an official Profile

Avoid self-reference. First commit the definitive payload (Commit A). In a
later commit (Commit B), add or update the catalog entry to pin Commit A's
SHA. Do not use a branch, resolve `HEAD` during bootstrap, or point an entry
at its own commit.

Catalogs are snapshots copied with Core. v1 has no automatic catalog updates,
multiple catalogs, remote search, registry, or Profile upgrades.

## Access

GitHub access uses existing Git credentials only. Public sources need no
Mocca-managed authentication. A private source works only when the environment
already has authorized Git access; otherwise fetch fails before workspace
writes. Mocca does not store or request credentials.

`omaryesith/mocca-stack` is currently private. Its official Profile entries
therefore work only for authorized users. Before general public distribution,
official payloads must move to a publicly accessible source or this repository
must become public.
