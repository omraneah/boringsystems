---
name: article-review
description: Pre-publish review for boringsystems articles. Loads design charter, target audiences, and French guide, then flags voice, structure, lane, and FR register issues. Use before publishing any new article or playbook — EN and FR together.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob, Skill
argument-hint: "[article slug — e.g. system-design/architecture-governance — or full EN path]"
---

Review the article at $ARGUMENTS before it ships. Load the three governance docs, check against each, and produce a categorized flag report.

## Inputs

One of:
- A slug like `system-design/architecture-governance` or `archive/s1-p0-how-we-run` — resolve to the EN file under `src/content/<collection>-en/<rest>.md(x)` and the FR file under `src/content/<collection>-fr/<rest>.md(x)`. Valid collections: `system-design`, `builders`, `technology`, `archive`.
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
- `date` present for articles in `system-design`, `builders`, `technology` collections (EN + FR). Must be an ISO date (`YYYY-MM-DD`). Absent = **blocker** — the layout relies on it to render the meta strip and the cards. Seed from the file's first-merge git date (`git log --follow --diff-filter=A --format=%aI -- <path> | tail -1`). `archive` (playbooks) does not require `date`.
- Lane assignment = folder. There is no `persona` frontmatter field; an article's voice target is implicit in its collection: `system-design` → `technical`, `builders` → `builder`, `technology` → cross-cut, `archive` → long-living.
- If frontmatter contains `featured: true` or `highlight: true`, cross-check that the article is actually a representative piece — flag for human review.

### 3. Voice & structure (EN)

Check against the design charter:
- **Opening hook.** First paragraph should name the tension (technical) or the business stake (builder). Flag if it reads as "in this article, we will discuss…".
- **Hedging.** Search for "it depends", "may", "might", "could", "perhaps" — flag density >5/1000 words unless hedge is load-bearing.
- **Filler phrases.** Search for charter-banned EN fillers: "as we all know", "at the end of the day", "in today's fast-paced world", "it is important to note", "it should be noted".
- **Takeaway.** For case files, flag if there is no closing paragraph that crystallizes the insight. A bulleted summary does not count.
- **Length sanity.** Flag if article is under 400 words (likely incomplete) or over 5000 words (likely unfocused).

### 4. Lane / voice alignment

- Resolve the article's lane from its collection path (`system-design` / `builders` / `technology` / `archive`).
- Read the first 3 paragraphs. Check that the entry point matches the lane's voice target:
  - `system-design` (`technical`) → tension / architecture decision / trade-off named immediately.
  - `builders` (`builder`) → business implication or operational consequence named in paragraph 1, with a clear "what to do" orientation toward the end.
  - `technology` → topic/tool named concretely, no vague scene-setting.
  - `archive` → principle or framing stated up-front, not buried.
- Flag mismatches as **warnings**. This check is judgment-heavy — report the discrepancy with quoted text, don't autofix.

### 5. Typography / structural signals

- Flag mono-font blocks (`\`\`\``) that contain prose (not code, paths, commands, or identifiers) — mono is signal, not texture.
- Flag bold runs longer than 4 words (bold is for the one scannable word).
- Flag more than one `h1` in the body (the title is the h1).
- Flag heading gaps (jumping from `h2` to `h4`).

### 6. Anti-pattern check

Grep the article text for explicit anti-patterns from the charter:
- Emoji characters (outside quoted content) → blocker.
- "Trusted by", "our amazing customers", testimonial-pull strings → blocker.
- "🚀", "✨", "💡" as section markers → blocker.
- "Subscribe to our newsletter", popup/modal hooks → blocker.
- Exit-intent, fake-urgency language — blocker.

### 7. Article tail check (optional)

If the article has a trailing email-gated section (detected by a marker like `{/* email-gate */}` or a component like `<EmailGate />`):
- Must come **after** the takeaway, not before.
- Gated asset must be named specifically (not "more insights").
- Only one tail per article.
- Flag violations as blockers.

### 8. FR pair review

If the FR pair exists, invoke the `french-audit` skill on the pair (pass `<en-path>:<fr-path>` so length comparison runs). Embed its report inline under a `## French audit` section.

If FR is missing and the article is in a collection that has existing FR siblings, flag as a warning: "FR version expected but missing."

### 9. Schema-level sanity

- File is in the correct collection directory.
- File extension matches collection (`.md` vs `.mdx`).
- Images referenced are in `public/` or use absolute URLs — no broken paths.
- Internal links use site-relative, **language-prefixed** paths that match the canonical folder-equals-URL structure: `/en/system-design/<slug>`, `/en/builders/<slug>`, `/en/technology/<slug>`, `/en/archive/<slug>` for EN articles; FR mirrors. Never full domain URLs, never unprefixed paths. The root `/` 301-redirects to `/en/`; no other redirects exist.

## Output format

Single markdown report to stdout, with sections:

```
# Article Review — <slug>

**Lane**: <System Design | Builders | Technology | Archive>
**Voice target**: <technical | builder | cross-cut | long-living>
**EN path**: <path>
**FR path**: <path or "missing">

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
