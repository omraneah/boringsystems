---
name: Linear card lifecycle — creation, start, done
description: When Claude creates or works a Linear card, the card lifecycle is the shared collaboration surface. On creation — surface 5-bullet summary + URL + auto-open in browser. On start — In Progress + starting comment. On done — In Review + executive summary. Cards are durable; chat is ephemeral.
type: feedback
---

When Claude creates or works a Linear card (or a bundle of cards on a single PR), the card lifecycle is the shared collaboration surface. Treat the card as the durable state record; treat chat as the in-the-moment back-and-forth.

**Lifecycle:**

1. **On creation** — when Claude creates a card on Ahmed's instruction, end the turn with all three of:
   1. **A 5-bullet executive summary** of what the card captures (one bullet per concern, terse — not a re-statement of the description). Surfaces the load-bearing decisions / placeholders / open questions so Ahmed can react without reading the full body.
   2. **The Linear card URL** clickable in chat.
   3. **`open <url>` executed via Bash in the same turn** so the card launches in Ahmed's default browser automatically.

   No asking, no per-card opt-in — this is the durable default. Mirrors the `/pr` end-of-turn protocol (`feedback_pr_creation.md`). The summary + link in chat is the user-facing artifact; the `open` call is the convenience layer. Both happen, every time.

2. **On start (working an existing card)** — transition the card to **In Progress** *and* post a comment with: what's about to happen, the feature branch name, whether bundled with other cards, and the next handoff point ("will return when ready for your review with an executive summary"). Short. One paragraph.

3. **On done, before push or after push** — transition the card to **In Review** *and* post an **executive summary** comment that lets Ahmed react without re-reading the diff. Include: what changed (one-line per file or per concern), what was deliberately not changed (carve-outs), any divergences from the card description, anything that surfaced for follow-up. Link the PR if/when one exists.

4. **Bundled cards** — if multiple cards land on the same PR, both cards get the In Progress transition + starting comment, and both get the In Review transition + executive summary (cross-reference the sibling card in each). One PR is fine; two cards still need two comment threads because each card has its own audit trail.

**Why:** Cards are the durable shared state — Ahmed scans them between sessions, on phone, weeks later. Chat is ephemeral. If the card doesn't reflect the work, the work effectively didn't happen for anyone reading the card. Posting a starting comment also signals "Claude has the lock" — important when a session may bundle related cards. The creation-time 3-part artifact (summary + URL + auto-open) compresses the moment Ahmed first encounters the card: one click into the browser, five bullets digested before reading the body, no friction.

**How to apply:**

- Default to this lifecycle for any card Claude creates or actively executes on (not just reads).
- **At creation**, the summary is a delta-from-the-body — the 3-5 lines that matter most. Cap at 5 bullets. If you can't fit it in 5, the card is too sprawling.
- **At start**, the starting comment is a contract: name the branch, name the bundle, name the handoff point.
- **At done**, the executive summary is *not* a re-statement of the card description. It's a delta: what *actually* happened relative to the card's intent.
- Never close a card to **Done** without Ahmed's explicit signal. Done is Ahmed's transition, not Claude's. Claude's terminal state is **In Review**.
- If the work surfaces something out-of-scope (renamed file reference, stale link, sibling pattern), mention it in the executive summary; do not silently fix it unless trivially in scope.
- "Cards are durable, chat is ephemeral" applies to push events too: if Claude pushes a branch but doesn't update the card, the push is invisible.

## Companion rules

- `feedback_linear_cards_self_contained.md` (stable) — what the card body must contain at creation time so a clean-slate agent can execute it. The lifecycle rule covers *how to surface* the card after creation; the self-contained rule covers *what to put in* the card before submitting. Both apply at creation.
- `feedback_card_fanout_discipline.md` (in-flight) — before creating multiple cards, check for container patterns and mirror them. Sequence: fan-out check → self-contained content → lifecycle surfacing.
- `feedback_pr_creation.md` (stable) — the 3-part end-of-turn shape (summary + URL + auto-open) for branch pushes. Card creation mirrors it, by design.
