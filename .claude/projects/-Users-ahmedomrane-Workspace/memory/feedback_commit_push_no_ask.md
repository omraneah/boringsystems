---
name: Commit + Push Without Asking
description: When work on a task is complete, commit and push to a feature branch automatically — no permission check. Always feature branch, never main.
type: feedback
---

When a discrete unit of work finishes, run `/commit` (or equivalent) and push to a feature branch without asking permission first. This is the default close-out for any completed task.

**Why:** Asking each time creates friction and signals hesitation on a workflow that's already settled. Ahmed has established it as the standard close.

**How to apply:**
- After finishing a task (skill created, file written, fix shipped, etc.), commit + push immediately. Don't end the turn with "want me to commit?".
- Always on a feature branch. Never main, master, development, dev, production. (Already enforced by hook, but bake it into the default flow — branch first if currently on a protected branch.)
- The `/commit` skill already pushes to the current feature branch — just run it.
- If currently on a protected branch, create a sensibly-named feature branch first (e.g., `omraneah/<short-task-name>`), then commit + push.
- This rule does not change the PR-creation rule: Claude pushes; Ahmed opens the PR.
