# Design Charter

The visual, structural, and voice standard for boringsystems. Every article, page, and component is reviewed against this document. The `article-review` skill loads this file before flagging issues.

Voice targets referenced here (`technical`, `builder`) are defined in [`target-audiences.md`](./target-audiences.md). The site surfaces content through four navigation lanes, each a distinct **content type** (not an audience split): **Writing** (thinking pieces, decision guides, frameworks — primary lane, most volume), **Work** (past case studies of real engagements), **Building** (current AI-native builds shown live), and **Archive** (long-living playbooks and principles). A piece's voice target is a per-piece calibration decision; its lane is structural (folder = URL = collection).

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

## Titles, descriptions, and slugs

A piece is found, judged, and clicked through three short artifacts before its body ever loads: the **title**, the **description** (subtitle), and the **slug** (URL). Each has its own discipline.

- **Slug = title, by default.** New article slugs are the title kebab-cased — lowercase, em-dashes/colons/commas/apostrophes dropped, spaces replaced with hyphens, repeats collapsed. The forcing function lives on the title side: if the title makes a bad URL, the title is bad. Deviate only with a documented reason. **Never rename a published slug** — inbound URLs (LinkedIn shares, citations, search-engine cache) are stable, breaking them costs more than any rename benefit.
- **Descriptions are audience-calibrated.** A description written for engineers will alienate operators, and vice versa. Match the voice target of the piece (per `target-audiences.md`). Concretely: no engineer-coded jargon (`IDE`, `fresh-machine clone`, `tool-call layer`) in builder-target descriptions; no consumer-soft language in technical pieces. The description appears as the meta description, the lane-card hover, and the LinkedIn preview snippet. Treat it like ad copy with no ad budget.
- **Distill, don't pad.** One or two sentences max, ideally one. The title carries the promise; the description sharpens the angle. If the description repeats the title in different words, cut it.
- **Both surface in the wild.** A bad title or description shows up in places the body never reaches — search results, link previews, RSS readers, screenshots circulated on X. Both are public artifacts in their own right.

The `article-review` skill enforces these as warnings: slug ≠ slugified title, description register ≠ inferred voice target, description repeats title.

---

## Lists vs prose

When the structure of an idea is **a list of three or more items**, write it as a list. When the structure is **flowing argument**, write it as prose. Do not disguise one as the other.

The most common failure on this site: a paragraph that enumerates three or more labelled items separated by colons and periods — *"Short-term: … Mid-term: … Long-term: …"* — pretending to be prose. It reads as a wall and forces the reader to manually parse the structure that should be visible at a glance. This is a defect, not a style choice.

The shape of a properly-listed enumeration:

- **Lead-in sentence**, ending with a colon, that names what's about to be enumerated. *"The work moves through three layers in sequence:"*
- **Bulleted list**, one item per line, each item with a **bold lead-in** for the labelled term, followed by `:` and the expansion. *"**Business first:** vision, GTM…"*
- **Wrap-up sentence**, if any, on its own paragraph after the list — never appended to the last bullet.

When prose is the right call: when the items are not parallel definitions but flowing argument, when there are only two items, when the labels are rhetorical anaphora rather than enumeration. Heuristic for distinguishing: remove the labels mentally and read the descriptions back. If they read as continuous prose, the labels are an enumeration and the structure wants to be a list. If removing the labels breaks the argument, the structure is rhetoric and prose is correct.

The `article-review` skill flags violations as warnings.

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

The site has four navigation lanes, each a distinct **content type** with its own layout conventions. Voice target is a per-piece calibration (see `target-audiences.md`); lane is structural placement.

### Writing lane (`/en/writing`, `/fr/writing`) — primary conversion lane

Thinking pieces, decision guides, frameworks, tactical advice. The calls founders, operators, and builders face — framed, diagnosed, and answered. This is where most new content lands. **Highest volume + primary conversion surface.**
- Playfair throughout body prose. Dense body, no decorative spacing.
- Inline code in mono; code blocks used sparingly — these pieces are about *reasoning*.
- Metadata strip at the top: read time, publish date (both mandatory — see "Dates & read times" below).
- End with a **one-paragraph crisp takeaway**, not a bulleted summary.
- Voice target varies per piece (`technical` or `builder`). See `target-audiences.md` for per-target calibration.
- Article tail (email-gated prompt pack, setup guide) lives most naturally here when the piece targets `builder`.

### Work lane (`/en/work`, `/fr/work`) — past proof

Case studies from real past engagements. What got built, under what constraint, with what trade-offs accepted. **This is proof, not testimonials — the work itself.**
- Same typography rules as Writing.
- Voice target typically `technical` (case studies read peer-to-peer), but a case can be framed for `builder` if the operational story is the point.
- Open with the context and the tension. Close with the outcome and the principle.
- Dates mandatory.

### Building lane (`/en/building`, `/fr/building`) — live AI-native work

Current builds shown live — boringsystems itself, portfolio apps, Claude skills, stack experiments, lead-magnet artifacts. **Evidence the method works in 2026 on modern stacks.** Attracts peer builders who want to see craft, and reassures sponsors who want concreteness.
- Code blocks and diagrams are first-class. The stack is visible.
- Register is active-tense: "I'm building this, here's what I'm deciding."
- Dates mandatory — pieces here are time-stamped by design; they age by convention.

### Archive lane (`/en/archive`, `/fr/archive`) — long-living material

Principles and playbooks. Doctrine layer. Slower-changing than the other three lanes; returnable reference material.
- Longer-form allowed; typography and spacing can breathe.
- Personal register permitted — still no hedging, still no filler.
- No `date` required (pieces here are principles, not time-stamped).
- Grouped on disk under `operating-playbooks/series-{N}-{name}/`; URLs stay flat per `constraints.md`.

### Dates & read times

**Publish date and read time are mandatory** for every article in Writing, Work, and Building collections (EN + FR). Surfaced in frontmatter (`date:` ISO field), rendered in the article header under the subtitle, and shown on every card that references the piece (home-page, lane indexes). Format in-page: `MMM D, YYYY · N min read` (EN) / `D MMM YYYY · N min de lecture` (FR). Read time is derived from the body; publish date is the first-merge git date. Archive (playbooks) does not require `date`.

### Voice calibration: peer-facing vs prospect-facing

Same register, different framing. Picked per-piece based on the intended reader, regardless of lane:

| | Peer-facing (`technical`) | Prospect-facing (`builder`) |
|---|---|---|
| Opener | Names the technical tension | Names the business stake or decision |
| Background | Skip — assume vocabulary | Define central terms once |
| Trade-offs | Assume the reader will weigh them | Take a position on the common case |
| Closing | Crystallized insight | "What to do now" clarity |
| English jargon in FR | Keep every English technical term in English | Keep every English business/tech term in English |

**French edition note.** Both audiences are English-savvy. Engineers in France work in English-tinted French; entrepreneurs and operators read English business/tech content daily. The FR editions of articles across all four lanes keep English terms in English — translating `startup`, `MVP`, `pipeline`, `framework`, `engineering`, `product`, `growth`, `onboarding`, etc., is the single most common quality failure and reads as written for a general audience rather than a professional one. Full rule lives in [`french-guide.md`](./french-guide.md).

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
