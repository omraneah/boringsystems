---
name: Card-Fanout Discipline
description: When creating Linear cards for related multi-deliverable work, check the workspace for existing "container" card patterns (e.g. BOR-23-style article series with multiple sections) and mirror that shape instead of creating sibling cards.
type: feedback
---

Before creating more than one Linear card for related deliverables in the same session, search the team for an existing container card and mirror its shape. Single card with deliverables as sections beats multiple sibling cards.

**Why:** When the same architecture decision produces multiple deliverables (e.g. two articles, one audit + one writeup, a migration + a doc update), one container card with sections is more navigable than N sibling cards. Sibling cards lose the cross-referencing context, scatter the conversation, and require manual cleanup when discovered. This rule was prompted by the 2026-04-26 incident: I created BOR-25 + BOR-26 (two article cards) when BOR-23 — already in the workspace as the established "article series" container shape — should have been mirrored. Cleanup cost: two cancellations + one consolidation card (BOR-27).

**How to apply:**

1. If creating one card → no check needed
2. If creating multiple related cards → grep recent team issues for container shapes (`Article series — …`, `Audit — …`, `Migration — …`, multi-deliverable titles)
3. If a container pattern exists for similar work → mirror the shape with deliverables as sections, in one card
4. If no container pattern exists → create siblings but cross-reference tightly
5. Confirm the proposed shape with Ahmed before firing `save_issue`

The `card-against-pattern` skill enforces this — invoke it (or its logic) before any multi-card Linear operation.

## Container patterns observed

- **BOR-23** — article series with two articles (Writing + Building) + architecture diagram, all in one card
- **BOR-27** — article series mirroring BOR-23, two articles + mermaid diagram in one card

## See also

- `.claude/personal-skills/card-against-pattern/SKILL.md` — the enforcement skill
- `memory/feedback_no_recap_after_link.md` — sister rule on cognitive-load discipline
