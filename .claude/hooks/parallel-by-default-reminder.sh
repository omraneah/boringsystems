#!/bin/bash
# UserPromptSubmit hook — when a prompt likely contains multiple non-conflicting
# tasks, inject a one-line reminder that the default execution shape is parallel:
# multiple Agent calls / Bash calls in a single message.
#
# See: memory/feedback_parallel_by_default.md
# Provenance: 2026-04-25 session, after Ahmed asked for the default to be flipped.

set -euo pipefail

INPUT="$(cat)"
PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // empty' 2>/dev/null || true)"

if [ -z "$PROMPT" ]; then
  exit 0
fi

# Heuristic signals for multi-task prompts. Count occurrences (not matching
# lines) so a single-line multi-task prompt still fires. Threshold of 2 keeps
# single-task prompts quiet so the reminder doesn't become noise.
SIGNAL=$(printf '%s' "$PROMPT" | grep -oiE 'and then|\balso\b|in parallel|paralyz|simultaneously|at the same time|^[[:space:]]*[0-9]+\.' | wc -l | tr -d ' ' || true)

if [ "${SIGNAL:-0}" -ge 2 ]; then
  cat <<'EOF'
[parallel-by-default] Multi-task prompt detected. Default to parallel execution: independent Agent calls + Bash calls + Write calls in a SINGLE message (multiple tool_use blocks run concurrently). Worktrees are only for explicit conflict-isolation requests — same-tree parallel is the default. See memory/feedback_parallel_by_default.md.
EOF
fi

exit 0
