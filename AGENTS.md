# pre-commit-just: instructions for AI agents

A pre-commit / prek hook repo: `format-justfile` runs `just --fmt` on `justfile`, `.justfile`, `Justfile` and `*.just`
files. The hook is `.pre-commit-hooks.yaml` (entry `pre-commit-just.sh`, language `script`). Pure bash, no package
registry: a release is a SemVer git tag plus a GitHub release.

## Layout

- `pre-commit-just.sh`: the hook. Bash 3.2 compatible (macOS), `set -euo pipefail`, shellcheck `enable=all`, shfmt.
- `.pre-commit-hooks.yaml`: the hook definition. Keep `files:` identical to the local hook in `.pre-commit-config.yaml`.
- `tests/test.sh`: runs the script directly and through `prek try-repo` (spaces in paths, modules, broken files).
- The repo is small and personal: commit to `main` directly, no PRs.

## Commands

[just](https://just.systems) is the entry point (`just` lists recipes).

- `just q-check`: the full gate (every prek hook on all files, then `tests/test.sh`). It must pass before committing.
  Prek fixers rewrite files; run it again until it passes.
- `just q-fast`: hooks only. `just q-test`: the hook tests. `just q-secrets`: gitleaks over the whole history.
- `just dev-hooks`: install the git hook. `just rel-check [tag]`: the tag has a changelog section and a matching
  README `rev`.
- Never commit the version bump of the `pre-commit-update` hook unasked.

## Rules

- Every behaviour change of the hook comes with a case in `tests/test.sh`.
- Fix shellcheck findings, do not silence them; a `disable` needs a reason comment.
- Release: move `Unreleased` in `CHANGELOG.md` into a `## [X.Y.Z] - date` section, update the README `rev:`, land,
  wait for green CI, then `git tag -a vX.Y.Z -m vX.Y.Z` and push the tag. `.github/workflows/release.yml` creates the
  GitHub release from the changelog section. Never tag unasked.
- Actions are pinned to a full commit SHA with a `# vX.Y.Z` comment; workflows start with `permissions: {}`.

## Reasoning

Shared practices: <https://github.com/evocaslab/hq/tree/main/practices> (`quality-gate.md`, `just-task-runner.md`,
`releases-and-versions.md`, `supply-chain-security.md`, `testing.md`, `gitignore-and-ide.md`).
