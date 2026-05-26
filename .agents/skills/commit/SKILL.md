---
name: commit
description: Stage all changes, write a meaningful commit message, and push to the current feature branch. Use when work on a task is complete or when moving to a new task. Never commits to protected branches.
model: sonnet
effort: medium
disable-model-invocation: false
allowed-tools: Bash(git *)
argument-hint: "[optional: commit message override]"
---

Stage, commit, and push current changes to the active branch.

## Steps

1. Check current branch — if on `main`, `master`, `development`, `dev`, or `production`, STOP and tell the user to create a feature branch first.
2. **Run `/hygiene-review`.** If it returns BLOCKED, stop and fix violations before continuing. Skip hygiene-review only for: single-file typo fixes, submodule pointer bumps, and operational one-liners (github-cleanup, tmp-cleanup). When in doubt, run it.
3. Run `git status` to see what changed.
3. Run `git add -A` to stage everything.
4. Write a commit message that:
   - Starts with a type: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`
   - First line: max 72 chars, imperative mood ("Add X" not "Added X")
   - Body (if needed): explain why, not what
   - Always ends with: `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>`
5. Commit using heredoc format to preserve formatting.
6. Push to `origin <current-branch>`.

## If $ARGUMENTS is provided
Use it as the commit message summary line (still apply type prefix if not present).

## Format
```bash
git commit -m "$(cat <<'EOF'
type: summary line here

Optional body explaining why.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

Never use `--no-verify`. Never push to protected branches.
