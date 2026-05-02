# boringsystems — Project Context

Ahmed's engineering-leadership site. Astro 5, deployed on Vercel.

## Stack

Astro 5 · MDX · Vanilla CSS with design tokens · Vercel adapter · Resend (transactional email) · Neon (when state is needed) · mermaid.js (client-side rendered from a custom remark plugin).

All code is authored through Claude Code. No manual editing.

## Non-negotiable rules (read `docs/constraints.md` for the full list and the "why" behind each)

- **Platform-native i18n.** Astro's `i18n` config with `prefixDefaultLocale: true` is the routing backbone. Every page lives under `/en/` or `/fr/`. No implicit default locale. Use `getRelativeLocaleUrl` from `astro:i18n` and `toLocalePath` from `src/lib/i18n.ts` — never reinvent.
- **Hreflang on every page.** `Base.astro` and `Article.astro` emit `<link rel="alternate">` pairs via `hreflangsForPath()`. Ship no page without it.
- **OG + Twitter Card tags on every page.** `Base.astro` and `Article.astro` both emit the full set (og:type, og:title, og:description, og:url, og:site_name, og:image, twitter:card, etc.). New layouts must wire this in. See `docs/constraints.md § SEO and AEO`.
- **JSON-LD on every page.** `Base.astro` emits Person + WebSite schema. `Article.astro` emits Article schema with datePublished. No layout should omit structured data.
- **robots.txt and llms.txt are in `public/`.** Never delete them. Update `llms.txt` key pieces list when a high-signal article ships.
- **Cross-references are mandatory.** Every article must link to at least two related pieces. Run `/cross-ref-check` before publishing. External company names (Enakl, The Fabulous) must link to their URLs on first body mention.
- **No build-time browser deps.** No playwright, no puppeteer. Mermaid renders client-side.
- **No CSS `transform: scale()` for vector zoom.** Scale via intrinsic `width`/`height`.
- **`date` frontmatter mandatory on case files.** Seed from first-merge git date.
- **Typed content registries** for reusable UI content. Canonical: `src/lib/lead-magnets.ts`. Do not build a generic wrapper.
- **FR = re-voiced, not translated.** Run `/french-audit` before committing any FR content. Keep English jargon per `docs/french-guide.md`.
- **Local-first enforcement.** No CI. The pre-commit hook (`astro check` + structural script + `astro build`) is the gate. `--no-verify` forbidden. See `docs/adr-003-enforcement-tier.md` and its upgrade trigger.
- **All API routes under `/api/v1/`.** Unversioned routes are forbidden. Use `src/lib/http.ts`'s `json()` helper.
- **Slug derives from title by default.** New article slugs (filenames) are the title kebab-cased — drop em-dashes, colons, commas, apostrophes; replace spaces with hyphens. Deviate only with a documented reason. **Never rename a published slug** — inbound URLs are stable. The forcing function is on the title side: if the title would make a bad slug, fix the title before publishing. Description frontmatter must match the piece's voice target — no engineer-coded jargon (`IDE`, `fresh-machine clone`) in builder-target pieces, no consumer-soft language in technical pieces. See `docs/design-charter.md` § Titles, descriptions, and slugs.

- **Never push with high or critical npm vulnerabilities.** The `pre-push` hook runs `npm audit --audit-level=high` and blocks the push on any high/critical finding. Fix first — `npm audit fix`, npm `overrides`, or a documented advisory-specific acceptance. Never `--no-verify`.

## Detail docs

| Topic | File |
|---|---|
| Workflow SOPs (article / code / structural / post-merge cleanup) | `docs/workflow.md` |
| Full constraints list + rationale | `docs/constraints.md` |
| Architecture + toolchain + typed-registry pattern | `docs/architecture-and-toolchain.md` |
| Home-page selection contract (featured/highlight/order) | `docs/adr-002-home-selection.md` |
| Local-first enforcement tier (no CI, pre-commit hook, upgrade trigger) | `docs/adr-003-enforcement-tier.md` |
| Design charter (voice, layout, lane alignment) | `docs/design-charter.md` |
| Target audiences (technical vs builder voice targets) | `docs/target-audiences.md` |
| French voice guide + do-not-translate list | `docs/french-guide.md` |

## Project-scoped skills

| Skill | When to invoke |
|---|---|
| `/article-capture` | When a conversation produces publishable insight |
| `/article-review` | Before publishing any article (EN + FR together) |
| `/french-audit` | After drafting or updating any FR content |
| `/verify-home` | After any change to home layout, redirects, or home-selection flags |
| `/check-constraints` | Before writing structural code (i18n, routing, caching, auth, deps) |

Cross-project skills (`/commit`, `/pr`, `/log-decision`, `/wrap-session`, `/session-pulse`, `/arch-review`) are available from any working dir.

## Dev workflow

```bash
npm install           # Installs deps + pre-commit hook via simple-git-hooks
npm run dev           # http://localhost:4321
npm run build         # Production build — must pass before commit
npm run verify        # Structural-integrity script (also runs in pre-commit)
```

Deploy is automatic on push to `main` (Vercel → GitHub integration). Never push to `main` directly — feature branch + PR. The pre-commit hook runs `astro check`, `npm run verify`, and `astro build` on every commit.
