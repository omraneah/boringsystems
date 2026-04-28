# Feedback — Active Behavioural Rules

> Every behavioural rule lives here first. By design temporary — feedback is mid-horizon by nature: too active to be long-term invariant, too durable to be short-term episodic.
> Auto-loaded every session (both `stable/` and `in-flight/`). See `../../README.md` for full architecture.

## Two sub-folders

```
feedback/
├── README.md          ← this file
├── stable/            ← rules that have held across domains and time. Constitutional in flavour.
│                        Candidates for promotion to long-term doctrine, but not yet promoted.
└── in-flight/         ← rules tied to current workflow / specific tooling / recent corrections.
                         Genuinely evolving. Most likely to be condensed or archived.
```

The split is for **audit purposes**, not for differential auto-load behaviour. Both folders auto-load every session — discipline is unified. The distinction tells the operator at a glance which rules to interrogate first when doing a deliberate audit pass.

### `stable/`

A rule belongs here when it has held across multiple domains, multiple weeks, and feels constitutional in flavour even though its file shape is still feedback (not yet promoted into a doctrine file or into `META-PRINCIPLES.md`).

Examples of what `stable/` looks like in practice:
- Workspace invariants (laptop-agnostic, PR-creation discipline, MCP connector-only)
- Anti-patterns Claude must avoid (no recap after link, no premature mass replacement)
- Communication discipline that doesn't change (lane-change announcement, parallel-agent recap)
- Identity-rooted preferences that have been consistent (collaboration tone)

These are eligible for promotion to long-term during a deliberate audit pass (not weekly consolidation — different cognitive mode).

### `in-flight/`

A rule belongs here when it is tied to current workflow, specific tooling, or a recent correction whose long-term shape isn't clear yet.

Examples of what `in-flight/` looks like in practice:
- Rules tied to a specific skill that may change (e.g. consolidate-week trigger, divergence-check trigger)
- Workflow conventions for tooling that may be replaced (render-long-output, tmp-as-ram)
- Workspace conventions still being shaped (post-merge workflow, model effort matrix)
- Discipline patterns still being calibrated (brief approval gate, batch permission)

These are most likely to be **condensed** (multiple in-flight rules merged into a single stable principle) or **archived** (when no longer relevant).

## What feedback is

Feedback is the catch-all for rules Ahmed has surfaced but hasn't yet structured into a more durable form. *"Things I didn't structure yet that could be structured later."*

Each rule lives in its own file, frontmattered, with a `Why:` and `How to apply:` section so future-Claude can judge edge cases.

## Lifecycle

Feedback evolves on the fly in a feedback loop:

```
[Surfaced]      ← Ahmed gives the correction or validation
   ↓
[Codified]      ← Claude writes a feedback_*.md file in in-flight/, usually within the same turn
   ↓
[Held]          ← Auto-loaded every session, applied across work
   ↓
[Reviewed]      ← Weekly consolidation surfaces patterns; deliberate audits do larger restructuring
   ↓
[Resolved]      ← Promoted to long-term doctrine, condensed into a single principle, or archived
```

Resolution paths:

- **Promotion to long-term.** When a `stable/` rule has held across domains and time and become identity-shaped (vs operationally-shaped), it earns long-term status. Reframed as part of the constitution. Happens during deliberate audit passes, not weekly consolidation.
- **Condensation.** When multiple feedback files cover related ground (often visible across the `stable/` and `in-flight/` boundary), they merge into a single principle that captures the cluster. The originals get archived; the condensed version may stay in feedback or promote.
- **Archival.** When a rule is no longer relevant (the situation changed, the operator changed, the tooling changed), it moves to `_archive/` (or just gets removed if pre-merge). Healthy feedback culture is more about deletion than promotion.

## When to write a feedback file

When Ahmed gives a correction OR confirms a non-obvious approach worked. Don't only save corrections — save validations too. Both shape future behaviour.

Default destination: `in-flight/`. Only `stable/` if the rule is being captured because it is already known to be constitutional (rare — most rules earn `stable/` status over time, not on day one).

Include in the body:

- The rule itself (one sentence in bold)
- **Why:** the reason Ahmed gave (often a past incident or strong preference)
- **How to apply:** when/where this rule kicks in, including edge cases

Knowing *why* lets future-Claude judge edge cases instead of blindly following the rule.

## Auto-load

**Full content every session, both sub-folders.** Read at the same time as long-term and current-arc.md.

## File naming

`feedback_<short-name>.md` — snake_case, descriptive of the rule. The frontmatter `name:` field is the canonical title.

## Companion: weekly consolidation + deliberate audit

- **Weekly consolidation** (`/consolidate-week`, fired Mondays per a feedback rule that lives here) handles small deltas — surfacing drift candidates from the past week's daily entries, proposing minor moves.
- **Deliberate audit passes** (separate cognitive mode, separate session, often a Linear card) handle the bigger restructuring — promotion of `stable/` rules to long-term, condensation of clusters, garbage collection.

Without both loops, feedback would accumulate without resolution. The two work as a pair.
