---
name: Linear card lifecycle — In Progress on start, In Review on done
description: When Claude works a Linear card, transition to "In Progress" + post a starting comment when work begins; transition to "In Review" + post an executive summary when work is done and Ahmed's interaction is needed. Cards are the shared status surface; chat is ephemeral.
type: feedback
---

When Claude is working a Linear card (or a bundle of cards on a single PR), the card lifecycle is the shared collaboration surface. Treat the card as the durable state record; treat chat as the in-the-moment back-and-forth.

**Lifecycle:**

1. **On start** — transition the card to **In Progress** *and* post a comment with: what's about to happen, the feature branch name, whether bundled with other cards, and the next handoff point ("will return when ready for your review with an executive summary"). Short. One paragraph.
2. **On done, before push or after push** — transition the card to **In Review** *and* post an **executive summary** comment that lets Ahmed react without re-reading the diff. Include: what changed (one-line per file or per concern), what was deliberately not changed (carve-outs), any divergences from the card description, anything that surfaced for follow-up. Link the PR if/when one exists.
3. **Bundled cards** — if multiple cards land on the same PR, both cards get the In Progress transition + starting comment, and both get the In Review transition + executive summary (cross-reference the sibling card in each). One PR is fine; two cards still need two comment threads because each card has its own audit trail.

**Why:** Cards are the durable shared state — Ahmed scans them between sessions, on phone, weeks later. Chat is ephemeral. If the card doesn't reflect the work, the work effectively didn't happen for anyone reading the card. Posting a starting comment also signals "Claude has the lock" — important when a session may bundle related cards.

**How to apply:**

- Default to this lifecycle for any card Claude is actively executing on (not just reading).
- The starting comment is a contract: name the branch, name the bundle, name the handoff point.
- The executive summary is *not* a re-statement of the card description. It's a delta: what *actually* happened relative to the card's intent.
- Never close a card to **Done** without Ahmed's explicit signal. Done is Ahmed's transition, not Claude's. Claude's terminal state is **In Review**.
- If the work surfaces something out-of-scope (renamed file reference, stale link, sibling pattern), mention it in the executive summary; do not silently fix it unless trivially in scope.
- "Cards are durable, chat is ephemeral" applies to push events too: if Claude pushes a branch but doesn't update the card, the push is invisible.
