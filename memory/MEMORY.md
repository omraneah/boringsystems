# MEMORY INDEX — Tiered v1

> Machine entry. Auto-loaded every turn.
> See `README.md` (sibling) for human governance, conflict rules, drift protocols, consolidation cadence.
> Implements principle #3 (tiered memory) of `META-PRINCIPLES.md`.

---

## SESSION-START PROTOCOL

1. **Read every file in `long-term/` and `long-term/inner-game/`.** These are the north star — constitutional rules and identity. Load fully every session. Weighted highest in routing.
2. **Read `medium-term/current-arc.md`.** This is the current direction snapshot — bridges short-term reality and long-term north star.
3. **Read all `.md` files in `short-term/<this-week>/` and `short-term/<last-week>/`.** Continuity. Captures decisions, state, conflicts from the past two weeks.
4. **If today is Monday**, follow `long-term/feedback_consolidate_week_on_monday_session_start.md` — fire `/consolidate-week` if this week's consolidation hasn't been written yet.
5. **Other medium-term files load on demand** when the work touches their topic.
6. **Do not read `short-term/_archive/`** unless Ahmed explicitly points to a week.

---

## LONG-TERM — North Star

`long-term/` — constitutional rules, identity, durable behavioural discipline.
`long-term/inner-game/` — distilled identity content from llm-context.

⚠️ Identity-rooted entries are the most likely tier to be stale. When live conversation contradicts an identity-rooted rule, default to live and surface the divergence. See `long-term/README.md` for the asymmetric conflict rule.

---

## MEDIUM-TERM — Current Direction

`medium-term/` — current positioning, doctrine, project arcs, evolving workflow conventions.
`medium-term/market/` — distilled market doctrine from llm-context.
`medium-term/current-arc.md` — the live snapshot. Updated during weekly consolidation.

The interpretive layer. Reads short-term experience, articulates what it means for direction, surfaces drift candidates for long-term audit.

---

## SHORT-TERM — Episodic Running Record

`short-term/<YYYY-Www>/` — daily entries, ISO week folders. Current + last 3 weeks active.
`short-term/<this-week>/consolidation.md` — created Monday, talks about last week.
`short-term/_needs-consolidation/` — items pending Ahmed's tier-decision.
`short-term/_archive/` — older weeks. Not auto-read.

Daily entry format: chronological with timestamps. Capture decisions, state, conflicts. Concise. See `short-term/README.md`.

---

## DRIFT DETECTION (the immune system)

- **`/whence`** — directive. Ahmed asks where Claude pulled a claim from. Claude reports tier + source + bias risk.
- **`/divergence-check`** — proactive. Claude fires on detected frustration / loss-of-fit. Surfaces suspected drift. See `long-term/feedback_fire_divergence_check_on_frustration.md` for trigger conditions.

---

## WEEKLY CONSOLIDATION (the closed loop)

- **`/consolidate-week`** — auto-fires Mondays per `long-term/feedback_consolidate_week_on_monday_session_start.md`. Reads last week's daily entries, proposes promotions/demotions/drift-flags, Ahmed decides, results recorded in this week's `consolidation.md`.

---

## CONFLICT RESOLUTION (when sources contradict)

Weight order, descending: live conversation > long-term > current week > last week > medium-term.

- Low-stakes conflicts: default to live, flag for next consolidation.
- Identity / strategy / north-star conflicts: stop, surface, ask before acting.

Full rules in `README.md`.

---

## REFERENCES

- `META-PRINCIPLES.md` (workspace root) — the tiered-memory principle this folder implements.
- `boringsystems/src/content/writing-en/orchestration-principles-that-outlive-the-model.mdx` — published article on the same principles.
