# MEMORY INDEX — Tiered v1

> Machine entry. Auto-loaded every turn.
> See `README.md` (sibling) for human governance, conflict rules, drift protocols, consolidation cadence.
> Implements principle #3 (tiered memory) of `META-PRINCIPLES.md`.

---

## SESSION-START PROTOCOL

1. **Read every file in `long-term/` and `long-term/inner-game/`.** These are the north star — identity profile and distilled identity content. Load fully every session. Weighted highest in routing.
2. **Read every file in `medium-term/feedback/stable/` and `medium-term/feedback/in-flight/`.** Active behavioural rules — how Claude has been told to operate. Always auto-loads (both sub-folders), even though the rest of medium-term is on-demand. Feedback is the live discipline layer. The `stable/` vs `in-flight/` split is for audit purposes only; both are equally in-scope at runtime.
3. **Read `medium-term/current-arc.md`.** The current-direction snapshot — bridges short-term reality and long-term north star.
4. **Read all `.md` files in `short-term/<this-week>/` and `short-term/<last-week>/`.** Continuity. Decisions, state, conflicts from the past two weeks.
5. **If today is Monday**, follow `medium-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md` — fire `/consolidate-week` if this week's consolidation hasn't been written yet.
6. **Other medium-term files load on demand** when the work touches their topic (positioning, doctrine, project state, etc.).
7. **Do not read `short-term/_archive/`** unless Ahmed explicitly points to a week.

---

## LONG-TERM — North Star

`long-term/` — identity profile and distilled identity content. Slow to change.
`long-term/inner-game/` — distilled identity-constitution content from llm-context.

⚠️ Identity-rooted entries are the most likely tier to drift over time because the operator changes. When live conversation contradicts an identity-rooted rule, default to live and surface the divergence. See `long-term/README.md`.

Note: behavioural rules (the `feedback_*` files) used to live here; they are now in `medium-term/feedback/` because feedback is by nature temporary — it gets condensed or promoted over time.

---

## MEDIUM-TERM — Current Direction + Active Discipline

`medium-term/feedback/stable/` — behavioural rules that have crystallized but haven't been promoted to long-term doctrine yet. Auto-loaded.
`medium-term/feedback/in-flight/` — behavioural rules tied to current workflow / specific tooling / recent corrections. Auto-loaded.
`medium-term/current-arc.md` — the live snapshot of where Ahmed is heading right now. Updated during weekly consolidation.
`medium-term/market/` — distilled market doctrine.
`medium-term/` (root) — positioning, project arcs, evolving conventions. Loaded on demand.

The interpretive layer between short-term episodic record and long-term constitutional anchors.

---

## SHORT-TERM — Episodic Running Record

`short-term/<YYYY-Www>/` — daily entries, ISO week folders. Current + last 3 weeks active.
`short-term/<this-week>/consolidation.md` — created Monday, talks about last week.
`short-term/_needs-consolidation/` — items pending Ahmed's tier-decision.
`short-term/_archive/` — older weeks. Not auto-read.

Daily entry format: chronological with timestamps. Decisions, state, conflicts. Concise. See `short-term/README.md`.

---

## DRIFT DETECTION (the immune system)

- **`/whence`** — directive. Ahmed asks where Claude pulled a claim from. Claude reports tier + source + bias risk.
- **`/divergence-check`** — proactive. Claude fires on detected frustration / loss-of-fit. Surfaces suspected drift. See `medium-term/feedback/in-flight/feedback_fire_divergence_check_on_frustration.md` for trigger conditions.

---

## WEEKLY CONSOLIDATION (the closed loop)

- **`/consolidate-week`** — auto-fires Mondays per `medium-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md`. Reads last week's daily entries, proposes promotions / demotions / drift-flags, Ahmed decides, results recorded in this week's `consolidation.md`.

---

## CONFLICT RESOLUTION (when sources contradict)

Weight order, descending: live conversation > long-term > medium-term/feedback > current week > last week > rest of medium-term.

- Low-stakes conflicts: default to live, flag for next consolidation.
- Identity / strategy / north-star conflicts: stop, surface, ask before acting.

Full rules in `README.md`.

---

## REFERENCES

- `META-PRINCIPLES.md` (workspace root) — the tiered-memory principle this folder implements.
- `boringsystems/src/content/writing-en/orchestration-principles-that-outlive-the-model.mdx` — published article on the same principles.
