# Agent Permissions

Canonical workspace permission policy for all agents.

Agent-agnostic means the policy lives here first, then each agent adapter expresses it in that platform's format:

- Claude Code adapter: `.claude/settings.json` grants the required tool classes and connector tools; `.agent-hooks/` enforces branch safety.
- Codex adapter: `.codex/rules/default.rules` mirrors `command-prefixes.rules` for recurring shell approvals; `.codex/setup.sh` installs those rules into Codex's runtime rules file. Codex connector access is provided by platform apps/connectors, not shell rules.

Do not add one-off runtime approvals directly to an agent-specific file without updating this folder. If a shell permission is part of ordinary workspace workflow, add it to `command-prefixes.rules`. If a Claude MCP connector tool is part of ordinary workspace workflow, add it to `claude-mcp-allow.txt`. Then sync the adapters.

Local merged-branch cleanup is ordinary workflow: `git branch -d <feature-branch>` is allowed without prompting. Guardrails live in `.agent-hooks/block-protected-push.sh`: never delete protected branches (`main`, `master`, `development`, `dev`, `production`), never force-delete with `git branch -D`, and never delete remote branches (`git push origin --delete ...` or refspec deletion).

Destructive commands stay out of the canonical policy: no `git reset`, no `git checkout --`, no `git branch -D`, no `rm`, no remote branch deletion.
