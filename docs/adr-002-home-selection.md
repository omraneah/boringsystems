# ADR-002 — Home-page selection semantics

**Status:** Accepted — 2026-04-21 · Amended 2026-04-22 (lane rename: Writing / Work / Building / Archive) · Amended 2026-04-22 (Selected Articles band removed; Highlights is the sole content surface on home) · Amended 2026-04-24 (Highlights sort is now `date` desc with `order` asc as tiebreaker; cap raised 3 → 4; publish date rendered inline with lane label on every card)
**Scope:** `src/pages/{en,fr}/index.astro`, `src/content/config.ts`

## Context

The home page currently has one content surface beyond the hero: **Highlights** (a stack of three small cards). A second surface — *Selected Articles* — existed briefly and was removed: not enough published material to justify two bands, and the redundancy pulled attention away from the hand-picked Highlights. If volume grows to the point where Highlights-alone hides too much, Selected Articles (or a new band) can be reintroduced here as an amendment.

Earlier iterations used three frontmatter flags with overlapping, under-documented semantics: `featured`, `highlight`, and `order`. This ADR pins the semantics so future changes are a two-minute decision.

## Decision

Each flag has one surface it drives. Surfaces and their sources are listed below.

### Flags

| Flag | Type | Default | Purpose |
|---|---|---|---|
| `featured` | boolean | `false` | Currently dormant. Was used by the removed Selected Articles band; re-activates if it's reintroduced. |
| `highlight` | boolean | `false` | Include in the home *Highlights* stack. Union across Writing + Work + Building. Capped at four — if more are flagged, only the four newest (by `date`, with `order` asc as tiebreaker) render. |
| `date` | ISO date | required | Primary home *Highlights* sort key (desc — newest first). Also renders in the lane-label meta strip on the card via `formatDate()` in `src/lib/article-meta.ts`. |
| `order` | number | `99` | Tiebreaker when two highlighted articles share a `date`. Lower wins. Not consulted when dates differ. |

### Surfaces

| Surface | Source query | Sort | Cap |
|---|---|---|---|
| Home *Highlights* | union of `writing-{lang}`, `work-{lang}`, `building-{lang}` where `highlight: true` | `date` desc, `order` asc as tiebreaker | `.slice(0, 4)` |
| `/writing` | all `writing-{lang}` | `date` desc (newest first) | — |
| `/work` | all `work-{lang}` | `date` desc (newest first) | — |
| `/building` | all `building-{lang}` | `date` desc (newest first) | — |
| `/archive` | all `archive-{lang}`, grouped by `series` frontmatter field | `seriesNum` desc, `playbook` asc within series | — |

### Why only Highlights on home

At the site's current volume (six articles across four lanes), the home page's job is to route the visitor to the three pieces Ahmed wants them to read first. Selected Articles added a second band that mostly duplicated what a lane-index click would show, diluting the Highlights signal. One surface keeps the decision sharp: Highlights is the curation layer; lane indexes are the browsing layer.

Re-introduce a second band (Selected Articles or otherwise) only when published volume makes Highlights feel like a narrow window onto a larger body of work.

### Why four highlights, not three

Previously capped at three on the thesis that three doors is the right amount for a cold visitor. Four is the current cap because the home now earns its fourth slot: a date-sorted stack of four visibly-dated articles reads as a running log of Ahmed's current thinking, not a curated shortlist. Three would silently drop the oldest flagged piece every time a new one gets promoted — unhelpful when two pieces publish in the same week. Five starts to feel like a list.

### Why sort by date, not editorial order

`order` ASC encoded a fixed editorial ranking, which degraded every time a newer piece earned the top slot: Ahmed had to re-stamp `order` across multiple files to keep the ranking fresh. `date` DESC auto-rolls: the newest highlighted piece leads without any frontmatter edit anywhere else. `order` survives as a tiebreaker only — used when two highlighted pieces publish the same day, which is rare but not zero.

## Consequences

- **Lane indexes are chronological.** Newest article appears first on `/writing`, `/work`, `/building`. Publishing a new article automatically promotes it to the top of its lane. No flag to set.
- **Home Highlights are editorial selection, chronological order.** Ahmed curates *which* pieces surface (by flipping `highlight: true`); the home orders them for him (newest first). The curation and the ordering are now decoupled.
- Adding a new highlight = set `highlight: true` on an article in any of Writing / Work / Building. No `order` edit needed unless two pieces share a `date` and the default tiebreaker is wrong. Once more than four pieces carry `highlight: true`, the oldest drops out automatically.
- **Date rendering.** Every highlight card shows its publish date inline with the lane label (`Building · Apr 24, 2026` / `Building · 24 avr. 2026`). Format is locale-aware via `formatDate()` in `src/lib/article-meta.ts`.
- Legacy `homePinned`, `showOnHome`, or any similar flag MUST NOT be added to the schema. Widen the home selection logic instead of adding flags.
- The `verify-home` skill asserts that the current Highlights expectations still hold after any change. Run it after touching frontmatter flags, `order` values, or selection logic.

## Alternatives considered

- **Keep Selected Articles as a secondary band now.** Rejected for current volume — duplicated Highlights, pulled attention from the curation surface. Re-evaluate when article count materially grows.
- **Explicit arrays in config.** Rejected — would externalise the sort+select logic from the article's own frontmatter, creating a second source of truth to keep in sync.
- **A custom collection for home-page picks.** Rejected — we want the article to carry its own fate; nothing should need to know about home in a second place.

## Related

- Decision log entries: `2026-04-21 — Home highlights as an ordered vertical stack (no carousel)`, `2026-04-21 — Mandatory date frontmatter`.
- `src/content/config.ts` — schema definition, now carries semantic comments pointing here.
- `/verify-home` skill — smoke test against the contract defined above.
