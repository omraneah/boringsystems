#!/bin/bash
# SessionStart hook — pulls latest on main or development when opening a session.
# Keeps sessions from diverging silently on the base branch.
# Agent-agnostic — works with Claude Code and Codex.

PROJ_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$PROJ_DIR" ] && exit 0
cd "$PROJ_DIR" || exit 0

git rev-parse --git-dir > /dev/null 2>&1 || exit 0

CURRENT=$(git branch --show-current 2>/dev/null)

# Determine canonical base branch
if git show-ref --quiet refs/heads/main; then
  BASE="main"
elif git show-ref --quiet refs/heads/development; then
  BASE="development"
else
  exit 0
fi

# Only auto-pull if already on the base branch
if [ "$CURRENT" = "$BASE" ]; then
  git fetch origin "$BASE" --quiet 2>/dev/null && git pull origin "$BASE" --ff-only --quiet 2>/dev/null || true
fi

exit 0
