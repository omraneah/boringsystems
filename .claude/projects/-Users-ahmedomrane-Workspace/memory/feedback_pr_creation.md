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
- When work is ready on a feature branch, end the turn with: (1) confirmation the branch is pushed, (2) the `github.com/.../pull/new/<branch>` URL, (3) pre-drafted title and body Ahmed can paste.
- `mcp__github__*` read operations are fine (checking PR status, reading issues, listing commits).
- The `/pr` skill should help Ahmed prepare — draft title/body and surface the URL — but it does not create the PR.
