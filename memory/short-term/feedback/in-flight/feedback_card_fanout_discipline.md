---
name: Card-Fanout Discipline
description: When creating Linear cards for related multi-deliverable work, check the workspace for existing "container" card patterns (e.g. an article-series card with multiple articles as sections) and mirror that shape instead of creating sibling cards.
type: feedback
---

Before creating more than one Linear card for related deliverables in the same session, search the team for an existing container card and mirror its shape. Single card with deliverables as sections beats multiple sibling cards.

**Why:** When the same architecture decision produces multiple deliverables (e.g. two articles, one audit + one writeup, a migration + a doc update), one container card with sections is more navigable than N sibling cards. Sibling cards lose the cross-referencing context, scatter the conversation, and require manual cleanup when discovered. This rule was prompted by the 2026-04-26 incident: two article sibling cards were created when an existing article-series container card — already in the workspace as the established shape — should have been mirrored. Cleanup cost: two cancellations + one consolidation card.

**How to apply:**

1. If creating one card → no check needed
2. If creating multiple related cards → grep recent team issues for container shapes (`Article series — …`, `Audit — …`, `Migration — …`, multi-deliverable titles)
3. If a container pattern exists for similar work → mirror the shape with deliverables as sections, in one card
4. If no container pattern exists → create siblings but cross-reference tightly
5. Confirm the proposed shape with Ahmed before firing `save_issue`

The `card-against-pattern` skill enforces this — invoke it (or its logic) before any multi-card Linear operation.

## Container patterns observed

- **Article series (canonical shape)** — two articles (Writing + Building) + architecture diagram, all in one card
- **Article series (variant)** — two articles + mermaid diagram; mirrors the canonical shape

## See also

- `.claude/personal-skills/card-against-pattern/SKILL.md` — the enforcement skill
- `memory/short-term/feedback/stable/feedback_linear_cards_self_contained.md` — every card (single or container) must stand alone for a clean-slate agent. Fan-out check fires first; self-contained content fires when each card is being filled in.
- `memory/short-term/feedback/in-flight/feedback_linear_card_lifecycle.md` — the surrounding lifecycle (creation surface, start, done). Apply after the fan-out shape is settled.
- `memory/short-term/feedback/stable/feedback_no_recap_after_link.md` — sister rule on cognitive-load discipline
