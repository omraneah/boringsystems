# Design Charter

The visual, structural, and voice standard for boringsystems. Every article, page, and component is reviewed against this document. The `article-review` skill loads this file before flagging issues.

Personas referenced here (`technical`, `operator`) are defined in [`target-audiences.md`](./target-audiences.md). The site surfaces them as three navigation lanes: **Engineering** (serves `technical`), **Entrepreneurs** (serves `operator`), and **Essays** (cross-cuts).

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

The site has three navigation lanes, each with its own voice calibration and layout conventions. Lane is an **audience** distinction; layout expectations follow.

### Engineering lane (`/engineering`) — peer-facing

Technical case files and engineering-leadership pieces for `technical` readers. Dense, peer-to-peer, no hand-holding.
- Playfair throughout body prose. Dense body, no decorative spacing.
- Inline code in mono; code blocks used sparingly — these pieces are about *reasoning*, not walkthroughs.
- Metadata strip at the top: primary persona, read time, publish date.
- No tables of contents for short pieces (under ~2000 words).
- End with a **one-paragraph crisp takeaway**, not a bulleted summary.
- Voice: skip background paragraphs a general reader would need. Assume vocabulary.

### Entrepreneurs lane (`/entrepreneurs`) — prospect-facing

Decision guides, founder case files, and operator-framed pieces for `operator` readers. This is the **conversion lane** — reads here are the target audience for consulting engagements and lead-magnet tails.
- Same typography rules as Engineering, but voice calibration is different: open with the business stake or the decision, not the technical tension.
- Code blocks and architecture diagrams are allowed but must be framed with "why this matters to you" before and after.
- Explicit "what this means for you" or "what to do now" sections near the end.
- Article tail (email-gated prompt pack, setup guide) lives most naturally here when it fits (see "Article tail" section below).
- Voice: decisive, no both-sides-ism. If trade-offs exist, name them and take a position on the common case.

### Essays lane (`/essays`) — editorial voice

Freestyle, curiosity-driven pieces on AI, macro, future-of-work, and the larger frame. Cross-cuts both personas — readers come here for voice, not for decisions.
- Longer-form allowed; typography and spacing can breathe more than peer-facing pieces.
- Personal register permitted — still no hedging, still no filler.
- This lane also surfaces **Principles & Playbooks** as a secondary band: the long-living operating playbooks that underpin the site's thinking. Playbooks live at `/operating-playbooks/*` URLs and are linked from the Essays index.

### Voice calibration: peer-facing vs prospect-facing

Same register, different framing. Read the persona, then pick the opener:

| | Peer-facing (`technical`) | Prospect-facing (`operator`) |
|---|---|---|
| Opener | Names the technical tension | Names the business stake or decision |
| Background | Skip — assume vocabulary | Define central terms once |
| Trade-offs | Assume the reader will weigh them | Take a position on the common case |
| Closing | Crystallized insight | "What to do now" clarity |

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
