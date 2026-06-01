# codeX — Methodology & Findings

External expert assessment · Ahmed Omrane · 2026-06-01 · detail behind `executive-summary.md`

---

## Context

codeX is Iliad's internal LLM coding agent — built in-house (DataX / AI-tooling), served on Scaleway, available as a CLI and an IDE plugin. I evaluated the **CLI**.

## Problem

Evaluating a coding agent honestly is hard in a short window and without a quantitative baseline. Two questions worth answering well:
1. Is the engine credible for real work?
2. Is the binding constraint the **tool**, or the **operating system around it** — context, governance, routing?

## Methodology

The principle: **compare like-for-like against something I've already mastered, hold it constant, and read the delta.**

- **Comparative.** The same work run through codeX and through a frontier reference tool I use daily (Claude Code).
- **Harness held constant.** Both run inside my own engineering harness — indexed architecture context, shared rules, reusable skills — so any difference reflects the *engine*, not the scaffolding.
- **Multiple use cases, pushed toward their limits**, across three areas of increasing demand:
  1. **General agentic collaboration** *(current focus)* — reasoning, discussion, drafting files and code.
  2. **Developer workflow under the harness** — authoring real articles in a live Astro project; ~two articles seeded from the same inputs to both tools.
  3. **A real engineering task, head-to-head** *(time-permitting)* — likely a modest change, not a deep one.
- **Quantify the delta where possible**; name it qualitatively where not.

## Constraints on this read (stated plainly)

- **Time-boxed: ~4 hours total.** Some areas won't be exercised deeply or fully — the engineering task in particular will be light.
- **No human baseline.** The rigorous version, which I'd build with more time, is a standardized eval: take a real codebase with a complex refactor already completed by a senior engineer (before/after), ask the agent to do the same task, and score it **against the human result**. The human is the benchmark. I don't have that asset here.
- **So this is intuition- and experience-based, not a quantified evaluation — not at this stage.** That's a deliberate honest limit, not a gap I'm hiding.

## Findings (running)

### Assessment 1 — codeX on the harness

I pointed codeX at a deliberately complex workspace — modules, skills, agents/personas, layered harness wiring, MCP connectors, permissions — and asked it to make sense of it. It showed a genuinely good understanding and can clearly work within it: thorough guidance, sensible use of web search to fill gaps, and concrete suggestions for making the harness usable even without its native triggers/hooks. Solid work — something I'd personally use and build on.

The caveat: it drifted into noisy territory — estimating how long each improvement would take, chasing a few rabbit holes — so the output needs double-checking. But as a first read, and as a likely-solid application once the harness is properly prepared, it's genuinely strong. (codeX's own write-up: `../harness-assessment.md`.)

### Other areas

- **Article authoring under the harness, and a real engineering task:** in progress / time-permitting.
- **Framework-level read:** the tool cleared the bar I could test; the leverage is in the operating system around it — context, governance, routing — not the model.

## Learnings

- **It's not the tool; it's the operating system around it.** Adoption and value live in context + governance + routing, which is an organizational build.
- **Routing is the hidden failure mode.** The cheap-vs-strong-model boundary is invisible mid-task; mis-routing (weak tool on the hard 20%) produces "AI doesn't work."
- **The harness is the compounding, model-portable asset** — worth more than the model choice, which churns.
- **Self-hosted trails the frontier** on hard reasoning, and "no per-token cost" ≠ free (fixed infra + ops + an owner).

## Next steps

- Finish areas 2–3 within the window; write up each head-to-head.
- **Recommended path:** build the harness/governance layer; plan two tiers (substrate + frontier burst) with tool-level routing; pilot one willing team for a quarter, instrumented, with a go/no-go gate.
- **Longer term:** build standardized, human-baseline evals so the next assessment is quantifiable rather than experiential.
