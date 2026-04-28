---
name: Lane-Change Announcement
description: When the conversation shifts task-dimension or cadence (psychology→code, exchange→distilled, single→parallel), announce the current model/effort and a recommendation BEFORE proceeding. Don't hide the choice.
type: feedback
---

When the conversation shifts lane — task dimension, cadence, or complexity changes meaningfully — name it explicitly. Announce the current model/effort, the recommendation, and the reason in one short block before continuing the work.

**Why:** Lane shifts are exactly where the current setup might no longer fit. Hidden mismatches cost two ways: (a) cognitive load on Ahmed (responses miscalibrated to the work — too long when he wants exchange, too shallow when he wants depth), and (b) quota / token waste (running max on file moves, running medium on architecture). Naming the shift makes the choice visible. Ahmed gets a beat to redirect if the recommendation is off.

**How to apply:**

Format:

> **Lane shift**: [old lane] → [new lane]
> **Current setup**: [model] / [effort]
> **Recommendation**: [keep / switch to X / bump to Y]
> **Why**: [reason in one line]

If recommendation is "keep" — proceed without waiting.
If recommendation is "switch / bump" — proceed for trivial mechanical changes (sub-agent inheritance, etc.) but wait for Ahmed's signal when the change is non-trivial (changing session model, going to max).

## Triggers (fire the announcement when)

- Strategic exchange → execution (architecture decided, now writing code/config)
- Code → market research
- Light coding → heavy infra
- Single thread → parallel sub-agents (then ALSO invoke `feedback_parallel_agent_recap.md`)
- Distilled output requested → exchange cadence resumes
- Ahmed signals "let's discuss" → drop to exchange-friendly setup
- Ahmed signals "go execute" → bump to deeper setup
- Architecture phase → execute phase (his own framework: "starts with lots of back and forth, and then do the work")

## Examples (real)

- "Lane shift: positioning exchange → architecture execution. Current: Opus/high. Recommendation: stay at Opus/high. Work is file writes, not deep reasoning. No bump."
- "Lane shift: light blog coding → heavy infra design. Current: Sonnet/high. Recommendation: switch to Opus/xhigh for the rest of this session. Confirm?"

## Don't announce when

- Within a continuous task lane — no shift, no announcement
- Trivial sub-step inside the same lane (writing file 3 of 5)
- Confirming a previous lane change (avoid noise loops)
- Single sub-agent inheriting parent setup with no override (announce inline, not as a block)

## See also

- `memory/feedback_model_effort_matrix.md` — the per-lane defaults the announcement references
- `memory/feedback_parallel_agent_recap.md` — sister rule for parallel sub-agent fanout
