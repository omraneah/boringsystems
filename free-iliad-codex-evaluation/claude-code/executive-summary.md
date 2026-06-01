# Executive Summary — Evaluating the Internal Coding Agent

**Author:** Ahmed Omrane · **Date:** 2026-06-01 · **Scope:** the CLI agent only

> **The tool cleared the bar I could test; the binding constraint is the operating system around it, not the model.** In a focused expert session the CLI's interaction quality was competitive with the frontier tools. That is *not* a full verdict — sustained code-generation under load is untested, and it's the gating unknown before any rollout call. But nothing I saw suggests the model is why adoption stalled. The likelier constraint is governance, routing, and ownership — which is an org-design problem, and a solvable one.

---

## What I tested — and what I didn't

**Tested:** the internal **CLI agent** (built on the open-source `opencode` harness, self-hosted model), driven as an expert user for a focused session, compared against my daily tools — Claude Code (primary), Codex (periodic), Cursor (current team tool). I exercised **interaction quality**: reasoning, exchange cadence, instruction-following.

**Not tested (named blockers, not footnotes):**
- **Code-generation under load** — multi-file refactors, long-context coherence, agentic tool-loop reliability. This is the single most important input to an adoption decision and it is still open.
- **Average-engineer usage** — I steer models well; the relevant question is how it performs for a median engineer on a gnarly module.
- The self-hosted **Mistral** variant and the **IDE plugin** — and the plugin may be the surface most engineers would actually use, so the CLI may not be the adoption-relevant artifact.

A short expert session is enough to say "the interaction quality is real." It is not enough to say "the tool is good." I'm holding the verdict to the evidence.

---

## The thesis — where this should go

### 1. Run both — but as a costed cost-structure decision, not a slogan.
- A **self-hosted agent** trades near-zero *marginal* cost for a real *fixed* cost — GPU/inference infra, ops, and a harness owner. "No per-token cost" is not "free"; it's capex+opex traded for token spend.
- **Frontier provider tools** (Claude Code, Codex) are pure marginal cost — pay per use for the hard, judgment-dense work.
- The internal tool is the **substrate** (high-volume executor); frontier is **burst capacity** (the reasoning when it matters). **Below some monthly-usage threshold, dual-tier loses to single-tier frontier.** That break-even is the number to compute before committing — I haven't, and neither should anyone, without real usage data.

### 2. The hard part is routing — and it's a tool problem, not a doc.
Work splits on two independent axes — **task volume** and **judgment-density / blast-radius** (irreversibility, cross-cutting impact, novelty). A five-line auth or schema change can be the hardest decision of the week. So there is no single boundary to "route on," and the boundary is often invisible mid-task. A rule in a governance doc can't fix a real-time perception failure — docs are read once and ignored.

**The fix is a tool-level affordance:** default to the frontier model on ambiguity / high blast-radius / low confidence, and let the cheap tier own the genuinely routine. Mis-routing — cheap tool silently failing on the hard work, engineer concluding "AI doesn't work" — is a concrete, observable adoption-killer and a likely contributor to stalled adoption.

### 3. The durable value lives in the harness, not the model.
Models churn; the **operating system around the tool** compounds: project context indexed for every agent (e.g. an architecture-decision corpus plus a skill that runs an architectural review against it), shared rules, common skills and commands. It's portable across models and zero-marginal-cost to reuse.

**Honest constraint:** this layer is *harder* to make binding on the internal tool. The `opencode` harness has the day-to-day tools (skills, MCP, git-hooks) but lacks pre-action enforcement hooks (session-start, pre-tool) — so governance on it is **advisory, not enforced**, unless that enforcement layer is built. The governance story is therefore currently *stronger on the frontier side*. That gap is a scoped engineering item, not a wish.

### 4. Adoption is a sequenced bet with a kill-criterion — not a switch, not an excuse.
I won't diagnose why adoption stalled without usage telemetry. I'll state it as a falsifiable bet instead:

> If we add routing-on-ambiguity + one indexed-context skill to **one willing team** and instrument it, and weekly-active usage still flatlines in **4–6 weeks**, then the constraint is the tool/model and I'm wrong. If usage compounds, it was org-design.

Won at the **team** level first (the lead gates the team), then the individual. Pick the pilot lead deliberately — willing and resourced, because exploring a tool is a tax on engineer attention, not a free trial.

---

## Recommendation — make the first "yes" cheap and measurable

**Don't buy a tool; fund the operating system around one.** Minimal first increment:
- **~0.5 FTE owner, one quarter, one willing team.**
- Build **one** indexed-context skill (architectural review against an ADR corpus) + a **routing default** (escalate-to-frontier on ambiguity).
- **Success metric, set up front:** that team's weekly-active usage + a measured task-split (rework rate, review-comment density, % sessions completed).
- **Go/no-go gate** at quarter end before any wider rollout. A failed gate stops the program; it doesn't loop forever.

**If that investment isn't on the table:** keep the internal tool available for exploration, let individuals pair it with a frontier tool of their choice, and expect no compounding — without the operating system, the value stays on the table. Leadership owns that trade-off.

**For a telecom specifically:** the strongest standalone case for the self-hosted tool isn't cost — it's **data residency** (sensitive code never leaves the perimeter). Where that constraint binds, the internal tool wins outright regardless of the routing economics.

---

## What I'd challenge in my own read (open questions)

- The volume/value split is illustrative, not measured — needs validation against tagged real tasks.
- "Run both" adds cost and a switching tax. Worth it only above the break-even and only if the harness can span both tools (escalation = model-swap, not tool-swap). That's testable; I haven't tested it.
- I measured interaction quality, not code-gen under load (see `code-assessment.md`) — that probe could move the verdict.
- Hosting cost/throughput, current adoption numbers, and whether shared rules/context exist today are unknown to me and would sharpen everything.

## My personal verdict

For my own work I'd run it as the **high-volume executor under a frontier reasoner — not standalone.** That's the honest read, no hedge.

---

## Method note

Produced **with AI agents** — Claude Code and the internal tool itself — which is the point: a working demonstration of the engineer-steers-the-agent workflow. The thesis, sequencing, and judgment are mine; a second pass with Claude was used to *attack* the argument from a principal-engineer, market, and skeptical-leader lens before shipping — not just to draft it.
