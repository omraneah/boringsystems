---
name: session-pulse
description: Mid-session meta-cognition checkpoint. Scans the in-progress work for patterns repeating twice or more, emerging architectural constraints, skills that should exist, and scope drift — then proposes codification before the patterns evaporate. Trigger manually, OR automatically when you notice (a) the same manual task happening for the second time in a session, (b) the user correcting the same class of Claude mistake for a second time, (c) a session exceeding three distinct concerns, or (d) a tool/framework feature being reimplemented by hand.
model: opus
effort: high
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git log *), Bash(git status *), Bash(git diff --stat *), Read, Grep, Glob
---

Mid-session reflective checkpoint. The opposite of `/wrap-session`: this runs *during* the work, not after. Its job is to catch patterns the moment they appear — before they compound into "we should have codified this three PRs ago."

Do not announce the skill invocation. Produce the report directly.

## Triggers

Auto-fire when any of the following are true:

- **Pattern repetition.** The same manual sequence (grep, edit, git command, build check, pattern-match) has been executed twice in the current session and is about to be done a third time.
- **Correction repetition.** Ahmed has corrected the same class of Claude behavior twice (e.g. "don't do X", "remember Y").
- **Scope drift.** The branch has accumulated more than three distinct concerns.
- **Reinvention detection.** Claude is about to write structural code (i18n, auth, redirects, caching) without a verified check against the framework's native features.
- **Decision without logging.** A non-trivial architectural choice has been made in conversation and not yet logged to `DECISIONS.md`.

Manual invocation is always valid: Ahmed asks, you run.

## Steps

1. **Survey the session.** List:
   - Concerns active on this branch (group by purpose, not by file).
   - Repeated manual sequences (what was done twice).
   - User corrections so far (topic + count).
   - Framework features being touched (i18n, redirects, caching, auth, content, routing) — flag any custom reimplementation.
2. **Check against patterns.** For each item, ask the five codification questions:
   - Is this a **deterministic shell sequence**? → hook or script.
   - Is this a **reasoning-heavy checklist**? → skill.
   - Is this a **behavioral rule**? → memory entry + one line in CLAUDE.md.
   - Is this an **architectural constraint**? → `docs/constraints.md` + decision log.
   - Is this a **governance decision**? → `DECISIONS.md` via `/log-decision`.
3. **Propose.** For each pattern found, state:
   - (a) What the pattern is, named in one line.
   - (b) Where it should live (pick one of the five above).
   - (c) The smallest durable form (10-line skill, one memory entry, one ADR).
   - (d) The cost of not codifying — what will it look like in three PRs?
4. **Name one to do now.** Force a single recommendation. The others can park.
5. **If scope drift is detected**, propose splitting the current branch into N branches by concern. Name the split lines concretely. Stop and wait for Ahmed's decision before any more work on the current branch.

## Output shape

Terse. Bulleted. No narration. The output is a checkpoint report, not an essay.

Headers in order:
- **Active concerns** (bulleted list, ideally 1–3)
- **Repeated patterns** (if any — name + count)
- **Reinvention flags** (if any)
- **Unlogged decisions** (if any)
- **Scope verdict** — OK / split / stop
- **Codify now** — one sentence naming the single highest-leverage capture

## What session-pulse is not

- Not a session-end wrap-up. That's `/wrap-session`.
- Not a code review. That's `/arch-review` (lightweight) or `/review` (PR-level).
- Not an approval gate. It proposes — Ahmed picks.
- Not mandatory. Skip when the session is short and has a single clean concern.

## Self-guard

If session-pulse is about to fire for a third time in the same session without any codification happening, stop and state that plainly: "pulse has proposed N times, no codification has landed. The meta-cognition itself has become a pattern. What's blocking?" This prevents the skill from becoming noise.
