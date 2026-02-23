---
title: "Breaking Vendor Lock-In in a Live Production System"
description: "A real-world migration off a black-box mobility platform — 18 months, zero downtime, 10x scale."
pubDate: "2025-01-01"
featured: true
order: 1
---

# Breaking Vendor Lock-In in a Live Production System
A real-world migration off a black-box mobility platform.

---

## Context

I joined an early-stage, VC-backed tech mobility company as its first technical leader.

The company operated daily transportation services using a third-party Transportation Management System (TMS).
This system was white-labeled at the interface level only.

The provider:

- did not provide access to source code,
- did not provide access to databases,
- did not provide infrastructure control,
- did not provide technical documentation,
- did not allow customization beyond standard client configuration.

The company interacted with the platform only through the same interfaces available to any external client.

Internally, the company managed routes, drivers, customer support, and operations, but did not own or control the software systems enabling those activities.

The vendor system was therefore:

- operationally usable,
- technically opaque,
- and structurally rigid with respect to the company's specific use cases.

At the time I joined, the organization had no internal technical DNA.
The focus was entirely operational and business-driven, with no existing engineering culture, internal systems ownership, or long-term technical roadmap.

The company was positioning itself as a growth-oriented technology platform, with the objective of owning its technology as a differentiating asset over time.

---

## Scale at Entry

At the beginning of the transition:

- ~10 bus lines
- ~100 daily riders

By the end of the migration:

- 100+ bus lines
- ~1,000 daily riders

The system scaled during the in-housing effort.

---

## Constraints

- Live production system with daily bookings
- No acceptable downtime
- No acceptable data loss
- No access to vendor source code, databases, or infrastructure
- No vendor-side customization or documentation
- No internal backend or infrastructure to extend
- Engineering team hired from scratch:
	- 5 engineers total
	- new country, new hiring market
	- budget constrained to one senior engineer initially
- No dedicated infrastructure or operations engineering roles

The system could not pause.
The organization could not absorb shock.

---

## Objective

Progressively internalize the core technical stack while maintaining uninterrupted operations.

The effort was treated as sequenced in-housing, not a rewrite.

---

## Execution Overview

The transition unfolded over ~18 months through incremental steps, each designed to reduce dependency without increasing operational risk.

---

### Phase 1 — System, Business, and Landscape Understanding

The first phase focused on building a complete understanding of the environment before making structural changes.

This included:

- analyzing how the third-party TMS was used in practice,
- identifying rigidity points caused by the lack of customization,
- understanding the business model and go-to-market strategy,
- reviewing fundraising materials and positioning,
- studying the competitive landscape to understand:
- what comparable players owned internally,
- what they outsourced,
- and how platform ownership evolved as they scaled.

Because no code, data, or documentation was accessible from the provider, this analysis was necessarily external and behavioral, based on:

- system outputs,
- operational workflows,
- and observed constraints.

Based on this analysis, the decision to progressively in-house the platform was made and sequenced.

No development occurred during this phase.

---

### Phase 2 — Owning the Rider Application

The first system to be rebuilt internally was the rider mobile application.

Although the backend logic and data remained external at this stage, this was the first part of the stack to become fully owned by the company.

This served two purposes:

- establishing internal ownership over a production-critical surface,
- creating early internal momentum by demonstrating that ownership was possible without disrupting operations.

The application remained compatible with the external provider interfaces (API endpoints).

---

### Phase 3 — Internal Authority Over Identity, Users, and Access

Internal backend services were introduced for:

- authentication,
- authorization,
- user management,
- booking creation.

From this point:

Users were created internally first, then propagated to the external TMS through its API.

Authentication and authorization decisions were made internally first, then validated again on the provider side to satisfy legacy execution constraints.

Bookings followed the same pattern:

- created internally,
- then created on the provider system for execution.

Internal systems replicated:

- the data layer,
- and the business logic inferred from observed behavior of the external platform.

The provider system continued to execute operational flows, but internal systems became authoritative for identity, user state, and access control.

Payments, wallets and promotion logic were subsequently internalized.

This resulted in:

- internal authority over identity, users, access control, and pricing,
- mirrored state and logic across internal and external systems,
- progressive reduction of dependency without disrupting operations.

---

### Phase 4 — Progressive Internal Adoption

Internal capabilities were exposed to teams incrementally using lightweight internal tooling.

Adoption followed a staged sequence:

- customer support,
- operations,
- broader internal teams.

This minimized friction and avoided forcing workflow changes prematurely.

Custom back-office interfaces were introduced only after internal usage patterns stabilized.

---

### Phase 5 — Parallel Operations for Core Operational Modules

Operational modules were migrated using parallel execution.

This included:

- stops,
- line and trip management,
- supply and supplier management,
- driver-related operational logic.

Two systems ran simultaneously:

- the internal system,
- the external TMS.

Routing rules determined which system handled a given request based on context and operation type.

Modules were migrated only once they could be unplugged without fallback.

---

### Phase 6 — Driver Application In-Housing

The driver application was rebuilt after identity, authorization, booking, payment, and operational logic were already internalized.

This removed the final externally dependent surface of the platform.

---

## Result

After ~18 months:

- full ownership of rider and driver applications,
- full ownership of identity, authorization, booking, payment, and operational logic,
- dependency on the external TMS removed progressively,
- zero downtime throughout the transition,
- zero data loss,
- operations scaled from ~10 to 100+ bus lines and from ~100 to ~1,000 daily riders without increasing operational cost.

The system evolved from reliance on an opaque third-party platform to an internally owned, interoperable ecosystem while remaining continuously operational.

---

## Closing Note

This case illustrates how technical sovereignty can be established incrementally under live operational constraints even when no vendor code, data, or documentation is accessible, through careful sequencing, parallel systems, and controlled exposure.
