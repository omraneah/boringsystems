---
title: "Untangling Auth Layer Boundaries in a Running System"
description: "A three-phase account of separating conflated auth layers in a live platform — from provider-entangled domain model to clean layer boundaries and an enterprise-ready federation path."
date: 2026-05-01
featured: true
order: 6
---

## Context

The founding principle was right: don't own passwords, don't become an Identity Provider. Delegate credential verification to a managed service — absorb none of the cryptographic risk, none of the breach-response complexity, none of the compliance surface. That decision was made correctly, under pressure and constraint, and it held.

What wasn't specified was everything else.

The auth stack has more than one layer. There is the Identity Provider — the system that authenticates users and issues signed assertions. There is the identity broker — the layer that normalizes federation across multiple upstream IdPs. There is the token verification layer — how the backend confirms identity on every API request. There is user management — the platform's own database, domain model, and user IDs. There is user provisioning — account lifecycle, separate from authentication. There is session management — maintaining authenticated state across requests. There is authorization — who can do what.

None of those layers were named. So by default, they became the IdP's responsibility. Not by design — by gravity. The managed cloud identity service was there, it had APIs, and the team used them. The provider's user identifier became the platform's user identifier, embedded across domain objects. Token validation called the provider on every API request. Authorization state was partially stored in the provider's custom attributes. The integration point that should have been narrow had become a load-bearing dependency across every domain module.

Each of these was a defensible call in isolation, made under velocity pressure during a critical transition. The problem wasn't any individual decision. It was the absence of a model that defined the layers as distinct, assigned each an owner, and made boundary violations rejectable.

This is the account of how that got fixed — and how the enterprise authentication path was built on clean foundations afterward.

---

## Constraints

The work ran under standard operating constraints for this type of platform work:

- live production, continuous delivery, no scheduled downtime
- feature delivery that could not stop
- a small team with limited parallel capacity
- provider-specific identifiers and logic across every domain module: booking, payment, wallet, user management, driver operations, GPS, line management, back office, mobile application

The coupling could not be resolved through a rewrite. It had to be treated progressively, one boundary at a time, without disrupting delivery.

---

## The three layer violations

Before any cleanup, the first task was naming which layers were doing whose job. Cleanup that begins without a clear model produces movement without progress.

Three violations were mapped:

**The IdP's identifier in the domain layer.** The auth provider's internal user ID — a token-issued claim — had become the canonical user identifier across all domain objects. Every booking record, payment row, activity log, and API contract referenced the provider's identifier. This was an IdP-layer construct embedded in the user management and domain layers. The provider was acting as the platform's user database — not by decision, but because no other decision had been made.

**Token verification on the API hot path.** The token verification layer was calling the auth provider's API on every incoming request. Every authenticated API call — page loads, button actions, data fetches — was a synchronous external network round-trip to an outside service. The effect: up to 300ms of external latency on every request, a runtime dependency on the provider's uptime for every user at every moment, and the provider's API rate limits becoming the platform's rate limits under load.

The correct pattern is local cryptographic verification: parse the JWT, check the signature against the issuer's published public keys (fetched once, cached via JWKS), validate the claims. This is a local operation with zero network calls in steady state. The provider belongs on the cold path — login — not the hot path.

**Authorization state in the wrong layer.** Roles and permission-relevant data were partially managed through the auth provider's custom attributes and group constructs. Authorization is a domain concern. Who can do what, in which context, under which tenant — that belongs in the platform's own database, derived from its own domain model. The IdP proves identity. What that identity is allowed to do is not the provider's concern.

---

## Phase 1 — Naming the debt before touching it

The first phase was a framing decision, not an implementation.

The pragmatic calls made during the platform transition were correct for that moment. Reopening the identity model under velocity pressure would have slowed the work that actually needed to move. The call was to continue, document the constraint explicitly, and commit to a defined cleanup — not an open-ended backlog item, but named debt with an owner and a scope.

That framing mattered. It meant the cleanup arrived with clear ownership and a defined stop condition, rather than as an open-ended refactoring triggered by accumulated friction.

---

## Phase 2 — Redrawing the boundaries and executing the cleanup

The second phase began once platform stability was restored.

**Rules first.** An internal platform user ID — generated by the platform, opaque to the auth provider — became the canonical user primitive across the entire system. The auth provider's identifier was confined to a single auth boundary. Any occurrence outside that boundary was classified as an architectural defect: not a code-review suggestion, not a backlog item, but a violation to be rejected.

These rules were published as architectural boundary documents placed where planning, implementation, and review already happened. This made them actionable rather than advisory.

**Programmatic enforcement.** Static analysis guardrails prevented provider-specific identifiers from crossing into domain modules undetected. A weekly tracking metric counted remaining violations across the codebase. When the cleanup has a visible number and a concrete stop condition, it finishes. When it's diffuse, it doesn't.

**Execution divided deliberately.** One senior engineer owned the structural refactoring across the core domain modules. Other contributors cleared violations they encountered in their normal delivery flow. This kept the cleanup from becoming a blocking project or concentrating on one person.

The full scope completed in approximately two months for a codebase of this size and surface area — faster than this type of structural refactoring typically moves, primarily because the model was explicit, enforcement was programmatic, and progress was tracked on a real metric.

---

## Phase 3 — The enterprise path: buyer's IdP through a broker to the platform

The third phase addressed the platform's next trajectory.

The business model required enterprise-grade authentication: integration with the identity providers that buyer organizations run, support for the protocols those organizations use, and account lifecycle management delegated to the buyer's own systems.

**The shape of B2B enterprise auth.** In a B2B SaaS context, enterprise authentication has a specific structure: the buyer's employees authenticate against the buyer's identity provider — Okta, Microsoft Entra ID, a self-hosted Keycloak instance. That provider issues a signed assertion (SAML or OIDC). The SaaS receives that assertion, verifies it, and maps it to the appropriate user record and session.

The layer between the SaaS and the buyer's IdP is the identity broker. Its function: normalize N customer IdP configurations, N protocol variants, N attribute mappings into one API. Handle the self-service admin portal so customer IT teams can configure connections independently. Abstract per-customer SAML metadata exchanges and certificate rotations. This is the multi-tenant federation problem — it compounds with each enterprise customer added. Building it in-house is a permanent operational commitment that scales poorly.

**The two options evaluated.** The managed auth service in place could support SAML and OIDC federation. But multi-tenant enterprise SSO at scale — per-tenant IdP configuration, a self-service admin portal, SCIM endpoint management across customers — required building a significant custom layer on top of it. Evaluated, rejected: this path would have recreated the broker layer, under-resourced, inside a service already carrying more responsibility than it should.

The alternative: introduce a purpose-built identity broker for new enterprise tenants, and leave the existing managed auth service in place for the internal company tenant where it works and where migration risk doesn't justify the cost.

**The resulting architecture for enterprise tenants:**

```
Enterprise employee
  → Buyer's IdP (Okta, Entra ID, Keycloak, etc.)
  → Identity broker (normalizes SAML/OIDC, manages per-tenant config, handles SCIM)
  → Platform backend (receives verified profile, issues own session token)
  → Platform database (user record, tenant, roles, permissions)
```

The internal company tenant continues on its existing path unchanged.

**Token verification stays the same pattern regardless of issuer.** Both paths issue JWTs. Both are verified locally against the issuer's published JWKS. The `iss` claim in the token determines which key set to use. Two issuers, two JWKS endpoints, one verification layer. The auth provider — whichever one — is on the cold path. The hot path is a local cryptographic check.

Account lifecycle management for enterprise tenants runs through SCIM: the buyer's identity provider pushes provisioning events to the broker, which forwards them to the platform. Join the organization: account created. Leave the organization: access revoked. No manual intervention, no drift.

---

## Result

The platform moved from a state where the auth provider's identifiers were embedded across the domain to a state with clean layer separation:

- An internal platform user ID is canonical across all domain objects
- The auth provider's identifier is an external reference, stored once, isolated to the auth boundary
- Token verification is a local cryptographic operation — no provider in the API hot path
- Authorization logic operates entirely from the platform's own data
- New enterprise tenants authenticate through an identity broker that handles multi-tenant federation without exposing that complexity to the backend
- The internal tenant continues unchanged, with a clear migration path available when the time comes

The cleanup completed the full scope in approximately two months — because the model was explicit, enforcement was programmatic, and progress was tracked on a real metric rather than managed by coordination overhead.

---

## The principle that holds

The founding call — don't own passwords, don't become an Identity Provider — was correct and cascades correctly to every layer of the stack.

The same logic applies to the identity broker: don't build the N-IdPs × M-protocols matrix in-house when the problem is already solved and the cost of building compounds with each customer.

The same logic applies to token verification: the provider issues a token once at login. Your backend verifies it locally on every request. The provider belongs on the cold path.

The failure mode isn't the wrong first decision. It's making the first decision without naming what comes after it. Each unnamed layer defaults to the vendor at hand — pragmatically, invisibly — until evolution pressure makes the cost of untangling it prohibitive.

The decision framework for when to delegate auth and how to read the ceiling of any given approach — before coupling becomes debt — is covered in [The SaaS Authentication Stack Operators Keep Treating as One Decision](/en/writing/the-saas-authentication-stack-operators-keep-treating-as-one-decision/).

The engineering principle that makes this class of problem predictable — each unit owns one responsibility, and boundary violations are defects to reject in review rather than design choices to tolerate — is dimension two of [Engineering Practice Boundaries — One Bar for Engineers and AI](/en/writing/engineering-principles-that-outlive-the-stack). The governance layer built to keep those boundaries authoritative across the platform, preventing new violations as delivery continued, is documented in [Establishing Cross-Surface Architecture Governance](/en/work/architecture-governance).

This work was executed at [Enakl](https://enakl.com) — a VC-backed B2B/B2G mobility platform serving emerging markets.
