---
name: tmp/ and Render Discipline — Write, Read, Promote
description: Long Claude-generated output goes to tmp/<name>.md. Render via /render → Marky on request. Promote anything load-bearing before session boundary. Three-part rule covering the full tmp/ lifecycle.
type: feedback
---

## Part 1 — tmp/ as Workspace Short-Term RAM

When Claude generates more than roughly 400 words of dense analysis the user will read in full, write it to `tmp/<descriptive-name>.md` at the workspace root and reference the path in chat. Do not dump it inline.

**Why:** Chat exchanges are read in full. Long blocks are friction — hard to scroll past, hard to revisit, hard to search. A file in `tmp/` is easier on every axis: scrollable, linkable, diffable, searchable, discardable. The chat stays an exchange instead of a wall. Ahmed framed it explicitly: `tmp/` is the workspace's short-term memory — RAM, not disk. Default fate of anything in there is deletion.

**How to apply:** The threshold is the scroll test — "would Ahmed want to scroll past this twice in a single exchange?" If yes, it goes in `tmp/`. Use descriptive filenames (`founding-engineer-synthesis.md`, not `analysis.md`). The folder is tracked but contents are gitignored; a SessionStart hook wipes everything except `.gitkeep` and `README.md`. Assume nothing persists across sessions. If a file matters, Ahmed will explicitly say to move it — to `docs/`, `memory/`, an article, a Linear card, an ADR. Never promote a `tmp/` file silently.

What counts as "long":
- Multi-section analyses, comparison tables, structured option breakdowns
- Verbatim drafts (article drafts, advisor briefs, decision memos) before they're approved
- Reference dumps the user is going to read once and discard
- Anything that would make the chat a scroll-fest

What does not go in `tmp/`:
- Short answers (one to a few paragraphs) — those stay inline
- Anything that's already going to a final home (article, memory, Linear, ADR) — write it there directly
- Code being edited — that goes in its real path

**Escalation:** When Ahmed says "save this" / "this matters" / "move this to X" about a `tmp/` file, that's the signal to relocate it. Never assume a `tmp/` file is worth keeping.

## Part 2 — Render via /render → Marky on Request

When Ahmed says any variant of "render this with Marky", "render this outside the terminal", "go render this", "open this in Marky", "render the last answer", "send this to Marky" — fire the `/render` skill. It writes the last substantive assistant message verbatim to `~/Workspace/tmp/<slug>.md` and opens it with `marky <path>`.

**Why:** Long markdown is painful to read in terminal scrollback. The `tmp/` folder was already established as workspace short-term RAM for long Claude output, but the *reader* half of the loop was missing — Ahmed had to manually `cat` or `open` the file. Marky (free, open source, Tauri/Rust, live-reload, folder workspaces) was installed 2026-04-28 as the canonical reader. This rule operationalises the second half of that loop.

**How to apply:**
- Trigger phrases auto-fire `/render`. Voice-drift "Marquee/Markey/Marki" → still Marky, fire anyway.
- Default scope is the last substantive assistant message. If Ahmed names a different scope ("render the linear table", "render the recap"), scope to that.
- Output is one line: `Rendered → tmp/<slug>.md`. No content recap (link IS the recap — `feedback_no_recap_after_link`).
- Do NOT auto-fire without a trigger phrase. This is user-driven, not proactive. Long output goes to `tmp/` per the existing rule; rendering is opt-in.
- If Marky is not on PATH, fall back to `open -a Marky <path>`. If both fail, surface and stop — do not silently degrade to terminal.

**Cross-references:**
- Skill: `.agents/skills/render/SKILL.md`
- ADR: `docs/architecture/adr-003-marky-as-canonical-reader.md`
- Voice-drift rule: `feedback_voice_dictation_disambiguation.md`

## Part 3 — Promote tmp/ Artifacts Before Session Boundary

**When you generate something in `tmp/` that matters beyond the current turn — load-bearing analysis, raw material for an article, anything you or Ahmed will reference later — promote it to a permanent home BEFORE any session-boundary event. Not "later." Now.**

**Why:** `tmp/` is deliberately ephemeral. The convention is "default fate is deletion." Anything that matters must escape tmp/ proactively, not reactively. Reactive escape (after a wipe) means recovery work and loses fidelity.

**The canonical incident this rule prevents:** during the v1 tiered-memory restructure session, the live build narrative was written to a `tmp/` scratch file. Claude knew it mattered for the boringsystems article (captured the risk in a Linear card note). But Claude did not promote the file to a permanent home. A SessionStart event fired between turns, the auto-wipe hook deleted the file, and Claude had to reconstruct the content from session memory when briefing the article-writing sub-agent. Quality survived; that was luck. Don't rely on luck.

**How to apply:**

1. When writing to `tmp/` for any reason beyond a one-turn render: ask explicitly, "does this matter beyond this turn?"
2. If yes — promote NOW:
   - For raw material that informs a deferred work item: paste content as a comment on the relevant Linear card (via Linear MCP).
   - For decisions / state worth keeping: write to `memory/short-term/<this-week>/<today>.md`.
   - For artifacts that belong in a project repo: commit them in that repo.
3. Do NOT defer. "I'll move it later" is the failure mode this rule exists to prevent.
4. The `/tmp-cleanup` skill exists for explicit operator-directed wipes; never assume `tmp/` persists across boundaries you don't control.

**Companion:** `/tmp-cleanup` skill (operator-directed wipe). The auto-wipe on SessionStart was removed when this rule was codified — the wipe is now operator-directed only, but tmp/ persistence is still NOT guaranteed (other accidents happen). The discipline applies regardless.
