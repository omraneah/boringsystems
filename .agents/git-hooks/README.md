# `.agents/git-hooks/` — Git hooks

These hooks are fired by **git** on git events (`pre-commit`, `pre-push`). Git finds them via:

```
git config core.hooksPath .agents/git-hooks
```

This is set by each agent's `setup.sh` (`.claude/setup.sh`, `.codex/setup.sh`).

Scripts here follow git's naming convention — the filename IS the hook name. Git does not care which agent is running; it calls the script when the git event fires.

---

## Sibling system: `.agents/hooks/`

`.agents/hooks/` holds agent-lifecycle hooks fired by the **agent platform** (Claude Code, Codex) on events like `SessionStart`, `PreToolUse`, `Stop`, `UserPromptSubmit`. These are registered in agent-specific config files (`.claude/settings.json`, `.codex/hooks.json`).

The two systems are **siblings, not parent/child**:
- Git hooks → git events → `core.hooksPath` → this directory
- Agent hooks → agent events → platform config → `.agents/hooks/`

They run independently. A pre-commit hook and a PreToolUse hook serve completely different purposes and fire at completely different times.

See `docs/architecture/adr-006-agent-agnostic-harness.md` for the full architecture.
