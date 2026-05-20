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
| `inbound-call-discipline.md` | Operating principles for inbound calls (Shape A mandate, Shape B fractional / transformation). Discovery-before-anchor, skin-in-the-game, slow-down, feedback ask. | When the discipline gets sharpened by a real conversation |
| `credibility-map.md` | Three-zone map of what the resume sells credibly, with friction, or not at all. Constrains offer design and qualifies inbound live. | Re-read every 6 months against actual inbound |
| `website.md` | Operational tactic for the `boringsystems.app` surface — funnel positioning, pre-funnel aesthetic-filter principle, rename-considered-and-rejected paragraph, secondary-domain experiment trigger conditions. Cross-references `strategy.md` § Surface 2. | When site positioning, tactics, or trigger conditions shift |
| `inbound-recruiter-doctrine.md` | Operating principle for LinkedIn recruiter inbound — ~80% wrong altitude, treat as market intelligence, don't close immediately, French cultural calibration (register not bluntness), freelance pivot when complexity is present. Airtable (Professional Transition → LinkedIn Inbound) is the live log; read that for current state. | When a pattern from the Airtable invalidates or sharpens the doctrine |
| `strategy.md` | Lean distribution architecture — three surfaces (LinkedIn → Shape A, warm network → Shape B, boringsystems → reputation currency). Position synthesis + drivers + filters live in `memory/medium-term/`. Prior cornerstone (2026-04-24, four-path framework) archived at `_outdated/strategy-2026-04-24.md`. | When distribution architecture shifts |

## `_outdated/` — do not read unless directed

Files superseded by the 2026-05-20 distillation pass are preserved in `_outdated/` for reference. **Do not read `go-to-market/_outdated/` unless Ahmed explicitly points to it.** The current files are downstream of those; reading them now risks drift back into a released frame. See `_outdated/README.md`.

## Relationship to other folders

- **`memory/medium-term/Drivers-and-Filters.md`** — qualification layer (what pulls, what disqualifies, position synthesis). Read-only. Upstream of every GTM decision.
- **`memory/medium-term/Engagement-Shapes.md`** — structural definitions of Shape A and Shape B. Read-only. The codified version of `offers.md`.
- **`memory/medium-term/market/`** — operational strategic context (sales-mode tactics, visibility OS, pre-funnel filter). Read-only.
- **`boringsystems/`** — the public content expression of the positioning (case files, lanes, personas). Persona doctrine lives in `boringsystems/docs/target-audiences.md`.
- **`personal-apps/`** — portfolio side of the positioning, surfaced on `portfolio.boringsystems.app`.

When GTM shifts, the downstream expressions (site IA, article voice, LinkedIn copy) may need to catch up — but that's a separate, follow-on action, not automatic.

## Update protocol

1. When a conversation surfaces new GTM signal (inbound pattern, positioning iteration, offer refinement, market feedback), run `/gtm-sync`.
2. The skill proposes the specific file and section to update. Never writes silently.
3. Invalidation triggers on hypotheses are checked at each update — if a hypothesis has been invalidated, mark it resolved and note the replacement thinking.
4. LinkedIn edits go into `linkedin.md` verbatim, with a dated diff note capturing what changed and why.

## Quick current snapshot (2026-05-20)

- **Status:** ~6 weeks remaining in the current chapter (transition end-June 2026). The 6 months following are the re-stabilize phase (July → December 2026).
- **Position synthesis:** *influence-based change leadership in complex orgs rooted in real constraints — engineering, systems, teams, operations — hands-on under half, no direct-report-heavy authority, in France, with people I'm aligned with.* Codified in `memory/medium-term/Drivers-and-Filters.md`.
- **Two valid shapes:** Shape A (mandate inside a company, LinkedIn inbound), Shape B (fractional / freelance via warm network — fractional CTO/CPO sub-shape + transformation freelance sub-shape). Codified in `memory/medium-term/Engagement-Shapes.md`.
- **Primary channels:** LinkedIn for Shape A inbound (v4 draft pending). Warm network for Shape B inbound (discovery-session-first). boringsystems as reputation currency for both.
- **Open question:** does the warm-graph position synthesis land in real conversations as legible and forwardable (H2 in `hypotheses.md`).
