# ADR-004 — Analytics Tooling: Mixpanel + Vercel Analytics

**Status:** Accepted  
**Date:** 2026-05-02  
**Decider:** Ahmed Omrane  
**Scope:** boringsystems.app only.

## Decision

Run Mixpanel (EU data residency) and Vercel Analytics side-by-side. Both are free. Both are consent-free. They serve different purposes.

## Why both tools

**Vercel Analytics** runs at the edge, zero config, aggregate traffic counts and referrers. Useful as a sanity-check layer. Its 30-day retention window and lack of custom events make it insufficient for behavioral analysis on its own.

**Mixpanel** is the primary analysis layer. The goal is to understand how visitors actually navigate the site: where they come from, what they click, which articles they read vs. skim, where they go after. UTM attribution per-pageview tells which distribution channels drive real engagement. Custom events on high-value actions (lead magnet, contact form, scroll depth, language toggle, outbound clicks) give signals the aggregate traffic view never would.

## Why Mixpanel specifically

- Operator knows Mixpanel from Fabulous (20M DAU) — fastest path from decision to working instrumentation.
- EU data residency on free tier (Netherlands DC, `api-eu.mixpanel.com`).
- `persistence: 'none'` — Mixpanel writes nothing to the browser (no cookies, no localStorage). No GDPR/CNIL consent required.
- Free tier is sufficient for current traffic volume.

## GDPR / CNIL posture

`persistence: 'none'` means no storage writes on the visitor's device. CNIL requires consent only when analytics tools write to terminal equipment. This setup does not. No consent banner needed. Same posture as Vercel Analytics.

## Deduplication

With `persistence: 'none'`:

- No cookie or localStorage — Mixpanel cannot reliably link two separate sessions to the same person.
- Each page load on a full-page-reload site gets a fresh anonymous `distinct_id`.
- Mixpanel clusters events server-side by IP + user-agent for approximate deduplication, but this is heuristic.

**For weekly aggregate analysis this is acceptable.** You're reading event counts and navigation patterns — not individual journeys. UTM attribution and `$referrer` chains are per-pageview and accurate regardless of deduplication.

If reliable user-level deduplication becomes load-bearing (e.g., funnel analysis across sessions), the path is: persistent first-party cookie (requires CNIL consent for French audience) or server-side ID assignment. Not needed at this stage.

## What was NOT chosen

| Alternative | Why not |
|---|---|
| Plausible (€9/mo) | Consent-free. Good for aggregate counts. No custom events, no UTM attribution depth, no behavioral sequences. |
| PostHog | Equivalent capability. 30–45 min longer to ship for an operator with no PostHog experience. |
| Vercel Analytics only | Good for traffic counts. No custom events, no UTM, no behavioral data. Stays as secondary sanity-check layer. |
| Server-side tracking | Stronger deduplication, avoids all client-side constraints. More work. Revisit if `persistence: 'none'` proves insufficient. |

## Implementation

- Token: `PUBLIC_MIXPANEL_TOKEN` env var (Vercel dashboard). Never hardcoded.
- EU API endpoint: `https://api-eu.mixpanel.com`
- `cross_subdomain_cookie: false` — scoped to boringsystems.app, not subdomains
- `ip: false` — IP not stored
- `track_pageview: 'url-with-path'` — hash/query string changes don't generate noise pageviews
- Super properties on init: `lane`, `language`
- Event taxonomy (5 max for v1): see `docs/analytics.md`

## Upgrade triggers

- Persistent deduplication becomes load-bearing → persistent cookie (with CNIL consent flow) or server-side tracking
- Free tier limits hit → evaluate Mixpanel paid plan
- Cross-subdomain tracking with portfolio.boringsystems.app becomes needed → revisit `cross_subdomain_cookie`

## References

- Mixpanel EU data residency: https://mixpanel.com/legal/eu-data-residency/
- CNIL guidelines on analytics: https://www.cnil.fr/en/sheet-ndeg16-use-analytics-your-websites-and-applications
