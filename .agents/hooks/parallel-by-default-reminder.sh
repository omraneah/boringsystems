#!/bin/bash
# UserPromptSubmit hook — when a prompt likely contains multiple non-conflicting
# tasks, inject a one-line reminder that the default execution shape is parallel:
# multiple Agent / Bash / Write calls in a single message.
#
# Output contract: hookSpecificOutput.additionalContext, always exit 0 (Codex
# treats non-zero as a hook failure). Reads the prompt from stdin via jq when
# the agent provides it; degrades silently (no reminder) if it doesn't.
# Tools: pure bash + jq + grep + sed. No Python.
# See: memory/short-term/feedback/stable/feedback_parallel_by_default.md

INPUT="$(cat 2>/dev/null || true)"
PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // ""' 2>/dev/null || true)"
[ -z "$PROMPT" ] && exit 0

# Heuristic signals for multi-task prompts. Threshold 2 keeps single-task quiet.
SIGNAL="$(printf '%s' "$PROMPT" | grep -oiE 'and then|\balso\b|in parallel|simultaneously|at the same time|^[[:space:]]*[0-9]+\.' | wc -l | tr -d ' ')"
[ "${SIGNAL:-0}" -ge 2 ] || exit 0

MSG='[parallel-by-default] Multi-task prompt detected. Default to parallel execution: independent Agent calls + Bash calls + Write calls in a SINGLE message (multiple tool_use blocks run concurrently). Worktrees are only for explicit conflict-isolation requests — same-tree parallel is the default.'
ESCAPED="$(printf '%s' "$MSG" | sed 's/\\/\\\\/g; s/"/\\"/g')"
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
