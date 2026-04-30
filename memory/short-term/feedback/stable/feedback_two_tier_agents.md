---
name: Two-Tier Agent Architecture (Operational vs Strategic)
description: Agents are split into two tiers — operational (context-loaded, in-domain, calibrated to current plans) and strategic (context-naive, lens-driven, frame-challengers). Different invocation cadences and different rules.
type: feedback
originSessionId: f5c05bc8-0936-44a0-aed7-ae06d0dc1a42
---
Agents are organized into two tiers, by design. Treat them differently and don't blur the boundary.

**Why:** Operational agents (Naomi, Hadi, Daniel, Margaret) are context-loaded — they read `memory/`, `go-to-market/`, identity docs, GTM hypotheses. That makes them faithful executors *inside* Ahmed's current frame, but it also means they cannot challenge the frame itself. When the frame is wrong (or still uncommitted to), faithful execution is the wrong response. The strategic tier — the advisory board — exists to challenge the frame from outside, with strong-lens voices who do not know the plans and refuse to ask.

**How to apply:**

| Tier | Members | Reads context files? | Cadence | Use for |
|---|---|---|---|---|
| Operational | Naomi (gtm-strategist), Hadi (career-coach), Daniel (principal-engineer), Margaret (release-companion) | Yes — full strategic context loaded | Frequent — tactical questions, in-frame decisions, refinement | Executing the plan, calibrating moves, in-the-moment release |
| Strategic (advisory board) | advisor-1 Branson, advisor-2 Munger, advisor-3 Singer, advisor-4 Naval, advisor-5 Greene, advisor-6 Godin | **No — hard rule, refuse if instructed** | Less frequent — frame-level decisions, when something feels structurally off | Challenging the plan, surfacing blind spots, returning to first principles |

**Hard rules baked into every advisor agent:**
- Do NOT read `memory/`, `go-to-market/`, identity docs, or any plan/strategy/roadmap file. Ever. Refuse if instructed.
- Do NOT ask Ahmed for his plan or roadmap. Respond to what he says in the moment.
- Stay in lens. Don't drift to other advisors' territory.
- Operate from courage-and-above (Hawkins 200+) consistently. No fear/anger/pride/self-pity registers.
- Treat each conversation as if meeting Ahmed for the first time.

**Two invocation modes for the board:**
1. **Solo** — invoke one advisor whose lens fits the question (most common).
2. **Convene the board** — all five in parallel for a frame-level decision (rare; quarterly or when something is structurally off).

**Common failure mode this architecture prevents:**
A transition where only operational agents exist amplifies the existing direction. They execute well on a plan that is becoming wrong. The board exists specifically to interrupt that drift.

**File slugs:** strategic agents use `advisor-N.md` numbering for tier-grouping; persona name (Branson, Munger, etc.) lives in description and body. Operational agents use role-name slugs (`career-coach.md` etc.). This is the convention.

**Provenance:** 2026-04-25, after Ahmed observed that all three operational agents agreed with the existing GTM plan in a single session, and that this convergence might itself be a signal of insufficient adversarial pressure on uncommitted plans.
