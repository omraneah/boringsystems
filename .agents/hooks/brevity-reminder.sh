#!/bin/bash
# UserPromptSubmit hook — injects a brevity reminder at every turn.
# Executive register: outcomes and open questions only, no essays.
#
# Agent-agnostic output contract: emits the hookSpecificOutput.additionalContext
# JSON shape that BOTH Claude Code and Codex accept. Always exits 0 — Codex treats
# a non-zero exit as a hook FAILURE, not a signal.
# See: memory/short-term/feedback/stable/feedback_brevity.md

MSG='[brevity] Executive register. Shortest form that carries the point. Outcomes and open questions only — no preamble, no trailing summary, no narrative. If Ahmed says "too long" → cut by half, no explanation.'

python3 - "$MSG" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": sys.argv[1]}}))
PY

exit 0
