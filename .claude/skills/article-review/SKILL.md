---
name: article-review
description: Pre-publish review for boringsystems articles. Loads design charter, target audiences, and French guide, then flags voice, structure, lane, and FR register issues. Use before publishing any new article or playbook — EN and FR together.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob, Skill
argument-hint: "[article slug — e.g. work/architecture-governance or writing/does-your-startup-need-a-cto — or full EN path]"
---

Review the article at $ARGUMENTS before it ships. Load the three governance docs, check against each, and produce a categorized flag report.

## Inputs

One of:
- A slug like `writing/does-your-startup-need-a-cto` or `work/breaking-vendor-lock-in` or `archive/s1-p0-how-we-run` — resolve to the EN file under `src/content/<collection>-en/<rest>.md(x)` and the FR file under `src/content/<collection>-fr/<rest>.md(x)`. Valid collections: `writing`, `work`, `building`, `archive`.
- A full path to an EN file — derive the FR pair by inserting `-fr` into the collection name.
- If no FR file exists yet, proceed EN-only and note that FR is missing.

## Process

### 1. Load governance docs

Read, in order:
- `docs/target-audiences.md` — voice-target definitions and lane mapping.
- `docs/design-charter.md` — voice, typography, layout, anti-patterns, lanes.
- `docs/french-guide.md` — FR register and the English-default rule.

If any of these is missing, stop and tell Ahmed to check the repo state — do not proceed on memory.

### 2. Frontmatter checks

- `title` present and non-empty.
- `description` present and non-empty.
- `date` present for articles in `writing`, `work`, `building` collections (EN + FR). Must be an ISO date (`YYYY-MM-DD`). Absent = **blocker** — the layout relies on it to render the meta strip and the cards. Seed from the file's first-merge git date (`git log --follow --diff-filter=A --format=%aI -- <path> | tail -1`). `archive` (playbooks) does not require `date`.
- Lane assignment = folder. There is no `persona` frontmatter field. An article's lane is set by which collection folder it lives in. Voice target is per-piece calibration (reviewer should ask "which voice target is this piece written for?" during step 4 and note it in the report — it is not a frontmatter value).
- If frontmatter contains `featured: true` or `highlight: true`, cross-check that the article is actually a representative piece — flag for human review.

### 3. Voice & structure (EN)

Check against the design charter:
- **Opening hook.** First paragraph should name the tension (technical) or the business stake (builder). Flag if it reads as "in this article, we will discuss…".
- **Hedging.** Search for "it depends", "may", "might", "could", "perhaps" — flag density >5/1000 words unless hedge is load-bearing.
- **Filler phrases.** Search for charter-banned EN fillers: "as we all know", "at the end of the day", "in today's fast-paced world", "it is important to note", "it should be noted".
- **Takeaway.** For case files, flag if there is no closing paragraph that crystallizes the insight. A bulleted summary does not count.
- **Length sanity.** Flag if article is under 400 words (likely incomplete) or over 5000 words (likely unfocused).

### 3a. Title clarity check

The title must pass the **teenager test**: a reasonably bright 16–18 year old who doesn't know the field should be able to guess what the article is about *from the title alone*. Flag as a **warning** if the title:

- Relies on abstract nouns the reader would need the article to decode (e.g. "The Architecture of X" where X is also abstract).
- Is clever or witty at the expense of clarity. Wit is earned by the body, not by the headline.
- Requires field expertise to even parse the subject. Technical terms in the title are fine *if* a smart non-expert can still extract the shape of the promise ("Why AI Agents Need Disposable Databases" — passes; "The Architecture of Disposable State" — fails).
- Leads with a metaphor before the subject ("The Ship of Theseus of Kubernetes" — fails until rewritten with the subject up front).

Pass-criteria:
- Names the subject concretely.
- Signals the promise of the piece (what the reader will understand / decide after finishing).
- Uses plain words for the non-technical connective tissue.

Report the title as a quoted string, state whether it passes, and if it fails propose 2–3 concrete alternatives.

### 3b. Prose clarity check

The **non-technical** English in the article should be readable by the same 16–18 year old reader — not *technically* literate, but linguistically unhindered. Technical jargon is allowed where the target reader has it; dense prose built out of ornamental English is never allowed.

Flag as **warnings** (cite line + quote):

- **Pompous / ornate phrasing** where plain English works: *"it can be posited that"*, *"one might observe"*, *"what is worth noting here"*, *"the fact of the matter is"*. Cut or rewrite.
- **Unnecessarily academic vocabulary** outside the domain: *"adumbrate"*, *"heretofore"*, *"concomitant"*, *"qua"*, *"ipso facto"*. Replace with the everyday word unless the reader-audience specifically expects it.
- **Long subordinate-clause sentences** where two short sentences work. If a sentence has three or more commas and no colon, it's probably a rewrite candidate.
- **Archaic or legalese constructions**: *"wherein"*, *"whereby"*, *"hereinafter"*, *"thereof"*. Almost never earned outside quoted policy text.
- **Inflated connectors**: *"furthermore"*, *"moreover"*, *"notwithstanding"*, *"inasmuch as"*. The charter already bans filler; these are filler with extra syllables.

What NOT to flag:
- Technical domain vocabulary that the intended reader has (*"disaggregated compute"*, *"copy-on-write"*, *"WAL replication"*, *"hyperscaler"*). These stay.
- Named incidents and field references that a technical peer recognizes (*"CAP"*, *"the S3 outage"*, *"Knight Capital"*).
- Deliberate short idioms or callback phrases the voice allows.

Rule of thumb: if a non-technical English word can be swapped for a simpler one without changing meaning, the simpler word wins.

### 3c. Slug-title alignment + description audience match

Two checks tied to the title-and-slug discipline (see `docs/design-charter.md` § Titles, descriptions, and slugs):

**Slug ↔ title.** For **new** articles (slug not yet published, no inbound URL pressure), the slug should equal the title in kebab-case form:

- Lowercase the title.
- Replace ` — ` (em-dash with surrounding spaces), `:`, `,` with `-`.
- Drop apostrophes, periods, and other punctuation.
- Replace remaining whitespace with `-`.
- Collapse multiple `-` to a single `-`. Drop leading/trailing `-`.

If `slug ≠ slugified(title)`, flag as a **warning** with the proposed slug. Recommend renaming the file before publish. **Do not flag this on already-published articles** where the slug is live in the wild — preserve URL stability, don't break inbound links. Heuristic for "already published": the article is in the most recent deploy on `main`, or has a `date` older than the current branch's first commit. When unsure, treat as published and skip the rename recommendation.

**Description ↔ voice target.** The `description` frontmatter field must match the piece's voice target (inferred in step 4):

- `technical` description: opens with technical tension or architectural framing; uses field vocabulary the technical reader has.
- `builder` description: opens with the business stake or operational decision; avoids engineer-only jargon (`IDE`, `tool-call layer`, `fresh-machine clone`, `harness configuration`); plain enough for a non-engineer operator.

If the description register clashes with the voice target — engineer jargon in a builder-target piece, or consumer-soft language in a technical piece — flag as a **warning** with the offending phrase quoted and a one-line proposed rewrite. Also flag if the description merely repeats the title in different words rather than sharpening the angle.

### 3d. List-pretending-to-be-prose check

When prose enumerates three or more items in sequence, each opening with a labelled term ("Short-term: … Mid-term: … Long-term: …" or "Business: … Product: … Engineering: …"), separated by periods rather than as bullets, that's a list pretending to be a paragraph. Lists scan; prose-with-colons doesn't. See `docs/design-charter.md` § Lists vs prose.

**Detection pattern.** Within a single paragraph, find three or more occurrences of `<term>: <description>` where each `<term>` is a noun or short noun phrase and each `<description>` is a definition or expansion of that term, separated by sentence breaks (`. `).

**Flag as warning** with:

- The line number range of the offending paragraph.
- The quoted offending paragraph (truncate to ~200 chars if long, ending on `…`).
- A proposed conversion: lead-in sentence ending with `:` + bulleted list with bold lead-ins (`**Term:**`) + wrap-up sentence on its own paragraph if any.

**Do not flag:**

- Two-item enumerations (the threshold is **three or more**).
- Items already correctly formatted as `<ul>` / markdown bullets.
- Parallel-structure rhetoric where labels are anaphora (rhetorical repetition for cadence, not enumeration). **Heuristic**: if you remove the labels and the descriptions still read as continuous prose, it's an enumeration → flag. If removing the labels breaks the flow, it's rhetoric → leave.

### 4. Lane / voice alignment

- Resolve the article's lane from its collection path (`writing` / `work` / `building` / `archive`).
- Infer the intended voice target from the first 3 paragraphs: `technical` (names a technical tension) or `builder` (names a business stake / decision).
- Check that the voice target's entry-point expectation is met:
  - `technical` → tension / architecture decision / trade-off named immediately.
  - `builder` → business implication or operational consequence named in paragraph 1, with a clear "what to do" orientation toward the end.
- Lane-specific expectations on top of the voice check:
  - `writing` → the piece must end with a takeaway the reader can act on (decision-guide register).
  - `work` → opens with context + tension of the engagement; closes with outcome and principle extracted.
  - `building` → active tense, names current work. Dated by design.
  - `archive` → principle or framing stated up-front, not buried.
- Flag mismatches as **warnings**. This check is judgment-heavy — report the discrepancy with quoted text, don't autofix.

### 5. Cross-link scan

Check whether this article connects to already-published pieces it should be linking to.

- Extract the article's main named entities: companies, products, frameworks, architectural patterns, concrete tools. Limit to the 3–5 that actually carry weight in the piece.
- Grep the four content collections (`src/content/{writing,work,building,archive}-en/`) for each entity. Ignore the article being reviewed itself.
- For each match, judge load-bearing:
  - Does the other article explain *why* this entity / pattern matters in a way that extends the current piece? → link opportunity.
  - Does the other article use the entity as evidence for a parallel argument? → link opportunity.
  - Is the match a passing mention that wouldn't give the reader new context? → skip, not a miss.
- For each **load-bearing match that is not already linked** in the article body, flag as a **nit**: name the target article, quote the sentence in the current article that should carry the link, and propose anchor text.
- Also flag the **reverse direction**: if the target article would clearly benefit from linking back to this new piece, note it in the cross-link section as a follow-up task. This is a nit too — Ahmed decides per-link.
- Do not flag more than 3 missed cross-links. If more are candidates, pick the 3 most load-bearing; the rest are editorial noise, not invariants.
- Cross-links are always nits, never blockers. Cross-linking is a quality lever; an article with no cross-links can still ship.

### 6. Typography / structural signals

- Flag mono-font blocks (`\`\`\``) that contain prose (not code, paths, commands, or identifiers) — mono is signal, not texture.
- Flag bold runs longer than 4 words (bold is for the one scannable word).
- Flag more than one `h1` in the body (the title is the h1).
- Flag heading gaps (jumping from `h2` to `h4`).

### 7. Anti-pattern check

Grep the article text for explicit anti-patterns from the charter:
- Emoji characters (outside quoted content) → blocker.
- "Trusted by", "our amazing customers", testimonial-pull strings → blocker.
- "🚀", "✨", "💡" as section markers → blocker.
- "Subscribe to our newsletter", popup/modal hooks → blocker.
- Exit-intent, fake-urgency language — blocker.

### 8. Article tail check (optional)

If the article has a trailing email-gated section (detected by a marker like `{/* email-gate */}` or a component like `<EmailGate />`):
- Must come **after** the takeaway, not before.
- Gated asset must be named specifically (not "more insights").
- Only one tail per article.
- Flag violations as blockers.

### 9. FR pair review

If the FR pair exists, invoke the `french-audit` skill on the pair (pass `<en-path>:<fr-path>` so length comparison runs). Embed its report inline under a `## French audit` section.

If FR is missing and the article is in a collection that has existing FR siblings, flag as a warning: "FR version expected but missing."

### 10. Schema-level sanity

- File is in the correct collection directory.
- File extension matches collection (`.md` vs `.mdx`).
- Images referenced are in `public/` or use absolute URLs — no broken paths.
- Internal links use site-relative, **language-prefixed** paths that match the canonical folder-equals-URL structure: `/en/writing/<slug>`, `/en/work/<slug>`, `/en/building/<slug>`, `/en/archive/<slug>` for EN articles; FR mirrors. Never full domain URLs, never unprefixed paths. The root `/` 301-redirects to `/en/`; no other redirects exist.

### 11. Cross-reference audit

Invoke `/cross-ref-check $SLUG` and embed its full output under `## Cross-reference audit` in the report. This checks bidirectional links and FR parity more thoroughly than the inline cross-link scan in step 5.

If `cross-ref-check` is unavailable, note "skipped — cross-ref-check not available" and proceed.

## Output format

Single markdown report to stdout, with sections:

```
# Article Review — <slug>

## Planning snapshot

So Ahmed can catch a miscall before reading the flag list:

- **Lane**: <Writing | Work | Building | Archive> (from folder path)
- **Voice target (inferred)**: <technical | builder>
- **What the reviewer reads this article as trying to do**: <one sentence describing
  the article's intent as inferred from title + description + opening paragraphs.
  e.g. "Frame why AI agent workloads make ephemeral databases economically rational,
  using the Snowflake/Neon parallel as the setup." — If this sentence does not
  match what Ahmed thinks the article is for, the review is reviewing the wrong
  piece. Catch it here.>
- **Title clarity verdict**: <pass | fail, with proposed alternatives if fail>
- **EN path**: <path>
- **FR path**: <path or "missing">

## Blockers
- [category] L<n>: <issue>
...

## Warnings
- [category] L<n>: <issue>
...

## Nits
- [category] L<n>: <issue>
...

## French audit
<embedded output from french-audit skill, or "skipped — FR missing">

## Cross-reference audit
<embedded output from cross-ref-check skill, or "skipped — not available">

## Verdict
- Blockers: N
- Warnings: N
- Nits: N
- Recommendation: <ship / fix blockers first / rethink>
```

## Rules

- **Blockers** must be fixed before ship.
- **Warnings** are judgment calls — Ahmed decides.
- **Nits** are style preferences.
- Do not auto-fix. Do not rewrite. This is a linter.
- Every flag must cite a line number or a specific quote. "The voice feels off" is not a valid flag.
- If the article cannot be reviewed (missing file, missing governance docs, malformed frontmatter), stop with a single-line error and do not produce a partial report.

## When to invoke

Run this skill:
- Before opening a PR for any content change.
- After running `/new-post` (once that skill exists).
- On demand when Ahmed wants to re-review existing content against updated governance docs.
