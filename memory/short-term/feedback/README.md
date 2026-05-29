# Feedback — Staging Area for Behavioural Rules

> **Feedback is a staging area, not a permanent home.** Every rule that lands here must eventually graduate — to a hook, an engineering principle, a SOP, a behavior doc, a long-term governance note, or deletion. Rules that have completed their staging graduate out; this folder stays thin.

---

## The routing tree (graduation paths)

When a rule is ready to graduate, route it to its ONE permanent home:

| Exit | Home | Examples |
|---|---|---|
| **Hook** (automatable, deterministic) | `.agents/git-hooks/` or `.agents/hooks/` | bash-only-scripts (H5), at-import drift (H4), transient-ref (H7) |
| **Engineering principle** | `ENGINEERING-PRINCIPLES.md` (additive) | infrastructure-first, platform-features-first |
| **SOP** (workflow/process protocol) | `docs/agent-ops/workspace-workflow.md`, `docs/agent-ops/github-sop.md`, or `docs/agent-ops/linear-sop.md` | twice-is-a-pattern, verify-before-done, commit-push-no-ask, card-fanout |
| **Behavior doc** (non-automatable communication/behaviour) | `docs/agent-ops/collaboration.md` | exec-summary-first, retry-silently, vocabulary, divergence-check |
| **Long-term governance** | `docs/governance/knowledge-governance.md` (additive) | laptop-agnostic checklist, living-doctrine-append |
| **Delete** | (no home needed) | Rules fully enforced by a live hook or fully subsumed by a promoted SOP |

Rules in this folder are auto-loaded every session. Keep the folder thin — the smaller the surface, the more reliably each rule fires.

---

## What lives here now

Files remaining in `feedback/` are deferred boringsystems-scoped graduations that need a submodule-scoped pass:

- `feedback_tool_comparison_discipline.md` — DEFER: boringsystems article-discipline + minimal-scope discipline.
- `feedback_planning_snapshot_before_flags.md` — DEFER: boringsystems review-skill output shape.

---

## Lifecycle

```
[Surfaced]  ← Ahmed gives the correction or validation
   ↓
[Codified]  ← feedback_*.md written here, usually within the same turn
   ↓
[Held]      ← auto-loaded every session, applied across work
   ↓
[Graduated] ← routed to permanent home, file deleted
```

New rules → write here first. Default to `feedback_<short-name>.md`, snake_case. Include **Why** and **How to apply** so future-Claude can judge edge cases.

---

## Auto-load

Full content of this folder every session. The folder is now flat (no `stable/` or `in-flight/` split).

---

## Where lifecycle history lives after graduation

When a feedback file graduates, the source file is deleted but the per-rule lifecycle is preserved in `memory/decisions/DECISIONS.md` as a lifecycle table in the corresponding decision entry.
