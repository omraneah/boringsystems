# Target Audiences

Every article on boringsystems is written for a **primary voice target** — the reader whose shoes the piece is written from. Voice target determines the register, the assumed background, and the entry point. It does **not** determine which lane the piece lives in.

**Lane ≠ voice target.** Lanes are content types (thinking pieces vs. past proof vs. live builds vs. long-living doctrine). Voice targets are per-piece calibration. A Writing-lane piece can be addressed to the technical reader or to the builder reader — what makes it a Writing piece is that it's a decision guide / framework / thinking piece, regardless of who it speaks to. Every lane ultimately serves both voice targets; the writer picks the target per piece.

---

## Voice target IDs

| ID | Short name | Primary reader |
|---|---|---|
| `technical` | Technical peers | CTOs, VPs of Engineering, Staff engineers, technical founders. People who run or shape engineering orgs, who have seen multiple stacks ship and die. |
| `builder` | Builders & entrepreneurs | Entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, business operators. People who ship and operate, who make technology decisions without writing it every day. |

These IDs are vocabulary for discussing voice — during reviews, in skill prompts, in the `article-review` report. They do **not** appear in frontmatter.

---

## P1 — `technical` — Senior engineering peers

**Profile.** CTO-level, VP of Engineering, Staff engineers, technical founders. Primarily European (France, Benelux, DACH, UK) but globally applicable. Running or shaping engineering orgs of 5–50 people. Has seen multiple stacks ship and die. Reads to *stress-test* their own thinking, not to learn vocabulary.

**Entry point.** Architecture decisions, trade-off reasoning, post-mortems on non-obvious constraints. Opens an article when the headline names a specific tension they've also felt.

**Needs.**
- Zero hand-holding on concepts. Don't define what a "sidecar" is.
- Specificity over generality — named systems, named failure modes, named constraints.
- Genuine trade-offs, not both-sides-ism. Take a position.

**What turns them off.**
- Generic advice that could have been written by anyone.
- Over-explaining the premise before getting to the insight.
- Vendor shilling, hype cycles, "revolutionary" framing.
- Anything that reads as a gentle introduction to a concept they've lived with for years.

**Conversion path.** None required. Reputation currency only. Their value is that they talk about the work to other senior peers, which is how Ahmed gets referred into rooms he hasn't applied to.

**Writing implications.**
- Headline carries the tension (not the topic).
- Can skip background paragraphs a general reader would need.
- Safe to assume they know what "blast radius", "eventual consistency", "backpressure" mean without restating.
- Invoking named incidents or references (Knight Capital, the S3 outage, CAP, etc.) is load-bearing for them — use them deliberately, not as flavor.
- Where pieces for this voice target typically live: **Work** (case studies — they want to see the decisions and trade-offs), occasionally **Writing** (if the piece is a genuine architecture-level framework).

**French edition (FR).** Engineers in France work in English-tinted French. They read English tech daily, and their working vocabulary for frameworks, infrastructure, tooling, and practice is English. FR content for this voice target must **keep English terms in English** — translating `deploy`, `pipeline`, `framework`, `runtime`, `engineering`, `rollout`, `observability`, `webhook`, etc., makes the content feel written for a general audience, not a peer. See [`french-guide.md`](./french-guide.md) for the full rule.

---

## P2 — `builder` — Entrepreneurs, intrapreneurs, builders

**Profile.** Entrepreneurs, intrapreneurs, solopreneurs, founders without deep engineering background, COOs, Heads of Operations, fractional executives. Makes purchasing, hiring, and stack decisions about technology without writing it every day. Some write code; many don't. What they share is that they *ship and operate* — they run the thing, not just staff a function inside it.

**Entry point.** Business implications + decision guides. "What does this technical decision mean for my company's cost base, runway, competitive position, team structure — and what do I do tomorrow." They click on headlines that translate a technical pattern into an operational consequence, or that promise a defensible decision where they currently feel exposed.

**Needs.**
- Accessible language without condescension. They are not learners — they are decision-makers who don't use the same vocabulary daily.
- Decisiveness. No "it depends" waffle. If it depends, name the two variables and take a position on the common case.
- A through-line from technical choice → operational effect → decision they can make tomorrow.
- Concrete numbers where honest. "Cuts infra cost ~40% in year one" lands; "significant savings" evaporates.
- Cost-awareness. Many of them feel every euro, especially solopreneurs and early-stage founders.

**What turns them off.**
- Pure technical walkthroughs with no business frame.
- Code blocks that don't explain their point.
- Framework-war neutrality. "There are many valid choices" is not helpful to someone shipping next week.
- Jargon dumps that feel like gatekeeping.
- Condescension disguised as teaching.

**Conversion path.** Highest-value for consulting engagements, advisory work, and referrals. A builder who reads two boringsystems articles and forms the "this person is trustworthy on technology calls" impression is the target reader for the consulting funnel. This is also where lead-magnet tails (prompt packs, setup guides, Claude skills) land most naturally.

**Writing implications.**
- Open with the business stake or the decision framing in the first paragraph.
- Code blocks, file trees, and architecture diagrams are allowed — but must be framed with "why this matters to you" before and after.
- Explicit "what this means for you" or "what to do now" sections near the end.
- Where pieces for this voice target typically live: **Writing** (primary — this is the lane where conversion-facing thinking lives), occasionally **Building** (when a stack/tool demonstration is framed for a non-technical operator).

**French edition (FR).** Entrepreneurs, intrapreneurs, and builders in France are English-savvy. They read English business and tech content as a normal part of their work — newsletters, product docs, Twitter/LinkedIn, investor decks. They expect to see `startup`, `MVP`, `pipeline`, `SaaS`, `onboarding`, `growth`, `product`, `marketing`, `sales` in English, and translating those terms reads as condescending — as if the writer assumed they couldn't handle professional vocabulary. **Keep English terms in English.** A brief gloss on first mention is only appropriate for genuinely niche terms — never for common professional vocabulary. See [`french-guide.md`](./french-guide.md) for the full rule.

---

## Lane placement — where does a piece go?

Lane placement is a **content-type** decision, not an audience decision. Ask in order:

1. **Is this a case study / retrospective of real past work Ahmed did for someone?** → `work`.
2. **Is this about current work Ahmed is building now (boringsystems itself, portfolio apps, personal tools, AI-agent orchestration) with live commentary on the decisions?** → `building`.
3. **Is this a long-living principle or playbook — slower-changing, returnable reference material?** → `archive`.
4. **Otherwise — thinking pieces, decision guides, frameworks, tactical advice, diagnosis of a specific question.** → `writing`. (Default. Most pieces land here.)

Lane placement is visible in the URL:

- `writing-{lang}/<slug>.md` → `/{lang}/writing/<slug>`
- `work-{lang}/<slug>.md` → `/{lang}/work/<slug>`
- `building-{lang}/<slug>.md` → `/{lang}/building/<slug>`
- `archive-{lang}/<subfolders>/<slug>.md` → `/{lang}/archive/<slug>` (subfolders are grouping-only; see `constraints.md`)

---

## Cross-voice rules

- **Lane placement is structural.** The content-collection folder is the single source of truth for a piece's lane. No frontmatter flag, no tag — just which folder the file lives in. Move the file to move the lane.
- **Voice target is per-piece calibration.** The writer decides who the piece is addressed to. The `article-review` skill asks for voice target as a review input; it does not check frontmatter for it.
- **Never write for both voice targets simultaneously.** An article that tries to serve a CTO and a non-technical founder in the same voice will fail both. Pick one. Secondary audience is a bonus, not a constraint.
- **Voice target does not dictate topic.** A French-market article on European cloud sovereignty can be framed for either target — the framing changes, the topic doesn't.
- **Same register across voice targets.** The boringsystems voice is constant per `design-charter.md`: constraint-first, short sentences, no hedging. Only the *framing* (technical tension vs. business stake) and the *assumed background* change with voice target.
