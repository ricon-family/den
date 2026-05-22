# shellcheck shell=bash
# Shared helpers for sessions-backup tasks. Sourced; tasks must `set -euo pipefail`.
#
# - ensure_b2:    load B2 credentials from keychain and register the mc alias
# - date_to_ts:   YYYY-MM-DD → unix ts (BSD date; start/end semantics)
# - ts_to_iso:    unix ts → ISO-8601 UTC
# - bytes_human:  byte count → 1.2M / 350K
# - source_root:  pool name → canonical local path
# - section:      bold section header for human output

# Load B2 credentials from `secrets/<alias>/b2-*` keychain entries and register
# the mc alias via `blobs setup`. Idempotent.
#
# Originally lived in baby-joel/home/.mise/tasks/sessions-backup/lib.sh
# (session 123, 2026-05-18); see notes/sessions-backup.md for the port history.
ensure_b2() {
  # Default to the active agent identity; require explicit if neither is set.
  : "${B2_ALIAS:=${GIT_AUTHOR_NAME:-}}"
  if [ -z "$B2_ALIAS" ]; then
    echo "error: B2_ALIAS unset and no GIT_AUTHOR_NAME (try: eval \$(shimmer as <agent>))" >&2
    return 1
  fi
  export B2_ALIAS

  if [ "${B2_SETUP_DONE:-}" = "1" ]; then
    return 0
  fi

  local endpoint key_id key bucket
  if ! endpoint=$(_keychain_lookup "secrets/$B2_ALIAS/b2-endpoint"); then
    echo "error: B2_ENDPOINT missing in keychain ('secrets/$B2_ALIAS/b2-endpoint')" >&2
    return 1
  fi
  if ! key_id=$(_keychain_lookup "secrets/$B2_ALIAS/b2-key-id"); then
    echo "error: B2_KEY_ID missing in keychain ('secrets/$B2_ALIAS/b2-key-id')" >&2
    return 1
  fi
  if ! key=$(_keychain_lookup "secrets/$B2_ALIAS/b2-application-key"); then
    echo "error: B2_APPLICATION_KEY missing in keychain ('secrets/$B2_ALIAS/b2-application-key')" >&2
    return 1
  fi

  # Re-derive B2_BUCKET unconditionally so a stale parent-shell B2_BUCKET from
  # a previous alias can't leak across alias switches.
  if ! bucket=$(_keychain_lookup "secrets/$B2_ALIAS/b2-bucket"); then
    echo "error: B2_BUCKET missing in keychain ('secrets/$B2_ALIAS/b2-bucket')" >&2
    return 1
  fi
  export B2_BUCKET="$bucket"

  export B2_ENDPOINT="$endpoint" B2_KEY_ID="$key_id" B2_APPLICATION_KEY="$key"

  blobs setup >/dev/null
  export B2_SETUP_DONE=1
}

# Look up a base64-encoded keychain secret and decode it. Exits non-zero with
# no output if the entry is missing.
_keychain_lookup() {
  local svc="$1" raw
  if ! raw=$(security find-generic-password -s "$svc" -w 2>/dev/null); then
    return 1
  fi
  printf '%s' "$raw" | base64 -d
}

# Convert YYYY-MM-DD to a unix timestamp. Second arg:
#   start (default) → 00:00:00 of that day
#   end             → 23:59:59 of that day
date_to_ts() {
  local d="$1" mode="${2:-start}" time
  case "$mode" in
    start) time="00:00:00" ;;
    end)   time="23:59:59" ;;
    *) echo "date_to_ts: bad mode '$mode'" >&2; return 1 ;;
  esac
  # BSD date (macOS); see [[bash-macos-compat]] for the cross-platform note.
  date -j -f "%Y-%m-%dT%H:%M:%S" "${d}T${time}" "+%s"
}

ts_to_iso() {
  date -u -r "$1" "+%Y-%m-%dT%H:%M:%SZ"
}

# Human-readable byte count. Awk for portability (no GNU numfmt on macOS).
bytes_human() {
  awk -v b="$1" 'BEGIN {
    suf="BKMGT"; i=1; s=b+0
    while (s >= 1024 && i < length(suf)) { s/=1024; i++ }
    if (i == 1) printf "%dB\n", s
    else        printf "%.1f%s\n", s, substr(suf, i, 1)
  }'
}

# Resolve a pool name to its canonical local source path.
source_root() {
  case "$1" in
    claude-projects)  printf '%s\n' "$HOME/.claude/projects" ;;
    wibey-sessions)   printf '%s\n' "$HOME/.wibey/sessions" ;;
    pi-sessions)      printf '%s\n' "$HOME/.pi/agent/sessions" ;;
    *) echo "source_root: unknown pool '$1'" >&2; return 1 ;;
  esac
}

# Bold section header for human-readable phase boundaries.
section() {
  printf '\n\033[1m== %s ==\033[0m\n' "$1"
}
