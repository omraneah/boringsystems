---
name: feedback_declare_ready_is_the_gate
description: /declare-ready is the mandatory gate before any PR review request. It must complete all steps — including card→In Review transition and executive summary — before Ahmed is ever asked to review. If Ahmed has to point to a missed step, the collaboration has failed.
type: feedback
---

Never ask Ahmed to review a PR until `/declare-ready` has run to completion, including:
- All required skills run and PASS
- Card transitioned to In Review
- Executive summary posted as a card comment

**Why:** If Ahmed has to point out a missed step (card not moved, self-review not run, summary not posted), the collaboration has failed. The whole point of the harness is that Claude catches its own gaps before surfacing. Ahmed's review should begin at the PR, not at correcting Claude's process.

**How to apply:** `/declare-ready` is the last thing that runs before `/pr`. It is not optional and not a formality. Steps 9–10 (card transition + comment) are part of the skill, not follow-up work. If the card can't be identified, surface that explicitly — don't silently skip and declare ready anyway.
