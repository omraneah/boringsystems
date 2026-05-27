#!/bin/bash
# Post-edit type-check hook — runs astro check / tsc --noEmit after a Stop event,
# on feature branches only, async. Logs errors so the next SessionStart can surface them.
# Agent-agnostic — works with Claude Code and Codex.

set -u

PROJ_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$PROJ_DIR" ] && exit 0
cd "$PROJ_DIR" || exit 0

git rev-parse --git-dir > /dev/null 2>&1 || exit 0

BRANCH=$(git branch --show-current 2>/dev/null)
[ -z "$BRANCH" ] && exit 0

# Only run on feature branches
if echo "$BRANCH" | grep -qE "^(main|master|development|dev|production)$"; then
  exit 0
fi

REPO_NAME=$(basename "$PROJ_DIR")
LOG="/tmp/typecheck-${REPO_NAME}.log"
SUMMARY="/tmp/typecheck-${REPO_NAME}.summary"

# Detect the right check command
CHECK_CMD=""
if [ -f "package.json" ]; then
  if grep -q '"astro"' package.json 2>/dev/null; then
    CHECK_CMD="npx --no astro check"
  elif grep -q '"typescript"' package.json 2>/dev/null && [ -f "tsconfig.json" ]; then
    CHECK_CMD="npx --no tsc --noEmit"
  fi
fi

[ -z "$CHECK_CMD" ] && exit 0

$CHECK_CMD > "$LOG" 2>&1
STATUS=$?

if [ $STATUS -eq 0 ]; then
  rm -f "$SUMMARY"
  exit 0
fi

{
  echo "Type-check failed on $BRANCH at $(date '+%Y-%m-%d %H:%M')"
  echo "Command: $CHECK_CMD"
  echo "Full log: $LOG"
  echo
  tail -n 30 "$LOG"
} > "$SUMMARY"

exit 0
