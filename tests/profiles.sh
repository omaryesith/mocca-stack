#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
repo="$work/repo"
cp -R "$root" "$repo"
chmod +x "$repo/scripts/bootstrap" "$repo/templates/core/scripts/apply-profile" "$repo/tests/fixtures/fake-git" "$repo/tests/fixtures/fake-cp" "$repo/tests/fixtures/fake-docker"
mkdir -p "$work/bin"
cp "$repo/tests/fixtures/fake-git" "$work/bin/git"
cp "$repo/tests/fixtures/fake-cp" "$work/bin/cp"
cp "$repo/tests/fixtures/fake-docker" "$work/bin/docker"
chmod +x "$work/bin/git"
chmod +x "$work/bin/cp"
chmod +x "$work/bin/docker"

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
  _catalog=$1 _tokens=$2
  _matches=$(awk '
    /^matches:/ { section = 1; next }
    /^[^ ]/ { section = 0 }
    section && /^  - / { sub(/^  - /, ""); print }
  ' "$_catalog")
  for _token in $_matches; do
    printf '%s\n' "$_tokens" | tr ' ' '\n' | grep -Fqx "$_token" || return 1
  done
}

catalog_matches "$catalog" 'language:python framework:django database:sqlite'

docker_pin=f239f26e2402b03886c85216c0c4225374e8de2f
docker_catalog="$repo/templates/core/profiles/catalog/docker.yaml"
test -f "$docker_catalog"
grep -Fqx "  ref: $docker_pin" "$docker_catalog"
test "${#docker_pin}" -eq 40
git -C "$root" cat-file -e "$docker_pin^{commit}"
git -C "$root" cat-file -e "$docker_pin:profiles/docker/profile.yaml"
profile_metadata <"$docker_catalog" >"$work/docker-catalog-metadata"
git -C "$root" show "$docker_pin:profiles/docker/profile.yaml" | profile_metadata >"$work/docker-payload-metadata"
cmp -s "$work/docker-catalog-metadata" "$work/docker-payload-metadata"
catalog_matches "$docker_catalog" 'containerization:docker'
if catalog_matches "$docker_catalog" 'containerization:podman'; then
  echo 'docker Catalog entry must not match another containerization capability' >&2
  exit 1
fi

profile_matches() {
  _profile=$1 _tokens=$2
  _matches=$(awk '
    /^matches:/ { section = 1; next }
    /^[^ ]/ { section = 0 }
    section && /^  - / { sub(/^  - /, ""); print }
  ' "$_profile")
  for _token in $_matches; do
    printf '%s\n' "$_tokens" | tr ' ' '\n' | grep -Fqx "$_token" || return 1
  done
}

profile_matches "$repo/profiles/docker/profile.yaml" 'containerization:docker'
if profile_matches "$repo/profiles/docker/profile.yaml" 'containerization:podman'; then
  echo 'docker Profile must not match another containerization capability' >&2
  exit 1
fi

"$repo/scripts/bootstrap" "$work/core" >/dev/null
test -x "$work/core/scripts/apply-profile"
test -d "$work/core/profiles/catalog"
test -f "$work/core/profiles/catalog/python-django.yaml"
test -f "$work/core/profiles/catalog/docker.yaml"
test ! -e "$work/core/profiles/python-django"
test ! -e "$work/core/profiles/docker"
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
  _workspace=$1
  "$repo/scripts/bootstrap" "$_workspace" >/dev/null
  sed -i 's/\*\*Current phase:\*\* `DISCOVERY`/**Current phase:** `IMPLEMENTATION_READY`/' "$_workspace/MOCCA.md"
}

add_catalog() {
  _workspace=$1 _name=$2 _fixture_path=$3
  _capabilities=$(awk '
    /^capabilities:/ { found = 1; next }
    found && /^  - / { print; next }
    found { exit }
  ' "$_fixture_path/profile.yaml")
  _matches=$(awk '
    /^matches:/ { found = 1; next }
    found && /^  - / { print; next }
    found { exit }
  ' "$_fixture_path/profile.yaml")
  [ -n "$_capabilities" ] || _capabilities='  - test:placeholder'
  {
    printf '%s\n' 'schema_version: 1'
    awk '/^(name|version|description):/' "$_fixture_path/profile.yaml"
    printf '%s\n' '' 'capabilities:' "$_capabilities" ''
    if [ -n "$_matches" ]; then
      printf '%s\n' 'matches:' "$_matches"
    else
      printf '%s\n' 'matches: []'
    fi
    printf '%s\n' '' 'source:'
    printf '%s\n' '  provider: github' '  repository: example/profiles' "  path: profiles/$_name" "  ref: $ref"
  } >"$_workspace/profiles/catalog/$_name.yaml"
}

assert_unchanged() {
  _workspace=$1
  grep -Fqx '**Applied profiles:** none' "$_workspace/MOCCA.md"
  test -z "$(find "$_workspace" -maxdepth 1 -name '*.toml' -print -quit)"
  test ! -e "$_workspace/.mocca"
}

expect_failure() {
  _workspace=$1 _expected=$2
  shift 2
  if MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE_ROOT="$fixture_root" PATH="$work/bin:$PATH" "$_workspace/scripts/apply-profile" "$@" >"$_workspace/out" 2>"$_workspace/err"; then
    echo "expected Profile failure: $*" >&2
    exit 1
  fi
  grep -Fq "$_expected" "$_workspace/err"
  assert_unchanged "$_workspace"
}

fixture_root="$repo/tests/fixtures/profiles"

apply_fixture() {
  _workspace=$1
  shift
  MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE_ROOT="$fixture_root" PATH="$work/bin:$PATH" "$_workspace/scripts/apply-profile" "$@"
}

announce() {
  echo "==> profile: $1"
}

announce 'invalid manifest'
case_workspace="$work/invalid-manifest"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" invalid-manifest "$fixture_root/invalid-manifest"
expect_failure "$case_workspace" 'missing required field capabilities' --profiles invalid-manifest

announce 'missing contributions'
case_workspace="$work/missing-contributions"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" no-contributions "$fixture_root/no-contributions"
expect_failure "$case_workspace" 'contributions must include environment or conventions' --profiles no-contributions

announce 'conventions only'
case_workspace="$work/conventions-only"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conventions-only "$fixture_root/conventions-only"
apply_fixture "$case_workspace" --profiles conventions-only >/dev/null
test -f "$case_workspace/.mocca/profiles/conventions-only/conventions/engineering.md"
test ! -e "$case_workspace/conventions-only.toml"
grep -Fqx '**Applied profiles:** conventions-only' "$case_workspace/MOCCA.md"

announce 'environment and conventions'
case_workspace="$work/environment-and-conventions"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" environment-and-conventions "$fixture_root/environment-and-conventions"
apply_fixture "$case_workspace" --profiles environment-and-conventions >/dev/null
test -f "$case_workspace/environment-and-conventions.toml"
test -f "$case_workspace/.mocca/profiles/environment-and-conventions/conventions/engineering.md"
grep -Fqx '**Applied profiles:** environment-and-conventions' "$case_workspace/MOCCA.md"

announce 'python django environment only'
cp -R "$repo/profiles/python-django" "$fixture_root/python-django"
case_workspace="$work/python-django"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" python-django "$fixture_root/python-django"
apply_fixture "$case_workspace" --profiles python-django >/dev/null
test -f "$case_workspace/pyproject.toml"
test ! -e "$case_workspace/.mocca"
grep -Fqx '**Applied profiles:** python-django' "$case_workspace/MOCCA.md"

announce 'docker conventions only'
cp -R "$repo/profiles/docker" "$fixture_root/docker"
case_workspace="$work/docker"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" docker "$fixture_root/docker"
docker_called="$work/docker-called"
MOCCA_DOCKER_CALLED="$docker_called" MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE_ROOT="$fixture_root" PATH="$work/bin:$PATH" "$case_workspace/scripts/apply-profile" --profiles docker >/dev/null
test -f "$case_workspace/.mocca/profiles/docker/conventions/docker-engineering.md"
grep -Fqx '**Applied profiles:** docker' "$case_workspace/MOCCA.md"
test ! -e "$docker_called"
test ! -e "$case_workspace/Dockerfile"
test ! -e "$case_workspace/compose.yaml"
test ! -e "$case_workspace/compose.yml"
test ! -e "$case_workspace/.dockerignore"
test ! -e "$case_workspace/app"
test ! -e "$case_workspace/src"

announce 'empty conventions'
mkdir -p "$fixture_root/empty-conventions/conventions"
case_workspace="$work/empty-conventions"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" empty-conventions "$fixture_root/empty-conventions"
expect_failure "$case_workspace" 'conventions/ must contribute a file' --profiles empty-conventions

announce 'conventions subdirectory'
case_workspace="$work/conventions-subdirectory"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conventions-subdirectory "$fixture_root/conventions-subdirectory"
expect_failure "$case_workspace" 'conventions/ must be flat' --profiles conventions-subdirectory

announce 'conventions extension'
case_workspace="$work/conventions-extension"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conventions-extension "$fixture_root/conventions-extension"
expect_failure "$case_workspace" 'unsupported conventions file: engineering.txt' --profiles conventions-extension

announce 'conventions executable'
chmod +x "$fixture_root/conventions-executable/conventions/engineering.md"
case_workspace="$work/conventions-executable"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conventions-executable "$fixture_root/conventions-executable"
expect_failure "$case_workspace" 'executable files are not supported' --profiles conventions-executable

announce 'conventions symlink'
ln -s engineering.md "$fixture_root/conventions-symlink/conventions/link.md"
case_workspace="$work/conventions-symlink"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conventions-symlink "$fixture_root/conventions-symlink"
expect_failure "$case_workspace" 'symbolic links are not supported' --profiles conventions-symlink

announce 'conventions collision'
case_workspace="$work/conventions-collision"
ready_workspace "$case_workspace"
touch "$case_workspace/shared.toml"
add_catalog "$case_workspace" conventions-collision "$fixture_root/conventions-collision"
if MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE_ROOT="$fixture_root" PATH="$work/bin:$PATH" "$case_workspace/scripts/apply-profile" --profiles conventions-collision >"$case_workspace/out" 2>"$case_workspace/err"; then
  echo 'expected convention collision failure' >&2
  exit 1
fi
grep -Fq 'attempts to overwrite protected or existing path: shared.toml' "$case_workspace/err"
test -f "$case_workspace/shared.toml"
grep -Fqx '**Applied profiles:** none' "$case_workspace/MOCCA.md"
test ! -e "$case_workspace/.mocca"

announce 'conventions rollback'
case_workspace="$work/conventions-rollback"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conventions-rollback "$fixture_root/conventions-rollback"
if MOCCA_FAIL_COPY_BASENAME=rollback.md MOCCA_FAKE_GIT_REF="$ref" MOCCA_FAKE_PROFILE_ROOT="$fixture_root" PATH="$work/bin:$PATH" "$case_workspace/scripts/apply-profile" --profiles conventions-rollback >"$case_workspace/out" 2>"$case_workspace/err"; then
  echo 'expected convention rollback failure' >&2
  exit 1
fi
assert_unchanged "$case_workspace"

announce 'missing dependency'
case_workspace="$work/missing-dependency"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" needs-base "$fixture_root/needs-base"
expect_failure "$case_workspace" 'profile needs-base requires base' --profiles needs-base

announce 'wrong dependency order'
case_workspace="$work/wrong-dependency-order"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" needs-base "$fixture_root/needs-base"
add_catalog "$case_workspace" base "$fixture_root/base"
expect_failure "$case_workspace" 'profile needs-base requires base before it' --profiles needs-base --profiles base

announce 'conflict'
case_workspace="$work/conflict"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" conflict-a "$fixture_root/conflict-a"
add_catalog "$case_workspace" conflict-b "$fixture_root/conflict-b"
expect_failure "$case_workspace" 'profile conflict: conflict-a conflicts with conflict-b' --profiles conflict-a --profiles conflict-b

announce 'collision'
case_workspace="$work/collision"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" collision-a "$fixture_root/collision-a"
add_catalog "$case_workspace" collision-b "$fixture_root/collision-b"
expect_failure "$case_workspace" 'profile collision: collision-b and collision-a both contribute shared.toml' --profiles collision-a --profiles collision-b

announce 'catalog mismatch'
case_workspace="$work/catalog-mismatch"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" base "$fixture_root/base"
sed -i 's/description: Test base Profile\./description: Catalog mismatch./' "$case_workspace/profiles/catalog/base.yaml"
expect_failure "$case_workspace" 'catalog/payload mismatch for base: description' --profiles base

announce 'unsupported environment'
case_workspace="$work/unsupported-environment"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" core-collision "$fixture_root/core-collision"
expect_failure "$case_workspace" 'unsupported environment file: readme.txt' --profiles core-collision

announce 'subdirectory'
case_workspace="$work/subdirectory"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" subdirectory "$fixture_root/subdirectory"
expect_failure "$case_workspace" 'environment/ must be flat' --profiles subdirectory

announce 'resolved lock'
case_workspace="$work/resolved-lock"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" resolved-lock "$fixture_root/resolved-lock"
expect_failure "$case_workspace" 'unsupported environment file: uv.lock' --profiles resolved-lock

announce 'source file'
case_workspace="$work/source-file"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" source-file "$fixture_root/source-file"
expect_failure "$case_workspace" 'unsupported environment file: main.py' --profiles source-file

announce 'executable'
chmod +x "$repo/tests/fixtures/profiles/executable/environment/tool.toml"
case_workspace="$work/executable"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" executable "$fixture_root/executable"
expect_failure "$case_workspace" 'executable files are not supported' --profiles executable

announce 'symlink'
ln -s tool.toml "$repo/tests/fixtures/profiles/symlink/environment/link.toml"
case_workspace="$work/symlink"
ready_workspace "$case_workspace"
add_catalog "$case_workspace" symlink "$fixture_root/symlink"
expect_failure "$case_workspace" 'symbolic links are not supported' --profiles symlink

grep -Fqx '  environment: environment/' "$repo/profiles/python-django/profile.yaml"
if grep -Fq 'conventions:' "$repo/profiles/python-django/profile.yaml"; then
  echo 'python-django must remain environment-only' >&2
  exit 1
fi
