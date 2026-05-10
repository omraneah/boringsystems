---
name: Verify before claiming done
description: Run the actual check before declaring a task complete — twice-is-a-pattern threshold crossed in W18.
type: feedback
---

# Verify Before Claiming Done

**Rule:** Never declare a task done without running the actual verification step. "Done" means verified, not executed.

**Why:** Twice-is-a-pattern threshold crossed in W18 — two separate tasks declared done with outstanding gaps: a scrub pass that left a reference in place, and a process implementation that required 3+ correction rounds post-declaration. In both cases, execution happened without verification. The `/declare-ready` skill exists precisely for this; the gap was invocation discipline, not missing tooling.

**How to apply:**
- Before saying "done", "complete", "clean", or any closure language: run the relevant check (build passes, grep returns empty, file state matches expectation, no leaks in stable docs).
- If the check tooling exists (`/declare-ready`, `/check-stable-docs-leaks`, `astro build`, `git status`), invoke it. Don't skip.
- If the check takes more than a few seconds: still run it. The cost of a correction round is higher.
- Exception: explicitly time-boxed exploratory tasks where "done" means "explored to scope" — but even then, surface what's unverified.
