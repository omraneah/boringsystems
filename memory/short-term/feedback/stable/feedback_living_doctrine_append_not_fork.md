---
name: Living doctrines get appended to, not forked
description: When a long-term inner-game doctrine is explicitly marked "living, enriched across sessions" (e.g., Surrender-Doctrine.md), future rounds add to the same file rather than spinning up siblings or scattered notes. Reach back to the canonical file before writing.
type: feedback
---

When Ahmed's practice deepens further on a topic that already has a **living doctrine file** in `memory/long-term/inner-game/` — a file whose own frontmatter or status block names it as "living" / "enriched across sessions" / "many more rounds expected" — the next round **appends to that file**. It does not create siblings, parallel notes, or fresh "Letting-Go-V2.md" style forks.

**Why:** Living doctrines are the workspace's mechanism for letting depth compound across sessions instead of evaporating. The contract is: today's articulation lives next to last month's, both visible together, and Claude (any future session) can read the full arc. Forking breaks the compounding. Ahmed explicitly named this pattern when seeding `Surrender-Doctrine.md` on 2026-05-17 — "we will do many rounds like this." Without this rule, the second round risks landing in a daily entry, a tmp/ file, a new sibling doctrine, or just a chat exchange that never gets codified — and the compounding promise breaks on the first re-entry.

**How to apply:**

- **Before writing any new doctrine-shaped material**, check `memory/long-term/inner-game/` for an existing living doctrine on the topic. If one exists, the default is *append*, not create.
- **Living-doctrine detection signals** (any of these → treat the file as living):
  - Frontmatter contains `seeded:` + `last_reviewed:` fields suggesting ongoing curation.
  - Status block names the file "living," "enriched across sessions," "first round," or similar.
  - The "How this doctrine evolves" section lists update triggers (new practice-line, new trap, new felt-test, misread).
- **Append shape:** add a new dated subsection inside the relevant existing section (e.g., a new trap goes under `## Traps the mind sets at this altitude`, a new practice-line under `## Core practice-lines`). Preserve the previous content verbatim — the older articulation is part of the arc, not stale matter to overwrite.
- **Update `last_reviewed:`** in the frontmatter to today's date. Leave `seeded:` alone (that's the first-round date and is load-bearing).
- **Cross-references in I-AM / Meta-Identity-Constitution / Path-Doctrine** generally do not need updates round-over-round — they already point at the doctrine. Touch them only if the new round changes the **summary** of what the doctrine covers (rare).
- **Daily entry** still gets the per-round capture (chronological log of what surfaced today), but the doctrine itself is where the *codified* form lives. Don't duplicate the codification in the daily entry — link to the doctrine instead.
- **Generalization:** this rule is currently anchored on `Surrender-Doctrine.md` but applies to any future living doctrine that emerges. If a second living doctrine appears, this feedback rule scales without modification.
- **Anti-pattern to refuse:** creating `Surrender-Doctrine-Round-2.md`, `Letting-Go-Practice.md` as a parallel to the existing file, or filing new practice material only into `tmp/` or a daily entry without folding it into the canonical doctrine.

When the second round arrives and the pattern holds, this rule has earned promotion. Until then it lives in `in-flight/` as a young rule waiting for its second test.
