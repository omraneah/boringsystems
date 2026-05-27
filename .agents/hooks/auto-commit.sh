#!/bin/bash
# Auto-commit and push at end of each task turn (Stop event).
# Agent-agnostic — works with Claude Code and Codex.
# Runs async — does not block the agent's response.

PROJ_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$PROJ_DIR" ] && exit 0
cd "$PROJ_DIR" || exit 0

git rev-parse --git-dir > /dev/null 2>&1 || exit 0

BRANCH=$(git branch --show-current 2>/dev/null)
[ -z "$BRANCH" ] && exit 0

# Never auto-commit on protected branches
if echo "$BRANCH" | grep -qE "^(main|master|development|dev|production)$"; then
  exit 0
fi

# Skip if no uncommitted changes
if git diff --quiet && git diff --cached --quiet && [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

# Debounce: skip if last commit was less than DEBOUNCE_SECONDS ago.
# Default 1800s (30min) — prevents back-to-back checkpoints during multi-step work.
DEBOUNCE_SECONDS="${AUTO_CHECKPOINT_DEBOUNCE:-1800}"
last_commit_ts="$(git log -1 --format=%ct 2>/dev/null || echo 0)"
now_ts="$(date +%s)"
if [ "$((now_ts - last_commit_ts))" -lt "$DEBOUNCE_SECONDS" ]; then
  exit 0
fi

# Skip if many dirty files — signals active multi-step work, not idle drift.
DIRTY_COUNT=$(git status --porcelain | wc -l | tr -d ' ')
DIRTY_THRESHOLD="${AUTO_CHECKPOINT_DIRTY_THRESHOLD:-10}"
if [ "$DIRTY_COUNT" -gt "$DIRTY_THRESHOLD" ]; then
  exit 0
fi

# Stage tracked changes only — never auto-stage untracked files (a stray
# secret, debug dump, or scratch file must not be checkpointed unattended).
git add -u
git commit -m "chore: auto-checkpoint" 2>/dev/null || exit 0
# Detach the push so neither Claude (async) nor Codex (synchronous Stop) blocks
# the turn on the network round-trip. The local commit already captured the work.
( git push origin "$BRANCH" >/dev/null 2>&1 & )
