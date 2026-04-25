---
name: convene-board
description: Convene Ahmed's strategic-tier advisory board — six named advisors (Branson, Munger, Singer, Naval, Greene, Godin) — in parallel on a single question. Each responds from their own lens, context-naive, refusing to read plan/strategy/identity files. Output is a side-by-side synthesis emphasizing disagreement across lenses. Use when Ahmed faces a frame-level decision, structural unease, or wants to test convergence of operational-tier verdicts against independent first-principles reads. Not for tactical questions — those go to the operational tier (Naomi/Hadi/Daniel).
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

### 3. Synthesize side-by-side

When all six return, produce the synthesis. Do not paraphrase each advisor's verdict in narrative form — that loses the comparison. Use this structure:

**Verdict matrix.** A compact table: Advisor | One-line verdict | Key move they recommend | Disagree with whom?

**Where they converge.** Name the points where 4+ advisors land in the same place. Convergence is signal but not always direction — it can also indicate the question itself was framed too narrowly.

**Where they diverge.** This is the point of the exercise. Surface every disagreement explicitly. Name which two advisors are in opposition and on what axis. Disagreement is the workshop where the actual insight lives.

**The frame check.** Did any advisor reframe the question itself rather than answer it as posed? If yes, surface that reframe — it's often the most valuable output.

**What the operational tier would have missed.** If this question would have been routed to Naomi/Hadi/Daniel, what would their context-loaded read have skipped that the board surfaced?

### 4. End with one question for Ahmed

Pick the single sharpest tension across the six reads and turn it into one decision-making question for Ahmed. Not a recommendation — a question that forces the choice he now has to make.

## Hard rules

- **No advisor reads context files.** Each advisor's persona file already enforces this; the brief reinforces it. If an advisor's response references context they shouldn't have, flag it as a calibration drift to address.
- **Same brief to all six.** No tailoring per advisor. The lens is what differs, not the prompt.
- **No more than 6 in parallel.** That's the board. Adding voices dilutes; subtracting fragments.
- **Don't pre-bias the synthesis.** Read all six before structuring the output. Do not write the synthesis structure around what you expected to find.
- **Don't reach consensus.** If the board is split, the synthesis stays split. Forcing a synthetic majority defeats the purpose.

## Output style

Compact. Tables and short bullets over prose. The reader should be able to scan the matrix and locate the disagreement in under 30 seconds. Long-form prose is for individual advisor responses, not synthesis.

End by asking Ahmed which tension he wants to sit with. Do not propose action. The board reframes; Ahmed decides.
