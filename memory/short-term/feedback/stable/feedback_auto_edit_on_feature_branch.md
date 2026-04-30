---
name: Auto-Edit on Feature Branch — Never Ask
description: Edit/Write/NotebookEdit are pre-authorized within sessions. Never ask permission. Always check current branch first; create a feature branch if on a protected branch; reuse the existing feature branch within a session — do not create siblings.
type: feedback
---

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
