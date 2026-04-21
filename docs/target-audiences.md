# Target Audiences

Every article on boringsystems is written for a **primary** persona and is readable by the other two without condescension. If an article doesn't have a primary persona in mind, it isn't ready to draft.

This document is the source of truth for persona tagging. The `persona` field in content frontmatter uses the IDs defined here.

---

## Persona IDs

| ID | Short name | Role sketch |
|---|---|---|
| `senior-peer` | Senior peers | CTO, VP Eng, Staff — Europe-centric |
| `operator` | Business operators | COO, non-technical founder, Head of Ops |
| `early-builder` | Early-stage builders | 0→1 builders, first technical hires, founder-devs |

Use these IDs verbatim in content frontmatter and when the `article-review` skill asks which persona an article targets.

---

## P1 — `senior-peer` — Senior peers / technical equals

**Profile.** CTO-level, VP of Engineering, Staff engineers. Primarily European (France, Benelux, DACH, UK). Running engineering orgs of 5–50 people. Has seen multiple stacks ship and die. Reads to *stress-test* their own thinking, not to learn vocabulary.

**Entry point.** Architecture decisions, trade-off reasoning, post-mortems on non-obvious constraints. Opens an article when the headline names a specific tension they've also felt.

**Needs.**
- Zero hand-holding on concepts. Don't define what a "sidecar" is.
- Specificity over generality — named systems, named failure modes, named constraints.
- Genuine trade-offs, not both-sides-ism. Take a position.

**What turns them off.**
- Generic advice that could have been written by anyone.
- Over-explaining the premise before getting to the insight.
- Vendor shilling, hype cycles, "revolutionary" framing.

**Conversion path.** None required. Reputation currency only. Their value is that they talk about the work to other senior peers, which is how Ahmed gets referred into rooms he hasn't applied to.

**Writing implications.**
- Headline carries the tension (not the topic).
- Can skip background paragraphs a general reader would need.
- Safe to assume they know what "blast radius", "eventual consistency", "backpressure" mean without restating.
- Invoking named incidents or references (Knight Capital, the S3 outage, CAP, etc.) is load-bearing for them — use them deliberately, not as flavor.

---

## P2 — `operator` — Business operators / non-technical executives

**Profile.** COO, Head of Operations, non-technical founders, fractional executives. Makes purchasing and hiring decisions about technology without writing it. Reads to understand *what they are buying, who to trust, how to evaluate*.

**Entry point.** Business model implications. "What does this technical decision mean for my company's cost base, runway, competitive position, team structure." They click on headlines that translate a technical pattern into an operational consequence.

**Needs.**
- Accessible language without condescension. They are not stupid — they just don't use the same vocabulary daily.
- A through-line from technical choice → operational effect → decision they can make tomorrow.
- Concrete numbers where honest. "Cuts infra cost ~40% in year one" lands; "significant savings" evaporates.

**What turns them off.**
- Pure technical walkthroughs with no business frame.
- Code blocks that don't explain their point.
- Jargon dumps that feel like gatekeeping.

**Conversion path.** Highest-value for consulting engagements and referrals. An operator who reads two boringsystems articles and forms the "this person is trustworthy on technology calls" impression is the target reader for the consulting funnel.

**Writing implications.**
- Open with the business stake in the first paragraph.
- Code blocks and architecture diagrams are allowed but must be framed with "why this matters to you" before and after.
- Explicit "what this means for you" sections near the end.
- Safe to use English infrastructure terms (deploy, pipeline, etc.) — they hear these already. Define them *once* per article only if central.

---

## P3 — `early-builder` — Early-stage operators going technical

**Profile.** 0→1 builders, solo founders who are the first engineer, first technical hires at a non-technical founder's company, founder-devs who have shipped one or two things and are picking the stack for the next. European tilt but global applicable.

**Entry point.** Opinionated decision guides. "What would you do in my position, with my constraints, right now." They click on headlines that sound like someone ahead of them handing down the playbook.

**Needs.**
- Decisiveness. No "it depends" waffle. If it depends, name the two variables and take a position on the common case.
- Clear next steps. If an article outlines a stack, they expect to know which command to run first when they close the tab.
- Cost-awareness. They feel every euro.

**What turns them off.**
- Framework-war neutrality. "There are many valid choices" is not helpful to someone shipping next week.
- Abstractions without recipes.
- Condescension disguised as teaching.

**Conversion path.** Direct users of patterns and tooling. They copy stacks, run setup scripts, share articles with peers. Future lead-magnet tails (prompt packs, setup guides) are most often consumed here.

**Writing implications.**
- The article must stand on its own AND set up the optional email-gated tail gracefully. No bait-and-switch.
- Commands, file trees, and concrete code are load-bearing — include them.
- "If you're in position X, do Y" is the default rhetorical move.

---

## Cross-persona rules

- **Primary persona is mandatory.** No article ships without one in frontmatter.
- **Secondary personas are optional** but named when the article is intentionally dual-purpose (e.g. a playbook that targets `early-builder` primary but intentionally also lands for `operator`).
- **Never write for all three at once.** An article that tries to serve everyone serves no one. The design charter enforces this at review time.
- **Persona does not dictate topic.** A French-market article on European cloud sovereignty can be framed for any of the three — the framing changes, the topic doesn't.
