---
name: signal-recap
description: Recap session signals — drop the noise, capture only architectural / decision-shaped signal — and create a Linear card to defer the work for later. Trigger when Ahmed asks "recap what we did", "capture this", "create a card for this", or signals end-of-session and wants the work saved.
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git *), Read, Edit, Write, Glob, Grep, mcp__claude_ai_Linear__*
---

Session-signal capture. Runs when Ahmed wants the non-trivial work from a session recorded before it evaporates. Creates one Linear card with the decision, what shipped, and what's deferred.

Do not announce the skill invocation. Just do the work.

## Step 1 — Extract signal

Scan the session for items that are decision-shaped or architectural. Keep only:

- **Decisions made** — architectural choices, non-negotiable rules encoded, defaults locked
- **Files shipped** — new or edited files that carry the decision forward
- **Deferred work** — follow-ups that were explicitly named but not completed

Drop:
- Exploration that didn't resolve (dead ends, experiments abandoned)
- Small fixes (typos, minor config tweaks with no lasting consequence)
- Narration and process (intermediate tool calls, retries, back-and-forth debugging)

If the session produced nothing decision-shaped, say so and stop. Do not fabricate signal.

## Step 2 — Structure the card

Format the Linear card description as structured markdown. Use the article-series container card structure:

```
## The decision
One-paragraph framing. What was decided, why it matters, what it changes. If a matrix or rule was established, name the axes and the default.

## What shipped (<date>)
Bullet list. One file per line. Format: `path/to/file` — one-line description of what it carries.

## Deferred follow-ups
Checkbox list. Each item is actionable: starts with a verb, names the specific work, notes if it belongs in a separate session/branch.

## When to revisit
Bullet list. Concrete triggers — not "review periodically" but "when X releases" or "when Y is observed".

## References (in workspace repo)
Bullet list. Absolute paths to the key files, with one-line annotation each.

## Notes for whoever picks this up
Operational notes. Which deferred item is highest-ROI, what NOT to bundle together, what the source of truth is.
```

## Step 3 — Create the Linear card

Use `mcp__claude_ai_Linear__save_issue` with:

- **team:** `Boringsystems` (default — use a different team only if Ahmed names one)
- **title:** concise, signals-first — e.g. `<Topic> — codified (<date>) + <follow-up label>`
- **priority:** 3 (Normal) — unless Ahmed says otherwise
- **state:** `Todo`
- **description:** the markdown from Step 2, with literal newlines (not escape sequences)
- **labels:** check `mcp__claude_ai_Linear__list_issue_labels` first; attach any label matching "infrastructure", "skill", "harness", or "agent" if it exists. Do not invent labels.

## Step 4 — Cross-reference

After creating the card, check if any of the following apply and note them in the reply:

- A related decision log entry exists in `memory/decisions/` — mention the file path
- A memory file was created or updated this session — confirm it's indexed in `MEMORY.md`
- A related Linear card already exists — surface it so Ahmed can link them manually

## Output shape

Return:
1. The Linear card URL
2. A one-line confirmation: what was captured, what was deferred
3. Any cross-references found (memory files, decision log, related cards)

No prose. No recap of the recap. Tight.

## Guardrails

- **Never fabricate.** If the session was thin, say "nothing decision-shaped to capture" and stop.
- **One card per session.** If multiple unrelated decisions shipped, consolidate into one card with clear sections — do not create multiple cards without asking.
- **Do not open PRs.** If follow-up work needs a branch, note it in the card's deferred section. Ahmed opens PRs.
- **Memory-first.** If a rule or pattern was established, verify it landed in a memory file before creating the card. The card defers future work; the memory file is the live rule.
