# Linear SOP — Boringsystems Workspace

> Version-controlled doctrine. Updated after each significant workflow change.
> Companion: `github-sop.md` (same folder).
>
> ⚠️ This document contains only stable rules and structures — never board snapshots,
> card IDs, or current issue lists. Those are short-term episodic state and belong in
> `memory/short-term/` or live on the Linear board itself.

---

## Workspace shape

**1 team:** Boringsystems (`BOR`)

**3 projects (fixed):**
| Project | Priority | Domain |
|---|---|---|
| Distribution & Market Exposure | Urgent | LinkedIn, publishing, ecosystem, monetization |
| Coding & Portfolio | High | boringsystems.app, personal-apps, infrastructure |
| Content Creation | High | Articles, case files, operating playbooks |

**Status workflow (custom):**
```
Triage → [Ahmed routes] → Backlog → Todo → [GTM / Building / Writing / In Progress] → In Review → Done
   ↑                          ↑                                                            ↑           ↑
Claude lands here     Ahmed decides column                                        Claude's terminal  Ahmed's only
  on creation          and project                                                     state         transition
```
- `Triage` = every new card lands here; Ahmed routes it to the right backlog column and project
- `GTM` = strategy/positioning work in flight
- `Building` = coding work in flight
- `Writing` = content work in flight
- `In Progress` = catch-all started state
- `In Review` = Claude's terminal state — awaiting Ahmed's review
- `Canceled` = superseded, out-of-scope, or duplicate
- `Duplicate` = explicitly superseded by another card (leave a pointer in description)

---

## Card creation — what must be in every card

Every card must pass the **self-containment test**: a clean-slate agent with no other context can execute it. Required elements:

1. **Goal** — what done looks like, one paragraph
2. **Why / value** — what problem it solves, what compounds when shipped
3. **Start-from** — concrete current state; verbatim where possible
4. **How (when useful)** — approach, decisions already made, things not to relitigate
5. **All input needed** — every artifact referenced must be durable (committed workspace file, URL, Linear card) or inlined verbatim as a card comment

**What breaks self-containment (never point to these):**
- `tmp/` contents — ephemeral render buffer, wiped at session boundaries
- Short-term memory pending consolidation
- "What we discussed" without codification
- Subagent findings not written down durably
- `.gitignore`d paths

**What is safe to reference:**
- `memory/long-term/`, `memory/medium-term/`, committed workspace docs
- Public URLs
- Other Linear cards
- The card's own comments

---

## Card creation — end-of-turn shape

Every time Claude creates a card, the turn ends with all three:
1. **5-bullet executive summary** — load-bearing decisions, placeholders, open questions. Not a restatement of the body.
2. **Linear card URL** — clickable in chat
3. **`open <url>` via Bash** — auto-launches the card in Ahmed's browser

No opt-in, every time. Mirrors the `/pr` end-of-turn shape.

---

## Card lifecycle — division of states

| Event | Owner | Action |
|---|---|---|
| Card created | Claude | Set status → **Triage**; 5-bullet summary + URL + auto-open |
| Card routed | **Ahmed** | Moves to right Backlog column + assigns project |
| Work begins | Claude | Transition → **In Progress** + starting comment (branch, bundle, handoff point) |
| Work done | Claude | Transition → **In Review** + executive summary comment (delta, carve-outs, follow-ups, PR link) |
| PR merged | **Ahmed** | Transitions to **Done** |

**Done is Ahmed's transition, not Claude's. Triage → Backlog routing is Ahmed's, not Claude's.**

For **bundled cards** (multiple cards on one PR): both cards get the In Progress transition + starting comment, and both get the In Review transition + executive summary. Each card has its own audit trail.

---

## Card creation — multi-deliverable work

Before creating more than one related card, check for an existing **container card pattern** and mirror it.

Container patterns are discovered live via `/card-against-pattern` — the skill searches the team for established shapes (e.g., article series with two articles + diagram in one card). Do not hardcode pattern examples in this document; they drift as the board evolves.

**Steps:**
1. Creating 1 card → no check needed
2. Creating N related cards → run `/card-against-pattern`, check for container shapes
3. Container pattern exists → mirror it; deliverables become sections in one card
4. No container pattern → create siblings with tight cross-references
5. Confirm shape with Ahmed before calling `save_issue`

---

## Rules — do / never do

**Do:**
- Always land new cards in **Triage** — never set Backlog, project, or column on creation
- One card per discrete concern; container card for related multi-deliverable work
- Cards are durable shared state — keep them current; update on state changes
- Cross-reference sibling cards explicitly in bundled work
- Use `get_issue` (not session memory) to audit a card after creation
- Run `/check-linear-card-paths` when renaming workspace files that cards reference

**Never:**
- Set a card's status to anything other than Triage on creation — Ahmed routes
- Transition a card to **Done** — that's Ahmed's
- Point cards at `tmp/` or unconsolidated short-term memory
- Create sibling cards when a container pattern already exists
- Recap card contents in chat after providing the URL — the link IS the recap
- Leave "In Progress" cards stale across sessions without a comment explaining state
- **Embed card IDs, board snapshots, or current issue lists in this document** — that is short-term episodic state; it belongs on the board or in `memory/short-term/`, not here

---

## Limitations and open questions

1. **No labels in use.** Linear supports issue labels but none are applied yet. A label taxonomy (e.g., `infra`, `gtm`, `content`, `harness`, `blocked`) would help filter across projects. Currently relies on project + status for navigation.

2. **No cycles/sprints.** Operating on priority + project only. A fortnightly cycle could help surface what's actually actionable vs. perpetual backlog.

3. **No stale-card protocol.** No rule exists for cards that stay In Progress across multiple sessions without updates. Candidate: reset to Backlog after two Monday consolidations with no new comment.

4. **No PR ↔ card link enforcement.** Claude posts an executive summary comment with the PR link, but this is manual discipline. Linear's GitHub integration could auto-link branches to cards via branch name convention (`omraneah/bor-<N>-...`) — not currently configured.

5. **No archived card review cadence.** Canceled/Duplicate cards accumulate. No periodic review to confirm they shouldn't be revived.
