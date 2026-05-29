#!/bin/bash
# SessionStart hook — decay nag for the tiered memory system.
# Detects staleness conditions and emits a non-blocking advisory message.
#
# Two detection modes:
# 1. Week folder without consolidation: a daily-entry week folder older than
#    the live window (this week + last week, ISO weeks) has no consolidation.md.
# 2. Feedback note count >20: too many raw feedback files signals distillation debt.
#
# Output contract: hookSpecificOutput.additionalContext — same contract as
# other .agents/hooks/ (brevity-reminder, parallel-by-default-reminder).
# Always exits 0 — never blocks the session.
#
# Tools: pure bash + date + find + wc. No Python, no installed tools beyond coreutils.
# Agent-agnostic — registered in both .claude/settings.json and .codex/hooks.json.

# Resolve workspace root
PROJ_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$PROJ_DIR" ] && exit 0

# --- ISO week helpers ---
# Current ISO week (YYYY-Www)
current_week="$(date +%Y-W%V 2>/dev/null || true)"
# Last ISO week
last_week="$(date -d '7 days ago' +%Y-W%V 2>/dev/null || true)"

# Fall back silently if date arithmetic is unavailable
[ -z "$current_week" ] && exit 0
[ -z "$last_week" ] && exit 0

nag_msgs=""

# --- Mode 1: stale week folders without consolidation.md ---
short_term_dir="$PROJ_DIR/memory/short-term"
if [ -d "$short_term_dir" ]; then
  while IFS= read -r week_dir; do
    week_name="$(basename "$week_dir")"
    # Only process YYYY-Www shaped folders
    case "$week_name" in
      20[0-9][0-9]-W[0-9][0-9]) ;;
      *) continue ;;
    esac
    # Skip the live window (current week and last week)
    if [ "$week_name" = "$current_week" ] || [ "$week_name" = "$last_week" ]; then
      continue
    fi
    # Check for any daily entry files (existence of at least one *.md that is not consolidation.md)
    has_daily=0
    has_consolidation=0
    for f in "$week_dir"/*.md; do
      [ -f "$f" ] || continue
      case "$(basename "$f")" in
        consolidation.md) has_consolidation=1 ;;
        *)                has_daily=1 ;;
      esac
    done
    if [ "$has_daily" -eq 1 ] && [ "$has_consolidation" -eq 0 ]; then
      nag_msgs="${nag_msgs}week ${week_name} has daily entries but no consolidation.md; "
    fi
  done < <(find "$short_term_dir" -mindepth 1 -maxdepth 1 -type d | sort)
fi

# --- Mode 2: feedback note count >20 ---
FEEDBACK_THRESHOLD=20
if [ -d "$PROJ_DIR/memory/short-term/feedback" ]; then
  feedback_count=0
  for f in "$PROJ_DIR/memory/short-term/feedback/stable/"*.md \
            "$PROJ_DIR/memory/short-term/feedback/in-flight/"*.md; do
    [ -f "$f" ] || continue
    case "$(basename "$f")" in README.md|TODO.md) continue ;; esac
    feedback_count=$((feedback_count + 1))
  done
  if [ "$feedback_count" -gt "$FEEDBACK_THRESHOLD" ]; then
    nag_msgs="${nag_msgs}${feedback_count} feedback notes (>${FEEDBACK_THRESHOLD} threshold); "
  fi
fi

# --- Emit or exit clean ---
if [ -n "$nag_msgs" ]; then
  # Trim trailing "; "
  nag_msgs="${nag_msgs%; }"
  MSG="⚠️ distillation + pruning needed — ${nag_msgs}. Run /consolidate-week."
  # Escape for JSON string value
  ESCAPED="$(printf '%s' "$MSG" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$ESCAPED"
fi

exit 0
