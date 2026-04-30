---
name: Promote tmp/ Artifacts to a Permanent Home Before Session Boundary
description: When Claude generates something in tmp/ that matters beyond the current turn (load-bearing analysis, raw material for an article, anything that will be referenced later), it must be promoted to a permanent home (Linear card comment, memory file, repo file) BEFORE any session-boundary event — not "later." tmp/ is render buffer; assume it can be wiped at any time by an explicit /tmp-cleanup or by accident.
type: feedback
---

**When you generate something in `tmp/` that matters beyond the current turn — load-bearing analysis, raw material for an article, anything you or Ahmed will reference later — promote it to a permanent home BEFORE any session-boundary event. Not "later." Now.**

**Why:** `tmp/` is deliberately ephemeral. The convention is "default fate is deletion." Anything that matters must escape tmp/ proactively, not reactively. Reactive escape (after a wipe) means recovery work and loses fidelity.

**The canonical incident this rule prevents:** during the v1 tiered-memory restructure session, the live build narrative was written to `tmp/restructure-narrative.md`. Claude knew it mattered for the boringsystems article (captured the risk in a Linear card note). But Claude did not promote the file to a permanent home. A SessionStart event fired between turns, the auto-wipe hook deleted the file, and Claude had to reconstruct the content from session memory when briefing the article-writing sub-agent. Quality survived; that was luck. Don't rely on luck.

**How to apply:**

1. When writing to `tmp/` for any reason beyond a one-turn render: ask explicitly, "does this matter beyond this turn?"
2. If yes — promote NOW:
   - For raw material that informs a deferred work item: paste content as a comment on the relevant Linear card (via Linear MCP).
   - For decisions / state worth keeping: write to `memory/short-term/<this-week>/<today>.md`.
   - For artifacts that belong in a project repo: commit them in that repo.
3. Do NOT defer. "I'll move it later" is the failure mode this rule exists to prevent.
4. The `/tmp-cleanup` skill exists for explicit operator-directed wipes; never assume `tmp/` persists across boundaries you don't control.

**Companion:** `/tmp-cleanup` skill (operator-directed wipe). The auto-wipe on SessionStart was removed when this rule was codified — the wipe is now operator-directed only, but tmp/ persistence is still NOT guaranteed (other accidents happen). The discipline applies regardless.
