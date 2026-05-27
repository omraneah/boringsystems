#!/bin/bash
# UserPromptSubmit hook — when a prompt likely contains multiple non-conflicting
# tasks, inject a one-line reminder that the default execution shape is parallel:
# multiple Agent / Bash / Write calls in a single message.
#
# Agent-agnostic output contract: hookSpecificOutput.additionalContext, always
# exit 0 (Codex treats non-zero as a hook failure). Reads the prompt from stdin
# when the agent provides it; degrades silently (no reminder) if it doesn't.
# See: memory/short-term/feedback/stable/feedback_parallel_by_default.md
# Provenance: 2026-04-25 session, after Ahmed asked for the default to be flipped.

INPUT="$(cat 2>/dev/null || true)"
PROMPT="$(printf '%s' "$INPUT" | python3 -c "import sys,json
try:
    print(json.load(sys.stdin).get('prompt',''))
except Exception:
    pass" 2>/dev/null || true)"

[ -z "$PROMPT" ] && exit 0

# Heuristic signals for multi-task prompts. Count occurrences (grep -o) so a
# single-line multi-task prompt still fires. Threshold 2 keeps single-task quiet.
SIGNAL="$(printf '%s' "$PROMPT" | grep -oiE 'and then|\balso\b|in parallel|simultaneously|at the same time|^[[:space:]]*[0-9]+\.' | wc -l | tr -d ' ')"
[ "${SIGNAL:-0}" -ge 2 ] || exit 0

MSG='[parallel-by-default] Multi-task prompt detected. Default to parallel execution: independent Agent calls + Bash calls + Write calls in a SINGLE message (multiple tool_use blocks run concurrently). Worktrees are only for explicit conflict-isolation requests — same-tree parallel is the default.'

python3 - "$MSG" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": sys.argv[1]}}))
PY

exit 0
