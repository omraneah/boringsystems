---
name: Workspace Structure & Project Map
description: What each folder is, its tech stack, and access rules
type: project
originSessionId: a319ed9a-b949-4c73-8e30-5e8620bcec97
---
Primary workspace: `/Users/ahmedomrane/Workspace/`

**Why:** This is Ahmed's main working directory for all projects — personal site, company context, architectural references, and personal apps.

**How to apply:** Always operate from this root. Each folder has different access rules.

---

## Folders

### `llm-context-2026/`
Ahmed's strategic brain — identity, market positioning, transition strategy. Living documents, updated as he evolves.
- **Access:** Read-only by default. Never modify without explicit instruction.
- **Key files:** `_SYSTEM PROMPT — STRATEGIC ADVISOR_.md` (main context), `STRATEGIC INDEX & ROUTING MAP.md` (navigation)
- **Subdirs:** `inner-game/` (identity), `transition/` (Enakl exit), `market/` (positioning)

### `Enakl/`
3-year history: built a TMS (Transport Management System) for a logistics startup, now transitioning to SaaS.
- **Access:** Read-only. Never modify without explicit per-session permission.
- **Purpose:** Reference for how Ahmed builds complex systems.

### `cross-stack-architecture-starter-pack/`
Ahmed's distilled architectural principles — non-negotiable boundaries for all projects.
- **Access:** Read-only.
- **Structure:** ARDs (root `.md` files) = non-negotiable. `AGENT-GUIDES/`, `PATTERNS/`, `DECISION-TREES/`, `ANTI-PATTERNS/` = implementation guidance.
- **Use:** Read before generating architecture code on new projects.

### `boringsystems/`
Ahmed's personal site — engineering leadership case files and frameworks.
- **Stack:** Astro, deployed on Vercel
- **Deploy:** Manual — `npx vercel --prod`. No auto-deploy from GitHub.
- **Color palette:** Defined in `src/styles/global.css`. Dark theme with gold accent (`#c8a96e`).

### `personal-apps/`
Personal subdomain apps — built to showcase and experiment with AI dev tools.
- **Stack:** Next.js 16.2, React 19, Tailwind 4, TypeScript, Vercel Analytics
- **Structure:** Monorepo-ish. Current app: `apps/pollen-tracker/`
- **Warning:** Next.js 16 / React 19 have breaking changes. Read `AGENTS.md` before coding here. Check `node_modules/next/dist/docs/` for current API.

