---
name: Load-bearing rules need auto-loaded sources
description: Behavioral rules that Claude must apply reliably belong in auto-loaded sources, not on-demand docs
type: feedback
---

Load-bearing rules — rules Claude must apply on every relevant action — must live in auto-loaded sources. Docs referenced from CLAUDE.md detail tables are pointers, not auto-reads; they are choreography references, not enforcement.

**Why:** Surfaced 2026-05-02 during workspace-structure.md reliability analysis. Ahmed asked "can I rely that you'll always be reading things from the docs?" — honest answer was no. A doc in `docs/` linked from CLAUDE.md only loads when Claude follows that link. If the rule in that doc is load-bearing (e.g. "autonomous pipeline fires when context is dropped"), it will be missed in sessions where the link is never followed.

**How to apply:** When writing or reviewing a rule, ask: does Claude need this to make the right call without being reminded? If yes → it belongs in CLAUDE.md non-negotiables or `memory/short-term/feedback/`. If no (it's choreography for a specific workflow type) → a doc reference is fine. The test is: would missing this rule cause real damage in a session where the doc isn't read?
