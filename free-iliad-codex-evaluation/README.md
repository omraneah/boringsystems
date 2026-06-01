# codeX — Expert-User Evaluation

An outside expert-user read on codeX (Iliad's internal LLM coding agent — CLI, Qwen model), exercised inside a real, deliberately complex working environment.

## How to read this

1. **[`executive-summary.md`](executive-summary.md)** — start here: what's good, what to re-explore, what's shaky, and what I recommend.
2. **[`methodology-and-findings.md`](methodology-and-findings.md)** — the detail behind it: the environment, the method, the three work sessions, and the findings.
3. **[`codex-assessment/`](codex-assessment/)** — go deeper: codeX's own raw outputs, one per use case.
   - `harness-assessment.md` — picking up the harness & context.
   - `writing-assessment.md` — writing an article.
   - `code-assessment.md` — working on code.

## Who wrote what

- **`executive-summary.md` and `methodology-and-findings.md`** were produced with **Claude Code** — my choice, because that's where I hold this context most fully.
- **The `codex-assessment/` files** were produced with **codeX**, in my own working flow.
- Everything here is AI-produced and steered by me. **Nothing was written by hand.** The split is itself part of the evaluation: the same operator, two engines, on the same environment.

## The environment it was tested against

Tiered memory · a custom harness (rules, skills, enforcement) · an agent-agnostic architecture with separate Claude Code and Codex configs · a live Astro website ([boringsystems.app](https://boringsystems.app)) · real project code · starter-pack architectural documents ([cross-stack-architecture-starter-pack](https://github.com/omraneah/cross-stack-architecture-starter-pack)).

The website and the starter pack are public; the rest of the environment is private.
