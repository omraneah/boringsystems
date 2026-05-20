# Feedback Layer — Improvement Backlog

Known limitations specific to `memory/short-term/feedback/`. Concerns spanning multiple tiers live in `memory/TODO.md`.

---

## 2026-05-20 consolidation pass (completed)

Six in-flight rules promoted to stable (had crystallized, not tool-specific):
- `feedback_card_fanout_discipline.md`
- `feedback_linear_card_lifecycle.md`
- `feedback_retry_silently_on_transient_platform_errors.md`
- `feedback_living_doctrine_append_not_fork.md`
- `feedback_load_bearing_rules_need_auto_load.md`
- `feedback_no_role_headcount_framing_in_doctrine.md`

Two files deleted (subsumed):
- `feedback_corpus_is_malleable.md` — covered by `META-PRINCIPLES.md`.
- `feedback_context_architecture.md` — architectural decision, belongs in an ADR not feedback.

---

## Crystallization into mid-term SOPs (still pending)

Many files in `stable/` are protocol rules — structured workflows in behavioral-correction form. These should be rewritten as SOP sections in `memory/medium-term/project-management/workspace-workflow.md` rather than staying as individual feedback files.

**How crystallization works:**
1. Identify a feedback file that describes a workflow or protocol (not a constitutional rule).
2. Rewrite it as a structured section in `workspace-workflow.md` — protocol voice, not correction voice.
3. Replace the feedback file body with a one-line pointer: "See `workspace-workflow.md` §[section]."
4. Archive the feedback file during the next audit pass (do not delete immediately — keep pointer in place for one consolidation cycle).

**Crystallization candidates (protocol-shaped → workspace-workflow.md):**

- `stable/feedback_code_change_gate.md` → §Code change flow (gates 1/2/3 already in workspace-workflow.md; this file can point there).
- `stable/feedback_parallel_by_default.md` + `stable/feedback_parallel_agent_recap.md` + `stable/feedback_lane_change_announcement.md` → condense → workspace-workflow.md §Parallel and lane-change protocols.
- `stable/feedback_pr_creation.md` → workspace-workflow.md §PR handoff.
- `stable/feedback_scope_discipline.md` → workspace-workflow.md §Code change flow (max 3 concerns rule).
- `stable/feedback_linear_card_lifecycle.md` → workspace-workflow.md §Card creation flow / Card pickup flow.
- `in-flight/feedback_brief_approval_gate.md` → workspace-workflow.md §Advisory and strategic session flow.
- `in-flight/feedback_model_effort_matrix.md` → workspace-workflow.md §Model and effort defaults (or keep as standalone reference — evaluate).

**Constitutional-shaped → long-term or keep in feedback:**
- `stable/feedback_laptop_agnostic.md` → long-term doctrine (it's an invariant, not a protocol).
- `stable/feedback_collaboration.md` → evaluate: pair-audit with Ahmed.

---

## Article-discipline cluster — candidate for boringsystems crystallization

Six article-shaped feedback files form a cluster that could crystallize into a single `boringsystems/docs/article-discipline.md` section:
- `stable/feedback_always_run_article_review_and_french_audit.md`
- `stable/feedback_boringsystems_articles_en_and_fr.md`
- `in-flight/feedback_article_cross_referencing.md`
- `in-flight/feedback_title_proposals_work_articles.md`
- `in-flight/feedback_no_pricing_in_articles.md`
- `in-flight/feedback_article_capture.md`

Crystallizing them lives in the boringsystems repo, not memory. Defer until a boringsystems-touching session.

---

## File count target

Target: 15-20 total files in `feedback/` (down from 46 as of 2026-05-03; current count after 2026-05-20 pass = ~53 minus 2 deleted = ~51).

Primary mechanism: crystallization (protocols → workspace-workflow.md SOP sections).
Secondary: condensation (related files → single principle).
Tertiary: garbage collection (situation changed, tooling changed, operator changed).

---

## stable/ vs in-flight/ boundary drift

Some in-flight files have been in-flight since April 2026 and are no longer tied to a current situation. During the next audit pass, interrogate every in-flight file: "Is the triggering situation still live?" If not: promote to stable, crystallize, or archive.

Files to interrogate next audit:
- `in-flight/feedback_advisor_brief_craft.md` — tied to a single April incident; verify if still firing or codified into `convene-board` skill.
- `in-flight/feedback_audit_fix_isolation.md` — already encoded in `/audit-fix` skill if it exists; the feedback file may be redundant.
- `in-flight/feedback_batch_permission_for_skill_edits.md` — tied to a permissions UX that may have changed.
- `in-flight/feedback_infrastructure_first.md` — possibly subsumed by `ENGINEERING-PRINCIPLES.md`; consider stub-pointing there.
- `in-flight/feedback_avoid_tool_comparison_decoration.md` + `in-flight/feedback_tool_comparison_categories.md` — different surfaces (scope vs structure) but both about comparison work; consider whether they should live together.
