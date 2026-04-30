# Short-term Memory — Episodic Record + Active Discipline

> Chronological daily entries + active behavioural rules (feedback). 4 rolling weeks active. Weekly consolidation. Archive after.
> See `../README.md` for full architecture.

## What goes here

Two things share short-term:

1. **The running record of what happens.** Day by day. **Episodic memory.**
2. **The active behavioural rules** Ahmed consolidates on top of weekly. Feedback.

Plus the active 2-month plan and Enakl-extraction discipline (which are short-term-bound by horizon).

## Top-level files

- **`current-arc.md`** — active 2-month plan (May → end June 2026). Auto-loaded.
- **`extraction-os.md`** — Enakl proof-asset extraction discipline (2-month bound). Auto-loaded.

## Subfolders

### `feedback/` — active behavioural rules (auto-loaded)

How Claude has been told to operate. Every behavioural rule starts here. Over time, rules condense, get promoted to long-term constitutional or medium-term doctrine, or archive. **Always auto-loaded.**

- `feedback/stable/` — rules that have crystallized; promotion candidates.
- `feedback/in-flight/` — rules tied to current workflow / specific tooling / recent corrections.

The split is for audit purposes only; runtime behaviour is unified. See `feedback/README.md` for the lifecycle.

### `<YYYY-Www>/` — weekly daily entry folders

ISO week numbering. Current + last 3 weeks active.

- `<YYYY-MM-DD>.md` — daily entry, chronological with timestamps.
- `consolidation.md` — created Monday, talks about last week.

### `_archive/` — archived weeks

Weeks older than 4 rolling weeks. Not auto-read.

## Daily entry capture

Each day, capture:

- **Decisions** taken or postponed
- **Health/state** when notable (emotional charge, energy, friction)
- **Conflicts / divergences** from any tier — most important, these feed consolidation

Be concise. No essays. Timestamps + bullet points.

## Daily entry format

```markdown
# 2026-04-28

## 09:30
- Decision: chose to restructure memory into 3 tiers in one pass.
- State: high energy, decisive.
- Conflict (vs long-term scope-discipline rule): this is 1 concern with 11 phases, not 3 concerns. Live wins.

## 14:15
- ...
```

Multiple sessions same day → append timestamp section, don't overwrite.

## Consolidation file format

`consolidation.md` lives in the current week's folder, but talks about last week. Three sections, populated in order:

```markdown
# Consolidation — Week 2026-W18 (consolidating 2026-W17)

*Created Monday 2026-04-28.*

## My consolidation
[Claude's proposals: promotions, demotions, drift flags, deletions]

## Your decisions
[Appended after Ahmed's exchange]

## Actions taken
[Final state, paths, summary]
```

## Auto-load

| Sub-area | Auto-load behaviour |
|---|---|
| `feedback/stable/` + `feedback/in-flight/` | Full content every turn |
| `current-arc.md` | Full content every turn |
| `extraction-os.md` | Full content every turn |
| Current week + last week | Full content (continuity) |
| `_archive/` | Not read unless Ahmed points to a specific week |

## Garbage collection

- Weeks older than current + last 3 → moved to `_archive/<YYYY-Www>/`
- Never deleted
- **Claude does not read `_archive/`** unless Ahmed points to a specific week
