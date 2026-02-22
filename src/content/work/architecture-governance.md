---
title: "Establishing Cross-Stack Architecture Governance"
description: "Consolidating architectural boundaries across five stacks and ten engineers — from scattered knowledge to a unified, AI-accessible source of truth."
pubDate: "2025-12-31"
featured: true
order: 3
---

# Establishing Cross-Stack Architecture Governance

A systematic approach to consolidating architectural boundaries and creating authoritative governance across multiple projects.

---

## Context

After successfully in-housing the platform from vendor lock-in, the organization faced a new challenge: **architectural knowledge fragmentation**.

Architectural decisions and boundaries were scattered across:

- Multiple Confluence documents (some outdated, some conflicting)
- Project-specific README files with inconsistent guidance
- Senior developer documentation that varied in depth and scope
- Implementation plans that didn't reference authoritative sources
- No single source of truth for cross-stack architectural constraints

The company operated:

- **Backend API** (NestJS/TypeScript)
- **Backoffice** (Next.js/React)
- **Rider App** (Flutter/Dart)
- **Driver App** (Flutter/Dart)
- **Infrastructure** (Terraform/AWS)

Each project had its own conventions, and architectural boundaries were:

- **implicit** rather than explicit,
- **project-specific** rather than cross-stack,
- **implementation-focused** rather than principle-level,
- **inconsistent** across different documentation sources.

The organization was transitioning toward a **SaaS model** with multi-tenancy, strict tenant isolation, and provider replaceability requirements. Without unified architectural governance, this transition risked:

- inconsistent implementation across projects,
- accidental boundary violations,
- difficulty onboarding new engineers,
- AI tools (like Cursor) making decisions without architectural context,
- technical debt accumulation from misaligned patterns.

At the time this effort began, the organization had:

- **~10 engineers** across all projects,
- **multiple active codebases** with different tech stacks,
- **legacy patterns** that needed to be frozen (not extended),
- **new architectural requirements** (multi-tenancy, SaaS) that needed clear boundaries.

---

## Scale at Entry

At the beginning of the consolidation:

- **6 boundary documents** scattered across Confluence and project READMEs
- **~20+ workspace documents** (implementation plans, project cards, tech debt analysis)
- **No cross-referencing** between documents
- **No authoritative source** for architectural constraints
- **Inconsistent principles** across different documentation sources

By the end of the consolidation:

- **6 authoritative boundary documents** in a dedicated GitHub repository
- **Complete alignment** between governance and implementation documents
- **Cross-referenced** and cohesive documentation structure
- **Linked to all projects** via `.cursorrules` and workspace references
- **Validated against tech debt** to ensure boundaries guide engineers away from known issues

---

## Constraints

- Live production systems across multiple projects
- No acceptable disruption to ongoing development
- Multiple documentation sources with conflicting information
- Documents needed to work for both **humans and AI tools** (LLMs)
- Documents must be **principle-level** (not implementation guides)
- Documents must be **cross-stack** (no code, no stack-specific references)
- Documents must be **succinct** (no fluff, actionable constraints)
- Existing implementation plans must remain valid
- Legacy patterns must be explicitly frozen (not extended)

The consolidation could not pause development.

The governance structure needed to be immediately usable.

---

## Objective

Create authoritative, principle-level, cross-stack architectural boundary documents that:

- serve as the **source of truth** for all projects,
- guide engineers away from technical debt,
- enable AI tools to make architecturally sound decisions,
- remain stable over time (principle-level, not implementation details),
- are linked and referenced across all projects.

The effort was treated as **governance consolidation**, not documentation cleanup.

---

## Execution Overview

The consolidation unfolded over ~2 months through incremental phases, each designed to establish governance without disrupting ongoing development.

---

### Phase 1 — Discovery and Inventory

The first phase focused on identifying all architectural documentation and understanding the current state.

This included:

- auditing all Confluence documents related to architecture,
- reviewing project-specific README files and documentation,
- analyzing senior developer documentation for architectural decisions,
- identifying conflicting guidance across different sources,
- mapping implementation plans to understand what boundaries they assumed,
- reviewing tech debt analysis to identify patterns that needed boundaries.

The analysis revealed:

- **scattered knowledge** across multiple platforms (Confluence, GitHub, project READMEs),
- **inconsistent terminology** (e.g., "organisation" vs "organization", "userId" vs "cognitoUserId"),
- **implementation details** mixed with architectural principles,
- **missing boundaries** for critical areas (multi-tenancy, authentication, module communication),
- **legacy patterns** that were documented but not explicitly frozen.

Based on this analysis, the decision was made to:

- create a **dedicated GitHub repository** for cross-stack architecture,
- consolidate all boundary documents into **authoritative, principle-level documents**,
- establish **clear structure** for what these documents are (and are not),
- link documents **across all projects** via `.cursorrules` and workspace references.

No new boundaries were created during this phase — only discovery and inventory.

---

### Phase 2 — Consolidation and Principle Extraction

The second phase focused on consolidating scattered documentation into authoritative boundary documents.

For each architectural area, the consolidation process involved:

- **extracting principles** from multiple sources (Confluence, project docs, implementation plans),
- **removing implementation details** (code examples, stack-specific references),
- **generalizing terminology** to be cross-stack applicable,
- **establishing non-negotiables** (hard constraints that must be rejected in review),
- **defining allowed vs forbidden zones** (clear boundaries for where patterns apply),
- **cross-referencing** related boundaries to ensure cohesion.

The consolidation produced **6 authoritative boundary documents**:

1. **`auth-boundaries.md`** — Authentication provider boundaries, Cognito isolation, internal `userId` only
2. **`multi-tenancy-boundaries.md`** — Tenant isolation, organisation scoping, access policies
3. **`organisation-user-boundaries.md`** — Organisation types, user profiles, profile ↔ organisation validation
4. **`module-communication-boundaries.md`** — Event-driven patterns, circular dependency rules, async over sync
5. **`quality-security-boundaries.md`** — Automated enforcement, CI as authority, security gates
6. **`README.md`** — Repository structure, document purpose, LLM guidance

Each document followed a consistent structure:

- **Purpose** — Why this boundary exists
- **Core Model** — Foundational concepts
- **Non-Negotiables** — Hard constraints (violations = rejected in review)
- **Allowed vs Forbidden Usage** — Clear zones
- **Responsibility Boundaries** — Conceptual flow (no code)
- **Related Boundaries** — Links to other boundary documents
- **Ownership** — CTO-owned, non-negotiable

All documents were:

- **principle-level** (not implementation details),
- **cross-stack** (no code, no stack-specific references),
- **authoritative** (source of truth),
- **succinct** (no fluff).

---

### Phase 3 — Cross-Project Linking and Integration

The third phase focused on linking the authoritative documents to all projects and ensuring they were accessible to both humans and AI tools.

This included:

- **updating `.cursorrules`** in all projects to reference the cross-stack architecture repository,
- **recommending local indexing** of the architecture repository for AI tools (Cursor),
- **cross-referencing** workspace implementation plans to authoritative boundaries,
- **validating** that workspace documents correctly referenced architecture documents as source of truth,
- **ensuring** all projects could access the boundaries during development.

The linking strategy ensured:

- **immediate accessibility** — developers and AI tools could reference boundaries during coding,
- **single source of truth** — all projects reference the same authoritative documents,
- **consistent guidance** — same principles apply across all projects,
- **AI-friendly** — documents structured for LLM consumption (clear structure, no ambiguity).

---

### Phase 4 — Alignment Validation and Gap Analysis

The fourth phase focused on validating that the consolidated boundaries aligned with existing implementation plans and identifying any gaps.

The validation revealed:

- **perfect alignment** between workspace documents and architecture boundaries,
- **all critical tech debt** addressed by boundaries (multi-tenancy, Cognito, circular deps),
- **some gaps** where tech debt items weren't covered (god objects, type safety, API versioning),
- **missing boundary documents** suggested by tech debt (code quality, API, infrastructure, observability).

---

### Phase 5 — Tech Debt Directional Analysis

The fifth phase confirmed that boundaries effectively guide engineers away from known technical debt.

The analysis produced:

- **directional alignment assessment** (Grade: A- 88/100),
- **coverage gaps** documented for future boundary documents,
- **recommendations** for enhancing existing boundaries,
- **roadmap** for missing boundary documents (code quality, API, infrastructure, observability).

---

### Phase 6 — Documentation Structure and LLM Optimization

The sixth phase optimized documentation for both human developers and AI tools.

From this point:

- **AI tools** can read and apply boundaries during coding,
- **Developers** have clear, authoritative guidance,
- **New boundary documents** can be created following established structure,
- **Documentation** remains stable and principle-level.

---

## Result

After ~2 months:

- **6 authoritative boundary documents** in dedicated GitHub repository,
- **Complete alignment** between governance and implementation documents,
- **Cross-referenced** and cohesive documentation structure,
- **Linked to all projects** via `.cursorrules` and workspace references,
- **Validated against tech debt** to ensure boundaries guide engineers away from known issues,
- **AI-optimized** structure for LLM consumption,
- **Zero disruption** to ongoing development,
- **Immediate usability** — boundaries accessible during coding and code review.

The system evolved from **scattered architectural knowledge** to **unified cross-stack governance** while remaining continuously operational and immediately actionable.

---

## Closing Note

This case illustrates how architectural governance can be established systematically across multiple projects and tech stacks, even when knowledge is fragmented across multiple sources, through careful consolidation, principle extraction, cross-project linking, and validation against existing implementation and tech debt.

Architectural boundaries must be authoritative, principle-level, and immediately accessible to both humans and AI tools. When boundaries are scattered, implicit, or implementation-focused, they fail to guide engineering decisions effectively. When boundaries are consolidated, explicit, and principle-level, they become a force multiplier for architectural consistency and technical debt prevention.
