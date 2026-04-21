#!/bin/bash
# Post-edit type-check hook — runs astro check / tsc --noEmit after a Stop
# event, on feature branches only, async. Logs errors to a known location
# so the next session can surface them.
#
# Silent on success. On failure, writes to /tmp/claude-typecheck-<repo>.log
# and prepends a short notice the next SessionStart hook picks up.

set -u

PROJ_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJ_DIR" || exit 0

# Must be a git repo
git rev-parse --git-dir > /dev/null 2>&1 || exit 0

BRANCH=$(git branch --show-current 2>/dev/null)
[ -z "$BRANCH" ] && exit 0

# Only run on feature branches — protected branches are not the place to surface build drift
if echo "$BRANCH" | grep -qE "^(main|master|development|dev|production)$"; then
  exit 0
fi

REPO_NAME=$(basename "$PROJ_DIR")
LOG="/tmp/claude-typecheck-${REPO_NAME}.log"
SUMMARY="/tmp/claude-typecheck-${REPO_NAME}.summary"

# Detect the right check command for this project
CHECK_CMD=""
if [ -f "package.json" ]; then
  if grep -q '"astro"' package.json 2>/dev/null; then
    CHECK_CMD="npx --no astro check"
  elif grep -q '"typescript"' package.json 2>/dev/null && [ -f "tsconfig.json" ]; then
    CHECK_CMD="npx --no tsc --noEmit"
  fi
fi

[ -z "$CHECK_CMD" ] && exit 0

# Run the check, keep stderr + stdout
$CHECK_CMD > "$LOG" 2>&1
STATUS=$?

if [ $STATUS -eq 0 ]; then
  # Clean — erase the summary file if it existed, so SessionStart stays quiet
  rm -f "$SUMMARY"
  exit 0
fi

# Errors — write a short summary the SessionStart hook will surface
{
  echo "Type-check failed on $BRANCH at $(date '+%Y-%m-%d %H:%M')"
  echo "Command: $CHECK_CMD"
  echo "Full log: $LOG"
  echo
  # Truncate tail so the notice stays short
  tail -n 30 "$LOG"
} > "$SUMMARY"

exit 0
