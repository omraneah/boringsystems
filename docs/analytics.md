# Analytics Reference — boringsystems.app

**Tool:** Mixpanel (EU — Netherlands DC)  
**ADR:** `docs/adr-004-analytics-tooling.md`  
**Central library:** `src/lib/analytics.ts`  
**Init:** `src/components/Analytics.astro`

## Rule: always go through the library

All tracking calls go through `src/lib/analytics.ts`. Never call `mixpanel.track()` directly in components.

```ts
import { trackOutbound, trackLeadMagnet, trackScroll75, trackLanguageToggle, trackPortfolioVisit } from '@/lib/analytics';
```

---

## Auto-tracked

`$pageview` fires on every full page load (Mixpanel SDK, `track_pageview: 'url-with-path'`).

| Auto property | What it contains |
|---|---|
| `$current_url` | Full URL of the current page |
| `$referrer` | URL of the previous page — internal = article-to-article chain; external = source |
| `$referring_domain` | Domain of the referrer |
| `utm_source`, `utm_medium`, `utm_campaign`, `utm_content` | UTM params, auto-captured and persisted as super properties for the session |
| `$initial_referrer` | First external referrer for the user's lifetime (stored in Mixpanel cookie) |
| `$browser`, `$os`, `$device` | Client info, auto-collected |

---

## Super properties (attached to every event automatically)

Set during `initMixpanel()` via `mixpanel.register()`. Derived once per page load.

| Property | Values | How it's derived |
|---|---|---|
| `lane` | `writing`, `work`, `building`, `archive`, `about`, `work-with-me`, `home` | URL pathname (client-side, same logic as server-side derivation in layouts) |
| `language` | `en`, `fr` | `document.documentElement.lang` |

---

## Custom events (v1 — 5 max, firm ceiling)

Do not add events without updating this doc and consulting the operator. The ceiling is intentional — observe before instrumenting.

### `lead_magnet_captured`

Fired when a user successfully submits the lead magnet form.

| Property | Type | Example |
|---|---|---|
| `magnet_slug` | string | `"claude-delegation-prompts"` |
| `article_slug` | string | `"why-most-ai-adoption-fails"` |
| `language` | `en` \| `fr` | `"en"` |

Fires in: `LeadMagnet.astro`, on successful API response (`/api/v1/lead-magnet`).

---

### `outbound_link_clicked`

Fired on any click on an external link tagged with `data-track-outbound`.

| Property | Type | Example |
|---|---|---|
| `target_url` | string | `"https://www.linkedin.com/in/omrane-ahmed/"` |
| `article_slug` | string | `"why-most-ai-adoption-fails"` (from `document.body.dataset.articleSlug`; `""` on non-article pages) |

Fires in: delegated click handler in `Analytics.astro` — covers any element in the document.

**How to add tracking to any new outbound link:**
```html
<a href="https://example.com" data-track-outbound="https://example.com">Link text</a>
```
No code changes needed. The event delegation handles the rest.

---

### `article_scroll_75`

Fired once when the user has scrolled past 75% of an article page. Indicates genuine reading interest.

| Property | Type | Example |
|---|---|---|
| `article_slug` | string | `"why-most-ai-adoption-fails"` |
| `lane` | string | `"writing"` |
| `voice_target` | `technical` \| `builder` | `"builder"` |

Fires in: `Article.astro`, passive scroll listener. Fires once, then self-removes.

---

### `language_toggled`

Fired when the user switches language via the nav toggle.

| Property | Type | Example |
|---|---|---|
| `from` | `en` \| `fr` | `"en"` |
| `to` | `en` \| `fr` | `"fr"` |

Fires in: `Nav.astro`, on click of `.lang-toggle`.

---

### `contact_form_sent`

Fired when the contact form is successfully submitted.

Props: none.

Fires in: `ContactForm.astro`, on successful API response (`/api/v1/contact`).

---

## UTM template

For LinkedIn posts and other distribution:

```
https://boringsystems.app/en/writing/[article-slug]?utm_source=linkedin&utm_medium=social&utm_campaign=[post-slug]&utm_content=[article-slug]
```

| Parameter | Values | Usage |
|---|---|---|
| `utm_source` | `linkedin`, `twitter`, `newsletter`, `direct` | Where the link lives |
| `utm_medium` | `social`, `email`, `referral` | Channel type |
| `utm_campaign` | `vp-eng-hiring-post-2026-05` | The post or campaign slug |
| `utm_content` | article slug | Which article is linked (for multi-link campaigns) |

Mixpanel persists UTMs as session-level super properties (last-touch). `initial_utm_*` profile properties hold first-touch attribution.

---

## Checklist — adding tracking to new components

1. **New outbound link?** Add `data-track-outbound="[url]"` to the `<a>`. Done — no code needed.
2. **New CTA / conversion action?** Import from `src/lib/analytics.ts` and call in the event handler.
3. **New event type not in the 5-event taxonomy?** Don't add it during the v1 observation window (minimum 2 weeks post-launch). Update this doc and confirm with the operator first.
4. **New page or layout using `Base.astro`?** Pageviews auto-tracked. No extra work.
5. **New article layout?** Use `Article.astro` — scroll depth and pageviews are wired in.

Run `/analytics-audit` before committing any component that contains new outbound links or CTAs.
