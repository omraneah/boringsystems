---
name: french-audit
description: Audit French content on boringsystems against the French voice guide. Flags over-translation of English terms, banned register phrases, over-length paragraphs, and passive-voice overuse. Use after drafting or updating any FR article, playbook, or page copy.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
argument-hint: "[path to FR file — or path pair like en.md:fr.md for length comparison]"
---

Audit French content at $ARGUMENTS against `docs/french-guide.md`.

## Inputs

One of:
- A single FR file path (skips length comparison).
- A colon-separated pair `<en-path>:<fr-path>` (enables length comparison).
- No argument — scan all FR content collections (`src/content/writing-fr/`, `src/content/work-fr/`, `src/content/building-fr/`, `src/content/archive-fr/`, `src/pages/fr/`) and pick the most-recently-modified file.

## Process

1. **Load the guide.** Read `docs/french-guide.md`. Extract the two rules (re-voice, don't translate; default to English for technical/business terms), the do-not-translate list (illustrative, not exhaustive), the banned register phrases list, and the register rules. This is the source of truth — do not substitute general knowledge.

2. **Scan for over-translation (the primary violation).** The default is that English technical and business terms stay in English. Flag any case where a professional English term was translated when it shouldn't have been.
   - Start with the do-not-translate list as an anchor, but the scan is **not limited to the list** — any English tech or business term with common professional usage that was translated is a violation.
   - Common failure patterns to grep for:
     - "démarrage" where "startup" should have been used
     - "cadre de travail" → should be "framework"
     - "sans serveur" → should be "serverless"
     - "agent conversationnel" → should be "chatbot" or "agent"
     - "modèle de langage" → should be "LLM"
     - "ingénierie" as a discipline/role label → should be "engineering"
     - "produit" as a function/discipline → should be "product"
     - "marketing/ventes/opérations/croissance/conception" as role labels when "marketing / sales / operations / growth / design" should be kept
     - "intégration" where "onboarding" is standard
     - "pré-lancement / amorçage" where "early-stage / bootstrap" are standard
   - **Negative rule (critical): never flag an English term that was left in English as a missing translation.** That is correct behavior, not a violation. Both boringsystems audiences (technical + builder) are English-savvy. Sentences like *"L'équipe product valide la roadmap avant le prochain sprint."* are perfectly normal professional French and must pass clean.

3. **Scan for banned register phrases.** Grep for each banned phrase from the guide. Report every occurrence with line number. Do not judge severity — every occurrence is a flag.

4. **Passive voice scan.** Find `être + participe passé` constructions. Flag paragraphs where passive density exceeds ~30% of sentences. Active-voice default is a hard rule.

5. **Length check (if EN file provided).** For each paragraph pair (matched by order), compute `fr_chars / en_chars`. Flag ratios above 1.25 as over-length. Report the specific paragraph with its ratio.

6. **Long-sentence scan.** Flag any sentence >25 words. Report line number and word count.

7. **Headline / CTA check.** If the file has frontmatter `title` or `description`, flag if it reads as a literal EN→FR mapping (same word count, same structure) rather than a rewrite. This check is heuristic — flag for human review, don't fail.

## Output format

Structured markdown report, written to stdout (not a file). Sections:

```
# French Audit — <file path>

## Blockers — over-translation (English term translated when it shouldn't have been)
- L42: "cadre de travail" should be "framework"
- L87: "agent conversationnel" should be "chatbot" or "agent"
- L103: "ingénierie" used as role label should be "engineering"

## Warnings — banned register
- L12: "Il convient de noter que" — state the thing directly
- L34: "Dans le cadre de" — restructure
- L56: "En effet" as sentence opener — likely deletable

## Warnings — length ratio
- Paragraph §3 (L45–52): ratio 1.47 — compress
- Paragraph §7 (L112–118): ratio 1.31 — compress

## Nits — passive voice cluster
- Paragraph §5: 4 of 6 sentences use passive construction; consider active voice

## Nits — long sentences
- L78: 34 words
- L102: 29 words

## Headline review (heuristic)
- frontmatter.title: reads as literal translation — consider rewrite

## Summary
- Blockers: 2
- Warnings: 5
- Nits: 3
- Recommended action: fix blockers, review warnings, accept/ignore nits.
```

## Rules

- Do **not** auto-fix. Ahmed decides per flag. The skill is a linter, not a formatter.
- Do **not** flag English technical or business terms that were left in English — that's the correct behavior.
- Do **not** suggest sentence rewrites unless the rewrite is trivially obvious. The skill identifies issues; Ahmed rewrites.
- If the file is empty or not found, return a single-line error and stop.
- If the guide file is missing, stop and ask Ahmed to check the repo state — do not proceed on memory alone.

## Invocation by other skills

`article-review` invokes this skill internally when reviewing FR content. When invoked as a sub-step, return the structured report verbatim so the parent skill can aggregate.
