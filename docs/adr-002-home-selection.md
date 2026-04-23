# ADR-002 — Home-page selection semantics

**Status:** Accepted — 2026-04-21 · Amended 2026-04-22 (lane rename: Writing / Work / Building / Archive) · Amended 2026-04-22 (Selected Articles band removed; Highlights is the sole content surface on home)
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
| `highlight` | boolean | `false` | Include in the home *Highlights* stack. Union across Writing + Work + Building. Capped at three — if more are flagged, only the first three (by `order`) render. |
| `order` | number | `99` | Sort key for the home *Highlights* band only. Not used by lane index pages (those sort by `date`). |

### Surfaces

| Surface | Source query | Sort | Cap |
|---|---|---|---|
| Home *Highlights* | union of `writing-{lang}`, `work-{lang}`, `building-{lang}` where `highlight: true` | `order` asc (editorial curation) | `.slice(0, 3)` |
| `/writing` | all `writing-{lang}` | `date` desc (newest first) | — |
| `/work` | all `work-{lang}` | `date` desc (newest first) | — |
| `/building` | all `building-{lang}` | `date` desc (newest first) | — |
| `/archive` | all `archive-{lang}`, grouped by `series` frontmatter field | `seriesNum` desc, `playbook` asc within series | — |

### Why only Highlights on home

At the site's current volume (six articles across four lanes), the home page's job is to route the visitor to the three pieces Ahmed wants them to read first. Selected Articles added a second band that mostly duplicated what a lane-index click would show, diluting the Highlights signal. One surface keeps the decision sharp: Highlights is the curation layer; lane indexes are the browsing layer.

Re-introduce a second band (Selected Articles or otherwise) only when published volume makes Highlights feel like a narrow window onto a larger body of work.

### Why three highlights, not N

The design charter calls for density without decorative motion. Three is the point at which the home page gives every visitor the three doors Ahmed wants them to walk through first, without scrolling overwhelm. Four starts to feel like a list; two leaves obvious space. Enforcing via `.slice(0, 3)` is intentional — if a fourth article gets `highlight: true`, it should push an older one out (by raising `order`), not silently append.

## Consequences

- **Lane indexes are chronological.** Newest article appears first on `/writing`, `/work`, `/building`. Publishing a new article automatically promotes it to the top of its lane. No flag to set.
- **Home Highlights are editorial.** Ahmed curates — flip `highlight: true` on the three pieces worth surfacing to cold visitors, set a low `order` to control placement. Lane position (which piece leads the lane) is driven by date, independent of this choice.
- Adding a new highlight = set `highlight: true` and a low `order` on an article in any of Writing / Work / Building. Previous highlights either drop out (if their `order` is now higher than three others) or stay.
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
