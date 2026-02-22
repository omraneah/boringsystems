---
title: "Establishing Cross-Stack Architecture Governance"
description: "Scaffolding architectural boundaries across five stacks — from scattered Confluence notes to 10+ authoritative, AI-accessible documents owned by the CTO and applied by everyone."
pubDate: "2025-12-31"
featured: true
order: 3
---

# Establishing Cross-Stack Architecture Governance
Scaffolding a shared governance layer for a team operating without one.

---

## Context

After completing a full vendor exit and establishing internal ownership of the platform, the organization operated under a new constraint: **no architectural governance layer**.

The company ran five technical surfaces:

- **Backend API** (NestJS/TypeScript)
- **Backoffice** (Next.js/React)
- **Rider App** (Flutter/Dart)
- **Driver App** (Flutter/Dart)
- **Infrastructure** (Terraform/AWS)

Each surface was owned by a different engineer working in a specialized, contained context. With no architecture lead and no boundary documents, architectural knowledge lived entirely in Confluence to-dos, project cards, and the codebases themselves. There was no authoritative source for cross-stack constraints.

The result was predictable: engineers diverged. Not intentionally — but without a shared reference, each surface evolved under its own assumptions. Patterns drifted, terminology split, and decisions that should have been consistent became inconsistent.

The company was also moving toward a **multi-tenancy SaaS model**, which required every surface to align on strict isolation patterns, tenant scoping, and provider replaceability. Without architectural governance, that transition would accumulate coordination overhead and generate compounding technical debt.

Scaffolding this layer was the decision — not to produce documentation, but to give engineers and AI tools the same clear guidance so they could work in parallel, reliably and without ambiguity.

---

## Scale at Entry

At the beginning:

- **5 engineers**, each owning a portion of the stack
- **1 senior engineer**, no architecture lead
- **0 boundary documents**
- all architectural context scattered across Confluence to-dos, project cards, and codebases
- no authoritative source for cross-stack constraints
- engineers diverging across surfaces, each working within their own specialized context

By the end of the first phase:

- **10+ authoritative boundary documents** in a dedicated GitHub repository
- complete alignment across all five stacks
- cross-referenced, cohesive documentation applied consistently by engineers and AI tools
- validated against technical debt, owned and maintained by the CTO

---

## Constraints

- live production systems across all surfaces
- no acceptable disruption to ongoing development
- team operating under constraint with no architecture lead
- documents must serve both **humans and AI tools**
- documents must be **principle-level** — not implementation guides
- documents must be **cross-stack** — no code, no stack-specific references
- must be **future-proof** against the upcoming multi-tenancy transition
- Confluence remained in use for to-dos and operational notes — the governance layer had to coexist without displacing it

The governance layer had to be immediately usable.

It had to work without adding process overhead.

---

## Objective

Scaffold a cross-stack governance layer that:

- serves as the **authoritative source of truth** for architectural boundaries across all surfaces,
- gives engineers and AI tools the **same guidance**, applied consistently,
- reduces divergence without requiring constant senior oversight,
- guides the team through the **multi-tenancy transition** without ambiguity,
- is owned by the CTO, maintained at a sustainable cadence, and durable enough to stay relevant.

---

## Execution Overview

The effort unfolded incrementally — from discovery through tooling — without disrupting development.

---

### Phase 1 — Discovery and Mapping

The first phase mapped the current state of architectural knowledge across all surfaces.

This included:

- auditing all Confluence documents for architectural decisions,
- reviewing project cards, to-dos, and codebase conventions,
- identifying where engineers had diverged across surfaces,
- documenting missing boundaries — especially for multi-tenancy, authentication, and module communication.

The analysis confirmed the problem: every surface had its own assumptions. There was no single answer to basic cross-stack questions. Engineers had no shared reference to point to.

From this phase, the scope of the governance layer was defined.

---

### Phase 2 — Boundary Document Creation

The second phase produced the authoritative boundary documents.

Each document addressed a distinct architectural concern — cross-stack, principle-level, with no code and no stack-specific references. Documents covered:

- authentication boundaries and provider isolation,
- multi-tenancy and tenant scoping,
- organisation and user profile constraints,
- module communication patterns and circular dependency rules,
- quality and security enforcement gates.

All documents followed a consistent structure: purpose, core model, non-negotiables, allowed versus forbidden zones, responsibility boundaries, and related boundaries. Cross-references between documents created a coherent graph — no boundary existed in isolation.

All documents were published to a dedicated GitHub repository: [omraneah/cross-stack-architecture](https://github.com/omraneah/cross-stack-architecture).

Ownership was assigned to the CTO. Non-negotiable.

---

### Phase 3 — Integration and Distribution

The third phase made the boundary documents accessible everywhere they were needed — for humans and for tools.

The architecture repository was linked to all project repositories via **GitHub submodules**, ensuring a single source of truth with no duplication.

Agent configuration files in each repository directed AI tools to the architecture repository, ensuring boundaries were checked during planning, implementation, and review. Higher-level governance rules were extracted and made available across the tooling layer.

From this point:

- engineers had a shared reference accessible directly in their development context,
- AI tools applied the same boundaries during code generation, planning, and review,
- no surface could diverge without surfacing a visible gap.

---

### Phase 4 — Governance Tooling

The fourth phase codified the governance layer into reusable commands and skills.

This included:

- **architectural review commands** — anyone on the team can invoke a standardized boundary review, reliably and consistently,
- **tech analysis codification** — structured analysis that follows the same principles every time,
- **card creation tooling** — issues surfaced during development or review can be captured and routed directly to the CTO's roadmap,
- **weekly metrics** — critical technical debt tracked against objectives, managed by the CTO, visible at cadence.

The tooling removed the need for seniors to explain architectural decisions repeatedly. The answer became: read the documents. If there is a violation, flag it — the command exists for that.

---

### Phase 5 — Alignment and Maintenance

The fifth phase established the ongoing maintenance model and validated the documents against known technical debt.

Gaps were identified, surfaced, and folded into the roadmap. As engineers and AI tools developed new features, newly uncovered debt was surfaced through the same commands and captured for the CTO. The architectural documents were kept aligned with the roadmap direction — including the multi-tenancy transition — ensuring they remained future-proof, not just descriptive.

Confluence remained in use for to-dos and operational notes. Whenever a conflict arose between Confluence content and the architectural documents, the architectural documents were the source of truth.

Maintenance cadence: updated during the first phase monthly, then once every two months. Audited once a quarter.

---

## Result

After one quarter:

- **10+ authoritative cross-stack boundary documents** maintained in a dedicated GitHub repository,
- same conventions, naming, and jargon applied consistently across all five stacks — engineers moving between surfaces faced no additional friction,
- AI tools and engineers applied the same constraints during development and review,
- fewer back-and-forth cycles between engineers and the CTO, and between authors and reviewers,
- new technical debt surfaced and routed to the roadmap directly through commands,
- new engineers onboarded against a single, maintained reference — not scattered, outdated Confluence pages,
- throughput increased across the team: less friction, less ambiguity, less coordination overhead,
- architectural review commands available to everyone, applied reliably.

---

## Closing Note

This case illustrates that architectural governance does not require an architecture team. It requires a decision: make the constraints explicit, make them accessible, and make them the source of truth for everyone — including the tools.

When engineers and AI agents apply the same principles from the same document, divergence shrinks. Coordination overhead drops. Throughput increases — not by speeding things up, but by removing the friction that was slowing everything down.

The discipline is not in the number of documents. It is in making them authoritative.
