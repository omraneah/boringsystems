# Decision Registry

## Purpose

Chronological log of architectural, workflow, and configuration decisions.
Tracks what was decided, why, what was expected — and over time, what actually happened.

The feedback loop: decisions that prove correct compound. Decisions that drift or fail get marked and explain what came next. This is not documentation after the fact. It is a running audit.

## Format

```
## YYYY-MM-DD — [Title]
**Context:** [situation that required a decision]
**Decision:** [what was decided]
**Why:** [reasoning]
**Expected outcome:** [what this should produce]
**Actual outcome:** [filled in later — what happened, what drifted, what compounded]
```

## How This File Is Maintained

Claude updates this file automatically after any session where architectural, workflow, configuration, or structural decisions are made. No manual entry needed. Periodic review to fill in **Actual outcome** fields as reality confirms or contradicts expectations.

---

## 2026-04-18 — Workspace Git Structure and Version Control Setup

**Context:** Ahmed's projects existed as independent repos with no unified version control layer. No workspace-level git, no submodule coordination, no enforced branching discipline.

**Decision:** Initialize a workspace-level git repo with all active projects as submodules. Create a private GitHub repo (`omraneah/workspace`) as the root. Exclude Enakl (no remote, company context). Use `fix/memory-tracking-and-cleanup` + `feat/global-context-architecture` as the first PRs.

**Why:** Single versioned view of all work. Memory, CLAUDE.md, hooks, skills — all tracked and portable across machines. Submodule structure keeps repo independence while giving workspace-level coordination.

**Expected outcome:** Every infrastructure change is auditable. New machine setup is two commands.

**Actual outcome:** *(pending)*

---

## 2026-04-18 — Context Inheritance Architecture Decision

**Context:** When opening Claude inside a submodule (e.g., boringsystems), it doesn't inherit the workspace-level memory — memory is keyed by git repo root. Two options: memory symlinks (share all workspace memory) or global CLAUDE.md (distilled always-loaded layer).

**Decision:** No symlinks. No `~/.claude/CLAUDE.md`. Ahmed always opens Claude from the workspace root. CLAUDE.md loads via directory walk-up into submodules automatically. Submodule memory stays project-specific. If memory inheritance gaps appear, revisit.

**Why:** Symlinks push workspace-structure noise into focused submodule sessions — the opposite of the intent. Going deeper should narrow context, not inherit it all. Simple is maintainable.

**Expected outcome:** Submodule sessions get workspace context via walk-up without the structural map noise. Memory stays clean and project-scoped.

**Actual outcome:** *(pending)*

---

## 2026-04-18 — Memory Tracking in Git

**Context:** Claude Code stores memory at `~/.claude/projects/.../memory/` — outside the workspace git. Files were not versioned, not portable, not auditable.

**Decision:** Move memory files into `/Workspace/.claude/projects/.../memory/`. Create symlink from `~/.claude/projects/.../memory` → workspace path. Memory is now git-tracked while Claude reads from the same path.

**Why:** Memory is context infrastructure — it should be versioned like code. Decisions, preferences, and user profile should survive machine resets. The symlink is transparent to Claude Code.

**Expected outcome:** Memory changes appear in git diffs. New machine: clone workspace, recreate symlink.

**Actual outcome:** *(pending)*

---

## 2026-04-18 — Harness Portability: settings.json Version Control

**Context:** `~/.claude/settings.json` held all hook configuration, permissions, and plugin settings but lived outside the workspace git. Not portable. A new machine would have skills and memory but no hooks — harness would be silently broken.

**Decision:** Move canonical `settings.json` into `/Workspace/.claude/settings.json`. Symlink `~/.claude/settings.json` → workspace path. `setup.sh` recreates this symlink. `settings.local.json` (Claude's runtime permission cache) is gitignored — it's ephemeral, not config.

**Why:** Every component of the harness must be recoverable from git alone. settings.json is load-bearing config; it belongs in version control. The symlink pattern is consistent with how skills and memory are handled — one source of truth, transparent to the runtime.

**Expected outcome:** `git clone + bash .claude/setup.sh` produces a fully working harness on any machine. settings.local.json noise stays out of git history.

**Actual outcome:** *(pending)*

---

## 2026-04-18 — Subproject Memory Inheritance: Known Limitation

**Context:** Claude Code keys memory by the directory from which it is launched. Opening Claude from `boringsystems/` creates a separate memory path (`-Users-ahmedomrane-Workspace-boringsystems/`) with no access to workspace-level memory (profile, collaboration preferences, strategic context).

**Decision:** Accept this limitation for now. Workspace-level context reaches subproject sessions via CLAUDE.md walk-up, which carries the structural facts (who Ahmed is, collaboration rules, git workflow). Memory's conversational layer (preferences, corrections) does not carry over. If subproject sessions repeatedly lack critical context, revisit with targeted subproject memory files or a shared memory symlink pattern.

**Why:** Symlinking all workspace memory into every subproject would inject workspace-scoping noise into focused sessions. The walk-up already carries the essentials. Over-inheriting context is a different failure mode than under-inheriting.

**Expected outcome:** Subproject sessions are functional with CLAUDE.md context. Edge cases where memory matters surface organically and get addressed per-project.

**Actual outcome:** *(pending)*

---

## 2026-04-20 — Full Stack Decision: boringsystems + personal-apps

**Context:** Two active hobby projects deploying on Vercel — boringsystems (Astro) and personal-apps/pollen-tracker (Next.js 16 / React 19 / Tailwind 4). Need database, analytics, auth, project management, and AI tooling choices locked in before implementation starts.

**Decision:** Adopted stack:

| Layer | Tool |
|---|---|
| Deployment | Vercel |
| Main site | Astro (boringsystems.app) |
| Portfolio app | Next.js 16 / React 19 / Tailwind 4 (portfolio.boringsystems.app) |
| Database | Neon — one instance per project |
| Auth | Clerk — only if personal-apps needs user accounts |
| Analytics | Mixpanel — both properties |
| Version control | GitHub |
| CI/CD | Vercel + GitHub (preview per PR, deploy gates) |
| Project management | Linear (boringsystems workspace) |
| AI coding | Claude Code (desktop + cloud) |
| Connectors | claude.ai OAuth — Linear, GitHub (account-bound, zero config) |

**Why Neon over Supabase:**
- Supabase Auth has a real migration problem: password hashes can't be exported via API, JWT secrets change on migration, users must re-login. This was a concern 3 years ago and is still valid.
- Neon is pure serverless Postgres — no auth/storage overhead, no lock-in beyond standard SQL.
- Neon's Vercel integration creates a copy-on-write database branch per preview deployment. Supabase's Vercel integration routes all preview deploys to the production database — a broken CI/CD story.
- If auth is ever needed, Clerk handles it independently with no database lock-in.

**Why not Supabase at all:** Could use it as a plain Postgres host (bypassing its auth), but Neon does that better with a cleaner Vercel integration and no unused surface area.

**Expected outcome:** Both projects have independent, portable Postgres databases. No vendor lock-in on auth. Preview deployments are isolated from production. Analytics centralized in Mixpanel.

**Actual outcome:** *(pending)*

---

## 2026-04-19 — MCP Connector Protocol: Built-in OAuth First, Never Manual API Keys

**Context:** Wasted a session setting up Linear MCP manually (.mcp.json + LINEAR_API_KEY env var) when Linear (and GitHub, Gmail) already have direct OAuth connectors through claude.ai. These connectors are account-bound: Anthropic holds the OAuth token server-side, so they work automatically in every session — local desktop, cloud web UI, phone — without any configuration on the machine or in the repo.

**Decision:** Non-negotiable protocol for any MCP integration going forward:
1. Check claude.ai Settings → Connectors first. If a direct connector exists, use it. Done.
2. Only proceed to manual MCP setup (.mcp.json, API keys, env vars) if no direct connector exists and the need is confirmed.
3. Never set up a manual MCP for: Linear, GitHub, Gmail, or any other service that has a direct claude.ai connector.

**Why:** Built-in connectors are: zero-config, account-scoped (survive machine changes and cloud sessions), OAuth-managed by Anthropic (no token rotation, no secrets in files), and work identically on desktop/web/mobile. Manual setups are none of these things. The manual route is a maintenance burden with no upside when a connector exists.

**Expected outcome:** No manual MCP setup ever conflicts with an existing connector. Time is not wasted on API key plumbing for services Anthropic already integrates.

**Actual outcome:** *(pending)*

---

## 2026-04-18 — Workspace Infrastructure: Hooks, Skills, Decision Registry

**Context:** Working from a configured-user baseline. No automated git enforcement, no skills, no auto-commit behavior, no decision tracking.

**Decision:** Build the full operator layer:
- Hook: block pushes to protected branches (main/master/dev/development/production)
- Hook: auto-commit at end of each task turn (Stop event)
- Hook: auto-update decision registry after configuration/architectural decisions
- Skills: commit, pr (personal), arch-review (workspace), new-post, content-research (boringsystems)
- Decision registry: `.claude/decisions/DECISIONS.md` — this file

**Why:** The gap between configured-user and orchestrator is automation. Rules written in CLAUDE.md are instructions. Rules written in hooks are enforcement. Skills encode recurring workflows so they don't need to be re-explained each session.

**Expected outcome:** Git discipline is machine-enforced. Sessions auto-commit. Recurring workflows invocable by slash command. Decisions tracked without manual intervention.

**Actual outcome:** *(pending)*

---

## 2026-04-20 — Add WORKSPACE_MAP.md routing index
**Context:** Token-expensive folder exploration every session. Only `llm-context-2026` had a routing map (Strategic Index). No single entry point describing top-level structure of the workspace.
**Decision:** Add hand-maintained `WORKSPACE_MAP.md` at workspace root — one-hop index pointing to each project's own routing entry (Strategic Index, AGENTS.md, ARDs) where one exists; references-only for projects without an index. Single-line pointer added to `CLAUDE.md` so it's discovered automatically. Explicitly NOT building a hook for updates — SessionStart/Stop can't reliably diff structural drift; maintenance is inline, same discipline as `/log-decision`.
**Why:** Routing index compresses the first-touch cost of a session. Auto-generation is fragile at the right abstraction level (project purpose, not file inventory). Keeping it hand-maintained and shallow (top-level only) prevents drift and overreach. Not forcing submodule maps respects the rule: don't overdo it.
**Expected outcome:** Future sessions route to the right project in one hop. Structural changes (project added/removed/renamed) update the map inline. No hook complexity to maintain.
**Actual outcome:** *(pending)*

---
