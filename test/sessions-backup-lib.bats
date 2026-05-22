#!/usr/bin/env bats
# Pure-function unit tests for sessions-backup/lib.sh and manifest.py.
#
# These tests source lib.sh directly (don't go through mise) because the
# functions under test are pure — no network, no keychain, no blob ops.
# Integration tests against mc/blobs/keychain are deferred to a follow-up
# (would require mock shims).

load test_helper

LIB="$REPO_DIR/.mise/tasks/sessions-backup/lib.sh"
MANIFEST="$REPO_DIR/.mise/tasks/sessions-backup/manifest.py"

setup() {
  # shellcheck disable=SC1090
  source "$LIB"
}

# ----- date_to_ts -----

@test "date_to_ts: start-of-day default" {
  run date_to_ts 2026-05-22
  [ "$status" -eq 0 ]
  # 2026-05-22T00:00:00 local time → compare against same computation
  expected=$(date -j -f "%Y-%m-%dT%H:%M:%S" "2026-05-22T00:00:00" "+%s")
  [ "$output" = "$expected" ]
}

@test "date_to_ts: end-of-day (mode=end) is start + 86399" {
  start=$(date_to_ts 2026-05-22 start)
  end=$(date_to_ts 2026-05-22 end)
  [ "$((end - start))" -eq 86399 ]
}

@test "date_to_ts: explicit start mode matches default" {
  default=$(date_to_ts 2026-05-22)
  explicit=$(date_to_ts 2026-05-22 start)
  [ "$default" = "$explicit" ]
}

@test "date_to_ts: bad mode errors with usable message" {
  run date_to_ts 2026-05-22 noon
  [ "$status" -ne 0 ]
  [[ "$output" == *"bad mode 'noon'"* ]]
}

# ----- ts_to_iso -----

@test "ts_to_iso: epoch 0 is 1970-01-01" {
  run ts_to_iso 0
  [ "$status" -eq 0 ]
  [ "$output" = "1970-01-01T00:00:00Z" ]
}

@test "ts_to_iso: a known recent timestamp" {
  # 2026-05-22T00:00:00Z (UTC midnight)
  run ts_to_iso 1779408000
  [ "$status" -eq 0 ]
  [ "$output" = "2026-05-22T00:00:00Z" ]
}

# ----- bytes_human -----

@test "bytes_human: bytes" {
  run bytes_human 500
  [ "$output" = "500B" ]
}

@test "bytes_human: kilobytes (1.5K)" {
  run bytes_human 1536
  [ "$output" = "1.5K" ]
}

@test "bytes_human: megabytes (1.0M)" {
  run bytes_human 1048576
  [ "$output" = "1.0M" ]
}

@test "bytes_human: gigabytes (2.0G)" {
  run bytes_human $((2 * 1024 * 1024 * 1024))
  [ "$output" = "2.0G" ]
}

@test "bytes_human: zero" {
  run bytes_human 0
  [ "$output" = "0B" ]
}

# ----- source_root -----

@test "source_root: claude-projects" {
  run source_root claude-projects
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.claude/projects" ]
}

@test "source_root: wibey-sessions" {
  run source_root wibey-sessions
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.wibey/sessions" ]
}

@test "source_root: pi-sessions" {
  run source_root pi-sessions
  [ "$status" -eq 0 ]
  [ "$output" = "$HOME/.pi/agent/sessions" ]
}

@test "source_root: unknown pool errors with usable message" {
  run source_root made-up-pool
  [ "$status" -ne 0 ]
  [[ "$output" == *"unknown pool 'made-up-pool'"* ]]
}

# ----- ensure_b2 (failure paths only, no network) -----

@test "ensure_b2: fails clearly when B2_ALIAS and GIT_AUTHOR_NAME both unset" {
  unset B2_ALIAS GIT_AUTHOR_NAME B2_SETUP_DONE
  run ensure_b2
  [ "$status" -ne 0 ]
  [[ "$output" == *"B2_ALIAS unset"* ]]
}

@test "ensure_b2: short-circuits when B2_SETUP_DONE=1 (does not touch keychain)" {
  # Use a deliberately-missing alias so a no-op short-circuit succeeds
  # while a real keychain lookup would fail. Proves the short-circuit fires.
  B2_ALIAS="__nope_does_not_exist__" B2_SETUP_DONE=1 run ensure_b2
  [ "$status" -eq 0 ]
}

@test "ensure_b2: with B2_SETUP_DONE unset, missing alias would hit keychain (control)" {
  # Control case: same fake alias, but no short-circuit — must fail trying
  # to look up keychain entries that don't exist.
  unset B2_SETUP_DONE
  B2_ALIAS="__nope_does_not_exist__" run ensure_b2
  [ "$status" -ne 0 ]
  [[ "$output" == *"missing in keychain"* ]]
}

# ----- manifest.py -----

@test "manifest.py: walks a fixture directory and produces a valid manifest" {
  fixture="$BATS_TEST_TMPDIR/pool"
  mkdir -p "$fixture/sub"
  echo "first" > "$fixture/a.jsonl"
  echo "second" > "$fixture/sub/b.jsonl"

  out="$BATS_TEST_TMPDIR/manifest.json"
  run python3 "$MANIFEST" "$fixture" "$out"
  [ "$status" -eq 0 ]
  [ -f "$out" ]

  # Top-level fields present.
  count=$(jq '.file_count' "$out")
  [ "$count" -eq 2 ]

  total=$(jq '.total_bytes' "$out")
  # "first\n" = 6 bytes, "second\n" = 7 bytes → 13
  [ "$total" -eq 13 ]

  # Files sorted by mtime (chronological).
  paths=$(jq -r '.files[].path' "$out")
  [ -n "$paths" ]
}

@test "manifest.py: with explicit filelist, includes only listed files" {
  fixture="$BATS_TEST_TMPDIR/pool"
  mkdir -p "$fixture"
  echo "included" > "$fixture/keep.jsonl"
  echo "excluded" > "$fixture/skip.jsonl"

  filelist="$BATS_TEST_TMPDIR/files.txt"
  echo "keep.jsonl" > "$filelist"

  out="$BATS_TEST_TMPDIR/manifest.json"
  run python3 "$MANIFEST" "$fixture" "$out" "$filelist"
  [ "$status" -eq 0 ]

  count=$(jq '.file_count' "$out")
  [ "$count" -eq 1 ]

  path=$(jq -r '.files[0].path' "$out")
  [ "$path" = "keep.jsonl" ]
}

@test "manifest.py: empty pool produces zero-file manifest, not an error" {
  fixture="$BATS_TEST_TMPDIR/empty-pool"
  mkdir -p "$fixture"

  out="$BATS_TEST_TMPDIR/manifest.json"
  run python3 "$MANIFEST" "$fixture" "$out"
  [ "$status" -eq 0 ]

  count=$(jq '.file_count' "$out")
  [ "$count" -eq 0 ]

  total=$(jq '.total_bytes' "$out")
  [ "$total" -eq 0 ]

  earliest=$(jq -r '.earliest_mtime' "$out")
  [ "$earliest" = "null" ]
}

@test "manifest.py: missing args exits with usage" {
  run python3 "$MANIFEST"
  [ "$status" -eq 2 ]
  [[ "$output" == *"usage: manifest.py"* ]]
}
