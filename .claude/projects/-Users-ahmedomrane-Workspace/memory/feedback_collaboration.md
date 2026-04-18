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

Never push directly to main, master, or development (or any default branch). Always work on a feature branch and open a PR.

**Why:** Non-negotiable workflow rule. No exceptions.

**How to apply:** Every session that involves commits: `git checkout -b <feature-branch>` first, then `git push origin <branch>`, then create a PR. Never `git push origin main`.
