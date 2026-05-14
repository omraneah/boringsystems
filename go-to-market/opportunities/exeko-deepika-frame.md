# Frame Map — Exeko.ai via Deepika

**Purpose.** Brought to the next call(s) — Louis re-pitch + Angelina presentation. Resets the frame on Ahmed's terms before Louis's "co-direction + hands-on + AI" framing locks in.

**Status.** Not committed. Frame-test only.

---

## The opportunity, in one line

A fractional engagement to **stabilize the foundations** of Exeko.ai's codebase before any R&D / AI work happens on top — routed via Deepika as sub-contractor, time-boxed, no entanglement.

This is **not** the mission Louis pitched. Louis pitched "co-direction with CEO + hands-on code + product roadmap + AI ambition (BPI R&D T1-T6)." Ahmed's frame is narrower, earlier, and explicitly time-boxed.

The call has to open on this reframe, not on Louis's version.

---

## The five guardrails (non-negotiable)

1. **Founder must understand technology.** Probed directly in the next call. Resistance or deflection → walk.
2. **Floor: €800/day, 2 days/week max.** Already match-confirmed with Louis.
3. **Never the main dev.** Scaffolding + architecture + practices, not feature delivery.
4. **Never own structural risks.** Infra, tooling, knowledge — owned by Exeko, handed over as deliverables.
5. **No founder-grade incentives on a non-founder engagement.** Named out loud to Deepika and Angelina.

---

## Proposed mission shape

### Scope

**Foundations only.** No AI, no growth features, no roadmap acceleration until the base is sound. The audit Deepika produced says this directly. The R&D BPI program cannot land on the current base.

Drawn from Deepika's own audit, P1.a + P1.b + P1.c:

- **P1.a — Technical safety net.** README + CONTRIBUTING + DEPLOYMENT. CI on push & PR. Tests on critical paths (auth, capabilities, payment, flags, scoring). E2E Playwright on 3–5 critical journeys.
- **P1.b — Need → solution alignment.** Référentiel of features in prod (Notion or `docs/product/`). Shared business model document.
- **P1.c — Explicit architecture.** Architecture diagrams in `docs/01-architecture/`, referenced from README.
- **P0 — Security incident.** Production DB dump committed in Git since 2025-10-08 → `git filter-repo` purge, force-push coordinated, password reset, OAuth refresh-token rotation, `.gitignore` hardened with anti-binary CI check.

**Explicit exclusions.**
- No work on T1-T6 of the BPI annexe (ASR, LLM, MPA, ADP, AI assistant, guardrails). Those come after the base is sound, and they may not come from Ahmed.
- No ownership of the existing dev's roadmap. Coaching available; replacement not Ahmed's call.
- No infra ownership. No tooling ownership. No "be the one who knows the system."

### Cadence & duration

- **Month 1 — Trust + diagnostic.** ~8 days @ 2 j/sem. Read the code in detail, validate the audit findings against reality, set the scaffolding, propose the month-2 sprint scope.
- **Gate 1 — End of month 1.** Joint review with Angelina. Either go to month 2 or walk clean.
- **Month 2 — Scoped tech-debt sprint.** ~8 days @ 2 j/sem. Execute the highest-leverage items from month 1's diagnostic.
- **Gate 2 — End of month 2.** Joint review. If synergies are real, set a new objective. If not, walk clean. **No rolling retainer.**

### Deliverables (value-holds-if-I-leave)

Every deliverable must continue to add value if Ahmed exits the day after Gate 2.

- CI/CD pipeline that runs without him.
- Test suite that catches regressions without him.
- Architecture diagrams readable by the next engineer.
- README + CONTRIBUTING + DEPLOYMENT that lets a new contributor onboard in 1 day.
- A documented coaching record for the existing dev — what was taught, what was understood, what remained gap.

### Rate

800 €/day to Deepika (margin theirs). Ahmed net 800. Confirmed in intro call.

---

## Probes for the call with Angelina

These are not questions to read off a list. They are signals to feel for during the conversation.

### Founder-technical-fit probes

- Ask Angelina a direct technical question about her system. E.g. "Your audit shows 6 places the Quiz domain logic is dispersed. How do you think about that — is that intentional or accidental?" Listen for: engagement vs. deflection.
- Ask her to describe in her own words what the BPI R&D program changes about the platform. Listen for: structured understanding vs. marketing-language.
- Ask her how she's thinking about the existing dev's growth trajectory. Listen for: managerial honesty vs. avoidance.

### Authority probes

- "If the existing dev's execution can't match the architecture I set, what's the path?" Listen for: clear authority + her holding the hiring decision, vs. punting it back to Ahmed.
- "If month 2 ends and we conclude the foundations need 3 more months before any R&D, who owns that decision?" Listen for: founder ownership vs. delegated ambiguity.

### Risk-transfer probes

- "Who owns the production environment today, and how does that change?" Listen for: clear answer vs. drift.
- "If we coordinate a `git filter-repo` for the DB dump, who runs the actual force-push and notifies collaborators?" Listen for: founder + dev willing to execute, vs. expectation that Ahmed does it solo.

### Incentive-asymmetry probe

- State directly: "I'm not joining as a co-founder. I'm contributing 2 days a week on a time-boxed scope. The structural risks of Exeko stay with Exeko. Is that the engagement you want?" Listen for: relief + clarity, vs. disappointment + push to expand.

---

## Probes for Louis (separately, before Angelina)

- **Margin transparency.** "What does Exeko pay Deepika per day? I don't need the number, I need order of magnitude — to know if the relationship is partnering or arbitraging."
- **The co-direction positioning.** "You said you haven't cracked the co-dirigeant externalisé positioning. I'm not the one to solve it on a 2-day/week ticket. Can the mission be scoped to foundations + handoff, not to figuring out your studio's product-market fit?"
- **The parallel candidate.** Mégardel framing. Not to negotiate against — to know whether Louis is selecting on fit or comparing rates.
- **The existing dev.** "If the existing dev is the bottleneck and you've already audited that, what's the studio's posture if I recommend replacement?"

---

## Cautions to keep visible to self during the calls

- **Replay risk.** This shape (big dreams + non-technical founder + fragile base + AI ambition on top) is exactly the Enakl shape. The body knows it before the mind. Listen for the felt-signal early.
- **Warm rapport ≠ aligned engagement.** Jean-Michel's Sfax / Morocco / UM6P opening is genuine and creates rapport. Rapport is not commitment. Decide on the engagement, not on the network warmth.
- **Sub-contractor framing.** Accept it only if Deepika's network + coaching + portfolio access add real value beyond a margin-take. If the deal is purely "Deepika brokers you to Exeko and takes 25%," that's leverage flowing the wrong direction.
- **Mafia framing.** Jean-Michel's joke ("c'est une mafia où tu vas rentrer, méfie-toi") is half-true. In-group dynamics are real. Inclusion can be capture. Stay sovereign in the relationship even while being warm.
- **August + September timing.** Calendar match is real but seductive. Don't let "it fits the calendar" override "it fits the frame."

---

## Engagement decision posture — 80 / 20 walk-with-gates

**Default expectation: 80 % walk, 20 % maybe.** Not pessimism — pattern recognition. The shape (non-technical founder + fragile base + BPI clock + 1 junior dev + studio margin) is the replay archetype.

The 20 % is real if **all** of the following hold simultaneously:
- Angelina passes the founder-technical-depth probes (not just literacy — current engagement with the codebase).
- She accepts the foundations-first reframe out loud, in the call, without re-negotiating it within 3 weeks.
- Cash plan is decoupled from BPI tranche timing (operating account, not restricted R&D account).
- Louis confirms margin transparency + dev-replacement authority.
- The existing dev passes a separate 30-min probe — capable of executing on scaffolding, not just shipping features.

**If all five hold → trial Month 1, 8 days, foundations only, Deepika re-audits at Month-2.**
**If any one fails → walk, network preserved, time spent: ~60 minutes total.**

This is not negotiable. Each non-negotiable that gets softened triples the entanglement risk on the next.

---

## Starter-pack as conversation artifact

Bring the `cross-stack-architecture-starter-pack` into both calls. Share openly. The act of sharing IS the probe.

**Frame to deliver (rough script):**

> "This is the playbook I built over four years at the company I'm leaving. Same archetype as Exeko — Next.js / Prisma / single dev / big ambitions on top of a thin foundation. I've codified it: 11 architectural boundary documents, 7 decision trees, patterns and anti-patterns, a 10-phase bootstrap sequence. **You can do it yourselves with this artifact. I can help you do it.** Either way, you walk away with the playbook. The risks you carry remain yours — that part doesn't transfer."

**What the founder's reaction tells you:**

| Founder response | Read |
|---|---|
| Engages with structure, asks how to adapt to their stack, proposes a step she'd take first | **20 % path live.** Technical, collaborative, treats you as peer. |
| "Send it to the dev" / "We'll look at it later" / "But the AI work is more urgent" | **Walk.** She's not in the loop. The engagement would compound the gap, not close it. |
| Probes the artifact for IP risk, asks if it can be reused | **Walk.** She's reading you as a resource to extract, not a peer to learn with. |
| Asks who else has used it, whether it produced outcomes | **Curious-but-careful.** Acceptable. Demonstrate via Enakl artifacts. |

**Three things the sharing accomplishes at once:**
1. Establishes credibility through evidence (4 years, named artifacts, real system).
2. Refuses the founder-grade-incentive trap upfront — their risks stay theirs.
3. De-risks the walk for both sides — if they say no, you both gained something (warm relationship, useful artifact in their hands).

The studio (Deepika) also reads this artifact. Louis admitted his co-direction positioning is unsolved. The starter-pack gives him a concrete shape he can adopt for his portfolio. Even if Exeko doesn't happen, **Deepika now sees you as the operator who brings structured playbooks**, not just availability. That signal compounds across his 2026 pipeline.

---

## Month-2 exit mechanism — studio re-audit

If Month 1 happens, lock in the following at engagement start:

> **Deepika re-audits Exeko at the end of Month 1.** The audit verdict gates the Month-2 decision. Ahmed delivers scoped foundations work; the studio measures the result. The next step (continue, expand, stop) is decided by the audit delta, not by any one party's preference.

Why this matters:
- **Decouples your exit from founder-relationship friction.** If foundations aren't ready for R&D, Deepika tells her — not you.
- **Three-sided alignment.** Founder, studio, you all measure the same thing: the audit delta. No politics.
- **Studio incentive aligned.** Deepika already audited once; re-auditing is low-cost and high-signal for their portfolio judgment.
- **Walk-clean baked in.** Either the audit shows readiness for R&D (you maybe continue or hand off), or it doesn't (you walk, no bad-news messenger problem).

Build this clause into any verbal agreement before Month 1 starts. Without it, Month 2 becomes a negotiation about whether to continue. With it, the audit decides.

---

## If the frame doesn't hold — walk criteria

Priority order (any one triggers walk):

1. Founder fails the technical-depth probes (deflection, "send it to the dev", no current engagement with the codebase).
2. Founder pushes back on foundations-only scope and insists on AI / co-direction / hands-on-as-main-dev.
3. Studio refuses margin transparency.
4. Authority on the existing dev is unclear or punted to Ahmed.
5. Pressure to commit beyond the Month-1 gate before Month 1 is even scheduled.
6. Cash plan tied to BPI tranche delivery on R&D milestones Ahmed doesn't own.
7. Co-founder (Pierre-Thomas) commitment ambiguous (BLCONSULTING / side allocation).
8. Existing dev fails the 30-min probe — unable to execute on scaffolding.

No negotiation, no scope expansion, no rate concession. The next opportunity is allowed to be different.

---

## Cross-references

- Doctrine this maps to → `memory/medium-term/operational-doctrine/Fractional-Engagement-Guardrails.md`
- Universal upstream filter → `memory/medium-term/operational-doctrine/Engagement-Validity-Filter.md`
- Today's episodic record → `memory/short-term/2026-W20/2026-05-14.md`
- Audit source documents (PDF synthesis + BPI annexe Excel) — kept ephemerally in render buffer; key findings extracted into this frame map and `exeko-deepika-transferability.md`.
