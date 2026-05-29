# Git workflow — non-negotiable

## Protected branches

**Never push to `main`, `master`, `development`, `dev`, or `production`.** Ever.

Enforcement: `.claude/hooks/block-protected-push.sh` blocks any such push at the shell level. The rule is not advisory — the hook intercepts it. If a push is ever needed to a protected branch, it is a conscious decision Ahmed makes manually, not something Claude does.

Git commands are pre-authorized normal workflow for agents. Claude Code gets this through broad `Bash`; Codex gets this through broad `prefix_rule(pattern=["git"], decision="allow")`. Do not ask Ahmed for permission to run Git unless the command touches a protected branch or bypasses hooks.

## Branch-per-concern

- One feature branch per distinct concern. If a session accumulates more than three concerns, split.
- Branch name convention: `omraneah/<kebab-case-summary>` — e.g. `omraneah/hreflang-tags-and-constraints-doc`.
- Branch off `main`. Keep branches short-lived.

## Commit discipline

- Auto-commit fires at the end of each task turn via the Stop hook (`.claude/hooks/auto-commit.sh`) on feature branches only. No manual `/commit` needed for the common case.
- Prefer new commits over amending. A pre-commit hook failure means the commit did not happen — never use `--amend` to "fix" a hook rejection.
- Commit message format: type prefix (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`), imperative mood, body explains "why" not "what".
- Every commit ends with `Co-Authored-By: Claude <model> <noreply@anthropic.com>`.

## PR creation — division of labor

**Claude never opens the PR.** Claude pushes the branch, prepares the title + body, and surfaces the GitHub PR-creation URL. Ahmed opens the PR manually. This is the rule in `memory/medium-term/project-management/workspace-workflow.md` § PR handoff — no `gh pr create`, no `mcp__github__create_pull_request`.

The `/pr` skill handles this workflow: verifies branch, pushes if needed, constructs the creation URL, drafts title and body.

## Post-merge cleanup

When Ahmed signals a merge has happened ("merged, pull and delete", "we're done", "wrap this up"), the `/wrap-session` skill fires automatically — switches to `main`, pulls, deletes the feature branch, stops dev servers, produces a recap with improvement proposals.

## Never

- Never skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless Ahmed explicitly asks.
- Never force-push to a protected branch under any circumstance.
- Never delete a protected branch locally or remotely.
- Never `git reset --hard` without Ahmed's explicit consent.
- Never commit files that likely contain secrets. Warn if Ahmed asks to commit one.

## Working across repos

Several folders are git submodules of the workspace (`boringsystems`, `personal-apps`). Changes to a submodule require:
1. Feature branch inside the submodule, commit, push, PR → merge inside the submodule.
2. Update the workspace's submodule pointer in a workspace feature branch, PR → merge.

The two PRs are independent but the workspace bump closes the loop. Do not leave submodule pointers uncommitted.
