# Workspace Context

Ahmed Omrane's primary workspace. All projects live here.

Start-of-session routing: `WORKSPACE_MAP.md` (project map). Detail docs under `docs/`.

## Top constraint — Laptop-agnostic by default

Everything here must survive a fresh-machine clone + `bash .claude/setup.sh`. No local-only state, no tokens, no manual MCP setup when a claude.ai connector exists.

Tests every change must pass:

1. **Fresh-machine.** Clone + setup.sh + `git submodule update --init --recursive` = full working state.
2. **Cloud-agent.** A claude.ai agent has everything it needs *in the checkout* — skills, docs, config.
3. **No-token.** No `gh auth login`, no API keys, no manual MCP. GitHub/Linear/Gmail via claude.ai connectors.
4. **Committed-or-it-doesn't-exist.** Hooks, skills, settings, memory, decisions — version-controlled or it isn't real.
5. **Symlink hygiene.** Symlinks from `~/` into a tracked workspace path are fine (reproducible via setup.sh). Symlinks from the repo out to the host are not.

Full rule: `memory/feedback_laptop_agnostic.md`.

## Who Ahmed is

Senior engineering leader (CTO-equivalent scope). Currently in transition — exiting Enakl after 3 years, re-entering on his own terms in France 2026. His leverage is capability-based and portable: rapid navigation of ambiguous systems, crisp judgment under constraint, cross-functional system thinking, AI-native execution that compresses cycles without outsourcing judgment. France-based. Depth-oriented.

Full profile: `memory/user_profile.md`, `memory/user_strategic_context.md`.

## Workspace structure

| Folder | Purpose | Access |
|--------|---------|--------|
| `llm-context-2026/` | Strategic brain — identity, strategy, transition, market positioning. | Read-only. Never modify without explicit instruction. |
| `Enakl/` | 3 years of TMS work. Past company context. | Read-only. Never modify. |
| `cross-stack-architecture-starter-pack/` | Distilled architectural principles. ARDs are non-negotiable boundaries. | Read-only. Consult before structural decisions. |
| `boringsystems/` | Personal site — engineering leadership case files. Astro, Vercel. | Active project. |
| `personal-apps/` | Subdomain apps. Next.js 16, React 19, Tailwind 4. | Active project. Read `AGENTS.md` first. |

## Non-negotiable rules

- **Never push to protected branches.** `main`, `master`, `development`, `dev`, `production`. Enforced by hook.
- **Never open PRs.** Claude pushes; Ahmed opens. No `gh pr create`, no `mcp__github__create_pull_request`.
- **Connector-first MCP.** Linear, GitHub, Gmail, Notion always via claude.ai connectors. Never manual auth.
- **Platform features first, custom code second.** Before reimplementing anything structural (i18n, auth, redirects, caching), check framework docs for native support.
- **Never modify `llm-context-2026/`, `Enakl/`, or `cross-stack-architecture-starter-pack/`** without explicit instruction.
- **Twice-is-a-pattern.** When the same manual task happens twice in a session, stop and propose codifying it before the third time.
- **Max three concerns per session.** Wider scope → split into separate branches.

## Detail — read these when the topic matters

| Topic | File |
|---|---|
| Collaboration tone, scope discipline, code comment rules | `docs/collaboration.md` |
| Git workflow, branch rules, PR handoff, post-merge cleanup | `docs/git-workflow.md` |
| Skills, hooks, setup, MCP, decisions, memory | `docs/infrastructure.md` |
| Per-project stack + conventions | `<project>/CLAUDE.md` and `<project>/docs/` |

## Strategic routing (from `llm-context-2026/`)

Use the Strategic Index to navigate. Never read everything — route precisely.

- Transition + emotion → `llm-context-2026/transition/`
- Opportunity evaluation → `llm-context-2026/market/Leverage Profile & Market Lens.md`
- External action / positioning → `llm-context-2026/market/AI-Native-Builder-Positioning.md`
- Identity drift → `llm-context-2026/inner-game/Meta-Identity-Constitution.md`
- Work confusion → `llm-context-2026/inner-game/Work-Hygiene-Doctrine.md`
