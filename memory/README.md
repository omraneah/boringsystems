# Memory — Architecture & Governance

> The tiered memory system that drives every Claude Code conversation in this workspace.
> Implements principle #3 of `boringsystems/src/content/writing-en/orchestration-principles-that-outlive-the-model.mdx`.

## Purpose

Three horizons of memory, each with its own decay model. One source of truth, version-controlled, laptop-agnostic. Dogfood of the orchestration article's principle #3.

## Folder layout

```
memory/
├── README.md            ← this file (human governance, source of truth)
├── MEMORY.md            ← machine entry (auto-loaded by Claude Code every turn)
├── long-term/           ← north star: constitutional, identity, durable behavioural rules
│   └── README.md
├── medium-term/         ← current direction: positioning, doctrine, evolving arc (1–6 month horizon)
│   └── README.md
└── short-term/          ← episodic running record: daily entries, weekly consolidation
    ├── README.md
    ├── <YYYY-Www>/      ← week folder (current + last 3, ISO week numbering)
    │   ├── <YYYY-MM-DD>.md     ← daily entry
    │   └── consolidation.md    ← created Monday, talks about last week
    ├── _needs-consolidation/   ← items Claude is uncertain about, pending Ahmed's audit
    └── _archive/               ← weeks older than 4 rolling weeks
```

## Tier definitions

| Tier | Horizon | What goes here | Examples |
|---|---|---|---|
| **Long-term** | Effectively constant | Constitutional rules. Identity profile. Engineering principles. | `feedback_laptop_agnostic`, `user_profile`, distilled `inner-game/` |
| **Medium-term** | 1–6 month, evolving | Current positioning, doctrine, project arcs, advisory board, current-direction snapshot | `current-arc.md`, distilled `market/`, `user_strategic_context`, `project_advisory_board` |
| **Short-term** | ≤4 weeks, episodic | Daily entries: decisions, health/state, conflicts. Weekly consolidation files. | `2026-W18/2026-04-28.md`, `_needs-consolidation/`, `consolidation.md` |

## Auto-load policy (v1)

| Tier | What auto-loads every turn |
|---|---|
| Long-term | Full content (north star, weighted highest) |
| Medium-term | Summary / routing index only — full content on demand |
| Short-term | Current week + last week (continuity) |

The auto-loaded surface is `MEMORY.md` (sibling to this README). It is the **machine entry** — lean, ~50–100 lines, pointers and digests only. **This README is the human entry**, source of truth for governance.

v1 deliberately loads broadly. Trim if context bloats. Adjust through consolidation, not silently.

## Weighting rules (when sources conflict)

In order of weight, descending:

1. **Live conversation** — always overrides stale docs (article principle #1: corpus is malleable). The user in the room is the canonical signal.
2. **Long-term** — north star. When live conversation contradicts long-term, this is potential identity drift. **Stop and surface.**
3. **Current week of short-term** — present-moment context.
4. **Last week of short-term** — continuity.
5. **Medium-term** — current direction articulation. Bridges short-term reality with long-term north star.

The medium-term layer is the *interpretive* layer — it reads short-term experience, interprets what it means for direction, and surfaces drift candidates for long-term audit during consolidation.

## Conflict resolution

When clear divergence between live conversation and any tier:

1. **Stop.** Do not silently follow either source.
2. **Surface.** Name what you see: *"I'm pulling from [tier], but you're saying [X]."*
3. **Ask.** Give Ahmed the choice: live wins (and we flag drift for consolidation), or memory wins (and we re-anchor).
4. **Record.** If live wins, record the drift in today's short-term entry under `Conflicts`. If memory wins, note no action needed.

For low-stakes conflicts (style, tone, tactical), default to live + flag. For identity / strategy / north-star conflicts, **always stop and ask first** — these are the cases where silently following either side does damage.

## Drift detection — proactive

Claude must fire `/divergence-check` when it senses:

- Frustration from the user (correction loops, "no", "you're missing me")
- Loss-of-fit (the response feels right by docs but lands wrong)
- A long-term claim being contradicted by a live preference
- Repeated requests to re-explain or rephrase

Pause, surface the suspected drift, propose the consolidation entry. Do not bulldoze through.

## Drift detection — directive

Ahmed fires `/whence` to ask: *"Where did you pull this from? What's the bias risk?"* Claude reports tier + file + date + bias risk for the current claim or behaviour.

## Consolidation — weekly cadence

Triggered at session start, **only on Mondays**. SessionStart behavioural rule (v1) — promote to hook (v2) if missed.

1. Today is Monday → check `short-term/<this-week>/consolidation.md` for date.
2. If file is missing, or its date is from before today → **fire consolidation flow.**
3. Consolidation flow:
   - Claude reads last week's daily entries.
   - Claude proposes: promotions (short→medium, medium→long), demotions, drift flags, deletions.
   - Ahmed reviews and decides.
   - Decisions appended to `consolidation.md` under "Your decisions".
   - Actions executed. Final state appended under "Actions taken".
4. The file stays for completeness. Three sections:
   - `## My consolidation` (Claude's proposals)
   - `## Your decisions` (Ahmed's verdicts)
   - `## Actions taken` (executed changes, paths, summary)

## Daily short-term entries

File: `short-term/<YYYY-Www>/<YYYY-MM-DD>.md`

Format: chronological, timestamps, concise. **No essays.**

```markdown
# 2026-04-28

## 09:30
- Decision: ...
- State: ...
- Conflict (vs long-term `user_profile.md`): ...

## 14:15
- Decision: ...
```

What to capture:
- **Decisions** taken (or postponed)
- **Health/state** (when notable: emotional charge, energy, friction)
- **Conflicts / divergences** from any tier (most important — these feed consolidation)

Multiple sessions in same day → append, don't overwrite. New entries get timestamp + new section.

## Garbage collection

- Past 4 rolling weeks: kept active in `short-term/`.
- Older: moved to `short-term/_archive/<YYYY-Www>/`.
- **Never deleted.** Audit trail.
- **Claude does not read `_archive/` unless Ahmed explicitly points to a week.** It exists for human inspection.

## `_needs-consolidation/` folder

Items Claude was uncertain about during write/migration get parked here for Ahmed's tier-decision in next consolidation. Folder should trend toward empty.

## Origin marking

Files distilled from another source carry a header note:

```markdown
> Distilled from `llm-context-2026/inner-game/Meta-Identity-Constitution.md` on 2026-04-28.
> Original retained at source path until full deprecation pass.
```

Original files in `llm-context-2026/` are **not modified, not auto-read**, and will be deprecated bit by bit by Ahmed (not Claude).

## Symlink architecture (laptop-agnostic)

The actual files live at `/Users/ahmedomrane/Workspace/memory/` (this folder, version-controlled).

Claude Code reads from `~/.claude/projects/-Users-ahmedomrane-Workspace/memory/` — that path is a **symlink** to this folder, created by `bash .claude/setup.sh` on a fresh machine.

Test: clone + setup.sh = full memory accessible.

## What this implements

This memory architecture is the dogfood of:

- **Principle #1 (corpus is malleable)** — live conversation overrides stale docs; drift detection is the immune system.
- **Principle #2 (written down, versioned, portable)** — everything in this folder is in-repo, version-controlled, laptop-agnostic.
- **Principle #3 (memory is tiered, three horizons)** — the entire structure of this folder.
- **Principle #4 (the system corrects itself)** — weekly consolidation, two attribution skills, drift detection.
- **Principle #5 (protect the operator's cognition)** — auto-load policy is conservative; routing is precise; READMEs are scannable.

Companion article: `boringsystems/src/content/writing-en/orchestration-principles-that-outlive-the-model.mdx`.

Live narrative of v1 build: `tmp/restructure-narrative.md`.

Post-restructure audit: Linear BOR-29.
