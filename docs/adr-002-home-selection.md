# ADR-002 — Home-page selection semantics

**Status:** Accepted — 2026-04-21
**Scope:** `src/pages/{en,fr}/index.astro`, `src/content/config.ts`

## Context

The home page has two content surfaces beyond the hero: **Highlights** (three large stacked cards) and **Selected Articles** (a grid of card previews). Earlier iterations used three frontmatter flags with overlapping, under-documented semantics: `featured`, `highlight`, and `order`. When Article B was added with both `highlight: true` and `featured: true`, the intent was unclear even at the moment of writing. This ADR pins the semantics so future changes are a two-minute decision rather than a re-derivation.

## Decision

Each flag has one surface it drives. Surfaces and their sources are listed below.

### Flags

| Flag | Type | Default | Purpose |
|---|---|---|---|
| `featured` | boolean | `false` | Include in grid listings: home *Selected Articles* (System Design only), and each lane index page (`/system-design`, `/builders`, `/technology`). |
| `highlight` | boolean | `false` | Include in the home *Highlights* stack. Union across System Design, Builders, and Technology. Capped at three — if more are flagged, only the first three (by `order`) render. |
| `order` | number | `99` | Sort key across all surfaces. Lower numbers surface first. |

### Surfaces

| Surface | Source query | Sort | Cap |
|---|---|---|---|
| Home *Highlights* | union of `system-design-{lang}`, `builders-{lang}`, `technology-{lang}` where `highlight: true` | `order` asc | `.slice(0, 3)` |
| Home *Selected Articles* | `system-design-{lang}` where `featured: true`, plus `getEntry('archive-{lang}', 's3-p2-context-is-the-edge')` | `order` asc for articles, archive entry appended last | — |
| `/system-design` | all `system-design-{lang}` | `order` asc | — |
| `/builders` | all `builders-{lang}` | `order` asc | — |
| `/technology` | all `technology-{lang}` | `order` asc | — |
| `/archive` | all `archive-{lang}`, grouped by series | `seriesNum` desc, `playbook` asc within series | — |

### Why the pinned archive entry is pinned by slug, not by flag

Only one archive entry is meant to appear in *Selected Articles* at any given time. A hypothetical `homePinned` flag would scale linearly with entries (one flag per doc), would need to be exactly-one-true, and would require either a custom schema validation or a convention everyone has to remember. Pinning by explicit slug in `src/pages/{en,fr}/index.astro` gives a single source of truth — to rotate, edit one line — and keeps the schema lean.

### Why three highlights, not N

The design charter calls for density without decorative motion. Three is the point at which the home page gives every visitor the three doors Ahmed wants them to walk through first, without scrolling overwhelm. Four starts to feel like a list; two leaves obvious space. Enforcing via `.slice(0, 3)` is intentional — if a fourth article gets `highlight: true`, it should push an older one out (by raising `order`), not silently append.

## Consequences

- Adding a new highlight = add the article with `highlight: true` and a low `order` in any of the three article lanes. Previous highlights either drop out (if their `order` is now higher than three others) or stay.
- Adding a new *Selected Articles* piece = place the article under `src/content/system-design-{lang}/`, set `featured: true`, appropriate `order`.
- Rotating the pinned archive entry = change the slug string in `src/pages/en/index.astro` and `src/pages/fr/index.astro`.
- Legacy `homePinned`, `showOnHome`, or any similar flag MUST NOT be added to the schema. If a second archive entry ever needs a home slot, widen the home selection logic to accept multiple slugs — do not introduce a new flag.
- The `verify-home` skill asserts that the current highlight and Selected Articles expectations still hold after any change. Run it after touching frontmatter flags, `order` values, or selection logic.

## Alternatives considered

- **Single `home-featured` boolean across both sections.** Rejected — the two sections have different visual weight and different content-type constraints (Selected Articles pulls only from System Design; Highlights pulls from all three article lanes).
- **Explicit arrays in config.** Rejected — would externalise the sort+select logic from the article's own frontmatter, creating a second source of truth to keep in sync.
- **A custom collection for home-page picks.** Rejected — we want the article to carry its own fate; nothing should need to know about home in a second place.

## Related

- Decision log entries: `2026-04-21 — Home highlights as an ordered vertical stack (no carousel)`, `2026-04-21 — Mandatory date frontmatter`.
- `src/content/config.ts` — schema definition, now carries semantic comments pointing here.
- `/verify-home` skill — smoke test against the contract defined above.
