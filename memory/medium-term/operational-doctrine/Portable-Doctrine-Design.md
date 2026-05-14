---
name: Portable Doctrine Design
description: How to build portable knowledge artifacts (architectural boundary packs, playbooks, audit protocols) that travel beyond one operator's specific codebase and stay useful in different stacks. Distilled from the cross-stack-architecture-starter-pack rebuild session, 2026-05-14.
type: doctrine
---

# Portable Doctrine Design

When I build a portable knowledge artifact — a boundary pack, a playbook, an audit protocol — these are the design moves that hold up under cold review. Distilled from the May 14, 2026 rebuild of `cross-stack-architecture-starter-pack` after a session where I learned what failure modes the artifact had under both LLM and human peer review.

## The two-layer separation

**Layer 1: Boundary.** The principle that holds across operators. Same shape across NestJS and FastAPI and Rails. Names the failure mode the principle prevents. Surfaces the trade-off honestly — the judgment section names 2-3 alternatives and when each fits, without picking a winner. Ends with signals of violation that an auditor or LLM can grep for.

**Layer 2: Doctrine.** One operator's specific picks within the boundary's principle. "I do X. Why: Y." Anonymous to the company but personal to the operator. Reference, not requirement.

The single biggest design mistake is letting Layer 2 leak into Layer 1. The boundary that says "always use async events for cross-module communication" is doctrine-leaking-into-boundary. The honest version says "async pub/sub OR direct DI; pick async when these conditions hold." The reader picks; the doctrine records what I picked and why.

## Judgment-first framing

A prescriptive boundary tells the reader what to do. A judgment-first boundary tells the reader what to choose between. The same principle but framed differently lands very differently.

- Prescriptive: "Use URI path versioning."
- Judgment: "Three places versioning can live (URI / header / query). URI for public APIs and independent clients; header for content-negotiation-heavy or SDK-coupled APIs; query parameter is discouraged."

The reader who runs a GraphQL shop, an internal-SDK shop, a HATEOAS shop — each finds themselves in the judgment frame. Each can't find themselves in the prescriptive frame.

## Severity floor, overridable by context

Each boundary names a default severity for a violation: P0 / P1 / P2. Then the audit explicitly says: the audit can override based on context. A P1 in a regulated B2B context steps up to P0; a P0 in an internal-tool context steps down to P1.

This lets the audit be opinionated AND context-aware. Without the floor, every audit re-derives severity from scratch. Without the override, the floor flattens the picture.

## Operator scar > textbook consensus

Readers can tell the difference between a line that was lived and a line that was paraphrased from Google SRE or Camille Fournier. The lived line uses specific failure modes ("I have never seen a 'we'll run the migration tonight, deploy the code tomorrow' plan that didn't create a window of inconsistency"). The textbook line uses general principles ("migrations should be deployed with the code that depends on them").

If a doctrine entry could appear in any engineering blog, it's not contributing. Cut it or rewrite with the operator's actual scar.

## Stack-agnostic in principle, stack-specific in worked examples

The boundary itself is portable. The worked example is concrete — TypeScript-flavored, opinionated about the database, opinionated about the framework. The pack keeps them separate. Boundaries in `boundaries/`; concrete code in `examples/`. Tagged as "the framework changes; the four boxes don't."

Without worked examples, the pack is theory and an LLM can't ground its audits. With worked examples in every boundary, the pack betrays its stack. The compromise: one or two worked examples in `examples/`, clearly marked as illustration, with porting notes for other stacks.

## Audit protocol: what the LLM does AND what the LLM does not do

The "does" list is the obvious part. The "does not" list is where the protocol's discipline lives:

- Don't auto-prescribe; surface the choice when alternatives are valid.
- Don't override the operator's existing choice.
- Don't flag a doctrine choice as a violation. The doctrine is reference.
- Don't rename codebase identifiers to match the pack's terminology.

Without the "does not" list, the LLM pretends to authority. With it, the LLM produces analysis the operator can read critically.

The protocol also needs an output schema (JSON or strict markdown template) and a sample run on a fictional codebase. Without these, the protocol is description; with them, it's executable.

## Org-context honesty

The pack assumes a normal-ish engineering org. Many early-stage orgs aren't normal. The pack should be honest about what changes when the org context is harder than the pack assumes:

- Adversarial founders blocking infrastructure investment.
- Junior-only teams without a senior engineering hire.
- No platform-engineering hire — IaC, IAM, deployment posture all drift together.
- AI-assisted development as a hiring substitute.

The boundaries don't change. The order in which they're landed, the political work attached to each, and the trade-offs the operator has to accept temporarily — those do. A separate `ORG-CONTEXT.md` keeps this honest without polluting the boundary docs.

## Public-repo anonymization

For a pack the author intends to make public, every domain reference is a leak candidate. The discipline:

- Zero company names anywhere.
- Zero references to vendors that an experienced reader would associate with a specific employer.
- Vendor / provider names in worked examples are acceptable ONLY when listed as one-of-many opaque examples ("Auth0, Cognito, Clerk, Firebase, custom — the boundary doesn't care").
- The doctrine file is the operator's voice but never says where the operator worked.

Test: a senior engineer reads the pack cold and can't deduce the author's employer, vertical, or specific tech stack from the content alone.

## Iterate with cold reviewers

The author of a portable artifact can't review their own work for over-fitting. Dispatch one cold reviewer (a peer or an LLM playing one) before publishing. The cold review catches things the author can't see:

- Where the boundary bakes a specific design choice as universal.
- Where the doctrine reads like textbook consensus.
- Where the audit protocol is conceptually correct but operationally vague.

The dual-audit pattern — one LLM audit, one human peer audit — catches more than either alone. Different priors, different blind spots.

## Cross-references

- `cross-stack-architecture-starter-pack` — the artifact this doctrine is distilled from.
- `Engagement-Validity-Filter.md` — the upstream filter for which engagements deserve this kind of artifact in the first place.
- `Fractional-Engagement-Guardrails.md` — when applying this kind of pack to a fractional engagement.
