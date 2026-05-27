# Agent Permissions

Canonical workspace permission policy for all agents.

Agent-agnostic means the policy lives here first, then each agent adapter expresses it in that platform's format:

- Claude Code adapter: `.claude/settings.json` grants the required tool classes; `.agent-hooks/` enforces branch safety.
- Codex adapter: `.codex/rules/default.rules` mirrors `command-prefixes.rules` for recurring shell approvals; `.codex/setup.sh` installs those rules into Codex's runtime rules file.

Do not add one-off runtime approvals directly to an agent-specific file without updating this folder. If a permission is part of ordinary workspace workflow, add it to `command-prefixes.rules` and sync the adapters.

Destructive commands stay out of the canonical policy: no `git reset`, no `git checkout --`, no `git branch -D`, no `rm`.
