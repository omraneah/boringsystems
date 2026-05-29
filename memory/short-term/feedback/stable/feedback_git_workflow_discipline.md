---
name: Git Workflow Discipline — Commit, Branch, and Edit Without Asking
description: Pre-authorized git + edit workflow. Commit + push on task completion without asking. Check branch before first edit; create feature branch if on a protected branch; reuse the session branch — no siblings. Batch multi-file edit plans.
type: feedback
---

## Rule 1 — Commit + Push Without Asking

When a discrete unit of work finishes, commit and push to a feature branch without asking permission first. This is the default close-out for any completed task.

**Why:** Asking each time creates friction and signals hesitation on a workflow that's already settled. Ahmed has established it as the standard close.

**How to apply:**
- After finishing a task (skill created, file written, fix shipped, etc.), commit + push immediately. Don't end the turn with "want me to commit?".
- Git commands are pre-authorized normal workflow. Do not ask permission for Git operations on feature branches.
- Always on a feature branch. Never main, master, development, dev, production. (Already enforced by hook, but bake it into the default flow — branch first if currently on a protected branch.)
- The `/commit` skill already pushes to the current feature branch — just run it.
- If currently on a protected branch, create a sensibly-named feature branch first (e.g., `omraneah/<short-task-name>`), then commit + push.
- This rule does not change the PR-creation rule: Claude pushes; Ahmed opens the PR.

## Rule 2 — Auto-Edit on Feature Branch — Never Ask

Editing files in this workspace is pre-authorized. Do not ask Ahmed for permission to use Edit, Write, or NotebookEdit. The workspace is fully version-controlled and edits on a feature branch are reversible.

**Why:** Asking each time creates friction on a settled workflow. The version-control layer already provides safety — branches give isolation, commits give history, PRs give review. Permission prompts on top of that are noise. Ahmed has explicitly stated this rule and asked it to be enforced via config so it never re-emerges.

**How to apply:**

1. **Before the first edit of any session, check current branch in the relevant repo.**
   - `git -C <repo-root> rev-parse --abbrev-ref HEAD`
   - Protected names: `main`, `master`, `development`, `dev`, `production`.

2. **If on a protected branch, create a feature branch first.**
   - Convention for single-feature work: `omraneah/<short-task-name>` (kebab-case, descriptive of the task).
   - Convention for multi-concern session work (questions review + memory distillation + decisions across multiple cards, where there isn't a single named feature): `omraneah/session-YYYY-MM-DD`. Established 2026-04-30.
   - The `enforce-feature-branch.sh` PreToolUse hook will block the edit otherwise — that hook is the safety net, not the primary path. Do the right thing without waiting for the hook to fire.

3. **If a feature branch already exists for this session in this repo, keep editing on it.**
   - Do not create siblings. One task = one branch. Multiple deliverables that share a context fit on the same branch.
   - Card-fanout discipline (see `feedback_card_fanout_discipline.md`) applies to branches too: if you're about to spin up a second feature branch in the same session for related work, reconsider — usually the answer is to keep using the current branch.

4. **Edit freely once the branch is right.** No "want me to edit this?" preambles, no recap of the diff in chat after editing. The diff IS the recap (workspace rule: `feedback_no_recap_after_link.md`).

5. **Submodule edits follow the same rule for the submodule's own branch.** The hook checks the repo containing the file being edited, which is the correct granularity — a workspace-root feature branch does not cover edits in `personal-apps/` or `boringsystems/` submodules; those need their own feature branches.

**Enforcement:**
- `Edit`, `Write`, `NotebookEdit` are in the permissions allow-list in `.claude/settings.json` (no prompt).
- `enforce-feature-branch.sh` blocks edits on protected branches (PreToolUse hook on `Edit|Write|NotebookEdit`).
- `block-protected-push.sh` blocks pushes to protected branches (PreToolUse hook on `Bash`) — defense in depth.

**Decisions:** see `decision-registry/` entries for "auto-allow Edit/Write" and "feature-branch enforcement at edit time".

## Rule 3 — Batch Permission for Multi-File Edit Sweeps

When editing multiple skill files or configuration files in a sweep, do not ask permission per file.

**Why:** Per-file confirmation creates noise and breaks momentum on a sweep that's already been agreed in principle. The risk of a per-file change is low (skills are reversible markdown edits, config changes are tracked), so the friction cost outweighs the safety benefit.

**How to apply:**
- At the start of a multi-file edit pass, present the full plan (which files, what changes per file, why). Ask once.
- Once approved, execute all edits in a batch using parallel Edit tool calls where independent.
- At the end, validate (read back the changed files, summarize the diff in one screen).
- Per-file mid-stream questions only when something genuinely surprising surfaces during the edit (e.g., the file is structured differently than expected and the planned change no longer fits).
- This rule applies to any multi-file sweep, not just boringsystems skills.
