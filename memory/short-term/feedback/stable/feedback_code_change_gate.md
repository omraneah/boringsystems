---
name: Code change gate — pre-execution reading + plan-confirm + post-execution self-review
description: For any non-trivial code change (multi-file, structural, new capability), enforce three gates before declaring done. Applies across all projects.
type: feedback
---

Three mandatory gates, in order. None are skippable.

## Gate 1 — Pre-execution: read context, write plan, confirm

Before writing the first line of code on any multi-file or structural change:

1. **Read the project's domain docs.** At minimum: `docs/constraints.md` + `docs/workflow.md`. For analytics work: also `docs/analytics.md`, `docs/target-audiences.md`. For i18n/routing work: also `docs/architecture-and-toolchain.md`. Do not infer from CLAUDE.md alone — the detail docs exist because CLAUDE.md is a pointer, not the full context.
2. **Write the plan.** What files change, what decisions are required, what assumptions are being made.
3. **Confirm with Ahmed before executing.** Especially: any decision that can't be easily reversed once code is written (removing a dependency, choosing an event taxonomy, mapping a derived dimension). Do not execute on assumed answers.

**Why:** A prior boringsystems analytics session shipped three rounds of corrections because Vercel Analytics removal, voice_target design, and event taxonomy were never confirmed in plan phase. Ahmed's cognition paid the tax that the plan gate would have blocked.

**How to apply:** "I'm about to start X. Here's my plan: [N bullets]. Decisions I need confirmed before I execute: [list]. Confirming?" — then wait.

## Gate 2 — During: atomicity on design changes

When a design decision changes mid-session (Ahmed overrules an approach, a constraint is discovered that invalidates a plan):

- Update all affected docs (ADRs, reference docs, constraints.md) in the **same commit** as the code change.
- Never split doc updates from code updates across commits. "I'll update the docs later" creates guaranteed drift.

**Why:** A prior session updated `persistence: 'none'` in code but left the ADR saying "consent banner required." The ADR was authoritative for anyone reading it after the session.

## Gate 3 — Post-execution: run skills, fix, re-run until clean, then declare done

After finishing any non-trivial boringsystems code change, before pushing:

1. **Run the relevant review skills.** For any component touching outbound links, CTAs, or conversion actions: `/analytics-audit`. For structural/architectural changes: `/arch-review`. For articles: `/article-review` + `/french-audit`. The CLAUDE.md skills table maps work type → skill.
2. **Fix all FIX-level findings.** WARN-level: judgment call. FIX-level: fix before declaring done.
3. **Re-run the relevant skill.** Confirm clean.
4. **Only then declare done** and push.

"Build passed" is a necessary condition, not a sufficient one. The build gate catches type errors and broken imports. The skills gate catches wiring gaps, missing tracking, broken invariants, and doc drift. Both must pass.

**Why:** A prior boringsystems analytics session had 5 untracked outbound links on about pages, a missing ContactForm tracking event, wrong voice_target mapping, and an ADR with wrong facts — all of which `/analytics-audit` and `/arch-review` caught. None were caught before Ahmed reviewed the PR because the skills were never run pre-push.

---

**Applies to:** boringsystems, personal-apps, any project with a skills table in its CLAUDE.md.

**Does not apply to:** typo fixes, one-line changes, single-file trivial edits with no architectural surface.
