# Workspace infrastructure

## Skills

Skills live in two scopes. Cross-project skills (useful in every repo) live at `.agents/skills/` (canonical, agent-agnostic). Codex reads this path natively; Claude Code reads it via the `~/.claude/skills` symlink. One source, two readers — no copy. Project-scoped skills live at `<project>/.claude/skills/` and only load when Claude Code is launched from that project.

| Skill                       | Scope         | User-invocable | Auto-invokes                                                               |
| --------------------------- | ------------- | -------------- | -------------------------------------------------------------------------- |
| `/commit`                   | cross-project | yes            | on Stop hook                                                               |
| `/pr`                       | cross-project | yes            | —                                                                          |
| `/log-decision`             | cross-project | no             | after any architectural, config, skill, hook, memory, or workflow decision |
| `/arch-review`              | cross-project | yes            | after a new module/API endpoint/structural change                          |
| `/wrap-session`             | cross-project | yes            | on natural-language end-of-session signals                                 |
| `/session-pulse`            | cross-project | yes            | mid-session on emerging-pattern detection                                  |
| `/github-cleanup`           | cross-project | yes            | on natural-language post-merge cleanup signals                             |
| `/tmp-cleanup`              | cross-project | yes            | only on explicit operator request (never auto-fires)                       |
| `/whence`                   | cross-project | yes            | on operator drift-detection prompts ("where did you get that?")            |
| `/divergence-check`         | cross-project | no             | on detected frustration / loss-of-fit / correction loops (proactive)       |
| `/consolidate-week`         | cross-project | yes            | on Monday session start (per long-term feedback rule)                      |
| `/render`                   | cross-project | yes            | on natural-language render-with-Marky signals                              |
| `/card-against-pattern`     | cross-project | yes            | before creating multi-deliverable Linear cards                             |
| `/convene-board`            | cross-project | yes            | on frame-level decisions, structural unease                                |
| `/signal-recap`             | cross-project | yes            | on natural-language recap-and-defer signals                                |
| `/check-stable-docs-leaks`  | cross-project | yes            | before opening a PR that touches stable docs                               |
| `/audit-fix`                | boringsystems | yes            | when `npm audit` shows high/critical                                       |
| `/gtm-sync`                 | cross-project | yes            | on go-to-market signal capture                                             |
| `/article-capture`          | boringsystems | yes            | when a conversation produces publishable insight                           |
| `/article-review`           | boringsystems | yes            | before publishing any article                                              |
| `/french-audit`             | boringsystems | yes            | after drafting/updating any FR content                                     |
| `/verify-home`              | boringsystems | yes            | after any change to home layout, redirects, or selection flags             |
| `/check-constraints`        | boringsystems | yes            | before writing structural code (i18n, auth, caching, redirects)            |

**The scope rule** (DECISIONS.md 2026-04-21): no duplication across scopes. If a skill needs to work in two projects, either hoist it up or accept that the agent must be launched from the right project. Launch discipline > file duplication.

**Write target:** always `.agents/skills/<name>/SKILL.md` (canonical). Never `~/.claude/skills/` — that is the Claude-facing symlink, not the source. The `enforce-feature-branch.sh` hook is pre-configured to bypass `.agents/skills/` writes — no branch needed when creating skills.

## Hooks

Hooks are shell commands wired into agent events. They run deterministically — `AGENTS.md`/`CLAUDE.md` are advisory, hooks are enforcement.

Two tiers:

| Tier | Location | Who uses it | Scripts |
|---|---|---|---|
| Shared (stateless) | `.agents/hooks/` | Claude Code + Codex | `block-protected-push.sh`, `enforce-feature-branch.sh`, `brevity-reminder.sh`, `parallel-by-default-reminder.sh` |
| Claude-specific (lifecycle) | `.claude/hooks/` | Claude Code only | `session-start.sh`, `auto-commit.sh`, `post-edit-typecheck.sh`, `gtm-nudge.sh` |

| Hook | Location | Event | Effect |
|---|---|---|---|
| `session-start.sh` | `.claude/hooks/` | SessionStart (async) | Pulls `main`/`development` if session opens on a base branch; runs `setup.sh` |
| `block-protected-push.sh` | `.agents/hooks/` | PreToolUse (Bash) | Blocks `git push origin main/master/dev/production` |
| `enforce-feature-branch.sh` | `.agents/hooks/` | PreToolUse (Edit\|Write) | Enforces feature branch before edits; bypasses `.agents/skills/` |
| `auto-commit.sh` | `.claude/hooks/` | Stop (async) | Auto-commits + pushes if dirty, on feature branches only. Skips if last commit was within `AUTO_CHECKPOINT_DEBOUNCE` (default 1800s) OR if more than `AUTO_CHECKPOINT_DIRTY_THRESHOLD` files are modified (default 10 — signals active multi-step work) |
| `post-edit-typecheck.sh` | `.claude/hooks/` | Stop (async) | Runs `astro check` / `tsc --noEmit` in background; reports errors |
| `parallel-by-default-reminder.sh` | `.agents/hooks/` | UserPromptSubmit | Reminds the agent to parallelize independent tool calls |
| `brevity-reminder.sh` | `.agents/hooks/` | UserPromptSubmit | Reinforces executive-register brevity rule |
| `gtm-nudge.sh` | `.claude/hooks/` | Stop (async) | Periodic reminder to capture GTM signal via `/gtm-sync` |

**Codex hook paths** use `bash -c 'bash "$(git rev-parse --show-toplevel 2>/dev/null || pwd)/<script>"'` — self-resolving, machine-agnostic. Defined in `.codex/hooks.json`. Codex SessionStart runs `.codex/setup.sh` after the workspace is trusted.

**Canonical permissions** live in `.agents/permissions/`. Agent-specific files are adapters, not policy sources. Claude Code expresses the policy through `.claude/settings.json` tool-class + connector permissions plus `.agents/hooks/`; Codex expresses shell approvals through `.codex/rules/default.rules` generated from `.agents/permissions/command-prefixes.rules` and connector access through platform apps/connectors.

Codex command approvals are installed additively into the Codex runtime rules file by `bash .codex/setup.sh`. Keep only workspace workflow approvals in the canonical permission policy; do not commit personal one-off approvals. Codex setup is workspace-scoped; do not add user-home or broader-root project setup.

Git workflow approvals in `.agents/permissions/command-prefixes.rules` allow the `git` command family broadly for Codex, matching Claude Code's broad `Bash` permission. Do not reintroduce per-command Git approval prompts. Git is normal workspace workflow; protection belongs in hooks.

Protected-branch policy: agents must never push to, force-push to, or delete protected branches (`main`, `master`, `development`, `dev`, `production`) locally or remotely. If a protected branch is involved, stop and surface the risk. All other Git commands are pre-authorized normal workflow.

Claude MCP connector allowlist entries live in `.agents/permissions/claude-mcp-allow.txt`. Linear read/write tools used by card lifecycle skills are ordinary workspace workflow and belong there. Airtable write tools remain excluded unless deliberately re-approved; read/search tools are allowed.

**Hook discipline.** Hooks must be idempotent, fast, and never block the user-visible response path. Long-running work goes to `async: true`. Hooks that need to surface findings write to a session-scoped file rather than `echo`-ing into the agent's stream.

## Setup on a new machine

```bash
git clone https://github.com/omraneah/workspace.git ~/Workspace
cd ~/Workspace
git submodule update --init --recursive
```

Claude Code:

```bash
bash .claude/setup.sh
```

Codex:

```bash
bash .codex/setup.sh
```

Claude Code setup is idempotent and runs automatically via `.claude/hooks/session-start.sh` each session. It:
- Symlinks `~/.claude/skills` → `.agents/skills/`
- Symlinks `~/.claude/settings.json` → `.claude/settings.json`
- Symlinks `~/.claude/projects/-Users-ahmedomrane-Workspace/memory/` → `memory/` (workspace root)

Codex setup is idempotent and runs automatically via `.codex/hooks.json` SessionStart after the workspace is trusted. It installs workspace-owned Codex rules only. Codex reads skills from `.agents/skills/` and personas from `.codex/agents/*.toml` (committed, generated from `.agents/personas/` by `scripts/generate-agents.sh`); cloud Codex has everything from the checkout.

`settings.local.json` is gitignored — it is Claude's runtime permission cache, not config.

## Why HTTPS for submodules (cloud-agent compatibility)

Submodule URLs in `.gitmodules` use **HTTPS** (`https://github.com/omraneah/...`) rather than SSH. This is load-bearing for the cloud-agent test (CLAUDE.md test #2): a claude.ai cloud agent has no SSH private key, but the GitHub connector populates Git's HTTPS credential helper transparently with a short-lived OAuth token. SSH submodule URLs fail in cloud-agent environments with `Permission denied (publickey)`; HTTPS URLs work without manual token setup.

**On the local laptop**, both protocols are supported simultaneously. Two patterns work:

1. **Transparent SSH-via-HTTPS** (recommended if you already have an SSH key registered with GitHub):
   ```bash
   git config --global url."git@github.com:".insteadOf "https://github.com/"
   ```
   Canonical URLs in the repo stay HTTPS (cloud-agent compatible). Your laptop transparently rewrites every `https://github.com/` to `git@github.com:` at runtime, so actual transport is SSH and your existing key keeps working. Cloud agent has no global git config, ignores the rewrite, uses HTTPS as written.

2. **Native HTTPS via macOS Keychain** (if you want HTTPS to genuinely work end-to-end):
   ```bash
   git config --global credential.helper osxkeychain
   ```
   First HTTPS pull/push prompts for username (your GitHub username) and password (a Personal Access Token from github.com → Settings → Developer settings → Personal access tokens, scoped at minimum to `repo`). Token cached in Keychain; subsequent operations transparent. SSH continues to work in parallel for any explicit `git@` URL.

Pattern 1 is lower-friction (no PAT to generate or rotate). Pattern 2 makes HTTPS a real first-class transport on the laptop. Pick one or both — they coexist.

## MCP integrations — connector-first

Before setting up any MCP server manually (`.mcp.json`, API keys, env vars):
1. **Check claude.ai Settings → Connectors.** If a direct connector exists, use it. Stop.
2. Only do manual setup if no direct connector exists and the need is confirmed.

Services with direct connectors (never set up manually): **Linear, GitHub, Gmail, Notion, Google Calendar, Google Drive.** These are OAuth-managed by Anthropic, account-scoped, and work in every session — including cloud and mobile — automatically.

Full rule: `memory/medium-term/feedback/stable/feedback_mcp_connectors.md`.

## Decision registry

`.claude/decisions/DECISIONS.md` — chronological log of architectural, workflow, configuration, and infrastructure decisions. Updated automatically via `/log-decision` after every significant decision. Format documented in the file header.

## Memory system

Tiered file-based memory at `memory/` (workspace root, version-controlled, symlinked from `~/.claude/projects/...`). Three horizons:

- `memory/long-term/` — identity profile, distilled identity-constitution content. Auto-loaded fully every session.
- `memory/medium-term/` — current direction (`current-arc.md`), market doctrine, project arcs, advisory board, plus the `feedback/` sub-tier (active behavioural rules, split into `stable/` and `in-flight/` for audit purposes; both auto-loaded).
- `memory/short-term/` — daily entries, weekly consolidation files. Current week + last week auto-loaded for continuity. Older weeks archived in `_archive/`.

The auto-loaded surface is `memory/MEMORY.md` (machine entry, ~80 lines) — session-start protocol + tier descriptions + drift / consolidation pointers. Human governance lives in `memory/README.md`. Architecture rationale + alternatives + revisit triggers in `docs/adr-004-tiered-memory-architecture.md`.

Drift detection: `/whence` (operator-fired) + `/divergence-check` (Claude-fired). Closed loop: `/consolidate-week` on Monday session start.
