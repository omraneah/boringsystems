---
name: analytics-audit
description: Audit a new component or page for missing analytics wiring. Checks that new outbound links use data-track-outbound, new CTAs/conversion actions call the analytics library, and no mixpanel.track() calls exist outside src/lib/analytics.ts. Run before committing any component with new outbound links or CTAs.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
argument-hint: "[optional: path to the component or page to audit]"
---

Analytics wiring audit for boringsystems components and pages.

Do not announce the skill invocation. Produce the audit directly.

## What this checks

1. **Outbound links** — every `<a>` pointing outside `boringsystems.app` must have `data-track-outbound="[url]"`. The delegated handler in `Analytics.astro` fires `outbound_link_clicked` automatically.
2. **CTA / conversion actions** — form submissions, lead magnet captures, and any action that represents a visitor decision must call the appropriate function from `src/lib/analytics.ts`.
3. **No raw Mixpanel calls** — `mixpanel.track()` must never appear in components. All calls go through `src/lib/analytics.ts`.
4. **No new event types outside the v1 taxonomy** — the 5 custom events in `docs/analytics.md` are the ceiling for v1. No new events without operator approval.

## Steps

1. **Identify the target.** If an argument was passed, audit that path. Otherwise, audit all files modified in the current git diff (`git diff --name-only HEAD`).
2. **For each `.astro`, `.ts`, `.tsx` file in scope:**
   - Grep for `<a href` — check if any href points outside `boringsystems.app` without `data-track-outbound`.
   - Grep for `fetch(` or `form.addEventListener` — check if any conversion action lacks an analytics call.
   - Grep for `mixpanel.track(` — flag any occurrence outside `src/lib/analytics.ts`.
3. **Read `docs/analytics.md`** for the authoritative event taxonomy. Flag any event name not in the taxonomy.
4. **Emit a verdict** per file: PASS, WARN (missing tracking but not a conversion action), or FIX (missing tracking on a conversion action or outbound link, or raw mixpanel call).

## Output shape

```
File: src/components/Footer.astro
  ✓ LinkedIn link has data-track-outbound
  PASS

File: src/components/SomeNewComponent.astro
  ✗ <a href="https://github.com/..."> — missing data-track-outbound
  FIX: add data-track-outbound="https://github.com/..." to the link

File: src/pages/en/writing/[slug].astro
  ✓ No outbound links. No conversion actions.
  PASS
```

## Guardrails

- If a new event type is needed but not in the taxonomy: STOP. Do not add it. Surface the need to Ahmed with a one-line rationale. The v1 observation window (minimum 2 weeks post-launch) must close before the taxonomy expands.
- Internal links (`/en/...`, `/fr/...`) do not need `data-track-outbound`. Only external links (non-boringsystems.app domains) need it.
