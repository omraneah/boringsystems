---
title: "The SaaS Authentication Stack Operators Keep Treating as One Decision"
description: "A field guide for B2B SaaS operators: the functional layers behind 'auth,' how requirements shift by market segment, and what goes wrong when you collapse them into one."
date: 2026-05-01
highlight: false
order: 7
---

## The decision every operator gets right — and what comes after it

The first auth decision most operators get right is this: don't own passwords. Don't become an Identity Provider. Don't build the cryptographic infrastructure, the credential storage, the breach-response machinery, the MFA flows. Outsource that risk to a specialized third party. The tools exist, the protocols are standardized, and there is no competitive advantage in rolling your own.

That decision cascades correctly into the first implementation call: use a managed authentication service. AWS Cognito, Firebase Auth, Supabase Auth — any of these handles credential verification and token issuance. The IdP layer is solved. Move on.

The problem starts with what comes next.

Because auth isn't one layer — it's several. And once the first layer is correctly delegated, the remaining ones still need explicit answers. Most operators don't give those answers. They let the first vendor expand by default. Or they ship the first layer and name nothing else, then discover the missing structure during a procurement call for an enterprise deal.

This is the guide for making those decisions before they get made for you.

---

## What "auth" actually bundles together

"Auth" is shorthand for a stack of distinct functional layers. These layers are real regardless of which vendor or protocol you use — they describe *roles*, not products. One vendor often fills multiple roles, which is exactly what creates the confusion.

### Identity Provider (IdP)

The system that authenticates users — proves this person is who they claim to be. It holds or federates credentials, runs multi-factor verification, and issues signed assertions to downstream systems: a SAML response or an OIDC token.

In B2C and SMB contexts, the IdP is usually under your control. AWS Cognito or Firebase Auth for email/password users, Google or Apple for social login. You're either running a managed IdP service or delegating to one.

In B2B enterprise contexts, the IdP belongs to the buyer. Their Okta tenant, their Microsoft Entra ID, their Keycloak instance — that's the authority. When an employee logs into a tool their company bought, they authenticate against the company's IdP, not yours. The SaaS doesn't hold credentials for those users. It trusts assertions from an IdP it doesn't run.

That distinction — who runs the IdP — is the first axis of every auth architecture decision.

### Identity broker

The layer between your application and the buyer's IdP. When you have multiple enterprise customers, each with their own IdP, each running their own SAML or OIDC configuration, the broker normalizes that complexity into one API your backend talks to.

This layer recently got a name. The pattern is sometimes called a federation broker in academic identity literature, but the term identity broker — or just auth broker — became operator language around 2022, when purpose-built products emerged to solve it. Before that, teams built this layer themselves and called it "the SAML integration," which understates what it actually involves.

The broker problem is: N customer IdPs × M protocols (SAML 2.0, OIDC) × per-customer configuration × a self-service admin portal for each customer's IT team. That's not a JIRA ticket. It's a full-time engineering investment that compounds with every enterprise customer you add. WorkOS, Stytch B2B, and SSOReady exist because the industry converged on "this layer is worth buying."

| Vendor | SAML | OIDC | SCIM | Admin portal | Model |
|---|---|---|---|---|---|
| **WorkOS** | ✓ | ✓ | ✓ | ✓ | Paid — per-connection |
| **Stytch B2B** | ✓ | ✓ | ✓ | ✓ | Paid |
| **Frontegg** | ✓ | ✓ | ✓ | ✓ | Paid — bundled app-layer features (RBAC UI, etc.) |
| **Auth0 (Okta CIC)** | ✓ | ✓ | ✓ | ✓ | Paid — broad feature set, mature, expensive |
| **Clerk** | ✓ | ✓ | Partial | ✓ | Paid — B2C origins, enterprise SCIM maturing |
| **SSOReady** | ✓ | ✓ | ✓ | ✓ | Open-source / self-hosted |
| **Keycloak** | ✓ | ✓ | ✓ | ✓ | Open-source / self-hosted — full ops burden |

The broker is not the same as the IdP. The broker doesn't own identity — it federates to IdPs that do. Conflating them is one of the most expensive auth mistakes: treating a broker as a user database, then discovering the coupling when you need to migrate.

### Token verification

How your backend verifies identity on every API request.

The correct pattern is local cryptographic verification: parse the JWT from the Authorization header, check the signature against the issuer's published public keys (fetched once, cached — that's what JWKS is for), validate the standard claims. This is a local operation. It costs microseconds. Zero network calls in steady state.

The common anti-pattern is calling the auth provider on every request to validate the token — invoking the auth service's user-lookup API for each incoming call. This adds up to 300ms to every authenticated request, consumes the auth provider's API rate limits, and makes your application's availability dependent on the provider's uptime for every user, every endpoint, at every second of the day. It runs silently in development and surfaces under load.

AWS publishes `aws-jwt-verify` specifically because this mistake is widespread enough to warrant an official library fix. The pattern is documented: validate tokens locally, using JWKS.

Your backend verifies tokens. The auth provider issues them, once, at login.

### User management

Your database. Not the auth provider's.

The auth provider authenticates the user and hands you a verified identity claim — an email, a stable identifier, a name. What your application does with that identity is entirely your domain: which tenant they belong to, what roles they hold, what permissions they have, what their profile looks like, what data they own.

The failure mode is letting the auth provider's user identifier become your application's primary user ID. Booking records reference the provider sub. Payment rows carry the provider's identifier. Activity logs, API contracts, event handlers — the provider's ID is in all of them. Months later, when you add enterprise SSO, migrate providers, or clean up your authorization model, you find that what should have been a narrow integration point has become the structural backbone of the data model. The migration cost is measured in engineering-months.

Own your user ID. It's generated by your system, lives in your database, and is stable across auth provider changes. The provider's identifier is stored once, as an external reference. Your domain never depends on it.

The full account of what this coupling looks like in a live platform — how provider identifiers accumulate across domain modules and the systematic separation that resolved it — is documented in [Untangling Auth Layer Boundaries in a Running System](/en/work/untangling-auth-layer-boundaries-in-a-running-system/).

### User provisioning (SCIM)

Account lifecycle management. This layer runs on a different protocol at a different moment: not "who is logging in right now" but "who should have access, and is their access synchronized with the buyer's HR and IT systems."

When someone joins a company, their account should exist in the tools the company bought before they show up on day one. When someone leaves, their access should be revoked everywhere the moment they're offboarded in the HR system — not when they try to log in, not when an IT admin remembers to remove them.

SCIM 2.0 (System for Cross-domain Identity Management) is the protocol that handles this. The buyer's identity provider pushes lifecycle events — user created, updated, deactivated — to an endpoint your application exposes. Your application processes them and keeps access synchronized.

Just-in-time (JIT) provisioning — creating a user account on first SSO login — is an acceptable fallback for SMB customers and the first handful of enterprise accounts. It fails at scale because it cannot deprovision, cannot pre-provision, and cannot sync group membership changes in real time. 

### Session management

The "you're still logged in" layer. Short-lived access tokens, refresh token rotation, configurable session timeouts, forced logout, concurrent session limits. Enterprise IT teams want this configurable per tenant: short sessions for security-sensitive environments, longer sessions where productivity matters, forced re-authentication after a credential change.

### Authorization

Who can do what, in what context. Your roles, your permissions, your business rules. This layer lives entirely in your application — in your database and your backend logic.

The auth provider proves identity. Your application decides what that identity is allowed to do.

This separation matters because the authorization model evolves independently of the authentication model. Roles change as the product grows. Permission logic gets more nuanced. If roles are stored in the auth provider's custom claims or metadata, every role change propagates through JWT semantics instead of a database update. The cleanup is disproportionate to the convenience that created it.

---

## How the requirements change by market

The right answers at each layer depend on who you're selling to.

| Layer | B2C | B2SMB (≤50) | B2B mid-market | B2B enterprise | Regulated |
|---|---|---|---|---|---|
| **Identity Provider** | Managed IdP or social login | Google / Microsoft OIDC + managed IdP | Mix of managed + buyer's corporate IdP | Buyer's IdP is the authority | Buyer's IdP mandatory; self-hosted (Keycloak) in sovereign/regulated contexts |
| **Identity broker** | Not needed | Not needed | Optional — one or two enterprise accounts manageable manually | Required — more than a few customers makes in-house multi-tenant SAML permanent overhead | Required; often self-hosted broker |
| **Token verification** | Local JWKS — always | Local JWKS — always | Local JWKS — always | Local JWKS — always | Local JWKS + immutable audit trail |
| **User management** | Your DB — always | Your DB — always | Your DB — always | Your DB — always | Your DB — always |
| **Provisioning** | Not needed | JIT is enough | JIT acceptable; SCIM for larger accounts | SCIM required | SCIM required + audit-grade logging |
| **Session management** | Basic | Configurable | Per-tenant configurable | Per-tenant: timeout, force-logout, concurrent limits | Strict controls; often compliance-mandated |
| **Authorization** | Simple | Role-based | RBAC, tenant-aware | Tenant-aware RBAC, attribute-based controls | Fine-grained; sometimes external policy engine |

Three things from this table that surprise operators most often:

**SSO is a procurement gate, not a feature request.** Enterprise buyers cannot manage credentials centrally and offboard employees cleanly without SSO support from every connected SaaS. "We don't support it" translates directly to "we can't be on your approved vendor list." The threshold doesn't scale with headcount — a 30-person team inside a 50,000-person bank needs SSO because the parent organization's IT policy mandates it for all third-party tools.

**SAML is not deprecated.** OIDC is the modern protocol — JSON, REST-native, works with mobile and APIs. SAML 2.0 is the 2005 standard — XML, browser-mediated, heavier to integrate. New SaaS integrations default to OIDC where buyers accept it. Enterprise IT teams with legacy infrastructure, compliance auditors, and regulated industries often require SAML specifically. Any team selling to enterprise needs to support both. "OIDC only" closes the deal on technical grounds and reopens it on a SAML request six months later.

**SCIM becomes a hard gate above mid-market.** Manual deprovisioning fails compliance audits. SOC 2 Type II requires evidence of timely access removal. SCIM is that evidence. JIT provisioning solves the "create on first login" problem; deprovisioning is the half that IT security teams actually require for audit.

---

## What to delegate, what to own

| Layer                  | Decision                                               | Principle                                                                                                                                                                                      |
| ---------------------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Identity Provider**  | Delegate                                               | Never implement credential storage. Choose based on your market: consumer-grade managed IdP for users who don't bring their own; defer to the buyer's corporate IdP for enterprise.            |
| **Identity broker**    | Delegate once N > a few enterprise customers           | The N-IdPs × M-protocols matrix is a full-time engineering problem that compounds with each customer. Purpose-built brokers exist because building in-house is permanent operational overhead. |
| **Token verification** | Own — a couple of hundred lines using a vetted library | Local JWKS verification with a library. The provider is not in your API hot path.                                                                                                              |
| **User management**    | Own — always                                           | Your user table, your IDs, your schema. The provider's identifier is a foreign reference, not your primary key.                                                                                |
| **Provisioning**       | Delegate via broker or build the SCIM endpoint         | The protocol is standardized; the hard part is the customer admin self-service UI. Brokers handle this; building in-house requires owning that surface.                                        |
| **Session management** | Build with a library                                   | Short-lived access tokens, refresh rotation, per-tenant configurable timeout.                                                                                                                  |
| **Authorization**      | Own; scale to a policy engine when complexity warrants | Start with RBAC in your database. Add an external policy engine if your access control rules become complex enough to need independent testing.                                                |

The broker decision is where the math changes most visibly as you scale. One enterprise customer: wire up SAML manually. Three customers: three configurations, three certificate rotations, three IT support threads. Ten customers: you've built the broker layer yourself, under pressure, without the tooling. At two or three enterprise deals a quarter, the per-connection cost of a purpose-built broker is a rounding error against the engineering time required to build and operate the same thing in-house — plus the organizational risk of that engineering time being a permanent commitment.

---

## The decision before it's made for you

Auth decisions are cheap when made early. The layers are clear, the protocols are standardized, and the tooling is mature. Every layer in this stack has a well-understood failure mode, a well-understood fix, and a well-understood point where the wrong choice becomes expensive to reverse.

The mistake isn't picking the wrong vendor. It's not naming the layers at all — letting each one default to "also the auth provider," then discovering the boundaries when evolution pressure makes refactoring expensive.

The founding call — don't own passwords — is correct and cascades correctly through every layer. Apply it all the way down.

---

The separation-of-concerns principle underneath every call in this guide — each layer owns one responsibility, violations are defects not opinions — is formalized in *[Engineering Practice Boundaries — One Bar for Engineers and AI](/en/writing/engineering-principles-that-outlive-the-stack)*. The question of who holds technical judgment for these decisions at an early-stage company is addressed in *[Does Your Early-Stage Startup Actually Need a CTO?](/en/writing/does-your-startup-need-a-cto)*. And the organizational pattern for keeping these boundaries explicit and enforceable as the system grows — so future decisions and future engineers inherit clear constraints — is in *[Establishing Cross-Surface Architecture Governance](/en/work/architecture-governance)*.
