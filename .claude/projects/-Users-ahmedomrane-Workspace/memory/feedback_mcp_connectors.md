---
name: Cloud-Connector-Only Tool Auth
description: Never suggest manual auth (gh auth login, MCP API keys, tokens). All tool access goes through claude.ai connectors. Applies to MCP AND CLI tools.
type: feedback
originSessionId: 5eb01b49-a215-4b70-a1a0-353c0aaae2f2
---
**All tool authentication goes through claude.ai connectors. Never suggest manual token-based auth — ever.** This covers both MCP servers and CLI tools.

**Why:** Connectors are OAuth-managed by Anthropic, account-scoped, and work across every surface (local, cloud, mobile) with zero configuration. Manual token setups (gh auth login, API keys in .mcp.json, env vars) are pointless maintenance burden, don't work in cloud/mobile sessions, and leak credentials into local state. Ahmed explicitly refuses to hand out tokens — the architecture must be laptop-agnostic and connector-first.

**Services with direct connectors** (never set up manually, never suggest CLI auth for these): Linear, GitHub, Gmail, Google Calendar, Google Drive, Notion — and anything else visible in claude.ai Connectors.

**How to apply:**
- When Ahmed asks to connect a tool, first check if it's in claude.ai Connectors. If yes, use it. Stop.
- When an action needs GitHub (create PR, comment, merge, read issues, etc.), use the `mcp__github__*` tools. Never `gh` CLI, never `gh auth login`.
- When Linear is needed, use `mcp__claude_ai_Linear__*`. Never `linear-cli` or API keys.
- If I catch myself about to recommend `gh auth login`, `gh auth status`, a manual .mcp.json edit, or any token flow — stop, switch to the connector, and if no connector exists for that specific service, ask before proposing manual setup.
- Manual setup is only acceptable after explicit confirmation that no connector exists and the need is real.
