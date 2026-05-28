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
CWD="$(printf '%s' "$INPUT" | jq -r '.cwd // ""' 2>/dev/null || true)"
[ -z "$CWD" ] && CWD="$(pwd)"

PATHS=""
FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || true)"
[ -n "$FILE_PATH" ] && PATHS="$FILE_PATH"

# Codex file edits arrive through apply_patch. Its hook input reports patch text
# as tool_input.command, so extract touched file paths from patch headers.
PATCH_TEXT="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // .tool_input.cmd // ""' 2>/dev/null || true)"
if [ -n "$PATCH_TEXT" ]; then
  PATCH_PATHS="$(printf '%s\n' "$PATCH_TEXT" | sed -n \
    -e 's/^\*\*\* Update File: //p' \
    -e 's/^\*\*\* Add File: //p' \
    -e 's/^\*\*\* Delete File: //p' \
    -e 's/^\*\*\* Move to: //p')"
  if [ -n "$PATCH_PATHS" ]; then
    PATHS="$(printf '%s\n%s\n' "$PATHS" "$PATCH_PATHS" | sed '/^$/d')"
  fi
fi

[ -z "$PATHS" ] && exit 0

deny_for_path() {
  FILE_PATH="$1"

  # Canonical skills are always editable regardless of branch — quick skill
  # iteration should never require a feature branch.
  case "$FILE_PATH" in
    */.agents/skills/*|.agents/skills/*) return 1 ;;
  esac

  case "$FILE_PATH" in
    /*) ABS_PATH="$FILE_PATH" ;;
    *) ABS_PATH="$CWD/$FILE_PATH" ;;
  esac

  # Walk up to the nearest existing directory (the file may not exist yet).
  DIR="$ABS_PATH"
  while [ ! -d "$DIR" ] && [ "$DIR" != "/" ]; do
    DIR="$(dirname "$DIR")"
  done

  REPO_ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null)"
  [ -z "$REPO_ROOT" ] && return 1

  BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  case "$BRANCH" in
    main|master|development|dev|production)
      REASON="Edits forbidden on protected branch '$BRANCH' in $REPO_ROOT. Create a feature branch first: 'git -C $REPO_ROOT checkout -b omraneah/<short-task-name>' (or 'omraneah/session-$(date +%Y-%m-%d)' for multi-concern session work). See memory/short-term/feedback/stable/feedback_auto_edit_on_feature_branch.md."
      return 0
      ;;
  esac

  return 1
}

while IFS= read -r path; do
  [ -z "$path" ] && continue
  if deny_for_path "$path"; then
    if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
      printf '%s\n' "$REASON" >&2
      exit 2
    fi
    ESCAPED="$(printf '%s' "$REASON" | sed 's/\\/\\\\/g; s/"/\\"/g')"
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$ESCAPED"
    exit 0
  fi
done <<< "$PATHS"

exit 0
