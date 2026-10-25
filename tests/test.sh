#!/usr/bin/env bash
# Tests for the format-justfile hook: the script directly, then through prek.
#
# Usage: tests/test.sh      (needs `just`, `git` and `prek`; `just q-test` runs it)

set -o errexit
set -o pipefail
set -o nounset

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hook="${root}/pre-commit-just.sh"
work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT
failures=0

fail() {
  echo >&2 "FAIL: $*"
  failures=$((failures + 1))
}

# Write a justfile that is not formatted (two-space indent, extra spaces).
unformatted() {
  mkdir -p "$(dirname "$1")"
  printf 'foo:\n  echo   hi\n' >"$1"
}

# Is the file formatted according to `just`?
formatted() {
  just --fmt --unstable --check --justfile "$1" >/dev/null 2>&1
}

# 1. Several files, including a space in the path and a module.
mkdir "${work}/direct"
unformatted "${work}/direct/dir with space/justfile"
unformatted "${work}/direct/mod.just"
unformatted "${work}/direct/.justfile"
unformatted "${work}/direct/Justfile"
printf 'x:\n    @echo ok\n' >"${work}/direct/ok.just"
cp "${work}/direct/ok.just" "${work}/direct/ok.copy"
if ! "${hook}" "${work}/direct/dir with space/justfile" "${work}/direct/mod.just" \
  "${work}/direct/.justfile" "${work}/direct/Justfile" "${work}/direct/ok.just" 2>/dev/null; then
  fail "formatting valid files must succeed"
fi
for f in "dir with space/justfile" mod.just .justfile Justfile; do
  formatted "${work}/direct/${f}" || fail "${f} was not formatted"
done
cmp -s "${work}/direct/ok.just" "${work}/direct/ok.copy" || fail "a formatted file changed"

# 2. A second run changes nothing.
cp "${work}/direct/mod.just" "${work}/direct/mod.copy"
"${hook}" "${work}/direct/mod.just" 2>/dev/null
cmp -s "${work}/direct/mod.just" "${work}/direct/mod.copy" || fail "the hook is not idempotent"

# 3. A file that does not parse fails and is left alone.
printf 'foo bar baz:::\n' >"${work}/direct/bad.just"
cp "${work}/direct/bad.just" "${work}/direct/bad.copy"
if "${hook}" "${work}/direct/bad.just" 2>/dev/null; then
  fail "a syntax error must fail the hook"
fi
cmp -s "${work}/direct/bad.just" "${work}/direct/bad.copy" || fail "a broken file was modified"

# 4. No `just` on PATH fails with a message.
if message="$(PATH=/nonexistent /bin/bash "${hook}" "${work}/direct/ok.just" 2>&1)"; then
  fail "a missing just must fail"
fi
case "${message}" in
  *"'just' binary not found"*) ;;
  *) fail "missing-just message not shown: ${message}" ;;
esac

# 5. Through prek: the hook picks the right files and rewrites them.
repo="${work}/repo"
mkdir "${repo}"
git -C "${repo}" init --quiet
git -C "${repo}" config user.email test@example.com
git -C "${repo}" config user.name test
unformatted "${repo}/justfile"
unformatted "${repo}/sub dir/tools.just"
printf 'robust:\n  echo   hi\n' >"${repo}/robust"
printf 'adjust:\n  echo   hi\n' >"${repo}/adjust.txt"
git -C "${repo}" add .
# The repo under test is the working tree (prek try-repo also takes uncommitted changes).
(cd "${repo}" && prek try-repo "${root}" format-justfile --all-files >/dev/null 2>&1) &&
  fail "prek must report the files the hook rewrote"
formatted "${repo}/justfile" || fail "prek: justfile was not formatted"
formatted "${repo}/sub dir/tools.just" || fail "prek: sub dir/tools.just was not formatted"
grep -q 'echo   hi' "${repo}/robust" || fail "prek: a file named robust was touched"
grep -q 'echo   hi' "${repo}/adjust.txt" || fail "prek: adjust.txt was touched"

if [[ ${failures} -gt 0 ]]; then
  echo >&2 "${failures} check(s) failed"
  exit 1
fi
echo "All hook tests passed."
