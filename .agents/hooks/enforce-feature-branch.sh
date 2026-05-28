#!/bin/bash
# PreToolUse (Edit|Write|NotebookEdit) hook — block file edits on protected branches.
# Forces feature-branch discipline. Companion to block-protected-push.sh.
#
# Output contract differs by agent (see block-protected-push.sh):
#   Claude Code  → exit 2 + reason on stderr (blocks even when Edit/Write are in
#                  permissions.allow — permissionDecision is ignored there).
#   Codex/other  → hookSpecificOutput.permissionDecision="deny" + exit 0.
# Detection: Claude Code sets CLAUDE_PROJECT_DIR; Codex does not.
# Tools: pure bash + jq. No Python.

INPUT="$(cat 2>/dev/null || true)"
FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || true)"
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
    if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
      printf '%s\n' "$REASON" >&2
      exit 2
    fi
    ESCAPED="$(printf '%s' "$REASON" | sed 's/\\/\\\\/g; s/"/\\"/g')"
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$ESCAPED"
    exit 0
    ;;
esac

exit 0
