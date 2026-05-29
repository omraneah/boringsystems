# Consolidation — Week 2026-W22 (consolidating 2026-W21)

*Created Friday 2026-05-29. Manual mid-cycle run (testing the upgraded two-lane skill). Also clears a backlog: W18, W20, W21 had no consolidation.md (decay-nag flagged).*

## My consolidation

### HELD memos coming due
- None. `memory/medium-term/held/` does not yet exist (no memos created).

### Promotions proposed (short → medium) [Staged]
- **Sub-agent worktree & branch discipline → graduate into `github-sop.md`.** W21 (05-20) logged four observations: branch new work off `main`, never off an unmerged feature branch; worktree agents leak isolation via absolute paths; `git add -A` sweeps worktree subfolders into the index; submodule pointer drifts during rebase. **These recurred this session** — the stale-base merge conflict (enforcement branch cut pre-#115/#116) and the empty-branch bug (feedback-lane commits landed on the worktree auto-branch, not the pushed feature branch). Twice-is-a-pattern is met. Codify as a rule: sub-agents must `git fetch` then `git checkout -b <branch> origin/main`, use relative paths inside worktrees, and verify the intended feature branch is the one pushed.

### Promotions proposed (medium → long) [Staged]
- None this week.

### Demotions proposed [Staged]
- None.

### Drift flags (live conversation contradicted memory)
- None. W21's logged conflicts (05-20 sloppy rebase) were execution lapses, recovered same session — not memory-vs-live drift.

### Current-arc update proposed [Staged]
- None. W21's direction-shaping work (drivers + filters, two engagement shapes, money targets stripped) was already integrated into `current-arc.md` on 05-20. Within phase.

### Feedback corpus (Step 3b)
- Current count: **2** files (flat staging — `stable/` + `in-flight/` collapsed during the feedback graduation). Target: **≤5**.
- Status: **within target.**
- Both remaining are boringsystems-scoped, deferred to a submodule pass: `feedback_tool_comparison_discipline`, `feedback_planning_snapshot_before_flags`. No workspace graduation this run.

### Mechanical lane (auto — runs after Staged items above are classified)
- Prune W19 dailies (consolidation.md present): `2026-05-05.md`, `2026-05-06.md`, `2026-05-10.md`.
- Prune W21 dailies (after this consolidation.md lands): `2026-05-18.md`, `2026-05-20.md`, `2026-05-26.md`.
- Dedupe: none found.

### Backlog — un-consolidated weeks W18 + W20 [Staged — signal-deleting, needs your call]
- W18 (6 dailies) + W20 (4 dailies) have no consolidation.md. Their signal is already durably captured elsewhere (W18 = tiered-memory restructure → ADRs + decision registry; W20 = starter-pack + leader-builder voice → decision registry + go-to-market). Options: (a) verify-then-prune as already-distilled, or (b) write catch-up stubs then prune. Your call.

## Your decisions

- **All approved** ("do all", 2026-05-29): (1) graduate worktree/branch discipline → `github-sop.md`; (2) W18 + W20 backlog → verify-then-prune (signal already promoted, recoverable via git); (3) Mechanical prune W19 + W21 dailies.

## Actions taken

- [Staged] Graduated **sub-agent worktree & branch discipline** into `github-sop.md` (new section, after Branch naming).
- [Staged] Pruned W18 (6) + W20 (4) raw dailies — signal already in ADRs / decision registry / go-to-market; recoverable via git history.
- [Mechanical] Pruned W19 (3) raw dailies — `consolidation.md` present (digest retained).
- [Mechanical] Pruned W21 (3) raw dailies — this file is the digest.
- Feedback corpus: 2 files, within ≤5 target — no action.
