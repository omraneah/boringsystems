# codeX — Methodology & Findings

External expert assessment · Ahmed Omrane · 2026-06-01 · the detailed companion to `executive-summary.md`

---

## Context

codeX is Iliad's internal LLM coding agent, built in-house (DataX / AI-tooling) and served on Scaleway. The variant I used is the **CLI, running the Qwen model**. It also ships as an IDE plugin, which I did not test.

I exercised it against my own working environment. You receive these files, not access to that environment, so here is what it contains — the deliberate complexity is the point, because it's a realistic, demanding test of whether the tool can pick up context and do useful work:

- **Tiered memory** — long / medium / short horizons, with weekly consolidation.
- **A custom harness** — codified rules, skills, and enforcement around the agents.
- **An agent-agnostic architecture** — one setup that works across agents, with separate configs for Claude Code and Codex.
- **A live website** — my own Astro blog, [boringsystems.app](https://boringsystems.app) *(public)*.
- **Real project code**, and my **starter-pack architectural documents** — [cross-stack-architecture-starter-pack](https://github.com/omraneah/cross-stack-architecture-starter-pack) *(public)*.
- Plus go-to-market material and the other day-to-day work I keep here.

The website and the starter pack are public; everything else in the environment is private.

## Problem

When codeX was rolled out internally, adoption didn't take the way it was hoped — that's the signal I was given. Building this capability in-house is the right kind of bet, and I came in to use it, explore it, and give an honest expert-user read on where it stands and where it should go.

## Method

I didn't run a head-to-head. I **used codeX inside my own setup** and exercised it across the use cases I actually run. I set the context up, made sure it was read properly, and then let the model navigate and produce the work itself rather than hand-holding it — so the output reflects the tool's own capability, not my steering.

Three use cases, matching the three deliverables codeX authored (in `codex-assessment/`):

1. **Harness & context** — how well it picks up the workspace, understands the context, helps, and collaborates.
2. **Writing an article** — in the live Astro project.
3. **Working on code** — a real change.

This is a **qualitative, intuition-based read — not a quantified benchmark.** A quantified version would need a managed internal setup with a human baseline (for example, an agent vs a senior engineer on a known refactor, scored against the human result); that's beyond this exercise.

### How I worked on it (three sessions)

1. **~1 hour** — set up the config and explored the CLI to get a feel for it, comparing it intuitively against what I'm used to with Claude Code.
2. **~2–3 hours** — went deeper: worked as if the CLI were my primary tool instead of Claude Code, built a real understanding, and prepared the methodology — how I'd test it and run my own workflows (across Claude Code and codeX) to produce something useful to share.
3. **~2–3 hours** — finished the remaining use cases and wrapped up.

I was mostly assessing, so I did not push every use case to its final outcome.

## How to read the findings

For each use case, **read codeX's own file first, then my take.** Those files are what the model produced in a normal working session — the same way I work day to day: I make sure my context is read properly and I let the model do the navigating and the output, so the work is its, not mine.

## Findings

### 1. codeX on the harness

codeX picked up a deliberately complex workspace — modules, skills, agents, harness wiring, MCP connectors, permissions — with a genuinely good grasp, and could work within it: thorough guidance, sensible use of web search, and concrete ideas for making the harness usable even without its native triggers. Solid enough to use and build on. It did drift into noisy territory — time estimates, a few rabbit holes — so the output needs a double-check, but as a first read, and as a likely-solid application once the harness is prepared, it's strong. *(codeX's output: `codex-assessment/harness-assessment.md`.)*

### 2. codeX on an article

In progress. Run as a one-shot, head-to-head test — the same agent-agnostic prompt given to a Claude Code agent and to codeX, each in its own worktree, both deployed as separate Vercel previews. *(Shared prompt: `article-head-to-head-prompt.md` · codeX's output: `codex-assessment/writing-assessment.md`.)*

### 3. codeX on code

In progress / time-permitting. *(codeX's output: `codex-assessment/code-assessment.md`.)*

## Learnings

- It's not the tool; it's the operating system around it — context, governance, routing.
- The harness is the compounding, model-portable asset; the model itself churns.
- The cheap-vs-strong-model routing boundary is invisible mid-task, so mis-routing — not the engine — is the quiet adoption-killer.

## Next steps

- Finish use cases 2–3 within the window.
- Build standardized, internally-managed evaluations (with a human baseline) so the next assessment is quantifiable rather than experiential.

## How this was produced

The executive summary and this document were produced with **Claude Code** — my choice, because that's where I hold this context most fully. The three use-case deliverables were produced with **codeX**, using my own current flow. **Nothing here was written by hand** — all of it is AI-produced, steered by me.
