# Feedback — Active Behavioural Rules

> Every behavioural rule lives here first. By design temporary — feedback is mid-horizon by nature: too active to be long-term invariant, too durable to be short-term episodic.
> Auto-loaded every session. See `../../README.md` for full architecture.

## What feedback is

Feedback is the catch-all for rules Ahmed has surfaced but hasn't yet structured into a more durable form. *"Things I didn't structure yet that could be structured later."*

Examples of what becomes feedback:

- Corrections Ahmed gives during work ("don't mock the database in these tests")
- Validations Ahmed signals on a non-obvious approach ("yes exactly, keep doing that")
- Discipline patterns Claude must apply going forward ("when X, fire Y skill")
- Workspace conventions worth holding to even if they evolve

Each rule lives in its own file, frontmattered, with a `Why:` and `How to apply:` section so future-Claude can judge edge cases.

## Lifecycle

Feedback evolves on the fly in a feedback loop:

```
[Surfaced]      ← Ahmed gives the correction or validation
   ↓
[Codified]      ← Claude writes a feedback_*.md file here, usually within the same turn
   ↓
[Held]          ← Auto-loaded every session, applied across work
   ↓
[Reviewed]      ← Weekly consolidation surfaces patterns: condense? promote? archive?
   ↓
[Resolved]      ← Promoted to long-term, condensed into a doctrine, or archived
```

Resolution paths:

- **Promotion to long-term.** When a rule has held across domains and time and become identity-shaped (vs operationally-shaped), it earns long-term status. Reframed as part of the constitution.
- **Condensation.** When multiple feedback files cover related ground, they merge into a single principle that captures the cluster. The originals get archived; the condensed version may stay in feedback or promote.
- **Archival.** When a rule is no longer relevant (the situation changed, the operator changed, the tooling changed), it moves to `_archive/` (or just gets removed if pre-merge).

## Why feedback lives in medium-term

Feedback is mid-horizon by nature:

- **Not long-term:** because rules are still being shaped. Long-term is for what has crystallized.
- **Not short-term:** because rules carry forward across sessions and weeks. Short-term is for what passes.
- **Medium-term:** because rules are active, evolving, expected to change as understanding sharpens.

The auto-load policy makes feedback always-in-scope despite living in medium-term. Behaviour doesn't degrade just because the file's logical home is mid-horizon.

## Auto-load

**Full content every session.** Read at the same time as long-term and current-arc.md.

## File naming

`feedback_<short-name>.md` — snake_case, descriptive of the rule. The frontmatter `name:` field is the canonical title.

## When to write a feedback file

When Ahmed gives a correction OR confirms a non-obvious approach worked. Don't only save corrections — save validations too. Both shape future behaviour.

Include in the body:

- The rule itself (one sentence in bold)
- **Why:** the reason Ahmed gave (often a past incident or strong preference)
- **How to apply:** when/where this rule kicks in, including edge cases

Knowing *why* lets future-Claude judge edge cases instead of blindly following the rule.

## Companion: weekly consolidation

The `/consolidate-week` skill (fired Mondays per a feedback rule that lives here) reads short-term entries and proposes feedback-related moves: promotions, condensations, archivals. Ahmed decides; results recorded in the week's `consolidation.md`.

Without this loop, feedback would accumulate without resolution. Consolidation is what keeps the layer alive instead of frozen.
