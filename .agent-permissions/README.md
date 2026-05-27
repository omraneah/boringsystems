# Agent Permissions

Canonical workspace permission policy for all agents.

Agent-agnostic means the policy lives here first, then each agent adapter expresses it in that platform's format:

- Claude Code adapter: `.claude/settings.json` grants the required tool classes and connector tools; `.agent-hooks/` enforces branch safety.
- Codex adapter: `.codex/rules/default.rules` mirrors `command-prefixes.rules` for recurring shell approvals; `.codex/setup.sh` installs those rules into Codex's runtime rules file. Codex connector access is provided by platform apps/connectors, not shell rules.

Do not add one-off runtime approvals directly to an agent-specific file without updating this folder. If a shell permission is part of ordinary workspace workflow, add it to `command-prefixes.rules`. If a Claude MCP connector tool is part of ordinary workspace workflow, add it to `claude-mcp-allow.txt`. Then sync the adapters.

Git is ordinary workspace workflow. Codex allows the `git` command family broadly, matching Claude Code's broad `Bash` permission. Do not narrow this back into per-command Git prompts. The safety boundary is enforced by hooks, not by asking Ahmed for every Git command.

Git guardrails live in `.agent-hooks/block-protected-push.sh`: never push to protected branches (`main`, `master`, `development`, `dev`, `production`), never force-push to protected branches, and never delete protected branches locally or remotely. If protected branches are involved, treat it as risky and stop for Ahmed. All other Git commands are pre-authorized normal workflow.

Non-Git destructive shell commands stay out of the canonical policy: no `rm` blanket approval.
