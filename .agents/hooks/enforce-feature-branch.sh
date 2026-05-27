#!/bin/bash
# PreToolUse (Edit|Write|NotebookEdit) hook — block file edits on protected branches.
# Forces feature-branch discipline. Companion to block-protected-push.sh.
#
# Agent-agnostic output contract: a block is expressed via
# hookSpecificOutput.permissionDecision="deny" on stdout, ALWAYS exit 0.
# Both Claude Code and Codex honor this; a non-zero exit would be read as a hook
# FAILURE, not a block. Stateless — no agent-specific env vars required.

INPUT="$(cat 2>/dev/null || true)"
FILE_PATH="$(printf '%s' "$INPUT" | python3 -c "import sys,json
try:
    print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))
except Exception:
    pass" 2>/dev/null || true)"

[ -z "$FILE_PATH" ] && exit 0

# Canonical skills are always editable regardless of branch — quick skill
# iteration should never require a feature branch.
case "$FILE_PATH" in
  */.agents/skills/*) exit 0 ;;
esac

# Walk up to the nearest existing directory (the file may not exist yet).
DIR="$FILE_PATH"
while [ ! -d "$DIR" ] && [ "$DIR" != "/" ]; do
  DIR="$(dirname "$DIR")"
done

REPO_ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null)"
[ -z "$REPO_ROOT" ] && exit 0

BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null)"

case "$BRANCH" in
  main|master|development|dev|production)
    REASON="Edits forbidden on protected branch '$BRANCH' in $REPO_ROOT. Create a feature branch first (e.g. 'git -C $REPO_ROOT checkout -b omraneah/<short-task-name>') and retry. If a feature branch already exists for this session in this repo, switch to it — do not create siblings."
    python3 - "$REASON" <<'PY' 2>/dev/null || true
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": sys.argv[1]}}))
PY
    exit 0
    ;;
esac

exit 0
