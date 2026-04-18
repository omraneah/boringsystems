---
name: pr
description: Create a GitHub pull request for the current feature branch. Use after committing and pushing work. Never targets protected branches.
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *)
argument-hint: "[optional: PR title override]"
---

Create a pull request for the current branch.

## Steps

1. Verify current branch is not a protected branch (`main`, `master`, `dev`, `development`, `production`). If it is, stop.
2. Run `git log main..HEAD --oneline` to see all commits in this branch.
3. Run `git diff main...HEAD --stat` to understand the scope.
4. Determine the base branch (default: `main`).
5. If $ARGUMENTS provided, use as the PR title. Otherwise derive from branch name and commits.
6. Create PR with `gh pr create`.

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
- Title: under 70 chars, imperative mood
- Never target `main` if the branch was cut from a feature branch
- If `gh` is not installed, output the PR URL from the push response and ask user to open it

## Command
```bash
gh pr create --title "..." --body "$(cat <<'EOF'
...body...
EOF
)"
```
