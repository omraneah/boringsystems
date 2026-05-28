#!/bin/bash
# PreToolUse (Bash) hook — block protected-branch Git operations.
#
# Output contract differs by agent (CLAUDE_PROJECT_DIR signals Claude):
#   Claude Code  → exit 2 + reason on stderr. Blocks RELIABLY even when the Bash
#                  tool is in permissions.allow. (A hookSpecificOutput
#                  permissionDecision is IGNORED when the tool is pre-allowed —
#                  anthropics/claude-code#4669, #18312.)
#   Codex/other  → hookSpecificOutput.permissionDecision="deny" + exit 0. Codex
#                  treats a non-zero exit as a hook FAILURE, not a block.
#
# Precision: quoted spans are stripped so a protected operation MENTIONED inside
# a commit message or quoted arg does not false-positive. Protected-name matches
# are anchored within the SAME statement as the `git push` / `git branch -d`
# they refer to (statements split on ; && || | newline). So
# `git checkout main && git branch -d feature` is allowed.
#
# Tools: pure bash + jq (JSON stdin parse) + grep + sed. No Python.

INPUT="$(cat 2>/dev/null || true)"
COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || true)"

# Strip "..." and '...' so quoted MENTIONS don't false-positive.
SCAN="$(printf '%s' "$COMMAND" | sed -e 's/"[^"]*"/ /g' -e "s/'[^']*'/ /g")"

# Split into statements via parameter expansion. Order matters: && and || before
# single | so the multi-char separators are consumed first.
STMTS="${SCAN//&&/$'\n'}"
STMTS="${STMTS//||/$'\n'}"
STMTS="${STMTS//;/$'\n'}"
STMTS="${STMTS//|/$'\n'}"

PROT_RE='main|master|development|dev|production'
REASON=""

while IFS= read -r stmt; do
  [ -z "$stmt" ] && continue

  # --- git push <…> checks within this statement ---
  if grep -qE '(^|[^A-Za-z0-9_])git[[:space:]]+push\b' <<< "$stmt"; then
    if grep -qE "\borigin[[:space:]]+($PROT_RE)\b" <<< "$stmt"; then
      REASON="Direct push to a protected branch is forbidden. Create a feature branch and open a PR instead."
      break
    fi
    if grep -qE '(-f\b|--force\b|--force-with-lease\b)' <<< "$stmt" && grep -qE "\b($PROT_RE)\b" <<< "$stmt"; then
      REASON="Force-pushing to a protected branch is forbidden."
      break
    fi
    if grep -qE "(--delete|:)[[:space:]]*($PROT_RE)\b" <<< "$stmt"; then
      REASON="Deleting protected branches on the remote is forbidden."
      break
    fi
  fi

  # --- git branch -d/-D <…> arg-check: protected name must appear as an ARG ---
  if grep -qE '(^|[^A-Za-z0-9_])git[[:space:]]+branch[[:space:]]+-[dD]\b' <<< "$stmt"; then
    args="$(printf '%s' "$stmt" | sed -E 's/.*-[dD][[:space:]]+//')"
    for tok in $args; do
      case "$tok" in
        -*) continue ;;
        main|master|development|dev|production)
          REASON="Deleting protected branches locally is forbidden. Protected: main, master, development, dev, production."
          break 2
          ;;
      esac
    done
  fi
done <<< "$STMTS"

if [ -n "$REASON" ]; then
  if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
    printf '%s\n' "$REASON" >&2
    exit 2
  fi
  ESCAPED="$(printf '%s' "$REASON" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$ESCAPED"
  exit 0
fi

exit 0
