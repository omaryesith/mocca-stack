#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

repo="$work/repo"
cp -R "$root" "$repo"
cp -R "$repo/tests/fixtures/profiles/." "$repo/profiles/"

assert_fails_without_destination() {
  destination=$1
  shift
  if "$repo/scripts/bootstrap" "$destination" "$@" >/dev/null 2>&1; then
    echo "expected bootstrap failure: $*" >&2
    exit 1
  fi
  test ! -e "$destination"
}

"$repo/scripts/bootstrap" "$work/core" >/dev/null
test -f "$work/core/MOCCA.md"
test ! -e "$work/core/pyproject.toml"

"$repo/scripts/bootstrap" "$work/with-profile" --profiles python-django >/dev/null
test -f "$work/with-profile/pyproject.toml"
test -f "$work/with-profile/uv.lock"
test ! -e "$work/with-profile/app"
test ! -e "$work/with-profile/manage.py"
test ! -e "$work/with-profile/config"

"$repo/scripts/bootstrap" "$work/existing" >/dev/null
"$repo/scripts/bootstrap" "$work/existing" --profiles python-django >/dev/null
test -f "$work/existing/pyproject.toml"
test ! -e "$work/existing/app"
if "$repo/scripts/bootstrap" "$work/existing" --profiles python-django >/dev/null 2>&1; then
  echo "expected reapplication failure" >&2
  exit 1
fi

assert_fails_without_destination "$work/missing" --profiles does-not-exist
assert_fails_without_destination "$work/invalid-manifest" --profiles invalid-manifest
assert_fails_without_destination "$work/repeated" --profiles python-django --profiles python-django
assert_fails_without_destination "$work/missing-dependency" --profiles needs-base
assert_fails_without_destination "$work/misordered" --profiles needs-base --profiles base
assert_fails_without_destination "$work/conflict" --profiles conflict-a --profiles conflict-b
assert_fails_without_destination "$work/collision" --profiles collision-a --profiles collision-b
assert_fails_without_destination "$work/unsupported-file" --profiles core-collision
assert_fails_without_destination "$work/subdirectory" --profiles subdirectory
assert_fails_without_destination "$work/source-file" --profiles source-file

chmod +x "$repo/profiles/executable/environment/tool.toml"
assert_fails_without_destination "$work/executable" --profiles executable

ln -s tool.toml "$repo/profiles/symlink/environment/link.toml"
assert_fails_without_destination "$work/symlink" --profiles symlink

mkdir "$work/not-mocca"
cp "$repo/README.md" "$work/not-mocca/file"
if "$repo/scripts/bootstrap" "$work/not-mocca" --profiles python-django >/dev/null 2>&1; then
  echo "expected non-Mocca destination failure" >&2
  exit 1
fi
test ! -e "$work/not-mocca/pyproject.toml"

"$repo/scripts/bootstrap" "$work/core-preflight" >/dev/null
if "$repo/scripts/bootstrap" "$work/core-preflight" --profiles core-collision >/dev/null 2>&1; then
  echo "expected existing workspace preflight failure" >&2
  exit 1
fi
test ! -e "$work/core-preflight/app"
