#!/bin/bash
# SessionStart hook — Claude Code-specific session wiring.
# Handles: CLAUDE_ENV_FILE export, setup.sh, pull-base-branch, typecheck surface.

PROJ_DIR="${CLAUDE_PROJECT_DIR}"
[ -z "$PROJ_DIR" ] && exit 0
cd "$PROJ_DIR" || exit 0

# Export workspace root to all session Bash tool calls
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo "export CLAUDE_PROJECT_DIR=\"$CLAUDE_PROJECT_DIR\"" >> "$CLAUDE_ENV_FILE"
fi

# Wire ~/.claude/ symlinks, git hooksPath, Marky. Idempotent.
SETUP_LOG="/tmp/claude-setup-$(basename "$PROJ_DIR").log"
bash "$PROJ_DIR/.claude/setup.sh" >"$SETUP_LOG" 2>&1 \
  || echo "WARN: setup.sh failed — check $SETUP_LOG"

# Pull base branch (shared logic)
bash "$PROJ_DIR/.agent-hooks/pull-base-branch.sh"

# Surface type-check failures from last session
REPO_NAME=$(basename "$PROJ_DIR")
SUMMARY="/tmp/typecheck-${REPO_NAME}.summary"
if [ -f "$SUMMARY" ]; then
  echo "── type-check issues from last session ──"
  cat "$SUMMARY"
  echo "────────────────────────────────────────"
fi
