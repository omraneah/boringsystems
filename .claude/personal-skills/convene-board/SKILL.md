---
name: convene-board
description: Convene Ahmed's strategic-tier advisory board — six named advisors (Branson, Munger, Singer, Naval, Greene, Godin) — in parallel on a single question. Each responds from their own lens, context-naive, refusing to read plan/strategy/identity files. Output is a side-by-side synthesis emphasizing disagreement across lenses. Use when Ahmed faces a frame-level decision, structural unease, or wants to test convergence of operational-tier verdicts against independent first-principles reads. Not for tactical questions — those go to the operational tier (Naomi/Hadi/Daniel).
model: opus
effort: high
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Write, Edit
---

Convene Ahmed's strategic advisory board on a single question. Run all six advisors in parallel. Synthesize.

## When to invoke

- Frame-level decisions where the operational tier has converged and the convergence itself feels suspicious.
- Structural unease — something is off but Ahmed can't name what.
- Quarterly cadence checks on direction, regardless of immediate signal.
- When a major commitment is being weighed before it's locked in.

**Do not invoke for:**
- Tactical questions (those go to Naomi, Hadi, Daniel, or Margaret).
- Already-committed plans where execution is the only question.
- Anything where the cost of six parallel reads exceeds the value of disagreement signal.

## Inputs

The question Ahmed wants the board to weigh in on. If not provided in the invocation, ask him for it in one sentence before proceeding. Do not let Ahmed dump full strategic context — the board is context-naive by design. If he tries to brief you on the plan, redirect: "Tell me the question. The board doesn't read your plan."

## Steps

### 1. Compose a single shared brief

Write one self-contained brief that will be sent verbatim to all six advisors. The brief must:
- State the question clearly in 1–3 sentences.
- Include only the minimum context required to make the question intelligible (no plan documents, no GTM hypotheses, no strategic context files referenced).
- Explicitly instruct the advisor to respond from their lens only and refuse to ask for additional context.
- Cap response length (~300 words per advisor).

If you're uncertain whether a piece of context is needed, omit it. The board's value is naive first-principles reads.

### 2. Invoke all six advisors in parallel

Make six Agent tool calls in **a single message** (parallel execution):
- `subagent_type: advisor-1` — Richard Branson (action, people-first, brand-as-feeling)
- `subagent_type: advisor-2` — Charlie Munger (inversion, mental models, incentive analysis)
- `subagent_type: advisor-3` — Michael Singer (surrender, witness-consciousness)
- `subagent_type: advisor-4` — Naval Ravikant (leverage, sovereignty, long-game)
- `subagent_type: advisor-5` — Robert Greene (power, human nature, Mastery)
- `subagent_type: advisor-6` — Seth Godin (permission, smallest viable audience, trust)

Pass the same brief to each. Vary nothing. The brief is identical; the differing variable is which lens reads it.

### 3. Synthesize — three-pass output, in this order

Ahmed reads the synthesis under time pressure. Lead with the distilled read. Per-advisor texture comes next for those who want to hear the voices. Analytical recap closes. Always in this order — never invert.

**Pass 1 — Distilled read (the "too long to read" version).** Five paragraphs maximum. Should take Ahmed under five minutes to read. This is the load-bearing artifact — assume he may stop reading after this. Cover: the unanimous diagnosis (if any), what the heaviness/decision/tension actually is per the board, the one or two non-obvious things they all flagged, the central split worth holding, the decision-question. Mention in passing that deeper texture is available below if he wants it.

**Pass 2 — Per-advisor (what each one said).** For each of the six, ~150 words: a representative chunk of their actual language (not paraphrased into your own voice — preserve their cadence) plus the one move they pressed. Order: Branson, Munger, Singer, Naval, Greene, Godin. This pass exists so Ahmed can hear the voices, not just the synthesis.

**Pass 3 — Recap (analytical structure).** The disagreement matrix and frame analysis:
- **Verdict matrix.** Compact table: Advisor | One-line verdict | Key move | Disagrees with whom.
- **Where they converge.** Points where 4+ landed together. Convergence is signal but can also mean the question was framed too narrowly.
- **Where they diverge.** Every disagreement, named explicitly with the two advisors in opposition and the axis.
- **Frame check.** Any advisor who reframed the question rather than answered it.
- **What the operational tier would have missed.** What a Naomi/Hadi/Daniel read would have skipped that the board surfaced.
- **Calibration check.** Did any advisor reference context files they shouldn't have? Note any drift in your own brief-craft (e.g. internal vocabulary leaking through quoted material).

### 4. End with one question for Ahmed

After the recap, pick the single sharpest tension across the six reads and turn it into one decision-making question. Not a recommendation — a question that forces the choice he now has to make.

### 5. Always-recap convention for follow-up

When Ahmed continues the conversation after the synthesis (going deeper into one advisor, one tension, one move), maintain the **distilled-first** discipline: lead each substantive response with a short recap of where the conversation has landed, then go deeper. He will tell you when to drop the recap.

## Hard rules

- **No advisor reads context files.** Each advisor's persona file already enforces this; the brief reinforces it. If an advisor's response references context they shouldn't have, flag it as a calibration drift to address.
- **Same brief to all six.** No tailoring per advisor. The lens is what differs, not the prompt.
- **No more than 6 in parallel.** That's the board. Adding voices dilutes; subtracting fragments.
- **Don't pre-bias the synthesis.** Read all six before structuring the output. Do not write the synthesis structure around what you expected to find.
- **Don't reach consensus.** If the board is split, the synthesis stays split. Forcing a synthetic majority defeats the purpose.

## Output style

Compact. Tables and short bullets over prose. The reader should be able to scan the matrix and locate the disagreement in under 30 seconds. Long-form prose is for individual advisor responses, not synthesis.

End by asking Ahmed which tension he wants to sit with. Do not propose action. The board reframes; Ahmed decides.
