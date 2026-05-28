#!/bin/bash
# PreToolUse (Bash) hook — block protected-branch Git operations.
#
# Output contract differs by agent, so we detect which one is running:
#   Claude Code  → exit 2 + reason on stderr. Blocks RELIABLY even when the Bash
#                  tool is in permissions.allow. (A hookSpecificOutput
#                  permissionDecision is IGNORED when the tool is pre-allowed —
#                  anthropics/claude-code#4669, #18312 — so we must use exit 2.)
#   Codex/other  → hookSpecificOutput.permissionDecision="deny" + exit 0. Codex
#                  treats a non-zero exit as a hook FAILURE, not a block.
# Detection: Claude Code sets CLAUDE_PROJECT_DIR in the hook env; Codex does not.
#
# Precision lives in the companion detector `_block-check.py`: quoted spans are
# stripped so quoted MENTIONS never block, and protected-name matches are
# anchored within the same statement as the push/branch -d (split on ; && || |
# newline). So `git checkout main && git branch -d feature` is allowed.

INPUT="$(cat 2>/dev/null || true)"
COMMAND="$(printf '%s' "$INPUT" | python3 -c "import sys,json
try:
    print(json.load(sys.stdin).get('tool_input',{}).get('command',''))
except Exception:
    pass" 2>/dev/null || true)"

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REASON="$(printf '%s' "$COMMAND" | python3 "$HOOK_DIR/_block-check.py" 2>/dev/null)"

if [ -n "$REASON" ]; then
  if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
    printf '%s\n' "$REASON" >&2
    exit 2
  fi
  python3 - "$REASON" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": sys.argv[1]}}))
PY
  exit 0
fi

exit 0
