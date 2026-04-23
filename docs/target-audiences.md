# Target Audiences

Every article on boringsystems is written for a **primary** persona and is readable by the other without condescension. If an article doesn't have a primary persona in mind, it isn't ready to draft.

This document is the source of truth for persona tagging. The `persona` field in content frontmatter uses the IDs defined here. The site's navigation lanes (`System Design`, `Builders`, `Technology`, `Archive`) are the visible expression of the site's structure — `System Design` serves `technical`, `Builders` serves `builder`, `Technology` cross-cuts, and `Archive` holds long-living playbooks.

The ID `builder` replaced `operator` on the 2026-04-22 layout restructure. Underlying audience (entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, business operators) is unchanged — only the label shifted to emphasise build-posture over job title.

---

## Persona IDs

| ID | Short name | Lane | Role sketch |
|---|---|---|---|
| `technical` | Technical peers | System Design | CTO, VP Eng, Staff engineers, technical founders |
| `builder` | Builders & entrepreneurs | Builders | Entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, business operators — people who ship |

Use these IDs verbatim in content frontmatter and when the `article-review` skill asks which persona an article targets.

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
- Lives primarily in the **System Design** lane.

**French edition (FR).** Engineers in France work in English-tinted French. They read English tech daily, and their working vocabulary for frameworks, infrastructure, tooling, and practice is English. FR content for this persona must **keep English terms in English** — translating `deploy`, `pipeline`, `framework`, `runtime`, `engineering`, `rollout`, `observability`, `webhook`, etc., makes the content feel written for a general audience, not a peer. See [`french-guide.md`](./french-guide.md) for the full rule.

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
- Lives in the **Builders** lane.

**French edition (FR).** Entrepreneurs, intrapreneurs, and operators in France are English-savvy. They read English business and tech content as a normal part of their work — newsletters, product docs, Twitter/LinkedIn, investor decks. They expect to see `startup`, `MVP`, `pipeline`, `SaaS`, `onboarding`, `growth`, `product`, `marketing`, `sales` in English, and translating those terms reads as condescending — as if the writer assumed they couldn't handle professional vocabulary. **Keep English terms in English.** A brief gloss on first mention is only appropriate for genuinely niche terms — never for common professional vocabulary. See [`french-guide.md`](./french-guide.md) for the full rule.

---

## Cross-persona rules

- **Primary persona is mandatory.** No article ships without one in frontmatter. The `article-review` skill enforces this.
- **Lane assignment follows persona.** `technical` → System Design lane; `builder` → Builders lane. An article can only sit in one lane (case files). Technology pieces cross-cut and live in their own lane; Archive holds long-living playbooks regardless of persona.
- **Technology cross-cuts.** Stack, tooling, and pattern pieces don't need a persona assignment — they serve the topic. If a Technology piece has a clear primary audience, tag it; otherwise leave `persona` unset and it stays in the Technology lane only.
- **Never write for both personas simultaneously.** An article that tries to serve a CTO and a non-technical founder in the same voice will fail both. Pick one. Secondary audience is a bonus, not a constraint.
- **Persona does not dictate topic.** A French-market article on European cloud sovereignty can be framed for either persona — the framing changes, the topic doesn't.
