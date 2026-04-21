---
name: check-constraints
description: Before writing or modifying structural code on boringsystems (i18n/routing, auth, caching, redirects, build pipeline, dependency addition, SEO metadata, major layout), scan `docs/constraints.md` for rules that apply and verify the planned approach does not violate them. Also checks the framework's native-feature list before greenlighting custom implementation. Auto-invoke when about to write this kind of code, or run manually before planning a significant change.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, WebSearch, WebFetch
argument-hint: "[optional: short description of the planned change]"
---

Pre-flight constraint check for any structural change on boringsystems.

Do not announce the skill invocation. Produce the check directly.

## When to run

**Auto-invoke when about to:**
- Add or remove a dependency.
- Touch `astro.config.mjs`, `src/layouts/*`, `src/content/config.ts`, or `src/lib/i18n.ts`.
- Implement i18n, routing, redirects, auth, caching, image pipeline, or SEO metadata.
- Build a new reusable UI pattern that will be used in multiple places.
- Refactor selection/filtering logic on the home page or lane indexes.
- Introduce a new content collection or modify an existing one.
- Add a new hook to `.claude/hooks/`.

Skip for pure content changes (writing an article, tweaking copy), pure styling tweaks, or bug fixes in a single non-structural file.

## Steps

1. **Read `docs/constraints.md`.** Full read. The constraints are short.
2. **Restate the planned change** in one sentence at the top of the check. This forces precision.
3. **Map the change to applicable constraint sections.** Name each one that applies. If none apply obviously, note that and continue.
4. **For each applicable constraint, verify compliance.** State either (a) "OK — planned approach respects the constraint" or (b) "VIOLATION — proposed approach conflicts with [constraint name]". Cite the exact line from `constraints.md`.
5. **Native-feature check.** If the change touches a domain where the framework typically has native support (i18n, redirects, caching, images, fonts, RSS, sitemap, content, middleware/proxy, form handling), explicitly state:
   - The native Astro/Vercel feature that covers it (with a doc URL — use WebFetch if uncertain).
   - Whether the planned implementation uses it, wraps it, or replaces it.
   - If replacement: why the native version is insufficient, and propose an ADR entry justifying the custom path.
6. **Dependency check.** If the change adds a dep, verify:
   - The package is actively maintained (last release within 12 months).
   - It does not pull playwright/puppeteer/chromium transitively (check `npm info <pkg>` or the package's README).
   - No native alternative exists.
7. **Decision log check.** If the change is non-trivial architecturally, propose a `DECISIONS.md` entry and invoke `/log-decision` after the change ships.
8. **Verdict.** One of: **GO** (all clear), **GO-WITH-ADR** (non-violating but non-trivial, needs a decision log entry), **REVISE** (violation found — propose the compliant alternative), **STOP** (framework has a native feature that should be used instead — name it).

## Output shape

Terse and structured. No narration. Example:

```
Plan: Add PostHog for analytics.

Constraints that apply:
- "Check framework-native support before adding a dep" → Vercel Analytics is already in package.json and covers page-views/web-vitals. POSTHOG adds session replay + funnels, which Vercel Analytics does not.
- "Never pin to a package that hasn't been updated in >12 months" → posthog-js released 4 weeks ago. OK.
- "No build-time browser deps" → posthog-js is runtime client-side. OK.

Native check:
- Vercel Analytics: installed. Covers basic metrics.
- Vercel Web Analytics (custom events): covers funnel-lite if needed.
- Gap: no session replay. This is the justification for PostHog.

Dependency check:
- posthog-js v1.x, active. No chromium transitively.

Verdict: GO-WITH-ADR. Propose DECISIONS entry: "Add PostHog for session replay — Vercel Analytics covers metrics but not session UX review; PostHog fills that gap without replacing the Vercel stack."
```

## What this skill is not

- Not a code review. Use `/arch-review` (lightweight) or `/review` (PR-level) for that.
- Not a build verifier. Use `/verify-home` for surface-level home page smoke tests.
- Not a replacement for reading the docs. The skill tells you *where to look*; it does not absolve the need to check the official documentation when uncertain.

## Guardrails

- If a constraint would force the scope of the change to balloon, stop and propose scope reduction to Ahmed. Do not silently widen the change to comply.
- If the user has explicitly asked for a violation ("just do it this way"), note the violation clearly, do the work, and insist on a decision log entry capturing the override.
