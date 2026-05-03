---
horizon: medium-term
type: project-management-sop
auto-load: true
last-reviewed: 2026-05-03
---

# Workspace Collaboration Workflow

Cross-project SOP for all collaboration flows between Ahmed and Claude Code. This document governs the whole workspace — not any single project. Project-specific flows (boringsystems article pipeline, analytics gates, etc.) extend these protocols in their own `docs/workflow.md`.

**Auto-loaded every session.** Weighted above `short-term/feedback` in conflict resolution: a crystallized SOP wins over a raw behavioral correction.

---

## Autonomy gradient

Every flow has a defined autonomy level. Knowing it in advance prevents the single biggest failure mode: Claude executing when it should have confirmed, or confirming when it should have just executed.

| Flow | Level | Confirmation required |
|---|---|---|
| Research — narrow lookup | Full-auto | Nothing. Execute and report. |
| Research — open-ended investigation | Plan-confirm | Question scope, sources, output shape, check-in trigger |
| Card creation | Behavioral checklist | Nothing — checklist is structural |
| Card pickup / kickoff | Plan-confirm | Plan declaration before ANY edit |
| Code change | Plan-confirm | Files changing, irreversible decisions, assumptions |
| Structural change | Plan-confirm + ADR | Same as code change + ADR scope |
| Article flow (boringsystems) | See boringsystems workflow | See boringsystems workflow |
| Post-merge cleanup | Full-auto | Nothing — deterministic |

**Level bump triggers (any flow):** an irreversible decision discovered mid-execution → pause, surface, confirm before continuing. Scope expands beyond approved plan → pause, surface.

---

## Per-flow skill checklist

Skills that must run before declaring done. "Build passed" is necessary but not sufficient — skills catch wiring gaps and doc drift the build doesn't.

| Flow | Pre-execution | Before declaring done |
|---|---|---|
| Code change | `/check-constraints` (if structural surface) | `/analytics-audit` (new outbound links/CTAs), `/arch-review` (structural/architectural) |
| Structural change | `/check-constraints` | `/arch-review` |
| Research — open-ended | — | — (output is findings, not code) |
| Card creation | `/card-against-pattern` | Self-containment test (mental — see `memory/medium-term/project-management/linear-sop.md`) |
| Card pickup / kickoff | `/pre-start` | `/declare-ready` |
| New skill or hook | — | `/arch-review` |
| Article flow | — | See boringsystems workflow |

---

## Research flow

**Trigger:** "think with me on X", "investigate Y", "what do you know about Z", "explore this", or any open-ended investigative request.

**Narrow lookup** (specific file, symbol, factual question with a known answer): full-auto. Execute and report. No gate.

**Open-ended investigation:** plan-confirm.

1. **Declare the investigation.** State: what question is being answered, what sources will be checked (web / codebase / docs / memory), expected output shape (synthesis / bulleted findings / comparison), and check-in trigger.
2. **Wait for scope approval.** Ahmed confirms or corrects. Alignment happens before investigation begins.
3. **Investigate.** Use subagents where scope warrants — long web research → `market-strategist`; codebase archaeology → `Explore` agent. Run parallel where independent.
4. **Synthesize.** Long output (>400 words of dense analysis) → `tmp/<name>.md` + reference path. Short output → inline.
5. **Declare done.** What was checked, what was NOT checked (scope boundary), confidence level.

---

## Card creation flow

**Trigger:** Ahmed asks to create a Linear card.

**Autonomy level:** behavioral checklist (no confirmation gate; the checklist is the gate).

1. **Check for container pattern.** Run `/card-against-pattern`. If an existing pattern fits, mirror it.
2. **Draft the card.** Five components required: goal (what done looks like), why (problem being solved), start-from (current state, concrete), how (approach/decisions already made, optional), all inputs needed (every artifact a clean-slate agent needs, inlined verbatim if ephemeral).
3. **Self-containment test.** Classify every reference: durable (workspace file, URL, Linear card) or ephemeral (tmp/, short-term memory, unconsolidated discussion). For every ephemeral reference: inline the substrate as a card comment before submitting.
4. **Submit.** End turn with: 5-bullet executive summary + Linear card URL + `open <url>` via Bash.

See `memory/medium-term/project-management/linear-sop.md` for the full card lifecycle (In Progress → In Review → Done transitions).

---

## Card pickup / kickoff flow

**Trigger:** "start BOR-XX", "let's work on BOR-XX", or Claude picks up a card to execute.

**Autonomy level:** plan-confirm — always, even on detailed cards.

1. **Fetch the card in full.** Read description + all comments. Do not skim.
2. **Verify all path references.** Every file path, skill name, and doc reference in the card — confirm it resolves. If a path has drifted, flag it before proceeding.
3. **Read required docs.** If the card has a start-of-session protocol, follow it exactly. Otherwise: apply the code change gate (read domain docs first per the relevant project's workflow SOP).
4. **Invoke `/pre-start`.** Produce a gated plan artifact: flow type, files changing, decisions requiring confirmation, assumptions, skills to run post-execution.
5. **Transition card to In Progress.** Post a starting comment: branch name, any bundled cards, next handoff point.
6. **Wait for Ahmed's explicit approval** before any edit. Silence is not approval.
7. **Execute** per the approved plan. Mid-execution: if an irreversible decision arises that wasn't in the plan, pause and surface before continuing.

---

## Code change flow

**Applies to:** any non-content file change in any project (layouts, components, config, scripts, deps, hooks, skills). Each project adds project-specific steps — see that project's `docs/workflow.md`.

**Autonomy level:** plan-confirm.

1. **Read context first.** Before writing any plan: read the project's domain docs relevant to the work type. Do not infer from CLAUDE.md alone — CLAUDE.md is a pointer, not the full context.
2. **Invoke `/pre-start`.** Produce a plan artifact: files changing, decisions requiring confirmation, assumptions, skills to run post-execution. Confirm before executing.
3. **Branch.** Create a feature branch: `omraneah/<short-description>`.
4. **Edit.** ≤3 concerns per branch. When a design decision changes mid-edit, update affected docs in the same commit as the code change — never split them.
5. **Verify locally.** Run the project's build command before committing. Don't discover failures at commit time.
6. **Run review skills.** Per the per-flow skill checklist above. Fix all FIX-level findings before declaring done.
7. **Invoke `/declare-ready`.** Explicit pre-handoff declaration before any push.
8. **Commit → PR.** Run `/commit` then `/pr`.
9. **Post-merge cleanup.** Per project-specific workflow SOP.

---

## Structural change flow

For changes to content schema, routing architecture, enforcement tier, or anything that would require an ADR. Extends the code change flow.

**Autonomy level:** plan-confirm + ADR.

1. **Run `/check-constraints` first.** If a conflict surfaces, resolve the constraint before proceeding.
2. **Write an ADR if the decision is hard to reverse.** Threshold: does it affect project structure, a key quality attribute, or would it be painful to undo?
3. **Proceed as code change flow**, referencing the ADR in the commit message.

---

## Cross-workspace conventions

### TODO.md files

Known limitations and improvement backlog items live in `TODO.md` files, placed at the parent folder level of where they apply. If a limitation affects a whole folder, `<folder>/TODO.md`. If it affects a subfolder, the TODO lives at the parent. Content: what's incomplete, what needs improvement, what the next step is. This keeps technical debt visible and co-located with the affected context.

### Workspace root > submodule for principles

When pointing to a principle or protocol, point first to its workspace-root declaration (e.g., this file, `META-PRINCIPLES.md`). Never point only to a submodule. The workspace is the authoritative tier; submodule docs are project-specific extensions.

### Feedback crystallization path

Short-term feedback rules crystallize into mid-term SOPs when they describe a protocol (not just a behavioral correction). The crystallization target is this file. After a rule crystallizes into a section here, the corresponding feedback file becomes a thin pointer and is archived in the next audit pass. See `memory/short-term/feedback/TODO.md` for the candidate list.
