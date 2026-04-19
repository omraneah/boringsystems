# CLAUDE.md — Workspace Context

This is Ahmed Omrane's primary workspace. All projects live here.

---

## Who Ahmed Is

Ahmed is a senior engineering leader (CTO-equivalent scope) currently in a transition period — exiting Enakl after 3 years, re-entering on his own terms in France 2026.

His leverage is **capability-based and portable**, not title-based:
- Rapid navigation of complex, ambiguous systems
- Crisp judgment under constraint — no over-analysis
- Cross-functional system thinking (tech, product, ops)
- Operational system design (how work flows, not just org charts)
- AI-native edge: compresses execution cycles with AI, does not outsource judgment

He is a sovereign explorer. Depth-oriented. France-based.

---

## Workspace Structure

| Folder | Purpose | Access |
|--------|---------|--------|
| `llm-context-2026/` | **Main brain** — identity, strategy, transition, market positioning. Living documents. | Read-only by default. Handle with care. |
| `Enakl/` | 3 years of TMS work, moving to SaaS. Past company context. | Read-only. Never modify without explicit permission. |
| `cross-stack-architecture-starter-pack/` | Distilled architectural principles and agent guides. Ahmed's opinionated system for starting projects correctly. | Read-only. These are non-negotiable boundaries. |
| `boringsystems/` | Ahmed's personal site — engineering leadership case files. Built with Astro, deployed on Vercel. | Active project. |
| `personal-apps/` | Subdomain apps on boringsystems domain. Next.js 16 + React 19 + Tailwind 4. First app: pollen-tracker. | Active project. |

---

## Rules for This Workspace

### Enakl folder
- **Never modify** anything without explicit per-session permission.
- Read-only context for understanding how Ahmed builds systems.

### llm-context-2026 folder
- This is the strategic brain. Read it when context matters for decisions.
- **Never modify** without explicit instruction.
- The `_SYSTEM PROMPT` and `STRATEGIC INDEX` are the routing map — use them to navigate.

### cross-stack-architecture-starter-pack
- These are Ahmed's architectural principles extracted from real production work.
- ARDs (root-level `.md` files) are **non-negotiable boundaries**.
- Read before generating any architecture code for new projects.

### boringsystems (Astro site)
- Deployed manually via `npx vercel --prod` — no auto-deploy.
- Color palette is defined in `src/styles/global.css` — do not touch without reading it.

### personal-apps (Next.js monorepo)
- Next.js 16 / React 19 / Tailwind 4 — these are newer than most training data.
- Always read `node_modules/next/dist/docs/` or official docs before writing Next.js code.
- Read `AGENTS.md` at the root before coding here.

---

## How to Collaborate With Ahmed

- **Be direct and terse.** No trailing summaries. No "here's what I did" recap after tool use.
- **No emojis** unless explicitly asked.
- **Do not refactor or add features beyond what was asked.** Surgical only.
- **Do not add comments or docstrings** to code you didn't touch.
- When working in any project, read the relevant existing code before suggesting changes.
- When uncertain about architectural decisions, reference `cross-stack-architecture-starter-pack/`.

### Git Workflow (Non-Negotiable)
- **Never push to `main`, `master`, `development`, `dev`, or `production`.**
- Always create a feature branch, push to it, and open a PR.
- Auto-commit runs at end of each task turn (Stop hook) — this is automatic, no need to ask.
- Protected branch push is blocked at hook level — not just instruction level.
- No exceptions, no urgency overrides.

---

## Workspace Infrastructure

### Skills available
| Skill | Scope | Invoke |
|---|---|---|
| `/commit` | Personal (all projects) | Manual or auto |
| `/pr` | Personal (all projects) | Manual only |
| `/log-decision` | Personal (all projects) | Claude auto-invokes after decisions |
| `/arch-review` | Personal (all projects) | Manual or auto |
| `/new-post` | boringsystems only | Manual only |
| `/content-research` | boringsystems only | Manual or auto |

### Hooks active
| Hook | Event | Effect |
|---|---|---|
| `block-protected-push.sh` | PreToolUse (Bash) | Blocks any `git push origin main/master/dev/...` |
| `auto-commit.sh` | Stop (async) | Auto-commits + pushes if dirty, on feature branches only |
| `session-start.sh` | SessionStart (async) | Pulls latest on `main` or `development` if session opens on base branch |

### New machine setup
Run once after cloning:
```bash
bash /Users/ahmedomrane/Workspace/.claude/setup.sh
```
This creates three symlinks:
- `~/.claude/skills` → `personal-skills/` (all personal skills, globally available)
- `~/.claude/settings.json` → `.claude/settings.json` (hooks, permissions, plugins — version controlled)
- `~/.claude/projects/.../memory` → `.claude/projects/.../memory` (workspace memory in git)

`settings.local.json` is gitignored — it is Claude's runtime permission cache, not config.

### Decision Registry
`.claude/decisions/DECISIONS.md` — chronological log of architectural and workflow decisions.
Updated automatically via `log-decision` skill after significant changes.

### MCP Integrations — Non-Negotiable Protocol

Before setting up any MCP server manually (.mcp.json, API keys, env vars):
1. **Check claude.ai Settings → Connectors first.** If a direct connector exists, use it. Stop.
2. Only do manual setup if no direct connector exists and the need is confirmed.

Services with direct connectors (never set up manually): **Linear, GitHub, Gmail** — and any others added to claude.ai Connectors going forward. These are OAuth-managed by Anthropic, account-scoped, and work in every session including cloud and mobile automatically.

---

### cross-stack-architecture-starter-pack — Calibration Note
This repo contains full SaaS-grade patterns (multi-tenancy, OIDC, tenant scoping).
**Most projects here do not need all of it.** Use `arch-review` skill for lightweight checks.
Only pull full ARDs for explicitly multi-tenant or enterprise-grade work.

---

## Key Tech Stack References

- **boringsystems**: Astro, Vercel
- **personal-apps**: Next.js 16.2, React 19, Tailwind 4, TypeScript, Vercel Analytics
- **Enakl** (historical context): TMS → SaaS transition, complex multi-tenant system

---

## LLM Context Routing (from llm-context-2026)

Use the Strategic Index to navigate the context documents:
- Transition + emotion → `transition/` set
- Opportunity evaluation → `market/Leverage Profile & Market Lens.md` first
- External action / positioning → `market/AI-Native-Builder-Positioning.md`
- Identity drift → `inner-game/Meta-Identity-Constitution.md`
- Work confusion → `inner-game/Work-Hygiene-Doctrine.md`
- Never read everything — route precisely.
