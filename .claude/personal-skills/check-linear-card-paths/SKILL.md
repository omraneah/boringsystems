---
name: check-linear-card-paths
description: Sweep open Linear card descriptions and comments for path references to workspace files that no longer resolve. Catches the drift that happens when memory files / docs / skills are renamed but Linear cards still reference the old paths. Sibling to /check-stable-docs-leaks (same shape, different surface — filesystem vs Linear API).
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash, Read
---

# /check-linear-card-paths — Sweep Linear cards for stale workspace path references

Linear card descriptions and comments often reference workspace files (`memory/...`, `docs/...`, `.claude/...`) — those paths can rot when files are renamed or moved. The repo doesn't enforce this; the cards live in the Linear API, not in the working tree, so a `git grep` won't catch them.

This skill mechanizes the sweep. Sibling to `/check-stable-docs-leaks` — same discipline (path-references-must-resolve), different surface (Linear, not filesystem).

## Why this exists

A real instance: 2026-05-01, a card was filed with a description pointing at `memory/medium-term/operational-doctrine/Enakl-Derailment-Archetype.md`. The next day, the file was renamed to `Engagement-Validity-Filter.md` as part of a memory cleanup. The Linear card description still pointed at the old name — caught manually inline during the card's execution, but the class of drift will recur.

## When to fire

- **Manual invocation** — `/check-linear-card-paths`. Default on-demand cadence.
- **Natural-language triggers**: "check Linear card paths", "are any cards pointing at renamed files?", "stale card references".
- **After a memory restructure / rename pass** — the consolidation flow that renames files should fire this skill afterward to catch the resulting drift.
- **Periodic sweep** — could be wired to `/loop` or `/schedule` weekly. Not required.

## Scope (which cards to check)

By default: **open cards** (status not Done / Canceled / Duplicate) in the Boringsystems team. Stale references in closed cards are archaeological — leave alone.

Operator can override scope:
- `/check-linear-card-paths --all` — include closed cards too.
- `/check-linear-card-paths --team <name>` — different team.
- `/check-linear-card-paths --card BOR-NN` — single card check.

## What to look for

Path-shaped references in Linear card descriptions and comments. Patterns:

- `memory/...\.md` — memory files
- `docs/...\.md` — docs (ADRs, architecture)
- `.claude/...\.md` — skills, decisions, hooks, agents
- `<workspace-relative>/...\.md` — generic markdown references like `go-to-market/strategy.md`, `boringsystems/docs/<file>.md`

Extract every path-shaped substring → for each, check whether it resolves in `/Users/ahmedomrane/Workspace/` → flag the ones that don't.

**Carve-outs:**
- Skip URLs (`https://...`, `mailto:`, etc.).
- Skip references inside fenced code blocks where they're clearly illustrative (e.g. an example of *what an old path used to look like*). Heuristic: if the path appears in a fenced block AND there's a sibling resolving path nearby, skip.
- Skip `tmp/...` paths — those are render-buffer-by-design.

## Steps

1. **List target cards** via Linear MCP (`mcp__claude_ai_Linear__list_issues`). Default filter: status type ∈ {`backlog`, `unstarted`, `started`}. Honor scope flags.
2. **For each card**: fetch the description via `get_issue`, fetch all comments via `list_comments`. Concatenate text.
3. **Extract path-shaped substrings** from each card's full text using a path regex. Suggested: `[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)+\.md`.
4. **Resolve each path** against `/Users/ahmedomrane/Workspace/`. Use the Bash tool with `[ -f ... ]` checks, or batch via `find`.
5. **Flag non-resolving paths** grouped by card.
6. **Output report**: per-card list of stale references, with the line context from the description/comment.

## Output shape

If clean:

```
✓ Linear cards clean. Swept N open cards. No stale workspace path references.
```

If stale references found:

```
⚠ N stale workspace path references across M cards:

[PROJ-NN] Re-voice go-to-market/strategy.md to remove striving-tax
- description:34 — memory/medium-term/operational-doctrine/Enakl-Derailment-Archetype.md (does not exist; possible rename → Engagement-Validity-Filter.md)

[BOR-NN] <title>
- comment 2026-05-01 — docs/adr-002-old-name.md (does not exist)

Fix manually via Linear UI, or re-invoke with --fix to attempt rename-resolution lookups.
```

## --fix mode (best-effort)

Optional. For each stale reference:
1. Search the workspace for files with the same basename — if exactly one match, propose a rename-resolution.
2. If multiple matches or no matches, surface for manual decision.
3. Never silently mutate a Linear card. Surface proposed edits, ask, then apply via `mcp__claude_ai_Linear__save_issue` or `save_comment` only after operator approval.

## Rate-limit handling

Linear MCP rate-limits unpredictably (per `feedback_retry_silently_on_transient_platform_errors.md`). When `list_issues` / `get_issue` / `list_comments` hits a rate limit:
- First retry: same call.
- Second retry: smaller batch (fewer cards per page, narrower filter).
- Third route-around: process the cards already fetched; surface the unprocessed list as a follow-up.
- Never let a rate-limit error be the user-facing artifact.

## Guardrails

- **Read-only by default.** Only `--fix` mode proposes mutations, and even then asks before applying.
- **Don't sweep historical Linear noise.** Closed cards are archaeology unless `--all` is passed.
- **Cross-link from `/check-stable-docs-leaks`** — they're siblings; the operator should know both exist.
- **Workspace-rooted only.** This skill checks paths against `/Users/ahmedomrane/Workspace/`. It does not check absolute paths, URLs, or external filesystems.
- **Don't conflate with leak-sweep direction.** `/check-stable-docs-leaks` checks repo files for *forbidden* references (Linear, tmp, etc.). This skill checks Linear cards for *broken* references (non-resolving paths). Inverse direction; don't merge them.

## Companion skills

- `/check-stable-docs-leaks` — sibling. Sweeps repo stable docs for leak patterns. Same shape, different surface.
- `/consolidate-week` — fires after memory restructures / renames. Wire this skill into the consolidation flow if file renames were part of the week's work.
