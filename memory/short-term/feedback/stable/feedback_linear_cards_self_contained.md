---
name: Linear cards must be self-contained
description: When Ahmed asks Claude to create a Linear card, every input the next agent needs must live inside the card itself — body or comments — not in ephemeral state. No dangling pointers.
type: feedback
---

# Linear cards must be self-contained

When Ahmed asks Claude to create a Linear card, the card must stand alone. The next agent picking it up — clean slate, no session context, possibly not even in this workspace — must have everything they need inside the card itself.

## Why

Linear cards are durable artifacts that outlive any single Claude session. The agent who eventually executes the card is not the agent who created it, doesn't have the session transcript, and may be a fresh instance with zero shared context. Pointers to state that won't survive — `tmp/`, short-term memory pending consolidation, "what we discussed" without codification, subagent IDs from a closed session — become dangling references that strand the executing agent.

We hit this exactly: a card referenced `tmp/copy-writing.md` (verbatim LinkedIn copy + recruiter transcript) and the file got deleted shortly after. The substrate the card depended on was inaccessible to anyone reading the card afterwards. Ahmed had to ask for an audit-and-repair pass.

This is a guiding principle, not temporary feedback. Every Linear card creation must pass the self-containment test before being submitted.

## How to apply

When creating a Linear card, the description (and comments where length warrants) must include:

1. **Clear goal.** What this card is for. One paragraph that names what *done* looks like.
2. **Why / value.** Why Ahmed asked for this — what problem it solves, what compounds when it's done. The next agent should know whether to push back on the framing.
3. **Start-from.** The current state. Where the work begins, in concrete terms — verbatim where possible.
4. **How (where useful).** Indications of approach, principles, decisions already made, things not to relitigate. Optional but valuable.
5. **All input needed.** Every artifact the next agent will reference — inlined verbatim as comments if it doesn't already live in a durable location. Don't rely on the next agent having any context outside the card.

### What NOT to point to (these break self-containment)

- **`tmp/` contents.** `tmp/` is render buffer; contents wipe at session boundaries and are git-ignored. Anything in `tmp/` that the card needs must be copied verbatim into a card comment before the card is finalized.
- **Short-term memory entries pending consolidation.** Daily entries, this-week files, `_archive/` — these get promoted, demoted, or archived. Card readers in two months won't find them where the card pointed.
- **"What we discussed" without codification.** If a session conversation produced an insight the card relies on, the insight must be inlined in the card, not referenced as *"see prior discussion"* or *"as Camille said earlier."*
- **Anything ignored in git.** If a path is in `.gitignore` or is otherwise ephemeral, it cannot be a card reference. Linear cards travel; local-only state does not.
- **Subagent findings that haven't been written down anywhere durable.** Subagent IDs are session-scoped; their outputs evaporate. If a subagent's analysis informs the card, the analysis goes into the card.

### What IS safe to point to

- Workspace files committed to git: `memory/long-term/`, `memory/medium-term/`, `boringsystems/docs/`, `go-to-market/`, `cross-stack-architecture-starter-pack/`, etc. Durable and version-controlled.
- Live URLs (public websites, public docs).
- Other Linear cards.
- The card's own comments.

## The self-containment test

Before submitting a card, ask: *"If a fresh agent opens this card right now with no other context, can they execute it?"* If any reference would 404 or strand them, fix it — either inline the substrate as a comment, or replace the reference with a durable equivalent.

## Process when creating a card

1. Draft the description with the five components above (goal, why, start-from, how, input).
2. Identify every reference. Classify each: durable (workspace file, URL, Linear) or ephemeral (`tmp/`, short-term, unconsolidated, subagent-only).
3. For every ephemeral reference: copy the substrate verbatim into a card comment, then point the body at the comment instead of the original location.
4. Run the self-containment test mentally before submitting.
5. If Ahmed asks for an audit afterwards, fetch the card fresh (not from session memory) and verify nothing dangles.

## Companion rules

- `feedback_card_fanout_discipline.md` (in-flight) — before creating multiple cards, check for container patterns. Fires first in the creation pipeline.
- `feedback_linear_card_lifecycle.md` (in-flight) — covers the surrounding lifecycle: on creation (5-bullet summary + URL + `open <url>`), on start (In Progress + comment), on done (In Review + summary). The self-contained rule governs *what's in the card*; the lifecycle rule governs *how to surface it*. Both apply at creation.
- `feedback_pr_creation.md` (stable) — the 3-part end-of-turn shape (summary + URL + auto-open in browser) that the card creation surface mirrors.
- `feedback_no_recap_after_link.md` (stable) — once the card exists, the link IS the recap. The 5-bullet creation summary is the bounded exception (because it lands at the same moment as the link, not after it).
- `feedback_promote_tmp_artifacts_before_session_boundary.md` (stable) — adjacent: anything in `tmp/` that should outlive the session must be promoted before the session ends. The self-containment rule is the upstream move — don't create the dependency in the first place when shipping a card.
