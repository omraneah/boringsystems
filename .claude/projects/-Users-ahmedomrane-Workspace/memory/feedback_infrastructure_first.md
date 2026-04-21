---
name: Infrastructure-first, content-second
description: When adding a capability that will be reused (lead magnets, date meta, mermaid diagrams, etc.), build the typed registry / helper / plugin first, then the content that uses it. Do not inline a one-off.
type: feedback
originSessionId: e464aaed-a5a0-4c1c-ac8b-19b9dd83adf6
---
When adding a capability that will show up in more than one place, build the reusable artifact first — then the specific content or page that uses it. One-off inline implementations are rework.

**Why:** Ahmed said this explicitly in session 2026-04-21: "make sure things are abstracted higher whenever you see that I'm using it in multiple places." The lead-magnet build validated it — a typed registry + component + API route took the same hour as an inline one-off would have, but now any future magnet is a registry entry rather than a new flow. The date-meta helper (`src/lib/article-meta.ts`) followed the same pattern and paid off across EN + FR listings.

**How to apply:** Before writing the first instance, ask "is this the only place this will live?" If the answer is anything weaker than a firm yes, build the typed registry / helper / plugin first. Typed registries on boringsystems follow the `lead-magnets.ts` shape: a `Record<slug, Asset>`, per-locale content, a `getEntry(slug)` accessor that throws on unknown. Ahmed's aesthetic is pragmatic — one short file with explicit types beats a generic abstraction with reflection.

Do not over-apply: if the thing is genuinely one-of-one (a single hero on a single page), inline it. The rule is "abstract when reuse is likely", not "abstract preemptively".
