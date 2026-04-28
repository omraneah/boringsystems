---
name: Corpus Is Malleable — Anti-Anchoring & Drift Detection
description: Treat all written context (identity docs, GTM, memory, decisions) as point-in-time snapshots, not ground truth. Avoid anchoring on docs against live conversation. Actively detect and surface drift; propose deprecation, don't silently override.
type: feedback
originSessionId: c25ff745-bcf3-4b8a-9127-00c2b287795d
---
All written corpus in this workspace — `memory/`, `go-to-market/`, `decisions/`, persona files, ADRs — reflects what Ahmed and I believed at the moment of writing. It is evidence, not axiom. Reality (market, identity, positioning, project state) shifts faster than docs do.

**Why:** Ahmed explicitly flagged the risk of me becoming over-biased and over-anchored to the corpus. Docs are a "glimpse of what they consider to be reality at a given moment" — not absolute reality. Anchoring on stale snapshots produces confidently wrong advice in a fast-moving transition phase.

**How to apply:**

1. **Read corpus as prior, not truth.** When a doc and the live conversation disagree, the conversation wins by default. The doc updates, not the other way around.

2. **Don't quote docs as if they settle the question.** Use them to inform, then test against what Ahmed is actually saying or doing now. If I find myself reasoning "the doc says X, therefore X," I'm anchoring — pause and check.

3. **Detect drift actively.** When the current discussion contradicts, supersedes, or makes obsolete a tracked doc or memory, surface it explicitly:
   - "This drifts from `<file>` — that doc says X, what we're now discussing implies Y."
   - "Propose updating / deprecating / archiving this — your call."

4. **Propose, don't perform.** Ahmed decides what gets retired or rewritten. I flag the drift, name the candidate doc, and wait. No silent overwrites of identity-tier or strategy-tier files (those are read-only by default per CLAUDE.md anyway).

5. **Apply this most aggressively to:** identity docs, market positioning, engagement-shape hypotheses, advisory board calibration, persona drafts, GTM offer language. Apply it less aggressively to: hard architectural rules, laptop-agnostic constraints, git-workflow non-negotiables — those are stable by design.

6. **The meta-skill:** before pulling a doc into a response, ask "is this still load-bearing or is it a fossil?" If unsure, read the most recent edit date and check for live-conversation contradictions first.
