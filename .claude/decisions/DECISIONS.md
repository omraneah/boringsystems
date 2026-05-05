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

## Scope

**Workspace infrastructure decisions only.** This means choices about workspace setup, tooling, process architecture, and meta-level rules that apply across all projects.

Not for:
- Behavioral corrections → `memory/short-term/feedback/` (feedback memory files)
- Code/architecture decisions → project `docs/adr-*.md` (structured ADRs per project)

Historical entries predate this scope clarification and remain as-is. The discipline applies going forward.

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

## 2026-04-21 — Skills Architecture: Project-Scoped + Cross-Project Split

**Context:** Two active workflows create a skills-location tension. (1) Locally, Claude Code is launched from the workspace root (`~/Workspace/`) so Ahmed can move between projects in one session — skills under `~/.claude/skills/` (symlinked from `.claude/personal-skills/`) load globally. (2) Cloud agents (claude.ai platform) run against a single GitHub repo and only see that repo's checkout — they never see workspace-level skills. Putting boringsystems-specific skills (`article-capture`, `article-review`, `french-audit`) at workspace root meant the cloud agent couldn't use them; putting them only in boringsystems meant local workspace-root sessions couldn't use them. Skills were in the wrong place for at least one of the two workflows.

**Decision:** Adopt a two-layer skills architecture with no duplication and no sync script:

1. **Cross-project skills** live at `~/.claude/skills/` (via the `.claude/personal-skills/` symlink). These apply regardless of repo: `commit`, `pr`, `log-decision`, `arch-review`.
2. **Project-scoped skills** live at `<project>/.claude/skills/`. They travel with the repo and are only active when Claude Code is launched from inside that project. Cloud agents on that repo see them natively via the checkout.
3. **Governance docs stay in the project** (`<project>/docs/*.md`). Any agent with the repo checked out can read them with or without the skills — the skills are convenience wrappers around "read docs, then act."
4. **Workflow rule:** always launch Claude from the project you're working on. The workspace root launch is only for cross-project navigation, routing, and WORKSPACE_MAP-level work.
5. **Redundancy is rejected by default.** If a specific skill genuinely needs both scopes later, prefer hoisting it up rather than duplicating down. Duplication invites drift.

Applied immediately: moved `article-capture`, `article-review`, `french-audit` from `.claude/personal-skills/` to `boringsystems/.claude/skills/`.

**Why:** Skill discovery in Claude Code is based on launch directory, not file-touch heuristics. There is no inheritance across nested `.claude/skills/` folders. The only ways to make a skill available in two scopes are (a) duplicate the files and sync them, or (b) accept that workflow discipline chooses the scope. Option (a) has drift risk for no real upside. Option (b) aligns with the tool's design — Claude Code is meant to be launched per-project — and puts cloud-agent viability on equal footing with local work. The governance docs at `<project>/docs/` give agents a reliable fallback even if skills aren't loaded: "read this file, then do X" is a valid substitute for "invoke /X."

**Expected outcome:** Cloud agents working on a single repo have full capability from the checkout alone (skills + docs both present, no external dependencies). Local workspace-root sessions stay lean — no noise from skills that don't apply to the current task. Project-specific skills are version-controlled with the code they govern and visible in the project PR when they change. Drift between "global" and "project" copies becomes structurally impossible because there is only one copy.

**Actual outcome:** *(pending)*

---

## 2026-04-20 — Add WORKSPACE_MAP.md routing index
**Context:** Token-expensive folder exploration every session. Only `memory` had a routing map (Strategic Index). No single entry point describing top-level structure of the workspace.
**Decision:** Add hand-maintained `WORKSPACE_MAP.md` at workspace root — one-hop index pointing to each project's own routing entry (Strategic Index, AGENTS.md, ARDs) where one exists; references-only for projects without an index. Single-line pointer added to `CLAUDE.md` so it's discovered automatically. Explicitly NOT building a hook for updates — SessionStart/Stop can't reliably diff structural drift; maintenance is inline, same discipline as `/log-decision`.
**Why:** Routing index compresses the first-touch cost of a session. Auto-generation is fragile at the right abstraction level (project purpose, not file inventory). Keeping it hand-maintained and shallow (top-level only) prevents drift and overreach. Not forcing submodule maps respects the rule: don't overdo it.
**Expected outcome:** Future sessions route to the right project in one hop. Structural changes (project added/removed/renamed) update the map inline. No hook complexity to maintain.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Strict `/en` + `/fr` i18n on boringsystems, no implicit default

**Context:** Site had `/fr/*` but no `/en/*`; English was the unprefixed default. Asymmetric structure made "proper two languages from the start" impossible and forced language detection into Nav logic.
**Decision:** Move every EN page under `src/pages/en/*`. Rename content collections to `case-files-en` + `operating-playbooks-en` (`-fr` counterparts already existed). Add `astro.config.mjs` redirects so `/`, `/case-files/*`, `/engineering`, `/entrepreneurs`, `/essays`, `/operating-playbooks/*`, and `/about` 301 to their `/en/*` equivalents. Rewrite `Nav.astro` so prefix logic works symmetrically for both locales.
**Why:** Two languages that are structurally equal is the only stable shape for a bilingual site. Any "default" locale forces the nav toggle to asymmetric logic and breaks when a third locale ever lands. The 301 layer protects every existing backlink.
**Expected outcome:** Adding a third locale (or rotating the default) becomes a mirror operation, not a refactor. FR and EN pages develop at the same rate because they share a shape.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Mandatory `date` frontmatter + meta strip on case files

**Context:** Articles had no persistent publish date — read time was derived per page, but dates were ad-hoc. The design charter called for a metadata strip at the top of every piece.
**Decision:** Add `date: YYYY-MM-DD` as a required field in the `case-files` schema (both `-en` and `-fr`). Seed all existing articles from `git log --follow --diff-filter=A --format=%aI | tail -1` (first-merge date). Extend `src/lib/article-meta.ts` with `readTime()` + `formatDate()` + `articleMeta()`. Render the meta strip (`Feb 22, 2026 · 5 min read`) on every card and under every article subtitle. Update `article-review` skill to block if `date` is missing.
**Why:** Date is a permanent property of the piece, not a runtime concern — it belongs in frontmatter where the schema enforces it. Rendering it consistently on card and article page cements the design-charter intent ("metadata strip at the top") without per-page code.
**Expected outcome:** Every future case file gets both pieces of meta rendered automatically. Readers get signal about recency and length before clicking.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Typed content registry pattern for reusable UI assets

**Context:** Lead magnets will multiply over time (starter prompts, prompt packs, templates, cohort offers). Each needs title/description/confirmation email content in EN + FR. Inlining any of this per-article creates a drift farm.
**Decision:** Establish the "typed content registry" pattern on boringsystems. The canonical example is `src/lib/lead-magnets.ts`: a `Record<slug, Asset>` where each asset has locale-indexed fields (`title`, `description`, `buttonLabel`, `prompt`, `confirmation`), accessed via a single `getEntry(slug)` helper that throws on unknown slugs. The reusable `<LeadMagnet />` component + `/api/lead-magnet` route both resolve through the registry. Adding a new asset = one registry entry; no component, route, or mail code changes.
**Why:** This shape matches how Ahmed thinks about reusable artefacts — abstract where reuse is likely, keep the abstraction surgical, single file, explicit types. It also sidesteps the next-gen temptation (a generic `<ContentRegistry />` with reflection) — one short typed file is more legible than any metaframework we could build over it.
**Expected outcome:** The next reusable UI artefact that needs locale content (testimonials, CTAs, stack cards, pricing tiers) follows this shape without an argument. Drift between locales becomes visible at the type level, not at render time.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Mermaid via inline remark plugin + client-side render (reject playwright)

**Context:** Article B needed a rendered architecture diagram. `rehype-mermaid` is the obvious pick, but its non-`pre-mermaid` strategies depend on `mermaid-isomorphic` which pulls in `playwright` at module scope — which broke `astro build` even with `strategy: 'pre-mermaid'` selected. Installing playwright + chromium into the build chain adds ~150MB and a chromium browser dependency in every CI environment.
**Decision:** Drop `rehype-mermaid`. Write a ~12-line inline remark plugin in `astro.config.mjs` that rewrites `mermaid` code fences into raw `<pre class="mermaid">` HTML nodes before Shiki can touch them. Load mermaid.js client-side in `Article.astro`, running only when `pre.mermaid` blocks are present. Zero build-time browser dependency.
**Why:** The playwright dependency on a mostly-static content site is an asymmetric cost for the feature's value. Client-side render with a progressive-enhancement loading placeholder is indistinguishable in UX from SSR for the reader, and it keeps the build chain portable.
**Expected outcome:** Mermaid diagrams work on Vercel build without special setup. Future mermaid blocks in any `.md` or `.mdx` article render automatically with zoom + pan. If SSR mermaid ever becomes necessary (heavy static-export cases), revisit with the lighter `@mermaid-js/mermaid-cli` or server-side headless chromium at that time.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Vector-clean mermaid zoom via SVG width/height, not CSS transform

**Context:** First zoom implementation used `transform: scale()` on the stage. The browser rasterised the SVG at its natural size first and upscaled the bitmap, producing visible pixelation at anything above 1.5×. Flex-centering on the stage also silently shrank the SVG back to fit the container, so zoom buttons had no visible effect at all.
**Decision:** Capture the SVG's viewBox aspect on init, compute a base display size that fits the viewport at scale=1, then scale via `svg.style.width/height` (in pixels, driven by `base × scale`). Absolutely-position the stage (no flex), center via `transform: translate(-50%, -50%)`, and append pan offsets to that transform. ResizeObserver recomputes the base on viewport changes.
**Why:** SVGs are vector — browsers re-render them at the requested width/height. Scaling the intrinsic size bypasses the rasterise-then-scale path of CSS transforms entirely. Dropping flex-centering was necessary because flex shrinks children below the container on overflow.
**Expected outcome:** Diagrams stay sharp at any zoom from 0.3× to 6×, pan cost stays cheap (CSS translate is compositor-only), and the pattern applies to any future zoomable SVG without modification.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Home highlights as an ordered vertical stack (no carousel)

**Context:** Home page had a two-slot rotating carousel (one case-file + one playbook). Ahmed wanted all three featured articles visible at once without requiring interaction, and wanted the "Selected Articles" grid constrained to the engineering lane (plus one explicitly pinned playbook).
**Decision:** Replace the carousel with a vertical stack of three large highlight cards, sorted by the `order` flag, capped via `slice(0, 3)`. "Selected Articles" section (renamed from "Selected Case Files") now sources from technical-persona `featured` case files plus `getEntry('operating-playbooks-*', 's3-p2-context-is-the-edge')` — the playbook is pinned by explicit slug so rotation is a one-line edit, not a flag toggle. "All case files" link removed. Carousel JS + CSS + dots deleted.
**Why:** The carousel hid two of three entries behind interaction. A stack matches the "dense, no decorative motion" side of the design charter and maximises scroll as the primary navigation signal. Pinning the playbook by slug (instead of a flag) keeps one playbook visible on home without giving every `featured` playbook a home slot it shouldn't have.
**Expected outcome:** Readers see the three highlighted articles immediately. Ahmed can rotate which playbook sits alongside the engineering pieces by changing a single line. Adding a 4th highlight requires removing one — the `slice(0,3)` is deliberate, not a bug.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Create `/wrap-session` skill + auto-trigger behaviour

**Context:** Every merge-pull-delete cycle this session ended with Claude doing the git mechanics on demand but missing the post-merge reflection (what compounded, what should become a skill, what needs an ADR). The lessons evaporated across session boundaries.
**Decision:** Create cross-project skill `/wrap-session` in `personal-skills/wrap-session/` that runs git cleanup + produces a structured recap with improvement proposals (skills / hooks / ADRs / docs / memory / decisions). Save a feedback memory (`feedback_wrap_session.md`) so Claude auto-invokes it on natural-language triggers ("merged, pull and delete", "wrap this up", etc.) without requiring the slash command. The skill explicitly does NOT use a shell hook — hooks run deterministic commands, the recap needs Claude's reasoning.
**Why:** System improvement is itself a capability. Without a codified closing ritual, every session's lessons live or die by the next prompt. With one, the compound interest of skill and doc investment accumulates.
**Expected outcome:** Every future merge produces a recap that either (a) identifies durable patterns to codify or (b) honestly reports "nothing new, session was small" — both outcomes are information. The registry of skills and decisions grows at the rate of actual leverage, not activity.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — CLAUDE.md split: lean top-level + docs/ for detail

**Context:** Workspace CLAUDE.md was 170 lines — approaching the documented 200-line soft cap and over the community-recommended ~100-line sweet spot. Every line costs context that competes with actual work; community research (DEV Community, obviousworks.ch, Anthropic docs) is consistent: keep it short or lose attention.
**Decision:** Reduce workspace CLAUDE.md to ~65 lines containing only (a) the laptop-agnostic constraint, (b) who Ahmed is, (c) workspace structure table, (d) non-negotiable rules, (e) pointer table to `docs/*.md`. Move collaboration style, git workflow detail, infrastructure tables, and MCP protocol to `docs/collaboration.md`, `docs/git-workflow.md`, `docs/infrastructure.md`. Same pattern to apply at project level (`boringsystems/CLAUDE.md` + `boringsystems/docs/`).
**Why:** Community research says Claude attends ~150 instructions reliably; system prompts + tool schemas already consume 30-40k tokens before user input. CLAUDE.md bloat directly trades against usable context. The pointer structure gives Claude a deterministic "read `docs/X.md` if topic is X" routing instead of forcing everything into a single file read.
**Expected outcome:** Context window stays leaner, attention stays sharper on the rules that matter, detail remains a one-file-read away when relevant. Each new project's CLAUDE.md follows the same shape.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Codify pattern-capture lag as a named discipline: twice-is-a-pattern

**Context:** Every improvement this week landed 2-3 PRs after the pattern appeared. `/wrap-session` was run manually 3× before becoming a skill. `/verify-home` came after 4× manual HTML greps. The insight was always there; codification was always late. This is pattern-codification lag — the systemic friction that prevents the system from compounding.
**Decision:** Create the "twice-is-a-pattern" rule: when the same manual task happens twice in a session, stop before the third time and propose codification (skill, hook, doc, memory, or ADR — one of five). Encoded as: (a) memory entry `feedback_twice_is_a_pattern.md`, (b) one-line rule in CLAUDE.md, (c) trigger in `/session-pulse` skill which fires mid-session on pattern detection. `/session-pulse` is the mid-session mirror of `/wrap-session` — meta-cognition during the work, not only after.
**Why:** Hook-level automation can't detect patterns — only Claude can. Skill-level meta-cognition can. The rule's power is in naming it: once Claude knows "pattern repetition = codify before third time", the reaction becomes automatic even when no skill is invoked.
**Expected outcome:** Codification latency drops from 2-3 PRs to 0-1 PRs. The skill registry grows at the rate of real pattern discovery. The compound interest of the system starts accumulating meaningfully.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Stop hook: background type-check on every feature-branch turn

**Context:** Claude can ship code that compiles locally but has type errors, or breaks the Astro build, or fails `tsc --noEmit`. Auto-commit fires on Stop regardless. Errors surface late — usually at the next `npx astro build` or on a CI failure.
**Decision:** Add a Stop hook `post-edit-typecheck.sh` that runs after auto-commit, detects the right check command (`astro check`, `tsc --noEmit`) based on `package.json`, runs it async, writes failures to `/tmp/claude-typecheck-<repo>.summary`. The existing `session-start.sh` hook is extended to surface that summary at the next session start.
**Why:** Hooks enforce; CLAUDE.md advises. Type errors are the exact kind of thing that should fail loudly and deterministically, not be discovered mid-conversation in the next session. Async means no added latency on the visible response path.
**Expected outcome:** Type errors introduced in session N are surfaced at the start of session N+1 (or caught by the user before then). No silent type-error accumulation between sessions.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — /session-pulse: mid-session meta-cognition skill

**Context:** The `/wrap-session` skill does post-merge reflection. But reflection at session end is too late for patterns that should be codified mid-session (to benefit the rest of the same session). Pattern-codification lag could be 0-hours instead of 2-3 PRs if meta-cognition happens during the work.
**Decision:** Create `/session-pulse` as the mid-session mirror of `/wrap-session`. Auto-triggers on: (a) pattern repetition, (b) user correction repetition, (c) scope drift past 3 concerns, (d) framework-feature reinvention, (e) decisions made without logging. Produces a terse structured report naming patterns, reinvention flags, scope verdict, and one "codify now" recommendation. User-invocable for manual check-ins.
**Why:** The meta-cognition skill closes the loop between pattern recognition and pattern codification within the same session. Combined with the "twice-is-a-pattern" memory rule, Claude now has both the trigger and the named discipline.
**Expected outcome:** Patterns caught and codified mid-session rather than three PRs later. Session scope policed actively. Fewer "we should have named this pattern earlier" moments in `/wrap-session` recaps.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Adopt Astro's native i18n; replace manual routing

**Context:** Previous session built `/en` + `/fr` structure manually — hand-written redirects in `astro.config.mjs`, hardcoded locale prefixes in every page, custom Nav logic. Astro 5 has a built-in `i18n` config block (`defaultLocale`, `locales`, `routing.prefixDefaultLocale`) that does exactly this natively, plus exports `getRelativeLocaleUrl`/`getAbsoluteLocaleUrl` helpers. The manual version was ~80% of what Astro does for free.
**Decision:** Enable Astro's native i18n: `defaultLocale: 'en'`, `locales: ['en', 'fr']`, `routing: { prefixDefaultLocale: true }`. Retain the `redirects` map for legacy flat URLs (`/about` → `/en/about`, etc.) and root redirect (`/` → `/en/`, 301) because `redirectToDefaultLocale: true` requires a root `index.astro` and emits a meta-refresh fallback on static builds. Refactor `Nav.astro` to use `getRelativeLocaleUrl` instead of hardcoded strings. Extract a small `src/lib/i18n.ts` helper for the essays/essais slug alias table and hreflang URL generation — Astro's native `getRelativeLocaleUrl` does not know about per-locale slug aliases.
**Why:** Platform-native features age with the platform. Custom implementations do not. Future Astro releases will improve native i18n; our code will inherit the improvements. Also unlocks proper hreflang support (see next entry) and cleaner call sites.
**Expected outcome:** Astro upgrades carry forward cleanly. Any third locale is a one-line addition. `getRelativeLocaleUrl` used consistently, not reinvented.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — hreflang tags on every page + sitemap i18n metadata

**Context:** Prior to this change, no page on boringsystems emitted `<link rel="alternate" hreflang=…>` tags. Both the Astro i18n docs and the general SEO guidance consider these mandatory for bilingual sites — without them, Google cannot disambiguate which language version to serve to which searcher, and EN/FR pages compete against each other for the same queries.
**Decision:** Add `hreflangsForPath()` to `src/lib/i18n.ts` — returns `[{hreflang: 'en-US', href}, {hreflang: 'fr-FR', href}, {hreflang: 'x-default', href}]` for any `/en/*` or `/fr/*` path, respecting the essays/essais slug alias. Wire into `Base.astro` and `Article.astro` head blocks. Also pass i18n locale config to `@astrojs/sitemap` so the generated sitemap includes per-page alternate links. `/verify-home` skill updated to assert hreflang presence as a build-time smoke check.
**Why:** SEO payoff is immediate and durable — correct hreflang prevents keyword cannibalization and routes users to the right-language page. Wiring via a single helper + layout makes it impossible to ship a new page without hreflang going forward.
**Expected outcome:** Search engines serve `/en/…` to English queries and `/fr/…` to French queries without confusion. No SEO regression from the bilingual split. Adding a third locale requires only updating `LOCALES` in `src/lib/i18n.ts`.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — boringsystems CLAUDE.md split + docs/constraints.md

**Context:** Project-level CLAUDE.md was empty (`0 lines`). All project rules lived implicitly — in conversation, in the session memories, in the workspace-level CLAUDE.md. Constraints like "no build-time browser deps" and "no CSS transform for vector zoom" had been discovered through failure, logged in DECISIONS.md, but not surfaced anywhere Claude would reliably see them at session start.
**Decision:** Create a lean `boringsystems/CLAUDE.md` (~40 lines) with only the non-negotiable rules + a pointer table to `docs/*.md`. Create `boringsystems/docs/constraints.md` — the "never do X" list with the reasoning behind each constraint. Create `/check-constraints` skill which loads `docs/constraints.md` and vets any planned structural change against it before execution. Workspace-level memory `feedback_platform_features_first.md` makes the cross-project principle explicit: always check framework-native support before custom implementation.
**Why:** Constraints discovered through failure are expensive — each rediscovery is another iteration, another PR, another review cycle. Codifying them in a short doc that Claude reads automatically (at session start via CLAUDE.md pointer, and explicitly via `/check-constraints` before structural work) converts discovered friction into upfront discipline.
**Expected outcome:** Future sessions do not rediscover already-known constraints. New constraints discovered in a session land in `docs/constraints.md` immediately, not after two more failures. `/check-constraints` becomes the reflex for any structural change.
**Actual outcome:** *(pending)*

---

## 2026-04-21 — Enforcement tiered below CI for solo/pre-revenue repos
**Context:** Cross-stack ARD `quality-security-boundaries.md` demands "CI is the only authority." boringsystems is solo, pre-revenue, on the free GitHub plan. Literal compliance requires paid Actions minutes that aren't justified today.
**Decision:** Honor the ARD *principle* ("enforcement is systemic, not human") at a local-first tier. Pre-commit hook (`astro check` + structural verify + `astro build`) + pre-push hook (`npm audit --audit-level=high`) in boringsystems. Workspace-level pre-push at `.claude/git-hooks/pre-push` iterates npm submodules for pointer bumps. No GitHub Actions. Codified in `docs/patterns/local-first-enforcement.md` + `docs/ard-tier-map.md`. Anchored per-project by `boringsystems/docs/adr-003-enforcement-tier.md` with named upgrade trigger.
**Why:** Keeps every line of code and every dependency a deliberate liability (ARD §5 simplicity clause). Gates catch what author memory won't. Upgrade trigger (first paid subscriber, public repo, second committer, prod state layer) is named, so the exemption isn't silent — it's a tier with an exit condition.
**Expected outcome:** Type safety + structural integrity + dependency safety enforced at the commit/push boundary. Zero reliance on "remembering to run X." When a trigger fires, a superseding ADR lifts the tier to T2 with an Actions workflow running the same commands the hooks run.
**Actual outcome:** *(pending)*

---

## 2026-04-23 — Lane indexes sort by date; `order` scoped to Highlights

**Context:** boringsystems lane index pages (`/writing`, `/work`, `/building`) sorted by the `order` frontmatter field — an editorial curation knob — inherited from when the `featured` + `highlight` + `order` flags were introduced for home-page selection (ADR-002). When BOR-7 shipped ("Why AI Agents Need Disposable Databases"), the newest piece buried behind older articles with lower `order` values. Publishing should auto-promote the newest article to the top of its lane without the author remembering to set `order`.

**Decision:** Lane indexes sort by `date` descending (newest first). `order` is now scoped to the home *Highlights* band only — editorial curation of what sits in the three home slots. `featured` remains dormant (was tied to the now-removed Selected Articles band; will re-activate if that band is ever reintroduced). Archive is unchanged — groups by `series` with `seriesNum` desc + `playbook` asc within series. ADR-002 amended on the same commit (773a35c in boringsystems PR #25).

**Why:** Publishing semantics should be automatic. The author's only structural decision when shipping a new article is the file's lane (folder placement); freshness ordering within the lane is a property of the date, not an editorial choice. Keeping `order` alive but scoping it to Highlights preserves the curation lever where it's needed (home page) without letting it silently bury new content on lane indexes.

**Expected outcome:** Every new article surfaces first on its lane index automatically. No author action required beyond correct frontmatter `date`. Home Highlights stays curated — Ahmed flips `highlight: true` + low `order` on the three pieces worth promoting, independent of what each lane is currently leading with.

**Actual outcome:** *(pending)*

---

## 2026-04-24 — Persona subagents architecture (Naomi / Daniel / Hadi)

**Context:** Ahmed wanted multiple specialized "expert chat rooms" — GTM strategist, principal engineer, career coach — to navigate distinct dimensions of his current professional transition. The existing `gtm-discussion` skill demonstrated the pattern but was the wrong primitive: skills load context once into the main thread, then the model drifts back to default behavior over a multi-turn conversation. Research (Anthropic docs + community practice including the SuperClaude Framework) confirmed subagents are the right primitive for sustained role-play because each subagent's system prompt is active on every turn.

**Decision:** Create three subagents at `.claude/agents/`: `gtm-strategist` (Naomi Renard), `principal-engineer` (Daniel Kovac), `career-coach` (Hadi Bensoussan). Each has a named archetypal persona with backstory, voice, operating constraints, what-they're-for / what-they're-not-for boundaries, and an `@imports` block preloading the substrate context (GTM folder + strategic advisor for Naomi; cross-stack ARDs + workspace CLAUDE.md for Daniel; inner-game docs + strategic advisor for Hadi). All three: Opus 4.7, full repo tools (Read/Edit/Write/Bash/Grep/Glob/WebSearch/WebFetch), TLDR output style, forward-focused, hand off rather than overreach. Deleted the now-redundant `gtm-discussion` skill. Added `.claude/agents/README.md` documenting invocation, iteration protocol, and a load-bearing calibration disclaimer that the personas are first drafts — Ahmed has not vetted the reference figures (April Dunford, Gary Vee, Camille Fournier, Charity Majors, Jung) and should rewrite voices that don't serve him after real use.

**Why:** Subagents enforce role across multi-turn conversations (system prompt active every turn) where skills drift. Named archetypal personas (vs unnamed advisors) give the model a consistent voice to inhabit, deeper than abstract role definitions. Archetypal-and-named (not real-person impersonation) avoids brittle mimicry while still anchoring depth. Each persona's "what they're NOT for" plus the trio's complementary scopes (positioning / engineering / inner-game) covers the three dimensions Ahmed is navigating without overlap. Preloading substrate via `@imports` means the persona inhabits the material at session start instead of having to discover it. Calibration disclaimer prevents the personas from being treated as fixed — they are first drafts, iterable as Ahmed learns what voice actually works for him.

**Expected outcome:** Ahmed can run focused multi-turn sessions in any of three persona modes (`claude --agent <name>`) without role drift. Each persona consults the right substrate without being told. Voices stay coherent across long conversations. After 2-3 real sessions per persona, Ahmed iterates the agent files where voices land off — the README documents the protocol so iteration doesn't require rebuilding from scratch. The pattern scales to additional personas (real-estate agent, others) by following the same structure.

**Actual outcome:** *(pending)*

---

## 2026-04-25 — Adopt two-tier agent architecture (operational + strategic advisors)

**Context:** Ahmed asked the three operational subagents (Naomi/Daniel/Hadi from the 2026-04-24 decision) to weigh in on a content-vs-relational GTM question. All three independently returned the same verdict — "stay course on relational." Convergence felt clean; Ahmed identified it as a structural failure mode rather than a useful signal. Each agent had loaded the GTM doctrine, the Re-Entry Doctrine, and the leverage profile via `@imports`, then concluded what those documents already prescribed. Operational agents amplify the existing direction by design — they cannot challenge the frame because the frame is their substrate. The decision being weighed was uncommitted; it deserved adversarial pressure, not faithful execution.

**Decision:** Split agents into two tiers with distinct rules and cadences. **Operational tier** (Naomi `gtm-strategist`, Daniel `principal-engineer`, Hadi `career-coach`, Margaret `release-companion`) reads context files and executes inside the frame; invoked frequently for tactical work. **Strategic tier** (`advisor-1` Branson, `advisor-2` Munger, `advisor-3` Singer, `advisor-4` Naval, `advisor-5` Greene, `advisor-6` Godin) refuses to read `memory/`, `go-to-market/`, or any plan/identity/strategy file; refuses to ask Ahmed for his plan; responds from lens to what is said in the moment; operates from Hawkins 200+ register. Six real named figures, all entrepreneurs/builders, selected by Ahmed for personal resonance and lens-diversity. Invocation modes: solo (one lens for one question) or `/convene-board` skill for parallel synthesis on frame-level decisions. Full rationale in `docs/adr-001-two-tier-agents.md`.

**Why:** Context-loaded agents amplify direction; they cannot challenge it. A separate tier with hard refusal of context-reading is the only durable enforcement of frame-challenging behavior — soft instructions drift. Real named figures (vs invented archetypes) give the model a coherent worldview to simulate, producing voice-stable output. Six (not five) was Ahmed's lock after Greene and Godin were both deemed essential and non-overlapping; beyond six, parallel synthesis becomes harder to scan. Hard refusal of context-reading is the load-bearing wall — every other guardrail erodes without it. Alternatives considered and rejected (in ADR-001): adding adversarial behavior to existing operational agents (incoherence), single challenger agent (no lens-diversity), anonymous archetypes (generic mush), partial context-reading (slope erodes), status quo (the failure mode that triggered this).

**Expected outcome:** Frame-level decisions get adversarial pressure rather than faithful amplification. The board's parallel use surfaces disagreement-across-lenses, which is the highest-leverage signal in strategic decisions — convergence-only systems miss it. The two-tier split is portable: new operational agents (real-estate, hiring, fundraising) can be added without disturbing the strategic tier. The `/convene-board` skill formalizes parallel invocation, preventing friction-based underuse. First real test: convening on the content-vs-relational question that triggered the architecture, comparing the board's verdict against the operational tier's "stay course."

**Actual outcome:** *(pending)*

---

## 2026-04-25 — Engagement-shapes page as exposed-not-broadcast permission artifact

**Context:** Across a four-round strategic-board session (six advisors × four briefs = 24 advisor calls), 5/6 converged on building a single page on boringsystems naming Ahmed's four engagement shapes — fractional CTO/CPO/tech-product builder, complex project lead, founder/builder sprint, AI-agent training. The board was specific about *what shape the page must take*: declarative, in the harness-piece voice, no prices, no CTA button, no testimonials, no logos, no SEO meta, no "I help X do Y" language, no booking calendar. The page is a filter, not persuasion — *"wrong people bounce, right people point at a door"* (Godin). The Singer dissent (refused the page entirely as "more document, the loud mind preparing for conversations that haven't happened") was held alongside as the floor.

After the page was drafted, Ahmed surfaced a peer reference — Rémi Alvado (`remi.alva.do/prestation/*`, in market for ~6 months with a stabilizing French niche). His pages: one URL per shape, French-only, formal "vous", credibility anchored by named past companies (WIZBII / Kelkoo / BestOfMedia), per-page methodology breakdowns by phase, subtle 30-min-call CTA, occasional fictional case studies, BPI funding co-pay angle for PME. Different positioning surface entirely — Alvado's pages are optimized for *cold inbound* (a stranger lands and evaluates in 60 seconds); Ahmed's page is optimized for *warm conversation* (sent only when someone in conversation asks "how do we work together?").

**Decision:** Ship `/en/work-with-me` and `/fr/work-with-me` (EN + FR re-voiced per `boringsystems/docs/french-guide.md`). One page, four shapes inline. Each shape: *what it is · when it fits · when it doesn't · first two weeks · cadence*. The "when it doesn't" line was added after the Alvado comparison (sharpens the filter — Godin's exact criterion; Alvado's "what I don't do" section in Sprint Fondateur validated the pattern). No prices, no CTA button, no testimonials, no SEO. Page **not** in main nav. Linked from About (next to LinkedIn, end of page) and from the home contact section. Sent in conversation, not broadcast. Versioned with an `Updated YYYY-MM-DD` date in the footer for honest staleness signal.

**Why:** Ahmed's positioning is deliberately not Alvado's. Alvado has a stabilized French SME / fractional-CTO niche and his pages are designed to convert cold strangers — that's a different motion with a different cost curve (SEO maintenance, per-page upkeep, calendar/inbox load). Ahmed is in a 30-month exploration window where the binding constraint is *which shape pulls*, not *how many strangers land per week*. The exposed-not-broadcast page fits the constraint: it gives warm referrers something to forward, lets the four shapes be observable to people already in conversation, and doesn't open a cold-inbound surface that would force premature collapse of the four. The board's unanimous "the work is already happening — don't interrupt it" frame says the page should be the smallest possible artifact that adds legibility, not the largest possible artifact that adds reach. One page beats five. Inline shapes beat per-shape URLs. Versioning beats freshness theater.

**Expected outcome:** When someone Ahmed has already been talking to asks "how can we work together?" the page exists and answers cleanly. Warm referrers have a single URL to forward. The four shapes stay observable side-by-side, which preserves Naval's "let one die by day 45 by weight of evidence, not decision" — visible co-presence makes the relative pull-data legible. The "when it doesn't" lines disqualify the wrong fit before the conversation, which is bandwidth saved on both sides. By June 15 (post-disconnect), one of the four shapes will have produced more inbound resonance than the others; the page allows that signal to surface without forcing premature commitment to which.

**Actual outcome:** *(pending — first signal review scheduled mentally for ~2026-06-15; tracked in `memory/project_engagement_shapes_signal_check.md`)*

---

## 2026-04-25 — Parallel-by-default for non-conflicting tasks

**Context:** Across the 2026-04-25 strategic-board session, Ahmed repeatedly observed that multi-task instructions were being executed serially when most of the tasks had zero conflict surface. The wrap-session round in particular ("merge cleanup + Linear card + Singer subagent + workspace PR bump + encoding the rule itself") was four-to-five independent reasoning streams that should have fired concurrently. Ahmed surfaced this as a class of mistake worth codifying: he should not have to ask for parallelization on every multi-task prompt; the default should be to parallelize independent work and run sequential only when there's a real dependency.

**Decision:** Adopt parallel-by-default as the standard execution shape for any user prompt containing 2+ distinct tasks. Three layers of enforcement:

1. **Memory** — `memory/feedback_parallel_by_default.md` is the operational rule. Loaded at session start via `MEMORY.md`. Defines the classification (independent / sequential-dependency / conflicting), the parallelization mechanics (multiple tool_use blocks in a single message, subagents as the unit of parallel cognition), and the worktree exception (conflict-only, explicit-only).

2. **Decision (this entry)** — captures the rationale and the trigger event for posterity.

3. **Hook** — `.claude/hooks/parallel-by-default-reminder.sh` (UserPromptSubmit, registered in `.claude/settings.json`). Heuristic-based: detects multi-task signals in the prompt (numbered lists, "and then", "also", "in parallel", "paralyze/parallelize", "simultaneously") and injects a one-line reminder when threshold is met. Quiet on single-task prompts to avoid noise.

**Why:** Operator-time is the binding constraint, not compute. Wall-clock latency from serial execution of independent tasks is the most common avoidable waste in long sessions. Worktrees were the previous structural answer for parallelism but they're overkill for the common case (no shared-file conflict) — same-tree parallel via concurrent tool calls and concurrent subagents is enough for ~95% of multi-task prompts. Worktrees stay reserved for the explicit-conflict case Ahmed names directly.

**Expected outcome:** When Ahmed gives a multi-task prompt, the agent identifies independent tasks (no shared file, no shared state, no dependency) and fires them in a single message — multiple Bash calls + multiple Agent calls + multiple Write calls concurrently. Sequential dependencies (e.g. submodule pointer bump needs the post-merge SHA) run after their predecessor. Conflicting writes run serially in the main thread. The hook nudges when the prompt has multi-task signals, providing a safety net for the rule. Net: less wall-clock waiting, no new conflicts.

**Actual outcome:** *(pending — first observable test on the next multi-task prompt after this commit)*

---

## 2026-04-26 — Model × Effort × Lane matrix codified

**Context:** Ahmed had been running every Claude Code session at Opus 4.7 / effort=high under the (mistaken) assumption that high effort is faster. In reality, higher effort is slower and longer-form, biasing toward distilled output and away from exchange cadence — which actively fights the workflow he uses for ~70% of his work (psychology, positioning, GTM, advisor convening, market thinking). On a Pro 5x plan with significant unused headroom, the underlying question was: what model + effort suits which kind of work, and how do we make the choice visible rather than hidden behind a single global setting?

**Decision:** Adopt a Model × Effort × Lane matrix as the workspace's operating framework for choosing Claude model + effort. Three independent axes shape the choice: (1) task dimension — psychology / positioning / advisors / code / ops / research; (2) cadence — exchange (back-and-forth) vs distilled (long output); (3) complexity — file writes vs deep reasoning vs novel architecture. Workspace default: Opus 4.7 / effort=high (matches the dominant exchange-heavy workload). Per-lane overrides documented in `memory/feedback_model_effort_matrix.md`. Strategic-tier advisors (advisor-1..6) get `effort: xhigh` via frontmatter — each lens fires in parallel under `/convene-board` with no internal exchange, so depth + distillation matter and exchange cadence does not. Operational agents calibrated per lane: principal-engineer `xhigh` (heavy infra), gtm-strategist + career-coach `high` (positioning/psychology with exchange cadence), release-companion `medium` (release work refuses cognitive reframing — less output, more presence).

Two new behavioral norms encoded as CLAUDE.md non-negotiables:

1. **Lane-change announcement** (`memory/feedback_lane_change_announcement.md`) — when task dimension/cadence shifts mid-session, post a fixed-format block: old lane → new lane, current setup, recommendation, why. Don't hide the choice. Wait for Ahmed's signal on non-trivial bumps; proceed silently for trivial inheritance.

2. **Parallel-agent recap** (`memory/feedback_parallel_agent_recap.md`) — when spawning parallel sub-agents, post model/effort/why per agent as the FIRST summary before any output is read. Sub-agent settings are otherwise invisible; the recap makes audit possible and gives Ahmed a chance to redirect mid-flight.

**Why:** Effort and response length are independent levers but correlate misleadingly. The matrix surfaces the calibration explicitly so the workspace stays auditable as new models / new effort levels ship (xhigh was added in 4.7; assume more variation will come). Per-agent frontmatter pins the right setup so it's reproducible across machines and visible in git — laptop-agnostic in spirit, not just in environment. The two behavioral norms address the failure modes that motivated this work: cognitive load when responses are miscalibrated to the cadence Ahmed is operating in, and quota waste from running max on file moves.

**Expected outcome:** Sessions feel cadence-correct out of the box. Ahmed sees the model/effort choice when it matters (lane shifts, parallel fanout) and never has to reverse-engineer why a sub-agent produced what it produced. The matrix becomes a living artifact — revisited when new effort levels release, when a recurring task type doesn't fit any existing row, or when the effort↔length correlation changes upstream. Skills frontmatter audit deferred to a follow-up session (BOR-24) to keep this PR within the three-concern rule.

**Actual outcome:** *(pending — first observable test on the next strategic-exchange and next /convene-board session after this commit)*

---

## 2026-04-26 — Disable vercel-plugin + codify cognitive-load rules

**Context:** Wrap-session pass surfaced two compounding noise problems: (a) the `vercel-plugin@vercel` Claude Code plugin was loading ~30 skills on every session and pattern-matching on Bash command substrings (false-positive on `pgrep -fa "next dev"` injecting a "MANDATORY" block during a git wrap-session); (b) Claude was recapping PR/Linear/ADR content in chat after providing the link, duplicating cognitive load when Ahmed could just read the source. Same session: Claude over-fanned three Linear cards when one container card (BOR-23-style) was the right shape.

**Decision:** Three corrections, single PR.

1. **Disable vercel-plugin**, codify rationale in `docs/adr-002-vercel-auto-deploy-only.md`. Vercel deploys via existing GitHub auto-deploy; in-session plugin guidance is not needed for the auto-deploy path. WebFetch the official docs on the rare occasion Vercel-specific guidance comes up. `enabledPlugins: {}` in `.claude/settings.json`.

2. **No-recap-after-link** as a CLAUDE.md non-negotiable + `memory/feedback_no_recap_after_link.md`. When Claude gives a link to a PR, Linear card, ADR, doc, or any authoritative source, the link IS the recap — duplicating its content in chat burns Ahmed's attention. The exception is a one-line orientation or an unusual condition the link doesn't surface.

3. **Card-fanout discipline** as a CLAUDE.md non-negotiable + `memory/feedback_card_fanout_discipline.md` + new `card-against-pattern` skill. Before creating multi-deliverable Linear cards, search the team for existing container shapes (BOR-23-style article series) and mirror them rather than creating siblings.

**Why:** All three corrections share a single principle — Ahmed's cognition is the binding constraint. The Model × Effort × Lane matrix shipped earlier today is the upstream version of this principle (don't waste tokens on the wrong setup); these three are the downstream operational versions (don't waste attention on duplicated content, plugin noise, or scattered Linear cards). The vercel-plugin rule has the highest immediate ROI because it pollutes every session today; the no-recap and card-fanout rules prevent recurring tax on every link / every multi-card creation event going forward.

**Expected outcome:** Sessions feel quieter — fewer skills in the available-skills system reminder, fewer false-positive injections, less duplicated content in chat after a PR or card link, single container cards instead of sibling fanout. ADR-002 makes the vercel-plugin decision findable so future-Claude does not silently re-enable.

**Actual outcome:** *(pending — observable on the next session after this PR merges; vercel-plugin skills should drop from the available list, and the no-recap rule should bite the next time a PR URL is delivered)*

---

## 2026-04-26 — Skills frontmatter audit (BOR-24 follow-up)

**Context:** The Model × Effort × Lane matrix shipped earlier on 2026-04-26 codified per-lane defaults but only the agents tier was audited in that pass. BOR-24 deferred the equivalent skills-tier audit as the highest-ROI remaining item: 8 personal-skills (commit, pr, wrap-session, log-decision, gtm-sync, session-pulse, arch-review, convene-board) had no `model:` or `effort:` frontmatter and were silently inheriting the workspace default (opus / high) regardless of whether their workload matched it.

**Decision:** Add explicit `model:` and `effort:` to all 8 SKILL.md files, mirroring the agent-frontmatter convention (placed after `description`, before `tools`/`allowed-tools`).

- **Operational ops — sonnet / medium:** `commit`, `pr`, `wrap-session`, `log-decision`. Mechanical, speed > depth.
- **Analytical / distilled — opus / high:** `gtm-sync`, `session-pulse`, `arch-review`, `convene-board`. Reasoning-heavy or composition-heavy work; not novel architecture, so not xhigh.

Per-advisor `xhigh` stays on the `advisor-1..6` agent files (set in the 2026-04-26 agent audit). The `convene-board` skill itself is the orchestrator — brief composition + parallel fanout + synthesis — which sits at `high`.

**Why:** Operational ops were silently running at opus/high — wasted Opus quota and slower-than-needed turnaround on mechanical commits and PR drafts. Analytical skills were technically at the right tier by default but the explicit frontmatter makes the choice auditable and prevents drift if the workspace default ever changes. Matching the matrix everywhere also makes per-skill overrides visible and justifiable rather than implicit.

**Expected outcome:** /commit and /pr feel faster from the next invocation. /gtm-sync, /session-pulse, /arch-review, /convene-board behave identically to before (already at the right tier by default) but now survive a workspace-default change. BOR-24's three remaining deferred items (status-line surfacing, board xhigh validation, auto lane-shift hook) stay deferred to separate sessions per the card's "do not bundle" note.

**Actual outcome:** *(pending — observable on the next /commit and /pr invocations; should feel snappier and surface Sonnet 4.6 in any model-line telemetry)*

---

## 2026-04-26 — Split post-merge workflow into /cleanup + /wrap-session

**Context:** Until today, `/wrap-session` did two jobs in one shot — per-PR git mechanics (sync main, delete the merged feature branch) and end-of-session reflection (dev-server stop, recap, improvement proposals). That worked when sessions shipped a single PR. Today's BOR-24 work surfaced that sessions now routinely ship multiple PRs, and conflating the two scopes forces a bad choice: either run the heavy reflective recap after every merge (wasted reflection budget on PRs that don't need it), or defer all cleanup to session end (leaving stale feature branches checked out across multiple PRs and breaking "always on main between chunks" hygiene).

**Decision:** Split into two skills with distinct trigger phrases.

- **`/cleanup`** (new, sonnet/medium): per-PR git mechanics only. Sync main `--ff-only`, delete merged feature branch with `-d`. Fires on "merged, clean up" / "PR merged on main" / "go to main and delete the branch". May fire multiple times per session.
- **`/wrap-session`** (modified, re-tiered opus/high): end-of-session reflection only. Stops dev servers Claude started across the session, then produces the recap + improvement-proposal pass. Fires on "wrap up the session" / "we're done for today" / "end of session". Once per session.

Memory file `feedback_wrap_session.md` renamed → `feedback_post_merge_workflow.md` and rewritten to describe both triggers. Matrix updated: ops row swaps `/wrap-session` for `/cleanup` + `/log-decision`; new "Reflection / session recap" row pulls `/wrap-session` and `/session-pulse` together at opus/high.

**Why:** The two scopes have different cadence (per-PR vs per-session), different cognitive register (mechanical vs reflective), and now different model+effort tier. Splitting is the only way to honor both without wasting reflection on small PRs or leaving branch hygiene to drift across multi-PR sessions. Bumping `/wrap-session` to opus/high reflects that reflection-only is closer to `/session-pulse` than to `/commit`.

**Expected outcome:** Multi-PR sessions feel cleaner — between chunks Ahmed says "merged, clean up", Claude does 5 seconds of git mechanics, ready for the next chunk. At session end Ahmed says "wrap up", and the heavyweight reflection runs once on the full session arc. Trigger ambiguity ("I'm done") gets a single one-line clarifier, not a guess.

**Actual outcome:** *(pending — first real test is when this PR itself merges; the BOR-24 branch will be cleaned up via the new `/cleanup` skill it introduces)*

---

## 2026-04-26 — Add Sofia Marchetti (market-strategist) — operational tier

**Context:** Workspace had Naomi (gtm-strategist), Daniel (principal-engineer), Hadi (career-coach), Margaret (release-companion), and the six strategic advisors. None of these did market research. None tracked who was making money in the AI-native solo-operator economy in 2026, where readiness pain was concentrating in EU/France, or where the disruption was real vs. noise. Naomi is bound to the Re-Entry Doctrine; an analyst seat that could pressure-test the doctrine itself with field evidence was missing.

**Decision:** Add `.claude/agents/market-strategist.md` — Sofia Marchetti, Italian, 38, Lisbon-based, ex-Atomico (2018–2022), now writes a private research letter on the EU AI-native solo-operator economy and ships one productized service of her own. Operational tier (context-loaded). Sister to Naomi. Does both research AND strategy.

Persona explicitly calibrated to be **AI-forward, not pre-AI nostalgic.** Field years (Atomico, productized service, EU operator graph) are substrate, not lens. Operating mode is first-principles, strategic foresight + tactical now, native to the 2026 economy. She is licensed to challenge the Re-Entry Doctrine, the four engagement shapes, and the AI-readiness-gap thesis itself with evidence.

Default model/effort: **Opus 4.7 / max** (per BOR-24 matrix + Ahmed's instruction for the deep-research workload). Updates `.claude/agents/README.md` table; the existing persona-vet disclaimer block extends to Sofia.

Same commit also adds `memory/feedback_personas_are_living.md` codifying that all persona files are first drafts subject to revision as Ahmed's way of working with them evolves — calibration notes get baked into files, not just chat.

**Why:** The two-tier architecture (operational context-loaded vs. strategic context-naive) is sound, but the operational tier was missing the research seat. Adding Sofia gives the workspace a place where field evidence can pressure-test the doctrine without crossing into Naomi's positioning-craft lane or the strategic board's frame-level lane. Calibrating her AI-forward (not pre-AI) prevents the dominant failure mode of importing 2018-era VC-analyst patterns onto a 2026 solo-operator economy. Codifying "personas are living drafts" prevents calcification — these are tools, not canon.

**Expected outcome:** Sofia produces the BOR-28 deliverables (landscape map + three positioning bets) on a separate commit on the same branch, as the first proof of the persona. Naomi keeps her positioning-craft lane. Ahmed gains an adversarial-research seat that doesn't require him to convene the strategic board for every cohort/altitude question. Future personas inherit the same draft-and-iterate posture rather than being treated as canonical.

**Actual outcome:** *(pending — first observable on Sofia's first deliverable run)*

---

## 2026-04-26 — Pre-commit branch guard + auto-checkpoint debounce + BOR-24 deferred-items memory (session-close PR)

**Context:** End-of-session wrap on 2026-04-26 surfaced three improvements worth shipping in one PR before closing. (1) Earlier in the session I committed BOR-28 work to local `main` — `pre-push` hook caught it and refused, but the recovery required `git reset --hard`. The protected-branch rule is non-negotiable per workspace CLAUDE.md, but enforcement only existed at push time. (2) The auto-checkpoint Stop hook (`.claude/hooks/auto-commit.sh`) fired after every Claude turn with no debounce, producing 2 noise commits on the BOR-24 branch alongside 2 real commits — signal-to-noise on PR history was poor. (3) BOR-24 was closed with four deferred items (status-line surfacing, model-release calibration, board xhigh validation, auto lane-shift hook) that were intentionally not re-carded to avoid sibling-card fanout, but had no codified surface point.

**Decision:** Three small, independent changes shipped in one session-close PR:

1. **`.claude/git-hooks/pre-commit`** (new) — shell hook refusing commits to `main` / `master` / `dev` / `development` / `production`. Mirrors the existing `pre-push` style. Auto-registers via `core.hooksPath = .claude/git-hooks` (already configured by `setup.sh`). Defense-in-depth — catches the protected-branch mistake at commit time, before the recovery dance.

2. **`.claude/hooks/auto-commit.sh`** (modified) — debounce: skip if the last commit on the current branch was less than `AUTO_CHECKPOINT_DEBOUNCE` seconds ago (default 600 = 10 min). A real commit also resets the timer, so the next auto-checkpoint waits 10 min past the last real save. Env var allows override per session if needed.

3. **`memory/project_bor24_deferred_followups.md`** (new) — surfaces the four deferred BOR-24 items as a single project memory. Honors the card-fanout discipline (no sibling cards) while keeping the items reachable. Marked "surface when relevant; do not preemptively spin a session" so future-Claude doesn't manufacture work.

The fourth recap proposal (decision-log structural pass) was explicitly parked by Ahmed — he wants to design that himself. The "container-card pattern as CLAUDE.md non-negotiable" proposal was redundant — already shipped in the previous session's no-recap-after-link / card-fanout-discipline PR.

**Why:** Each piece addresses an observed-today failure mode. Pre-commit hook prevents a class of mistake the workspace policy already forbids — moving enforcement from "after the fact" to "at the moment of intent". Auto-checkpoint debounce trades a small amount of safety-net coverage (uncommitted work could sit dirty for up to 10 min) for materially cleaner branch history, which compounds across every multi-commit PR. BOR-24 memory note keeps four small follow-ups reachable without inflating the Linear backlog.

**Expected outcome:** Next time Claude is on `main` and tries to commit, `git commit` itself fails — no recovery dance. Auto-checkpoint commits drop from "every Stop event with dirty state" to "at most one per 10 minutes per branch", visible in the next multi-commit PR's `git log`. When a session naturally touches one of the four BOR-24 items, future-Claude surfaces it via the memory rather than re-discovering it cold. No fourth Linear card created — discipline held.

**Actual outcome:** *(pending — pre-commit visible on next stray `git commit` on main; debounce visible on next multi-step session; memory visible on next session that touches model/effort or convene-board)*

---

## 2026-04-26 — `lab/` workspace track scaffolded (10% exploration probe, side-door)

**Context:** Same 2026-04-26 session as the Sofia decision. After two rounds of strategic-board input — the second round on a corrected brief — the board endorsed a 90/10 exploitation/exploration split: keep 90% on the relationship-led primary path (engagement-shapes signal-check, warm-graph reactivation already running at 4–5 catch-ups/week), and allocate ~10% (≈ 1 hour/night) to a small parallel probe testing one specific hypothesis: that the emerging agent-to-agent attention dynamic of 2026 may favor people positioned for agent-discoverable assets, and that accumulated knowledge can be productized into info products via a fully-automated stack with €500–€1k MRR as an open-horizon success floor. The board flipped the round-1 verdict (which was responding to a frame error of mine — I'd implied the conversations were waiting; they aren't) and converged on: run the probe, but the originally-named protections (folder + timer + verbal "no attachment") are naive — replace with kill criteria, named tribe, accountability human, narrative discipline, attentional discipline, and Singer's chest-check.

**Decision:** Create `lab/` as a workspace-level folder (not a submodule — soft quarantine), parallel to `go-to-market/`, deliberately separated from boringsystems / personal-apps / engagement-shapes positioning. Four scaffold files committed:

1. `lab/README.md` — entry point. Encodes the 10% rule as load-bearing and the quarantine rules (one-way reference, no narration to the warm graph, no coupling to existing positioning surfaces). Branson exception (one trusted confidant) explicitly allowed.
2. `lab/CHARTER.md` — the five proofs being run, the success criterion (€500–€1k MRR), the integrity floor ("no duping"), the failure criteria (kill or 90% cadence drops or surface narration leaks or integrity at risk).
3. `lab/PROTECTIONS.md` — the six board-endorsed protections as the execution gate. Placeholders for kill criteria, named tribe, accountability human, narrative discipline, attentional discipline first-signal commitment, and Singer's chest-check. **No execution begins until the gate is filled.**
4. `lab/QUESTIONS.md` — eleven open questions preserved deliberately (no collapsing). Hardest one (item 9): does the Re-Entry Doctrine apply to the lab, or does the side-door framing exempt it? The two readings produce very different labs.

Soft quarantine by default. Escalation to hard quarantine (own submodule) is conditional on the lab generating commercially distinct artifacts or needing different deploy / branding surfaces. Hard quarantine is not the default because it imports setup cost the probe can't yet justify.

**Why:** The board-endorsed split (90/10 epsilon-greedy applied to a personal career at a substrate-shift inflection) is structurally sound — *"10% exploration at the inflection of a substrate shift is not optional, it's hygiene"* (Naval). But the dominant failure mode is the 90% getting eaten by the 10% as the probe gets interesting (6/6 advisors converged on this). Filesystem separation buys reversibility of artifacts but not of attention; the real protections live in pre-committed kill criteria, a named tribe, an accountability human, and narrative discipline. Encoding those as a gate file (`PROTECTIONS.md`) before any execution prevents the two failure modes the board flagged: (a) the folder + timer + "no attachment" framing being mistaken for actual protection, and (b) execution starting before the load-bearing prerequisites (named tribe, kill criteria, accountability human) are in place. The four-file scaffold is the minimum that lets Ahmed pick this up next session without re-deriving context from chat history.

The soft quarantine is the laptop-agnostic default — folder lives in the workspace git tree, no separate setup, fully reproducible from `clone + setup.sh`. If it later escalates, that's a logged decision, not a drift.

**Expected outcome:** Ahmed picks up `lab/` next session, fills the `PROTECTIONS.md` placeholders (kill criteria, tribe, accountability human, first-signal commitment), runs Singer's chest-check, then either resolves or annotates the open questions in `QUESTIONS.md` (especially item 9 — doctrine relationship). Only then does any execution begin (agents, goals, build). The 90% (4–5 catch-ups/week, four engagement shapes resolving by mid-June) continues uninterrupted. The 10% remains genuinely 10% or kills itself.

**Actual outcome:** *(pending — first observable when Ahmed picks the lab back up and either fills the gate or doesn't. If the lab folder sits untouched for >4 weeks, that itself is data — likely indicates the chest-check resolved against the probe.)*

---

## 2026-04-28 — Marky as canonical reader for long Claude output; `/render` skill operationalises it

**Context:** The `tmp/` folder was already established (2026-04-27) as workspace short-term RAM — long Claude-generated analysis writes there instead of into chat scrollback. The *write* half of the loop existed; the *read* half did not. Ahmed had to manually `cat`, `open`, or pull the file into another tool. He hates reading long markdown in the terminal. He explicitly tried Mac markdown apps (Marked 2, MacMD Viewer, generic readers) and rejected them — paid, heavy UI, App Store friction, or terminal-bound (glow). He asked for the AI-frontier 2026 answer and was open to building it.

**Decision:** Adopt **Marky** ([github.com/GRVYDEV/marky](https://github.com/GRVYDEV/marky)) as the canonical reader for long Claude-generated output. Free, open source, Tauri/Rust/React, ~15 MB, ARM-only (matches Ahmed's M-series Mac), live-reload, folder workspaces, Shiki + KaTeX + Mermaid. Installed via `brew tap GRVYDEV/tap && brew install --cask GRVYDEV/tap/marky`, point at `~/Workspace/tmp/`. Created `/render` skill (`.claude/personal-skills/render/SKILL.md`) that auto-fires on natural-language triggers ("render this with Marky", "render outside the terminal", "go render this", etc.), takes the last substantive assistant message, writes verbatim to `tmp/<slug>.md`, runs `marky <path>`, returns one-line confirmation. Memory rule logged at `feedback_render_long_output.md`. ADR at `docs/adr-003-marky-as-canonical-reader.md`.

**Why:** The `tmp/` rule had a missing piece — without a frictionless reader, the rule was incomplete and Ahmed kept reading long output in terminal anyway. Building the viewer ourselves was on the table; Marky exists, is purpose-built for agentic coding workflows in 2026, and is exactly what we'd have built. Codifying as a skill (not just "do it manually each time") matters because Ahmed will say "render this" frequently — without the skill, every render is a re-derivation. The skill normalises the verb.

**Expected outcome:** Long Claude output stops landing in terminal scrollback. Ahmed reads in Marky's native window with rendered tables, code, mermaid diagrams. The `/render` skill becomes the default verb when he wants to consume substantive output. Live-watch on `tmp/` means files appear in Marky's sidebar as Claude writes them — the loop closes without a manual second step. Voice-drift "Marquee/Markey/Marki" handled inline.

**Actual outcome:** *(pending — first observable across the next 5–10 long-output exchanges. Signals of fit: Ahmed stops complaining about terminal reading; renders happen reflexively. Signals of drift: skill stops firing when expected, or Ahmed manually re-derives. If Marky proves unstable or unsigned-binary friction recurs, fall back to Obsidian vault on `tmp/` — same loop, heavier reader.)*

---


---

## 2026-04-28 — Tiered memory architecture v1 (ADR-004)

**Decision:** Restructured the workspace `memory/` folder from a flat 37-file structure into a three-tier architecture (long-term identity, medium-term direction + behavioural feedback, short-term episodic), with two attribution skills (`/whence`, `/divergence-check`) as the drift-detection immune system and `/consolidate-week` as the closed-loop weekly correction. Auto-load policy reads long-term + medium-term/feedback/ + current-arc + current+last week of short-term every session. Symlink architecture: workspace is source of truth, Claude Code reads via symlink at `~/.claude/projects/.../memory/`. Full design rationale, alternatives, and revisit triggers in `docs/adr-004-tiered-memory-architecture.md`.

**Why:** `META-PRINCIPLES.md` declared "tiered memory" as principle #3 but the architecture didn't enforce it. Flat memory mixed constitutional rules (laptop-agnostic, PR creation) with identity preferences with active project state, all loaded with equal weight. No drift detection, no consolidation cadence. The orchestration article on the same principles had been published; the architect's own memory hadn't been restructured. This was the dogfood pass.

---

## 2026-04-28 — Feedback as a medium-term sub-tier with stable/in-flight split

**Decision:** Behavioural rules (`feedback_*.md` files) live in `memory/medium-term/feedback/`, split into two audit-only sub-folders: `stable/` (rules that have crystallized across many domains and time, constitutional in flavour) and `in-flight/` (rules tied to current workflow, specific tooling, or recent corrections, genuinely evolving). Both auto-load every session — runtime is unified. The split exists so the operator can see at a glance which rules to interrogate first during a deliberate audit pass.

**Why:** Initial v1 design put all behavioural rules in long-term. Audit critique surfaced false equivalence: constitutional rules (which don't drift) and identity-rooted rules (which do) sat together with the same conflict-resolution semantics. Moving feedback to medium-term acknowledges that most behavioural rules are temporary — they get condensed, promoted, or archived over time. Long-term is reserved for what has crystallized into identity or doctrine. The stable/in-flight split is a refinement of that move, addressing the secondary critique that 34 files in one folder lost signal-to-noise.

---

## 2026-04-28 — Split `/cleanup` into `/github-cleanup` + `/tmp-cleanup`

**Decision:** Renamed the `/cleanup` skill to `/github-cleanup` (per-PR post-merge git branch cleanup) and created a separate `/tmp-cleanup` skill (operator-directed `tmp/` folder wipe). Removed the auto-wipe of `tmp/` from the SessionStart hook in `.claude/settings.json`. Both skills share the same shape (explicit operator request → mechanical action → one-line confirmation) but operate on different surfaces.

**Why:** The auto-wipe of `tmp/` at SessionStart caused a load-bearing artifact (the live build narrative for the boringsystems article) to disappear mid-workflow during the v1 tiered-memory restructure. The wipe was a hook firing at session-restart events the operator didn't control. Two improvements: (a) the wipe is now explicit operator-directed only, and (b) the word "cleanup" is now scoped — `/github-cleanup` for git, `/tmp-cleanup` for tmp. Backward-compatible triggers preserved so muscle memory still works.

---

## 2026-04-28 — Bilingual EN+FR mandate for boringsystems articles

**Decision:** Codified two long-term feedback rules: every boringsystems article / playbook / page-copy update ships in both English and French at the same time, in the same PR (`feedback_boringsystems_articles_en_and_fr`); and `/article-review` (EN + FR) plus `/french-audit` (FR) are mandatory passes before declaring any boringsystems content done (`feedback_always_run_article_review_and_french_audit`). Never asks the operator about either — both are non-questions.

**Why:** Boringsystems serves a French-market audience as a primary segment. EN-only or FR-deferred shouldn't be on the table. Asking each time creates friction and signals the rule isn't internalized. Codifying as feedback rules removes the question and ensures the discipline survives across sessions.

---

## 2026-04-28 — `llm-context-2026/` submodule deleted, content fully migrated to `memory/`

**Decision:** Removed the `llm-context-2026/` submodule from the workspace. Content distilled into `memory/long-term/inner-game/` (4 files), `memory/medium-term/market/` (7 files), `memory/medium-term/strategic-advisor-system-prompt.md` (1 file), and `memory/medium-term/Proof-Asset-Extraction-OS.md` (1 file). The transition content (3 files) was intentionally discarded per the let-go direction. The Strategic Index was superseded by the new `memory/MEMORY.md` routing protocol.

**Why:** The legacy strategic-context folder created routing fragmentation — two separate memory locations with cross-references, manual STRATEGIC INDEX navigation, and no auto-load. With the new tiered memory architecture in place (ADR-004), all strategic content has a structural home in `memory/`. The submodule no longer earned its place. Two-step deletion (PR #41 cleared all references and migrated load-bearing content; PR #42 deleted the submodule atomically) preserved review safety.

---

## 2026-04-29 — Extend /wrap-session to write daily entry before recap

**Context:** `/wrap-session` produced a session-level recap + improvement proposals but did not write to `memory/short-term/`. Operator caught the gap during the 2026-04-29 session: significant work (long-term tier restructure, PR #44 merged, ADR-005 filed) without any chronological short-term entry for the day. Daily entries depended on operator asking explicitly or Claude proactively offering — neither reliable.

**Decision:** Added new Part 2 "Daily entry" to `/wrap-session` skill (`.claude/personal-skills/wrap-session/SKILL.md`). Writes (or appends to) `memory/short-term/<YYYY-Www>/<YYYY-MM-DD>.md` before producing the recap. Current Part 2 (recap + improvement proposals) renumbered to Part 3. Daily entry is a file write; recap is chat output. Different shapes, different audiences, both required after substantive sessions.

**Why:** `/wrap-session` is already where end-of-session housekeeping happens, so adding the daily-entry write there is the lightest fix — no new skill to remember, no SessionEnd hook firing too aggressively. Lighter than alternatives: a separate `/log-day` skill adds surface area; a SessionEnd hook fires on every `/clear` and quit without a substantive-session filter; a behavioural rule depends on Claude remembering. Closes the gap at the source by resolving the chronological-vs-recap conflation that caused it.

**Expected outcome:** Every `/wrap-session` invocation ensures today's daily entry exists in short-term. No more gaps in the chronological record. Operator never has to ask. The `/wrap-session` ritual becomes the deterministic gate for both chronological logging (Part 2) and retrospective recap (Part 3). Implemented in the same PR as ADR-005 (`omraneah/adr-005-long-term-being-first`).

**Actual outcome:** *(pending)*

---

## 2026-04-30 — Auto-allow Edit/Write/NotebookEdit (no permission prompt)

**Context:** Edit, Write, and NotebookEdit were not in the permissions allow-list, so each first-edit-of-a-file in a session triggered a permission prompt. Operator flagged this as friction on a settled workflow: the workspace is fully version-controlled, edits land on feature branches, branches are isolated and reversible, pushes to protected branches are already blocked by hook. The prompt layer adds nothing the version-control layer doesn't already cover.

**Decision:** Added `Edit`, `Write`, `NotebookEdit` to `permissions.allow` in `.claude/settings.json`. No more permission prompts for file edits. Safety moves down to the existing version-control layer (feature branches, commit history, branch-protection hook) plus the new edit-time enforcement hook (see companion decision below).

**Why:** Permission prompts are valuable when the action is hard to reverse or has external blast radius. File edits in a version-controlled workspace are neither — `git checkout`, `git restore`, branch deletion all roll back cleanly. Trust earned at the version-control layer should not be re-litigated at the prompt layer. Operator stated the rule explicitly and asked it codified so it never re-emerges.

**Expected outcome:** Zero edit-permission prompts in normal flow. If this produces an accidental edit on a protected branch, the companion enforcement hook catches it. If a file outside any git repo gets edited unexpectedly, that's surfaced by the lack of a feature-branch context.

**Actual outcome:** *(pending)*

---

## 2026-04-30 — Feature-branch enforcement at edit time (PreToolUse hook)

**Context:** With Edit/Write auto-allowed (companion decision above), there is no longer a per-edit confirmation moment to catch a stray edit on `main`/`master`/`dev`/`development`/`production`. The existing `block-protected-push.sh` only fires at push time — by then, edits and commits have already accumulated on the wrong branch and need rewinding. Operator wants the rule enforced earlier and stated as a default behavior: before the first edit of any session, check current branch; if protected, create a feature branch first; if a feature branch already exists for the session, keep editing on it (no siblings).

**Decision:** Added `.claude/hooks/enforce-feature-branch.sh`, registered as a PreToolUse hook on `Edit|Write|NotebookEdit`. The hook resolves the repo containing the file being edited (handles workspace root + submodules naturally), reads `git rev-parse --abbrev-ref HEAD` for that repo, and blocks the edit if the branch matches the protected list. Block message tells Claude to create `omraneah/<short-task-name>` and retry, and explicitly to reuse an existing session feature branch rather than creating siblings. Companion feedback file: `memory/medium-term/feedback/stable/feedback_auto_edit_on_feature_branch.md`.

**Why:** Defense in depth. The hook is the safety net — the primary path is Claude doing the right thing without waiting for the hook to fire (per the feedback rule). Catching protected-branch edits at the PreToolUse stage is much cheaper than catching them at push time: zero commits to rewind, zero history to rewrite. Submodule-aware resolution (find the git repo containing the file, not the workspace root) is critical because edits in `personal-apps/` or `boringsystems/` need their own feature branches in those submodules.

**Expected outcome:** Impossible to land an edit on a protected branch in any tracked repo (workspace root or submodule). Block message gives Claude actionable guidance — branch name convention, sibling-avoidance rule. Combined with the companion auto-allow decision, the net effect is: edits flow without prompts on feature branches, hard-stop on protected branches.

**Actual outcome:** *(pending)*

---

## 2026-05-01 — Keep boringsystems.app as canonical surface; defer secondary-domain experiment
**Context:** Late April 2026, reconsidering the website surface name ahead of SEO/AEO consolidation. Two replacement candidates analyzed (`slowcraft.app`, `calmcraft.app`). Reversibility decreases fast once SEO/AEO investment compounds, so the call needed to land before the consolidation work.
**Decision:** Keep `boringsystems.app` as canonical surface. Defer the secondary-domain hedge (e.g. `omrane.work` / `ahmedomrane.com` 301'd to the same site) for cold-stranger-heavy contexts until trigger conditions fire.
**Why:** Verified through the copy-craftsperson agent (Camille Brodeur) twice — initial verdict and a refined verdict after pushback. Three load-bearing reasons. (1) **Counterweight** — the rest of the positioning system is uniformly warm (calm, anchored, sovereign, resonance-not-persuasion); "boring" is the only un-warm word and provides the structural edge for bottom-of-funnel commitment. Replacing it produces a uniformly-warm system that fails to filter at the close. (2) **Archetype-fit** — `boringsystems` flags the new operator-archetype the market is just learning to price (AI-compressed execution, refuses theatre); `calmcraft` flags an older, saturated artisan-consultant archetype. (3) **Pre-funnel aesthetic filter** — boring's strangeness *is* the filter; structurally cheaper than positional polarization because wrong-fit readers don't enter the funnel at all. The site itself rescues the name within ~6 seconds via hero copy and case-file format.
**Expected outcome:** SEO/AEO investment compounds into one canonical brand. Pre-funnel aesthetic-filter principle generalizes to all cold-stranger touchpoints (LinkedIn header, bios, podcast cards). Secondary-domain hedge available when crossover triggers fire (LinkedIn reach threshold crossed, AI-citation traffic appears, two-plus cold-stranger reports of pre-funnel friction, or distribution shifts to cold-stranger-heavy). Don't relitigate for 6 months minimum. Full tactic context in `go-to-market/website.md`.
**Actual outcome:** *(pending)*

---

## 2026-05-01 — /pr always opens URL in browser + 5-bullet summary
**Context:** Ahmed asked whether Claude could `open` the GitHub PR-creation URL on his Mac instead of just printing it. Confirmed yes — `open <url>` launches the default browser. He then asked for this to be the durable default for /pr and any in-conversation push, with a 5-bullet concise summary alongside the link.
**Decision:** Updated `.claude/personal-skills/pr/SKILL.md` (added `Bash(open *)` to allowed-tools, added "open the URL in browser" + "print 5-bullet summary" steps, updated output shape) and `memory/short-term/feedback/stable/feedback_pr_creation.md` (formalized the three-part end-of-turn artifact: 5-bullet summary + clickable URL + automatic `open <url>` in same turn). Applies even outside the /pr skill — any time a push surfaces a PR URL.
**Why:** Reduces friction (one less click) and forces the summary to be terse + scannable instead of re-stating the diff. Codified at both the skill layer and the feedback layer so the rule binds even when /pr isn't explicitly invoked.
**Expected outcome:** Every push that surfaces a PR URL: browser opens automatically, chat shows 5 terse bullets + the link. No asking, no per-instance opt-in. Ahmed reviews the diff in-browser; the bullets are the executive summary.
**Actual outcome:** *(pending)*

---

## 2026-05-01 — New /check-linear-card-paths sibling skill
**Context:** During wrap-session, surfaced that BOR-38's Linear card description pointed at the renamed `Enakl-Derailment-Archetype.md` (now `Engagement-Validity-Filter.md`). Existing `/check-stable-docs-leaks` sweeps repo files for forbidden references but doesn't touch Linear cards — different surface, different drift class. Operator approved extension.
**Decision:** Created `.claude/personal-skills/check-linear-card-paths/SKILL.md` as a sibling skill. Sweeps open Linear card descriptions + comments for path-shaped references (`memory/...`, `docs/...`, `.claude/...`, generic `<path>.md`) and flags those that no longer resolve in `/Users/ahmedomrane/Workspace/`. Read-only by default; optional `--fix` proposes rename-resolution lookups but never silently mutates. Cross-linked from `/check-stable-docs-leaks`. Honors silent-retry rule for Linear MCP rate-limit hiccups. Also patched BOR-38's description manually inline (the load-bearing instance the skill exists to catch).
**Why:** Same shape as the existing leak-sweep skill, opposite direction — repo→leaks vs. cards→broken-paths. Sibling rather than merged because the surfaces (filesystem vs. Linear API) and the cadences (pre-PR vs. on-demand / post-restructure) differ. Sibling pattern matches how `/github-cleanup` and `/tmp-cleanup` are kept separate. Real instance forced the issue today; future memory restructures will recur this drift class without mechanization.
**Expected outcome:** Card descriptions stay synchronized with the workspace as files rename. Catches the drift class within seconds instead of months. Operator surfaces it manually or wires to `/loop` weekly later.
**Actual outcome:** *(pending)*

---

## 2026-05-01 — Linear card lifecycle extended to cover creation (5-bullet summary + URL + auto-open)
**Context:** Wrap-session surfaced one critical improvement: cross-link the Linear-card-rule cluster (`feedback_card_fanout_discipline.md`, `feedback_linear_card_lifecycle.md`, `feedback_linear_cards_self_contained.md`) for two-way discoverability. Operator extended the scope: bundle the cross-references with a behavioral addition — every time Claude *creates* a Linear card on operator instruction, the end-of-turn artifact should match the `/pr` shape (5-bullet executive summary + clickable URL + `open <url>` in browser). The pattern established in `feedback_pr_creation.md` for branch pushes generalizes to card creation; both are "Claude just produced a durable artifact, surface it cleanly so Ahmed can react fast."
**Decision:** Extended `feedback_linear_card_lifecycle.md` with a new **On creation** lifecycle phase (sits before the existing On start / On done / Bundled phases). Mirrors the `/pr` end-of-turn 3-part artifact: terse summary, URL, automatic `open <url>` via Bash in the same turn — no asking, every time. Updated CLAUDE.md non-negotiable line for the lifecycle to cover both the creation and working phases. Two-way cross-references added across the Linear-card rule cluster.
**Why:** Card creation is the moment Ahmed first encounters a card. Without the 3-part artifact, the URL appears but Ahmed has to click manually and read the body before he can react. With it, the browser opens, the 5 bullets give him the load-bearing decisions / placeholders / open questions in 10 seconds, and the body is one scroll away. The cognitive-protection meta-principle (#5) makes this the right default. Mirroring the `/pr` shape rather than inventing a new one reduces the surface area Ahmed has to remember.
**Expected outcome:** Every future Claude-created Linear card lands with the 3-part artifact in the same turn. Card creation feels identical to PR pushes from Ahmed's side. The rule auto-loads via `feedback/in-flight/` so it binds across all future sessions. The cross-reference cluster makes it harder for a future Claude to land on one rule and miss the others.
**Actual outcome:** *(pending)*

---

## 2026-05-02 — Ahmed defers all SEO/AEO to the system — no deeper expertise required
**Context:** Full SEO/AEO overhaul of boringsystems.app was completed: robots.txt, llms.txt, OG tags, Twitter Cards, JSON-LD structured data (Person, WebSite, Article/BlogPosting, ProfilePage, BreadcrumbList), cross-references, company links. A follow-up audit by a specialist agent identified 16 gaps; all were closed. Ahmed reviewed the constraints and asked whether he should go deeper on SEO/AEO or stay at his current conceptual altitude. His stated goal: minimum cognitive investment, maximum protection from self-inflicted damage, defer everything technical to Claude.
**Decision:** Ahmed will not acquire deeper SEO/AEO expertise. His operating model for this domain: (1) write good `description` frontmatter that describes what the article covers specifically; (2) never rename a published slug; (3) update `llms.txt` when a high-signal article ships. Everything else is system-enforced. The `/article-review` skill was updated to catch all three at review time — description quality check (step 10a), published slug preservation blocker (step 10a), and llms.txt refresh signal (step 10a). The full SEO/AEO standard is codified in `docs/constraints.md § SEO and AEO` and `CLAUDE.md` non-negotiables.
**Why:** Ahmed's leverage is in content quality, positioning, and judgment — not in knowing how JSON-LD entity graphs work. Every technical SEO invariant is now either layout-enforced (tags emit unconditionally) or skill-enforced (article-review catches gaps before publish). Adding SEO/AEO to Ahmed's required knowledge surface would violates the cognitive-protection meta-principle (#5). The system is now self-reinforcing: new articles automatically get all metadata, the review skill blocks or warns on the three things that are editorially in Ahmed's hands, and Claude owns everything else.
**Expected outcome:** Zero SEO/AEO regressions as the site grows. Ahmed never needs to ask "did I do the SEO right?" — the answer is always yes if the review skill passed. No topic re-opens unless a platform change requires a constraint update, at which point Claude updates the system, not Ahmed's mental model.
**Actual outcome:** *(pending)*

---

## 2026-05-01 — Linear cards must be self-contained (guiding principle)
**Context:** Late evening session created BOR-42 (a critical GTM power card for personal-positioning consolidation) with several body references to `tmp/copy-writing.md`, which held the verbatim LinkedIn copy + recruiter transcript. Shortly after, the tmp file was deleted (per `tmp/` semantics — render buffer, contents wipe at session boundaries, git-ignored). The substrate the card depended on became inaccessible to anyone reading the card afterwards. Operator caught it via an explicit audit request and asked the principle codified — *"this is not temporary feedback; this is a guiding principle. Log this in all the needed places, mandatory."*
**Decision:** New stable feedback rule at `memory/short-term/feedback/stable/feedback_linear_cards_self_contained.md`. Every Linear card Claude creates on operator instruction must stand alone for a clean-slate agent. Five components required (goal, why, start-from, how, input). What NOT to point to (`tmp/`, short-term pending consolidation, "what we discussed" without codification, git-ignored, subagent-only). Self-containment test ("could a clean-slate agent with no other context execute this?"). Per-card process: classify every reference as durable vs ephemeral, inline ephemeral substrate as comments before submitting. Non-negotiable rule line added to `CLAUDE.md` between card-fanout discipline and lifecycle (Linear cluster).
**Why:** Linear cards are durable artifacts that outlive any session. The agent who eventually executes is not the agent who created it, may not have the session transcript, may be a fresh instance. Pointers to ephemeral state become dangling references that strand the executing agent. Real failure observed this session; rule prevents recurrence at the moment of card creation rather than catching it downstream. Sibling rule to `feedback_promote_tmp_artifacts_before_session_boundary.md` (downstream catch); this one is the upstream move — don't create the dependency in the first place.
**Expected outcome:** Every future Claude-created Linear card stands alone. Audit-after-creation pattern (operator-driven this session) becomes self-check at card creation. Substrate stays accessible regardless of `tmp/` lifecycle, weekly consolidation, or subagent session-scope. Rule auto-loads via stable feedback folder + CLAUDE.md non-negotiables, so it binds across all future sessions.
**Actual outcome:** *(pending)*

---

## 2026-05-05 — Skills canonical write path is Workspace/.claude/personal-skills/
**Context:** While creating the `/log-inbound` skill, a new skill file was written to `~/.claude/skills/log-inbound/` instead of the canonical workspace path `Workspace/.claude/personal-skills/log-inbound/`. The file resolved correctly via symlink (`~/.claude/skills` → `Workspace/.claude/personal-skills`), so no functional breakage occurred — but the wrong path was used, exposing that the symlink relationship was not known before writing. The mistake only surfaced during git status, triggering a wasted permission prompt and operator frustration.
**Decision:** New non-negotiable added to `CLAUDE.md`: skills always go to `Workspace/.claude/personal-skills/<name>/SKILL.md`. `~/.claude/skills/` is a symlink — never a write target. Before writing to any `~/.claude/` path, resolve it first (`ls -la`); if it's a symlink into the workspace, write to the workspace path directly. Codified simultaneously as a stable feedback rule at `memory/short-term/feedback/stable/feedback_skills_canonical_path.md`.
**Why:** The workspace is the source of truth. Writing to a symlink instead of the source obscures version control, creates confusion about canonical location, and contradicts the laptop-agnostic constraint (everything must survive a fresh clone). The symlink exists so Claude Code finds skills at the expected user-level path — it is a read path, not a write path. The mistake was rooted in using `ls ~/.claude/skills/` to discover the skills location without checking whether that path was canonical.
**Expected outcome:** All future skill creation goes directly to `Workspace/.claude/personal-skills/`. The feedback rule auto-loads every session. The CLAUDE.md non-negotiable is highest-weight enforcement. The symlink is never used as a write target again.
**Actual outcome:** *(pending)*

---
