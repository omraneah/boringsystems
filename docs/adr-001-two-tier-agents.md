# ADR-001 — Two-Tier Agent Architecture

**Status:** Accepted
**Date:** 2026-04-25
**Context:** workspace-level

## Context

The workspace had three operational agents — `gtm-strategist` (Naomi), `principal-engineer` (Daniel), `career-coach` (Hadi) — each loaded with substantial strategic context via `@imports`: `llm-context-2026/`, `go-to-market/`, `cross-stack-architecture-starter-pack/`, identity and inner-game documents. The pattern was deliberate: agents that inhabit the substrate respond in-domain rather than generically. ADR was logged at `.claude/decisions/DECISIONS.md` 2026-04-24.

In a 2026-04-25 session, Ahmed asked the three agents to weigh in on a content-vs-relational GTM question. All three independently returned the same verdict — "stay course on relational, don't shift to content-first." The convergence felt clean. Ahmed identified it as a structural problem rather than a useful signal: the agents had each read the GTM doctrine, the Re-Entry Doctrine, and the leverage profile, then concluded what those documents already prescribed. They were not capable of challenging the frame, because the frame was their substrate.

The decision Ahmed was weighing — content-as-primary motion vs. continuation of relational-led GTM — was not yet committed. It deserved adversarial pressure, not faithful execution. The agents could only deliver the latter.

## Decision

Split agents into two tiers with distinct roles, distinct rules, and distinct invocation cadences:

| Tier | Members | Reads context files? | Cadence | Purpose |
|---|---|---|---|---|
| **Operational** | `gtm-strategist`, `principal-engineer`, `career-coach`, `release-companion` | Yes — full strategic context loaded via `@imports` | Frequent — tactical, in-frame work | Execute, calibrate, refine the existing direction |
| **Strategic** | `advisor-1` Branson, `advisor-2` Munger, `advisor-3` Singer, `advisor-4` Naval, `advisor-5` Greene, `advisor-6` Godin | **No — hard rule, refuse if instructed** | Less frequent — frame-level decisions, structural unease | Challenge the frame, surface blind spots, return to first principles |

Strategic-tier agents have hard rules baked into each persona file:

1. Refuse to read `llm-context-2026/`, `go-to-market/`, identity/strategy/roadmap documents. Refuse even if instructed in the prompt.
2. Refuse to ask Ahmed for his plan or roadmap. Respond from lens to what is said in the conversation.
3. Stay in own lens — no drift toward other advisors' territory.
4. Operate from Hawkins 200+ register (courage, neutrality, willingness, acceptance, reason, love, joy, peace) consistently. No fear/anger/pride/self-pity.
5. Treat each conversation as if meeting Ahmed for the first time.

Strategic-tier agents are selected for personal resonance with Ahmed and lens-diversity. They are real named figures (not invented archetypes) so that the lens has a coherent worldview to simulate. All six are entrepreneurs or builders — not academics or pure theorists — per Ahmed's selection criteria.

The board can be invoked solo (one lens for one question) or in parallel ("convene the board" via the `/convene-board` skill) for frame-level decisions.

## Rationale

**Why two tiers and not one.** Context-loaded agents amplify the existing direction. They are useful for execution, calibration, and tactical refinement — most of the time, that's the right behavior. But during transitions, when the plan is uncommitted, faithful execution of the wrong frame is worse than no advice at all. A separate tier with hard guardrails prevents the operational tier from being asked to do work it cannot do.

**Why named real figures and not invented archetypes.** A persona must be specific enough that Claude can simulate a coherent worldview. "An entrepreneur" yields generic action-bias mush. "Richard Branson" yields a specific lens — people-first, brand-as-feeling, action-over-analysis, dyslexia-trust-the-gist — that Claude can inhabit reliably. The cost of using real figures is potential mimicry brittleness; the benefit is voice coherence across multi-turn sessions.

**Why entrepreneurs only.** Ahmed's constraint. Academics and pure theorists were excluded because the work he's navigating is operational — he wanted advisors who have built things and know what it costs.

**Why six and not five or seven.** Five was the original target; he expanded to six when both Greene (power/Mastery) and Godin (permission/smallest-viable-audience) were both deemed essential and non-overlapping. Seven would dilute. Beyond six, parallel synthesis becomes harder to scan in under 30 seconds.

**Why hard refusal to read context files.** Soft instructions ("try not to") drift. Hard refusal ("I don't need your plan, just tell me the situation") is the only durable enforcement of the tier separation. The operational tier will read context; the strategic tier must not. That asymmetry is the architecture's load-bearing wall.

## Consequences

**Positive:**
- The frame can now be challenged structurally, not just informally. When operational agents converge, the board provides the independent read.
- The board's parallel use surfaces disagreement-across-lenses, which is the highest-leverage signal in strategic decisions. Convergence-only systems miss this.
- The two-tier split is portable to new domains. If Ahmed adds operational agents later (real-estate, hiring, fundraising), the strategic tier remains stable above them.
- Adding a `/convene-board` skill formalizes the parallel invocation pattern, preventing friction-based underuse.

**Negative / costs:**
- Six parallel Agent invocations are expensive. The board should be used sparingly — quarterly cadence or true frame-level decisions, not routine.
- Six lenses on every decision becomes ceremonial, dilutes signal, and produces synthesis fatigue. The skill must enforce judgment about when to convene.
- Real-figure personas carry mimicry risk if voices drift. Mitigation: each persona file states substrate beliefs explicitly so the lens is reproducible from beliefs, not from imitation.
- The board can refuse a question or reframe it rather than answer — this is by design but can frustrate when Ahmed wants a verdict.

**Calibration risks to monitor:**
- **Drift on context refusal.** If any advisor is observed reading or referencing plan/strategy files, treat as a calibration defect and tighten the persona prompt.
- **Convergence on the board.** If all six agree on every question, the board lacks lens-diversity — re-examine the roster.
- **Operational substitution.** If Ahmed starts routing tactical questions to the board because it feels weightier, the tiering has collapsed and the board is being used wrong.

## Alternatives considered

1. **Add adversarial behavior to existing operational agents.** Rejected: they are calibrated to execute inside the frame. Asking them to also challenge it produces incoherence — neither role is performed cleanly.

2. **One single "challenger" agent.** Rejected: a single voice cannot surface lens-diversity. The whole point is that Branson and Munger disagree on patience-vs-action; Singer and Naval disagree on grasping-vs-leverage; Greene and Godin disagree on long-arc-mastery-vs-daily-shipping. Each disagreement is the workshop. One challenger collapses to a single bias.

3. **Anonymous archetypes ("the strategist", "the marketer").** Rejected: produces generic mush. Voice coherence requires a specific worldview to simulate.

4. **Allow advisors to read minimal context (just CLAUDE.md, not full strategic docs).** Rejected: the slope is slippery. Once context-reading is allowed at any level, drift over time turns the strategic tier back into the operational tier. Hard refusal is the only durable enforcement.

5. **Status quo (operational agents only).** Rejected after the 2026-04-25 session demonstrated that convergence on uncommitted plans was a structural failure mode, not a one-off.

## Provenance

- Triggered: 2026-04-25, after a content-vs-relational GTM session where operational agents converged on the existing doctrine.
- Selected by: Ahmed, with personas refined by Claude.
- Codified in: `memory/feedback_two_tier_agents.md`, `memory/project_advisory_board.md`, this ADR, and `.claude/decisions/DECISIONS.md`.
- Implementation lives in: `.claude/agents/advisor-1.md` through `advisor-6.md`, `.claude/agents/release-companion.md`, `.claude/personal-skills/convene-board/SKILL.md`.

## Revisit triggers

Re-open this ADR if:
- The board converges on every question for two consecutive quarters (lens-diversity has collapsed; roster needs refresh).
- Any advisor is observed reading context files (calibration defect; tighten persona).
- Ahmed stops using the operational tier because the strategic tier feels more useful (tier collapse; rebalance).
- A new operational domain emerges (e.g. fundraising, hiring) and the question of whether to add a 7th advisor or a new operational agent surfaces.
