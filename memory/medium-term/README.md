# Medium-term Memory — Current Direction + Active Discipline

> Positioning, doctrine, project arcs, current direction (1–6 month horizon, evolving), plus the live behavioural discipline layer (`feedback/` subfolder, auto-loaded).
> The interpretive layer that bridges short-term reality with long-term north star.
> See `../README.md` for full architecture.
>
> **Restructured 2026-04-30** during the long-term-enrichment + medium-term reconciliation pass. Previous structure preserved fragments under `audit/` (pending deletion). See `../short-term/2026-W18/2026-04-30.md` for the session log.

## Top-level files

- **`plan.md`** — six-month re-stabilization plan (July → December 2026). Replaces former `current-arc.md`. **Auto-loaded** because it sets the live direction filter for everything.
- **`current-context.md`** — current life-phase context, capability profile, geographic and market specifics. Updates as the phase evolves; archive when re-entry phase ends.

## Subfolders

### `feedback/` — active behavioural rules (auto-loaded)

How Claude has been told to operate. Every behavioural rule starts here. Over time, rules condense, get promoted to long-term constitutional, or archive. **Always auto-loaded** even though the rest of medium-term is on-demand. See `feedback/README.md` for the lifecycle.

### `market/` — market doctrine (on-demand)

Capability-led positioning, market lens, sales-mode tactics, visibility OS.

Files:
- `Leverage-Profile-and-Market-Lens.md` — capability profile + AI-driven shift + ugliness detection. Renamed from "Leverage Profile & Market Lens.md" 2026-04-30.
- `AI-Native-Builder-Positioning.md` — entry strategy + selection filters + failure modes.
- `Sales-Mode-Tactics.md` — when in sales-mode, run it as one. Renamed from `GTM-Strategy-Transition.md` 2026-04-30 (file is tactics, not strategy).
- `Visibility-OS.md` — publishing posture + tone + content shape. Renamed from `Support_Visibility-OS.md` 2026-04-30.

### `operational-doctrine/` — operational discipline (on-demand)

State regulation, work hygiene, exit triggers, recovery markers, relational altitude, derailment-archetype filter. The being layer is at `../long-term/I-AM.md`; this folder holds the operating rules that protect the being from capture.

Files:
- `Identity-and-Exit-Doctrine.md` — Freedom-Wealth-Experience doctrine + life-level exit triggers + walking modes. Renamed from `Identity-Constitution-and-Exit-Doctrine.md` 2026-04-30.
- `State-and-Guardrails-OS.md` — daily/weekly state regulation + boundary protocols + correction loops + mantras.
- `Work-Hygiene-Doctrine.md` — clean work / dirty work / disengagement protocol / weekly check.
- `Recovery-Signals.md` — felt markers indicating depletion is lifting. Transition-period; expires end of 2026.
- `Relational-Altitude-OS.md` — sponsor-facing posture + altitude levels + French warmth floor. Relocated from `market/` 2026-04-30 (it's interaction discipline, not market doctrine).
- `Enakl-Derailment-Archetype.md` — non-negotiable filter for engagement-validity. Captured 2026-04-30.

### `projects/` — project metadata (on-demand)

Documentation about specific tools / systems used by Claude.

Files:
- `advisory-board.md` — six-advisor strategic-tier board composition + invocation rules. Renamed from `project_advisory_board.md` 2026-04-30.

### `audit/` — TEMPORARY (delete when reconciliation complete)

Holds documents deprecated as of 2026-04-30 reconciliation pass but not yet purged. Five files remain pending deletion:
- `current-arc.md` — replaced by `plan.md`.
- `project_workspace_structure.md` — superseded by `WORKSPACE_MAP.md` at workspace root.
- `strategic-advisor-system-prompt.md` — superseded by the six-advisor board (`projects/advisory-board.md`).
- `market/Re-Entry-Doctrine-Relationship-Primacy.md` — over-committed the shape; subsumed by `../long-term/inner-game/Path-Doctrine.md`.
- `market/Support_Offensive-AI-Positioning_France-2026.md` — striving-shaped; substance subsumed by other docs.

## What goes here

Rules and facts that pass the test:

> *"Is this true today, but might be different in 6 months?"*

If yes → medium-term.

## Auto-load

| Sub-area | Auto-load behaviour |
|---|---|
| `feedback/` | Full content every turn |
| `plan.md` | Full content every turn |
| Everything else | Routing reference only in `MEMORY.md`; full content on demand |

## The interpretive role

Medium-term is the layer that:

- Reads short-term experience (last 4 weeks of daily entries)
- Articulates what it means for current direction (`plan.md`)
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

## Open TODOs from 2026-04-30 reconciliation

- **Update `../MEMORY.md`** auto-load paths — the index references `medium-term/current-arc.md` which no longer exists. Replace with `medium-term/plan.md`.
- **Verify `../../CLAUDE.md`** (workspace root) routing references still resolve.
- **Delete `audit/` folder** once verified.
- **Light cleanup edits** still possible on `Work-Hygiene-Doctrine.md` (Narrative Hygiene softening) and `State-and-Guardrails-OS.md` (Section 9 metric-strip) — flagged but not blocking.
