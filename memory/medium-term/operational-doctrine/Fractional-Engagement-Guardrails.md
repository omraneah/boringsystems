---
name: Fractional Engagement Guardrails
description: Rules for evaluating any fractional CTO / lead-as-a-service / studio-routed engagement. Sits downstream of the Engagement Validity Filter and refines it for the specific shape of part-time tech-leadership work routed through a studio, agency, or VC vehicle. Universal — applies to any opportunity of this shape.
type: doctrine
---

# Fractional Engagement Guardrails

**The shape this filter applies to:** any part-time engagement where the work is technical leadership (CTO, fractional CTO, lead engineer, "tech advisor with hands"), the founder is not deeply technical, and a third party (studio, agency, VC, fund) routes the deal and takes margin.

This is the shape most likely to come Ahmed's way during the 2026 re-entry phase. It looks aligned on the surface and structurally drains across the [[Engagement-Validity-Filter]] dimensions if not framed carefully.

---

## The five non-negotiables

### 1. Founder must understand technology

Probe directly in the first call. Ask a technical question that requires the founder to reason about the system. Listen for:

- **Engagement** → founder thinks with you, asks back, names trade-offs.
- **Resistance** → founder deflects to the dev, the audit, the deck.
- **Performative agreement** → founder nods but doesn't actually engage with the substance.

**If resistance or deflection appears, walk.** A non-technical founder cannot hold the conversation that fractional tech leadership requires. The engagement will collapse into being the de-facto CTO with no decision authority and no equity — the worst shape of all.

### 2. Floor: €800/day, 2 days/week max

Below the floor, the engagement is priced as labor, not as leverage. Above the cap (2 days/week), it's not fractional — it's a full-time job in disguise, with all the downside of full-time and none of the upside (equity, authority, ownership).

The cap is not about hours — it's about cognitive ownership. More than 2 days/week and the founder offloads the decision-weight to you. That's the entanglement trap.

### 3. Never the main dev

Fractional CTO ≠ fractional lead dev. The distinction:

- **Fractional CTO** sets architecture, hires/replaces, defines practices, gates major decisions. The existing engineer(s) execute.
- **Main dev** carries the codebase. Builds the features. Owns delivery.

The studio / founder will frequently try to blend the two — "co-direction + hands-on code + roadmap". When the codebase is fragile and the existing dev is junior, "hands-on code" silently becomes "you are now the main dev." Refuse the blend explicitly.

**Hands-on is fine. Owning delivery is not.** Set the scaffolding, the architecture, the testing, the CI/CD. Coach the existing dev. If the dev can't execute on what you put in place, that's the founder's hiring problem, not yours.

### 4. Never own structural risks

Three categories of risk that must remain with the company, not transfer to you:

- **Infrastructure risk.** Hosting, deployment, uptime, scaling — owned by the company.
- **Tooling risk.** Build systems, CI/CD pipelines, developer environment — set up, then handed over.
- **Knowledge risk.** Architecture diagrams, decision records, documentation — produced as deliverables, not held in your head.

The failure pattern: you become the one who *has* the tools, the *one* who knows the system, the *only one* who can deploy. By the time you notice, exit costs are catastrophic.

**The Enakl lesson:** structural ownership of tools by the external party makes everyone worse off. The company can't operate without you; you can't leave without breaking the company. Both sides lose. Refuse the shape from day one.

### 5. No founder-grade incentives on a non-founder engagement

When a studio or founder proposes incentive alignment ("you'll be invested in the outcome", "we'll share equity once we figure out the structure", "co-direction means you carry the project like a founder"), name the asymmetry out loud:

> External parties cannot carry founder-grade incentives on a project that is not theirs. Pretending otherwise is meant to fail.

The convergence point is not your project. You are contributing in some way. That is the honest frame. Resist any structure that pretends otherwise — it sets up resentment on both sides.

---

## Mission shape that works

When the five guardrails hold, the mission shape that consistently delivers value:

1. **Foundation-first scope.** No AI, no growth features, no roadmap acceleration until the base is sound. Audit-fix only: testing, CI/CD, monitoring, architecture, knowledge-sharing artifacts. The [[../market/engagement-shapes]] *audit + remediation* shape.
2. **Time-boxed milestone gates.** Month 1 = trust + diagnostic. Month 2 = scoped tech-debt sprint (~8 days @ 2d/week). Then explicit re-evaluation. No rolling retainer.
3. **Value-holds-if-I-leave test.** Every deliverable must continue to add value if Ahmed exits the day after. CI/CD that runs without him. Tests that catch regressions without him. Architecture docs that survive him. Scaffolding ≠ ongoing presence.
4. **Coach-the-dev posture.** If the existing engineer is solid, scaffold and coach. If not, tell the founder honestly and let the founder decide. Never quietly replace the dev — that's the entanglement entry point.
5. **No commitment beyond the milestone.** If month 2 ends and synergies are real, set a new objective. If not, walk clean. The next opportunity is allowed to be different.

---

## Studio-routed specifics

When a studio (or VC fund, or accelerator, or agency) routes the engagement, additional guardrails apply:

- **Margin transparency.** Know what the studio pays you vs. what the client pays the studio. Order-of-magnitude is enough. If the studio refuses to surface this, the relationship is arbitraging you.
- **Branding.** Sold as "the studio's resource" vs. sold as yourself. The first is a positioning cost that compounds; the second is leverage. Negotiate for the second when you can; accept the first only when the relationship has additional value (network, portfolio, coaching, future-deal pipeline).
- **Co-direction unsolved.** Studios that route "fractional CTO" engagements often haven't cracked the positioning themselves. If they admit this openly, that's honest — but it also means you'd be solving their structural problem on a 2-day/week ticket. Refuse to absorb it. Your job is the mission, not the studio's product-market-fit.
- **Parallel candidates.** Studios run multiple candidates. Don't be surprised; don't compete by lowering the rate or expanding the scope. The right alignment is binary — either it fits or it doesn't. Compete only on fit, never on concession.

---

## The two-week confirmation rule

If after two weeks inside the engagement the five non-negotiables are being silently violated, exit. The pattern of "let's see if it gets better" is the entanglement trap. The willingness to exit early is what makes commitment safe.

Time-box every fractional engagement as if it could end at the next milestone. That posture is what keeps it healthy.

---

## Cross-references

- [[Engagement-Validity-Filter]] — the upstream universal filter this refines.
- [[Identity-and-Exit-Doctrine]] — life-level exit triggers.
- [[Work-Hygiene-Doctrine]] — clean / dirty work distinction.
- `../market/engagement-shapes.md` — the four pricing & scope archetypes.
- `../market/Sales-Mode-Tactics.md` — the sales-mode posture during these conversations.
- `../../long-term/I-AM.md` — the being-tier these guardrails serve.
