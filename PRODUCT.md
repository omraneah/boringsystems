# Product

Compact context file for AI design and writing agents. Load this alongside `DESIGN.md` before any UI or copy work. Full audience profiles and voice rules live in `docs/target-audiences.md` and `docs/design-charter.md`.

## Register

brand

## Users

Two voice targets, both engineering-org leaders, read peer-to-peer. Voice target is a per-piece calibration, not a lane assignment. Both targets are English-savvy; FR editions keep English business and tech vocabulary in English.

**Technical peers (`technical`).** CTOs, VPs Engineering, Staff engineers, technical founders. Primarily European. Run or shape engineering orgs of 5–50 people. Read to stress-test their own thinking. Entry point: architecture decisions, trade-off reasoning, post-mortems on non-obvious constraints. Full profile: `docs/target-audiences.md`.

**Builders & entrepreneurs (`builder`).** Entrepreneurs, intrapreneurs, non-technical founders, COOs. Make stack and hiring decisions about technology without writing it daily. Entry point: business implications + decision guides. Full profile: `docs/target-audiences.md`.

## Product Purpose

boringsystems is an engineering leader's case-file archive. Not a marketing site, not a blog. Reads like the inside of a well-run ops dashboard.

Two outcomes:

- **Reputation currency with technical peers.** No conversion required. When a senior engineer reads a piece and decides "this person is trustworthy on technology calls", they refer Ahmed into rooms he hasn't applied to. Value lives in conversations they have, not clicks they make.
- **Consulting funnel via builders.** When an entrepreneur or operator forms the same trust impression across two articles, that's the target reader for advisory and consulting engagements. Lead-magnet tails (prompt packs, setup guides, Claude skills) land most naturally in this lane.

Success is reach × recall, not traffic. A piece that lands in 200 of the right inboxes outperforms one that hits 20,000 of the wrong ones.

## Brand Personality

**Operator-to-operator. Constraint-first. Editorial.**

The reader is a peer, not a prospect. Short sentences. No hedging. Concrete over abstract — named systems, named constraints, named numbers. No filler. No self-congratulation. The work speaks; the article describes the work.

Visual register: editorial-typographic — Playfair Display in body, dense paragraphs, metadata strips that read like a magazine masthead, accent color used as signal not decoration. Reference family: Stratechery, The Browser, Matt Levine's archive. Voice rules: `docs/design-charter.md`.

## Anti-references

What boringsystems must not resemble:

- **Content-creator newsletter.** Substack-default layouts, big author photo, soft cream backgrounds, "Subscribe" as the dominant CTA, paywall teases.

Pattern bans (every page):

- No SaaS landing aesthetics: gradient heroes, testimonial strips, "trusted by 10,000 companies" logo grids, animated hero backgrounds, parallax scroll, floating particles.
- No cookie-cutter author bios with stock-photo headshots.
- No emoji as decoration. Emoji only inside legitimate content quotes.
- No newsletter popups, exit-intent interstitials, or fake urgency.
- No dark-pattern opt-ins. Form checkboxes unchecked by default.
- No giant display quotes ripping sentences out of body. The body prose is the work.

## Design Principles

1. **Constraint-first.** Every visual element earns its place by doing work. If removing it wouldn't be noticed, it shouldn't ship.
2. **Dense.** Information density signals respect for the reader's time.
3. **No decoration without function.** Color is signal, not texture. Borders carry structure. No gradients, no glass, no animated backgrounds.
4. **Practice what you preach.** If an article argues for constraint and density, the page around it must demonstrate constraint and density.

## Accessibility

Best-effort floor:

- Visible focus states on all interactive elements.
- Body text contrast adequate for default-to-good lighting. Dark theme: `--text: #e8e6e1` over `--bg: #0a0a0a`.
- Keyboard-navigable nav and forms.
- `prefers-reduced-motion` honored.
- Both languages get the same a11y treatment; FR is not a downgrade.
