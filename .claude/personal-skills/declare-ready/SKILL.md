---
name: declare-ready
description: Pre-handoff declaration — the self-review audit trail before surfacing to Ahmed. Lists skills run and outcomes, what was NOT checked and why, residual risks. Then transitions the active Linear card to In Review and posts the executive summary. Ahmed must never be asked to review a PR until this skill has completed all steps. The output of this skill IS the handoff artifact.
user-invocable: true
model: sonnet
effort: medium
disable-model-invocation: false
allowed-tools: Read, Bash(git diff --stat *), Bash(git diff --name-only *), Bash(git branch --show-current), Grep, Glob, mcp__claude_ai_Linear__save_issue, mcp__claude_ai_Linear__save_comment, mcp__claude_ai_Linear__get_issue
argument-hint: "[optional: branch name or scope to declare ready]"
---

Pre-handoff declaration. Makes Claude's self-review audit trail explicit, then moves the card and posts the summary. Ahmed is never asked to review until all steps complete.

Do not announce the skill invocation. Produce the declaration directly.

## When to invoke

**Auto-invoke** before:
- Running `/pr` on any non-trivial change (code change, structural change, new skill/hook).
- Saying "done", "ready for review", "pushed", or equivalent to Ahmed.

**Manual invocation** always valid.

**Skip for:** operational skill runs (`/commit` on a trivial change, `/github-cleanup`, `/tmp-cleanup`) and article context drops (the `/article-review` output already serves as the pre-handoff artifact).

## Steps

1. **Identify the scope.** What branch or set of files is being declared ready? Use `git branch --show-current` and `git diff --name-only HEAD` or take the argument.

2. **Check the per-flow skill checklist.** From `memory/medium-term/project-management/workspace-workflow.md` §Per-flow skill checklist: which skills should have run for this flow type?

3. **List skills run.** For each skill that ran post-execution: name, outcome (PASS / PASS WITH WARNINGS / FIX-level findings fixed / finding deferred with explicit reason).

4. **List what was NOT checked.** For every checklist skill that did not run: skill name + reason (`not applicable because…` / `out of scope for this change` / `deferred — [specific reason]`). No silent omissions.

5. **List residual risks.** Anything Ahmed should know before approving. Includes: deferred WARN-level findings, known scope limitations, decisions made under time constraint that could be revisited.

6. **State PR description coverage.** One sentence: "PR description covers [X]. Ahmed attention needed on [Y]." or "No additional attention needed beyond PR description."

7. **Emit the declaration:**

```
## Declare ready — [branch or scope]

Skills run:
- /[skill]: [outcome]
- ...

Not checked:
- /[skill]: [reason]
- ...

Residual risks:
- [risk]: [mitigation or "accepted"]

PR: [covers X. Ahmed attention needed on Y / no additional attention needed]
```

8. **Identify the active Linear card.** Derive it from the branch name (e.g. `omraneah/bor-NN-*` → `BOR-NN`). If the branch name doesn't contain a card identifier, check recent Linear cards in the boringsystems team for one matching the work. If no card is found, skip steps 9–10 and note "No Linear card identified."

9. **Transition the card to In Review** via `mcp__claude_ai_Linear__save_issue` (`state: "In Review"`).

10. **Post executive summary as a card comment** via `mcp__claude_ai_Linear__save_comment`. Format:

```
**In Review** — PR open on branch `[branch-name]`

**What shipped:**
- [bullet per meaningful change — what it does, not what file changed]
- ...

**Carve-outs / deferred:**
- [anything intentionally left out or deferred]

**Ahmed attention needed on:** [specific items requiring decision, or "nothing beyond PR description"]
```

11. **Emit final line:** `Ready to surface. Card moved to In Review.`

## Guardrails

- **FIX-level finding not fixed → blocker.** Do not declare ready. Fix it first, re-run the relevant skill, confirm clean, then declare.
- **Checklist skill not run → declare it explicitly.** Silence about a missed skill is worse than naming the gap. If a skill should have run and didn't, name it in "Not checked" with an honest reason.
- If this is the first `/declare-ready` run on a branch and there are items in "Not checked": offer to run the missing skill before proceeding.
- **Card transition is not optional.** Steps 9–10 are part of the handoff, not a follow-up. If the card cannot be identified or the transition fails, surface the error explicitly — do not silently skip and declare ready anyway.
- The declaration is not a formality. If writing it surfaces something that should have been fixed, fix it.

## Reference

Per-flow skill checklist: `memory/medium-term/project-management/workspace-workflow.md` §Per-flow skill checklist
Card lifecycle: `memory/short-term/feedback/in-flight/feedback_linear_card_lifecycle.md`
