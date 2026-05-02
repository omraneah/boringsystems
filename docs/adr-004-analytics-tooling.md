# ADR-004 — Analytics Tooling: Mixpanel (Experimental)

**Status:** Accepted  
**Date:** 2026-05-02  
**Decider:** Ahmed Omrane  
**Scope:** boringsystems.app only. Portfolio subdomain is a separate surface.

## Decision

Mixpanel (EU data residency — Netherlands DC) with a minimal GDPR consent banner.

## Context and forces

1. Conversion measurement must precede the P2 conversion funnel (Camille's rule, 2026-05-01). Analytics now = historical baseline by the time the funnel ships.
2. SEO/AEO consolidation needs retention windows beyond Vercel Analytics' 30-day cap.
3. Operator knows Mixpanel from Fabulous (20M DAU) — fastest path from decision to working instrumentation.
4. Vercel Analytics (previously installed) is CNIL-exempt but lacks UTM attribution and custom events. Removed as part of this work.
5. Plausible (€9/mo, consent-free, sufficient for v1 observation window) was the recommendation. Operator chose Mixpanel for depth and familiarity.

## Hard constraints (non-negotiable)

1. **EU data residency.** Netherlands DC. Configured at project creation. Irreversible on free tier.
2. **No fingerprinting.** No canvas/browser fingerprinting (FingerprintJS-style). No IP-based deduplication.
3. **User deduplication via Mixpanel `distinct_id`.** Stored as a first-party cookie. Same browser across sessions = same user. Requires GDPR consent.
4. **GDPR consent banner required.** CNIL 2025-2026: analytics cookies (and localStorage UUIDs) require explicit consent for French audience. Visitors who decline are invisible — accepted trade-off.
5. **Scope: boringsystems.app only.** `cross_subdomain_cookie: false`. Portfolio subdomain is a separate project.

## What was NOT chosen and why

| Alternative | Why not |
|---|---|
| Plausible (€9/mo) | Consent-free and sufficient for v1. Recommended but operator chose Mixpanel for behavioral depth and prior familiarity. Best fallback if consent decline rate proves unacceptable. |
| PostHog | Equivalent capability, but 30–45 min longer to ship for an operator with no PostHog experience. |
| Vercel Analytics (was installed) | No UTM attribution, no custom events, no user-level data. Removed. |
| Server-side tracking | Stronger privacy, avoids consent banner. More work. Defer unless client-side proves problematic. |

## Posture: experimental, throwaway-acceptable

No custom dashboards for 2 weeks. Observe raw data first. If Mixpanel earns a rebuild after the observation window, rebuild with better design rationale.

## Upgrade triggers (revisit this ADR if)

- Consent decline rate > 40% among French visitors → evaluate Plausible migration
- EU regulatory changes tighten Mixpanel's compliance posture
- Server-side tracking becomes a priority (privacy-first redesign)
- Cross-domain tracking with portfolio subdomain becomes load-bearing

## Implementation

- Token: `PUBLIC_MIXPANEL_TOKEN` env var (Vercel dashboard). Never hardcoded.
- EU API endpoint: `https://api-eu.mixpanel.com`
- `cross_subdomain_cookie: false` — scoped to boringsystems.app only
- `ip: false` — IP not stored
- `track_pageview: 'url-with-path'` — hash/query changes don't create noise pageviews
- Dynamic import (`import('mixpanel-browser')`) inside `initMixpanel()` — Mixpanel JS only loads after consent
- Super properties on init: `lane`, `language`, `voice_target`, `is_returning`
- Event taxonomy (5 max for v1): see `docs/analytics.md`

## References

- Mixpanel EU data residency: https://mixpanel.com/legal/eu-data-residency/
- CNIL Sheet n°16 on analytics: https://www.cnil.fr/en/sheet-ndeg16-use-analytics-your-websites-and-applications
- BOR-40 (operational card): https://linear.app/boringsystems/issue/BOR-40
- Event taxonomy and tracking reference: `docs/analytics.md`
