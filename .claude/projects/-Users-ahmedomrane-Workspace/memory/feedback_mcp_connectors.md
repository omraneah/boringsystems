---
name: MCP Connector Protocol
description: Never set up manual MCP (API keys, .mcp.json) when a direct claude.ai connector exists. Check connectors first, always.
type: feedback
---

Always check claude.ai Settings → Connectors before any MCP setup. If a direct connector exists, use it — never do manual API key / .mcp.json setup for that service.

**Why:** Built-in connectors are OAuth-managed by Anthropic, account-scoped, and work in every session (local, cloud, mobile) with zero configuration. Manual setups are pointless maintenance burden when a connector exists.

**Services with direct connectors (never set up manually):** Linear, GitHub, Gmail — and any others visible in claude.ai Connectors.

**How to apply:** When Ahmed asks to connect a tool, first check if it's in claude.ai Connectors. If yes, say so and stop. Only go the manual route if confirmed no connector exists.
