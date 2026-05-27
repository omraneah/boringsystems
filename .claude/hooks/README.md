# .claude/hooks/ — Claude Code-specific lifecycle hooks

These hooks are **Claude Code-only**. They depend on `CLAUDE_PROJECT_DIR` / `CLAUDE_ENV_FILE`
(env vars only Claude Code injects) or on Claude-specific infrastructure (`~/.claude/`).

| File | Event | Purpose |
|------|-------|---------|
| `session-start.sh` | SessionStart | Exports CLAUDE_ENV_FILE, runs setup.sh, calls pull-base-branch, surfaces typecheck summary |
| `gtm-nudge.sh` | Stop | Scans Claude transcripts (`~/.claude/projects/`) for GTM keywords — inherently Claude-specific |

**Shared hooks** (agent-agnostic, registered by both Claude Code and Codex) live in `../.agents/hooks/`:
- `pull-base-branch.sh` — SessionStart: pull base branch on session open
- `auto-commit.sh` — Stop: auto-checkpoint uncommitted work
- `post-edit-typecheck.sh` — Stop: run type check, write summary for next session
- `block-protected-push.sh` — PreToolUse: block pushes to protected branches
- `enforce-feature-branch.sh` — PreToolUse: block edits on protected branches
- `brevity-reminder.sh` — UserPromptSubmit: brevity nudge
- `parallel-by-default-reminder.sh` — UserPromptSubmit: parallel execution nudge
