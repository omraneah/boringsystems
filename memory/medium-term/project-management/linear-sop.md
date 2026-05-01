# Linear SOP — Boringsystems Workspace

> Version-controlled doctrine. Updated after each significant workflow change.
> Companion: `github-sop.md` (same folder).

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
Backlog → Todo → [GTM / Building / Writing / In Progress] → In Review → Done
                                                                         ↑
                                                              Ahmed's transition only
```
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

## Card lifecycle — Claude's states vs Ahmed's

| Event | Claude's action |
|---|---|
| Card created | 5-bullet summary + URL + auto-open |
| Work begins | Transition → **In Progress** + starting comment (branch, bundle, handoff point) |
| Work done | Transition → **In Review** + executive summary comment (delta vs card, carve-outs, follow-ups, PR link) |
| PR merged | Claude doesn't touch the card. Ahmed transitions to **Done**. |

**Done is Ahmed's transition, not Claude's.**

For **bundled cards** (multiple cards on one PR): both cards get the In Progress transition + starting comment, and both get the In Review transition + executive summary. Each card has its own audit trail.

---

## Card creation — multi-deliverable work

Before creating more than one related card, check for an existing **container card pattern** and mirror it.

**Known container patterns:**
- `BOR-23` — article series (Writing + Building + diagram) in one card
- `BOR-27` — same shape, different series

**Steps:**
1. Creating 1 card → no check needed
2. Creating N related cards → run `/card-against-pattern`, check for container shapes
3. Container pattern exists → mirror it; deliverables become sections in one card
4. No container pattern → create siblings with tight cross-references
5. Confirm shape with Ahmed before calling `save_issue`

---

## Rules — do / never do

**Do:**
- One card per discrete concern; container card for related multi-deliverable work
- Cards are durable shared state — keep them current; update on state changes
- Cross-reference sibling cards explicitly in bundled work
- Use `get_issue` (not session memory) to audit a card after creation
- Run `/check-linear-card-paths` when renaming workspace files that cards reference

**Never:**
- Transition a card to **Done** — that's Ahmed's
- Point cards at `tmp/` or unconsolidated short-term memory
- Create sibling cards when a container pattern already exists
- Recap card contents in chat after providing the URL — the link IS the recap
- Leave "In Progress" cards stale across sessions without a comment explaining state

---

## Board health — known active work (as of 2026-05-01)

**In Progress / started (needs attention):**
- **BOR-40** — Mixpanel install. Blocks BOR-41. Needs planning Q&A resolved before coding.
- **BOR-41** — SEO/AEO hygiene. Blocked on BOR-40.
- **BOR-29** — Deep audit long/medium-term memory. CRITICAL identity-reshaping risk — do not execute without full context.
- **BOR-30** — Tiered memory v1 follow-up refinements. Dependent on BOR-29.
- **BOR-32** — Feedback audit: promote stable → doctrine, condense in-flight.

**GTM backlog (active strategy lane):**
- **BOR-42** — Leader-builder thesis voice consolidation across LinkedIn + boringsystems
- **BOR-13** — LinkedIn distribution strategy
- **BOR-20** — Voice-target personas + reader-facing tag dimension (deferred until signal)

**Deferred but durable:**
- **BOR-37** — Engagement-shapes signal check (due 2026-06-15)
- **BOR-36** — BOR-24 follow-ups (4 items: status-line, /check-constraints on schedule, hook review, skill consolidation)
- **BOR-27** — Article series: model × effort × lane
- **BOR-23** — Article series: AI advisory board
- **BOR-31** — Building case file: tiered-memory v1
- **BOR-16** — AI-Native Builder Starter Prompt lead-magnet
- **BOR-21** — GTM session wrap-up improvements
- **BOR-15** — Ecosystem navigation strategy (French market, face-to-face)
- **BOR-14** — Publishing strategy (cross-channel content architecture)
- **BOR-22** — /work-with-me deferred improvements
- **BOR-19** — Apply CLAUDE.md + docs/ pattern to personal-apps
- **BOR-18** — /split-claude skill

---

## Limitations and open questions

1. **No labels in use.** Linear supports issue labels but none are applied yet. A label taxonomy (e.g., `infra`, `gtm`, `content`, `harness`, `blocked`) would help filter across projects. Currently relies on project + status for navigation.

2. **No cycles/sprints.** Operating on priority + project only. A fortnightly cycle could help surface what's actually actionable vs. perpetual backlog — currently every non-Done card looks equally viable.

3. **In Progress drift.** BOR-29, BOR-30, BOR-32 have been In Progress since April 28 with no recent activity. No SLA or stale-card protocol exists. Candidate rule: if a card stays In Progress across two Monday consolidations without a new comment, reset to Backlog.

4. **No PR ↔ card link enforcement.** Claude posts an executive summary comment with the PR link, but this is manual discipline. Linear's GitHub integration could auto-link branches to cards via branch name convention (`omraneah/bor-<N>-...`) — not currently configured.

5. **No archived card review cadence.** Canceled/Duplicate cards accumulate. No periodic review to confirm they shouldn't be revived.
