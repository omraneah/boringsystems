#!/bin/bash
# SessionStart hook — pulls latest on main or development when opening a session.
# Keeps submodule sessions from diverging silently.

PROJ_DIR="${CLAUDE_PROJECT_DIR}"
[ -z "$PROJ_DIR" ] && exit 0
cd "$PROJ_DIR" || exit 0

# Export workspace root to all session Bash tool calls via CLAUDE_ENV_FILE
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo "export CLAUDE_PROJECT_DIR=\"$CLAUDE_PROJECT_DIR\"" >> "$CLAUDE_ENV_FILE"
fi

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

# Surface any type-check failures logged by the previous Stop hook.
# The post-edit-typecheck.sh hook writes /tmp/claude-typecheck-<repo>.summary
# only when the last build failed. If it exists, echo it so Claude sees it
# in the SessionStart context.
REPO_NAME=$(basename "$PROJ_DIR")
SUMMARY="/tmp/claude-typecheck-${REPO_NAME}.summary"
if [ -f "$SUMMARY" ]; then
  echo "── type-check issues from last session ──"
  cat "$SUMMARY"
  echo "────────────────────────────────────────"
fi
