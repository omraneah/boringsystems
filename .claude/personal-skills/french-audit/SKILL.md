---
name: french-audit
description: Audit French content on boringsystems against the French voice guide. Flags translated jargon, banned register phrases, over-length paragraphs, and passive-voice overuse. Use after drafting or updating any FR article, playbook, or page copy.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
argument-hint: "[path to FR file — or path pair like en.md:fr.md for length comparison]"
---

Audit French content at $ARGUMENTS against `boringsystems/docs/french-guide.md`.

## Inputs

One of:
- A single FR file path (skips length comparison).
- A colon-separated pair `<en-path>:<fr-path>` (enables length comparison).
- No argument — scan all FR content collections (`src/content/case-files-fr/`, `src/content/operating-playbooks-fr/`, `src/pages/fr/`) and pick the most-recently-modified file.

## Process

1. **Load the guide.** Read `boringsystems/docs/french-guide.md`. Extract the do-not-translate list, banned register phrases list, and register rules. This is the source of truth — do not substitute general knowledge.

2. **Scan for do-not-translate violations.** For each term in the list, grep the FR file(s) for common French translations that should have been left in English. Examples:
   - "démarrage" where "startup" should have been used
   - "déploiement" is fine as infrastructure term, but "déployer une startup" for "launch a startup" is wrong — it should be "lancer une startup"
   - "sans serveur" → "serverless"
   - "cadre de travail" → "framework"
   - "agent conversationnel" → "chatbot" or "agent"
   - "modèle de langage" used where "LLM" is standard

3. **Scan for banned register phrases.** Grep for each banned phrase from the guide. Report every occurrence with line number. Do not judge severity — every occurrence is a flag.

4. **Passive voice scan.** Find `être + participe passé` constructions. Flag paragraphs where passive density exceeds ~30% of sentences. Active-voice default is a hard rule.

5. **Length check (if EN file provided).** For each paragraph pair (matched by order), compute `fr_chars / en_chars`. Flag ratios above 1.25 as over-length. Report the specific paragraph with its ratio.

6. **Long-sentence scan.** Flag any sentence >25 words. Report line number and word count.

7. **Headline / CTA check.** If the file has frontmatter `title` or `description`, flag if it reads as a literal EN→FR mapping (same word count, same structure) rather than a rewrite. This check is heuristic — flag for human review, don't fail.

## Output format

Structured markdown report, written to stdout (not a file). Sections:

```
# French Audit — <file path>

## Blockers — do-not-translate violations
- L42: "cadre de travail" should be "framework"
- L87: "agent conversationnel" should be "chatbot" or "agent"

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
- Do **not** flag English technical terms that appear in the do-not-translate list — that's the correct behavior.
- Do **not** suggest sentence rewrites unless the rewrite is trivially obvious. The skill identifies issues; Ahmed rewrites.
- If the file is empty or not found, return a single-line error and stop.
- If the guide file is missing, stop and ask Ahmed to check the boringsystems repo state — do not proceed on memory alone.

## Invocation by other skills

`article-review` invokes this skill internally when reviewing FR content. When invoked as a sub-step, return the structured report verbatim so the parent skill can aggregate.
