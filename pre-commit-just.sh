#!/usr/bin/env bash
# Format Justfiles with `just --fmt` (pre-commit and prek hook, entry of `format-justfile`).
#
# Usage: pre-commit-just.sh <file>...
#
# For each file: check the formatting, rewrite it when it differs, and fail only when
# `just` cannot parse or write the file (the error is shown). The hook runner then
# fails the commit because the files changed. Needs `just` on PATH; works with bash 3.2.

set -o errexit
set -o pipefail
set -o nounset

if ! command -v just >/dev/null 2>&1; then
  # Install `just` in the CI job too, see https://just.systems/man/en/packages.html.
  echo >&2 "Error: 'just' binary not found; the format-justfile hook cannot run."
  exit 1
fi

# `--unstable` is needed by `just` older than 1.38 and ignored by newer ones.
# https://just.systems/man/en/formatting-and-dumping-justfiles.html
status=0
for file in "$@"; do
  if just --fmt --unstable --check --justfile "${file}" >/dev/null 2>&1; then
    continue
  fi
  echo >&2 "Formatting required for ${file}. Applying fixes..."
  if just --fmt --unstable --justfile "${file}"; then
    echo >&2 "Successfully formatted ${file}."
  else
    echo >&2 "Error: Failed to format ${file}."
    status=1
  fi
done

exit "${status}"
