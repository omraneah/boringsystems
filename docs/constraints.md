# Project constraints — boringsystems

The "never do X" list for this project. Read this before writing structural code. These constraints encode the *actual* reasons for past decisions — if you're tempted to violate one, the decision log (`.claude/decisions/DECISIONS.md` at workspace level) has the context of why it exists.

The `/check-constraints` skill runs through this file whenever a structural change is in flight.

---

## Build & deployment

- **Never introduce a build-time browser dependency.** No `playwright`, no `puppeteer`, no `chromium-*` in runtime or build. The deploy runs on Vercel's build machines; chromium pulls ~150MB and can fail silently in sandboxed builds. When a feature needs a browser (SSR mermaid, OG image generation), use a client-side render or hand-craft the asset.
  - Canonical example: `rehype-mermaid` was rejected for this reason — replaced by a 12-line remark plugin + client-side mermaid.js. See DECISIONS.md `2026-04-21 — Mermaid via inline remark plugin`.

- **Never use CSS `transform: scale()` for vector zoom.** It rasterizes at the natural size first and upscales the bitmap. Scale via the element's intrinsic attributes (SVG `width`/`height` in pixels, driven by scale × base size). See DECISIONS.md `2026-04-21 — Vector-clean mermaid zoom`.

- **Never deploy without `npx astro build` passing locally.** The Stop hook at workspace level runs `astro check` after every turn on a feature branch; its summary surfaces in the next SessionStart. No silent drift.

- **Enforcement is local-first by design.** No GitHub Actions, no CI runner, no PR-workflow gates. The merge gate is the pre-commit hook (`astro check` + `scripts/verify-structure.ts` + `astro build`), wired via `simple-git-hooks` and installed by `npm install`. See `docs/adr-003-enforcement-tier.md` for the principle reconciliation against `quality-security-boundaries.md` and the upgrade trigger. `--no-verify` is forbidden.

- **No unit tests by design at this tier.** The structural-integrity script replaces the class of tests a SaaS codebase would write. Unit coverage on `mailer.ts` or `toLocalePath` would test the standard library, not the domain. Re-evaluate when the ADR-003 upgrade trigger fires.

- **Pre-push hook blocks high/critical npm vulnerabilities.** `npm audit --audit-level=high` must exit clean before a push is accepted. Fix path: `npm audit fix` (non-breaking), npm `overrides` for transitive patches, or — when a CVE is not exploitable in this project's context — an entry in `docs/adr-003-enforcement-tier.md` documenting the accepted risk. Never `--no-verify`.

## Routing & i18n

- **Every page lives under `/en/` or `/fr/`.** No implicit default locale. The root `/` 301-redirects to `/en/` via the `redirects` map in `astro.config.mjs`. No other redirects exist — folder = URL is authoritative. See DECISIONS.md `2026-04-21 — Strict /en + /fr i18n`.

- **Use Astro's native i18n primitives for locale-aware URLs.** Import `getRelativeLocaleUrl` from `astro:i18n` instead of hardcoding `/en/foo`. For slugs that differ per locale, use `toLocalePath` from `src/lib/i18n.ts` which knows the slug alias table (empty after the 2026-04-22 restructure — all lanes now share identical slugs across locales). Never reimplement locale routing by hand.

- **Every page-level head emits hreflang tags.** `Base.astro` and `Article.astro` both call `hreflangsForPath()` from `src/lib/i18n.ts`. If you add a new layout, wire hreflang in — do not ship a page without the `<link rel="alternate">` pairs, or SEO silently bleeds.

- **Every article must exist in both EN and FR.** Applies to all four lanes (Writing, Work, Building, Archive). The hreflang logic assumes mirror content. If a locale-specific piece is ever added, update `src/lib/i18n.ts`'s SLUG_ALIASES and document in DECISIONS.md; do not add orphan content.

## Imports

- **Use the `@/` path alias for all imports from `src/`.** `@/*` maps to `./src/*` via `tsconfig.json`. No `../../../lib/x` in any `.astro`, `.ts`, or `.mdx` file — always `@/lib/x`. Applies to pages, components, layouts, content MDX imports, and `scripts/*.ts` (the `tsx`-run structural-verify script honours the same alias). Moving a file under `src/` should not require import edits elsewhere; relative-depth paths make that false. **Enforced by `scripts/verify-structure.ts` → `verifyImportsConvention()`** — the pre-commit hook fails on any `from '../...'` under `src/` or `scripts/`, pointing at the line with the violation.

## API surface

- **Every API route lives under `/api/v{N}/`.** Current version is `v1`. Per `cross-stack-architecture-starter-pack/api-boundaries.md`, unversioned routes are forbidden. Breaking changes introduce a new version segment; additive changes land within the current version. Form clients point at the versioned base URL.

- **Shared `json()` response helper.** All API routes use `src/lib/http.ts`'s `json()` — do not re-implement `new Response(JSON.stringify(...))` inline. Single source of truth for content-type headers and status shape.

## SEO and AEO

- **Every page must emit OG and Twitter Card tags.** `Base.astro` and `Article.astro` both emit the full set: `og:type`, `og:title`, `og:description`, `og:url`, `og:site_name`, `og:image`, `og:locale`, `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`. If you add a new layout, wire these in — do not ship a page without them.
- **Every article must emit JSON-LD Article schema.** `Article.astro` emits `Article` with `headline`, `description`, `author` (Person), `publisher` (Organization), `datePublished`, `mainEntityOfPage`, and `url`. No new layout should omit this.
- **Homepage and Base layout emit JSON-LD Person + WebSite schema.** Declared in `Base.astro`. The Person schema includes `sameAs` with the LinkedIn and Medium URLs — keep these current.
- **`robots.txt` is in `public/`.** Never delete or block crawlers from content paths. AI crawlers (GPTBot, ClaudeBot, PerplexityBot, Google-Extended) are explicitly allowed.
- **`llms.txt` is in `public/`.** Update the key pieces list when a new high-signal article ships.
- **Every article description must be a proper description, not a tagline.** Descriptions are the meta description for search and answer engines — they should describe the content specifically, not echo the site tagline. Check: does this description tell a search engine what the article covers?
- **Cross-references are mandatory on every article.** Before publishing any new article, run `/cross-ref-check` to audit for missing internal links. Every article must link to at least two related pieces (same-site). Hub-and-spoke applies: the pillar piece in a cluster should link to all spokes; each spoke should link back to the pillar and to at least one sibling.
- **External company links are required where companies are named.** When naming Enakl or The Fabulous in article body text, link to enakl.com or thefabulous.co on first mention in each article. Do not name companies without linking.
- **FR parity on cross-references.** Every internal link added to an EN article must have an FR equivalent in the FR mirror. FR URLs use `/fr/` prefix.

## Content

- **Frontmatter `date` is mandatory for Writing, Work, and Building articles.** Not required for Archive (playbooks are principles, not time-stamped). First-merge git date via `git log --follow --diff-filter=A --format=%aI -- <path> | tail -1`. Article-review skill blocks missing dates.

- **Lane folder + filename = URL. Subfolders in between are free.** For every content collection, the first-level folder (`writing-en/`, `work-fr/`, `archive-en/`, …) is the URL lane and the file basename (no extension) is the URL slug. Any subfolders between them are organizational grouping only and **must not appear in URLs**. Canonical example: archive playbooks are grouped on disk as `archive-{lang}/operating-playbooks/series-{N}-{name}/s{N}-p{M}-<slug>.md` but render at `/{lang}/archive/s{N}-p{M}-<slug>`. Every `[slug].astro` route maps `entry.slug.split('/').pop()` back to the param, and `scripts/verify-structure.ts` enforces per-collection basename uniqueness so two files in different subfolders can't collide at the same URL.

- **New article slugs default to the title kebab-cased.** Take the title, lowercase, drop em-dashes, colons, commas, apostrophes; replace spaces with hyphens; collapse repeats. That's the slug. The forcing function is on the title side: if the title would make a bad slug, fix the title before publishing. Deviate only with a stated reason. **Never rename a published slug** — preserve URL stability for inbound links. Description frontmatter must match the piece's voice target (no engineer-coded jargon in builder-target pieces, no consumer-soft language in technical pieces). The article-review skill warns on title/slug mismatch for new articles and on description/voice-target mismatch.

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
