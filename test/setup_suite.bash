# Runs once per bats invocation (bats >= 1.5). Sets up the repo env so tests
# work whether invoked via `mise run test` or `bats test/foo.bats` directly.
#
# See fold's [[bats-tool-testing]] for the canonical pattern.

setup_suite() {
  # Derive REPO_DIR from this test file's own location. Do NOT use
  # $MISE_CONFIG_ROOT here — agent sessions inherit a stale MCR from the
  # launcher task, pointing at the wrong repo.
  local repo
  repo="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export REPO_DIR="$repo"

  # Load this repo's mise env so tests get the right tool versions regardless
  # of entry point. Requires `mise trust` for this repo.
  eval "$(cd "$REPO_DIR" && mise env)"
}
