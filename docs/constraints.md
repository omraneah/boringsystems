# Project constraints — boringsystems

The "never do X" list for this project. Read this before writing structural code. These constraints encode the *actual* reasons for past decisions — if you're tempted to violate one, the decision log (`.claude/decisions/DECISIONS.md` at workspace level) has the context of why it exists.

The `/check-constraints` skill runs through this file whenever a structural change is in flight.

---

## Build & deployment

- **Never introduce a build-time browser dependency.** No `playwright`, no `puppeteer`, no `chromium-*` in runtime or build. The deploy runs on Vercel's build machines; chromium pulls ~150MB and can fail silently in sandboxed builds. When a feature needs a browser (SSR mermaid, OG image generation), use a client-side render or hand-craft the asset.
  - Canonical example: `rehype-mermaid` was rejected for this reason — replaced by a 12-line remark plugin + client-side mermaid.js. See DECISIONS.md `2026-04-21 — Mermaid via inline remark plugin`.

- **Never use CSS `transform: scale()` for vector zoom.** It rasterizes at the natural size first and upscales the bitmap. Scale via the element's intrinsic attributes (SVG `width`/`height` in pixels, driven by scale × base size). See DECISIONS.md `2026-04-21 — Vector-clean mermaid zoom`.

- **Never deploy without `npx astro build` passing locally.** The Stop hook at workspace level runs `astro check` after every turn on a feature branch; its summary surfaces in the next SessionStart. No silent drift.

## Routing & i18n

- **Every page lives under `/en/` or `/fr/`.** No implicit default locale. The root `/` and all legacy flat URLs 301-redirect to their `/en/` equivalents via the `redirects` map in `astro.config.mjs`. See DECISIONS.md `2026-04-21 — Strict /en + /fr i18n`.

- **Use Astro's native i18n primitives for locale-aware URLs.** Import `getRelativeLocaleUrl` from `astro:i18n` instead of hardcoding `/en/foo`. For slugs that differ per locale (currently only `essays` ↔ `essais`), use `toLocalePath` from `src/lib/i18n.ts` which knows the slug alias table. Never reimplement locale routing by hand.

- **Every page-level head emits hreflang tags.** `Base.astro` and `Article.astro` both call `hreflangsForPath()` from `src/lib/i18n.ts`. If you add a new layout, wire hreflang in — do not ship a page without the `<link rel="alternate">` pairs, or SEO silently bleeds.

- **Every case file and playbook must exist in both EN and FR.** The hreflang logic assumes mirror content. If a locale-specific piece is ever added, update `src/lib/i18n.ts`'s SLUG_ALIASES and document in DECISIONS.md; do not add orphan content.

## Content

- **Frontmatter `date` is mandatory on case files.** First-merge git date via `git log --follow --diff-filter=A --format=%aI -- <path> | tail -1`. Article-review skill blocks missing dates.

- **Home selection flags are pinned by ADR-002.** `featured` = grid listings; `highlight` = home highlights stack; `order` = sort key. Do not add new flags (`homePinned`, `showOnHome`, etc.) — widen the selection logic instead. See `docs/adr-002-home-selection.md`.

- **FR content is re-voiced, not translated.** Per `docs/french-guide.md`: same meaning, French operator register, keep English jargon (startup, MVP, pipeline, deploy, etc.). Run `/french-audit` before committing FR content.

## Content collections & reusable UI

- **Typed content registries for reusable UI content.** Pattern canonical at `src/lib/lead-magnets.ts`: typed record keyed by slug, locale-indexed fields, `getEntry(slug)` accessor. Apply to testimonials, stack cards, CTAs, pricing — anything that repeats with locale variants. See `docs/architecture-and-toolchain.md`.

- **No generic registry abstraction.** One short typed file per content type. Never build a generic `<ContentRegistry />` wrapper with reflection — it loses the type safety that makes the pattern worth using.

## Dependencies

- **Check framework-native support before adding a dep.** Astro 5 and Next.js 16 cover most "I need a library for…" needs natively: i18n, redirects, image optimization, font loading, caching, analytics, content collections, RSS, sitemap, proxy/middleware. Read the official docs first. If a native feature exists, use it. Only add a dep when the framework genuinely has no answer.

- **Never pin to a package that hasn't been updated in >12 months** without flagging it. Stale deps are future security/compat debt.

- **Dependency rejections are logged.** When you reject a dep (like `rehype-mermaid`), add a DECISIONS entry explaining why. Future-you will thank present-you for not re-evaluating the same tradeoff six months later.

## Workflow

- **Never push to `main`.** Feature branch, PR, Ahmed opens the PR on GitHub. Auto-commit hook handles feature-branch commits.

- **Max three concerns per branch.** If the current branch spans more concerns, split. See `memory/feedback_scope_discipline.md` at workspace level.

- **When a pattern repeats twice in a session, codify before the third time.** Skill, hook, doc, memory, or ADR — pick one of the five. See `memory/feedback_twice_is_a_pattern.md` at workspace level.
