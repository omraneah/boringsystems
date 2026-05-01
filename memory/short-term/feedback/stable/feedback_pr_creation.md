---
name: PR Creation Division of Labor
description: Claude creates and pushes feature branches; Ahmed opens the actual PR on GitHub. Never invoke gh pr create or mcp__github__create_pull_request.
type: feedback
originSessionId: 5eb01b49-a215-4b70-a1a0-353c0aaae2f2
---
**Claude's job**: create feature branches, commit to them, push to origin, announce when the branch is ready with the GitHub PR-creation URL. Draft the PR title and body if useful.

**Ahmed's job**: click the URL, review, and open the actual PR himself.

**Why:** Ahmed wants the human review-and-submit step to stay manual — the PR is the point where he inspects what's going out, not a rubber stamp. Also consistent with the laptop-agnostic + cloud-connector-only principles: no `gh` CLI, no local tokens, no token-based MCP. Even when the GitHub connector is OAuth-authorized on claude.ai, PR creation is Ahmed's call.

**How to apply:**
- Never run `gh pr create`, `gh pr ...`, or any `gh` command that mutates state.
- Never call `mcp__github__create_pull_request`, `mcp__github__merge_pull_request`, or similar write operations — even if the connector is authenticated.
- When work is ready on a feature branch, end the turn with **all three** of:
  1. **A 5-bullet concise summary** of what shipped (one bullet per concern, terse — not a re-statement of the diff).
  2. **The `github.com/.../pull/new/<branch>` URL** clickable in chat.
  3. **`open <url>` executed via Bash in the same turn** so the URL launches in Ahmed's default browser automatically. No need to ask first; this is the durable default.
- The summary + link in chat is the user-facing artifact; the `open` call is the convenience layer. Both happen, every time.
- `mcp__github__*` read operations are fine (checking PR status, reading issues, listing commits).
- The `/pr` skill follows this same shape — draft title/body, surface URL, open in browser, give the 5-bullet summary — but never creates the PR.
