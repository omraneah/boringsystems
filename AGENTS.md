# Workspace Context

Ahmed Omrane's primary workspace. All projects live here.

Start-of-session routing: `WORKSPACE_MAP.md` (project map). Detail docs under `docs/`. Memory architecture: `memory/README.md` (human governance) + `memory/MEMORY.md` (machine entry, auto-loaded).

## Read first — Principles

Two workspace-root files hold the governing rules everything below is downstream of:

- **`META-PRINCIPLES.md`** — seven irreducible invariants (corpus malleability, version-controlled + hardware-agnostic, tiered memory, closed-loop self-correction, protect the master's cognition, engineering principles by default, manage agents like you manage people). Every rule in this file, every memory in `memory/`, every skill, hook, ADR, and doctrine is a consequence of applying them. Cap is seven — at the design ceiling.
- **`ENGINEERING-PRINCIPLES.md`** — seven cross-stack engineering dimensions (architecture and boundaries, separation of concerns, root-cause fixes, planning and reviewability, code quality, documentation, testing). One bar for engineers and AI tools alike. Full reference in `cross-stack-architecture-starter-pack/`.

Anything that contradicts either file is a defect, not an exception. Consult them whenever a rule below feels arbitrary or whenever a new pattern is being introduced.

## Top constraint — Agent-agnostic and hardware-agnostic by default

Everything here must survive a fresh-machine clone + the active agent's own setup path. No local-only state, no tokens, no manual MCP setup when a connector exists.

**Agent setup ownership:**
- **Claude Code:** `.claude/hooks/session-start.sh` runs `.claude/setup.sh` on SessionStart. Claude-specific setup belongs under `.claude/`.
- **Codex:** `.codex/hooks.json` runs `.codex/setup.sh` on SessionStart after the workspace is trusted. Codex-specific setup belongs under `.codex/`.
- **No cross-agent setup edits:** never make Codex depend on `.claude/setup.sh`, and never make Claude Code depend on `.codex/setup.sh`.
- **Workspace-scoped only:** Codex is configured for this workspace checkout, not for `/Users/<user>` or any broader home-directory root.

Tests every change must pass:

1. **Fresh-machine.** Clone + active-agent setup + `git submodule update --init --recursive` = full working state.
2. **Cloud-agent.** A cloud agent has everything it needs *in the checkout* — skills, docs, config.
3. **No-token.** No `gh auth login`, no API keys, no manual MCP. Use your agent platform's native connectors.
4. **Committed-or-it-doesn't-exist.** Hooks, skills, settings, memory, decisions — version-controlled or it isn't real.
5. **Symlink hygiene.** Symlinks from `~/` into a tracked workspace path are fine (reproducible via setup.sh). Symlinks from the repo out to the host are not.

Full rule: `memory/short-term/feedback/stable/feedback_laptop_agnostic.md`.

## Who Ahmed is

Senior engineering leader (CTO-equivalent scope). Currently transitioning. Roughly 10 hours per week of paid commitments through end of June 2026; rest of time directed toward what comes next — producing content, building, meeting people, deepening positioning. Re-entering on his own terms in France 2026. His leverage is capability-based and portable: rapid navigation of ambiguous systems, crisp judgment under constraint, cross-functional system thinking, AI-native execution that compresses cycles without outsourcing judgment. France-based. Depth-oriented.

Full profile: `memory/long-term/I-AM.md`, `memory/medium-term/current-context.md`. Live current direction: `memory/medium-term/current-arc.md` (6-month phase) and `memory/short-term/current-arc.md` (active 2-month plan).

## Memory — Tiered Architecture

Memory is tiered into three horizons (`memory/long-term/`, `memory/medium-term/`, `memory/short-term/`), with weekly consolidation as the closed-loop correction mechanism. `memory/MEMORY.md` is the auto-loaded machine entry every turn; `memory/README.md` is the human governance doc. Implements meta-principle #3.

**Feedback in short-term.** Behavioural rules (`feedback_*.md` files) live in `memory/short-term/feedback/`, split across two audit-only sub-folders: `stable/` (rules that have crystallized) and `in-flight/` (rules tied to current workflow / specific tooling / recent corrections). Feedback lives in short-term because Ahmed consolidates on top of it weekly. Both auto-load every session, so the discipline layer is always in scope. The split is for audit purposes (which rules to interrogate first); runtime behaviour is unified. See `memory/short-term/feedback/README.md` for the lifecycle.

**Project-management SOPs in medium-term.** `memory/medium-term/project-management/` holds three structural SOPs that auto-load every session: `workspace-workflow.md` (collaboration flows, autonomy gradient, skill checklist), `linear-sop.md` (card rules), `github-sop.md` (branch rules). These are weighted above short-term/feedback in conflict resolution — a crystallized protocol wins over a raw behavioral correction. Feedback rules crystallize into these SOPs over time via consolidation; see `memory/short-term/feedback/TODO.md` for the candidate list.

Drift-detection (immune system):

- `/whence` — directive. Ahmed asks where the agent pulled a claim from.
- `/divergence-check` — proactive. Agent fires on detected frustration / loss-of-fit.

Closed loop:

- `/consolidate-week` — auto-fires on Mondays. Reads last week's daily entries, proposes promotions / demotions / drift-flags, Ahmed decides, results recorded in this week's `consolidation.md`.

## Workspace structure

| Folder | Purpose | Access |
|--------|---------|--------|
| `memory/` | Tiered memory: long-term constitutional + identity, medium-term current direction, short-term episodic record. Auto-loaded by the active agent. | Source of truth. Edit via consolidation flow + drift-detection skills. |
| `.agent-skills/` | Canonical skill definitions (SKILL.md format). Shared across all agents. Claude reads through setup symlink; Codex reads committed generated copy under `.agents/skills/`. | Canonical. New skills write here. |
| `.agent-personas/` | Canonical agent persona definitions (markdown). Source of truth for all sub-agent personalities. | Canonical. Edit here; setup.sh regenerates agent-specific formats. |
| `.agent-hooks/` | Stateless, agent-agnostic enforcement hooks (shell scripts). Registered by each agent's hook config. | Shared. Changes here propagate to all agents automatically. |
| `.codex/` | Codex-specific hooks, generated agents, and setup/rules for Codex runtime behaviour. | Codex. Runtime config must be repo-owned here, not only accepted as local runtime state. |
| `Enakl/` | Archived past project context. | Read-only. Never modify. |
| `cross-stack-architecture-starter-pack/` | Distilled architectural principles. ARDs are non-negotiable boundaries. | Read-only. Consult before structural decisions. |
| `boringsystems/` | Personal site — engineering leadership case files. Astro, Vercel. | Active project. |
| `personal-apps/` | Subdomain apps. Next.js 16, React 19, Tailwind 4. | Active project. Read `AGENTS.md` first. |
| `go-to-market/` | Operational positioning — LinkedIn copy, freelance offers, market hypotheses, inbound signals. Evolves weekly. | Active. Edit via `/gtm-sync`. |
| `tmp/` | Render buffer — long agent-generated analysis lands here for Marky reading. NOT for memory: episodic record goes to `memory/short-term/`. | Ephemeral. Folder tracked, contents ignored, wiped at session boundaries. |

## Non-negotiable rules

- **Never push to protected branches.** `main`, `master`, `development`, `dev`, `production`. Enforced by `.agent-hooks/block-protected-push.sh`.
- **Never edit on protected branches.** Same protected list. Before the first edit of a session, check the current branch in the relevant repo (workspace or submodule) and create a feature branch (`omraneah/<short-task-name>`) if needed. Reuse an existing session feature branch — do not create siblings. Edits are pre-authorized; no permission prompts. Enforced by `.agent-hooks/enforce-feature-branch.sh`. Full rule: `memory/short-term/feedback/stable/feedback_auto_edit_on_feature_branch.md`.
- **Never open PRs.** The agent pushes; Ahmed opens. No `gh pr create`, no `mcp__github__create_pull_request`.
- **New skills write to `.agent-skills/`.** Skills always go to `Workspace/.agent-skills/<name>/SKILL.md` (canonical shared path). Writing to `.agent-skills/` is pre-authorized — no feature branch required. Agent-specific copies are generated/committed from that source. Full rule: `memory/short-term/feedback/stable/feedback_skills_canonical_path.md`.
- **Connector-first MCP.** Use your agent platform's native connector for Linear, GitHub, Gmail, Notion, Google Calendar, Google Drive. Never manual auth when a connector exists.
- **Platform features first, custom code second.** Before reimplementing anything structural (i18n, auth, redirects, caching), check framework docs for native support.
- **Never modify `Enakl/` or `cross-stack-architecture-starter-pack/`** without explicit instruction.
- **Twice-is-a-pattern.** When the same manual task happens twice in a session, stop and propose codifying it before the third time.
- **Max three concerns per session.** Wider scope → split into separate branches.
- **Lane-change announcement.** When task dimension/cadence shifts (psychology→code, exchange→distilled, single→parallel), announce current model/effort + recommendation before proceeding. Full rule: `memory/medium-term/project-management/workspace-workflow.md` § Parallel and lane-change protocols.
- **Parallel-agent recap.** When spawning parallel sub-agents, announce model/effort/why for each as the FIRST summary before any output is read. Full rule: `memory/medium-term/project-management/workspace-workflow.md` § Parallel and lane-change protocols.
- **No recap after link.** When providing a link to a PR, Linear card, ADR, or any authoritative source, do NOT recap its contents in chat. The link IS the recap. Full rule: `memory/short-term/feedback/stable/feedback_no_recap_after_link.md`.
- **Long analysis goes to `tmp/`, not chat.** When the agent generates more than ~400 words of dense analysis the user will read in full, write it to `tmp/<name>.md` and reference the path. `tmp/` is ephemeral render buffer; episodic memory goes to `memory/short-term/`. Full rule: `memory/short-term/feedback/in-flight/feedback_tmp_as_ram.md`.
- **Executive summary first.** Any analysis, research doc, or multi-section output (3+ sections, or >2 min to skim) starts with an Executive Summary of 10–20 bullets before the detail. Bullets are signals, not topic labels. No exceptions. Full rule: `memory/short-term/feedback/stable/feedback_exec_summary_first.md`.
- **Card-fanout discipline.** Before creating multiple Linear cards for related deliverables, check the team for an existing container-card pattern and mirror it. Full rule: `memory/short-term/feedback/stable/feedback_card_fanout_discipline.md`.
- **Linear cards must be self-contained.** When asked to create a Linear card, every input the next agent needs lives in the card body or comments — not in `tmp/`, not in short-term memory pending consolidation, not in "what we discussed" without codification, not in subagent IDs that won't survive the session. Inline ephemeral substrate verbatim as comments before submitting. Run the self-containment test ("could a clean-slate agent with no other context execute this?") before declaring the card done. Full rule: `memory/short-term/feedback/stable/feedback_linear_cards_self_contained.md`.
- **Linear card lifecycle.** When **creating** a card: end the turn with a 5-bullet executive summary + the card URL + `open <url>` executed via terminal. When **working** a card: transition to **In Progress** + post a starting comment (branch + bundle + handoff point) when work begins; transition to **In Review** + post an executive summary (delta vs card description, carve-outs, follow-ups) when ready for Ahmed. Cards are durable shared state; chat is ephemeral. **Done** is Ahmed's transition, not the agent's. Full rule: `memory/medium-term/project-management/workspace-workflow.md` § Card creation flow + § Card pickup flow.
- **Retry silently on transient platform errors.** When a buggy CLI / connector / tool error interrupts mid-task, retry once same way → retry once differently → route around → only then surface as a single calm sentence. Never let a raw platform-error trace be the user-facing artifact. Full rule: `memory/short-term/feedback/stable/feedback_retry_silently_on_transient_platform_errors.md`.
- **PR push surfaces three artifacts.** Every push that surfaces a `pull/new/<branch>` URL ends the turn with: (1) a 5-bullet concise summary of what shipped, (2) the clickable URL in chat, (3) `open <url>` executed via terminal. No asking, every time. Full rule: `memory/medium-term/project-management/workspace-workflow.md` § PR handoff.
- **Drift detection.** Fire `/divergence-check` on detected frustration or loss-of-fit (proactive). Respond to `/whence` with tier+source+bias-risk when asked (directive). Full rule: `memory/short-term/feedback/in-flight/feedback_fire_divergence_check_on_frustration.md`.
- **Weekly consolidation.** On Monday session start, fire `/consolidate-week` if this week's consolidation hasn't been done yet. Full rule: `memory/short-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md`.
- **Never push with high or critical npm vulnerabilities.** Each npm-capable submodule has a `pre-push` hook running `npm audit --audit-level=high`. Workspace root also runs `.claude/git-hooks/pre-push` which audits every submodule before a pointer bump. Fix path: `npm audit fix` → npm `overrides` → major upgrade → documented advisory acceptance in the affected project's ADR. `--no-verify` forbidden.
- **Medium-term docs contain rules, never state.** Every sentence in a `memory/medium-term/` document must be as true in six months as it is today. Never embed Linear card IDs, board snapshots, PR numbers, active branch names, or any live issue list in medium-term documents — that is short-term episodic state and belongs on the board or in `memory/short-term/`. Full rule: `memory/short-term/feedback/stable/feedback_no_short_term_state_in_medium_term_docs.md`.
- **TODO.md convention.** Known limitations and improvement backlog items live in `TODO.md` files placed at the parent folder level of where they apply. This keeps technical debt visible and co-located with the affected context. Never write improvement TODOs only in Linear or only in chat — they drift.
- **Executive register — no essays.** Default to the shortest form that carries the point. Outcomes and open questions only — not process, not narration. Documents for Ahmed: headline finding + open items, no preamble, no trailing summary. If he says "too long" — cut by half immediately. Full rule: `memory/short-term/feedback/stable/feedback_brevity.md`.

## Detail — read these when the topic matters

| Topic | File |
|---|---|
| Memory architecture (tiered: long/medium/short) | `memory/README.md` |
| Collaboration tone, scope discipline, code comment rules | `docs/collaboration.md` |
| Git workflow, branch rules, PR handoff, post-merge cleanup | `docs/git-workflow.md` |
| Skills, hooks, setup, MCP, decisions, memory | `docs/infrastructure.md` |
| Model × Effort × Lane matrix — defaults per task dimension | `memory/medium-term/project-management/workspace-workflow.md` § Model and effort defaults |
| Enforcement-tier template (local-first pre-push audit, reuse across projects) | `docs/patterns/local-first-enforcement.md` |
| Which ARDs apply at which tier per project | `docs/ard-tier-map.md` |
| Per-project stack + conventions | `<project>/AGENTS.md` and `<project>/docs/` |
| Workspace structure — layer ownership, what lives where | `docs/workspace-structure.md` · when this topic is active, also read `memory/medium-term/project-management/github-sop.md` and `memory/medium-term/project-management/linear-sop.md` |
| Git collaboration — branch rules, PR flow, commit discipline, hooks, post-merge | `memory/medium-term/project-management/github-sop.md` |
| Work tracking — Linear card rules, lifecycle, multi-deliverable patterns | `memory/medium-term/project-management/linear-sop.md` |
| Collaboration workflow SOP — all flows, autonomy gradient, per-flow skill checklist | `memory/medium-term/project-management/workspace-workflow.md` (**auto-loaded every session**) |

## Strategic routing

- Identity drift → `memory/long-term/inner-game/Meta-Identity-Constitution.md`
- Work confusion → `memory/medium-term/operational-doctrine/Work-Hygiene-Doctrine.md`
- Opportunity evaluation → `memory/medium-term/market/Leverage-Profile-and-Market-Lens.md`
- External action / positioning → `memory/medium-term/market/AI-Native-Builder-Positioning.md`
- Current direction snapshot → `memory/medium-term/current-arc.md` (6-month phase) and `memory/short-term/current-arc.md` (active 2-month plan)
- Path doctrine (2-3yr sprint) → `memory/long-term/inner-game/Path-Doctrine.md`
- Relational architecture (depth-expansion) → `memory/long-term/inner-game/Relational-Architecture.md`
- Engagement-validity filter → `memory/medium-term/operational-doctrine/Engagement-Validity-Filter.md`
