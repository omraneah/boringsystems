# boringsystems — Claude Code Project Architecture

This document governs how Claude Code tooling (skills, docs, governance) is structured for this repo. It is the source of truth for any agent — local or cloud — working on boringsystems.

**Companion decision entry:** `workspace/.claude/decisions/DECISIONS.md` (`2026-04-21 — Skills Architecture: Project-Scoped + Cross-Project Split`).

---

## Two-layer skills model

The skills this project uses live in two different scopes. There is **no duplication** and **no sync script**. Location determines availability.

### Project-scoped (this repo)

Live at `.claude/skills/` in this repo. They travel with the code. They are only active when Claude Code is launched **from inside this repo** — or when a cloud agent is operating against this repo's checkout.

Current skills:

| Skill | Purpose |
|---|---|
| `article-capture` | Turn a conversation into a structured Linear card for a boringsystems article. |
| `article-review` | Pre-publish review against `docs/design-charter.md`, `docs/target-audiences.md`, `docs/french-guide.md`. Delegates FR pass to `french-audit`. |
| `french-audit` | Lint French content against `docs/french-guide.md`. Blocks over-translation of English technical/business terms. |

When the skill set grows (e.g. a future `new-post` scaffolder), add it here — not to the workspace root.

### Cross-project (workspace-wide)

Live at `~/.claude/skills/` on Ahmed's local machine (via the `workspace/.claude/personal-skills/` symlink). They apply to every repo: `commit`, `pr`, `log-decision`, `arch-review`. They are **not** accessible to cloud agents — those agents only see this repo.

---

## Governance docs

Live at `docs/` in this repo. Agents read them even when the skills above aren't loaded.

| Doc | Purpose |
|---|---|
| `docs/target-audiences.md` | Two personas (`technical`, `operator`) and their lane assignments. |
| `docs/design-charter.md` | Voice, typography, color discipline, lanes, anti-patterns. |
| `docs/french-guide.md` | FR voice rules. English-default for technical/business terms. |

**The docs are the real source of truth.** Skills are convenience wrappers around "read these docs, then act." A cloud agent that doesn't load the project skills can still do most of the work by reading the docs directly ("read `docs/french-guide.md`, then review this FR draft").

---

## Two workflows, one architecture

### Local (Ahmed's laptop)

Claude Code is typically launched from one of two directories:

- **Workspace root** (`~/Workspace/`) — for cross-project work, WORKSPACE_MAP navigation, or multi-project decisions. Only cross-project skills are loaded here. **boringsystems skills are NOT available.** If you need them, either `cd boringsystems && claude` in a separate terminal, or ask Claude to read the relevant `docs/*.md` directly.
- **Project root** (`~/Workspace/boringsystems/`) — for all boringsystems work. Both cross-project skills (via user-level) and project-scoped skills (via this repo's `.claude/skills/`) are loaded. **This is the default workflow for content work.**

### Cloud agent (claude.ai platform, single repo)

A cloud agent running against `omraneah/boringsystems` sees:
- `.claude/skills/` — loaded as project skills (once the platform supports it) or readable as configuration.
- `docs/*.md` — directly readable.
- No access to the workspace-root symlinks. That is by design — cross-project skills don't belong to a single repo.

The cloud agent has **full capability** on this repo because everything it needs is in the checkout.

---

## Adding a new skill

1. Decide the scope by asking: "Does this apply to every repo I work in, or only this one?"
2. If project-only → add to `boringsystems/.claude/skills/<skill>/SKILL.md`. Commit with the repo.
3. If cross-project → add to `workspace/.claude/personal-skills/<skill>/SKILL.md`. Commit at workspace level.
4. Never duplicate. If a skill outgrows its scope later, hoist it up — don't copy it down.

---

## Adding a new governance doc

1. Put it in `docs/` in this repo.
2. Reference it from the skill(s) that load it (usually `article-review`).
3. Reference it from here if it's load-bearing for the architecture.

Governance docs are meant to be read by humans **and** agents. Write them accordingly — no implicit context.

---

## Why this is stable

- **No drift risk.** Each skill has one home; each doc has one home.
- **Cloud-agent native.** Everything a cloud agent needs for boringsystems work is in the checkout.
- **Workflow-discipline-driven.** The launch directory is the signal. Launch from the project you're working on. The tool is designed for this.
- **Reversible.** If a project-scoped skill becomes genuinely cross-project, move it up. If a cross-project skill calcifies around one repo, move it down. The model supports both directions.
