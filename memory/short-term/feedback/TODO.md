# Feedback Layer — Improvement Backlog

Known limitations specific to `memory/short-term/feedback/`. Concerns spanning multiple tiers live in `memory/TODO.md`.

---

## Crystallization into mid-term SOPs (high priority — BOR-32 work)

Many files in `stable/` are protocol rules — structured workflows in behavioral-correction form. These should be rewritten as SOP sections in `memory/medium-term/project-management/workspace-workflow.md` rather than staying as individual feedback files or being promoted to long-term doctrine.

**How crystallization works:**
1. Identify a feedback file that describes a workflow or protocol (not a constitutional rule).
2. Rewrite it as a structured section in `workspace-workflow.md` — protocol voice, not correction voice.
3. Replace the feedback file body with a one-line pointer: "See `workspace-workflow.md` §[section]."
4. Archive the feedback file during the next audit pass (do not delete immediately — keep pointer in place for one consolidation cycle).

**Crystallization candidates (to verify during BOR-32):**

Protocol-shaped → workspace-workflow.md:
- `stable/feedback_code_change_gate.md` → §Code change flow (gates 1/2/3 are already in workspace-workflow.md as of 2026-05-03; this file can point there)
- `stable/feedback_parallel_by_default.md` + `stable/feedback_parallel_agent_recap.md` + `stable/feedback_lane_change_announcement.md` → condense → workspace-workflow.md §Parallel and lane-change protocols
- `stable/feedback_pr_creation.md` → workspace-workflow.md §PR handoff
- `stable/feedback_scope_discipline.md` → workspace-workflow.md §Code change flow (max 3 concerns rule)
- `in-flight/feedback_brief_approval_gate.md` → workspace-workflow.md §Advisory and strategic session flow
- `in-flight/feedback_linear_card_lifecycle.md` → workspace-workflow.md §Card creation flow / Card pickup flow
- `in-flight/feedback_model_effort_matrix.md` → workspace-workflow.md §Model and effort defaults (or keep as standalone reference — evaluate)

Constitutional-shaped → long-term or keep in feedback:
- `stable/feedback_laptop_agnostic.md` → long-term doctrine (it's an invariant, not a protocol)
- `stable/feedback_corpus_is_malleable.md` → already expressed in META-PRINCIPLES.md; consider archiving the feedback file
- `stable/feedback_collaboration.md` → evaluate: is this still current? Pair-audit with Ahmed

---

## File count target

Target: 15-20 total files in `feedback/` (down from 46 as of 2026-05-03).

Primary mechanism: crystallization (protocols → workspace-workflow.md SOP sections).
Secondary: condensation (related files → single principle).
Tertiary: garbage collection (situation changed, tooling changed, operator changed).

---

## stable/ vs in-flight/ boundary drift

Some in-flight files have been in-flight since April 2026 and are no longer tied to a current situation. During the BOR-32 audit, interrogate every in-flight file: "Is the triggering situation still live?" If not: promote to stable, crystallize, or archive.
