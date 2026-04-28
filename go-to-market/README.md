# Go-To-Market — Ahmed Omrane

Active, operational positioning. Evolves as signal arrives.

This folder is the source of truth for how Ahmed shows up in the market — LinkedIn positioning, the freelance offers on the table, the bets behind them, and the inbound signal used to validate or invalidate those bets.

It's **operational** — updated weekly as inbound lands and positioning iterates. That's the distinction from `memory/`, which holds the slower-moving strategic brain (identity, doctrine, inner-game) and is read-only.

## What lives here

| File | Purpose | Update cadence |
|---|---|---|
| `linkedin.md` | Current LinkedIn headline + bio, versioned. Prior positioning kept as diff notes. | Each LinkedIn edit |
| `offers.md` | The freelance offers currently on the table — structure, pricing logic, stated deliverables, target buyer. | When an offer shifts |
| `hypotheses.md` | Active bets about the market and how Ahmed is positioning into it. Each hypothesis has an invalidation trigger. | When reality confirms or contradicts a bet |
| `signals.md` | Running log of inbound signal — DMs, referrals, advisory-call requests, rejections. Feeds hypothesis updates. | Per-inbound, or weekly batch |
| `outreach-templates.md` | Reusable outbound message templates — warm-tie reactivation, etc. Bucketed by relationship depth and cross-cultural notes. | When a new pattern earns its keep |
| `inbound-call-discipline.md` | Operating principles for inbound calls (Fractional CTO, Sprint, Transformation, advisory). Discovery-before-anchor, skin-in-the-game, slow-down, feedback ask. | When the discipline gets sharpened by a real conversation |
| `credibility-map.md` | Three-zone map of what the resume sells credibly, with friction, or not at all. Constrains offer design and qualifies inbound live. | Re-read every 6 months against actual inbound |

## Relationship to other folders

- **`memory/medium-term/market/`** — strategic context (leverage profile, positioning doctrine). Read-only. Referenced when a GTM decision needs strategic grounding.
- **`boringsystems/`** — the public content expression of the positioning (case files, lanes, personas). Persona doctrine lives in `boringsystems/docs/target-audiences.md`.
- **`personal-apps/`** — portfolio side of the positioning, surfaced on `portfolio.boringsystems.app`.

When GTM shifts, the downstream expressions (site IA, article voice, LinkedIn copy) may need to catch up — but that's a separate, follow-on action, not automatic.

## Update protocol

1. When a conversation surfaces new GTM signal (inbound pattern, positioning iteration, offer refinement, market feedback), run `/gtm-sync`.
2. The skill proposes the specific file and section to update. Never writes silently.
3. Invalidation triggers on hypotheses are checked at each update — if a hypothesis has been invalidated, mark it resolved and note the replacement thinking.
4. LinkedIn edits go into `linkedin.md` verbatim, with a dated diff note capturing what changed and why.

## Quick current snapshot (2026-04-22)

- **Status:** 2 months remaining in current role (Enakl exit mid-2026). Freelance-first for the 6 months following the exit — 2026 second half is about navigating solo-preneurship.
- **Primary channel:** LinkedIn. Recent headline shift moved inbound away from founding-engineer / IC-under-manager pattern toward Principal / Staff / Head-of roles and fractional CTO conversations.
- **Three offers on the table:** Fractional CTO (rolling quota), Sprint Founder-Builder (multi-week MVP+judgment build), Transformation Lead (non-IC migrations at larger corps).
- **Open question:** which of the three freelance offers concentrates the highest-quality inbound over the next 60 days.
