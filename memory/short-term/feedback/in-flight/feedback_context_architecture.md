---
name: Context Inheritance Architecture
description: How context flows from workspace to submodules — design decision to revisit if gaps appear
type: feedback
---

Context architecture is intentionally simple:

1. `/Workspace/CLAUDE.md` — the primary context file. Always opened from the workspace root, so always loaded. Carries identity, rules, workspace structure, git workflow.
2. Submodule `CLAUDE.md` — project-specific only, lean. The workspace CLAUDE.md loads automatically via directory walk-up when Claude opens in a submodule.
3. Memory — project-specific per git repo. No cross-project symlinks.

**Why no `~/.claude/CLAUDE.md`:** Ahmed always opens Claude from the workspace root. A global file would be redundant and adds a machine-level setup step with no real benefit. Avoided as unnecessary complexity.

**Why no memory symlinks:** Symlinked submodule memory would push workspace-structure noise into focused submodule sessions. Going deeper into a submodule intentionally narrows context — that's the point.

**Revisit if:**
- Ahmed starts opening Claude from outside the workspace root regularly
- A submodule needs context that the workspace CLAUDE.md doesn't cover via walk-up
- The relationship between boringsystems and personal-apps grows complex enough to warrant shared rules via `.claude/rules/` symlinks

**How to apply:** When opening a new submodule as a primary work context, check whether a project-level CLAUDE.md exists there. If not, suggest creating one focused on that project only. The workspace context loads automatically via directory walk-up.
