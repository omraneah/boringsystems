---
name: declare-ready
description: Pre-handoff declaration — the self-review audit trail before surfacing to Ahmed. Lists skills run and outcomes, what was NOT checked and why, residual risks. The output of this skill IS the handoff artifact. Invoke before any push or before declaring done to Ahmed.
user-invocable: true
model: sonnet
effort: medium
disable-model-invocation: false
allowed-tools: Read, Bash(git diff --stat *), Bash(git diff --name-only *), Grep, Glob
argument-hint: "[optional: branch name or scope to declare ready]"
---

Pre-handoff declaration. Makes Claude's self-review audit trail explicit before surfacing to Ahmed.

Do not announce the skill invocation. Produce the declaration directly.

## When to invoke

**Auto-invoke** before:
- Running `/commit` + `/pr` on any non-trivial change (code change, structural change, new skill/hook).
- Saying "done", "ready for review", "pushed", or equivalent to Ahmed.

**Manual invocation** always valid.

**Skip for:** operational skill runs (`/commit` on a trivial change, `/github-cleanup`, `/tmp-cleanup`) and article context drops (the `/article-review` output already serves as the pre-handoff artifact).

## Steps

1. **Identify the scope.** What branch or set of files is being declared ready? Use `git diff --name-only HEAD` or take the argument.
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

Ready to surface.
```

## Guardrails

- **FIX-level finding not fixed → blocker.** Do not declare ready. Fix it first, re-run the relevant skill, confirm clean, then declare.
- **Checklist skill not run → declare it explicitly.** Silence about a missed skill is worse than naming the gap. If a skill should have run and didn't, name it in "Not checked" with an honest reason.
- If this is the first `/declare-ready` run on a branch and there are items in "Not checked": prompt — "Do you want me to run [skill] before I declare ready?" — before declaring.
- The declaration is not a formality. If writing it surfaces something that should have been fixed, fix it.

## Reference

Per-flow skill checklist: `memory/medium-term/project-management/workspace-workflow.md` §Per-flow skill checklist
