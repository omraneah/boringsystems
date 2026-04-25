# Workspace infrastructure

## Skills

Skills live in two scopes. Cross-project skills (useful in every repo) live at `.claude/personal-skills/` and are surfaced globally via the `~/.claude/skills` symlink. Project-scoped skills live at `<project>/.claude/skills/` and only load when Claude is launched from that project.

| Skill | Scope | User-invocable | Auto-invokes |
|---|---|---|---|
| `/commit` | cross-project | yes | on Stop hook |
| `/pr` | cross-project | yes | — |
| `/log-decision` | cross-project | no | after any architectural, config, skill, hook, memory, or workflow decision |
| `/arch-review` | cross-project | yes | after a new module/API endpoint/structural change |
| `/wrap-session` | cross-project | yes | on natural-language merge signals |
| `/session-pulse` | cross-project | yes | mid-session on emerging-pattern detection |
| `/article-capture` | boringsystems | yes | when a conversation produces publishable insight |
| `/article-review` | boringsystems | yes | before publishing any article |
| `/french-audit` | boringsystems | yes | after drafting/updating any FR content |
| `/verify-home` | boringsystems | yes | after any change to home layout, redirects, or selection flags |
| `/check-constraints` | boringsystems | yes | before writing structural code (i18n, auth, caching, redirects) |

**The scope rule** (DECISIONS.md 2026-04-21): no duplication across scopes. If a skill needs to work in two projects, either hoist it up or accept that Claude must be launched from the right project. Launch discipline > file duplication.

## Hooks

Hooks are shell commands wired into Claude Code events. They run deterministically — CLAUDE.md is advisory, hooks are enforcement. All hooks live at `.claude/hooks/`.

| Hook | Event | Effect |
|---|---|---|
| `session-start.sh` | SessionStart (async) | Pulls `main`/`development` if session opens on a base branch |
| `block-protected-push.sh` | PreToolUse (Bash) | Blocks `git push origin main/master/dev/production` |
| `auto-commit.sh` | Stop (async) | Auto-commits + pushes if dirty, on feature branches only |
| `post-edit-typecheck.sh` | PostToolUse (Edit, Write on .ts/.astro) | Runs `astro check` / `tsc --noEmit` in background; reports errors |
| `pattern-capture-nudge.sh` | Stop (async) | Every N turns, reminds Claude to check for uncodified emerging patterns |

**Hook discipline.** Hooks must be idempotent, fast, and never block the user-visible response path. Long-running work goes to `async: true`. Hooks that need to surface findings write to a known location (e.g. `/tmp/claude-<session>/notices.log`) rather than `echo`-ing into Claude's stream.

## Setup on a new machine

```bash
git clone https://github.com/omraneah/workspace.git ~/Workspace
cd ~/Workspace
git submodule update --init --recursive
bash .claude/setup.sh
```

`setup.sh` creates three symlinks:
- `~/.claude/skills` → `.claude/personal-skills/`
- `~/.claude/settings.json` → `.claude/settings.json`
- `~/.claude/projects/-Users-ahmedomrane-Workspace/memory/` → `.claude/projects/-Users-ahmedomrane-Workspace/memory/`

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

Full rule: `memory/feedback_mcp_connectors.md`.

## Decision registry

`.claude/decisions/DECISIONS.md` — chronological log of architectural, workflow, configuration, and infrastructure decisions. Updated automatically via `/log-decision` after every significant decision. Format documented in the file header.

## Memory system

File-based memory at `.claude/projects/-Users-ahmedomrane-Workspace/memory/`. Types: user, feedback, project, reference. Rules and structure live in Claude's system prompt — see the "auto memory" section.

The index file `MEMORY.md` is loaded on every conversation. Keep it terse — one line per entry, under ~150 characters. Content goes in per-topic files, not in the index.
