---
name: BOR-24 deferred follow-ups (still open after 2026-04-26)
description: Four items deferred from the Model × Effort × Lane matrix card. Surface when relevant — status-line surfacing, model-release calibration revisit, board xhigh validation, auto lane-shift hook spike. Do NOT preemptively spin a session for them.
type: project
---

The BOR-24 card was closed 2026-04-26 with the agents audit + skills frontmatter audit shipped. Four follow-up items were deferred and intentionally not re-carded — creating a card per item violates the card-fanout discipline; these stay tracked here until a session naturally touches them.

**Why:** Each item is low-urgency and low-context-setup once the right session arrives. A separate Linear card per item would create exactly the sibling-card fanout the workspace just codified against. Memory is the right home for "surface when relevant" follow-ups.

**How to apply:** When a session naturally surfaces one of these — e.g. Ahmed asks "where am I running at right now?" (status-line), Anthropic announces a new model tier (calibration), `/convene-board` produces a noticeably under- or over-loaded advisor (xhigh validation), or a lane shift goes uncaught (auto lane-shift hook) — surface the item, name it as a deferred BOR-24 follow-up, and ask Ahmed if he wants to fold it into the current branch or park it. **Do not** preemptively start a session for any of these.

## The four items

1. **Status-line surfacing.** Surface current model + effort live in the Claude Code status line so Ahmed sees it without running `/status` or grepping settings. Investigate the harness `statusLine` config option first; if not exposed, a SessionStart hook that announces model/effort once per session is the fallback. Lives in `.claude/settings.json` + possibly `.claude/hooks/`.

2. **Model-release calibration revisit.** When a new model tier ships (Opus 4.8, Sonnet 5, a new effort level between `xhigh` and `max`, etc.), re-run the matrix pass: workspace default in `settings.json`, agents frontmatter sweep, skills frontmatter sweep, matrix doc itself. Add to a "next model release" mental checklist.

3. **Board xhigh validation.** Run `/convene-board` on three or four genuinely different question types (frame-level, structural-unease, quarterly-direction, structural-commitment) and read each advisor's output for over- or under-loading at `xhigh`. If a consistent advisor over-runs at `xhigh`, drop their effort to `high`; if one consistently under-delivers, the issue is the persona file, not the effort tier.

4. **Auto lane-shift hook spike.** Currently lane-change announcement is a behavioral rule (`feedback_lane_change_announcement.md`) that depends on Claude noticing the shift. Worth spiking a `UserPromptSubmit` hook that pattern-matches keywords ("write an article", "audit the code", "run a market read") and emits the lane announcement deterministically. Investigation question first: does the hook get the prompt text in a usable form? If yes, build; if not, leave the behavioral rule in place and revisit when the hook contract changes.
