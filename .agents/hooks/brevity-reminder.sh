#!/bin/bash
# UserPromptSubmit hook — inject a brevity reminder at every turn.
# Executive register: outcomes and open questions only, no essays.
#
# Output contract: hookSpecificOutput.additionalContext (Claude + Codex both
# accept). Always exit 0 — Codex treats non-zero as a hook FAILURE.
# Tools: pure bash + sed. No Python.
# See: memory/short-term/feedback/stable/feedback_brevity.md

MSG='[brevity] Executive register. Shortest form that carries the point. Outcomes and open questions only — no preamble, no trailing summary, no narrative. If Ahmed says "too long" → cut by half, no explanation.'
ESCAPED="$(printf '%s' "$MSG" | sed 's/\\/\\\\/g; s/"/\\"/g')"
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
