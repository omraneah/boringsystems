---
name: consolidate-week
description: "Run the weekly memory consolidation flow. Reads last week's daily entries, proposes promotions (short→medium, medium→long), demotions, drift flags, and deletions. Ahmed reviews each proposal; decisions append to this week's consolidation.md. Trigger automatically on Monday SessionStart, or manually with /consolidate-week."
model: opus
effort: high
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Edit, Write, Glob, Bash
---

# /consolidate-week — Weekly memory tier reconciliation

The closed-loop self-correction mechanism for the tiered memory architecture. Without weekly consolidation, the tiers freeze and become stale. This skill is the load-bearing operation that keeps the architecture alive.

## When to fire

- **Auto-fire**: at session start, IF today is Monday AND last consolidation file is dated before today. (See companion long-term feedback rule for the SessionStart trigger logic.)
- **Manual**: `/consolidate-week` — Ahmed runs it any day if the cadence got missed or if a weighty signal warrants mid-week reconciliation.

Do NOT auto-fire on non-Monday days.

## Step 1 — Locate the file paths

- This week folder: `memory/short-term/<YYYY-Www>/` based on today's ISO week.
- Last week folder: the previous ISO week. (macOS: `date -j -v-7d +%Y-W%V`. Linux: `date -d "7 days ago" +%Y-W%V`.)
- Consolidation file: `memory/short-term/<this-week>/consolidation.md`. Created if missing.

## Step 2 — Read last week's daily entries

All `.md` files in last week's folder EXCEPT `consolidation.md`. Read them all. Parse for:

- **Decisions** taken during the week
- **State** patterns (recurring frustration, energy, mode)
- **Conflicts / divergences** logged from any tier — these are the highest-signal items, since they directly feed long-term audit candidates

## Step 3 — Read current state of medium-term

Especially `memory/medium-term/current-arc.md`. The arc is what consolidation might update.

Skim other medium-term files for any that no longer fit, or any short-term observation that has stabilized into them.

## Step 4 — Propose (write the file)

Write `memory/short-term/<this-week>/consolidation.md` with this structure:

```markdown
# Consolidation — Week <YYYY-Www> (consolidating <prior-YYYY-Www>)

*Created <weekday> <YYYY-MM-DD>.*

## My consolidation

### Promotions proposed (short → medium)
- [item]: rationale.

### Promotions proposed (medium → long)
- [item]: rationale. ⚠️ identity-shift candidate if applicable.

### Demotions proposed
- [item]: rationale.

### Drift flags (live conversation contradicted memory)
- Tier: [long/medium/short]. Memory said: [X]. Live signal: [Y]. Suggested action: [keep/edit/archive].

### Deletions proposed
- [item]: rationale (rare — usually archive instead).

### Current-arc update proposed
- [diff against current-arc.md]
```

## Step 5 — Hand to Ahmed

After writing the proposals, surface them concisely in chat. Do NOT recap the consolidation file content in detail — point to the file. Ask one question:

> Consolidated `<prior-week>` into the new consolidation file. What do you want to do?

Wait for Ahmed's responses item by item, OR a batch response.

## Step 6 — Append decisions

As Ahmed responds, append under `## Your decisions`:

```markdown
## Your decisions
- [proposal item] → [keep / edit / promote / demote / archive / discuss further]
- [proposal item] → ...
```

## Step 7 — Execute and append

Execute the approved actions (file moves, edits, archives). Append under `## Actions taken`:

```markdown
## Actions taken
- Promoted `[item description]` to medium-term: `<destination folder>`.
- Updated current-arc.md: `<short diff summary>`.
- Archived `[item description]` to `short-term/_archive/<YYYY-Www>/`.
```

## Step 8 — Rotate older weeks to archive

After consolidation, check if there are any short-term week folders older than current + last 3 active weeks. Move them to `short-term/_archive/`. Never delete.

## What NOT to do

- Do not auto-fire on non-Monday days. The user can run manually if needed.
- Do not silently execute without Ahmed's decisions. Propose only, then wait.
- Do not link to Linear cards or `tmp/` files in the consolidation file or in chat output (stable-doc reference rules).
- Do not delete anything. Archive instead.
- Do not recap the consolidation file in chat — the file is the recap.

## Edge cases

- **No last week folder.** First week of using the system. Write a stub: "First week, no prior data."
- **Last week consolidation already exists with current date.** Already done today; no-op.
- **Many weeks missed.** Batch up: read all missed weeks' entries, consolidate together, note in the consolidation file that it covers multiple weeks.
- **Empty last-week folder (no daily entries).** Note this — maybe a quiet week or skipped logging. No consolidation needed; write a one-line stub.
