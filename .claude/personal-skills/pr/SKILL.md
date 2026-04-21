---
name: pr
description: Prepare a pull request for the current feature branch — pushes if needed, drafts title and body, and surfaces the GitHub PR-creation URL for Ahmed to open himself. Does NOT create the PR. Use after committing work.
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git *)
argument-hint: "[optional: PR title override]"
---

Prepare everything Ahmed needs to open a PR on GitHub. **Claude never creates the PR itself** — that is Ahmed's manual step. See `memory/feedback_pr_creation.md` for the rule.

## Steps

1. Verify current branch is not a protected branch (`main`, `master`, `dev`, `development`, `production`). If it is, stop.
2. Run `git log main..HEAD --oneline` to see all commits in this branch.
3. Run `git diff main...HEAD --stat` to understand the scope.
4. Determine the base branch (default: `main`).
5. If the branch has unpushed commits, push with `git push -u origin <branch>`.
6. Derive the origin URL from `git remote get-url origin` and construct the PR-creation URL: `https://github.com/<owner>/<repo>/pull/new/<branch>`.
7. If $ARGUMENTS provided, use as the PR title. Otherwise derive from branch name and the most substantive commit subjects.
8. Print to Ahmed: the branch name (confirmed pushed), the PR-creation URL, the drafted title, and the drafted body in a paste-ready code block.

## PR body format

```markdown
## Summary
- [bullet: what changed and why]
- [bullet]

## Test plan
- [ ] [what to verify]
- [ ] [what to verify]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Rules

- Title: under 70 chars, imperative mood.
- Base branch never `main` if the branch was cut from a feature branch — detect the fork point and use that.
- **Never invoke `gh pr create`, `gh pr edit`, or any `gh` command that mutates state.**
- **Never invoke `mcp__github__create_pull_request` or any GitHub MCP write operation** even if the connector is authorized.
- Read-only MCP GitHub operations (status checks, file reads, issue lookups) are fine when needed.
- If Ahmed explicitly asks you to open the PR, remind him of the division of labor and offer to refine the draft instead.

## Output shape

End the turn with a clear, pasteable block:

```
Branch: omraneah/<name> (pushed)
Open PR: https://github.com/<owner>/<repo>/pull/new/<branch>

Title:
<title>

Body:
<body>
```
