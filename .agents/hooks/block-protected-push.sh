#!/bin/bash
# PreToolUse (Bash) hook — block protected-branch Git operations.
#
# The block contract differs by agent, so we detect which one is running:
#   Claude Code  → exit 2 + reason on stderr. Blocks RELIABLY even when the Bash
#                  tool is in permissions.allow. (A hookSpecificOutput
#                  permissionDecision is IGNORED when the tool is pre-allowed —
#                  anthropics/claude-code#4669, #18312 — so we must use exit 2.)
#   Codex/other  → hookSpecificOutput.permissionDecision="deny" + exit 0. Codex
#                  treats a non-zero exit as a hook FAILURE, not a block.
# Detection: Claude Code sets CLAUDE_PROJECT_DIR in the hook env; Codex does not.
# Stateless — no other agent-specific state.

INPUT="$(cat 2>/dev/null || true)"
COMMAND="$(printf '%s' "$INPUT" | python3 -c "import sys,json
try:
    print(json.load(sys.stdin).get('tool_input',{}).get('command',''))
except Exception:
    pass" 2>/dev/null || true)"

PROTECTED="main|master|development|dev|production"

# Strip quoted spans ("…" and '…') before matching, so a protected push merely
# MENTIONED inside a quoted argument (e.g. a `git commit -m` message that talks
# about `git push origin main`) does not false-positive. Real executed pushes —
# including chained forms `cd x && git push …`, `true; git push …` — sit outside
# quotes and are still caught.
SCAN="$(printf '%s' "$COMMAND" | python3 -c "import sys,re
s=sys.stdin.read()
print(re.sub(r'\"[^\"]*\"|'+chr(39)+r'[^'+chr(39)+r']*'+chr(39), ' ', s))" 2>/dev/null || printf '%s' "$COMMAND")"

deny() {
  if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
    printf '%s\n' "$1" >&2
    exit 2
  fi
  python3 - "$1" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": sys.argv[1]}}))
PY
  exit 0
}

# Match `git push` after any command boundary (whole command, quotes stripped),
# so chained forms (`cd x && git push origin main`, `true; git push …`) are
# caught, not just commands that start with `git push`.
has_push() { printf '%s' "$SCAN" | grep -qE '(^|[^[:alnum:]_])git[[:space:]]+push\b'; }

if has_push && printf '%s' "$SCAN" | grep -qE "origin[[:space:]]+($PROTECTED)\b"; then
  deny "Direct push to a protected branch is forbidden. Create a feature branch and open a PR instead."
fi

if has_push && printf '%s' "$SCAN" | grep -qE '(-f|--force|--force-with-lease)' && printf '%s' "$SCAN" | grep -qE "\b($PROTECTED)\b"; then
  deny "Force-pushing to a protected branch is forbidden."
fi

if printf '%s' "$SCAN" | grep -qE '(^|[^[:alnum:]_])git[[:space:]]+branch[[:space:]]+-[dD]\b' && printf '%s' "$SCAN" | grep -qE "\b($PROTECTED)\b"; then
  deny "Deleting protected branches locally is forbidden. Protected: main, master, development, dev, production."
fi

if has_push && printf '%s' "$SCAN" | grep -qE "(--delete|:)[[:space:]]*($PROTECTED)\b"; then
  deny "Deleting protected branches on the remote is forbidden."
fi

exit 0
