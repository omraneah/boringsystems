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
**Context:** Token-expensive folder exploration every session. Only `llm-context-2026` had a routing map (Strategic Index). No single entry point describing top-level structure of the workspace.
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

**Decision:** Split agents into two tiers with distinct rules and cadences. **Operational tier** (Naomi `gtm-strategist`, Daniel `principal-engineer`, Hadi `career-coach`, Margaret `release-companion`) reads context files and executes inside the frame; invoked frequently for tactical work. **Strategic tier** (`advisor-1` Branson, `advisor-2` Munger, `advisor-3` Singer, `advisor-4` Naval, `advisor-5` Greene, `advisor-6` Godin) refuses to read `llm-context-2026/`, `go-to-market/`, or any plan/identity/strategy file; refuses to ask Ahmed for his plan; responds from lens to what is said in the moment; operates from Hawkins 200+ register. Six real named figures, all entrepreneurs/builders, selected by Ahmed for personal resonance and lens-diversity. Invocation modes: solo (one lens for one question) or `/convene-board` skill for parallel synthesis on frame-level decisions. Full rationale in `docs/adr-001-two-tier-agents.md`.

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
