# Workspace Map

Routing index for `/Users/ahmedomrane/Workspace`. One file, one hop — load this before exploring.

Scope: top-level projects and where to go next for each. Not a file inventory. When a project has its own routing index, this map points to it and stops.

---

## Projects

### `personal-apps/` — submodule
Next.js 16 + React 19 + Tailwind 4 monorepo. Subdomain apps on boringsystems domain.
- Routing entry → `AGENTS.md` and `CLAUDE.md`
- Apps live under `apps/` (first: `pollen-tracker`).

### `boringsystems/` — submodule
Personal site. Astro + Vercel, manual deploy (`npx vercel --prod`).
- No routing index. Start at `package.json` and `src/`.
- Palette lives in `src/styles/global.css` — don't touch blindly.

### `cross-stack-architecture-starter-pack/` — submodule
Architectural principles + ARDs. Pattern library, not runtime code.
- Routing entry → ARDs at root (`*-boundaries.md`, `PATTERNS/`, `ANTI-PATTERNS/`, `DECISION-TREES/`, `AGENT-GUIDES/`)
- Use via `/arch-review` for lightweight checks. Pull full ARDs only for enterprise/multi-tenant work.

### `Enakl/` — directory (not a submodule)
Historical TMS → SaaS work. Read-only context.
- Sub-apps: `analytics/`, `backend/`, `cloud-infra/`, `cross-stack-architecture/`, `driver-app/`, `rider-app/`
- `driver-app/` and `rider-app/` have their own `CLAUDE.md`.

### `tmp/` — scratch
Ephemeral. Not persistent, not tracked as project state.

---

## Workspace-level infra

### Canonical (agent-agnostic)

- `AGENTS.md` — workspace instructions. Industry-standard, read natively by Codex / Cursor / Windsurf / Amp / Devin. Claude Code imports via `@AGENTS.md` in `CLAUDE.md`. Single source of truth for all non-agent-specific rules.
- `.agents/` — the single canonical shared tree. Everything agent-agnostic lives here; `.claude/` and `.codex/` are pure adapters that read or are generated from it.
  - `.agents/skills/` — cross-agent skills, canonical write target. Codex reads natively; `~/.claude/skills/` symlinks here for Claude. Bypasses the feature-branch hook by design. No per-agent copies.
  - `.agents/personas/` — sub-agent definitions: YAML frontmatter (description, model, effort, tools) + body. Single source; `scripts/generate-agents.sh` builds both adapters from it.
  - `.agents/hooks/` — stateless shared hooks (no agent-specific env vars). Registered by both Claude Code and Codex: `enforce-feature-branch.sh`, `block-protected-push.sh`, `brevity-reminder.sh`, `parallel-by-default-reminder.sh`, `auto-commit.sh`, `post-edit-typecheck.sh`, `pull-base-branch.sh`.
  - `.agents/permissions/` — canonical permission policy for shell workflow and connector tools. Agent-specific permission files are adapters generated/validated from here via `sync.sh`.
- `scripts/generate-agents.sh` — generates `.claude/agents/*.md` AND `.codex/agents/*.toml` from `.agents/personas/*.md`. Run before commit by `.claude/git-hooks/pre-commit`.

### Claude Code–specific

- `CLAUDE.md` — thin wrapper: `@AGENTS.md` + Claude Code addenda (skills invocation, sub-agents, connectors, hooks path).
- `.claude/` — settings, hooks, agent wrappers, decisions, git-hooks, setup.
  - `settings.json` — shared hooks point to `.agents/hooks/`; Claude-specific lifecycle hooks stay in `.claude/hooks/`.
  - `hooks/` — Claude-specific lifecycle hooks: `session-start.sh`, `gtm-nudge.sh`.
  - `agents/` — generated; do not edit by hand. Frontmatter + inlined body, built from `.agents/personas/<name>.md`.
  - `decisions/DECISIONS.md` — chronological decision log (via `/log-decision`).
  - `setup.sh` — idempotent Claude Code setup: skills symlink, settings symlink, memory symlink, git hooks, Marky.

### Codex-specific

- `.codex/agents/*.toml` — generated; do not edit by hand. Source: `.agents/personas/*.md`.
- `.codex/hooks.json` — Codex hook config; uses `git rev-parse --show-toplevel` for machine-agnostic paths. Runs `.codex/setup.sh` on SessionStart once the workspace is trusted.
- `.codex/setup.sh` — Codex runtime setup. Installs workspace-owned command approvals additively into Codex's runtime rules file.
- `.codex/rules/default.rules` — Codex command-approval adapter generated from `.agents/permissions/command-prefixes.rules`. Do not edit by hand.

---

## Maintenance

This map is maintained by hand, not auto-generated. Update it when top-level structure changes: a new project added, a project removed, a routing entry moved or renamed. Do not list files below the project level — that belongs in each project's own index.

Rule: if a submodule has no routing index, reference it but don't force-create one here. Do not overdo it.
