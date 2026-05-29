---
name: card-against-pattern
description: Before creating Linear cards for multi-deliverable work, check if a "container" card pattern already exists in the workspace and mirror that shape instead of creating siblings. Prevents card-fanout. Use whenever about to create more than one Linear card in the same session.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, mcp__claude_ai_Linear__list_issues, mcp__claude_ai_Linear__get_issue, mcp__claude_ai_Linear__save_issue
---

Pattern check before Linear card creation. Runs when Claude is about to create more than one Linear card for related deliverables in the same session — or proactively when the user asks for "cards" plural.

Do not announce the skill invocation. Just do the work.

## Step 1 — Identify the multi-deliverable shape

If the work has more than one deliverable that share context (same architecture decision, same article series, same audit pass, etc.), do NOT default to one-card-per-deliverable. Single deliverables go straight to a single card; this skill is irrelevant.

## Step 2 — Search for an existing container pattern

Use `mcp__claude_ai_Linear__list_issues` on the relevant team (default: Boringsystems) filtered to recent + completed states, scanning titles for shape signals like:

- "Article series — …"
- "Audit — …"
- "Migration — …"
- "Refactor — …"
- "Decision — … + …"

Or any title containing `+` / multi-deliverable language. Inspect the top 2-3 candidates by description (`mcp__claude_ai_Linear__get_issue`) for the section structure they use — articles-as-sections, deliverables-as-sections, etc.

Reference container card shapes observed in this workspace:

- **Article series (canonical shape)** — two articles ("Writing" + "Building") + architecture diagram in one card
- **Article series (variant)** — same shape applied to a second topic; two articles + mermaid diagram in one card

## Step 3 — Mirror, don't fan

If a container pattern exists for similar work, propose creating ONE card that mirrors that container shape — multiple deliverables as sections inside one issue. Each section gets the same structure as the example (working title, thesis, topics, references, notes). Do not create siblings.

If no container pattern exists for the work-shape, create one card per deliverable but keep them tightly cross-referenced.

## Step 4 — Confirm before creating

Always show the proposed shape to the user before calling `save_issue`:

> Found similar pattern (article-series container). Proposed: ONE card mirroring that shape, with [Article A] and [Article B] as sections. Confirm?

Only fire `save_issue` after explicit confirmation, unless the user has set autonomy expectations otherwise in-session.

## Why this skill exists

The 2026-04-26 model × effort × lane session created three Linear cards when only two were intended (one work-tracker + one article series). Cleanup required cancelling two cards and creating a consolidation card. The fix is upstream: check for the container pattern before creating, not after.

See also: `memory/medium-term/project-management/linear-sop.md` § Card creation — multi-deliverable work.
