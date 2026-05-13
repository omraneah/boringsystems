---
name: boringsystems
description: An engineering leader's case-file archive. Dense, editorial, operator-to-operator.
colors:
  bg: "#0a0a0a"
  bg-elevated: "#111111"
  border: "#1e1e1e"
  text: "#d6d2c8"
  text-muted: "#8a8780"
  accent: "#c8a96e"
  accent-dim: "#8a7248"
  bg-light: "#faf9f7"
  bg-elevated-light: "#f0ede8"
  border-light: "#d4cfc9"
  text-light: "#1a1917"
  text-muted-light: "#706e6a"
  accent-light: "#8b6914"
  accent-dim-light: "#b09050"
typography:
  display:
    fontFamily: "Playfair Display, Georgia, serif"
    fontSize: "3.5rem"
    fontWeight: 700
    lineHeight: 1.2
  headline:
    fontFamily: "Playfair Display, Georgia, serif"
    fontSize: "2.5rem"
    fontWeight: 700
    lineHeight: 1.2
  title:
    fontFamily: "Playfair Display, Georgia, serif"
    fontSize: "1.75rem"
    fontWeight: 700
    lineHeight: 1.3
  body:
    fontFamily: "Source Serif 4, Georgia, serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "0.75rem"
    fontWeight: 500
    letterSpacing: "0.15em"
  ui:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 500
  mono:
    fontFamily: "IBM Plex Mono, Courier New, monospace"
    fontSize: "0.875rem"
    fontWeight: 400
rounded:
  none: "0"
  hairline: "2px"
spacing:
  sm: "0.75rem"
  md: "1.5rem"
  lg: "3rem"
  xl: "6rem"
components:
  link-body:
    textColor: "{colors.accent}"
    typography: "{typography.body}"
  link-body-hover:
    textColor: "{colors.text}"
  nav-link:
    textColor: "{colors.text-muted}"
    typography: "{typography.ui}"
  nav-link-active:
    textColor: "{colors.text}"
  inline-code:
    backgroundColor: "{colors.bg-elevated}"
    textColor: "{colors.text}"
    typography: "{typography.mono}"
    rounded: "{rounded.hairline}"
    padding: "0.1em 0.4em"
  label-strip:
    textColor: "{colors.text-muted}"
    typography: "{typography.label}"
  card-article:
    backgroundColor: "{colors.bg-elevated}"
    padding: "{spacing.md}"
  toggle-control:
    backgroundColor: "{colors.bg}"
    textColor: "{colors.text-muted}"
    typography: "{typography.label}"
    padding: "0.2rem 0.45rem"
---

# Design System: boringsystems

Machine-readable token spec. Load alongside `PRODUCT.md` for design/copy work. Narrative rules live in `docs/design-charter.md`.

## Colors

**Aged Brass** (`#c8a96e` dark / `#8b6914` light) — the signal color. Links, active nav, one emphasized metric per page. Five-percent rule: if it covers more than ~5% of any visible area, it is being misused.

Dark ground: `#0a0a0a` (Logbook Black) over `#111111` elevated. Light ground: `#faf9f7` (Logbook Cream). Borders: `#1e1e1e` dark / `#d4cfc9` light.

**Body text in dark mode is `#d6d2c8`, not pure white.** High contrast ratios over near-black grounds cause halation — letterforms glow and shimmer, fatiguing eyes during long reads (especially at night). The current value sits at ~11:1 contrast — safely above the WCAG 4.5:1 floor, well below the halation threshold. Muted text is `#8a8780` — tuned to the new body level. Never raise body text toward `#fff` for "more contrast"; that direction makes legibility worse, not better.

No gradients. No `#000` or `#fff`. No shadows.

## Typography

Four faces, four non-overlapping jobs:

| Face | Job |
|---|---|
| Playfair Display | Headlines only (h1–h3, display) — editorial weight at 32px+ |
| Source Serif 4 | Body prose — screen-optimized text serif, opsz 8..60 |
| Inter | Nav, buttons, labels, form chrome — never in body |
| IBM Plex Mono | Code, file paths, IDs — signal, not texture |

**Playfair Display is never used below 32px.** It is a high-contrast didone display face; at body sizes the thin strokes shimmer and tire the eye. Source Serif 4 carries body prose — designed by Adobe for screen reading, optical-size axis tuned per use.

## Elevation

Flat-by-default. No `box-shadow`. Depth via `--bg` / `--bg-elevated` tonal shift. Structure via 1px `--border` hairlines.

## Do's and Don'ts

- No gradients, no shadows, no glassmorphism, no `border-left` accent stripes > 1px
- No SaaS-landing or content-creator-newsletter aesthetics
- No emoji as decoration
- No new colors outside the palette without updating this file
- Never rename a published slug
