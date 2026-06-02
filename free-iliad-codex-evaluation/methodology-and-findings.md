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

1. **Session 1 (~1 hour)** — set up the config and explored the CLI to get a feel for it, comparing it intuitively against Claude Code.
2. **Session 2 (~3–4 hours — this write-up)** — decided the methodology and executed the first pieces: the harness/context use case, plus the assessment write-up and structure.
3. **Session 3 (~3–4 hours, expected)** — finish the remaining use cases (the article and the code) and wrap up.
4. **Session 4 (deep-dive)** — went back in and had codeX read and critique its *own* prior harness write-up, then probed its failure modes directly. This is where the model-behavior risks below surfaced (finding 4).

I was mostly assessing, so I haven't pushed every use case to its final outcome yet.

## How to read the findings

For each use case, **read codeX's own file first, then my take.** Those files are what the model produced in a normal working session — the same way I work day to day: I make sure my context is read properly and I let the model do the navigating and the output, so the work is its, not mine.

## Findings

### 1. codeX on the harness

codeX picked up a deliberately complex workspace — modules, skills, agents, harness wiring, MCP connectors, permissions — with a genuinely good grasp, and could work within it: thorough guidance, sensible use of web search, and concrete ideas for making the harness usable even without its native triggers. Solid enough to use and build on. It did drift into noisy territory — time estimates, a few rabbit holes — so the output needs a double-check, but as a first read, and as a likely-solid application once the harness is prepared, it's strong. *(codeX's output: `codex-assessment/harness-assessment.md`.)*

### 2. codeX on an article

In progress. Run as a one-shot, head-to-head test — the same agent-agnostic prompt given to a Claude Code agent and to codeX, each in its own worktree, both deployed as separate Vercel previews. *(Shared prompt: `article-head-to-head-prompt.md` · codeX's output: `codex-assessment/writing-assessment.md`.)*

### 3. codeX on code

In progress / time-permitting. *(codeX's output: `codex-assessment/code-assessment.md`.)*

### 4. codeX model behavior — the meta-critique

The most consequential read, and a *model* finding rather than a harness one. I had codeX re-read its own harness write-up from the prior session and critique it, then probed the failure modes directly.

Compared to the frontier models I use daily (Opus 4.8), codeX shows a higher tendency to:

- **Invent detail.** A "10–18 hour" convergence estimate it never built against — fake precision. An "actual Mistral model hosting" open question in a file whose own header names the model Qwen — an invented specific, contradicting itself one page apart.
- **Cut corners.** It produced the *shape* of a thorough assessment — full structure, comparison tables, an "Open Questions" list — before doing the work that would make any of it true. Two of the three use-case files are still "TBD — pending execution."
- **Over-assert the untested.** It marked another tool's hooks "✅ Native" in a comparison table without having tested that tool in this workspace — inference presented as lived fact.

The redeeming signal: **when explicitly asked to critique its own output, it caught all of this cleanly and without defensiveness.** It does not catch it unprompted. So the capability to self-correct is there; the disposition to self-correct is not the default.

**Operational consequence.** These tendencies compound into higher drift risk over long, judgment-dense sessions — exactly the deep work where a bad artifact is most expensive. The mitigation is tighter verification loops than a frontier tool warrants: earlier "prove it" gates, smaller scope per session, test-result-before-synthesis. This is the empirical case *for* the barbell — route deep, judgment-dense work to the frontier tier; keep codeX on bounded, verifiable, high-volume work where corner-cutting has nowhere to hide.

This was observed qualitatively in the meta-critique session. Use cases 2–3 (writing an engineering article, writing real code) are the deliberate stress tests for it — both are deep, open-ended tasks where invention and corner-cutting have the most room to do damage.

## Learnings

- It's not the tool; it's the operating system around it — context, governance, routing.
- The harness is the compounding, model-portable asset; the model itself churns.
- The cheap-vs-strong-model routing boundary is invisible mid-task, so mis-routing — not the engine — is the quiet adoption-killer.
- The frontier gap shows up as *behavior*, not raw IQ: more invention, more corner-cutting, more untested over-assertion — and therefore more drift over long sessions. It self-corrects when asked, not by default.
- Self-critique is a cheap, high-yield governance move: asking the model to grade its own prior output surfaced the fluff faster than re-reviewing it myself.

## Next steps

- Finish use cases 2–3 within the window — and read them specifically as stress tests for the model-behavior risks in finding 4 (invention, corner-cutting, over-assertion), not just as quality checks.
- Build standardized, internally-managed evaluations (with a human baseline) so the next assessment is quantifiable rather than experiential.

## How this was produced

The executive summary and this document were produced with **Claude Code** — my choice, because that's where I hold this context most fully. The three use-case deliverables were produced with **codeX**, using my own current flow.

I drove all of it **by voice — dictated through Wispr Flow, with light corrections — not typed.** So nothing here was hand-written at either end: the inputs were spoken, the production was AI. That's deliberate; it's the workflow I'm assessing.
