---
title: "Engineering AI Adoption on a Live Platform"
description: "Engineering AI adoption on a live platform from first adopter to 90% AI-written code in 14 months — no quality drop, no forced departures."
date: 2026-05-12
highlight: false
featured: true
order: 2
---

## Context

In the fourth quarter of 2024, the engineering organization in this case carried a stable architecture, a mid-sized team mixing senior and mid-level engineers, and no AI-assisted development practice. Cursor had just become credible. Copilot was widely available but rarely used in production paths. Agentic coding — agents writing branches end-to-end with human review — was still mostly demoware.

The team had a clear technical direction, an in-flight migration off vendor-managed infrastructure — the in-housing transition documented in *[Reclaiming System Ownership Under Vendor Lock-In](/en/work/breaking-vendor-lock-in)*, completed mid-period — and several active product surfaces under simultaneous development. The pace was already constrained by judgment, not by hands.

What started as personal exploration at the end of 2024 turned, over fourteen months, into a sustained shift in how the team built software. By the start of 2026, more than 90% of new code in the platform was AI-generated, the team's velocity ranged 2–3x baseline on most surfaces and 5–10x on greenfield work, straightforward bug-fixing, and abstraction-heavy surfaces, and the operating discipline had been codified, enforced, and absorbed.

This is the sequence that produced that outcome — what was done, in what order, and why.

The companion piece — *[Change Management for Operators: A Battle-Tested Playbook from Three Runs](/en/writing/the-ai-adoption-playbook-for-engineering-teams)* — formalizes the playbook this case file demonstrates in practice.

---

## Constraint Pattern

The starting environment carried these constraints:

- a live platform with production-grade reliability requirements,
- multiple parallel surfaces under active development,
- a mixed-seniority team with varying ceilings of judgment and openness to new tooling,
- no dedicated function for tooling adoption or AI integration,
- no precedent in the team for what *"good AI-assisted engineering"* looks like,
- and a competitive context in which slower adoption was already a strategic cost.

The work had to happen without disrupting active delivery, without imposing top-down mandates that would generate resistance, and without lowering the quality floor.

---

## Objective

By end of period, the operating system around AI-assisted engineering had to:

- be adopted by a clear majority of the engineering team without forcing,
- run inside a governance layer that prevented quality drift,
- compound velocity meaningfully across multiple surfaces,
- include a mentoring path for engineers who needed to come up,
- absorb new tooling and new models without requiring full restarts,
- and remain coherent under future leadership transitions.

---

## Execution Overview

The work moved through six phases over fourteen months. Each phase changed the substrate. The pacing was deliberate — the wrong order would have broken the system.

---

### Phase 1 — Personal Exploration (Q4 2024)

Before anything was brought to the team, the leader spent meaningful personal time using the tools.

That included:

- Cursor as a primary editor, on real code in real branches, not in a sandbox.
- Amazon Q Developer and adjacent agentic IDEs in parallel, to triangulate the state of the market.
- The same tools applied to non-code work — architecture decisions, document drafting, agent orchestration — to understand where the productivity floor sat in 2024 versus where it was heading.

The objective was not to pick a winner. The objective was fluency. The team would not absorb the change if the leader was operating from briefings.

The output of this phase was internal: a calibrated read on where the tools were strong, where they failed, what a sustainable workflow looked like, and what governance gaps would appear once the tools entered the team.

The same context discipline that made this transition stable later — what context lives at the project layer, what at the shared layer, what at the personal layer — is described in *[Context is the Edge](/en/writing/context-is-the-edge)*. The transition described in this case file was made possible by treating context as architecture, not as content.

---

### Phase 2 — Introducing the First Adopter (Q1 2025)

Once the leader's fluency was real, the next move was not a team announcement. It was a one-on-one.

The most curious senior engineer on the team — already running experiments with Cursor on side projects — was the natural first adopter.

The handling:

- explicit message that the team was moving in this direction, with no calendar pressure,
- access to the tools the engineer would otherwise have had to justify,
- regular feedback exchanges, low-formality, focused on what was breaking and what was unblocking,
- and explicit room to explore without a deliverable attached.

The senior engineer began producing visible delta within weeks. Code review depth increased. Ticket throughput rose. The shape of his commits changed.

This phase had two outputs: the team's first internal proof point, and a private feedback channel that surfaced the failure modes early.

---

### Phase 3 — First Quality Drift, First Guardrails

The drift appeared exactly where it tends to appear.

As the first adopter's output rose, certain anti-patterns started slipping through that would not have slipped through under his pre-AI workflow. Boundary discipline weakened in places. Duplication crept in. Some abstractions appeared earlier than the architecture wanted them. The work was faster — and the floor had slightly cracked.

This was not a sign to retreat. It was the signal that governance was now needed.

The first governance moves:

- **Architectural rules codified in a form an AI agent could apply.** The team's architectural-decision records were rewritten with explicit invariants, allowed/forbidden zones, and responsibility boundaries — phrased so a model loading them as context would respect them at generation time. The same discipline is documented end-to-end in *[Establishing Cross-Surface Architecture Governance](/en/work/architecture-governance)*.
- **The rules indexed inside the IDE.** The codified rules were made available through the team's Cursor integration so every session loaded them before any code was generated.
- **A standing skill — a project-scoped command — to invoke these rules on demand**, so engineers could run a structural check against the codified bar before opening a review.

The point of the governance layer was not to slow the first adopter. The point was to make the first adopter's accelerated pace structurally safe. After the layer landed, his throughput stayed up and the quality floor recovered.

---

### Phase 4 — Momentum and Differentiated Mentoring

Other engineers started picking up the tooling. By this stage, the AI toolchain had crossed from a side exploration into the team's standard workflow.

The momentum was uneven. Some of the next wave moved fast — they had been watching the first adopter and were ready. Others lagged. Two distinct resistance patterns emerged.

**Resistance pattern 1 — the engineer hiding behind hacks.**

One engineer had been operating slightly below the team's standard for some time, shipping through assertiveness and informal workarounds rather than clean engineering. The new tooling, particularly the codified rule layer and the agent-as-reviewer step that came later, exposed this more sharply than the pre-AI environment had.

Quality on this engineer's branches deteriorated visibly. The friction was not the tooling. The friction was that the floor had risen and the gap was now legible.

The handling was direct. Explicit mentoring. Clear expectations. Paired sessions with the first adopter. Private one-on-ones framing the situation as a capability conversation, not an adoption conversation. The engineer made measurable progress over the following months. The mentoring was sustained — and it was kept separate from the rest of the rollout, so the team's adoption story did not become entangled with an individual performance situation.

**Resistance pattern 2 — the purist engineer.**

Another engineer was genuinely strong. He had tested early versions of the tools and concluded — correctly — that the output was below his bar. He had no incentive to chase a trend. His position was principled, not defensive.

The handling was the opposite of Pattern 1.

No pressure. Continued access to the tools, continued visibility into what the champions were shipping, no public framing of his position. Over the following year, as the models improved and as the harness around them matured, he began exploring on his own and ultimately adopted the toolchain — on his terms, by his own assessment. By the start of 2026 he was using it regularly.

The same engineer who would have resisted any forced rollout adopted voluntarily once the evidence converged. This is the dividend of patience as a deliberate move, not patience as avoidance.

The broader discipline of running these two patterns in parallel — coaching one set of engineers up, holding space for another set to come around — is the operating principle in *[Influence-First Cross-Functional Leadership](/en/archive/s2-p3-influence-first)*.

---

### Phase 5 — Governance as a Multi-Agent Layer

By mid-period, the team was operating with most of the engineers using the tooling. The governance layer needed to evolve.

Three additions:

- **A second AI agent as first-pass reviewer.** The agent read every PR against the codified rules and architectural boundaries before any human reviewer engaged. The engineer corrected on the agent's feedback first. The human reviewer then came in last, judging substance instead of catching trivia.
- **CI/CD guardrails enforcing the rule layer at machine level.** Tests, principle-violation checks, boundary-crossing checks. Cheap mistakes caught at the cheapest possible moment.
- **Codified engineering principles distilled for both AI agents and engineers.** Not a documentation site. A small, dense set of rules loaded into every session by every engineer, regardless of which agent they were running. The principles are the same ones documented separately in *[Engineering Practice Boundaries — One Bar for Engineers and AI](/en/writing/engineering-principles-that-outlive-the-stack)*.

The orchestration discipline that holds this kind of multi-agent layer together — what gets written down, how memory is tiered, how the loop stays closed — is the substrate described in *[Agentic AI Orchestration — 7 Operating Principles](/en/writing/orchestration-principles-that-outlive-the-model)*.

After this layer landed, the governance stopped depending on synchronous intervention from any one person. The system enforced itself.

---

### Phase 6 — Standardization and Compounding (Q1 2026)

The final phase formalized the new standard.

- Adoption became part of standing engineering practice — referenced in onboarding, in performance conversations, in OKRs.
- KPIs were tracked per project and per engineer: percentage of AI-generated code, velocity delta, defect rate, review iteration count, governance violation count.
- New rules and new commands kept being added in response to specific failure modes, with the system designed to absorb them without restarts.
- Newer models — Claude Opus 4.6 in particular — multiplied what was already working. The substrate was ready for the upgrade; the upgrade did not require re-running the rollout.

By this point, the operating pattern had absorbed. It no longer felt like a transition.

---

## Result

The material outcomes after fourteen months:

- more than 90% of new code on the platform AI-generated,
- 2–3x velocity baseline across most surfaces; 5–10x on greenfield work, straightforward bug-fixing, and abstraction-heavy surfaces,
- no measurable degradation in quality versus the pre-adoption baseline; on the rule-heavy surfaces, a measurable improvement,
- an engineering team operating fluently in agentic workflows, with a shared vocabulary for the new bar,
- a governance layer codified inside the repository and inside CI, capable of absorbing new tooling without rewrite,
- one engineer mentored up, one engineer adopted on his own terms, zero forced departures tied to the rollout.

The substrate now compounds. The next model upgrade adds throughput without disturbing the operating system.

---

## Closing Note

The transition described here did not break the system, did not produce backlash, and did not depend on any single tool surviving. The substrate it produced — codified rules, multi-agent governance, a mentoring path for resisters, clear KPIs visible across the team — is portable across stacks, across teams, and across the next wave of models. The cross-cutting principles for change of this shape — when to act, how to anchor, what to protect — are crystallized separately in *[Change Injection: Shaping Systems Without Collapse](/en/archive/s2-p2-change-injection)*.

The playbook this case file demonstrates in practice is in *[Change Management for Operators: A Battle-Tested Playbook from Three Runs](/en/writing/the-ai-adoption-playbook-for-engineering-teams)*. The two are paired: this one is the proof, that one is the bar.
