# boringsystems — Workflow SOP

Boringsystems-specific flow extensions. The general collaboration protocols (code change flow, structural change flow, research flow, card flows, autonomy gradient, per-flow skill checklist) live in the workspace SOP: `memory/medium-term/project-management/workspace-workflow.md`. Read that first.

This file covers what's specific to boringsystems: article pipelines, Astro build gates, and post-merge cleanup.

---

## Article context drop — autonomous pipeline

When the operator shares article context — materials, raw input, personal thoughts, potential cross-links, framing — the full article creation pipeline triggers immediately, no questions asked, through to PR.

**Trigger:** operator shares any of: source material, voice memo transcript, a thread of thoughts, cross-link candidates, framing context for a piece.

**Pipeline (end-to-end, no pauses):**

1. Write EN article from the provided context.
2. Write FR article — re-voiced, not translated.
3. Wire frontmatter (title, description, date, series if applicable).
4. Add ≥2 internal cross-references. Run `/cross-ref-check`.
5. Run `/french-audit` on the FR file.
6. Run `/article-review` on EN + FR together. Fix all BLOCKERs.
7. Self-review pass — read both as a reader. Check description fit, voice consistency, cross-reference naturalness.
8. `/commit`
9. `/pr` — Ahmed opens the PR; Claude doesn't.

If something is genuinely ambiguous (one article or two, which lane), pick the most natural interpretation and note it in the PR summary. No upfront questions.

---

## Article workflow

For new articles or updates to existing articles — manual, step-by-step reference.

1. **Branch.** Create a feature branch in boringsystems: `git checkout -b omraneah/<article-slug>`.

2. **Draft.** Write in the correct content collection folder.
   - EN: `src/content/<lane>-en/`
   - FR: `src/content/<lane>-fr/`
   - Both locale files must exist before the PR. No orphan content.

3. **Frontmatter.** Required fields per lane:
   - `title`, `description`, `date` (Writing/Work/Building lanes) — `date` = first-merge git date via `git log --follow --diff-filter=A --format=%aI -- <path> | tail -1`
   - Archive lane: `title`, `description` — no `date` (principles, not time-stamped)
   - `description` must be specific to the content, not a tagline. Match the voice target (`docs/target-audiences.md`).

4. **Cross-references.** Every article must link to ≥2 related pieces. Run `/cross-ref-check` before committing.

5. **FR parity.** Every internal link added to the EN file must have an FR counterpart in the FR mirror. Run `/french-audit` on the FR file.

6. **Review.** Run `/article-review` on both EN + FR together. Fix all BLOCKERs before committing. WARNs and NITs: judgment call.

7. **Commit.** Run `/commit`. The pre-commit hook runs `astro check` + `npm run verify` + `astro build`. Fix any failures — `--no-verify` is forbidden.

8. **PR.** Run `/pr`. Ahmed opens the PR on GitHub.

9. **Post-merge cleanup.** See the dedicated section below.

---

## Code change and structural change

Follow the workspace code change flow (`memory/medium-term/project-management/workspace-workflow.md` §Code change flow and §Structural change flow).

**boringsystems-specific additions on top of the workspace flow:**

- **Read context:** `docs/constraints.md` is mandatory. Domain-specific docs: analytics work → `docs/analytics.md` + `docs/target-audiences.md`; i18n/routing → `docs/architecture-and-toolchain.md`.
- **Check constraints:** Run `/check-constraints` before touching i18n, routing, content schema, deps, API surface, or enforcement tier.
- **Verify locally:** Run `npm run build` (not just type-check) before committing.
- **Review skills:**
  - Analytics work (new outbound links, CTAs, conversion actions): `/analytics-audit` — fix all FIX-level findings, re-run until clean.
  - Structural/architectural changes: `/arch-review`.
- **Commit gate:** Pre-commit hook runs `astro check` + `npm run verify` + `astro build`. Fix all failures; `--no-verify` is forbidden.

---

## Post-merge cleanup

Run after every merged PR. Both steps are required.

### Step 1 — Clean up boringsystems

```bash
# Run from inside the boringsystems repo
git checkout main
git pull origin main
git branch -D omraneah/<branch-name>    # force-delete required: squash merges don't leave a standard merge commit
```

### Step 2 — Bump the workspace submodule pointer

The workspace repo tracks boringsystems at a specific commit. Without this bump, a cloud agent starting from the workspace root sees stale boringsystems content.

```bash
# Run from inside the workspace repo (parent of boringsystems/)
git checkout -b omraneah/bump-boringsystems-<short-description>
git add boringsystems
git commit -m "chore(submodule): bump boringsystems to <short-description>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
git push -u origin omraneah/bump-boringsystems-<short-description>
```

Then Ahmed opens the workspace PR on GitHub.

---

## Quick reference

| Situation | First step |
|---|---|
| New article | Draft both locales → `/article-review` → commit |
| Updating existing article | Check slug stability (never rename post-publish) → edit → `/article-review` |
| Layout / component change | See workspace code change flow → read context → `/pre-start` → confirm → edit → skills → `npm run build` |
| Schema / routing / i18n change | `/check-constraints` → ADR decision → workspace structural change flow |
| Any PR merged | Post-merge cleanup immediately (both steps) |
| Pattern repeated twice in a session | Stop → propose codification before the third time |
| llms.txt needs updating | Update `public/llms.txt` key pieces list when a high-signal article ships |
