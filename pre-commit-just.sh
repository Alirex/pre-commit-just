#!/bin/bash

# [bash_init]-[BEGIN]
# Exit whenever it encounters an error, also known as a non–zero exit code.
set -o errexit
# Return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status,
#   or zero if all commands in the pipeline exit successfully.
set -o pipefail
# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error when performing parameter expansion.
set -o nounset
# [bash_init]-[END]

# [pre_check]-[BEGIN]
# Check if 'just' binary is available.
if ! command -v just >/dev/null 2>&1; then
  echo >&2 "Error: 'just' binary not found; pre-commit hook will not run."
  exit 1
fi
# [pre_check]-[END]

# [action]-[BEGIN]
# https://just.systems/man/en/formatting-and-dumping-justfiles.html

status=0

for file in "$@"; do
  if ! just --fmt --unstable --check --justfile "$file" >/dev/null 2>&1; then
    echo >&2 "Formatting required for ${file}. Applying fixes..."

    if just --fmt --unstable --justfile "$file" >/dev/null 2>&1; then
      echo >&2 "Successfully formatted ${file}."
    else
      echo >&2 "Error: Failed to format ${file}."
      status=1
    fi
  fi
done

exit $status
# [action]-[END]
