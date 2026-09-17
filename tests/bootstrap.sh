#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
target=$(mktemp -d)
trap 'rm -rf "$target"' EXIT

"$root/scripts/bootstrap" "$target/project" >/dev/null

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
