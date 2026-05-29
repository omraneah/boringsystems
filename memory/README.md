# Memory — Architecture & Governance

> The tiered memory system that drives every Claude Code conversation in this workspace.
> Implements principle #3 of `META-PRINCIPLES.md`. Architecture rationale, alternatives considered, and revisit triggers in `docs/architecture/adr-004-tiered-memory-architecture.md`.

## Purpose

Three horizons of memory, each with its own decay model. One source of truth, version-controlled, laptop-agnostic. Dogfood of the orchestration article's principle #3.

## Folder layout

```
memory/
├── README.md              ← this file (human governance, source of truth)
├── MEMORY.md              ← machine entry (auto-loaded by Claude Code every turn)
├── TODO.md                ← improvement backlog spanning multiple tiers
├── _outdated/             ← superseded files preserved for reference (do not auto-read)
├── long-term/             ← north star: identity, distilled doctrine, path doctrine
│   ├── README.md
│   ├── I-AM.md
│   └── inner-game/
│       ├── Meta-Identity-Constitution.md
│       ├── Path-Doctrine.md
│       ├── Relational-Architecture.md
│       ├── Surrender-Doctrine.md
│       └── Trait-Architecture.md
├── medium-term/           ← current direction (1–6 month horizon, evolving)
│   ├── README.md
│   ├── current-arc.md         ← phase narrative (auto-load)
│   ├── current-context.md     ← geography + market + stack (on demand)
│   ├── Drivers-and-Filters.md ← drivers + filters + position synthesis (auto-load)
│   ├── Engagement-Shapes.md   ← Shape A (incl. A.1) + Shape B (auto-load)
│   ├── market/                ← Sales-Mode-Tactics, Visibility-OS, pre-funnel-filter
│   ├── operational-doctrine/  ← EVF, Identity-and-Exit, State-and-Guardrails, etc.
│   ├── project-management/    ← workspace-workflow, linear-sop, github-sop (auto-load)
│   └── projects/              ← advisory-board metadata
└── short-term/            ← episodic record + active discipline
    ├── README.md
    ├── feedback/          ← active behavioural rules (auto-loaded)
    │   ├── README.md
    │   ├── stable/        ← rules that have crystallized; promotion candidates
    │   └── in-flight/     ← rules tied to current workflow / tooling
    ├── current-arc.md     ← active 2-month plan (auto-loaded)
    ├── extraction-os.md   ← Proof-asset extraction discipline (auto-loaded)
    ├── <YYYY-Www>/        ← week folder
    │   ├── <YYYY-MM-DD>.md
    │   └── consolidation.md
    └── _archive/
```

## Tier definitions

| Tier | Horizon | What goes here | Lives in |
|---|---|---|---|
| **Long-term** | Years | Identity profile, identity-constitution depth-expansion, path doctrine, relational architecture, surrender doctrine, trait architecture. North star. | `long-term/` |
| **Medium-term** | 1–6 months, evolving | Phase narrative (`current-arc.md`), geography + market context (`current-context.md`), drivers + filters (`Drivers-and-Filters.md`), engagement shapes (`Engagement-Shapes.md`), market doctrine, operational doctrine, project-management SOPs, project metadata. Auto-loaded: `current-arc.md`, `Drivers-and-Filters.md`, `Engagement-Shapes.md`, and all `project-management/` files. Rest on demand. | `medium-term/` |
| **Short-term** | ≤4 weeks episodic + active discipline | Daily entries, weekly consolidation, active feedback rules, current 2-month plan, extraction discipline. | `short-term/` |

## On feedback

Feedback is the catch-all category for behavioural rules Ahmed has surfaced but hasn't yet structured into a more durable form. It lives in `short-term/feedback/` because **Ahmed consolidates on top of it weekly** — feedback rules are part of the running record, not stable doctrine.

- Every behavioural rule starts here.
- Over time, recurring patterns get **condensed** (multiple feedback files merging into a single principle), **promoted** to long-term constitutional or medium-term doctrine, or **archived** (when no longer relevant).
- This shaping happens during weekly consolidation, audit passes, or whenever Ahmed names a structuring move.

The split between `stable/` and `in-flight/` is for audit purposes only:

- `stable/` — rules that have crystallized; promotion candidates next.
- `in-flight/` — rules tied to current workflow / tooling / recent corrections; still being interrogated.

Both auto-load with the rest of the discipline layer (long-term + current-arc + this/last week of short-term) so the rules are always in scope.

## Auto-load policy

| Tier | What auto-loads every turn |
|---|---|
| Long-term | Full content (north star, weighted highest) |
| Medium-term — `project-management/workspace-workflow.md` | Full content (collaboration SOP — governs every session) |
| Medium-term — `project-management/linear-sop.md` | Full content (card rules — governs every session) |
| Medium-term — `project-management/github-sop.md` | Full content (branch rules — governs every session) |
| Medium-term — `current-arc.md` | Full content (phase narrative) |
| Medium-term — `Drivers-and-Filters.md` | Full content (operational center for this next step) |
| Medium-term — `Engagement-Shapes.md` | Full content (the two valid surface shapes) |
| Medium-term — rest | Routing-only references in `MEMORY.md`; full content on demand |
| Short-term — `feedback/` | Full content (active discipline layer) |
| Short-term — `current-arc.md` | Full content (active 2-month plan) |
| Short-term — `extraction-os.md` | Full content (proof-asset extraction discipline) |
| Short-term — current week + last week | Full content (continuity) |
| `_outdated/` | Not read unless Ahmed explicitly points to a file |

## Weighting rules (when sources conflict)

In order of weight, descending:

1. **Live conversation** — always overrides stale docs (article principle #1: corpus is malleable). The user in the room is the canonical signal.
2. **Long-term** — north star (identity). When live conversation contradicts long-term, this is potential identity drift. **Stop and surface.**
3. **Mid-term — project-management SOPs** (`workspace-workflow.md`, `linear-sop.md`, `github-sop.md`) — crystallized structural protocols. A protocol wins over a raw behavioral correction. When a feedback rule contradicts a mid-term SOP, the SOP is authoritative unless Ahmed explicitly overrides.
4. **Short-term / feedback** — the live behavioural discipline.
5. **Current week of short-term** — present-moment context.
6. **Last week of short-term** — continuity.
7. **Medium-term — rest** — current direction, positioning, project arcs. Loaded on demand; lower weight in conflicts.

⚠️ **Known limitation:** This weighting structure was corrected 2026-05-03 (previously mid-term sat below short-term/feedback). The distinction between "protocol-shaped" mid-term (high weight, auto-load) and "context-shaped" mid-term (lower weight, on-demand) is structural and needs ongoing review. See `memory/TODO.md`.

## Conflict resolution

When clear divergence between live conversation and any tier:

1. **Stop.** Do not silently follow either source.
2. **Surface.** Name what you see: *"I'm pulling from [tier], but you're saying [X]."*
3. **Ask.** Give Ahmed the choice: live wins (and we flag drift for consolidation), or memory wins (and we re-anchor).
4. **Record.** If live wins, record the drift in today's short-term entry. If memory wins, note no action needed.

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
   - Claude reads last week's daily entries + feedback rules.
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

## Symlink architecture (laptop-agnostic)

The actual files live at `/Users/ahmedomrane/Workspace/memory/` (this folder, version-controlled).

Claude Code reads from `~/.claude/projects/-Users-ahmedomrane-Workspace/memory/` — that path is a **symlink** to this folder, created by `bash .claude/setup.sh` on a fresh machine.

Test: clone + setup.sh = full memory accessible.

## What this implements

This memory architecture is the dogfood of the workspace meta-principles:

- **Corpus is malleable** — live conversation overrides stale docs; drift detection is the immune system.
- **Written down, versioned, portable** — everything in this folder is in-repo, version-controlled, laptop-agnostic.
- **Tiered memory, three horizons** — the entire structure of this folder, with feedback inside short-term where weekly consolidation operates.
- **The system corrects itself** — weekly consolidation, two attribution skills, drift detection.
- **Protect the operator's cognition** — auto-load policy is conservative; routing is precise; READMEs are scannable.

References:

- `META-PRINCIPLES.md` (workspace root) — the workspace-level meta-principle declaration.
- `docs/architecture/adr-004-tiered-memory-architecture.md` — the ADR for this architecture's design rationale, alternatives considered, consequences, and revisit triggers.
