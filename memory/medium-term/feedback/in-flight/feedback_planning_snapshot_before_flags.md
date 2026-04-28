---
name: Planning Snapshot Before Flags — Review Skill Output Shape
description: Every pre-publish review skill I design or update should open its report with a stated interpretation of what the reviewed artifact is trying to do, before listing flags. This catches miscalls early by making the reviewer's read explicit.
type: feedback
originSessionId: 44ff18a5-ca81-4a95-9c8a-b9ba7360d45f
---
When designing or updating a **pre-publish review skill** (article review, PR review, copy review, landing-page review — any skill whose output is "is this ready to ship?"), the report must open with a **Planning snapshot** that states:

- The artifact's structural placement (lane, collection, category, URL).
- The inferred audience / voice target / positioning.
- **One sentence describing what the reviewer reads the artifact as trying to do.**
- Any up-front verdicts that would invalidate the rest of the review if wrong (e.g. title clarity for articles).

This section appears **before** the Blockers / Warnings / Nits list. The reason is not cosmetic: if the reviewer has misread what the artifact is for, every flag that follows is reviewing the wrong piece. Forcing the interpretation to be explicit lets Ahmed (or whoever is reading the report) catch the miscall in two seconds rather than after arguing through a flag list.

**Why:** 2026-04-23 boringsystems session. After BOR-7 shipped, Ahmed caught a cryptic title ("The Architecture of Disposable State") that the `/article-review` skill had passed clean. The skill had no mechanism to state its read of the piece's intent — so the miscall wasn't a misjudgment, it was an unstated one. Adding a Planning-snapshot header to the review output would have forced the reviewer to name the article's promise in a sentence, which would have surfaced the title gap immediately. Ahmed confirmed the pattern carries forward: any future review skill gets this shape.

**How to apply:**

- When **writing a new review skill**, the output-format template must include a "Planning snapshot" section at the top. Fields: structural placement + audience + one-sentence intent interpretation + up-front verdicts on title / framing / naming.
- When **updating an existing review skill**, add the section if it's not already there.
- The snapshot is not decorative. It is a trap-catcher. Keep it to 4–6 lines, no more. The cost is low; the save per miscall caught is high.
- This does not replace the Blockers / Warnings / Nits list. It precedes and contextualises it.
- The first verdict inside the snapshot should be whatever **would invalidate the review if wrong**. For articles that is lane + title clarity. For PR reviews it might be scope + intent. Adapt per skill.

**Canonical example:** `boringsystems/.claude/skills/article-review/SKILL.md` — the Planning-snapshot section added 2026-04-23 includes Lane, Voice target (inferred), "What the reviewer reads this article as trying to do", and Title clarity verdict.
