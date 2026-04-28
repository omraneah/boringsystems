---
name: wrap-session
description: End-of-session reflection after one or more PRs have shipped and been cleaned up. Stops any dev servers Claude started during the session, then produces a session-level recap with proposed system improvements (skills, hooks, docs, ADRs, memory, decisions). Trigger when Ahmed says some variant of "wrap up the session", "we're done for today", "end of session", "wrap this up". Per-PR git cleanup is NOT this skill's job — that's `/github-cleanup`, which runs separately for each merged PR during the session.
model: opus
effort: high
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(pkill *), Bash(pgrep *), Bash(git log *), Bash(git status *), Read, Edit, Write, Glob, Grep
---

End-of-session reflection. Runs after Ahmed signals the session is done — typically after one or more PRs have already been merged and cleaned up via `/github-cleanup` during the session. This skill's job is the session-level pass: stop the long-running dev servers, then produce a recap that compounds the session's lessons into system-level improvements.

Do not announce the skill invocation. Just do the work.

## When to invoke

Auto-fire when Ahmed signals end-of-session:

- "wrap up the session"
- "we're done for today"
- "end of session"
- "wrap this up"

Do **not** invoke for:

- Per-PR cleanup signals ("merged, clean up", "go delete the branch") — that's `/github-cleanup`.
- Mid-session pulse checks — that's `/session-pulse`.

If the signal is ambiguous (could be either `/github-cleanup` or `/wrap-session`), ask one one-line clarifier: "cleanup the merged branch only, or full session wrap?"

## Part 1 — Dev server cleanup

These persist across PRs within a single session, so they're stopped at session end (not after each `/github-cleanup`).

1. **Stop dev servers Claude started** in this session. `pkill -f "astro dev"`, `pkill -f "next dev"`, `pkill -f "vite"`, or whatever is relevant. Verify with `pgrep`.
2. **Confirm clean shell state.** `git status -s` should be empty in whatever cwd you're in. If it isn't, surface the diff and ask before proceeding.

Note: branch / sync state is `/github-cleanup`'s responsibility. Don't re-do that work. Trust that if Ahmed is saying "wrap up", he's already cleaned up each merged PR with `/github-cleanup`. If you see an unmerged feature branch checked out, surface it and ask — don't silently switch.

## Part 2 — Session recap + improvement proposals

Produce a written recap. Four sections, in order:

### Session recap
Short prose (3–5 short paragraphs, not bullets). What arcs shipped, how they fed each other, what's now live on `main`. If multiple PRs merged this session, name each one and the through-line that connects them (or note explicitly that they were independent).

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

- **Never fabricate.** If the session context is thin, produce a short recap. Do not invent improvements to pad the output.
- **Prefer proposals over actions.** Part 2 proposes. It does not execute. Ahmed picks.
- **If Ahmed says "do everything" or picks items to implement**, branch out into the relevant repos (one feature branch per repo), commit, push, and surface PR-creation URLs per the `/pr` skill. Never open PRs directly — Ahmed does that (`memory/feedback_pr_creation.md`).
- **Don't re-do `/github-cleanup`'s work.** This skill assumes per-PR cleanup already happened. If the working tree is dirty or a feature branch is still checked out, surface and ask.

## Output shape (user-facing)

Keep Part 1 minimal — one or two confirmation lines (servers stopped, state clean). The bulk of the visible output is Part 2: the recap and proposals. Structured markdown, no emojis.
