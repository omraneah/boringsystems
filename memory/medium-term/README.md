# Medium-term Memory — Current Direction + Active Discipline

> Positioning, doctrine, project arcs, current direction (1–6 month horizon, evolving), plus the live behavioural discipline layer (`feedback/` subfolder, auto-loaded).
> The interpretive layer that bridges short-term reality with long-term north star.
> See `../README.md` for full architecture.

## Subfolders

### `feedback/` — active behavioural rules (auto-loaded)

How Claude has been told to operate. Every behavioural rule starts here. Over time, rules condense, get promoted to long-term constitutional, or archive. **Always auto-loaded** even though the rest of medium-term is on-demand. See `feedback/README.md` for the lifecycle.

### `market/` — market doctrine

Positioning, leverage profile, re-entry doctrine, visibility, sponsor-altitude rules, GTM strategy. Loaded on demand.

## Top-level files

- `current-arc.md` — the always-fresh snapshot of where Ahmed is heading right now. Updated during weekly consolidation. **Auto-loaded** because it sets the live direction filter for everything.
- `user_strategic_context.md` — current life-phase context, work hygiene, geographic and market specifics. On-demand.
- `project_workspace_structure.md` — workspace folder map. On-demand.
- `project_advisory_board.md` — six-advisor strategic board composition. On-demand.
- `Proof-Asset-Extraction-OS.md` — framework for converting work into market-grade assets. On-demand.

## What goes here

Rules and facts that pass the test:

> *"Is this true today, but might be different in 6 months?"*

If yes → medium-term.

## Auto-load

| Sub-area | Auto-load behaviour |
|---|---|
| `feedback/` | Full content every turn |
| `current-arc.md` | Full content every turn |
| Everything else | Routing reference only in `MEMORY.md`; full content on demand |

## The interpretive role

Medium-term is the layer that:

- Reads short-term experience (last 4 weeks of daily entries)
- Articulates what it means for current direction (`current-arc.md`)
- Holds the live behavioural discipline (`feedback/`)
- Flags drift candidates for long-term audit during consolidation

## Promotion / demotion path

- Short-term observation that has stabilized over 4 weeks → propose promotion to medium-term during consolidation.
- `feedback/` rule that has held across domains and time and become identity-shaped → propose promotion to long-term.
- Multiple `feedback/` files covering related ground → propose condensation into a single principle.
- Medium-term claim that no longer fits current direction → demote to short-term `_needs-consolidation/` for re-evaluation, or archive.

All movements happen during weekly consolidation, not silently.

## Conflict with live conversation

Medium-term is the most fluid tier overall. If live conversation contradicts a medium-term entry, default to live + flag for consolidation. Less stop-and-ask friction than long-term, more than short-term.

Exception: if `feedback/` contains a rule about behaviour Ahmed cares about strongly (the rule's own description signals it), respect it until consolidation re-evaluates.
