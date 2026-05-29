# `.agents/hooks/` — Agent-lifecycle hooks

These hooks are fired by the **agent platform** (Claude Code, Codex) on agent events: `SessionStart`, `PreToolUse`, `Stop`, `UserPromptSubmit`.

They are registered in agent-specific config files:
- Claude Code: `.claude/settings.json` (under `hooks`)
- Codex: `.codex/hooks.json`

Scripts here are stateless and agent-agnostic — they must work correctly when called by any agent that registers them. Agent-specific lifecycle hooks (e.g. `session-start.sh`) live under the agent's own directory (`.claude/hooks/`, `.codex/`) and are not here.

---

## Sibling system: `.agents/git-hooks/`

`.agents/git-hooks/` holds git hooks (`pre-commit`, `pre-push`) fired by **git** via `core.hooksPath`. These are a separate system:

- Git names hooks by event (`pre-commit`, `pre-push`, etc.), not by agent.
- `core.hooksPath` can only point at one directory; that directory must contain only git-named hooks.
- Agent-lifecycle hooks and git hooks run at different times, triggered by different systems.

They are **sibling systems, not parent/child**. Separate directories keep them orthogonal.

See `docs/architecture/adr-006-agent-agnostic-harness.md` for the full architecture.
