# Design Charter

The visual, structural, and voice standard for boringsystems. Every article, page, and component is reviewed against this document. The `article-review` skill loads this file before flagging issues.

Personas referenced here (`technical`, `builder`) are defined in [`target-audiences.md`](./target-audiences.md). The site surfaces them through four navigation lanes: **System Design** (serves `technical`), **Builders** (serves `builder`), **Technology** (cross-cuts, topic-led), and **Archive** (long-living playbooks).

---

## Core principle

**Constraint-first. Dense. No decoration without function.**

Every element on the page — a color, a heading weight, a rule line, a whitespace decision — earns its place by doing work. If removing it wouldn't be noticed, it shouldn't have shipped.

boringsystems is an engineering leader's case-file archive. It reads like the inside of a well-run ops dashboard, not like a marketing site.

---

## Voice

- **Operator-to-operator.** The reader is a peer, not a prospect.
- **Short sentences.** Break long ones. One idea per sentence when possible.
- **No hedging.** Take a position. "It depends" is banned unless followed immediately by "here's what it depends on."
- **Concrete over abstract.** Named systems, named constraints, named numbers.
- **No filler.** "As we all know", "at the end of the day", "in today's fast-paced world" — cut on sight.
- **No self-congratulation.** The work speaks. The article describes the work.

Voice calibration per persona lives in [`target-audiences.md`](./target-audiences.md). The register does not change — the framing and the assumed background do.

---

## Typography

Four typefaces do four specific jobs. Mixing them outside their job is the most common charter violation.

| Face | CSS var | Job |
|---|---|---|
| Playfair Display | `--font-display`, `--font-body` | Headlines, body prose of essays and case files. Carries editorial weight. |
| IBM Plex Mono | `--font-mono` | Code, file paths, commands, IDs, metadata that needs to feel machine-native. |
| Inter | `--font-ui` | Nav, buttons, labels, form chrome. Never in body. |

**Rules.**
- Never use Inter for article body. Never use Playfair for buttons or labels.
- Mono is a signal, not a texture. A paragraph typeset in mono says "this is literally machine output or a literal path." Don't use it for emphasis.
- Italics are used for titles of external works and for genuine semantic emphasis. Not for decoration.
- Bold is used sparingly inside body prose — typically for the one word that would be lost if the reader scanned.

---

## Color discipline

Palette from `src/styles/global.css`:

**Dark (default).**
- `--bg: #0a0a0a`, `--bg-elevated: #111111`, `--border: #1e1e1e`
- `--text: #e8e6e1`, `--text-muted: #6b6b6b`
- `--accent: #c8a96e` (warm gold), `--accent-dim: #8a7248`

**Light.**
- `--bg: #faf9f7`, `--bg-elevated: #f0ede8`, `--border: #d4cfc9`
- `--text: #1a1917`, `--text-muted: #706e6a`
- `--accent: #8b6914`, `--accent-dim: #b09050`

**Rules.**
- **Accent is signal.** Use for links, active nav state, primary CTAs, one emphasized metric. If the page has accent color in more than ~5% of the visible area, it's wrong.
- **No gradients.** No hero washes, no accent-to-bg fades, no radial glows. Flat color only.
- **No additional colors.** If a new semantic state needs a color (success, warning, danger), propose it here first.
- **Borders carry structure.** `--border` defines rhythm. Don't substitute shadow for border.

---

## Lanes and layout

The site has four navigation lanes, each with its own voice calibration and layout conventions. Lane is an **audience** or **topic** distinction; layout expectations follow.

### System Design lane (`/en/system-design`, `/fr/system-design`) — peer-facing

Technical case files and system-design pieces for `technical` readers. Dense, peer-to-peer, no hand-holding.
- Playfair throughout body prose. Dense body, no decorative spacing.
- Inline code in mono; code blocks used sparingly — these pieces are about *reasoning*, not walkthroughs.
- Metadata strip at the top: primary persona, read time, publish date. **Publish date and read time are mandatory** for every `case-files` article (EN + FR) — surfaced in frontmatter (`date:` ISO field), rendered in the article header under the subtitle, and also shown on every card that references the piece (home-page featured, `/{lang}/system-design`, `/{lang}/builders`, `/{lang}/case-files`, where `{lang}` is `en` or `fr`). Format in-page: `MMM D, YYYY · N min read` (EN) / `D MMM YYYY · N min de lecture` (FR). Read time is derived from the body; the publish date is the first-merge git date.
- No tables of contents for short pieces (under ~2000 words).
- End with a **one-paragraph crisp takeaway**, not a bulleted summary.
- Voice: skip background paragraphs a general reader would need. Assume vocabulary.

### Builders lane (`/en/builders`, `/fr/builders`) — prospect-facing

Decision guides, founder case files, and builder-framed pieces for `builder` readers. This is the **conversion lane** — reads here are the target audience for consulting engagements and lead-magnet tails.
- Same typography rules as System Design, but voice calibration is different: open with the business stake or the decision, not the technical tension.
- Code blocks and architecture diagrams are allowed but must be framed with "why this matters to you" before and after.
- Explicit "what this means for you" or "what to do now" sections near the end.
- Article tail (email-gated prompt pack, setup guide) lives most naturally here when it fits (see "Article tail" section below).
- Voice: decisive, no both-sides-ism. If trade-offs exist, name them and take a position on the common case.

### Technology lane (`/en/technology`, `/fr/technology`) — topic-led

Tech, stack, and tooling pieces — SaaS primitives, AI-native stacks, pattern breakdowns. Cross-cuts `technical` and `builder` readers when the topic serves both.
- Voice is closer to the metal than System Design, and more opinionated than the case files.
- Code blocks and diagrams are first-class here, not rationed.
- Persona assignment is optional — `persona` frontmatter may be left unset when a piece is genuinely topic-led.

### Archive lane (`/en/archive`, `/fr/archive`) — long-living material

The long-living **Principles & Playbooks** band. Playbooks live at `/{lang}/operating-playbooks/*` URLs (`{lang}` = `en` | `fr`) and are linked from the Archive index. Reads here are for readers returning to source material, not arriving for the first time.
- Longer-form allowed; typography and spacing can breathe more than peer-facing pieces.
- Personal register permitted — still no hedging, still no filler.

### Voice calibration: peer-facing vs prospect-facing

Same register, different framing. Read the persona, then pick the opener:

| | Peer-facing (`technical`) | Prospect-facing (`builder`) |
|---|---|---|
| Opener | Names the technical tension | Names the business stake or decision |
| Background | Skip — assume vocabulary | Define central terms once |
| Trade-offs | Assume the reader will weigh them | Take a position on the common case |
| Closing | Crystallized insight | "What to do now" clarity |
| English jargon in FR | Keep every English technical term in English | Keep every English business/tech term in English |

**French edition note.** Both audiences are English-savvy. Engineers in France work in English-tinted French; entrepreneurs and operators read English business/tech content daily. The FR editions of articles in **both** lanes keep English terms in English — translating `startup`, `MVP`, `pipeline`, `framework`, `engineering`, `product`, `growth`, `onboarding`, etc., is the single most common quality failure and reads as written for a general audience rather than a professional one. Full rule lives in [`french-guide.md`](./french-guide.md).

---

## Article tail (optional, never required)

Some articles — especially `early-builder`-targeted ones — may expose an **email-gated tail**: a prompt pack, a setup script, a Claude skill, a configuration. Rules:

- **The article must stand on its own.** The tail is a bonus, not the payoff. If the article only makes sense when you get the gated content, the article isn't finished.
- **The tail is named and specific.** "Get the setup guide" is fine. "Get more insights" is a red flag.
- **One tail per article maximum.** No sidebar pop-ups, no mid-article interrupts, no exit-intent modals.
- **Tail appears at the natural end of the reading arc**, after the takeaway, not before it.

Implementation of the tail UX is not in this doc's scope — this is the rule, not the mechanism.

---

## What boringsystems is NOT

Explicit anti-patterns. If an article or UI change trends toward any of these, flag it.

- No SaaS landing-page aesthetics (gradient heroes, stacked testimonial strips, "trusted by 10,000 companies" logos).
- No cookie-cutter author bios with stock-photo headshots.
- No "🚀" emoji as decoration. No emoji at all outside legitimate content quotes.
- No "subscribe to my newsletter" popups. No exit-intent interstitials.
- No fake urgency ("last chance", "limited seats").
- No animated hero backgrounds, floating particles, parallax scroll effects.
- No dark-pattern opt-ins. If a form has a checkbox, it is unchecked by default.
- No third-party trackers beyond what is already in place (Vercel Analytics + Speed Insights). Any addition requires a fresh decision.
- No giant display quotes ripping sentences out of the body. The body prose is the work.

---

## Review heuristic

When in doubt, ask: *would I show this to a senior peer whose opinion I respect, without apologizing for any part of it?* If the answer is "yes, but…", cut the "but" and ship without it.
