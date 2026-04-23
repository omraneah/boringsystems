# Architecture & Toolchain

**Status:** Living document — update when tools or integrations change  
**Date:** 2026-04-14

---

## How This Project Is Built

No code is written by hand. All development happens through prompts to Claude Code CLI, which reads, writes, and refactors the codebase directly. Prompts are dictated via Wispr Flow — voice-to-text feeds directly into the terminal session.

This means the effective workflow is: speak a requirement → Claude Code executes it → review the diff → commit.

---

## Stack

| Layer | Tool | Notes |
|---|---|---|
| Framework | Astro 5 | Static by default, SSR opt-in per route |
| Rendering | Hybrid (static + serverless) | All pages prerendered; API routes run as Vercel Functions |
| Styling | Vanilla CSS with design tokens | CSS variables in `global.css`, no framework |
| Content | Astro Content Collections | Markdown files in `src/content/` |

---

## Development Workflow

| Tool | Role |
|---|---|
| Claude Code CLI | All code authoring — no manual editing |
| Wispr Flow | Voice dictation for prompts |
| GitHub | Version control, branch-per-feature, PR review before merge |

Every change goes through a branch and a pull request. Nothing is committed directly to main. Claude Code operates on the branch; the human reviews and merges.

---

## Hosting & Deployment

| Tool | Role |
|---|---|
| Vercel | Hosting, automatic deployments, serverless functions |
| GitHub → Vercel | Push to any branch creates a preview deployment; merge to main deploys to production |
| Vercel Analytics | Page views, unique visitors, referrers, countries — no cookies, GDPR-compliant |
| Vercel Speed Insights | Core Web Vitals per page |

The Vercel project is linked to this GitHub repository. Deployment is fully automatic — no manual deploy steps.

---

## Domain

Bought and managed on Vercel. DNS is handled there.

**Domain:** `boringsystems.app`

---

## Email

| Tool | Role |
|---|---|
| Resend | Transactional email for contact form, article feedback, and lead magnets |
| `contact@boringsystems.app` | Sending address (domain verified on Resend) |

Resend is the only outbound email dependency. It is fully encapsulated in `src/lib/mailer.ts`, which exposes a single internal `sendEmail()` helper plus four named exports (`sendContactEmail`, `sendFeedbackEmail`, `sendLeadMagnetNotification`, `sendLeadMagnetConfirmation`). Swapping providers requires changes to that file only. See `docs/adr-001-contact-form.md` for the original decision rationale.

### Lead magnets

Lead-magnet assets are declared in `src/lib/lead-magnets.ts` as a typed registry (`slug`, `title`, `description`, `buttonLabel`, `prompt`, `confirmation` — each indexed by `en` / `fr`). The reusable `<LeadMagnet />` component (`src/components/LeadMagnet.astro`) takes an `assetSlug` and drops the capture form anywhere on the site. The `POST /api/v1/lead-magnet` endpoint (`src/pages/api/v1/lead-magnet.ts`) notifies the operator and sends the subscriber the asset body from the registry. To add a new lead magnet, add one entry to the registry — nothing else needs to change.

---

## Environment Variables

Managed in Vercel project settings. For local development, copy to `.env.local` (gitignored).

| Variable | Purpose |
|---|---|
| `RESEND_API_KEY` | Resend authentication |
| `CONTACT_TO_EMAIL` | Destination inbox for contact, feedback, and lead-magnet notification emails |
| `CONTACT_FROM_EMAIL` | Sending address (`contact@boringsystems.app`); also used as the "from" for lead-magnet confirmations to subscribers |

---

## Repository Structure (Key Paths)

```
src/
├── components/        ← Reusable UI: ArticleCard, ArticleFeedback, LeadMagnet, Nav, Footer
├── content/           ← Markdown + MDX articles, one collection per lane × locale:
│                       system-design-{en,fr}/, builders-{en,fr}/,
│                       technology-{en,fr}/, archive-{en,fr}/.
│                       Lane folder = URL path. File basename = URL slug.
│                       Any subfolders in between are grouping-only and never
│                       appear in URLs (see docs/constraints.md "Content").
│                       Articles are .md by default; use .mdx when a piece needs
│                       embedded components (e.g. <LeadMagnet />) or mermaid diagrams.
│
│                       Archive is grouped on disk by series; URLs stay flat:
│                         archive-{en,fr}/operating-playbooks/
│                           series-1-foundations/s1-p0-how-we-run.md
│                           series-1-foundations/s1-p1-first-30-days.md
│                           ...
│                           series-2-leadership-and-judgment/s2-p1-*.md
│                           series-3-ai-edge/s3-p1-*.md
│                         → /{lang}/archive/<basename>
│                       Basename uniqueness per collection is enforced by
│                       scripts/verify-structure.ts so grouping never causes
│                       URL collisions.
├── layouts/           ← Page layouts (Base.astro, Article.astro).
│                       Article.astro loads mermaid.js client-side when any
│                       <pre class="mermaid"> blocks are present on the page.
├── lib/               ← Backend + typed registries (mailer.ts, article-meta.ts,
│                       lead-magnets.ts)
├── pages/             ← Routes, strict two-language tree:
│                       en/{system-design,builders,technology,archive}/* and
│                       fr/{system-design,builders,technology,archive}/* mirror each
│                       other; api/* is language-neutral.
│                       No content lives at the root — astro.config.mjs 301-redirects
│                       `/` to `/en/`. No other redirects: folder = URL.
└── styles/            ← Global CSS and design tokens

Mermaid diagrams: write a ```mermaid code fence inside a .md or .mdx article.
A small remark plugin in astro.config.mjs rewrites the fence into a
<pre class="mermaid"> HTML block at build time; mermaid.js renders it
client-side. No build-time browser dependency is needed.

docs/                  ← Architecture decisions and toolchain documentation
```

---

## Reusable UI Content — the typed-registry pattern

When UI content needs to live in more than one place and carry locale variants, use the "typed content registry" pattern rather than inlining or creating an ad-hoc abstraction.

**Canonical example:** `src/lib/lead-magnets.ts`.

**The shape:**

```ts
export type Lang = 'en' | 'fr';

export interface AssetShape {
  slug: string;
  title: Record<Lang, string>;
  description: Record<Lang, string>;
  // ... other per-locale fields specific to the asset type
}

export const ASSETS: Record<string, AssetShape> = {
  'some-slug': { /* ... */ },
};

export function getAsset(slug: string): AssetShape {
  const a = ASSETS[slug];
  if (!a) throw new Error(`Unknown asset: ${slug}`);
  return a;
}
```

**Rules:**

- Single file, explicit types, no reflection or metaframework.
- One record keyed by slug; every asset has a matching locale record for every `Lang` member. TypeScript catches missing locales at build time.
- Consumer components (`<LeadMagnet />`) and API routes (`/api/v1/lead-magnet`) both resolve through the registry. Adding a new asset is one registry entry — **no component, route, or mail changes**.
- Renaming an asset is a slug rename; search is reliable.

**When to use this instead of a content collection:** Content collections are for Markdown-bodied documents (articles, playbooks). The registry pattern is for structured UI content — email bodies, form copy, CTA text, testimonials, stack-item cards — where the "body" is short, structured, and consumed by components.

**Candidates as they come up:** testimonials, stack item cards, inline CTAs, pricing tiers, FAQ entries, contact-form presets. Each follows the same shape. Do not introduce a generic `<ContentRegistry />` wrapper — the value is in the explicit types, not in a shared abstraction.

---
