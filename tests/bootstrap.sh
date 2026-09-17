#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
target=$(mktemp -d)
trap 'rm -rf "$target"' EXIT

"$root/scripts/bootstrap" "$target/project" >/dev/null

grep -Fq 'active harness exposes it' "$target/project/AGENTS.md"
grep -Fq 'Yorkie Principles, specs, checkpoints, test-first, and verification' "$target/project/docs/integrations.md"
grep -Fq 'explore the repository normally when unavailable' "$target/project/docs/integrations.md"
grep -Fq 'use native `docs/` and `specs/` when unavailable' "$target/project/docs/integrations.md"
grep -Fq 'Required only by remote Profile Application; Profile Discovery is local' "$target/project/docs/integrations.md"
grep -Fq 'Docker is not required by Core,' "$target/project/docs/integrations.md"
grep -Fq 'Bootstrap, Discovery, Specification, or Profile Discovery' "$target/project/docs/integrations.md"
grep -Fq 'does not block Discovery or Specification' "$target/project/docs/integrations.md"
grep -Fq 'without attempting installation, provisioning, privilege escalation' "$target/project/docs/integrations.md"
grep -Fq 'Docker is required for this operation but is not available in the current environment' "$target/project/docs/integrations.md"
grep -Fq 'install, provision, enable, or modify the host automatically' "$target/project/AGENTS.md"
grep -Fq 'Clean-environment E2E' "$target/project/docs/integrations.md"
grep -Fq 'Otherwise explore the relevant repository files normally' "$target/project/docs/workflow.md"
grep -Fq 'Otherwise apply the Yorkie Principles' "$target/project/docs/workflow.md"

if grep -Eq 'command -v (codex|ponytail|graphify|specify|docker)|\.codex|\.agents|\$HOME' "$root/scripts/bootstrap"; then
  echo "bootstrap must not probe global capabilities" >&2
  exit 1
fi

for path in AGENTS.md MOCCA.md .gitignore docs/constitution.md docs/discovery.md docs/technology.md docs/integrations.md docs/architecture/README.md docs/architecture/adr/README.md docs/autonomy.md docs/workflow.md specs/README.md scripts/verify scripts/apply-profile profiles/catalog; do
  test -f "$target/project/$path"
done

test -x "$target/project/scripts/verify"
test -x "$target/project/scripts/apply-profile"
test -f "$target/project/profiles/catalog/python-django.yaml"
test ! -e "$target/project/profiles/python-django"
test ! -e "$target/project/environment"
test ! -e "$target/project/pyproject.toml"
test ! -e "$target/project/manage.py"
test ! -e "$target/project/app"
test ! -e "$target/project/config"
"$target/project/scripts/verify"
