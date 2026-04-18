---
name: Context Inheritance Architecture
description: How context flows from workspace to submodules — design decision to revisit if gaps appear
type: feedback
---

Context architecture is intentionally layered and minimal:

1. `~/.claude/CLAUDE.md` (symlink → `/Workspace/.claude/global-claude.md`) — always loaded, every session, every project. Carries identity, collaboration rules, git rule, strategic context pointer.
2. `/Workspace/CLAUDE.md` — loaded when in workspace or any submodule (CLAUDE.md loads by walking up the directory tree). Carries workspace structure map.
3. Submodule `CLAUDE.md` — project-specific only. Lean.
4. Memory — project-specific per git repo. No cross-project symlinks.

**Why:** Symlinked submodule memory would push workspace-structure noise into focused submodule sessions. The global CLAUDE.md handles "distilled bigger picture" without the map. Going deeper into a submodule intentionally narrows context.

**Why:** Documented Anthropic approach — `~/.claude/CLAUDE.md` is the official mechanism for global context. `.claude/rules/` with symlinks is the official mechanism for sharing rules across projects.

**Revisit if:**
- Submodule sessions lack critical context that can't be covered by the global CLAUDE.md
- A submodule develops enough project-specific memory that it needs its own profile
- The relationship between boringsystems and personal-apps grows complex enough to warrant shared rules via `.claude/rules/` symlinks
- A new submodule is added that needs different global context behavior

**How to apply:** When opening a new submodule as a primary work context, check whether a project-level CLAUDE.md exists there. If not, suggest creating one focused on that project. Do not suggest adding workspace-level context there — it loads automatically.
