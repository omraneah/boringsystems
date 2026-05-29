---
name: consolidate-week
description: "Run the weekly memory consolidation flow. Reads last week's daily entries, proposes promotions (short→medium, medium→long), demotions, drift flags. Two-lane model: Mechanical lane (auto) prunes already-distilled dailies and dedupes byte-identical content; Staged lane (Ahmed-gated) handles all promotions, graduating feedback rules into SOPs, and any signal-deleting moves. Trigger automatically on Monday SessionStart, or manually with /consolidate-week."
model: opus
effort: high
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Edit, Write, Glob, Bash
---

# /consolidate-week — Weekly memory tier reconciliation

The closed-loop self-correction mechanism for the tiered memory architecture. Without weekly consolidation, the tiers freeze and become stale. This skill is the load-bearing operation that keeps the architecture alive.

## Two-lane model

All lifecycle moves fall into exactly one lane. Lane assignment happens BEFORE any file operation.

### Mechanical lane (auto, rides in the commit)

Safe to execute without Ahmed's review because nothing is lost and no signal is destroyed:

- **Prune already-distilled raw dailies**: if a week has a `consolidation.md`, the raw daily entry files for that week can be removed via `git rm`. Git history is the recoverable archive — no `_archive/` graveyard needed.
- **Dedupe byte-identical content**: if two files in the same logical home are byte-for-byte identical, remove the duplicate via `git rm`.

**Constraint**: Mechanical prune runs strictly AFTER the Staged lane has classified all observations in those dailies. Never prune a week's dailies before its consolidation.md exists and is complete.

**Commit convention**: `distill: prune week-NN` for prune operations, `distill: dedupe <description>` for deduplication.

### Staged lane (batched, Ahmed-gated)

Requires Ahmed's explicit approval before execution:

- **Feedback graduation**: promoting a feedback rule from `memory/short-term/feedback/` into a `memory/medium-term/project-management/` SOP section. Commit convention: `distill: graduate <rule-name> → <sop-file>`.
- **Signal-deleting moves**: any operation that removes content from its home without a recoverable copy elsewhere (e.g. removing a feedback file before its rule is represented in a SOP).
- **Identity/doctrine touches**: any edit to `memory/long-term/` or `memory/medium-term/` doctrine files.
- **Tier promotions**: moving an observation from short-term to medium-term, or medium-term to long-term.

Ahmed-decides gate: propose → wait → execute. Never auto-execute Staged items.

### HELD state

An observation that is neither clearly durable nor clearly obsolete → create a dated "revisit by YYYY-MM-DD" memo in `memory/medium-term/held/` with a brief rationale. This memo re-surfaces on its date as a consolidation agenda item. Format:

```markdown
# HELD: <topic> — revisit by <YYYY-MM-DD>
*Held on <YYYY-MM-DD> during consolidation of <week>.*
<one-sentence rationale for why it's held rather than decided now>
```

## When to fire

- **Auto-fire**: at session start, IF today is Monday AND last consolidation file is dated before today.
- **Manual**: `/consolidate-week` — Ahmed runs it any day if the cadence got missed or if a weighty signal warrants mid-week reconciliation.

Do NOT auto-fire on non-Monday days.

## Step 1 — Locate the file paths

- This week folder: `memory/short-term/<YYYY-Www>/` based on today's ISO week.
- Last week folder: the previous ISO week. (Linux: `date -d "7 days ago" +%Y-W%V`. macOS: `date -j -v-7d +%Y-W%V`.)
- Consolidation file: `memory/short-term/<this-week>/consolidation.md`. Created if missing.
- Check for HELD memos coming due: `find memory/medium-term/held -name "*.md" 2>/dev/null` and surface any with `revisit by` date ≤ today.

## Step 2 — Read last week's daily entries

All `.md` files in last week's folder EXCEPT `consolidation.md`. Read them all. Parse for:

- **Decisions** taken during the week
- **State** patterns (recurring frustration, energy, mode)
- **Conflicts / divergences** logged from any tier — highest-signal items, feed long-term audit candidates

## Step 3 — Read current state of medium-term

Especially `memory/medium-term/current-arc.md`. The arc is what consolidation might update.

Skim other medium-term files for any that no longer fit, or any short-term observation that has stabilized into them.

## Step 3b — Feedback corpus pruning quota check

Before writing proposals, count the current feedback files and assess against the 15–20 target range.

```bash
find memory/short-term/feedback -name "*.md" \
  -not -name "README.md" -not -name "TODO.md" | wc -l
```

For each feedback file: is this rule mature enough to graduate into a `memory/medium-term/project-management/` SOP section? Is it redundant or superseded?

**Target:** ≤5 feedback files (post-graduation thin staging). Above 5 = overcrowded; propose at least one graduation this run.

**Graduation** = a feedback rule folds into a permanent SOP section. Once the SOP section exists, the feedback file is pruned via `git rm` (Staged lane — Ahmed must approve). The `distill: graduate` commit captures the history.

**Ahmed-decides gate:** always propose, never auto-execute. Surface the count, surface ≥1 candidate, and wait for Ahmed's decision before moving any file.

## Step 4 — Lane assignment (before writing proposals)

Classify every proposed action into Mechanical or Staged before touching any file:

| Action | Lane |
|--------|------|
| Prune raw dailies after consolidation.md complete | Mechanical |
| Dedupe byte-identical files | Mechanical |
| Graduate feedback rule → SOP | Staged |
| Remove feedback file (after graduation confirmed) | Staged |
| Promote short-term → medium-term | Staged |
| Promote medium-term → long-term | Staged |
| Edit doctrine (medium/long-term) | Staged |
| Create HELD memo | Mechanical (no signal lost) |

## Step 5 — Propose (write the file)

Write `memory/short-term/<this-week>/consolidation.md` with this structure:

```markdown
# Consolidation — Week <YYYY-Www> (consolidating <prior-YYYY-Www>)

*Created <weekday> <YYYY-MM-DD>.*

## My consolidation

### HELD memos coming due
- <topic>: held since <date>, revisit rationale: <summary>. Proposed action: [promote/archive/extend].

### Promotions proposed (short → medium) [Staged]
- [item]: rationale.

### Promotions proposed (medium → long) [Staged]
- [item]: rationale. ⚠️ identity-shift candidate if applicable.

### Demotions proposed [Staged]
- [item]: rationale.

### Drift flags (live conversation contradicted memory)
- Tier: [long/medium/short]. Memory said: [X]. Live signal: [Y]. Suggested action: [keep/edit/archive].

### Current-arc update proposed [Staged]
- [diff against current-arc.md]

### Feedback corpus (Step 3b) [Staged for graduation/archive]
- Current count: N files (stable: X, in-flight: Y). Target: 15–20.
- Status: [within target | OVER TARGET — N above ceiling]
- Graduation candidate(s): [rule name → proposed SOP section] [Staged]
- Archive candidate(s): [rule name → rationale] [Staged]

### Mechanical lane (auto, no approval needed)
- Prune week <YYYY-Www> dailies: <list of files to git rm after above Staged items approved>
- Dedupe: <any byte-identical pairs found>
```

## Step 6 — Hand to Ahmed

After writing the proposals, surface them concisely in chat. Point to the file; do NOT recap it. Ask one question:

> Consolidated `<prior-week>` into the new consolidation file. What do you want to do?

Wait for Ahmed's responses item by item, OR a batch response.

## Step 7 — Append decisions

As Ahmed responds, append under `## Your decisions`:

```markdown
## Your decisions
- [proposal item] → [keep / edit / promote / demote / graduate / hold / archive / discuss further]
- [proposal item] → ...
```

## Step 8 — Execute

Execute approved actions in lane order: Staged first (so Mechanical prune runs after graduation is confirmed).

For Mechanical prune commits, use the `distill:` convention:
- `git rm memory/short-term/<YYYY-Www>/YYYY-MM-DD.md ...`
- `git commit -m "distill: prune week-<NN> raw dailies after consolidation"`

For Staged graduation commits:
- Update the target SOP file to absorb the rule
- `git rm memory/short-term/feedback/<lane>/<rule-file>.md`
- `git commit -m "distill: graduate <rule-name> → <sop-file>"`

Append under `## Actions taken`:

```markdown
## Actions taken
- [Staged] Graduated `[rule description]` into `memory/medium-term/project-management/<sop>`.
- [Staged] Promoted `[item description]` to medium-term: `<destination folder>`.
- [Mechanical] Pruned week-NN raw dailies (consolidation.md present): <N files removed>.
- Updated current-arc.md: `<short diff summary>`.
```

## Step 9 — Rotate older weeks

After consolidation, check if there are week folders older than current + last 3 active weeks that have a `consolidation.md`. Those are eligible for Mechanical prune. Propose them in the Mechanical lane section of the consolidation file.

## What NOT to do

- Do not auto-fire on non-Monday days. The user can run manually if needed.
- Do not silently execute Staged items. Propose only, then wait.
- Do not link to Linear cards or `tmp/` files in the consolidation file or in chat output.
- Do not use `_archive/` folders. Prune = `git rm` — git history is the archive.
- Do not run Mechanical prune before the Staged lane has classified all observations.
- Do not recap the consolidation file in chat — the file is the recap.
- **Do not skip the pruning quota check (Step 3b).** Surface the count even if within target — it's signal, not noise; the corpus re-accretes silently without it.
- **Do not auto-graduate.** Propose → Ahmed decides → then move/edit files. Never silently fold a feedback rule into an SOP without surfacing it first.

## Edge cases

- **No last week folder.** First week of using the system. Write a stub: "First week, no prior data."
- **Last week consolidation already exists with current date.** Already done today; no-op.
- **Many weeks missed.** Batch up: read all missed weeks' entries, consolidate together, note in the consolidation file that it covers multiple weeks.
- **Empty last-week folder (no daily entries).** Note this — maybe a quiet week or skipped logging. No consolidation needed; write a one-line stub.
- **HELD memo on a non-Monday run.** Surface due HELD memos regardless of day; they're agenda items, not Monday-only.
