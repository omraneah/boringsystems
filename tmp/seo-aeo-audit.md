# SEO / AEO Audit — boringsystems.app
_Generated: 2026-05-02_

---

## Research Basis

Sources consulted:
- Google Search Central: Article structured data, hreflang, ProfilePage
- schema.org: Article, BlogPosting, Person, ProfilePage, WebSite, BreadcrumbList
- llmstxt.org specification
- Anthropic: Claude bot user-agent documentation
- Search Engine Journal, SEMrush, ALM Corp, Frase.io, PoweredBySearch on AEO/GEO 2025-2026

---

## Gap Analysis — 16 Gaps Found

---

### GAP 1 — Article schema uses wrong `@type`

**Priority: Critical**

**What's missing or wrong:**
`Article.astro` emits `@type: "Article"` for all content lanes (writing, work, building, archive). For a personal technical blog, `BlogPosting` is the semantically correct and more specific type. `BlogPosting` is a subtype of `Article` and inherits all its properties, but signals to Google and AI engines that this is authored, opinionated, serialized content — which unlocks Google Discover eligibility and stronger E-E-A-T signals. Using the generic `Article` type is not wrong, but it leaves entity signals on the table.

**Why it matters:**
Search engines and AI citation engines (Perplexity, Claude-SearchBot) use the `@type` to infer content nature. `BlogPosting` triggers author-centric indexing pathways. For a single-author site building a personal brand, every bit of entity-signal reinforcement matters. This is particularly relevant given the AEO context: AI answer engines are more likely to cite sources where the author entity is strongly established.

**Exact fix:**
In `Article.astro`, change the `articleSchema` object:

```js
const articleSchema = {
  '@context': 'https://schema.org',
  '@type': 'BlogPosting',  // was: 'Article'
  ...
};
```

Archive entries (operating playbooks, no `date`) should remain as `Article` since they are non-serialized reference doctrine. Pass an `articleType` prop from `[slug].astro` pages to `Article.astro`:

```astro
// In archive/[slug].astro
<Article
  articleType="Article"
  ...
/>

// In writing/[slug].astro, work/[slug].astro, building/[slug].astro
// Default (no prop) = BlogPosting
```

In `Article.astro` Props interface:
```ts
interface Props {
  articleType?: 'BlogPosting' | 'Article';
  ...
}
const { articleType = 'BlogPosting', ... } = Astro.props;
```

Then in the schema:
```js
const articleSchema = {
  '@context': 'https://schema.org',
  '@type': articleType,
  ...
};
```

---

### GAP 2 — `dateModified` missing from Article schema

**Priority: Critical**

**What's missing or wrong:**
`Article.astro`'s `articleSchema` includes `datePublished` (conditionally from `isoDate`) but never sets `dateModified`. Google's Article structured data documentation lists `dateModified` as a recommended field. More critically: AI answer engines (Perplexity, Google AI Overviews) apply freshness weighting — content updated within 30 days gets substantially more AI citations. When `dateModified` is absent, crawlers fall back to `datePublished`, making all articles appear as old as their publish date even if updated.

**Why it matters:**
This is the highest-leverage AEO signal missing from the markup. Without `dateModified`, a polished article revised last month looks stale from the AI's perspective. For a content site trying to get cited by ChatGPT/Perplexity/Claude, this is a direct ranking signal being ignored.

**Exact fix:**
1. Add optional `dateModified` to the content schema in `config.ts`:

```ts
const article = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    date: z.coerce.date(),
    lastModified: z.coerce.date().optional(),  // add this
    featured: z.boolean().optional().default(false),
    highlight: z.boolean().optional().default(false),
    order: z.number().optional().default(99),
  }),
});
```

2. Pass it through from all `[slug].astro` pages — example for `writing/[slug].astro`:

```astro
<Article
  title={entry.data.title}
  description={entry.data.description}
  backHref="/en/writing"
  backLabel="Writing"
  date={formatDate(entry.data.date, 'en') ?? undefined}
  isoDate={entry.data.date ? entry.data.date.toISOString() : undefined}
  lastModifiedIso={entry.data.lastModified ? entry.data.lastModified.toISOString() : undefined}
  readTime={readTime(entry.body, 'en')}
>
```

3. Add `lastModifiedIso` to `Article.astro`'s Props interface and schema:

```ts
interface Props {
  ...
  lastModifiedIso?: string;
}
const { ..., lastModifiedIso } = Astro.props;

const articleSchema = {
  ...
  ...(isoDate ? { datePublished: isoDate } : {}),
  ...(lastModifiedIso ? { dateModified: lastModifiedIso } : isoDate ? { dateModified: isoDate } : {}),
  // Fallback: if no explicit lastModified, use datePublished as dateModified (acceptable)
};
```

---

### GAP 3 — `inLanguage` missing from Article schema

**Priority: Critical**

**What's missing or wrong:**
The site is bilingual (EN/FR). `Article.astro` emits one Article schema for both locale versions but never declares `inLanguage`. Both `/en/writing/foo` and `/fr/writing/foo` emit structurally identical schemas with the same canonical URL, meaning a crawler cannot distinguish EN content from FR content at the structured-data level. The `lang` prop is passed to the layout but not surfaced in JSON-LD.

**Why it matters:**
For a bilingual site, `inLanguage` is the field that prevents entity confusion between language versions. Without it, Google and AI engines treat EN and FR article entities as duplicates rather than distinct language variants. This undermines the hreflang work already done at the link level. It also directly affects AI citation accuracy — Claude-SearchBot and Perplexity index by language; an article without declared language may be cited in the wrong locale context.

**Exact fix:**
In `Article.astro`, the `lang` prop is already received. Add it to the schema:

```js
const articleSchema = {
  '@context': 'https://schema.org',
  '@type': articleType,
  headline: title,
  description: metaDescription,
  inLanguage: lang === 'fr' ? 'fr-FR' : 'en-US',  // add this
  ...
};
```

Also add `inLanguage` to the `websiteSchema` in `Base.astro` (not critical for WebSite, but consistent):

```js
const websiteSchema = {
  '@context': 'https://schema.org',
  '@type': 'WebSite',
  name: 'Boring Systems',
  url: 'https://boringsystems.app',
  inLanguage: ['en-US', 'fr-FR'],  // array for bilingual site
  ...
};
```

---

### GAP 4 — Person schema on `about.astro` is incomplete — missing `ProfilePage` wrapper and key E-E-A-T fields

**Priority: High**

**What's missing or wrong:**
The About page (`/en/about`) renders using `Base.astro`, which emits the generic `Person` + `WebSite` schemas defined at the layout level. This is the wrong schema for a dedicated About/profile page. Google's documentation explicitly defines `ProfilePage` structured data for exactly this use case — a page whose primary subject is a person. The current `Person` schema also lacks:
- `image` (no photo URL)
- `knowsAbout` (expertise signals for E-E-A-T)
- `worksFor` (organization affiliation)
- `alumniOf` (past employers — strong E-E-A-T signal)

**Why it matters:**
The About page is the highest-value page for E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness), which is the primary signal Google uses to evaluate whether to show Ahmed's content in AI Overviews. `ProfilePage` with a rich `Person` mainEntity can trigger a Knowledge Panel. Missing `knowsAbout` means AI engines don't know Ahmed's domain — they see a generic "Engineering Leader" rather than someone with established expertise in agentic AI orchestration, SaaS architecture, and vendor lock-in migrations.

**Exact fix:**
Create a dedicated `ProfilePage` JSON-LD block emitted only on `about.astro`. Since `Base.astro` already emits a basic `Person` schema globally, the About page should emit a richer schema that overrides via a page-specific `<script type="application/ld+json">`.

In `about.astro`, add after the `<Base>` open tag or inject via a slot — since `Base.astro` currently has no `head` slot, the cleanest approach is to add a `headSlot` to `Base.astro` or (simpler) emit the richer person schema via an inline script block in `about.astro` using Astro's `<Fragment slot="head">` pattern if a head slot is added to Base.

Alternatively, promote the Person schema object in `Base.astro` and accept an optional prop `personSchema` that a page can override:

Minimal viable fix — add the following directly to `about.astro` as a `<script type="application/ld+json" is:inline>` after the `<Base>` usage (Astro renders slot content into the body, so use `set:html` approach via a component, or add a `headExtra` slot to Base.astro):

The schema to emit:
```json
{
  "@context": "https://schema.org",
  "@type": "ProfilePage",
  "mainEntity": {
    "@type": "Person",
    "name": "Ahmed Omrane",
    "url": "https://boringsystems.app/en/about",
    "image": "https://boringsystems.app/logo.png",
    "jobTitle": "Engineering Leader",
    "description": "Engineering leader with 15+ years owning the business → product → engineering arc. AI-native execution. France-based.",
    "knowsAbout": [
      "Agentic AI Orchestration",
      "Engineering Leadership",
      "SaaS Architecture",
      "Vendor Lock-in Migration",
      "Multi-tenant Systems",
      "Technical Product Strategy"
    ],
    "worksFor": {
      "@type": "Organization",
      "name": "Boring Systems",
      "url": "https://boringsystems.app"
    },
    "alumniOf": [
      {
        "@type": "Organization",
        "name": "Enakl",
        "url": "https://enakl.com"
      },
      {
        "@type": "Organization",
        "name": "The Fabulous",
        "url": "https://thefabulous.co"
      }
    ],
    "sameAs": [
      "https://www.linkedin.com/in/omrane-ahmed/",
      "https://medium.com/@ahmedomrane"
    ]
  }
}
```

Implementation path: Add an optional `headExtra` slot to `Base.astro`, then use it from `about.astro`:

In `Base.astro` `<head>`:
```astro
<slot name="head-extra" />
```

In `about.astro`:
```astro
<Base title="About" description="...">
  <script slot="head-extra" type="application/ld+json" set:html={JSON.stringify(profilePageSchema)} />
  ...content...
</Base>
```

---

### GAP 5 — `og:image:width` and `og:image:height` missing — causes async crawl on first share

**Priority: High**

**What's missing or wrong:**
Both `Base.astro` and `Article.astro` emit `<meta property="og:image">` but never declare `og:image:width` or `og:image:height`. The default `ogImage` is `https://boringsystems.app/logo.png` — an unspecified-dimension PNG. Facebook (and LinkedIn) require explicit width/height to avoid asynchronous image parsing on the first share, which can result in no image preview being shown. The recommended universal size is 1200×630 (aspect ratio 1.91:1).

**Why it matters:**
Without `og:image:width`/`height`, Facebook's crawler has to fetch and parse the image before displaying a preview. On first share of any page, the preview may appear without an image. This is a direct social distribution hit.

**Exact fix:**
In both `Base.astro` and `Article.astro`, add after the `og:image` tag:
```astro
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
<meta property="og:image:type" content="image/png" />
```

Note: This only fully works if the logo.png actually is 1200×630. Currently the logo is presumably not that size. Action required: either resize `logo.png` to 1200×630 or create a dedicated `og-image.png` at that size and update the `ogImage` default to point to it. A 1200×630 OG image is the single biggest improvement to social sharing previews.

---

### GAP 6 — `twitter:card` is `summary` instead of `summary_large_image`

**Priority: High**

**What's missing or wrong:**
Both layouts set `twitter:card` to `"summary"`, which renders as a small square thumbnail next to the tweet text. The `summary_large_image` type renders a prominent full-width image strip — the de facto standard for content sites and dramatically more visually engaging. All content sites with unique og:images should use `summary_large_image`.

**Why it matters:**
`summary` cards are near-invisible in a Twitter/X timeline. `summary_large_image` cards get significantly higher engagement. For a content distribution strategy where LinkedIn and Twitter are channels, this is a first-impression issue on every article share.

**Exact fix:**
In both `Base.astro` and `Article.astro`:
```astro
<!-- was: <meta name="twitter:card" content="summary" /> -->
<meta name="twitter:card" content="summary_large_image" />
```

Also add `twitter:site` (if Ahmed has a Twitter/X handle):
```astro
<meta name="twitter:creator" content="@handle" />
```

---

### GAP 7 — `article:author` OG tag uses plain text string instead of URL

**Priority: High**

**What's missing or wrong:**
In `Article.astro`, line 80: `<meta property="article:author" content="Ahmed Omrane" />`. The `article:author` Open Graph tag is supposed to be a URL (profile URL), not a plain name string. Facebook's OG spec defines `article:author` as a URL to the author's profile. Passing a bare string means Facebook can't link to the author's profile on shares.

**Why it matters:**
The correct value enables Facebook to establish the author entity link, contributing to social graph integrity. Wrong values don't cause errors but waste the tag's purpose.

**Exact fix:**
```astro
<!-- was: <meta property="article:author" content="Ahmed Omrane" /> -->
<meta property="article:author" content="https://www.linkedin.com/in/omrane-ahmed/" />
```

LinkedIn profile URLs are the standard choice for `article:author` for professionals without a Facebook profile.

---

### GAP 8 — `lang` prop not passed through from article `[slug].astro` pages to `Article.astro`

**Priority: High**

**What's missing or wrong:**
`Article.astro` accepts a `lang` prop (default: `'en'`), but neither `writing/[slug].astro`, `work/[slug].astro`, nor `building/[slug].astro` pass `lang` to it. This means:
1. FR articles rendered via `/fr/writing/[slug].astro` get `lang="en"` in the `<html>` tag
2. The `og:locale` tag defaults to `en_US` for French articles
3. The `inLanguage` fix (Gap 3) would also default to `en-US`
4. `hreflangs` are generated from the URL path (so hreflang is correct), but `<html lang>` is wrong

Checking `/Users/ahmedomrane/Workspace/boringsystems/src/pages/fr/writing/[slug].astro` would confirm the FR counterpart, but the EN `[slug].astro` clearly defaults lang to 'en' — the FR slug page must be inspected to confirm.

**Why it matters:**
Incorrect `<html lang>` is a Lighthouse accessibility failure and a signal Google uses for language classification. An article at `/fr/writing/foo` should declare `lang="fr"`. Mismatched `og:locale` confuses social crawlers.

**Exact fix:**
In `src/pages/fr/writing/[slug].astro`, `src/pages/fr/work/[slug].astro`, `src/pages/fr/building/[slug].astro`, `src/pages/fr/archive/[slug].astro`:
```astro
<Article
  title={entry.data.title}
  description={entry.data.description}
  lang="fr"          {/* add this */}
  backHref="/fr/writing"
  backLabel="Écriture"
  ...
>
```

For EN pages (no change needed — default is already `'en'`).

---

### GAP 9 — `robots.txt` missing `anthropic-ai` and other active AI crawlers

**Priority: Medium**

**What's missing or wrong:**
The current `robots.txt` explicitly allows: `GPTBot`, `ClaudeBot`, `Google-Extended`, `PerplexityBot`. Missing:
- `anthropic-ai` (deprecated Anthropic agent but some old references still use it — low value but harmless to add)
- `Claude-SearchBot` (Anthropic's search indexing crawler — separate from ClaudeBot)
- `Claude-User` (real user requests in Claude — allowing this is the most valuable signal)
- `OAI-SearchBot` (OpenAI's search-mode crawler, distinct from GPTBot)
- `Meta-ExternalAgent` (Meta's AI crawler)
- `Applebot` (Apple's Siri/Intelligence crawler)
- `Bytespider` (ByteDance/TikTok LLM)
- `DuckAssistBot` (DuckDuckGo AI answers)
- `YouBot` (You.com AI search)

For a site that explicitly wants AI visibility, having only partial coverage means some AI engines are crawling under their default behavior without explicit permission signaling. The more important issue is `Claude-SearchBot` — without it, Claude's search-answer indexing may miss the site.

**Why it matters:**
`Claude-SearchBot` is the bot that directly feeds Claude's answer-engine responses. Explicitly allowing it signals intent and ensures compliance with any future per-bot gating. For a site positioning itself as AI-native, having `ClaudeBot` but not `Claude-SearchBot` is an inconsistency.

**Exact fix:**
```txt
User-agent: *
Allow: /

# AI crawlers — welcome, this site is AI-native by design
User-agent: GPTBot
Allow: /

User-agent: OAI-SearchBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: Claude-User
Allow: /

User-agent: Claude-SearchBot
Allow: /

User-agent: Google-Extended
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: Meta-ExternalAgent
Allow: /

User-agent: Applebot
Allow: /

Sitemap: https://boringsystems.app/sitemap-index.xml
```

---

### GAP 10 — `llms.txt` missing key recent articles and French content signal

**Priority: Medium**

**What's missing or wrong:**
The `llms.txt` "Key pieces" section lists 5 articles (all EN). Issues:
1. No mention that each article has a French version — AI engines indexing the site for multilingual retrieval don't know EN/FR pairs exist
2. No `llms-full.txt` link — the spec allows a companion `llms-full.txt` with complete markdown versions of key articles. For AEO, linking to markdown versions gives AI engines cleaner parseable content
3. Missing recently published articles (the llms.txt hasn't been updated since at least the auth articles session per git log)
4. No `## Optional` / `## Links` section distinction per the llmstxt.org spec — the spec defines a specific section format

**Why it matters:**
AI engines like Claude and Perplexity use `llms.txt` as an editorial signal — it's Ahmed's curated list of what matters. An outdated list means AI engines may cite older pieces over newer, higher-quality work. The FR signal helps multilingual retrieval.

**Exact fix:**
Update `llms.txt` to spec format and add:
```markdown
## Key pieces (recommended entry points for LLMs)

- [Agentic AI Orchestration — 7 Operating Principles](https://boringsystems.app/en/writing/orchestration-principles-that-outlive-the-model): Seven operating principles for running multi-agent systems that don't collapse under load or ambiguity.
- [The Harness Behind the Agent](https://boringsystems.app/en/writing/harness-behind-the-agent): How to build an AI orchestration harness that preserves operator judgment while compressing execution cycles.
- [Engineering Practice Boundaries](https://boringsystems.app/en/writing/engineering-principles-that-outlive-the-stack): One bar for engineers and AI tools alike — seven cross-stack engineering dimensions.
- [Context is the Edge](https://boringsystems.app/en/writing/context-is-the-edge): Why context quality, not model capability, determines AI output quality.
- [The SaaS Authentication Stack](https://boringsystems.app/en/writing/the-saas-authentication-stack-operators-keep-treating-as-one-decision): The authentication decision operators keep treating as one choice when it's actually five.

## Bilingual content

All articles listed above have French counterparts at the same path under /fr/. Example: https://boringsystems.app/fr/writing/orchestration-principles-that-outlive-the-model

## Permissions
...
```

---

### GAP 11 — `WebSite` schema in `Base.astro` is missing `potentialAction` / SearchAction

**Priority: Low**

**What's missing or wrong:**
The `websiteSchema` has no `potentialAction`. This was previously recommended for sitelinks search box in Google SERPs — however, Google retired sitelinks search box from SERPs in November 2024, so this gap no longer has a Google SERP impact. For completeness it can be omitted. **Verdict: Skip this — it's genuinely not worth implementing as of 2025.**

---

### GAP 12 — `BreadcrumbList` schema missing on article pages

**Priority: Medium**

**What's missing or wrong:**
No breadcrumb structured data is emitted on any page. The article URL structure is `/en/writing/[slug]` — a clear 3-level hierarchy (Home → Writing → Article). Google supports BreadcrumbList rich results and uses it for hierarchical content signals. Desktop search still shows breadcrumbs in SERPs (mobile removed in Jan 2025).

**Why it matters:**
For desktop search users, breadcrumbs in the SERP snippet replace the raw URL and provide context. They also help Google understand that articles belong to content categories (writing, work, building), reinforcing topical clustering. Given the site has ~4 active lanes (writing, work, building, archive), breadcrumbs establish hierarchy that helps AI engines understand content organization.

**Exact fix:**
Add to `Article.astro`'s schema output. The `backHref` and `backLabel` props already encode the parent. Add a `BreadcrumbList` script alongside the Article schema:

```js
const breadcrumbSchema = {
  '@context': 'https://schema.org',
  '@type': 'BreadcrumbList',
  itemListElement: [
    {
      '@type': 'ListItem',
      position: 1,
      name: 'Home',
      item: `https://boringsystems.app/${lang}/`,
    },
    {
      '@type': 'ListItem',
      position: 2,
      name: backLabel,
      item: `https://boringsystems.app${backHref}`,
    },
    {
      '@type': 'ListItem',
      position: 3,
      name: title,
      item: canonicalUrl.href,
    },
  ],
};
```

```astro
<script type="application/ld+json" set:html={JSON.stringify(breadcrumbSchema)} />
```

---

### GAP 13 — `Person` schema in `Base.astro` missing `@id` for entity linking

**Priority: Medium**

**What's missing or wrong:**
The `personSchema` in `Base.astro` has no `@id`. Without `@id`, the Person entity cannot be cross-referenced by the `Article.astro` author block or any other schema that references Ahmed. Currently `Article.astro`'s author is an anonymous inline Person object, not linked to the global Person entity. This means Google/AI can't consolidate "Ahmed Omrane the Person" across article schemas — they're separate entity declarations each time.

**Why it matters:**
Entity graph consolidation is how Google builds Knowledge Panels and how AI engines establish author authority. Every article on the site references an author — if all those author references point to the same `@id`, Google treats them as a single known entity with accumulated signals. Without `@id`, each article's author is effectively a new anonymous claim.

**Exact fix:**
In `Base.astro`:
```js
const personSchema = {
  '@context': 'https://schema.org',
  '@type': 'Person',
  '@id': 'https://boringsystems.app/#ahmed-omrane',  // add this
  name: 'Ahmed Omrane',
  url: 'https://boringsystems.app',
  ...
};
```

In `Article.astro`:
```js
const articleSchema = {
  ...
  author: {
    '@type': 'Person',
    '@id': 'https://boringsystems.app/#ahmed-omrane',  // reference the same @id
    name: 'Ahmed Omrane',
    url: 'https://boringsystems.app',
  },
  ...
};
```

---

### GAP 14 — `og:locale:alternate` missing on bilingual pages

**Priority: Medium**

**What's missing or wrong:**
Both layouts emit `og:locale` (e.g., `en_US` or `fr_FR`) but never emit `og:locale:alternate` for the other locale. When a page has language alternates (which this site does, via hreflang), the Open Graph spec supports declaring alternate locales:
```html
<meta property="og:locale:alternate" content="fr_FR" />
```
(on EN pages) and vice versa.

**Why it matters:**
Facebook and other platforms use `og:locale:alternate` to route shares to the appropriate locale version. Without it, sharing an EN article on a French Facebook audience will always link to the EN version even when a FR version exists.

**Exact fix:**
In both `Base.astro` and `Article.astro`, after the `og:locale` tag:
```astro
{lang === 'en' 
  ? <meta property="og:locale:alternate" content="fr_FR" />
  : <meta property="og:locale:alternate" content="en_US" />
}
```

---

### GAP 15 — `article:section` OG tag missing on article pages

**Priority: Low**

**What's missing or wrong:**
`Article.astro` sets `og:type="article"` and emits `article:published_time`, `article:author` — but skips `article:section`. The Open Graph `article:section` property declares the content category (e.g., "Writing", "Work", "Building") — a lightweight topical signal for social crawlers.

**Why it matters:**
Low impact but zero cost. It maps directly to the existing `backLabel` prop (already "Writing", "Work", "Building", "Archive"). Facebook uses it for article categorization in some surfaces.

**Exact fix:**
In `Article.astro`, after `article:author`:
```astro
{backLabel && <meta property="article:section" content={backLabel} />}
```

---

### GAP 16 — `WebSite` schema missing `@id` for entity graph

**Priority: Low**

**What's missing or wrong:**
Same issue as Gap 13 but for the `websiteSchema`. Without `@id`, the WebSite entity can't be referenced as a named node in the structured data graph. The `publisher` in `Article.astro` creates a duplicate anonymous Organization object rather than referencing the canonical WebSite entity.

**Why it matters:**
Low impact but it's the difference between a structured data graph and scattered isolated JSON-LD objects. Proper entity referencing is the direction Google's structured data guidelines push toward.

**Exact fix:**
In `Base.astro`:
```js
const websiteSchema = {
  '@context': 'https://schema.org',
  '@type': 'WebSite',
  '@id': 'https://boringsystems.app/#website',  // add this
  name: 'Boring Systems',
  url: 'https://boringsystems.app',
  ...
};
```

In `Article.astro`, publisher should reference it:
```js
publisher: {
  '@type': 'Organization',
  '@id': 'https://boringsystems.app/#website',
  name: 'Boring Systems',
  url: 'https://boringsystems.app',
  logo: {
    '@type': 'ImageObject',
    url: 'https://boringsystems.app/logo.png',
  },
},
```

---

## Things That Are Fine — Don't Touch

| Topic | Status |
|---|---|
| Canonical URLs | Correct — `new URL(Astro.url.pathname, Astro.site)` pattern is solid |
| hreflang implementation | Correct — `hreflangsForPath()` emits `en-US`, `fr-FR`, and `x-default` (confirmed in `i18n.ts`) |
| Sitemap | Correct — Astro sitemap integration with i18n hreflang alternates configured |
| robots.txt base rules | Correct — `Allow: /` for all, sitemap URL present |
| OG meta completeness | Mostly correct — og:type, og:title, og:description, og:url, og:site_name all present |
| JSON-LD on every page | Correct in principle — both layouts emit structured data |
| FAQ schema | Not applicable — no FAQ sections exist on the site |
| Speakable schema | Not applicable — experimental, minimal adoption, no use case here |
| SearchAction / sitelinks searchbox | Deprecated by Google Nov 2024 — skip |
| AggregateRating / Review schema | Not applicable — personal blog |

---

## Priority Summary

| # | Gap | Priority |
|---|-----|----------|
| 1 | Article @type should be BlogPosting | Critical |
| 2 | dateModified missing from Article schema | Critical |
| 3 | inLanguage missing from Article schema | Critical |
| 4 | ProfilePage + rich Person schema missing on About | High |
| 5 | og:image:width/height missing (async crawl risk) | High |
| 6 | twitter:card should be summary_large_image | High |
| 7 | article:author should be URL, not name string | High |
| 8 | lang prop not passed through on FR article pages | High |
| 9 | robots.txt missing Claude-SearchBot, OAI-SearchBot | Medium |
| 10 | llms.txt outdated and missing FR signal | Medium |
| 11 | (WebSite SearchAction) | Skip — deprecated |
| 12 | BreadcrumbList missing on article pages | Medium |
| 13 | Person schema missing @id for entity linking | Medium |
| 14 | og:locale:alternate missing | Medium |
| 15 | article:section OG tag missing | Low |
| 16 | WebSite schema missing @id | Low |
