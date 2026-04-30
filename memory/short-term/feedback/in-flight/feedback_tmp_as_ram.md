---
name: tmp/ as Workspace Short-Term RAM
description: Long Claude-generated analysis goes to `tmp/<name>.md` and is referenced by path in chat — not dumped inline. Folder tracked, contents ignored, wiped at session boundaries.
type: feedback
---

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
