#!/bin/bash
# PreToolUse (Bash) hook — block protected-branch Git operations.
#
# Agent-agnostic output contract: a block is expressed via
# hookSpecificOutput.permissionDecision="deny" on stdout, ALWAYS exit 0.
# Both Claude Code and Codex honor this; both treat a non-zero exit as a hook
# FAILURE rather than a block, so we never exit non-zero.
# Stateless — no agent-specific env vars required.

INPUT="$(cat 2>/dev/null || true)"
COMMAND="$(printf '%s' "$INPUT" | python3 -c "import sys,json
try:
    print(json.load(sys.stdin).get('tool_input',{}).get('command',''))
except Exception:
    pass" 2>/dev/null || true)"

PROTECTED="main|master|development|dev|production"
FIRST_LINE="$(printf '%s' "$COMMAND" | head -1)"

deny() {
  python3 - "$1" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": sys.argv[1]}}))
PY
  exit 0
}

# Direct push to a protected branch
if echo "$FIRST_LINE" | grep -qE "^\s*git push" && echo "$FIRST_LINE" | grep -qE "origin\s+($PROTECTED)\b"; then
  deny "Direct push to a protected branch is forbidden. Create a feature branch and open a PR instead."
fi

# Force-push touching a protected branch
if echo "$FIRST_LINE" | grep -qE "^\s*git push\b" && echo "$FIRST_LINE" | grep -qE "(-f|--force|--force-with-lease)" && echo "$FIRST_LINE" | grep -qE "\b($PROTECTED)\b"; then
  deny "Force-pushing to a protected branch is forbidden."
fi

# Local delete of a protected branch
if echo "$FIRST_LINE" | grep -qE "^\s*git branch\s+-[dD]\b" && echo "$FIRST_LINE" | grep -qE "\b($PROTECTED)\b"; then
  deny "Deleting protected branches locally is forbidden. Protected: main, master, development, dev, production."
fi

# Remote delete of a protected branch
if echo "$FIRST_LINE" | grep -qE "^\s*git push\b" && echo "$FIRST_LINE" | grep -qE "((--delete|:)[[:space:]]*[^[:space:]]*)\b($PROTECTED)\b|\b($PROTECTED)\b.*(--delete|:))"; then
  deny "Deleting protected branches on the remote is forbidden."
fi

exit 0
