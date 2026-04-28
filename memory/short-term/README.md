# Short-term Memory — Episodic Running Record

> Chronological daily entries. 4 rolling weeks active. Weekly consolidation. Archive after.
> See `../README.md` for full architecture.

## What goes here

The running record of what happens, day by day. **Episodic memory.**

Each day, capture:

- **Decisions** taken or postponed
- **Health/state** when notable (emotional charge, energy, friction)
- **Conflicts / divergences** from any tier — most important, these feed consolidation

Be concise. No essays. Timestamps + bullet points.

## File layout

```
short-term/
├── README.md
├── 2026-W18/                    ← current week (ISO week numbering)
│   ├── 2026-04-28.md            ← daily entry
│   ├── 2026-04-29.md
│   └── consolidation.md         ← created Monday, talks about LAST week
├── 2026-W17/                    ← last week
├── 2026-W16/                    ← 2 weeks ago
├── 2026-W15/                    ← 3 weeks ago (oldest active)
├── _needs-consolidation/        ← Claude-uncertain items pending Ahmed's audit
└── _archive/
    └── 2026-W14/                ← archived, no longer auto-loaded
```

## Naming conventions

- Week folder: `<YYYY-Www>` — ISO week, e.g. `2026-W18`
- Daily entry: `<YYYY-MM-DD>.md` — ISO date
- Consolidation: `consolidation.md` (one per week, lives in current week's folder, talks about last week)

## Auto-load

**Current week + last week**, full content. For continuity.

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

## Garbage collection

- Weeks older than current + last 3 → moved to `_archive/<YYYY-Www>/`
- Never deleted
- **Claude does not read `_archive/`** unless Ahmed points to a specific week

## `_needs-consolidation/`

Items Claude was uncertain about during writes or migration get parked here. Each gets a top note explaining the uncertainty. Folder should trend toward empty after each consolidation.

## When in doubt about a new entry

If you're not sure whether something belongs in short-term, medium-term, or long-term — write it here under `_needs-consolidation/`. Better to over-park than to miscategorize. Ahmed sorts during weekly review.
