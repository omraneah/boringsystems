# Memory — Improvement Backlog

Known limitations and next-step improvements in the memory architecture. Concerns spanning multiple tiers live here; concerns specific to a sub-folder live in that folder's own `TODO.md`.

This file uses the workspace TODO.md convention: improvement notes placed close to where the problem exists, at the parent folder level.

---

## Feedback crystallization path (high priority)

`short-term/feedback/` holds 46 behavioral rules. Many are actually structured protocols disguised as behavioral corrections — they belong in mid-term SOPs, not as individual feedback files.

The crystallization path: short-term/feedback → rewrite as SOP section → place in `medium-term/project-management/workspace-workflow.md` → convert feedback file to thin pointer → archive during next audit pass.

This is the primary work of the BOR-32 audit session. See `short-term/feedback/TODO.md` for the candidate list.

The target is ~15-20 feedback files total (down from 46). The reduction comes from crystallization (protocols → SOP) and condensation (clusters → single principle).

---

## Mid-term scaffolding (medium priority)

The `medium-term/` tier has two structurally different kinds of content:

**Protocol-shaped** (governs every session, auto-load):
- `project-management/workspace-workflow.md`
- `project-management/linear-sop.md`
- `project-management/github-sop.md`

**Context-shaped** (situational, load on demand):
- `current-arc.md`, `current-context.md`
- `operational-doctrine/`
- `market/`
- `projects/`

This distinction is operational today but not formally documented. Over time, as more feedback crystallizes into mid-term, the `project-management/` folder will grow. When it reaches 5+ files, consider whether a dedicated sub-structure is needed.

---

## Conflict resolution order (monitoring)

The weighting order was corrected 2026-05-03: mid-term SOPs now sit above short-term/feedback. Monitor in practice:

- If a SOP entry is over-riding a recent valid Ahmed correction: the feedback rule should likely be promoted to the SOP, not suppressed. Surface the conflict.
- If the order creates unexpected behavior: log it here for the next architecture review.

---

## README folder map (minor)

`memory/README.md` folder map doesn't show `project-management/` as a subfolder of `medium-term/`. Update it when the mid-term structure stabilizes.
