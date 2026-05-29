#!/bin/bash
# UserPromptSubmit hook — emit a brevity reminder every turn, and a
# parallel-execution reminder when the prompt signals multiple independent tasks.
#
# Both reminders land in hookSpecificOutput.additionalContext (Claude + Codex).
# Always exit 0 — Codex treats non-zero as a hook FAILURE.
# Tools: pure bash + jq + grep + sed. No Python.
# See: docs/agent-ops/collaboration.md § Tone and output
#      docs/agent-ops/workspace-workflow.md § Parallel

# --- Brevity reminder (every turn) ---
BREVITY='[brevity] Executive register. Shortest form that carries the point. Outcomes and open questions only — no preamble, no trailing summary, no narrative. If Ahmed says "too long" → cut by half, no explanation.'

# --- Parallel reminder (multi-task prompts only) ---
INPUT="$(cat 2>/dev/null || true)"
PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // ""' 2>/dev/null || true)"

PARALLEL_MSG=''
if [ -n "$PROMPT" ]; then
  # Heuristic signals for multi-task prompts. Threshold 2 keeps single-task quiet.
  SIGNAL="$(printf '%s' "$PROMPT" | grep -oiE 'and then|\balso\b|in parallel|simultaneously|at the same time|^[[:space:]]*[0-9]+\.' | wc -l | tr -d ' ')"
  if [ "${SIGNAL:-0}" -ge 2 ]; then
    PARALLEL_MSG=' [parallel-by-default] Multi-task prompt detected. Default to parallel execution: independent Agent calls + Bash calls + Write calls in a SINGLE message (multiple tool_use blocks run concurrently). Worktrees are only for explicit conflict-isolation requests — same-tree parallel is the default.'
  fi
fi

MSG="${BREVITY}${PARALLEL_MSG}"
ESCAPED="$(printf '%s' "$MSG" | sed 's/\\/\\\\/g; s/"/\\"/g')"
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
