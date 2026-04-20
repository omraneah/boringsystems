# Design Guidelines — Boring Systems

## Principles

**No hacks. Solid, consistent, reliable work.**

Do not work around a design problem by treating languages, pages, or components differently unless there is an explicit, intentional design reason. When something looks wrong in one context, fix the root cause — not the symptom.

---

## Typography

### Font scale

Defined once in `src/styles/global.css`. Never override font sizes per-page or per-language unless there is an explicit design reason documented here.

| Variable | Value | Use |
|---|---|---|
| `--font-display` | Playfair Display, serif | Headings (h1–h6) |
| `--font-body` | Playfair Display, serif | All prose body text |
| `--font-mono` | IBM Plex Mono, monospace | Code blocks only |
| `--font-ui` | Inter, sans-serif | Nav, labels, UI chrome |

### Hero heading size

Both EN and FR hero headings use the same clamp: `clamp(2rem, 5vw, 3rem)`.

**Do not adjust font size per language to compensate for text length.** If a translation is longer, fix the layout — adjust column widths, reduce surrounding whitespace, or shorten the copy. Never use different font sizes across language versions.

### Hero layout

The hero splits into a content column (`flex: 1 1 0`) and a visual column (`flex: 0 0 280px`). Both EN and FR use the same values. The visual column is deliberately sized at 280px (not the original 346px) to give the content column sufficient room for the longer French heading at `3rem`.

If the layout needs to change, change it for both languages simultaneously and document it here.

---

## Color

Defined in `src/styles/global.css` under `:root` (dark mode) and `[data-theme="light"]` (light mode).

Never hardcode color values in component files. Always use CSS variables. Never add inline styles for color.

### Logo

The `flywheel-logo.svg` uses hardcoded `white` fills (correct for dark mode). In light mode, `filter: invert(1)` is applied via CSS in both `index.astro` pages. If the logo changes, update both the SVG and this note.

---

## Language / Theme toggles

Both controls are pill toggles in `Nav.astro` — two options side by side, active one highlighted. Same visual treatment for both. If the toggle design changes, it changes for both language and theme controls together.

---

## Rules

1. If it's broken in one language, it's broken in both — fix it properly.
2. One source of truth per design token. Change it once, it changes everywhere.
3. Do not add per-page CSS overrides to paper over layout problems. Fix the layout.
4. Do not use `!important`.
