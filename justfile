# pre-commit-just recipes. Run `just` for the list. Prefixes: q- quality, dev- setup, rel- release.

set shell := ["bash", "-euo", "pipefail", "-c"]

[private]
default:
    @just --list

# Full gate: every prek hook on all files, then the hook tests. Run again if fixers changed files.
[group('quality')]
q-check: q-fast q-test

# Prek hooks only (shellcheck, shfmt, markdownlint, zizmor, format-justfile on this repo's justfile).
[group('quality')]
q-fast:
    SKIP=pre-commit-update prek run --all-files

# Test the format-justfile hook, directly and through prek.
[group('quality')]
q-test:
    tests/test.sh

# Install the git hooks (once per clone).
[group('dev')]
dev-hooks:
    prek install

# Fail unless the tag (default: the latest one) has a section in CHANGELOG.md and points at a commit on main.
[group('release')]
rel-check tag=`git describe --tags --abbrev=0`:
    #!/usr/bin/env bash
    set -euo pipefail
    grep -q "^## \[{{ trim_start_match(tag, 'v') }}\]" CHANGELOG.md \
        || { echo >&2 "CHANGELOG.md has no section for {{ tag }}"; exit 1; }
    grep -q 'rev: "{{ tag }}"' README.md \
        || { echo >&2 "README.md example does not use rev {{ tag }}"; exit 1; }
    git merge-base --is-ancestor "{{ tag }}" origin/main \
        || { echo >&2 "{{ tag }} is not on origin/main"; exit 1; }
    echo "{{ tag }} is consistent"

# Scan the whole git history for leaked secrets (gitleaks).
[group('quality')]
q-secrets:
    prek run gitleaks-history --hook-stage manual --all-files
