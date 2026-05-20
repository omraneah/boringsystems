# Article discipline — boringsystems

The editorial bar for every article, playbook, and page-copy update on this site. Read this before drafting, reviewing, or shipping content. The rules are mechanical — they exist to spend human attention on judgment, not on catching predictable defects.

Workflow context (drafting steps, branch flow, post-merge cleanup) lives in `docs/workflow.md`. This file is the discipline layer; `workflow.md` is the process layer.

---

## Bilingual by default

Every article, playbook, or page-copy update ships in EN and FR together, in the same PR. EN-only or FR-deferred is not on the table.

- Produce EN at `src/content/<lane>-en/` and FR at `src/content/<lane>-fr/` (or the equivalent surface path).
- FR is re-voiced, not translated — follow `docs/french-guide.md`.
- Surface genuine translation judgment calls (rare technical term, idiom, register decision) in the PR description for Ahmed.
- Only exception: explicit unprompted instruction from Ahmed to ship EN-only for a specific piece.

## Review skills are mandatory, not optional

Before any article is declared done, ready for review, or pushed to a PR branch:

- `/article-review` on EN.
- `/article-review` on FR.
- `/french-audit` on FR.

Never ask whether to run them — they are non-negotiable passes. Fix all mechanical flags (banned register, over-translation, voice slips, structural defects, lane misplacement, over-length paragraphs, passive-voice clusters) before committing. Surface judgment calls in the PR description or the relevant Linear card.

Applies to every surface that goes through the content pipeline: articles, playbooks, page copy, lead-magnet email text.

## Cross-references are mandatory and bidirectional

Every article links to at least two related pieces. New articles also force updates to existing related articles — both directions, same PR.

- Before committing any new article, run `/cross-ref-check`.
- Bidirectional links between a writing article and its corresponding work case file are non-negotiable.
- Apply cross-refs to both EN and FR versions; FR parity on every internal link.
- Do not defer cross-refs to a follow-up PR.

The site is a coherent body of work, not a collection of standalone pieces. Connective tissue is part of the product.

## Title proposals for work case files

Work case file titles require 3–5 options proposed to Ahmed before the title is applied. Functional or descriptive defaults are not acceptable.

- After drafting the article content, output a "Title options:" block with 3–5 alternatives before creating the file.
- Option A may be the functional/descriptive title; the others must match the work series register (short, action-oriented or noun-phrase, no jargon overload — e.g. "SaaS Hardening", "Breaking Vendor Lock-In", "Architecture Governance").
- Wait for Ahmed to pick before committing.
- Same applies to writing articles if a title change is proposed mid-draft.

## No specific pricing figures in articles

Articles never include specific pricing numbers — no `$/month`, no `$/connection`, no annual totals, no plan tiers with dollar amounts.

- Describe pricing structure or model (per-connection, MAU-based, free core + enterprise tier, OSS) but never specific dollar amounts.
- When calibration context is genuinely useful, use order-of-magnitude brackets ("hundreds per month", "four figures annually for large teams") — never exact numbers.
- Applies to `writing-en`, `writing-fr`, `work-en`, `work-fr`, and any other content surface.
- When revising existing articles, strip specific pricing figures during the pass.

Pricing changes on short timescales. Articles must stay credible over years. A specific number wrong in six months undermines the whole piece.

## Proactive article capture

When a conversation produces publishable insight, surface the capture suggestion — do not wait to be asked:

> "Do you want me to prepare a card for a boringsystems article from this?"

Watch for conversations that have:

1. Gone deep on a technical topic with trade-off reasoning.
2. Connected infrastructure or tooling to business model positioning.
3. Surfaced a nuanced take a senior operator would find non-obvious.

When the pattern fires, suggest `/article-capture`. The Linear card preserves the intellectual thread so the next session can draft without reconstruction.

---

## Quick checklist before declaring done

- [ ] EN and FR both drafted, same PR.
- [ ] `/article-review` clean on EN.
- [ ] `/article-review` clean on FR.
- [ ] `/french-audit` clean on FR.
- [ ] `/cross-ref-check` clean — ≥2 internal links per article, FR parity, bidirectional with related existing pieces.
- [ ] No specific pricing figures anywhere in the piece.
- [ ] If this is a work case file: title options were proposed to Ahmed and one was picked.
- [ ] Frontmatter complete per `docs/workflow.md` § Article workflow.
