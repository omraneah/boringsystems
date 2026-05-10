# Product

## Register

brand

## Users

Two voice targets, both engineering-org leaders read peer-to-peer. Voice target is a per-piece calibration, not a lane assignment. Both targets are English-savvy; the FR editions keep English business and tech vocabulary in English (translating `pipeline`, `MVP`, `framework`, `onboarding` reads as written for a general audience, not professionals). See `docs/target-audiences.md` and `docs/french-guide.md`.

**Technical peers (`technical`).** CTOs, VPs of Engineering, Staff engineers, technical founders. Primarily European (France, Benelux, DACH, UK). Run or shape engineering orgs of 5–50 people. Have shipped multiple stacks. Read to stress-test their own thinking, not to learn vocabulary. Entry point: architecture decisions, trade-off reasoning, post-mortems on non-obvious constraints. Needs zero hand-holding, named systems and constraints, taken positions. Turned off by generic advice, over-explained premises, vendor shilling.

**Builders & entrepreneurs (`builder`).** Entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, COOs, fractional executives. Make stack and hiring decisions about technology without writing it daily. Entry point: business implications + decision guides — "what does this technical decision mean for my company". Needs accessible language without condescension, decisiveness, through-line from technical choice to operational consequence. Turned off by jargon dumps and framework-war neutrality.

## Product Purpose

boringsystems is an engineering leader's case-file archive. Not a marketing site, not a blog. Reads like the inside of a well-run ops dashboard.

Two outcomes:

- **Reputation currency with technical peers.** No conversion required. When a senior engineer reads a piece and decides "this person is trustworthy on technology calls", they refer Ahmed into rooms he hasn't applied to. Value lives in conversations they have, not clicks they make.
- **Consulting funnel via builders.** When an entrepreneur or operator forms the same trust impression across two articles, that's the target reader for advisory and consulting engagements. Lead-magnet tails (prompt packs, setup guides, Claude skills) land most naturally in this lane.

Success is reach × recall, not traffic. A piece that lands in 200 of the right inboxes outperforms one that hits 20,000 of the wrong ones.

## Brand Personality

**Operator-to-operator. Constraint-first. Editorial.**

The reader is a peer, not a prospect. Short sentences. No hedging. Concrete over abstract — named systems, named constraints, named numbers. No filler. No self-congratulation. The work speaks; the article describes the work.

The visual register is **editorial-typographic**: Playfair Display in body, dense paragraphs, metadata strips that read like a magazine masthead, accent color used as signal not decoration. Reference family: Stratechery, The Browser, Matt Levine's archive — long-form text, mature mood, restraint as confidence.

## Anti-references

What boringsystems must not resemble:

- **Content-creator newsletter.** Substack-default layouts, big author photo, soft cream backgrounds, "Subscribe" as the dominant CTA, paywall teases. The personal-brand creator with a Stripe link is a category boringsystems is not. This is an operator's archive, not a creator's funnel.

Pattern bans (apply across every page):

- **No SaaS landing aesthetics.** Gradient heroes, stacked testimonial strips, "trusted by 10,000 companies" logo grids, animated hero backgrounds, parallax scroll, floating particles.
- **No cookie-cutter author bios** with stock-photo headshots.
- **No emoji as decoration.** No "🚀". Emoji only inside legitimate content quotes.
- **No newsletter popups, exit-intent interstitials, or fake urgency.** ("Last chance", "limited seats" — banned.)
- **No dark-pattern opt-ins.** Form checkboxes unchecked by default.
- **No giant display quotes** ripping sentences out of body. The body prose is the work.

## Design Principles

1. **Constraint-first.** Every visual element — color, weight, rule line, spacing decision — earns its place by doing work. If removing it wouldn't be noticed, it shouldn't ship.
2. **Dense.** Information density signals respect for the reader's time. The site reads like an internal review board, not a marketing site.
3. **No decoration without function.** Color is signal, not texture. Borders carry structure, not shadow. No gradients, no glass, no animated backgrounds.
4. **Practice what you preach.** If an article argues for constraint and density, the page around it must demonstrate constraint and density. The site is itself a portfolio piece.

## Accessibility & Inclusion

Best-effort, not formally targeted to a WCAG level. Floor:

- Visible focus states on all interactive elements (links, buttons, form fields).
- Body text contrast adequate for default-to-good lighting on a normal monitor. The dark theme uses tinted neutrals (`--text: #e8e6e1`) over a near-black ground (`--bg: #0a0a0a`) — readable without being stark.
- Keyboard-navigable nav and forms.
- `prefers-reduced-motion` honored. The charter already bans animated heroes and parallax, so the surface area for motion regressions is small.
- Both languages get the same a11y treatment; FR is not a downgrade.

If a future change introduces interactive complexity (a richer form, an interactive diagram, a step-through reader), revisit this floor and consider raising it to formal WCAG 2.1 AA at that time.
