---
name: Parallel-Agent Recap as First Summary
description: When spawning parallel sub-agents, announce model/effort/why for each as the FIRST summary before reading any agent output. Settings are otherwise hidden — make them visible.
type: feedback
---

When multiple sub-agents fire in parallel, the FIRST thing Ahmed reads is a recap of each agent's model, effort, and rationale. Before any agent output is shown, summarized, or synthesized.

**Why:** Sub-agent settings are otherwise invisible. Ahmed can't audit whether an operational task got Sonnet/medium (right) or accidentally got Opus/max (over-spend). When triaging parallel outputs of varying quality, knowing each agent's setup is part of judging which one to trust most. Hidden defaults are not laptop-agnostic in spirit even if they're technically reproducible. The recap is also the natural moment to confirm the lane assignment was correct — Ahmed can redirect mid-flight if a wrong agent got a wrong setup.

**How to apply:**

Before the message that fires parallel sub-agents, post:

> **Parallel sub-agent setup**:
> - Agent A — [task]: model **[X]**, effort **[Y]** — why [Z]
> - Agent B — [task]: model **[X]**, effort **[Y]** — why [Z]

Then the tool calls fire.

When their results come back, recap one line per agent before synthesizing:

> Agent A returned [headline]. Agent B returned [headline]. Synthesizing.

## Don't announce when

- Single sub-agent call — overkill, just mention the model/effort inline
- Sub-agent inherits exactly the parent setup AND the task is mechanical
- Repeated invocation of the same agent type with the same setup in a session — announce once at first invocation, skip subsequent

## Two examples

**Right (this session, codifying the rule live):**
> Parallel sub-agent setup:
> - Sub-agent A — Linear card + signal-recap skill creation: Sonnet 4.6, high — operational, structured output, faster
> - Sub-agent B — two article-ticket Linear cards: Sonnet 4.6, high — same lane, same context

**Wrong (what we'd do without the rule):**
> [tool calls fire, no announcement, results land — Ahmed has to reverse-engineer which agent ran which model]

## See also

- `memory/feedback_lane_change_announcement.md` — sister rule for lane shifts (single-thread)
- `memory/feedback_model_effort_matrix.md` — the per-lane defaults the recap references
- `memory/feedback_parallel_by_default.md` — the upstream rule that produces the parallel fanout in the first place
