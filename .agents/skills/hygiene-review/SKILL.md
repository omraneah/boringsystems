---
name: hygiene-review
description: Pre-commit self-review gate. Runs /check-leaks (--docs surface) to enforce the no-Linear-IDs / no-tmp-refs rule, then scans staged files to determine which project-specific skills must still run before commit. Blocks if leaks exist or required project skills are unresolved. Auto-invoked by /commit on any non-trivial change.
user-invocable: true
model: sonnet
effort: medium
disable-model-invocation: false
allowed-tools: Read, Bash(git diff --cached --name-only *), Bash(git diff --cached *), Bash(git status *), Grep, Glob
argument-hint: "[optional: scope or branch name]"
---

Pre-commit self-review. Run before `/commit` on any non-trivial change.

Do not announce the skill invocation. Produce the review output directly.

## When to invoke

**Auto-invoke** (wired into `/commit`):
- Before any commit that touches more than one file or changes anything in `memory/`, `docs/`, `.claude/`, or a project's `src/`.

**Manual invocation** always valid.

**Skip for:** single-file typo fixes, operational one-liners, `/github-cleanup`, submodule pointer bumps.

## Steps

### Step 1 — Run /check-leaks --docs

Invoke `/check-leaks --docs` on the full workspace. Report its output inline.

If it surfaces any leaks:
- List each violation with file + line.
- **Block.** Do not proceed past this step. Fix leaks first, then re-run.

If it passes:
- Record: `✓ check-leaks --docs — clean`
- Continue.

### Step 2 — Identify staged files and project context

Run `git diff --cached --name-only` to see what's staged.

Classify staged files by project:
- Files under `boringsystems/` → boringsystems project
- Files under `personal-apps/` → personal-apps project
- Files under `memory/`, `.claude/`, root → workspace-level change

### Step 3 — Determine required project skills

For each project with staged files, check whether project-specific skills are required:

**boringsystems:**
- Staged files in `boringsystems/src/` → check if any contain new outbound links (`href=`, `data-track-outbound`, CTA components). If yes → `/analytics-audit` required.
- Staged files in `boringsystems/src/content/` → article content changed. If any FR file changed → `/french-audit` required. `/article-review` recommended.
- Staged files touch `boringsystems/src/` layouts, config, schema, i18n → `/check-constraints` required; `/arch-review` if architectural.

**personal-apps:**
- Structural or routing changes → `/arch-review` required.

**Workspace-level (.claude/, memory/, docs/):**
- New skill or hook added → `/arch-review` recommended.
- Structural change to memory tiers, CLAUDE.md, ENGINEERING-PRINCIPLES.md → `/arch-review` required.

For each required skill:
- State it as required.
- If the skill has not been run yet in this session, run it now or ask Ahmed whether to run it before committing.

### Step 4 — Emit verdict

```
## Hygiene review — [scope]

Leak check:
- /check-leaks --docs: [PASS / BLOCKED — N violations]

Project skills:
- [project]: /[skill]: [run + outcome | required — not yet run | not applicable]
- ...

Verdict: [CLEAR — commit may proceed | BLOCKED — fix items above first]
```

If BLOCKED: list exactly what needs to be fixed or run. Do not pass a blocked review.

## Guardrails

- **Any leak = blocker.** Linear card IDs and tmp/ refs in stable docs block the commit. No exceptions.
- **Required project skill not run = blocker** (unless explicitly deferred by Ahmed with a stated reason).
- **Do not silently skip steps.** If a step cannot be completed (e.g., boringsystems isn't set up), declare why it was skipped.
- **The pre-commit hook enforces this independently at the shell level.** This skill is the Claude-layer audit; the hook is the non-bypassable enforcement. Both must pass.

## Reference

- Stable docs definition and leak patterns: `/check-leaks` skill (Surface A = `--docs`)
- Per-flow skill checklist: `docs/agent-ops/workspace-workflow.md` §Per-flow skill checklist
- Project-specific skills: each project's `CLAUDE.md` §Project-scoped skills
