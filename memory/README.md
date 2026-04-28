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
├── long-term/           ← north star: identity profile, distilled identity content
│   └── README.md
├── medium-term/         ← current direction + active discipline (1–6 month horizon)
│   ├── README.md
│   ├── feedback/        ← active behavioural rules (auto-loaded)
│   │   └── README.md
│   ├── current-arc.md   ← live current-direction snapshot
│   └── ...              ← market doctrine, positioning, project arcs (on-demand)
└── short-term/          ← episodic running record: daily entries, weekly consolidation
    ├── README.md
    ├── <YYYY-Www>/      ← week folder (current + last 3, ISO week numbering)
    │   ├── <YYYY-MM-DD>.md     ← daily entry
    │   └── consolidation.md    ← created Monday, talks about last week
    ├── _needs-consolidation/   ← items Claude is uncertain about, pending Ahmed's audit
    └── _archive/               ← weeks older than 4 rolling weeks
```

## Tier definitions

| Tier | Horizon | What goes here | Lives in |
|---|---|---|---|
| **Long-term** | Effectively constant | Identity profile, distilled identity-constitution content. North star. | `long-term/` |
| **Medium-term — feedback** | Temporary, evolving | Active behavioural rules (how Claude has been told to operate). Promoted to long-term or condensed when patterns crystallize. **Auto-loaded** — the live discipline layer. | `medium-term/feedback/` |
| **Medium-term — rest** | 1–6 month, evolving | Current direction, positioning, doctrine, project arcs, advisory board. Loaded on demand. | `medium-term/` (root) |
| **Short-term** | ≤4 weeks, episodic | Daily entries (decisions, state, conflicts). Weekly consolidation files. Items pending tier-decision. | `short-term/` |

## On feedback

Feedback is the catch-all category for behavioural rules Ahmed has surfaced but hasn't yet structured into a more durable form. By design it is temporary:

- Every behavioural rule starts here.
- Over time, recurring patterns get **condensed** (multiple feedback files merging into a single principle), **promoted** to long-term constitutional (when the rule has held across enough domains and time), or **archived** (when the rule is no longer relevant).
- This shaping happens during weekly consolidation, audit passes, or whenever Ahmed names a structuring move.

Feedback lives in `medium-term/` because it is mid-horizon by nature — too active to be long-term invariant, too durable to be short-term episodic. It auto-loads with the rest of the discipline layer (long-term + current-arc + this/last week of short-term) so the rules are always in scope.

## Auto-load policy (v1)

| Tier | What auto-loads every turn |
|---|---|
| Long-term | Full content (north star, weighted highest) |
| Medium-term — feedback | Full content (active discipline layer) |
| Medium-term — current-arc | Full content (live direction snapshot) |
| Medium-term — rest | Routing-only references in `MEMORY.md`; full content on demand |
| Short-term | Current week + last week (continuity) |

The auto-loaded surface is `MEMORY.md` (sibling to this README). It is the **machine entry** — lean session-start protocol + tier descriptions + drift / consolidation pointers. **This README is the human entry**, source of truth for governance.

v1 deliberately loads broadly. Trim if context bloats. Adjust through consolidation, not silently.

## Weighting rules (when sources conflict)

In order of weight, descending:

1. **Live conversation** — always overrides stale docs (article principle #1: corpus is malleable). The user in the room is the canonical signal.
2. **Long-term** — north star (identity). When live conversation contradicts long-term, this is potential identity drift. **Stop and surface.**
3. **Medium-term / feedback** — the live behavioural discipline.
4. **Current week of short-term** — present-moment context.
5. **Last week of short-term** — continuity.
6. **Rest of medium-term** — current direction, positioning, project arcs.

Medium-term as a whole is the *interpretive* layer — it reads short-term experience, articulates what it means for direction, and surfaces drift candidates for long-term audit during consolidation.

## Conflict resolution

When clear divergence between live conversation and any tier:

1. **Stop.** Do not silently follow either source.
2. **Surface.** Name what you see: *"I'm pulling from [tier], but you're saying [X]."*
3. **Ask.** Give Ahmed the choice: live wins (and we flag drift for consolidation), or memory wins (and we re-anchor).
4. **Record.** If live wins, record the drift in today's short-term entry under `Conflicts`. If memory wins, note no action needed.

For low-stakes conflicts (style, tone, tactical), default to live + flag. For identity / strategy / north-star conflicts, **always stop and ask first**.

## Drift detection — proactive

Claude must fire `/divergence-check` when it senses:

- Frustration from the user (correction loops, "no", "you're missing me")
- Loss-of-fit (the response feels right by docs but lands wrong)
- A long-term claim being contradicted by a live preference
- Repeated requests to re-explain or rephrase

Pause, surface the suspected drift, propose the consolidation entry. Do not bulldoze through.

## Drift detection — directive

Ahmed fires `/whence` to ask: *"Where did you pull this from? What's the bias risk?"* Claude reports tier + folder/source + date + bias risk for the current claim or behaviour.

## Consolidation — weekly cadence

Triggered at session start, **only on Mondays**. Behavioural rule (v1) — promote to hook (v2) if missed.

1. Today is Monday → check `short-term/<this-week>/consolidation.md` for date.
2. If file is missing, or its date is from before today → **fire consolidation flow.**
3. Consolidation flow:
   - Claude reads last week's daily entries.
   - Claude proposes: promotions (short→medium, feedback→long, etc.), demotions, drift flags, deletions, condensation moves on feedback.
   - Ahmed reviews and decides.
   - Decisions appended to `consolidation.md` under "Your decisions".
   - Actions executed. Final state appended under "Actions taken".
4. The file stays for completeness. Three sections: my consolidation / your decisions / actions taken.

## Daily short-term entries

File: `short-term/<YYYY-Www>/<YYYY-MM-DD>.md`

Format: chronological, timestamps, concise. **No essays.**

What to capture: decisions, health/state when notable, conflicts / divergences from any tier (most important — these feed consolidation).

Multiple sessions in same day → append, don't overwrite. New entries get timestamp + new section.

## Garbage collection

- Past 4 rolling weeks: kept active in `short-term/`.
- Older: moved to `short-term/_archive/<YYYY-Www>/`.
- **Never deleted.** Audit trail.
- **Claude does not read `_archive/` unless Ahmed explicitly points to a week.** It exists for human inspection.

## `_needs-consolidation/` folder

Items Claude was uncertain about during write/migration get parked here for Ahmed's tier-decision in next consolidation. Folder should trend toward empty.

## Origin marking

Files distilled from another source carry a header note (e.g. `> Origin: Distilled from llm-context-2026/inner-game/...`). Original files are not modified, not auto-read, deprecated bit by bit by Ahmed.

## Symlink architecture (laptop-agnostic)

The actual files live at `/Users/ahmedomrane/Workspace/memory/` (this folder, version-controlled).

Claude Code reads from `~/.claude/projects/-Users-ahmedomrane-Workspace/memory/` — that path is a **symlink** to this folder, created by `bash .claude/setup.sh` on a fresh machine.

Test: clone + setup.sh = full memory accessible.

## What this implements

This memory architecture is the dogfood of the workspace meta-principles:

- **Corpus is malleable** — live conversation overrides stale docs; drift detection is the immune system.
- **Written down, versioned, portable** — everything in this folder is in-repo, version-controlled, laptop-agnostic.
- **Tiered memory, three horizons** — the entire structure of this folder, with feedback as a temporary sub-tier inside medium-term.
- **The system corrects itself** — weekly consolidation, two attribution skills, drift detection.
- **Protect the operator's cognition** — auto-load policy is conservative; routing is precise; READMEs are scannable.

References:

- `META-PRINCIPLES.md` (workspace root) — the workspace-level meta-principle declaration.
- `boringsystems/src/content/writing-en/orchestration-principles-that-outlive-the-model.mdx` — the detailed published article.
