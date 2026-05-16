---
name: article-comparative-review
description: Comparative review of a draft article against the N most similar shipped articles in the same lane. Uses the principal-engineer agent to grade the draft on quality parity and to surface contested claims, factual errors, or assertions a technical reader would push back on. Run after /article-review, before /commit.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob, Agent, WebSearch, WebFetch
argument-hint: "[article slug or full EN path — e.g. writing/domain-driven-design-the-fancy-name-for-principle-thinking]"
---

Comparative review of the draft at $ARGUMENTS against the most similar shipped articles in the same lane. Catches contested / false claims and quality-bar gaps before commit.

## When to invoke

Run after `/article-review` passes blockers, before `/commit`. Mandatory for any technical-voice article that makes behavioral, historical, or pattern-level claims that a senior engineer could contest.

## Inputs

Same formats as `/article-review`:
- Slug like `writing/domain-driven-design-the-fancy-name-for-principle-thinking` — resolve to `src/content/<collection>-en/<slug>.md`.
- Full EN path.

## Process

### 1. Resolve the draft

Read the EN file. Extract: lane (from collection folder), voice target (from opening paragraphs), key themes (3–5 named concepts the article is directly about).

### 2. Find comparison corpus

Scan `src/content/<same-collection>-en/` for all published `.md` / `.mdx` files. For each, read the first 20 lines (title + description + opening). Score relevance to the draft's key themes. Select the **3 most thematically similar** articles (excluding the draft itself).

If the collection has fewer than 3 published articles, use all of them. If zero, note that no comparison corpus exists and skip to Step 4 (claims-only pass).

### 3. Read comparison articles in full

Read each of the 3 comparison articles fully. They form the quality bar and the factual substrate the site has already committed to.

### 4. Invoke Daniel for comparative review

Spawn the `principal-engineer` agent with this brief:

> You are reviewing a draft article for a technical engineering leadership site. Your job is two-part:
>
> **Part A — Quality comparison.** Read the draft and the N comparison articles. Grade the draft on the same bar as the comparisons across: argument precision, real specificity (production incidents, named constraints), claim-to-evidence ratio, and prose economy. Render a grade (A–F) with a one-sentence rationale per dimension.
>
> **Part B — Contested claims audit.** For every behavioral, historical, pattern-level, or tool-specific claim in the draft, answer: is this claim accurate? Could a technically sophisticated reader credibly contest it? If yes, name the exact claim, the counter-argument, and the severity (factually wrong / overstated / contested-but-defensible). Do not flag stylistic choices — only claims that could make the site look uninformed or wrong to a senior technical audience.
>
> Produce the report in the following format:
>
> ## Grade vs. corpus
> | Dimension | Grade | Rationale |
> |---|---|---|
> | Argument precision | … | … |
> | Real specificity | … | … |
> | Claim-to-evidence ratio | … | … |
> | Prose economy | … | … |
> | Overall | … | … |
>
> ## Contested / false claims
> | Claim (quoted) | Counter-argument | Severity |
> |---|---|---|
> | … | … | Factually wrong / Overstated / Contested-but-defensible |
>
> ## Verdict
> Ship / Fix contested claims first / Rethink

Pass the agent: the full draft text, the full text of the 3 comparison articles, and the brief above.

### 5. Embed and surface

Embed Daniel's report verbatim. If any claim is rated **Factually wrong**, surface as a **blocker**. If rated **Overstated** or **Contested-but-defensible**, surface as a **warning**. Quality grade below B on any dimension = **warning**.

## Output format

```
# Comparative Review — <slug>

## Comparison corpus
- <slug-1> — <one-line theme>
- <slug-2> — <one-line theme>
- <slug-3> — <one-line theme>

## Daniel's report

<embedded agent output verbatim>

## Flags

### Blockers (factually wrong claims)
- L<n>: "<quoted claim>" — <counter-argument>

### Warnings (overstated / contested / quality gap)
- L<n>: "<quoted claim or dimension>" — <issue>

## Verdict
- Blockers: N
- Warnings: N
- Recommendation: <ship / fix contested claims first / rethink>
```

## Rules

- Do not auto-fix. Surface only; Ahmed decides.
- Every flag must cite a line number or a direct quote.
- If the comparison corpus is empty, run Part B (claims audit) only — Part A requires at least one comparison article.
- If the draft file is missing, stop with a one-line error.
