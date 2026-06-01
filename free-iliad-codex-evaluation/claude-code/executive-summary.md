# codeX — Evaluation & Recommendations

**External expert-user assessment** · Ahmed Omrane · 2026-06-01 · prepared for the Free / Iliad team

---

## Context

Free gave me a codeX access token and a setup guide to connect the tool to an IDE or CLI. codeX is Iliad's internal LLM coding agent, built in-house by the DataX / AI-tooling team and served on Scaleway. The brief, as framed: *the product is meant to be improved, and an outside view — as both a user and a technical expert — is what's useful; the assessment is my analysis and recommendations*, debriefed with the LLM team or with engineering leadership.

So this is an evaluation-and-direction exercise, not a coding exam. I treated it that way.

## Scope — what I tested, and what I deliberately did not

- **Tested:** the **CLI** surface, as an expert user, over a focused hands-on window.
- **Not tested:** the IDE plugin and the alternate (Mistral) model. The plugin in particular may be the surface most engineers actually use day to day.

This is a first, honest read calibrated to what I exercised — not an ultimate verdict on the platform. Where I have signal I'll say so plainly; where I don't, I'll say that too.

## Method — comparative, with the harness held constant

The evaluation is **comparative, not absolute**. I ran the same work through **codeX** and through **Claude Code** (my daily reference tool), with **both loaded into my own engineering harness** — an indexed architecture corpus, shared rules, and reusable skills. Holding the harness constant isolates the variable that matters: any difference reflects the *engine*, not the scaffolding around it.

Three evaluation areas, in increasing demand on the tool:

1. **General agentic collaboration** — codeX as an everyday operator: reasoning, discussion, drafting files and code. *Is it a credible thinking-and-working partner?*
2. **Developer workflow under a governed harness** — authoring a real article inside a live Astro project, governed by my rules and skills. *Does it hold up inside a sophisticated, governed workflow?*
3. **A real engineering task — head-to-head** *(time-permitting)* — a concrete code change executed by codeX and by Claude Code on the same harness. *Code generation under load.* This is the most expensive area to run well; I may cut it rather than do it shallowly, and I'll flag that openly.

**Authorship is part of the method.** This executive summary was written by **Claude Code**. Each per-area assessment was written by **codeX itself**, on the same task. Same work, two engines, in their own words — so the comparison is something you can read directly, not just take on my word.

---

## Headline

On the surface I tested, **codeX is a credible tool — the interaction quality holds up against the frontier tools I use daily.** The open question that gates any rollout decision is sustained code generation under load, which is exactly what area 3 is built to probe. But nothing I've seen so far points to the *tool* as the reason adoption has been hard. The harder, more valuable problem is the operating system around it — context, governance, and routing — which is an organizational build, not a model choice.

## What this points to (the recommendation)

1. **Don't pick a model — build the layer that compounds.** The durable advantage is not which model is hosted (models churn); it's the harness: indexed project context, shared rules, a small set of high-leverage skills (e.g. an architectural-review skill that runs against your own decision records). That layer is portable across models and is where adoption actually sticks.

2. **Plan for two tiers, deliberately.** A self-hosted tool like codeX is the right **substrate** for high-volume work at near-zero marginal cost; a frontier tool (Claude Code, Codex) is the right **burst capacity** for the judgment-dense work that carries most of the value. The catch is **routing**: the boundary between "routine" and "judgment-dense" is invisible mid-task, so it can't live in a document — it has to be a tool-level default (escalate to the stronger model on ambiguity or high blast-radius). For a telecom, data residency is a second, independent reason the self-hosted tier earns its place.

3. **Prove it on one team, with a metric.** Adoption is won team-by-team — the lead gates the team. The cheapest honest next step: one willing team, one quarter, one indexed-context skill plus a routing default, instrumented (weekly-active usage, rework rate). A go/no-go gate at the end. If usage compounds, it was the operating system; if it flatlines, the constraint is the tool — and that's a test worth running rather than a debate worth having.

## Limits of this read

A focused CLI session is enough to judge interaction quality; it is not enough to judge production code generation, average-engineer experience, or the IDE surface. Treat the recommendation as a direction the evidence points to, to be confirmed by the head-to-head in area 3 — not a closed verdict.

## Method note

This report was produced with AI — Claude Code for this summary, codeX for the assessments it authored — which is the point: it is a working demonstration of the engineer-steers-the-agent workflow the role is about. The judgment, the experimental design, and the thesis are mine; the agents compressed the production.
