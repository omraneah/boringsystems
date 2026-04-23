---
name: verify-home
description: Smoke-test the boringsystems home page (EN + FR). Runs `npx astro build`, then asserts the Highlights section contains the expected case files in order, that the Selected Articles section has the expected technical case files plus the pinned playbook, that legacy URLs 301-redirect, and that the lead-magnet form renders on the right articles. Use after any change that touches home-page layout, frontmatter flags (highlight/featured/order), redirects, or the selection logic in `src/pages/{en,fr}/index.astro`.
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(npx astro build), Bash(python3 *), Bash(cat *), Read, Grep
argument-hint: "[optional: 'en' or 'fr' to limit to one locale]"
---

Post-change smoke test for the boringsystems home page. Validates the surface-level promises of the home without a browser.

## Steps

1. Run `npx astro build` from the project root. If it fails, stop and report the error — no other checks make sense against a broken build.
2. Extract text from the generated HTML and assert:
   - **Root redirect.** `.vercel/output/config.json` contains a route that redirects `^/$` → `/en/` with status 301 (or 308).
   - **Only redirect.** `.vercel/output/config.json` contains exactly one 301: `^/$` → `/en/`. No legacy aliases, no cross-lane forwards. Folder = URL is authoritative.
   - **Highlights — EN** (`dist/client/en/index.html`): three `.highlight-title` elements, in order:
     1. `The Solo Founder's New Baseline: Command an Agent, Own the Build`
     2. `The Operator's AI Stack: April 2026`
     3. `Does Your Early-Stage Startup Actually Need a CTO?`
     Selection logic is driven by frontmatter `highlight: true` + `order` — if this list needs to change, update the articles, not the skill.
   - **Highlights — FR** (`dist/client/fr/index.html`): three titles mirroring the EN above in their French re-voiced form. Do not assert exact strings — just assert three `.highlight-title` elements present and none of them reference English-only brand phrases that were never re-voiced.
   - **No Selected Articles band.** The home page renders only Highlights as a content surface (per ADR-002 amendment). Assert no section labelled `Selected Articles` (EN) or `Articles sélectionnés` (FR) exists in `dist/client/{en,fr}/index.html`.
   - **Lead magnet presence.** The two lead-magnet-bearing articles (`/en/writing/solo-founder-new-baseline`, `/en/building/operator-ai-stack-april-2026`) contain a `<section class="lead-magnet">` block. FR mirrors too.
   - **Mermaid block present** on `/en/building/operator-ai-stack-april-2026` and its FR mirror — a `<pre class="mermaid">` tag with a `flowchart` keyword inside.
   - **Hreflang present on every page.** Check that `dist/client/en/index.html`, `dist/client/fr/index.html`, one Writing page, one Work page, and one Archive page all include three `<link rel="alternate" hreflang=…>` tags: `en-US`, `fr-FR`, and `x-default`. All lanes use identical slugs across locales — hreflang pairs should point at symmetric paths (`/en/writing` ↔ `/fr/writing`, `/en/work` ↔ `/fr/work`, `/en/archive` ↔ `/fr/archive`, etc.).
   - **Root `/` redirects to `/en/` with 301.** Inspect `.vercel/output/config.json` for a route `{"src":"^/$", "status":301, "headers":{"Location":"/en/"}}`.

3. Run each assertion with a short Python one-liner using stdlib `re`. Example pattern:
   ```bash
   python3 -c "import re, json; h=open('dist/client/en/index.html').read(); print(re.findall(r'highlight-title[^>]*>([^<]+)', h))"
   ```
4. Report as a pass/fail list — each assertion on its own line, with the actual value if the check failed. Do not narrate the passes individually; a single "✓ all N checks passed" is enough when everything is green.

## If $ARGUMENTS is provided

- `en` — skip FR checks.
- `fr` — skip EN checks.
- anything else — run both.

## What this does NOT check

- Visual rendering (no browser). Mermaid diagram correctness, card spacing, dark/light theming — all out of scope.
- Lead-magnet email delivery. The capture form renders; the send path is covered by Resend itself plus integration tests elsewhere.
- Article content quality. Use `/article-review` and `/french-audit` for that.
- Article meta strip rendering. Use a separate check if you suspect date/read-time drift.

## When assertions need to change

Edit this file. Do not silently adjust the test to match a drift in content — either the content intent changed (in which case the test should change with it, deliberately) or the content drifted accidentally (in which case the test caught it and the content should be fixed).
