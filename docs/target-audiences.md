# Target Audiences

Every article on boringsystems is written for a **primary** persona and is readable by the other without condescension. If an article doesn't have a primary persona in mind, it isn't ready to draft.

This document is the source of truth for persona tagging. The `persona` field in content frontmatter uses the IDs defined here. The site's navigation lanes (`Engineering`, `Entrepreneurs`, `Essays`) are the visible expression of these personas — `Engineering` serves `technical`, `Entrepreneurs` serves `operator`, and `Essays` cross-cuts.

---

## Persona IDs

| ID | Short name | Lane | Role sketch |
|---|---|---|---|
| `technical` | Technical peers | Engineering | CTO, VP Eng, Staff engineers, technical founders |
| `operator` | Entrepreneurs & operators | Entrepreneurs | Entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, business operators |

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
- Lives primarily in the **Engineering** lane.

---

## P2 — `operator` — Entrepreneurs, intrapreneurs, operators

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

**Conversion path.** Highest-value for consulting engagements, advisory work, and referrals. An operator who reads two boringsystems articles and forms the "this person is trustworthy on technology calls" impression is the target reader for the consulting funnel. This is also where lead-magnet tails (prompt packs, setup guides, Claude skills) land most naturally.

**Writing implications.**
- Open with the business stake or the decision framing in the first paragraph.
- Code blocks, file trees, and architecture diagrams are allowed — but must be framed with "why this matters to you" before and after.
- Explicit "what this means for you" or "what to do now" sections near the end.
- Safe to use English infrastructure and business terms (deploy, pipeline, startup, framework, MVP, etc.) — they hear these already. Define them *once* per article only if central.
- Lives in the **Entrepreneurs** lane.

---

## Cross-persona rules

- **Primary persona is mandatory.** No article ships without one in frontmatter. The `article-review` skill enforces this.
- **Lane assignment follows persona.** `technical` → Engineering lane; `operator` → Entrepreneurs lane. An article can only sit in one lane.
- **Essays cross-cut.** Freestyle, curiosity-driven pieces (AI, macro, future-of-work) do not need a persona assignment — they serve voice rather than audience. If an essay has a clear primary audience, tag it; otherwise leave `persona` unset and it stays in the Essays lane only.
- **Never write for both personas simultaneously.** An article that tries to serve a CTO and a non-technical founder in the same voice will fail both. Pick one. Secondary audience is a bonus, not a constraint.
- **Persona does not dictate topic.** A French-market article on European cloud sovereignty can be framed for either persona — the framing changes, the topic doesn't.
