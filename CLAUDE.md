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
| `resume_app/` | Outdated app for resume work. | Low priority. |

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
