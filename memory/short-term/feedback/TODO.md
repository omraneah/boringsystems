# Feedback Layer — Improvement Backlog

Known limitations specific to `memory/short-term/feedback/`. Concerns spanning multiple tiers live in `memory/TODO.md`.

Decided + executed work lives in `.claude/decisions/DECISIONS.md` (search "2026-05-20"). This file holds only the **remaining backlog**.

---

## Pending — Crystallization candidates (protocol-shaped → workspace-workflow.md)

Files still in feedback that describe a protocol (not a constitutional rule) and should rewrite as SOP sections in `memory/medium-term/project-management/workspace-workflow.md`. Stub-replace then archive after one consolidation cycle.

| Source file | Target section in workspace-workflow.md |
|---|---|
| `stable/feedback_code_change_gate.md` | § Code change flow |
| `stable/feedback_parallel_by_default.md` + `feedback_parallel_agent_recap.md` + `feedback_lane_change_announcement.md` | § Parallel and lane-change protocols (condense) |
| `stable/feedback_pr_creation.md` | § PR handoff |
| `stable/feedback_scope_discipline.md` | § Code change flow (max 3 concerns) |
| `stable/feedback_linear_card_lifecycle.md` | § Card creation flow + § Card pickup flow |
| `in-flight/feedback_brief_approval_gate.md` | § Advisory and strategic session flow |
| `in-flight/feedback_model_effort_matrix.md` | § Model and effort defaults |

## Pending — Constitutional-shaped → long-term or keep in feedback

- `stable/feedback_laptop_agnostic.md` → long-term doctrine candidate (it's an invariant, not a protocol).
- `stable/feedback_collaboration.md` → evaluate: pair-audit with Ahmed.

---

## File count target

Target: 15-20 total files in `feedback/`. Trajectory tracked via `.claude/decisions/DECISIONS.md` (search "2026-05-20" entries).

Primary mechanism: crystallization (protocols → workspace-workflow.md SOP sections).
Secondary: condensation (related files → single principle).
Tertiary: garbage collection (situation changed, tooling changed, operator changed).
