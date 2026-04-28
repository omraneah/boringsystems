---
name: Always Run /article-review and /french-audit Before Declaring a Boringsystems Article Done
description: Before declaring any boringsystems article, playbook, or page copy ready for review or PR, always run /article-review on EN and FR, plus /french-audit on FR. Never ask Ahmed whether to run them — they are mandatory passes.
type: feedback
---

**Before any boringsystems article, playbook, or page-copy update is declared done, ready for review, or pushed to a PR branch, always run `/article-review` on EN and FR, and `/french-audit` on FR. Never ask whether to run them.**

**Why:** voice, structure, lane, and FR-register quality are non-negotiable for boringsystems. The skills exist precisely to catch these issues mechanically before human time is spent. Asking creates friction and misses the point of having codified the discipline.

**How to apply:**

- After drafting (or updating) an EN article or playbook: run `/article-review` on EN.
- After drafting (or updating) the FR equivalent: run `/article-review` on FR + `/french-audit` on FR.
- Fix flagged issues that are clearly mechanical: banned register phrases, over-translation of English terms, voice slips, structural defects, lane misplacement, over-length paragraphs, passive-voice overuse.
- Surface judgment calls (where the skill flags something but the right answer is not obvious) in the PR description or the relevant Linear card for Ahmed to decide.
- Only declare "done" when the skills pass with no unresolved mechanical flags.
- Applies to: articles, playbooks, page copy, lead-magnet email text — anything that goes through the boringsystems content pipeline.

**Companion rule:** boringsystems articles always ship EN + FR together (`feedback_boringsystems_articles_en_and_fr.md`). The two rules work as a pair.
