#!/bin/bash
# Auto-commit and push at end of each task turn (Stop event).
# Runs async — does not block Claude's response.

PROJ_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJ_DIR" || exit 0

# Must be a git repo
git rev-parse --git-dir > /dev/null 2>&1 || exit 0

BRANCH=$(git branch --show-current 2>/dev/null)
[ -z "$BRANCH" ] && exit 0

# Never auto-commit on protected branches
if echo "$BRANCH" | grep -qE "^(main|master|development|dev|production)$"; then
  exit 0
fi

# Check for any uncommitted changes (staged or unstaged or untracked)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

# Debounce: skip if the last commit on this branch was less than DEBOUNCE_SECONDS ago.
# Prevents back-to-back auto-checkpoints when Claude is iterating fast through several
# Stop events within a short window. A real (non-auto-checkpoint) commit also resets
# the timer, so the next auto-checkpoint waits at least DEBOUNCE_SECONDS past it.
DEBOUNCE_SECONDS="${AUTO_CHECKPOINT_DEBOUNCE:-600}"
last_commit_ts="$(git log -1 --format=%ct 2>/dev/null || echo 0)"
now_ts="$(date +%s)"
if [ "$((now_ts - last_commit_ts))" -lt "$DEBOUNCE_SECONDS" ]; then
  exit 0
fi

# Commit and push
git add -A
git commit -m "chore: auto-checkpoint

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>" 2>/dev/null || exit 0
git push origin "$BRANCH" 2>/dev/null || true
