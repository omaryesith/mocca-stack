#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
repo="$work/repo"
cp -R "$root" "$repo"
chmod +x "$repo/scripts/bootstrap" "$repo/templates/core/scripts/apply-profile" "$repo/tests/fixtures/fake-git"
mkdir -p "$work/bin"
cp "$repo/tests/fixtures/fake-git" "$work/bin/git"
chmod +x "$work/bin/git"

grep -Fq 'Profile Catalog Contract v1' "$repo/docs/profile-catalog-contract-v1.md"
grep -Fq 'Commit A' "$repo/docs/profile-catalog-contract-v1.md"
grep -Fq 'scripts/apply-profile' "$repo/templates/core/docs/technology.md"
test -f "$repo/templates/core/profiles/catalog/README.md"

pin=03a8860ca4c5f0c9570356b103ea01c6e05e011c
catalog="$repo/templates/core/profiles/catalog/python-django.yaml"
test -f "$catalog"
grep -Fqx "  ref: $pin" "$catalog"
test "${#pin}" -eq 40
git -C "$root" cat-file -e "$pin^{commit}"
git -C "$root" cat-file -e "$pin:profiles/python-django/profile.yaml"

profile_metadata() {
  awk '
    /^name:|^version:|^description:/ { print; section = ""; next }
    /^capabilities:|^matches:/ { section = $1; sub(/:.*/, "", section); next }
    /^  - / && (section == "capabilities" || section == "matches") { print section ": " $0; next }
    /^[^ ]/ { section = "" }
  '
}

profile_metadata <"$catalog" >"$work/catalog-metadata"
git -C "$root" show "$pin:profiles/python-django/profile.yaml" | profile_metadata >"$work/payload-metadata"
cmp -s "$work/catalog-metadata" "$work/payload-metadata"

catalog_matches() {
  tokens=$1
  matches=$(awk '
    /^matches:/ { section = 1; next }
    /^[^ ]/ { section = 0 }
    section && /^  - / { sub(/^  - /, ""); print }
  ' "$catalog")
  for token in $matches; do
    printf '%s\n' "$tokens" | tr ' ' '\n' | grep -Fqx "$token" || return 1
  done
}

catalog_matches 'language:python framework:django database:sqlite'

"$repo/scripts/bootstrap" "$work/core" >/dev/null
test -x "$work/core/scripts/apply-profile"
test -d "$work/core/profiles/catalog"
test -f "$work/core/profiles/catalog/python-django.yaml"
test ! -e "$work/core/profiles/python-django"
test ! -e "$work/core/environment"
test ! -e "$work/core/pyproject.toml"
grep -Fqx '**Applied profiles:** none' "$work/core/MOCCA.md"

if "$work/core/scripts/apply-profile" --profiles base >"$work/gated.out" 2>"$work/gated.err"; then
  echo "expected phase gate failure" >&2
  exit 1
fi
grep -Fq 'IMPLEMENTATION_READY' "$work/gated.err"
test ! -e "$work/core/base.toml"

if "$repo/scripts/bootstrap" "$work/staging-failure" --profiles base >"$work/staging.out" 2>"$work/staging.err"; then
  echo "expected staging Profile failure" >&2
  exit 1
fi
grep -Fq 'Profile not available in local catalog: base' "$work/staging.err"
test ! -e "$work/staging-failure"

sed -i 's/\*\*Current phase:\*\* `DISCOVERY`/**Current phase:** `IMPLEMENTATION_READY`/' "$work/core/MOCCA.md"
ref=0123456789012345678901234567890123456789
mkdir -p "$work/core/profiles/catalog"
cp "$repo/tests/fixtures/profiles/base/profile.yaml" "$work/remote-profile.yaml"
cp -R "$repo/tests/fixtures/profiles/base" "$work/remote-base"

cat >"$work/core/profiles/catalog/base.yaml" <<EOF
schema_version: 1
name: base
version: 1.0.0
description: Test base Profile.

capabilities:
  - test:base

matches: []

source:
  provider: github
  repository: example/profiles
  path: profiles/base
  ref: $ref
EOF

MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE="$work/remote-base" PATH="$work/bin:$PATH" "$work/core/scripts/apply-profile" --profiles base >/dev/null
test -f "$work/core/base.toml"
grep -Fqx '**Applied profiles:** base' "$work/core/MOCCA.md"

if MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE="$work/remote-base" PATH="$work/bin:$PATH" "$work/core/scripts/apply-profile" --profiles base >"$work/reapply.out" 2>"$work/reapply.err"; then
  echo "expected reapply failure" >&2
  exit 1
fi
grep -Fq 'profile already applied: base' "$work/reapply.err"

"$repo/scripts/bootstrap" "$work/empty" >/dev/null
if "$repo/scripts/bootstrap" "$work/empty" --profiles base >"$work/unknown.out" 2>"$work/unknown.err"; then
  echo "expected unavailable Profile failure" >&2
  exit 1
fi
grep -Fq 'Profile application requires Engineering State IMPLEMENTATION_READY' "$work/unknown.err"
test ! -e "$work/empty/base.toml"

ready_workspace() {
  workspace=$1
  "$repo/scripts/bootstrap" "$workspace" >/dev/null
  sed -i 's/\*\*Current phase:\*\* `DISCOVERY`/**Current phase:** `IMPLEMENTATION_READY`/' "$workspace/MOCCA.md"
}

add_catalog() {
  workspace=$1 name=$2 fixture=$3
  capabilities=$(awk '
    /^capabilities:/ { found = 1; next }
    found && /^  - / { print; next }
    found { exit }
  ' "$fixture/profile.yaml")
  [ -n "$capabilities" ] || capabilities='  - test:placeholder'
  {
    printf '%s\n' 'schema_version: 1'
    awk '/^(name|version|description):/' "$fixture/profile.yaml"
    printf '%s\n' '' 'capabilities:' "$capabilities" '' 'matches: []' '' 'source:'
    printf '%s\n' '  provider: github' '  repository: example/profiles' '  path: profiles/base' "  ref: $ref"
  } >"$workspace/profiles/catalog/$name.yaml"
}

assert_unchanged() {
  workspace=$1
  grep -Fqx '**Applied profiles:** none' "$workspace/MOCCA.md"
  test -z "$(find "$workspace" -maxdepth 1 -name '*.toml' -print -quit)"
}

expect_failure() {
  workspace=$1 fixture=$2 expected=$3
  shift 3
  if MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE="$fixture" PATH="$work/bin:$PATH" "$workspace/scripts/apply-profile" "$@" >"$workspace/out" 2>"$workspace/err"; then
    echo "expected Profile failure: $*" >&2
    exit 1
  fi
  grep -Fq "$expected" "$workspace/err"
  assert_unchanged "$workspace"
}

fixture="$repo/tests/fixtures/profiles"

case_workspace="$work/invalid-manifest"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" invalid-manifest "$fixture/invalid-manifest"
expect_failure "$case_workspace" "$fixture/invalid-manifest" 'missing required field capabilities' --profiles invalid-manifest

case_workspace="$work/missing-dependency"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" needs-base "$fixture/needs-base"
expect_failure "$case_workspace" "$fixture/needs-base" 'profile needs-base requires base' --profiles needs-base

case_workspace="$work/wrong-dependency-order"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" needs-base "$fixture/needs-base"
add_catalog "$case_workspace" base "$fixture/base"
expect_failure "$case_workspace" "$fixture/needs-base" 'profile needs-base requires base before it' --profiles needs-base --profiles base

case_workspace="$work/conflict"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conflict-a "$fixture/conflict-a"
add_catalog "$case_workspace" conflict-b "$fixture/conflict-b"
expect_failure "$case_workspace" "$fixture/conflict-a" 'profile conflict: conflict-a conflicts with conflict-b' --profiles conflict-a --profiles conflict-b

case_workspace="$work/collision"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" collision-a "$fixture/collision-a"
add_catalog "$case_workspace" collision-b "$fixture/collision-b"
expect_failure "$case_workspace" "$fixture/collision-a" 'profile collision: collision-b and collision-a both contribute shared.toml' --profiles collision-a --profiles collision-b

case_workspace="$work/catalog-mismatch"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" base "$fixture/base"
sed -i 's/description: Test base Profile\./description: Catalog mismatch./' "$case_workspace/profiles/catalog/base.yaml"
expect_failure "$case_workspace" "$fixture/base" 'catalog/payload mismatch for base: description' --profiles base

case_workspace="$work/unsupported-environment"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" core-collision "$fixture/core-collision"
expect_failure "$case_workspace" "$fixture/core-collision" 'unsupported environment file: readme.txt' --profiles core-collision

case_workspace="$work/subdirectory"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" subdirectory "$fixture/subdirectory"
expect_failure "$case_workspace" "$fixture/subdirectory" 'environment/ must be flat' --profiles subdirectory

case_workspace="$work/resolved-lock"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" resolved-lock "$fixture/resolved-lock"
expect_failure "$case_workspace" "$fixture/resolved-lock" 'unsupported environment file: uv.lock' --profiles resolved-lock

case_workspace="$work/source-file"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" source-file "$fixture/source-file"
expect_failure "$case_workspace" "$fixture/source-file" 'unsupported environment file: main.py' --profiles source-file

chmod +x "$repo/tests/fixtures/profiles/executable/environment/tool.toml"
case_workspace="$work/executable"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" executable "$fixture/executable"
expect_failure "$case_workspace" "$fixture/executable" 'executable files are not supported' --profiles executable

ln -s tool.toml "$repo/tests/fixtures/profiles/symlink/environment/link.toml"
case_workspace="$work/symlink"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" symlink "$fixture/symlink"
expect_failure "$case_workspace" "$fixture/symlink" 'symbolic links are not supported' --profiles symlink
