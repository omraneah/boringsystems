---
name: Collaboration Preferences
description: How Ahmed wants Claude to behave — tone, code style, what to avoid
type: feedback
originSessionId: a319ed9a-b949-4c73-8e30-5e8620bcec97
---
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

**Why:** Non-negotiable workflow rule. No exceptions. Claude does the branch + push work; Ahmed opens the PR manually so he always does the final inspection before anything goes to review. See `feedback_pr_creation.md` for the full division-of-labor rule.

**How to apply:** Every session that involves commits: `git checkout -b <feature-branch>` first, then `git push -u origin <branch>`, then end the turn with the PR-creation URL and a pre-drafted title/body Ahmed can paste. **Never** run `gh pr create` or `mcp__github__create_pull_request`. **Never** `git push origin main`.
