---
name: Max three concerns per session
description: If a session accumulates more than three distinct concerns, stop and propose splitting into separate branches. Wider scope degrades quality.
type: feedback
originSessionId: e464aaed-a5a0-4c1c-ac8b-19b9dd83adf6
---
If a single session/branch accumulates more than **three distinct concerns**, stop and propose splitting into separate feature branches before proceeding.

**Why:** Session 2026-04-21 shipped date meta + i18n refactor + two articles + lead-magnet infra + mermaid + home redesign + zoom/pan fix in one branch. That's 7+ concerns. The result: 4 iterations on the mermaid alone, three rounds of home-page refinement, and a pattern where later edits corrected earlier edits. Wide-scope sessions hit three failure modes: (1) Claude's attention degrades as instruction count grows past ~150 reliable items, (2) PRs become un-reviewable in one pass, (3) context thrash — changes to one concern invalidate the mental model of another.

**How to apply:** Count concerns, not files. Two articles are one concern (content). Lead-magnet infra is another (platform). Mermaid rendering is a third (platform). Home redesign is a fourth (layout). At four, stop. If Ahmed asked for all of them in one message, propose the split explicitly: "this is four concerns — recommend splitting into branches A, B, C, D; which order do you want?" Do not proceed without a decision.

Bundling exception: work that is genuinely coupled (can't ship A without B) stays on one branch. Bundling failure mode: using "coupled" to rationalize tangentially related work onto one branch. When in doubt, split.
