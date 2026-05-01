# MEMORY INDEX — Tiered v1

> Machine entry. Auto-loaded every turn.
> See `README.md` (sibling) for human governance, conflict rules, drift protocols, consolidation cadence.
> Implements principle #3 (tiered memory) of `META-PRINCIPLES.md`.

---

## SESSION-START PROTOCOL

1. **Read every file in `long-term/` and `long-term/inner-game/`.** These are the north star — identity profile, distilled identity content (including `Path-Doctrine.md` for the 2-3yr sprint shape, `Relational-Architecture.md` for the depth-expansion of the relational North Star). Load fully every session. Weighted highest in routing.
2. **Read every file in `short-term/feedback/stable/` and `short-term/feedback/in-flight/`.** Active behavioural rules — how Claude has been told to operate. Always auto-loads (both sub-folders). Feedback is the live discipline layer; it lives in short-term because Ahmed consolidates on top of it weekly. The `stable/` vs `in-flight/` split is for audit purposes only; both are equally in-scope at runtime.
3. **Read `medium-term/current-arc.md`.** The current-direction snapshot for the re-stabilization phase (July → December 2026). Bridges short-term reality and long-term north star.
4. **Read `short-term/current-arc.md`.** The active 2-month plan (May → end June 2026). Bound to the current-chapter-closing window.
5. **Read `short-term/extraction-os.md`.** Proof-asset extraction discipline (2-month bound, transition-period).
6. **Read all `.md` files in `short-term/<this-week>/` and `short-term/<last-week>/`.** Continuity. Decisions, state, conflicts from the past two weeks.
7. **If today is Monday**, follow `short-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md` — fire `/consolidate-week` if this week's consolidation hasn't been written yet.
8. **Other medium-term files load on demand** when the work touches their topic (positioning, doctrine, project state, etc.).
9. **Do not read `short-term/_archive/`** unless Ahmed explicitly points to a week.

---

## LONG-TERM — North Star

`long-term/I-AM.md` — **centerpiece.** Being-statements with whys, 3–5 year convergence, day-to-day texture, relational architecture, anti-beings, stable preferences, philosophy. Read first.
`long-term/inner-game/Meta-Identity-Constitution.md` — depth-expansion of the I AM (immovable core, strong defaults, conscious trajectory, blind spots, upgrades-in-progress).
`long-term/inner-game/Path-Doctrine.md` — doctrine for the 2–3 year sprint to the North Star. Necessary conditions + Singer-echo (for-others is a valid path) + the single-dimension-trap as anti-pattern. Shape stays open.
`long-term/inner-game/Relational-Architecture.md` — depth-expansion of the I-AM Relational architecture section. Diversity layers, exit protocols, application across domains.
`long-term/inner-game/Trait-Architecture.md` — descriptive read on the wiring underneath the I AM (trait cluster, founder-archetype mismatch, wiring vs. trauma-adaptation, AI-leverage composition, psychological type).

> **Being → Doing → Having.** The long-term tier holds the BEING. The being attracts the rest.

⚠️ Identity-rooted entries are the most likely tier to drift over time because the operator changes. When live conversation contradicts an identity-rooted rule, default to live and surface the divergence. See `long-term/README.md`.

---

## MEDIUM-TERM — Current Direction

`medium-term/current-arc.md` — six-month re-stabilization plan (July → December 2026). Auto-loaded.
`medium-term/current-context.md` — current life-phase context, capability profile, market specifics, re-entry posture. On-demand.
`medium-term/operational-doctrine/` — operational discipline: state regulation, work hygiene, exit triggers, recovery markers, relational altitude, Engagement Validity Filter. On-demand.
`medium-term/market/` — capability-led positioning, market lens, sales-mode tactics, visibility OS. On-demand.
`medium-term/projects/` — project metadata (advisory board composition, etc.). On-demand.
`medium-term/project-management/linear-sop.md` — how we manage Linear: card rules, lifecycle, board structure, active work inventory, known limitations. On-demand.
`medium-term/project-management/github-sop.md` — how we manage GitHub: branch rules, PR division of labor, commit discipline, hooks, submodule workflow, known limitations. On-demand.

The interpretive layer between short-term episodic record and long-term constitutional anchors.

---

## SHORT-TERM — Episodic Running Record + Active Discipline

`short-term/feedback/stable/` — behavioural rules that have crystallized but haven't been promoted to long-term doctrine yet. **Auto-loaded.** Ahmed consolidates on top of these weekly.
`short-term/feedback/in-flight/` — behavioural rules tied to current workflow / specific tooling / recent corrections. **Auto-loaded.**
`short-term/current-arc.md` — active 2-month plan (May → end June 2026). Bound to current-chapter-closing window. Auto-loaded.
`short-term/extraction-os.md` — Proof-asset extraction discipline (2-month bound, transition-period). Auto-loaded.
`short-term/<YYYY-Www>/` — daily entries, ISO week folders. Current + last 3 weeks active.
`short-term/<this-week>/consolidation.md` — created Monday, talks about last week.
`short-term/_archive/` — older weeks. Not auto-read.

Daily entry format: chronological with timestamps. Decisions, state, conflicts. Concise. See `short-term/README.md`.

---

## DRIFT DETECTION (the immune system)

- **`/whence`** — directive. Ahmed asks where Claude pulled a claim from. Claude reports tier + source + bias risk.
- **`/divergence-check`** — proactive. Claude fires on detected frustration / loss-of-fit. Surfaces suspected drift. See `short-term/feedback/in-flight/feedback_fire_divergence_check_on_frustration.md` for trigger conditions.

---

## WEEKLY CONSOLIDATION (the closed loop)

- **`/consolidate-week`** — auto-fires Mondays per `short-term/feedback/in-flight/feedback_consolidate_week_on_monday_session_start.md`. Reads last week's daily entries + feedback, proposes promotions / demotions / drift-flags, Ahmed decides, results recorded in this week's `consolidation.md`.

---

## CONFLICT RESOLUTION (when sources contradict)

Weight order, descending: live conversation > long-term > short-term/feedback > current week > last week > medium-term.

- Low-stakes conflicts: default to live, flag for next consolidation.
- Identity / strategy / north-star conflicts: stop, surface, ask before acting.

Full rules in `README.md`.

---

## REFERENCES

- `META-PRINCIPLES.md` (workspace root) — the tiered-memory principle this folder implements.
- `docs/adr-004-tiered-memory-architecture.md` — the ADR for this architecture (design rationale, alternatives, revisit triggers).
