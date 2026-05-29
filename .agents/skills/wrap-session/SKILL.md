---
name: wrap-session
description: End-of-session reflection after one or more PRs have shipped and been cleaned up. Stops any dev servers Claude started during the session, writes today's daily entry to short-term memory, then produces a session-level recap with proposed system improvements (skills, hooks, docs, ADRs, memory, decisions). Trigger when Ahmed says some variant of "wrap up the session", "we're done for today", "end of session", "wrap this up". Per-PR git cleanup is NOT this skill's job — that's `/github-cleanup`, which runs separately for each merged PR during the session.
model: opus
effort: high
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(pkill *), Bash(pgrep *), Bash(git log *), Bash(git status *), Bash(ls *), Bash(mkdir *), Read, Edit, Write, Glob, Grep
---

End-of-session reflection. Runs after Ahmed signals the session is done — typically after one or more PRs have already been merged and cleaned up via `/github-cleanup` during the session. This skill's job is the session-level pass: stop the long-running dev servers, write the daily entry to short-term memory, then produce a recap that compounds the session's lessons into system-level improvements.

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

## Part 2 — Daily entry

Capture the session in the chronological short-term record. This step writes to disk before the recap is produced — the daily entry is for future-self continuity, the recap is for the operator's current review.

1. **Determine today's path.** Use today's date from session context: `memory/short-term/<YYYY-Www>/<YYYY-MM-DD>.md` where `<YYYY-Www>` is the ISO week folder. If the week folder doesn't exist, create it.
2. **If today's entry doesn't exist**, draft it from the session's decisions, state changes, and conflicts. Write the file.
3. **If it exists**, append new time-blocks for this session's work — do not overwrite earlier entries from the same day.

Format (matches existing daily entries):

````markdown
# YYYY-MM-DD

## TIME — short title

- Decision: ...
- State: ...
- Conflict: ...

## TIME — short title

- ...

## State

[end-of-day paragraph: where things stand, energy, what's pending]
````

Time-blocks use approximate hours (`~22:00` is fine). Use file modification times in the working tree as a hint when exact times are unclear.

**Tight, not verbose.** Yesterday's-entry compression is the target. Decisions / state / conflicts only — not a retrospective recap (that's Part 3).

**Part 2 vs Part 3 — different shapes:**

- **Part 2 = chronological log.** Event-by-event, in order. Written for future-self continuity.
- **Part 3 = retrospective recap.** Arcs, patterns, system improvements. Written for the operator's review now.

Both should exist after a substantive session. If the session was thin (one quick PR, no decisions), Part 2 can be a one-liner under a single time-block.

After writing, surface one confirmation line: `Daily entry written: <path>`.

## Part 3 — Session recap + improvement proposals

Produce a written recap. Four sections, in order:

### Session recap
Short prose (3–5 short paragraphs, not bullets). What arcs shipped, how they fed each other, what's now live on `main`. If multiple PRs merged this session, name each one and the through-line that connects them (or note explicitly that they were independent).

### What's still in-flight
Anything captured during the session that is not yet done. Linear cards, placeholder assets, TODO-style decisions waiting on Ahmed. Surface each with a short label and pointer.

### Proposed system improvements

**Operator cognition is the binding constraint** — meta-principle #5 (protect the master's cognition). The wrap exists to compress the session, not to broadcast every observation Claude noticed. Surface ONLY critical proposals; log everything else.

#### The cap (non-negotiable)

- **Default expected count: 1.** Sometimes 2. Three is a high bar — operator should agree all three are critical.
- **Hard ceiling: 5**, and only when genuine high-impact risks must be raised. Hitting 5 without a serious risk is a failure of triage, not a feature.
- **If you find yourself with more than 3 candidates, you are noticing too much, not curating enough.** Re-triage harder.

#### Triage rule

Walk the session through these lenses to identify candidates:

- **Patterns that repeated.** Same shape of work appearing more than once → propose a skill, doc section, or memory entry.
- **Skills that should exist.** Checklist run manually more than twice → propose a new skill. Be explicit about scope (`personal-skills/` vs. `<project>/.claude/skills/`).
- **Hooks.** Behaviour that should run automatically on a trigger (pre-commit, post-merge, SessionStart) → propose a `settings.json` hook. Real shell hooks, not skill invocations.
- **ADRs.** Non-trivial architectural choice made (collection shape, redirect strategy, dependency rejection) → propose an ADR under `docs/architecture/adr-NNN-<topic>.md`. 3-sigfig numbering.
- **Doc updates.** Architecture / toolchain / design docs that now misrepresent reality → flag the exact file and line.
- **Memory entries.** Feedback / project / reference memories Claude should carry into future sessions. Use only the shapes defined in the auto-memory system prompt.
- **Decisions to log.** Anything for `memory/decisions/DECISIONS.md` via `/log-decision`.

Then triage ruthlessly. A candidate passes the bar to be **surfaced** only if at least one of these holds:

- It catches the **second occurrence** of a pattern that will become entrenched if not codified now (twice-is-a-pattern threshold from the workspace doctrine).
- It prevents real damage to the next session if not raised today.
- It surfaces a risk the operator probably hasn't seen and would want to know about now.

Items that *don't* pass the bar — interesting observations, low-impact polish, things that compound slowly — are **logged, not surfaced**.

#### Logging the rest (don't drop the observations)

Append a section to today's daily entry titled `## Observations logged (not surfaced — for weekly consolidation)`. Use the same table format as below, but in the daily entry file (Part 2). Operator scans it during `/consolidate-week` if anything matters. **The observations are preserved; the operator's attention is protected.**

This is the load-bearing move. Without it, triage just becomes "drop everything I didn't surface" — losing signal. With it, signal is captured durably without burning the operator's bandwidth.

#### Output format — table for the surfaced items only

Render the surfaced critical items (1–3 typical, 5 ceiling) as a single table:

| # | Improvement | Category | Impact | Details |
|---|---|---|---|---|
| 1 | <distilled improvement> | Skill / Hook / Memory / ADR / Decision / Doc | High / Medium / Low | <why useful, how surfaced, where it lives> |

**Column rules:**

- **Improvement** — distilled in one short phrase, not a sentence.
- **Category** — pick one: Skill, Hook, Memory, ADR, Decision, Doc. If genuinely cross-cutting, pick the primary and note the others in Details.
- **Impact** — `High` = items you would definitely recommend; `Medium` = operator decides. (Low items don't get surfaced — they get logged.)
- **Details** — one or two sentences. Why useful + how surfaced this session + where it would live (path / scope). No paragraphs. No headings inside cells.

If a proposal genuinely needs more than two sentences, that's a sign it's not yet distilled enough — keep iterating until it fits, or split it.

### What I'd do first

**Skip this section if only 1 item was surfaced** — the choice is obvious, no need to narrate it.

If 2–3 items were surfaced, pick the single highest-leverage one and name it. Do not list multiple recommendations — force a choice. Explain in one sentence why it compounds more than the others. Then ask Ahmed which items he wants implemented *now* vs. parked.

## Guardrails

- **Never fabricate.** If the session context is thin, produce a short recap. Do not invent improvements to pad the output.
- **Prefer proposals over actions.** Part 3 proposes. It does not execute. Ahmed picks.
- **If Ahmed says "do everything" or picks items to implement**, branch out into the relevant repos (one feature branch per repo), commit, push, and surface PR-creation URLs per the `/pr` skill. Never open PRs directly — Ahmed does that. See `docs/agent-ops/workspace-workflow.md` § PR handoff.
- **Don't re-do `/github-cleanup`'s work.** This skill assumes per-PR cleanup already happened. If the working tree is dirty or a feature branch is still checked out, surface and ask.
- **Daily entry is a file write, not a chat recap.** Part 2 writes to disk; Part 3 surfaces in chat. Don't conflate them — they serve different audiences (future-self continuity vs. operator's current review).

## Output shape (user-facing)

Keep Part 1 minimal (one or two confirmation lines: servers stopped, state clean). Part 2 is a file write — confirm with one line (`Daily entry written: <path>`). The bulk of the visible chat output is Part 3: the recap and proposals. Structured markdown, no emojis.
