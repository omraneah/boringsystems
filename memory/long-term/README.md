# Long-term Memory — North Star

> Constitutional, identity, durable behavioural rules. Effectively constant. Auto-loaded fully.
> See `../README.md` for full architecture.

## What goes here

Rules and facts that pass the test:

> *"Would this still be true if I woke up in a different country with a different role?"*

If yes → long-term.

Two categories live here:

### 1. Operationally constitutional (rule-shaped, identity-independent)

Hard rules that hold regardless of who Ahmed is. Examples:

- `feedback_laptop_agnostic.md` — workspace must survive fresh-machine clone
- `feedback_pr_creation.md` — Claude pushes, Ahmed opens PRs
- `feedback_mcp_connectors.md` — connector-first, no manual auth
- `feedback_no_recap_after_link.md` — link IS the recap
- `feedback_twice_is_a_pattern.md` — codify before the third occurrence
- Engineering principles, parallel-by-default, etc.

### 2. Identity-rooted (who Ahmed is)

Profile, preferences tied to identity. Examples:

- `user_profile.md`
- `feedback_collaboration.md`
- Distilled `inner-game/` content

⚠️ **Identity files can drift.** See Linear BOR-29: Ahmed flagged active identity reshaping during the v1 restructure. Identity-rooted long-term entries are the most likely to be stale at any moment. Treat with vigilance.

## Auto-load

Full content. Weighted highest in routing.

## File naming

Preserve existing prefix conventions for migrated files (`feedback_*`, `user_*`). For files distilled from `llm-context-2026/`, keep the descriptive name and add an origin header.

## Conflict with live conversation

If live conversation contradicts a long-term file:

- **Category 1 (constitutional):** assume the long-term file is right. Surface the conflict if it persists. These rules exist precisely because we want them to hold under pressure.
- **Category 2 (identity-rooted):** assume the live signal is the truth. Long-term may be stale. **Stop and surface.** Then offer to update via consolidation.

## Promotion path

- A medium-term claim that has held for 3+ months and become identity-shaped → propose promotion to long-term during consolidation.
- A short-term observation never promotes directly to long-term. It must transit through medium-term first.
