#!/usr/bin/env bash
set -Eeuo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
SCRIPT=$ROOT/authwatch.sh
FIXTURE=$ROOT/fixtures/auth.log
TMP_DIR=$(mktemp -d)
trap 'rm -rf -- "$TMP_DIR"' EXIT

assert_contains() {
  local needle=$1 file=$2
  if ! grep -Fq -- "$needle" "$file"; then
    printf 'FAIL: expected output to contain: %s\n' "$needle" >&2
    cat "$file" >&2
    exit 1
  fi
}

bash "$SCRIPT" -t 3 "$FIXTURE" > "$TMP_DIR/output"
assert_contains 'Failed SSH passwords: 4' "$TMP_DIR/output"
assert_contains 'Invalid-user attempts: 1' "$TMP_DIR/output"
assert_contains 'Accepted SSH logins: 1' "$TMP_DIR/output"
assert_contains 'ALERT: 203.0.113.44 had 3 failed password attempts' "$TMP_DIR/output"

mkdir "$TMP_DIR/path with spaces"
cp -- "$FIXTURE" "$TMP_DIR/path with spaces/auth.log"
bash "$SCRIPT" "$TMP_DIR/path with spaces/auth.log" > "$TMP_DIR/spaces"
assert_contains 'Failed SSH passwords: 4' "$TMP_DIR/spaces"

if bash "$SCRIPT" -t 0 "$FIXTURE" >/dev/null 2>&1; then
  printf 'FAIL: zero threshold should be rejected\n' >&2
  exit 1
fi
if bash "$SCRIPT" "$TMP_DIR/missing.log" >/dev/null 2>&1; then
  printf 'FAIL: missing file should be rejected\n' >&2
  exit 1
fi

printf 'All AuthWatch checks passed.\n'
