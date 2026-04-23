#!/bin/bash
# Stop hook — nudges Claude to run /gtm-sync if the session touched
# go-to-market territory without updating the go-to-market/ folder.
#
# Cheap heuristic: scan the most recent transcript for GTM-shaped
# keywords. If matched AND no files under go-to-market/ were modified
# in the current branch since the last commit, print a one-line nudge.
#
# The nudge is informational — Claude sees it in SessionStart context
# and decides whether to invoke /gtm-sync before the next turn.

PROJ_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJ_DIR" || exit 0

# Only run at the workspace root (go-to-market/ lives there).
[ -d "$PROJ_DIR/go-to-market" ] || exit 0

# Locate the transcript for this session. Claude Code stores them under
# ~/.claude/projects/<slug>/. We scan the latest one.
SLUG=$(echo "$PROJ_DIR" | sed 's|/|-|g')
TRANSCRIPT_DIR="$HOME/.claude/projects/${SLUG}"
[ -d "$TRANSCRIPT_DIR" ] || exit 0

LATEST=$(ls -t "$TRANSCRIPT_DIR"/*.jsonl 2>/dev/null | head -1)
[ -z "$LATEST" ] && exit 0

# Grep only the last ~200 lines of the transcript to keep this cheap.
TAIL=$(tail -n 200 "$LATEST" 2>/dev/null)
[ -z "$TAIL" ] && exit 0

# GTM keyword scan. Case-insensitive. Tuned to catch the classes of
# signal gtm-sync is meant to capture without overfiring on generic
# business talk.
MATCHED=0
echo "$TAIL" | grep -qiE "\b(linkedin|fractional|freelanc|positioning|inbound|DM|reach[- ]?out|offer|pricing|sprint founder|transformation lead|solopreneur|founding engineer)\b" && MATCHED=1

[ "$MATCHED" -eq 0 ] && exit 0

# Check whether go-to-market/ was touched this branch since last commit.
# If yes, assume Claude already captured the signal.
if git diff --quiet HEAD -- go-to-market/ 2>/dev/null && \
   [ -z "$(git status --porcelain go-to-market/ 2>/dev/null)" ]; then
  # No changes under go-to-market/ yet — nudge.
  echo "[gtm-nudge] Session touched GTM territory (LinkedIn / offers / positioning / inbound signals) but go-to-market/ was not updated. Consider running /gtm-sync before closing." >&2
fi

exit 0
