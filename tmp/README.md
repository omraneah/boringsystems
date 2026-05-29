# tmp/ — short-term RAM

Long analysis Claude generates during a session lands here instead of being dumped in chat. Easier to read, easier to revisit, doesn't bloat the exchange.

## Rules

- Folder is tracked. Contents are not. `.gitignore` keeps `.gitkeep` and this `README.md` visible; everything else is hidden.
- Wiped at session start by a SessionStart hook.
- Wiped at session end by `/wrap-session` if anything's still here.
- Default fate of any file in `tmp/` is deletion. Assume nothing persists across sessions.

## Escalation

If something in `tmp/` matters, Ahmed says so explicitly. That's when it moves to its real home — `docs/`, `memory/`, an article, a Linear card, an ADR. Never promote a file silently.

## When Claude should use it

Output greater than ~400 words of dense analysis the user will read in full → write to `tmp/<descriptive-name>.md`, reference the path in chat. Don't dump long blocks inline.

Full rule: `docs/agent-ops/workspace-workflow.md` § tmp/ workspace short-term RAM.
