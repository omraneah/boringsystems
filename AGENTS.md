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
| `.agents/skills/` | Canonical skill definitions (SKILL.md format). Shared across all agents. Codex reads this path natively; Claude reads it through the `~/.claude/skills` setup symlink. | Canonical. New skills write here. |
| `.agents/personas/` | Canonical sub-agent persona definitions: YAML frontmatter (description, model, effort, tools) + body. Single source for all sub-agent personalities. | Canonical. Edit here; the generator builds each agent's format. |
| `.agents/hooks/` | Stateless, agent-agnostic enforcement hooks (shell scripts). Registered by each agent's hook config. | Shared. Changes here propagate to all agents automatically. |
| `.agents/permissions/` | Canonical permission policy for ordinary workspace workflow. Agent-specific permission files are adapters. | Canonical. Update here first. |
| `.codex/` | Codex-specific hooks, generated agents, and setup/rules for Codex runtime behaviour. | Codex. Runtime config must be repo-owned here, not only accepted as local runtime state. |
| `Enakl/` | Archived past project context. | Read-only. Never modify. |
| `cross-stack-architecture-starter-pack/` | Distilled architectural principles. ARDs are non-negotiable boundaries. | Read-only. Consult before structural decisions. |
| `boringsystems/` | Personal site — engineering leadership case files. Astro, Vercel. | Active project. |
| `personal-apps/` | Subdomain apps. Next.js 16, React 19, Tailwind 4. | Active project. Read `AGENTS.md` first. |
| `go-to-market/` | Operational positioning — LinkedIn copy, freelance offers, market hypotheses, inbound signals. Evolves weekly. | Active. Edit via `/gtm-sync`. |
| `tmp/` | Render buffer — long agent-generated analysis lands here for Marky reading. NOT for memory: episodic record goes to `memory/short-term/`. | Ephemeral. Folder tracked, contents ignored, wiped at session boundaries. |

## Non-negotiable rules

- **Never push to protected branches** (`main`, `master`, `development`, `dev`, `production`) → `memory/short-term/feedback/stable/feedback_git_workflow_discipline.md`
- **Git is pre-authorized workflow** — no permission prompts for Git on feature branches → `memory/short-term/feedback/stable/feedback_git_workflow_discipline.md`
- **Never edit on protected branches** — check branch first; create `omraneah/<task>` if needed; reuse the session branch → `memory/short-term/feedback/stable/feedback_git_workflow_discipline.md`
- **Never open PRs** — agent pushes; Ahmed opens. No `gh pr create`, no `mcp__github__create_pull_request` → `memory/medium-term/project-management/workspace-workflow.md` § PR handoff
- **New skills write to `.agents/skills/`** → `memory/short-term/feedback/stable/feedback_skills_canonical_path.md`
- **Connector-first MCP** — use the platform native connector; never manual auth → `memory/short-term/feedback/stable/feedback_mcp_connectors.md`
- **Platform features first, custom code second** → `memory/short-term/feedback/stable/feedback_platform_features_first.md`
- **Never modify `Enakl/` or `cross-stack-architecture-starter-pack/`** without explicit instruction. (AGENTS.md only — no standalone file.)
- **Twice-is-a-pattern** — same manual task twice → codify before the third time → `memory/short-term/feedback/stable/feedback_twice_is_a_pattern.md`
- **Max three concerns per session** — wider scope → split into separate branches → `memory/medium-term/project-management/workspace-workflow.md` § Scope discipline
- **Lane-change announcement** → `memory/medium-term/project-management/workspace-workflow.md` § Parallel and lane-change protocols
- **Parallel-agent recap** → `memory/medium-term/project-management/workspace-workflow.md` § Parallel and lane-change protocols
- **No recap after link** → `memory/short-term/feedback/stable/feedback_output_discipline.md`
- **Long analysis goes to `tmp/`, not chat** → `memory/short-term/feedback/in-flight/feedback_tmp_and_render_discipline.md`
- **Executive summary first** → `memory/short-term/feedback/stable/feedback_exec_summary_first.md`
- **Card-fanout discipline** → `memory/short-term/feedback/stable/feedback_card_fanout_discipline.md`
- **Linear cards must be self-contained** → `memory/short-term/feedback/stable/feedback_linear_cards_self_contained.md`
- **Linear card lifecycle** (creating + working + in-review transitions) → `memory/medium-term/project-management/workspace-workflow.md` § Card creation flow + § Card pickup flow
- **Retry silently on transient platform errors** → `memory/short-term/feedback/stable/feedback_retry_silently_on_transient_platform_errors.md`
- **PR push surfaces three artifacts** (summary + URL + `open <url>`) → `memory/medium-term/project-management/workspace-workflow.md` § PR handoff
- **Drift detection** — fire `/divergence-check` on frustration; answer `/whence` with tier+source+bias-risk → `memory/short-term/feedback/in-flight/feedback_fire_divergence_check_on_frustration.md`
- **Weekly consolidation** — fire `/consolidate-week` on Monday if not yet done → `memory/short-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md`
- **Never push with high or critical npm vulnerabilities** → `memory/medium-term/project-management/github-sop.md` § Pre-push audit
- **Harness work goes under `.agents/`**, never `.claude/` or `.codex/` → `memory/short-term/feedback/stable/feedback_harness_work_under_agents.md`
- **Medium-term docs contain rules, never state** → `memory/short-term/feedback/stable/feedback_no_short_term_state_in_medium_term_docs.md`
- **TODO.md convention** — backlog lives in `TODO.md` at the parent level of where it applies → `memory/medium-term/project-management/workspace-workflow.md` § TODO.md files
- **Executive register — no essays** → `memory/short-term/feedback/stable/feedback_output_discipline.md`
- **Bash for all scripts** → `memory/short-term/feedback/stable/feedback_bash_only_scripts.md`
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
