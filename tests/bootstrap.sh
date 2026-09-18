#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
target=$(mktemp -d)
trap 'rm -rf "$target"' EXIT

"$root/scripts/bootstrap" "$target/project" >/dev/null

grep -Fqx '**Bark mode:** not set' "$target/project/MOCCA.md"
grep -Fqx '**Initial gate:** pending' "$target/project/MOCCA.md"
grep -Fqx '**Acknowledged degradations:** none' "$target/project/MOCCA.md"
grep -Fqx 'schema_version: 1' "$target/project/.mocca/chef-recommendations.yaml"
for recommendation in ponytail graphify context7 github-mcp; do
  grep -Fqx "  - id: $recommendation" "$target/project/.mocca/chef-recommendations.yaml"
done
grep -Fq 'Before substantive `DISCOVERY`, resolve Environment Readiness' "$target/project/AGENTS.md"
grep -Fq 'preserve `unknown`' "$target/project/AGENTS.md"
grep -Fq 'acknowledgement before `DISCOVERY`' "$target/project/docs/workflow.md"
grep -Fq 'never relabel it `missing`' "$target/project/docs/workflow.md"
grep -Fq 'Bark is presentation only' "$target/project/docs/workflow.md"
grep -Fq 'Bootstrap performs no capability scan' "$target/project/docs/integrations.md"
grep -Fq 'containerization:docker' "$target/project/docs/integrations.md"
if grep -Eq 'find[[:space:]]+~|~/\.codex|~/\.agents' "$target/project/AGENTS.md" "$target/project/docs/integrations.md" "$target/project/docs/workflow.md"; then
  echo "Environment Readiness must not scan personal paths" >&2
  exit 1
fi

grep -Fq 'active harness exposes it' "$target/project/AGENTS.md"
grep -Fq 'Yorkie Principles, specs, checkpoints, test-first, and verification' "$target/project/docs/integrations.md"
grep -Fq '| Codebase intelligence | Graphify |' "$target/project/docs/integrations.md"
grep -Fq 'explore the repository normally' "$target/project/docs/integrations.md"
grep -Fq 'semantic graph exploration' "$target/project/docs/integrations.md"
grep -Fq 'use native `docs/` and `specs/` when unavailable' "$target/project/docs/integrations.md"
grep -Fq 'Required only by remote Profile Application; Profile Discovery is local' "$target/project/docs/integrations.md"
grep -Fq 'Applied Profile' "$target/project/AGENTS.md"
grep -Fq '.mocca/profiles/<profile>/conventions/' "$target/project/AGENTS.md"
grep -Fq 'Docker is not required by Core,' "$target/project/docs/integrations.md"
grep -Fq 'Bootstrap, Discovery, Specification, or Profile Discovery' "$target/project/docs/integrations.md"
grep -Fq 'approved conceptually while absent; that absence does not block Discovery or' "$target/project/docs/integrations.md"
grep -Fq 'Before a Docker-dependent operation, reevaluate Docker' "$target/project/docs/integrations.md"
grep -Fq 'Do not attempt installation, provisioning' "$target/project/docs/integrations.md"
grep -Fq 'privilege escalation' "$target/project/docs/integrations.md"
grep -Fq 'service changes, user-group changes, or host configuration changes' "$target/project/docs/integrations.md"
grep -Fq 'Docker is required for this operation but is not available in the current environment' "$target/project/docs/integrations.md"
grep -Fq 'or install,' "$target/project/AGENTS.md"
grep -Fq 'provision, enable, or modify the' "$target/project/AGENTS.md"
grep -Fq 'host automatically' "$target/project/AGENTS.md"
grep -Fq 'Clean-environment E2E' "$target/project/docs/integrations.md"
grep -Fq 'Otherwise explore the relevant repository files normally' "$target/project/docs/workflow.md"
grep -Fq 'harness exposes it and it materially improves the work. Otherwise apply the' "$target/project/docs/workflow.md"
grep -Fq 'Yorkie Principles, specifications, checkpoints, test-first practice, and' "$target/project/docs/workflow.md"
grep -Fq 'exit status 0' "$target/project/docs/workflow.md"
grep -Fq 'known non-zero result keeps the affected checkpoint open or reopens' "$target/project/docs/workflow.md"
grep -Fq 'Never leave Pulse `done`' "$target/project/docs/workflow.md"
grep -Fq 'Do not declare verification success, checkpoint closure, spec completion, or' "$target/project/AGENTS.md"
grep -Fq 'exit status 0 and no known failures remain' "$target/project/AGENTS.md"

if grep -Eq 'command -v (codex|ponytail|graphify|specify|docker)|\.codex|\.agents|\$HOME' "$root/scripts/bootstrap"; then
  echo "bootstrap must not probe global capabilities" >&2
  exit 1
fi

for path in AGENTS.md MOCCA.md .gitignore .mocca/chef-recommendations.yaml docs/constitution.md docs/discovery.md docs/technology.md docs/integrations.md docs/architecture/README.md docs/architecture/adr/README.md docs/autonomy.md docs/workflow.md specs/README.md scripts/verify scripts/apply-profile; do
  test -f "$target/project/$path"
done

test -d "$target/project/profiles/catalog" || {
  echo "missing Profile Catalog directory" >&2
  exit 1
}

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
