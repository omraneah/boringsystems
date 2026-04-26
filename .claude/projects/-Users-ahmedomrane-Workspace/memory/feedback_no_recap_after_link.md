---
name: No Recap After Link
description: When providing a link to a PR, Linear card, GitHub issue, doc, or any other authoritative source, do NOT recap that source's content in the chat. The information lives there. Recapping wastes Ahmed's cognition.
type: feedback
---

When the response includes a link to an authoritative source (GitHub PR, Linear card, GitHub issue, doc URL, decision log entry, ADR, memory file), do NOT recap the contents of that source in the chat below the link. Just provide the link and stop.

**Why:** Ahmed's cognition is the binding constraint, not the model's output budget. When a link is given, the source is canonical — recapping it in chat means he reads the same content twice, processes both versions, and burns attention reconciling them. The recap also creates a divergence risk: if the source changes, the chat recap becomes stale immediately. His core principle: **minimize cognitive load. His cognition is his horsepower; do not burn through it.**

The most common failure modes:

- After pushing a PR: re-stating the summary, file list, test plan, etc. that's already in the PR description
- After creating a Linear card: re-stating the card's title, sections, contents
- After writing an ADR or decision log entry: paraphrasing the rationale in the chat

In all of these, the link IS the recap. Anything more is duplication.

**How to apply:**

When you give a link, follow it with at most:
- One line of context if absolutely necessary ("PR ready, all checks green")
- The next action / question for Ahmed (what to do next, what's still outstanding)

Do NOT include:
- The PR title and body
- The Linear card description
- The decision rationale (when the link points to it)
- A bulleted breakdown of "what's in the linked thing"

## Examples

**Right:**
> Branch pushed. PR: https://github.com/owner/repo/pull/new/branch
>
> Anything left, or are we good to merge?

**Wrong:**
> Branch pushed. PR: https://github.com/owner/repo/pull/new/branch
>
> ## Summary
> - bullet
> - bullet
>
> ## Test plan
> - [ ] check 1
> - [ ] check 2
>
> [...all the content already in the PR body, recapped here]

## Don't apply when

- The user explicitly asks "what's in the PR" / "summarize the card" / "show me the contents"
- The link is to a long doc and Ahmed needs a one-line orientation before reading
- An error or unusual condition the link does not surface (e.g. "PR ready BUT one check is yellow — see the failed run")

## See also

- `memory/feedback_collaboration.md` — broader tone discipline
- `memory/feedback_card_fanout_discipline.md` — sister rule on Linear card structure
