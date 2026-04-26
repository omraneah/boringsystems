---
name: wrap-session
description: Close out a session after a PR has been merged. Syncs local main, deletes the merged feature branch, stops any dev servers Claude started, and produces a session recap with proposed system improvements (skills, hooks, docs, ADRs, memory, decisions). Trigger automatically when Ahmed says some variant of "merged, pull and delete", "I merged the PR, clean up", "we're done, wrap this up", "go to main and delete the branch", or any phrasing that clearly signals a post-merge cleanup.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git *), Bash(pkill *), Bash(pgrep *), Read, Edit, Write, Glob, Grep
---

Post-merge wrap-up for a session. Runs when Ahmed signals a PR has been merged. Does two jobs in order: git mechanics, then a reflective recap that proposes ways to improve the system.

Do not announce the skill invocation. Just do the work.

## Part 1 — Git mechanics

These run in whichever repo Claude is currently in. If the session spanned multiple repos (e.g. workspace + a submodule), repeat for each.

1. **Identify the feature branch.** `git branch --show-current`. If it's a protected branch (`main`, `master`, `development`, `dev`, `production`), skip to step 5 — nothing to delete.
2. **Check it's merged.** `git fetch origin main` then `git log HEAD..origin/main --oneline` should include the merge commit. If it doesn't, stop and ask Ahmed — the branch isn't actually merged yet.
3. **Switch and sync.** `git checkout main && git pull`.
4. **Delete the feature branch locally** with `git branch -d <branch>`. Never use `-D` — if `-d` refuses, the branch isn't fully merged; report that to Ahmed and do not force-delete.
5. **Stop dev servers Claude started** in this session. `pkill -f "astro dev"`, `pkill -f "next dev"`, `pkill -f "vite"`, or whatever is relevant. Verify with `pgrep`.
6. **Confirm clean state.** `git status -s` should be empty; `git branch --show-current` should be `main`.

## Part 2 — Session recap + improvement proposals

After the git mechanics complete, produce a written recap for Ahmed. Four sections, in order:

### Session recap
Short prose (3–5 short paragraphs, not bullets). What arcs shipped, how they fed each other, what's now live on `main`. Reference the merged branch name and the top-level commit messages.

### What's still in-flight
Anything captured during the session that is not yet done. Linear cards, placeholder assets, TODO-style decisions waiting on Ahmed. Surface each with a short label and pointer.

### Proposed system improvements

Walk the session through these lenses and surface anything worth codifying:

- **Patterns that repeated.** If the same shape of work appeared more than once (e.g. "build infrastructure first, content second"; "every content change needs EN+FR"), propose a skill, a doc section, or a memory entry that captures it.
- **Skills that should exist.** If a checklist was run manually more than twice (build → grep HTML, or "check FR mirror"), propose a new skill. Be explicit about whether it's cross-project (`personal-skills/`) or project-scoped (`<project>/.claude/skills/`).
- **Hooks.** If a behaviour should run automatically on a specific trigger (pre-commit, post-merge, SessionStart), propose a hook in `settings.json`. Real shell hooks, not skill invocations — hooks run deterministically, skills run when Claude decides to invoke them.
- **Architectural Decision Records.** If a non-trivial architectural choice was made (collection shape, redirect strategy, dependency rejection), propose an ADR under `docs/adr-NNN-<topic>.md` in the relevant project. Use 3-sigfig numbering so they sort.
- **Doc updates.** If architecture/toolchain/design docs now misrepresent reality, flag the exact file and line.
- **Memory entries.** Feedback/project/reference memories that capture what Claude should carry into future sessions. Use the shapes defined in the auto-memory system prompt — do not invent new types.
- **Decisions to log.** Anything that belongs in `.claude/decisions/DECISIONS.md` via the `/log-decision` skill. Give each a concrete title + one-line context.

For each improvement, state clearly: **(a)** what it is, **(b)** where it lives, **(c)** why it earns its place (the return, not the activity).

### What I'd do first

Pick the single highest-leverage improvement and name it. Do not list multiple recommendations — force a choice. Explain in one sentence why it compounds more than the others. Then ask Ahmed which items he wants implemented *now* vs. parked.

## Guardrails

- **Never force-delete a branch.** `git branch -d` only. If it refuses, investigate and report — do not overrule.
- **Never push to main.** The post-merge pull is read-only from the git perspective — fast-forward only.
- **Never fabricate.** If you cannot verify the merge, say so. If the session context is thin (short session, small change), say so and produce a short recap — do not invent improvements to pad the output.
- **Prefer proposals over actions.** Part 2 proposes. It does not execute. Ahmed picks.
- **If Ahmed says "do everything" or picks items to implement**, branch out into the relevant repos (one feature branch per repo), commit, push, and surface PR-creation URLs per the `/pr` skill. Never open PRs directly — Ahmed does that (`memory/feedback_pr_creation.md`).

## Output shape (user-facing)

Keep Part 1's output minimal — one confirmation line per step, no narration. The bulk of the visible output is Part 2: the recap and proposals. Structured markdown, no emojis.
