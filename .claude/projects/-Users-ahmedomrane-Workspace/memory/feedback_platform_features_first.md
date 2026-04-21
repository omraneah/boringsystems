---
name: Platform features first, custom code second
description: Before reimplementing anything structural (i18n, auth, redirects, caching, routing, state), check the framework's official docs for native support. Manual reimplementation of framework features is a recurring failure mode.
type: feedback
originSessionId: e464aaed-a5a0-4c1c-ac8b-19b9dd83adf6
---
Before writing structural code — i18n routing, redirects, auth, caching, routing middleware, state management, form handling — **check the framework's official docs for native support first.** Custom reimplementation of a framework feature is almost always wrong: it diverges from upgrade paths, misses SEO/accessibility affordances the framework provides, and duplicates logic that will drift.

**Why:** Session 2026-04-21 built a manual `/en/` + `/fr/` structure on boringsystems with hand-written redirects in `astro.config.mjs` and custom Nav locale logic. Astro 5 has `i18n: { defaultLocale, locales, routing: { prefixDefaultLocale: true } }` built in — it gives symmetric URLs, `getRelativeLocaleUrl()` helpers, content fallback, and middleware-compatible redirects for free. We built a lesser version of it by hand. This was not a one-off: the pattern "framework has it → we reinvent it → we discover the native version in a later session" is cheap to avoid and expensive to correct.

**How to apply:** Before the first line of structural code is written, the check is: "does the framework already do this?" The canonical check sequence:

1. Search the framework's official docs for the feature. Not memory — the docs. Framework APIs change faster than training data.
2. Search `<project>/docs/constraints.md` — the "never do X" list for this project may already forbid the custom path.
3. If the framework has a native version: use it. If it doesn't fit the exact need, document the gap in an ADR and then — only then — build custom.
4. If nothing exists: build it with the "typed registry" shape (`lead-magnets.ts` canonical on boringsystems) or whatever lightweight pattern matches.

**Domains to always check before writing custom code:**

- **Routing / i18n / redirects** — Astro, Next.js, and all modern meta-frameworks have native i18n.
- **Authentication** — provider SDKs (Clerk, Auth.js, WorkOS) before DIY session handling.
- **Database access** — framework adapters and typed ORMs before raw queries.
- **Caching** — framework `cache()`, `unstable_cache`, Vercel Runtime Cache before homegrown memoization.
- **Forms** — framework form actions (server actions, API routes) before custom handlers.
- **State management** — Server Components, URL state, form state before client stores.
- **SEO metadata (hreflang, canonical, OpenGraph)** — framework integrations usually exist.
- **Image / font optimization** — `next/image`, `astro:assets`, `next/font` before hand-tuned loaders.

The `/check-constraints` skill (boringsystems project-scoped) codifies this for that project's stack. Equivalent project-scoped skills should exist for any active project.
