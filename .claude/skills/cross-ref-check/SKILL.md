---
name: cross-ref-check
description: Audit an article for missing cross-references to related boringsystems content. Checks bidirectional links, proposes anchor text and placement, verifies FR parity. Run before publishing any new article.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
argument-hint: "[article slug or full EN path — e.g. work/decoupling-identity-from-the-auth-provider]"
---

Audit the article at $ARGUMENTS for missing cross-references to related existing content. Check both directions: does this article link out to related pieces, and do related pieces already link back?

## Process

### 1. Resolve the article

Accept the same input formats as `article-review`:
- Slug like `writing/saas-auth-the-good-the-bad-and-the-ugly` or `work/decoupling-identity-from-the-auth-provider` → resolve to `src/content/<collection>-en/<slug>.md(x)`.
- Full EN path → derive FR by inserting `-fr` into the collection name.

Read both EN and FR files.

### 2. Build a topic map of existing content

Read every `.md` / `.mdx` file in:
- `src/content/work-en/`
- `src/content/writing-en/`
- `src/content/building/`

For each, extract: slug (filename without extension), title (from frontmatter), and 3–5 key topics (infer from title + opening paragraph).

Exclude the article being reviewed from this map.

### 3. Extract the reviewed article's themes

From the EN body, identify the 3–5 most prominent named concepts, patterns, or problem domains. Focus on what the article is *directly about* — not incidental mentions.

### 4. Find load-bearing matches

For each theme, check the topic map for significant overlap. A match is **load-bearing** if:
- The other article explains why the theme matters in a way that extends the reader's understanding, OR
- The other article provides a complementary case study or decision framework.

A passing mention of the same term is not load-bearing.

### 5. Check outbound cross-references

Grep the EN body for `](/en/` — these are existing internal links. Record the target slug for each.

Compare against load-bearing matches:
- **Already linked**: target appears in the body → note as ✓, no action.
- **Missing outbound link**: load-bearing match not linked → flag with proposed anchor text and placement.

Limit to the 3 most important missing outbound links.

### 6. Check reverse direction

For each load-bearing match, read that article's EN body and check whether it already links back to the current article (`](/en/<current-slug>/`).

Flag each **missing reverse link** with: source article slug, the sentence in that article that should carry the link, and proposed anchor text.

Limit to the 3 most important reverse links.

### 7. FR parity check

Read the FR file. For each cross-reference in the EN body (matching `](/en/`), check that the FR file has a corresponding `/fr/` equivalent link.

Flag any EN link missing from FR as a **warning**.

## Output format

```
# Cross-Reference Audit — <slug>

## Missing outbound links (this article → related)
- [ ] **<target-slug>** — anchor: "<anchor text>" — placement: <section name>
  > "<quoted sentence where the link should live>"

## Missing reverse links (related → this article)
- [ ] **<source-slug>** — anchor: "<anchor text>" — placement: <section name>
  > "<quoted sentence in source-slug that should carry the link>"

## FR parity gaps
- [ ] EN links to /en/<slug>/ but FR does not link to /fr/<slug>/

## Already linked (no action needed)
- ✓ /en/<slug>/

## Summary
- Outbound missing: N | Reverse missing: N | FR gaps: N
```

## Rules

- Cross-ref gaps are always **nits** — they improve the reading experience but never block publish.
- Do not rewrite article content. Propose; Ahmed applies.
- If no load-bearing related content exists, report "No load-bearing related articles found" and stop.
- Maximum 3 flags per direction. Quality over completeness.
- **External company links:** If the article names Enakl or The Fabulous in body text, flag any first mention that doesn't link to enakl.com or thefabulous.co respectively. This is a constraint from `docs/constraints.md`.
- **FR parity is mandatory, not optional.** Every internal link in EN must have a FR equivalent. Flag FR parity gaps as **blocking** (not nits) — they break AEO signals for the FR audience.

## When to invoke

- Before opening a PR for any new article (mandatory).
- After article-review (as step 11 in that skill's flow).
- When a new article is added to the work series — always check against other work articles.
- When running a full SEO audit pass on the site.
