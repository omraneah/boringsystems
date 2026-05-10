---
name: boringsystems
description: An engineering leader's case-file archive. Dense, editorial, operator-to-operator.
colors:
  bg: "#0a0a0a"
  bg-elevated: "#111111"
  border: "#1e1e1e"
  text: "#e8e6e1"
  text-muted: "#6b6b6b"
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
    fontFamily: "Playfair Display, Georgia, serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.7
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

## 1. Overview

**Creative North Star: "The Engineering Leader's Logbook"**

This is the visual register of an operator's archive, not a marketing site. Dense paragraphs of Playfair Display sit on a near-black ground; metadata strips set in Inter line up like a magazine masthead; mono signals where machines speak. Color is signal, not texture. Borders carry structure. Nothing on the page advertises itself before the words do.

The system rejects the SaaS-landing reflex (gradient heroes, testimonial strips, animated backgrounds) and the content-creator-newsletter reflex (cream backgrounds, big author photo, "Subscribe" as the dominant CTA) in equal measure. It is editorial-typographic at the body scale and operator-dense at the layout scale: a magazine-grade reading experience over an internal-tool sense of rhythm.

**Key Characteristics:**
- Editorial-typographic: Playfair body, Inter UI, mono signal — three faces, three jobs.
- Two themes (dark default, light alternate) treated as equally rigorous; neither is decorative.
- Hard-edged. No rounded cards, no shadows, no ambient depth. Borders define rhythm.
- Accent is rare. Aged Brass appears on links, active nav, one emphasized number per page, never on more than ~5% of visible area.
- One container width for body (`--max-content: 680px`), one for chrome (`--max-wide: 1100px`); most content does not need a container at all.

## 2. Colors: The Aged Brass Palette

A near-black ground (`#0a0a0a`) with a single warm-metallic accent. Dark is the default register; the light theme inverts to a warm-paper ground that holds the same restraint.

### Primary
- **Aged Brass** (`#c8a96e` dark / `#8b6914` light): The signal color. Links, active nav state, primary CTAs, the one emphasized metric or pull-quote. The accent is rarity by doctrine: if it covers more than ~5% of any visible area, it is being misused.
- **Brass Patina** (`#8a7248` dark / `#b09050` light): The dim partner — `--accent-dim`. Default border on accented elements, hover outlines on toggles, secondary affordances that haven't been engaged yet.

### Neutral
- **Logbook Black** (`#0a0a0a`): The dark-theme ground. Tinted very slightly off pure black; never `#000`.
- **Logbook Slate** (`#111111`): The elevated dark surface — `--bg-elevated`. Inline code background, lang/theme toggle pressed state, the one-shade-up depth for layered content.
- **Hairline Charcoal** (`#1e1e1e`): The dark-theme border. Almost subliminal, but it carries every structural rule line on the page.
- **Logbook Cream** (`#faf9f7`): The light-theme ground. Warm paper, never pure white.
- **Cream Tint** (`#f0ede8`): The elevated light surface.
- **Hairline Stone** (`#d4cfc9`): The light-theme border.
- **Body Ink** (`#e8e6e1` dark / `#1a1917` light): The primary text color. Tinted toward warm; high contrast without being stark.
- **Margin Ink** (`#6b6b6b` dark / `#706e6a` light): Muted text — metadata, captions, label strips.

### Named Rules

**The Five Percent Rule.** Aged Brass appears on no more than ~5% of any visible area on a page. If it is being used as a tint, a fill, or decoration, it is wrong. The accent is signal: links, the active nav item, one emphasized number, the body-link hover-target color. Nothing more.

**The No-Gradient Rule.** No gradients of any kind. No hero washes, no accent-to-bg fades, no radial glows under headlines, no diagonal stripes that fade to transparent. Flat color, every time.

**The Hairline Rule.** Borders are 1px and the color of `--border`. Borders are how the system carries structure and rhythm; shadows are not allowed to substitute. Anything thicker than 1px, or in any color other than `--border`, must be deliberate and named.

## 3. Typography

**Display Font:** Playfair Display (with Georgia fallback)
**Body Font:** Playfair Display (with Georgia fallback)
**UI Font:** Inter (with system-ui fallback)
**Mono Font:** IBM Plex Mono (with Courier New fallback)

**Character:** Three faces, three non-overlapping jobs. Playfair sets the editorial mood and runs through every body paragraph; Inter handles chrome (nav, buttons, labels); Mono is reserved for things the machine literally said (file paths, command output, IDs). Mixing them outside their job is the single most common visual-system violation.

### Hierarchy
- **Display** (Playfair, 700, 3.5rem, line-height 1.2): Page-level headlines on the home page and lane indexes. Used sparingly; one display element per page maximum.
- **Headline** (Playfair, 700, 2.5rem, 1.2): Article title; primary section openers.
- **Title** (Playfair, 700, 1.75rem, 1.3): Sub-section headers in long articles; card titles on home and lane indexes.
- **Body** (Playfair, 400, 1rem, 1.7): All article body, all index prose. Capped at 65–75ch by the `--max-content: 680px` container.
- **UI** (Inter, 500, 0.875rem): Nav links, buttons, form labels — the system chrome. Letter-spacing 0.02em. Never used inside body.
- **Label** (Inter, 500, 0.75rem, letter-spacing 0.15em, uppercase): Metadata strips, card meta, kicker labels above titles. The closest the system gets to mono-as-signal without actually using mono.
- **Mono** (IBM Plex Mono, 400, 0.875rem): Inline code, file paths, commands, IDs. Used as signal: a paragraph in mono says "this is literally machine output". Never used for emphasis.

### Named Rules

**The Three-Job Rule.** Each typeface has exactly one job. Playfair runs body and headlines; Inter runs nav, buttons, and labels; Mono runs literal machine output. A button in Playfair is wrong. An article paragraph in Inter is wrong. Mono used for emphasis (instead of italic or weight) is wrong.

**The Editor's Italic Rule.** Italics mark titles of external works and genuine semantic emphasis. Not decoration, not tone. If a phrase is italic, it has earned the slant.

**The Bold-Sparingly Rule.** Bold inside body prose is reserved for the one word that would be lost if the reader scanned. Two or three bolds per article is normal. A paragraph with five bolds is wrong.

## 4. Elevation

**Flat-by-default, with two-tone depth via tonal layering.** No shadows. The system has zero `box-shadow` declarations and `--shadow-*` is not a token group. Depth is conveyed through `--bg` (the ground) and `--bg-elevated` (one shade up); structure is conveyed through `--border` hairlines.

This is doctrine. Adding a shadow vocabulary is not an extension; it is a violation. If a future component needs to feel "lifted", lift it with a hairline border or an elevated background, not a drop shadow.

### Named Rules

**The Flat Rule.** Surfaces are flat at rest. Surfaces are flat at hover. Surfaces are flat at active. The only depth in the system is the two-tone `--bg` / `--bg-elevated` distinction, and that is enough.

**The Border-Carries-Structure Rule.** Where a designer would reach for a shadow, the system reaches for a 1px border in `--border`. The border is the structural primitive; the shadow is not in the kit.

## 5. Components

Quiet utility. Components are scaffolding for the body prose; they are not decorative objects in their own right.

### Buttons
- **Shape:** No border-radius. Rectangular. (`rounded.none`)
- **Style:** The system has no canonical "primary button" yet. Affordances that look button-like are the lang/theme toggle and the contact form submit. Both are hairline rectangles in `--border`, body text muted, with the accent color reserved for active state.
- **Hover / Focus:** Border shifts to `--accent-dim`; transition 0.15s on `border-color` only. No fills, no glows.

### Links
- **Body link:** Aged Brass at rest; Body Ink on hover. No underline by default. The hover swap (accent → text) is the entire interaction language.
- **Nav link:** Inter, 500, Margin Ink at rest, Body Ink on hover/active. No underline ever. Letter-spacing 0.02em.

### Cards
- **Article card** (`ArticleCard.astro`): Currently uses a `border-left: 2px solid var(--accent-dim)` accent stripe with `--bg-elevated` fill and `var(--space-md)` internal padding. **This violates the Hairline Rule and the side-stripe ban (see Don'ts).** Any future card variant must use a full hairline border in `--border` or no border at all, and must not lean on a colored stripe to identify itself.
- **Corner Style:** None. No radius, no rounding.
- **Internal Padding:** `var(--space-md)` (1.5rem).

### Inputs
- **Style:** Hairline border in `--border`, no fill, no radius, body text in `--text`. Focus shifts the border to `--accent-dim`; no glow, no inset shadow, no border thickness change.

### Navigation
- **Style:** Inter, 500, 0.875rem, letter-spacing 0.02em. Margin Ink at rest, Body Ink on hover and active. No underline, no pill background, no divider between items beyond `--space-md` gap.
- **Mobile:** Same vocabulary, tighter `--space-sm` gaps under 768px. No hamburger, no slide-in drawer.

### Toggles (signature)
- **Lang and theme toggles:** Hairline-bordered rectangles with two segments. Each segment is `0.2rem 0.45rem` of padding, Inter Label scale, Margin Ink at rest. The active segment fills with `--bg-elevated` and shifts to Aged Brass; the inactive stays Margin Ink. The whole component is 1px tall with no rounding. This is the operator's two-position switch — no animation, no overshoot.

### Metadata strip
- **Style:** Inter Label scale (0.75rem, weight 500, letter-spacing 0.15em, uppercase) in Margin Ink. Used above article titles, on card meta, on lane index entries. The closest the system gets to a "kicker"; reads as a typeset masthead, not a tag pill.

## 6. Do's and Don'ts

### Do:
- **Do** keep accent usage to ≤5% of visible area on every page. Aged Brass is signal; rarity is the point.
- **Do** use hairline (1px) borders in `--border` to convey structure. Borders are the elevation system.
- **Do** keep each typeface in its one job: Playfair for body and headlines, Inter for nav and labels, Mono for literal machine output.
- **Do** keep both themes (dark default, light alternate) fully maintained. FR is not a downgrade of EN; light is not a downgrade of dark.
- **Do** honor `prefers-reduced-motion`. The system has barely any motion to begin with; a user who turns it off should see no change.
- **Do** cap body line length at 65–75ch via `--max-content: 680px`.

### Don't:
- **Don't** use a `border-left` or `border-right` greater than 1px as a colored accent on cards, list items, callouts, or alerts. The `ArticleCard.astro` 2px brass stripe is a known violation pending fix; no new components may copy that pattern.
- **Don't** introduce gradients of any kind: no hero washes, no accent-to-bg fades, no radial glows, no diagonal stripes. Flat color, every time.
- **Don't** add box-shadows. The system is flat-by-default; depth comes from `--bg` / `--bg-elevated` and structure comes from `--border`.
- **Don't** use `background-clip: text` with a gradient (gradient text is banned outright).
- **Don't** use glassmorphism — no `backdrop-filter: blur` decoratively. The system has no glass surfaces.
- **Don't** ship the SaaS-landing reflex: gradient heroes, stacked "Trusted by 10,000 companies" logos, animated hero backgrounds, parallax scroll effects, floating particles.
- **Don't** ship the content-creator-newsletter reflex: big author photo hero, "Subscribe" as dominant CTA, soft cream gradient backgrounds, paywall teases.
- **Don't** use emoji as decoration. No 🚀. Emoji appear only inside legitimate content quotes.
- **Don't** use newsletter pop-ups, exit-intent interstitials, or fake urgency ("last chance", "limited seats").
- **Don't** restate a heading in the paragraph immediately under it. Every word earns its place.
- **Don't** use em dashes in user-facing UI copy. Use commas, colons, semicolons, periods, or parentheses. (Internal docs may differ; UI copy may not.)
- **Don't** introduce a new color outside this palette. If a new semantic state needs one (success, warning, danger), it must be proposed in this file before it is shipped.
- **Don't** use `#000` or `#fff` anywhere. Every neutral is tinted toward the warm hue family.
- **Don't** rename a published article slug. URLs are stable. The forcing function is on the title side.
