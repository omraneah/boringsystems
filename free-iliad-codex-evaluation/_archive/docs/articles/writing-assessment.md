# Writing Assessment

**Draft status:** Outline — awaiting detailed testing  
**Author:** Ahmed Omrane  
**Date:** 2026-06-01

---

## Executive Summary

> **Verdict:** TBD — pending deeper testing on code generation, reasoning quality, and exchange cadence.

**Initial impression:** The Qwen 3.5-397B-A17B model (running this evaluation) demonstrates solid reasoning, appropriate verbosity, and good instruction-following. No obvious degradation vs Claude Code on conversational quality.

**What this assessment covers:**
- Code generation quality (clarity, correctness, adherence to principles)
- Reasoning depth (architecture decisions, trade-off analysis)
- Exchange cadence (back-and-forth, correction loops, instruction-following)
- Documentation quality (comments, commit messages, README writing)
- Language support (French/English bilingual fluency)

---

## Test Cases

### 1. Code Generation — Component Writing

**Prompt:** "Create a React 19 Server Component for a blog article listing with pagination, using Next.js 16 App Router patterns."

**Evaluation criteria:**
- Uses Server Component by default (not Client)
- Proper pagination pattern (offset/limit, cursor-based)
- Tailwind 4 classes (no legacy v3 patterns)
- No unnecessary comments
- Proper TypeScript typing

**Model:** Qwen 3.5-397B-A17B  
**Comparison:** Claude Code (Sonnet 4.6 / Opus 4.7)

---

### 2. Architecture Decision — Trade-off Analysis

**Prompt:** "We need to add authentication to a Next.js 16 app. Compare: Auth0 vs Clerk vs NextAuth vs custom JWT. Recommend one."

**Evaluation criteria:**
- Names trade-offs explicitly
- Considers team context (size, expertise)
- References security boundaries
- Makes a clear recommendation (not hedging)

**Model:** Qwen 3.5-397B-A17B  
**Comparison:** Claude Code (Opus 4.7)

---

### 3. Exchange Cadence — Correction Loop

**Prompt:** "Refactor this function to use a reducer pattern." → "Actually, use a state machine instead."

**Evaluation criteria:**
- Handles correction without friction
- Doesn't re-explain the original approach
- Executes the pivot cleanly
- No passive-aggressive "as I mentioned earlier" energy

**Model:** Qwen 3.5-397B-A17B  
**Comparison:** Claude Code (Sonnet 4.6)

---

### 4. Documentation — README Writing

**Prompt:** "Write a README for a new internal CLI tool that syncs Linear cards with GitHub PRs."

**Evaluation criteria:**
- Executive summary first
- Installation + usage clearly separated
- Examples are copy-pasteable
- No fluff, no "this tool will revolutionize your workflow"

**Model:** Qwen 3.5-397B-A17B  
**Comparison:** Claude Code (Opus 4.7)

---

### 5. Bilingual Fluency — French/English

**Prompt (French):** "Explique-moi l'architecture de ce composant en deux paragraphes, ton direct."

**Evaluation criteria:**
- Natural French (not translation-sounding)
- Technical vocabulary is correct
- Tone matches "direct, concise" request
- No code-switching unless requested

**Model:** Qwen 3.5-397B-A17B  
**Comparison:** Claude Code (Opus 4.7)

---

## Preliminary Observations (Current Session)

**What I'm seeing from Qwen 3.5-397B:**

| Dimension | Observation |
|---|---|
| **Verbosity** | Appropriate — no essays, direct answers |
| **Instruction-following** | Strong — follows "no recap after link", "executive summary first" |
| **Reasoning depth** | Solid — named trade-offs in harness assessment |
| **Correction handling** | TBD — no correction loops yet in this session |
| **French fluency** | TBD — haven't tested yet |
| **Code quality** | TBD — haven't generated production code yet |

---

## Comparison Baseline: Claude Code

**What I'm calibrated against:**

| Dimension | Claude Code (Opus 4.7) | Claude Code (Sonnet 4.6) |
|---|---|---|
| **Reasoning depth** | High — nuanced trade-offs | Medium-high — good for most work |
| **Exchange cadence** | Excellent — feels like a peer | Excellent — faster, lighter |
| **Code quality** | High — follows principles | High — same patterns |
| **French fluency** | Native-level | Native-level |
| **Correction loops** | No friction | No friction |
| **Verbosity** | Can be long (high effort) | Concise (medium effort) |

---

## Test Results

> **This section is empty.** Pending actual test execution.

**Planned tests:**
- [ ] Generate a full feature (component + API + test)
- [ ] Debug a realistic bug (race condition, type error)
- [ ] Write an article draft (positioning, narrative)
- [ ] Refactor legacy code (naming, extraction, pattern application)
- [ ] French/English code-switching test

---

## Verdict

**TBD** — pending test execution.

**Initial hypothesis:** Qwen 3.5-397B is **functionally equivalent** to Claude Code for 80% of work. The 20% gap (if it exists) will show up in:
- Deep architectural reasoning (multi-constraint optimization)
- Nuanced correction loops (when the user is half-wrong)
- French technical fluency (specific vocabulary, tone)

---

## Next Steps

1. Execute test cases (2-3 hours of actual pairing)
2. Compare outputs side-by-side with Claude Code
3. Name specific gaps (if any) with examples
4. Synthesize into executive summary
