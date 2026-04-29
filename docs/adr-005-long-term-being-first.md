# ADR-005 — Long-term Tier Holds Being Only (Being → Doing → Having)

**Status:** Accepted
**Date:** 2026-04-29
**Context:** workspace-level
**Refines:** ADR-004 (Tiered Memory Architecture)

## Context

ADR-004 established the three-tier memory architecture (long / medium / short) and named long-term as "identity profile, distilled identity-constitution content. North star." It did not specify the philosophy by which long-term content earns its place.

After ~24 hours of operation, an audit pass on 2026-04-29 found that ~70% of `long-term/` was operational discipline that had drifted up. Specifically:

- `Inner-Game_Identity-Constitution-and-Exit-Doctrine.md` — exit triggers, walking modes, distilled diagnostic dimensions. Operational, not constitutional.
- `Inner-Game_State-and-Guardrails-OS.md` — morning/midday/evening loops, boundary protocols, correction sequences, integration loops, field signals. Operational discipline.
- `Work-Hygiene-Doctrine.md` — work-mode rules. Operational.
- `user_profile.md` — mixed BEING (sovereign explorer, depth-oriented) + HAVING (CTO-equivalent scope) + transition context (3 years at Enakl, 2026 orientation, TypeScript stack).
- `Meta-Identity-Constitution.md` §6 — Recovery Signals, explicitly self-flagged as "expires when baseline is restored."

ADR-004's test for long-term — *"Would this still be true if I woke up in a different country with a different role?"* — was passing too liberally. It excluded title-based content but admitted operational discipline that's tied to the current chapter rather than constitutional.

The state had three real costs:

1. **The north star wasn't visible.** Identity-tier content was buried under operational discipline of similar register and length. The "what am I being" question had no canonical home.
2. **Operational drift up was uncorrected.** Without a sharper boundary, doctrine docs that started in medium-term aged into long-term by accident of placement.
3. **No felt-resonance test.** ADR-004's test was logical, not felt. A document could pass the test and still leave the operator cold — which meant the architecture didn't enforce that long-term content actually anchors.

The trigger to address this came from the operator: an explicit ask to "make sure that the long-term is really pointing to four three five years in the future... that's the only way how it can become a proper and solid North Star."

## Decision

The long-term tier holds **being only**, under the philosophy:

> **Being → Doing → Having.** Always start from being. Never start from having. The being attracts the rest.

### What long-term contains

Three documents, hierarchical:

| File | Role | Test |
|---|---|---|
| `long-term/I-AM.md` | Centerpiece. Canonical being-statements with whys, 3–5 year convergence, anti-beings, stable preferences, kindness ≠ niceness, philosophy. | Each section passes the felt-resonance test (smile / relief / no resistance vs. resistance / scarcity / closeness). |
| `long-term/inner-game/Meta-Identity-Constitution.md` | Depth-expansion of the I AM. Long-form articulation of the immovable core, in-motion strong defaults, conscious trajectory, blind spots, upgrades-in-progress. | Articulates *why* each I AM being is what it is. |
| `long-term/inner-game/Trait-Architecture.md` | Descriptive read on the wiring underneath the I AM. Trait cluster (where 2+ SD), founder-archetype mismatch, wiring vs. trauma-adaptation, AI-leverage composition, psychological type. | Describes the architecture the being expresses through. Not declarative. |

### What long-term does NOT contain

- Operational discipline (state regulation, boundary protocols, work hygiene, exit triggers, recovery markers) → `medium-term/operational-doctrine/`
- Current-state context (capability profile, transition phase, market specifics, stack) → `medium-term/current-context.md`
- Behavioural rules → `medium-term/feedback/`
- Strategy / positioning / market doctrine → `medium-term/market/`
- Anything tied to the current chapter (notice period, Enakl extraction, 2026-specific anchors)

### Three governing rules

**Rule 1 — Felt-resonance test.** Long-term content must produce smile / relief / no resistance when read from a stable baseline. If it produces resistance, scarcity, or closeness, either the wording is off or the content doesn't belong in long-term. The felt test sits above the logical test.

**Rule 2 — No rejection content.** Long-term documents are silent on what they're NOT. No "REJECTED" sections, no defensive listings of hallucinated framings, no anti-pattern enumerations. Rejection content carries the labels it claims to reject and creates surface area for drift back.

**Rule 3 — Descriptive over reactive.** Long-term content describes the being and its architecture. It does not react to specific external events, agent-produced framings, or current-chapter shape. If a section reads as a response to a recent thing, it's medium-term or short-term content.

### Reading order

`I-AM.md` (centerpiece) → `Trait-Architecture.md` (wiring underneath) → `Meta-Identity-Constitution.md` (depth-expansion). The first two are 80% of the load.

### Tier boundary signal

When asked "where does this go?" — apply the test:

> *Is this a being-statement (I AM <X>) or a description of the wiring the being expresses through?*
> - Yes → long-term.
> - No, but it's load-bearing operating discipline → medium-term/operational-doctrine/.
> - No, it's about the current chapter / state / context → medium-term/current-context.md or short-term.
> - No, it's a behavioural rule → medium-term/feedback/.

## Rationale

**Why Being → Doing → Having.** This is the operator's stated philosophy, made operational at the architecture level. The being is the attractor — health, wealth, relationships, creative output flow from the being, not the reverse. Starting from having ("I want to have X") or doing ("I should do Y") generates striving and drift. Starting from being ("I am X") generates emergence. The long-term tier holds the being so the architecture pulls in the same direction as the operator's life philosophy.

**Why three documents, not one.** A single document conflates three different shapes: declarative being-statements (terse, rhythmic, felt), depth-articulation of why each being is what it is (longer, philosophical), and descriptive read on the wiring (factual, multi-lens). Each shape wants different reading register. Three documents with hierarchical relationships keep each shape intact.

**Why the felt-resonance test sits above the logical test.** ADR-004's "still-true-in-a-different-country" test is logical and admits operational content that's logically context-independent but doesn't actually anchor. The felt test is harder to game and matches what long-term is for: an emotional-energetic anchor, not just a fact archive. Long-term is read from felt-baseline; if it doesn't produce relief, it's not load-bearing.

**Why no rejection content.** Tested in this session: a draft Trait-Architecture initially carried a "REJECTED — REJECTED — REJECTED" section enumerating hallucinated labels (HPI E2, etc.) to prevent drift. The operator surfaced this as wrong: long-term should be silent on hallucinations, not preserve them as anti-patterns. The principle is that rejection content carries the labels it rejects — listing "NOT-X" creates surface area for drift back to X. Long-term is level-headed, not defensive.

**Why operational discipline relocates to medium-term/operational-doctrine/ and not its own tier.** Three tiers (long / medium / short) are the architecture from ADR-004; adding a fourth tier for operational discipline would dilute the existing structure. Operational discipline has a 6–18 month horizon (current chapter), which is exactly the medium-term decay rate. Sub-foldering inside medium-term keeps the tier count stable.

**Why current-context.md merges user_profile + user_strategic_context.** Both held current-state content (capability profile, transition phase, market specifics, stack) but lived at different tiers. Merging into a single medium-term doc removes the duplication and makes the current-state question one lookup instead of two.

**Why long-term carries no rejection of clinical labels.** A specific case of Rule 2. The 2026-04-28 dive surfaced that "HPI E2" was a hallucinated label and the autism leg of the upstream "2e/AuDHD" framing was the weakest. The corrective doesn't belong in long-term; the long-term is silent on labels it never accepted. The dive's findings live in `Trait-Architecture.md` as positive descriptions (the trait cluster, the founder-archetype mismatch frame, the AI-leverage composition) without listing what was rejected.

## Consequences

**Positive:**

- The north star is now visible. `I-AM.md` is the canonical center; everything else in long-term is its expansion.
- The "where does this go?" question has a clear answer (the tier-boundary signal).
- Operational drift up is structurally prevented — operational discipline now has a clear medium-term home (`operational-doctrine/`).
- Felt-resonance test enforces that long-term content actually anchors, not just passes a logical filter.
- Reading order matches load-bearingness — operator hits the centerpiece first.
- No rejection content keeps long-term level-headed and slim.
- The being-attractor (Being → Doing → Having) is wired into the memory architecture, not just stated as a philosophy.

**Negative / costs:**

- The "being" boundary is a felt-check call, not a hard rule. Requires judgment per addition.
- Operational rules might drift back up if the rule isn't internalized. Mitigation: this ADR + the long-term/README.md + MEMORY.md routing all reinforce the rule.
- A new sub-folder (`medium-term/operational-doctrine/`) was added, modestly increasing tier surface area.
- Some content that was felt-stable for years (Work Hygiene Doctrine, State and Guardrails OS) had to relocate — felt like demotion even though it was a correction. Operator needs to internalize that medium-term placement is not a quality judgment, just a horizon judgment.
- The merge of `user_profile.md` + `user_strategic_context.md` lost the file-level granularity those served — but recovered it via clearer semantic boundaries (current-context vs. I AM).

**Calibration risks to monitor:**

- **Long-term grows past 4–5 files.** Audit the new content — is it really being, or is it operational drift?
- **A new long-term doc can't pass the "I AM <X>" or "describes the wiring" test.** It belongs in medium-term.
- **A long-term doc starts carrying defensive / reactive content.** Trim immediately. The Trait-Architecture trim during this session is the proof case.
- **The felt-resonance test gets skipped** ("just commit it, it's good enough") — re-anchor the practice.
- **Operational rules accumulate at long-term root** — the test is whether the rule survives a 5-year horizon felt-check.

## Alternatives considered

1. **Keep operational doctrine in long-term (the previous state).** Rejected: creates drift, dilutes the north star, allows operational rules to age into "constitutional" by placement rather than by passing any meaningful test. The audit found this had already happened in <24h after ADR-004 shipped.

2. **Single I-AM.md absorbing everything (one consolidated long-term doc).** Rejected: conflates three different shapes (declarative being / depth-articulation / descriptive wiring) into one register. Each shape wants different reading mode. Three hierarchically-related documents keep each register intact and produce a cleaner reading order.

3. **New top-level tier "constitutional" separate from long-term.** Rejected: redundant with long-term-as-already-defined; adds tier surface area without adding clarity. Long-term already means constitutional in ADR-004; this ADR sharpens what counts as constitutional rather than introducing a new container.

4. **Move all current-state content to short-term.** Rejected: current-context (capability profile, transition phase, market specifics) spans 1–6 months, which is exactly medium-term decay rate. Short-term is for episodic daily entries with a 4-week active window.

5. **Keep `user_profile.md` in long-term as a stripped-down BEING-only file.** Rejected: would have duplicated I-AM.md's role. The BEING content from user_profile (sovereign explorer, depth-oriented) is already absorbed into I-AM.md; the rest is current-state.

6. **Use a frontmatter `tier_horizon` field on each file instead of folder placement.** Rejected: folder structure is the routing primitive. A frontmatter field would be ignored by grep-based routing and add a layer of indirection that doesn't earn its place.

7. **Allow rejection content in long-term as a "what to refuse drifting toward" anchor.** Rejected after this session's stress test: rejection content carries the labels it rejects. The Anti-beings list in I-AM.md is the right shape — it states refusals positively ("NOT scarce" is a stance, not a reaction to a specific past event) without enumerating hallucinated framings.

## Provenance

- Triggered: 2026-04-29 session, ~24 hours after ADR-004's three-tier architecture shipped. Operator audit found ~70% of long-term was operational discipline drifted up.
- Operator-initiated: Ahmed surfaced the "make long-term really point to 3–5 years out" concern and the Being → Doing → Having philosophy as the governing principle.
- Implementation: PR #44 on branch `omraneah/long-term-tier-being-first`. Four commits: I AM restructure → Trait-Architecture initial → Trait-Architecture trim (rejection content removed) → INTJ + cohesiveness fixes.
- Felt-checked twice during the session: I-AM draft (rendered in Marky from `tmp/i-am-draft.md`) and Trait-Architecture (after the rejection-content trim).
- Codified in: `memory/long-term/I-AM.md`, `memory/long-term/inner-game/Meta-Identity-Constitution.md`, `memory/long-term/inner-game/Trait-Architecture.md`, `memory/long-term/README.md`, `memory/MEMORY.md`, `memory/medium-term/README.md`, this ADR.
- Relocated content: `medium-term/operational-doctrine/` (4 files, with origin pointers) + `medium-term/current-context.md` (merged from `long-term/user_profile.md` + `medium-term/user_strategic_context.md`).

## Revisit triggers

Re-open this ADR if:

- Long-term grows past 4–5 files (audit: is the new content really being?).
- "Where does this go?" question becomes ambiguous repeatedly across sessions (the tier-boundary signal isn't sharp enough).
- Operational rules drift back up to long-term despite the rule (the rule isn't enforced; consider stronger mechanism).
- The being layer crystallizes further (e.g., conscious upgrades complete, new beings emerge) and the I-AM document needs evolution beyond the current shape.
- A new identity-tier framework is needed (e.g., I-AM-AS-BUILDER, I-AM-AS-PARTNER) — re-derive whether the structural template generalizes.
- Felt-resonance test gets persistently skipped — the architecture has lost its anchoring property; revisit the philosophy.
- The operator's life philosophy shifts away from Being → Doing → Having — the architecture should follow the operator, not constrain them.
