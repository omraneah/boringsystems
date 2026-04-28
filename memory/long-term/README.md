# Long-term Memory — North Star

> Constitutional, identity, durable behavioural rules. Effectively constant. Auto-loaded fully.
> See `../README.md` for full architecture.

## What goes here

Rules and facts that pass the test:

> *"Would this still be true if I woke up in a different country with a different role?"*

If yes → long-term.

Two categories live here:

### 1. Operationally constitutional (rule-shaped, identity-independent)

Hard rules that hold regardless of who Ahmed is. The kind of thing that reads as a workspace invariant: laptop-agnostic compliance, PR-creation division of labour, connector-first auth, link-is-the-recap discipline, twice-is-a-pattern codification, engineering principles, parallel-by-default, etc.

### 2. Identity-rooted (who Ahmed is)

Profile, preferences, collaboration tone, distilled identity content from inner-game work. The kind of thing that defines the operator the rules are built around.

⚠️ **Identity files can drift.** Identity-rooted long-term entries are the most likely tier in this whole architecture to be stale at any moment, because the operator is a moving target. The `_needs-consolidation/` workflow and weekly consolidation are designed to surface this drift. Treat with vigilance — when live conversation contradicts an identity-rooted rule, default to live and flag for consolidation.

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
