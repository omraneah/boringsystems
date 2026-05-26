# .claude/hooks/ — Claude Code lifecycle hooks

These hooks are **Claude Code-specific**. They cannot be made agent-agnostic because they depend on:

- `CLAUDE_PROJECT_DIR` / `CLAUDE_ENV_FILE` — environment variables only Claude Code injects
- Lifecycle events (SessionStart, Stop, PostEditFile) that Codex and other agents do not support

| File | Event | Purpose |
|------|-------|---------|
| `session-start.sh` | SessionStart | Runs setup.sh, pulls base branch, surfaces last type-check failures |
| `post-edit-typecheck.sh` | Stop | Runs `astro check` / `tsc --noEmit` on feature branches after edits |
| `auto-commit.sh` | Stop | Auto-checkpoints uncommitted work (debounced, protected branches excluded) |
| `gtm-nudge.sh` | Stop | Nudges to run /gtm-sync when session touched GTM territory |

**Enforcement hooks** (branch protection, brevity, parallel reminder) are agent-agnostic and live in `../.agent-hooks/` — both Claude Code (`settings.json`) and Codex (`../.codex/hooks.json`) point there.
