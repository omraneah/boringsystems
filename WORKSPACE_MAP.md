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

- `CLAUDE.md` — project instructions, always in context.
- `.claude/` — hooks, symlinked personal skills, decision registry, memory.
  - `decisions/DECISIONS.md` — chronological decision log (via `/log-decision`).
  - `personal-skills/` — skills available everywhere (symlinked to `~/.claude/skills`).
  - Hooks: `block-protected-push.sh`, `auto-commit.sh`, `session-start.sh`.
- `setup.sh` — one-time symlink setup on a new machine.

---

## Maintenance

This map is maintained by hand, not auto-generated. Update it when top-level structure changes: a new project added, a project removed, a routing entry moved or renamed. Do not list files below the project level — that belongs in each project's own index.

Rule: if a submodule has no routing index, reference it but don't force-create one here. Do not overdo it.
