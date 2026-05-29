# ADR-002 — Vercel via GitHub auto-deploy, no Claude Code plugin

**Status:** Accepted (2026-04-26)
**Supersedes:** —
**Superseded by:** —

## Context

Vercel provides a Claude Code plugin (`vercel-plugin@vercel`) that surfaces ~30 specialized skills (deploy, env-vars, routing-middleware, ai-sdk, next-cache-components, vercel-functions, etc.) and adds knowledge-update / verification hooks. The plugin had been enabled in `.claude/settings.json` since workspace bootstrap.

Two failure modes observed in practice:

1. **Skill noise.** Every Claude Code session loaded the full vercel-plugin skill catalog into the available-skills system reminder, regardless of whether the work touched a Vercel-deployed project. Roughly 30 skill descriptions on every prompt. Token cost on every turn for skills that fire on a small minority of sessions.

2. **False-positive hooks.** The plugin's pattern-matching hooks fired on substring matches inside unrelated Bash commands. Concrete example: during a wrap-session git-cleanup, a `pgrep -fa "astro dev|next dev|vite"` argument triggered the `\bnext\s+(dev|build|start|lint)\b` matcher and injected a "MANDATORY: read official docs" block demanding I run `verification`, `next-cache-components`, and `nextjs` skills — for a `git pull` operation. The hook had no awareness of project context (workspace root, no Next.js code in scope) and over-claimed authority via "MANDATORY" language.

The active deployment story is simpler than the plugin assumes: Vercel auto-deploys on push to GitHub for both `boringsystems` (Astro) and `personal-apps` (Next.js). Configuration lives in `vercel.json` per project. There is no day-to-day operator interaction with Vercel CLI from Claude Code sessions — and when there is (rare), looking up the current docs takes seconds and avoids the systemic cost.

## Decision

Disable and do not reinstall the `vercel-plugin@vercel` Claude Code plugin. `enabledPlugins` in `.claude/settings.json` is set to `{}`. The marketplace cache directory under `~/.claude/plugins/marketplaces/vercel/` is local-only and may be left as-is or removed at user discretion — the canonical reproducible state is the empty `enabledPlugins` map in committed settings.

Vercel deployments continue to work via existing GitHub auto-deploy integration. Per-project `vercel.json` is the configuration source of truth.

If a future session genuinely needs Vercel guidance, fetch the current Vercel docs directly via WebFetch — that produces fresher information than the plugin's bundled knowledge anyway.

## Why

- **Token attention is the binding constraint.** The Model × Effort × Lane matrix (see `memory/decisions/DECISIONS.md` 2026-04-26 entry) is about reclaiming attention for the right work. A plugin that loads 30 skills and pattern-matches on every Bash call across every session is the immediate counter-example — it taxes every prompt for a benefit that materializes on a small fraction.
- **Deploy is solved by the platform.** GitHub → Vercel auto-deploy is the deploy story. There is no hand-rolled CI step or manual `vercel deploy` in the regular path. The plugin solves a problem we don't have.
- **Docs over training data.** When Vercel work does come up, the official docs are accurate by definition; the plugin's bundled knowledge is a snapshot that drifts. WebFetch on demand is more reliable than the plugin's canned guidance.

## Expected outcome

- Available-skills system reminder drops back to workspace + project-scoped skills only. No `vercel-plugin:*` skills on the surface.
- No more false-positive injections from substring matches on Bash arguments.
- Vercel deploys continue working unchanged (auto-deploy is independent of Claude Code).
- Future-Claude does not re-enable the plugin without revisiting this ADR.

## Revisit triggers

- Vercel ships a plugin variant with project-scoped activation (only loads when CWD is inside a Vercel-linked project), or
- The auto-deploy path stops being sufficient — e.g. needing programmatic env management or rollbacks from inside Claude Code, or
- A new Vercel feature is shipped that genuinely benefits from in-session skills (rare).

If revisited, prefer the narrowest possible activation scope and reject any plugin that pattern-matches on Bash command substrings without project-context filtering.
