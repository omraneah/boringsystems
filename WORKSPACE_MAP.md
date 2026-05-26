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
- `.agent-skills/` — cross-agent skills. Canonical write target; `~/.claude/skills/` symlinks here. Synced to `.agents/skills/` (Codex) by `setup.sh`. Bypass the feature-branch hook by design.
- `.agent-personas/` — persona body markdown for each sub-agent. Used by `.claude/agents/*.md` (via `@` import) AND `scripts/generate-codex-agents.py` (inlined into Codex TOML).
- `.agent-hooks/` — stateless shared hooks (no agent-specific env vars). Used by both Claude Code and Codex: `enforce-feature-branch.sh`, `block-protected-push.sh`, `brevity-reminder.sh`, `parallel-by-default-reminder.sh`.
- `scripts/generate-codex-agents.py` — generates `.codex/agents/*.toml` from `.claude/agents/*.md` (frontmatter) + `.agent-personas/*.md` (body). Run by `setup.sh` each session.

### Claude Code–specific

- `CLAUDE.md` — thin wrapper: `@AGENTS.md` + Claude Code addenda (skills invocation, sub-agents, connectors, hooks path).
- `.claude/` — settings, hooks, agent wrappers, decisions, git-hooks, setup.
  - `settings.json` — shared hooks point to `.agent-hooks/`; Claude-specific lifecycle hooks stay in `.claude/hooks/`.
  - `hooks/` — Claude-specific lifecycle hooks: `session-start.sh`, `auto-commit.sh`, `post-edit-typecheck.sh`, `gtm-nudge.sh`.
  - `agents/` — thin wrappers: frontmatter (description, model, effort, tools) + `@.agent-personas/<name>.md`.
  - `decisions/DECISIONS.md` — chronological decision log (via `/log-decision`).
  - `setup.sh` — idempotent harness setup: skills symlink, Codex skill sync, TOML generation, settings symlink, memory symlink, git hooks, Marky.

### Codex-specific

- `.codex/agents/*.toml` — generated; do not edit by hand. Source: `.claude/agents/*.md` + `.agent-personas/*.md`.
- `.codex/hooks.json` — Codex hook config; uses `git rev-parse --show-toplevel` for machine-agnostic paths.
- `.agents/skills/` — Codex skill copy, synced by `setup.sh`. Do not edit; `.agent-skills/` is the source.

---

## Maintenance

This map is maintained by hand, not auto-generated. Update it when top-level structure changes: a new project added, a project removed, a routing entry moved or renamed. Do not list files below the project level — that belongs in each project's own index.

Rule: if a submodule has no routing index, reference it but don't force-create one here. Do not overdo it.
