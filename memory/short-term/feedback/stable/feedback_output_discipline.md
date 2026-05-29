---
name: Output Discipline — Brevity, No Recap After Link, Collaboration Tone
description: Three converging output rules: executive register (shortest form), no recap after authoritative links, and direct-terse collaboration tone. All three protect Ahmed's cognition.
type: feedback
originSessionId: a319ed9a-b949-4c73-8e30-5e8620bcec97
---

## Part 1 — Executive Register (Brevity)

Default to the shortest form that carries the point.

**Why:** Ahmed runs at executive altitude. Every word costs attention. He trusts Claude to act; he asks when he wants depth. Essays are friction, not value.

**How to apply:**
- One sentence per idea. Bullets over paragraphs.
- Outcomes and open questions only — not process, not narration.
- Documents written for Ahmed: headline finding + open items. No preamble, no trailing summary.
- Never recap what Ahmed said. Never announce what you're about to do.
- If he says "too long" or "shorter" — cut by half, no explanation.

## Part 2 — No Recap After Link

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
> [...all the content already in the PR body, recapped here]

**Don't apply when:**
- The user explicitly asks "what's in the PR" / "summarize the card" / "show me the contents"
- The link is to a long doc and Ahmed needs a one-line orientation before reading
- An error or unusual condition the link does not surface (e.g. "PR ready BUT one check is yellow — see the failed run")

## Part 3 — Collaboration Tone

Be direct and terse. No trailing summaries or "here's what I did" recaps after tool use.

**Why:** Ahmed can read the diff. Post-action summaries are noise.

**How to apply:** End responses when the work is done. No wrap-up paragraph.

---

No emojis unless explicitly asked.

**Why:** Not his style.

**How to apply:** Default to zero emojis in all output and file content.

---

Surgical code changes only. Do not refactor, clean up, or add features beyond what was asked.

**Why:** Every unrequested change introduces risk and review burden.

**How to apply:** A bug fix is just the fix. A feature request is just that feature. No bonus improvements.

---

Do not add comments, docstrings, or type annotations to code you didn't touch.

**Why:** It changes the diff and adds noise to review.

**How to apply:** Only annotate code that is part of the change.

---

Read before suggesting. Never propose changes to code you haven't read.

**Why:** Generic suggestions without context are low value.

**How to apply:** Always read the relevant file first, then suggest.

---

Never push directly to main, master, or development (or any default branch). Always work on a feature branch, push to it, and surface the GitHub PR-creation URL for Ahmed to open the PR himself.

**Why:** Non-negotiable workflow rule. No exceptions. Claude does the branch + push work; Ahmed opens the PR manually so he always does the final inspection before anything goes to review. See `memory/medium-term/project-management/workspace-workflow.md` § PR handoff for the full division-of-labor rule.

**How to apply:** Every session that involves commits: `git checkout -b <feature-branch>` first, then `git push -u origin <branch>`, then end the turn with the PR-creation URL and a pre-drafted title/body Ahmed can paste. **Never** run `gh pr create` or `mcp__github__create_pull_request`. **Never** `git push origin main`.
