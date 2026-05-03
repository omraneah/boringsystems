---
name: No short-term state in medium-term docs
description: Medium-term memory holds stable rules and structures only. Never embed card IDs, board snapshots, PR IDs, branch names, or any live issue list in medium-term documents.
type: feedback
---

Medium-term documents (`memory/medium-term/`) are stable doctrine — rules, structures, and operating procedures that outlive any single session or sprint. Short-term state (Linear card IDs, board snapshots, current issue lists, PR numbers, active branch names) has a half-life of days. Mixing them corrupts the medium-term tier and forces manual cleanup every time the board evolves.

**Why:** This was violated in the first draft of the Linear SOP, which included a "Board health" section listing ~15 active card IDs as if they were doctrine. Ahmed flagged it immediately: those belong on the board or in `memory/short-term/`, not in a versioned SOP.

**How to apply:**

- Medium-term SOP/doctrine files → rules, workflows, structures, open questions about the system. No card IDs, no "as of YYYY-MM-DD" snapshots.
- Current board state → lives on Linear itself. Read it live when needed.
- Active sprint state / in-progress card tracking → `memory/short-term/<week>/` daily entries.
- If tempted to "document" the current state of the board inside a medium-term file, stop. The board IS the live state. Write the rule that governs the board instead.

The test: every sentence in a medium-term doc should be as true in six months as it is today. If it references a specific card number or a "known active work" list, it fails the test.
