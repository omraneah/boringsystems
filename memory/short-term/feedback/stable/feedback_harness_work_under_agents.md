---
name: Harness work goes under .agents/ — never .claude/ or .codex/
description: Any harness component that must run regardless of which agent is active (hooks, skills, personas, permissions, git-hooks) lives in .agents/. The .claude/ and .codex/ directories hold ONLY per-agent adapters (settings.json, hooks.json, generated persona files, per-agent setup scripts). New harness work that lands under .claude/ or .codex/ is a defect.
type: feedback
---

The workspace is agent-agnostic by design (meta-principle: anything here must survive a fresh-machine clone + the active agent's setup path). Harness components — the discipline layer that should fire regardless of which agent is in the room — must live in a shared location both agents can wire into their runtime.

**Why:** This was violated when a new `pre-commit` lint check landed under `.claude/git-hooks/` instead of `.agents/git-hooks/`. Git hooks are invoked by git itself, not by any agent, so they fire only if the active agent's setup wires `core.hooksPath` at them. Hiding them under `.claude/` means Codex commits silently skip every check the hook enforces. The harness must be one shared body with per-agent wiring on top — not duplicated per-agent.

**How to apply:**

- **Default destination for ALL new harness components is `.agents/`.** Before writing to `.claude/` or `.codex/`, prove the component is genuinely per-agent (settings schema, adapter format, runtime hook contract).
- **Categorization rule (where things live):**
  - `.agents/hooks/` — tool-call hooks (PreToolUse, PostToolUse, UserPromptSubmit, Stop). Agent-agnostic shell scripts; each agent's settings/hooks file wires them.
  - `.agents/git-hooks/` — git-invoked hooks (pre-commit, pre-push). Wired via `git config core.hooksPath .agents/git-hooks` by each agent's setup.sh.
  - `.agents/skills/` — canonical skill definitions (SKILL.md format).
  - `.agents/personas/` — canonical sub-agent personas (single source for all agents).
  - `.agents/permissions/` — canonical permission policy.
  - `.claude/` — Claude Code-specific adapters: `settings.json`, generated `agents/*.md`, `setup.sh` (claude-side wiring only).
  - `.codex/` — Codex-specific adapters: `hooks.json`, generated `agents/*.toml`, `rules/`, `setup.sh` (codex-side wiring only).
- **Per-agent setup wires the agent-agnostic harness into the agent's runtime.** Never duplicate harness logic across `.claude/setup.sh` and `.codex/setup.sh`; both must call into shared resources under `.agents/`. If the same wiring block appears in both setup scripts, that's expected — git hooks paths, hook executable checks, etc. The wiring is per-agent; the harness being wired is shared.
- **Test before commit:** "If Codex (or any other future agent) ran this workspace tomorrow, would the harness behavior I just added still fire?" If no, the work is in the wrong place.
- **Discovery move when adding harness:** look for an existing `.agents/<category>/` directory. If one exists for what you're building, put the new file there. If not, create the directory (e.g. `.agents/git-hooks/` was created via this exact move).

**Cross-references:**

- [[feedback_skills_canonical_path]] — skills always go to `.agents/skills/` (specific case of this general rule).
- [[feedback_laptop_agnostic]] — agent-agnostic + hardware-agnostic as the upstream principle.
- `AGENTS.md` § Agent setup ownership + § Workspace structure — load-bearing workspace context.
