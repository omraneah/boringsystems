---
name: Model × Effort × Lane Matrix
description: Decision matrix for choosing Claude model and effort level by task dimension, cadence, and complexity. Codifies the 2026-04-26 architectural decision. Workspace default Opus 4.7 / high.
type: feedback
---

The right model + effort isn't a single dial — three independent axes shape the choice:

1. **Task dimension** — psychology, positioning, advisors, code, ops, research
2. **Cadence** — exchange (back-and-forth, user is the loop closer) vs distilled (long output, model carries the pass)
3. **Complexity** — file writes / mechanical vs deep reasoning vs novel architecture

**Why:** Effort and response length are independent levers but correlate misleadingly. Higher effort biases the model toward longer, more complete output, which actively fights exchange cadence. Most users (Ahmed included before this matrix) intuit "higher effort = faster" — wrong. Higher effort = slower, deeper, longer reply. Lower effort = faster, shorter, more conversational. Model choice (Opus / Sonnet / Haiku) is the orthogonal lever for depth-of-reasoning quality vs speed-and-economy on operational work.

**How to apply:** Use the matrix below as defaults. Bump up only when complexity warrants. Bump down for mechanical work. Cadence is set primarily by prompting + system prompts, but effort biases the cadence the model defaults to.

## The matrix

| Lane | Model | Effort | Why |
|---|---|---|---|
| Psychology, release, emotional rabbit-holes | Opus 4.7 | `high` | Nuance matters + exchange cadence is the work. xhigh fights the cadence |
| Positioning, GTM, market research | Opus 4.7 | `high` | Iterative; user is the loop closer, not the model |
| Advisory board (`/convene-board`) | Opus 4.7 | `xhigh` per advisor | Each lens needs depth, fired in parallel, no internal exchange |
| Architecture decided → "go execute deeply" | Opus 4.7 | `max` (session-only) | Hand off deep reasoning, get one strong pass |
| Blog-site coding (boringsystems) | Sonnet 4.6 | `high` | Light, plenty smart, saves Opus quota |
| Heavy infra / backend coding | Opus 4.7 | `xhigh` | Default for serious code |
| Operational ops (`/commit`, `/pr`, `/github-cleanup`, `/tmp-cleanup`, `/log-decision`) | Sonnet 4.6 | `medium` | Speed > depth. Mechanical |
| Reflection / session recap (`/wrap-session`, `/session-pulse`) | Opus 4.7 | `high` | Pattern-recognition + improvement-proposal. Distilled, not exchange |
| Web / market research (long, distilled) | Opus 4.7 | `xhigh` | Long output OK; depth matters; no exchange inside the call |
| One-off "really think hard" turn | current model | current effort + word `ultrathink` in prompt | Bumps a single turn without committing the session |

## Workspace defaults

- Session default: **Opus 4.7 / high** — matches the dominant workload (strategic / psychological / positioning)
- Pinned in `.claude/settings.json` as `effortLevel: "high"` and `model: "opus[1m]"`
- Per-skill / per-agent overrides via frontmatter: `model:` and `effort:` fields in the YAML header

## Cascading order (which setting wins)

1. `CLAUDE_CODE_EFFORT_LEVEL` env var — highest precedence
2. `--effort` CLI flag at startup
3. Skill / agent / subagent frontmatter — when that skill or agent is active
4. `effortLevel` in settings.json — workspace / user
5. Model default (`xhigh` for Opus 4.7, `high` for Opus 4.6 / Sonnet 4.6)

## Three reasons NOT to follow the matrix

- User explicitly asks to bump or drop — honor it
- Lane shifts mid-session — invoke `feedback_lane_change_announcement.md` (announce + recommend)
- Genuinely hard problem warrants `max` for one session — set deliberately via `/effort max`, don't drift

## When this matrix moves (revisit triggers)

This is a 2026-04-26 snapshot. Revisit when:

- A new model is released or default changes (Opus 4.8, Sonnet 5, etc.)
- A new effort level is added (`xhigh` was added in 4.7; assume more variation will come)
- A recurring task type doesn't fit any row cleanly — propose a new row
- Effort/length correlation changes (Anthropic could decouple them in a future release)

Decision log: `decisions/` for the architectural rationale.
