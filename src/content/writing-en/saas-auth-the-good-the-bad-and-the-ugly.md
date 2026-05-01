---
title: "SaaS Auth: The Good, the Bad, and the Ugly"
description: "A field guide for operators building B2B SaaS — what auth actually is, the failure modes that bite hardest, and when to delegate instead of build."
date: 2026-05-01
highlight: false
order: 7
---

## The Stripe Analogy Nobody Applies to Auth

Nobody builds their own payment gateway. When your product needs to accept money, you reach for Stripe, Adyen, or Braintree. The reasoning is obvious: the risk of getting it wrong is asymmetric, the implementation complexity is non-trivial, and the tooling to delegate it is already there.

Auth doesn't get the same respect.

Most operators treat it as a checkbox — "user login, some roles, whatever the cloud provider offers, done" — and move on. It works well enough, until it doesn't. By then, the auth provider's identifiers are embedded in every corner of the system, the enterprise deal is blocked because you can't support the buyer's Okta setup, and the refactor to fix it takes months, not days.

This is the field guide for making that decision consciously — before the technical debt makes it for you.

---

## What Auth Actually Is

Most operators conflate three distinct systems under the word "auth." Keeping them separate is the foundation of every good decision below.

**Authentication (AuthN)** — proving identity. The auth provider's job: verify a credential (password, MFA code, SSO assertion from a corporate identity provider) and issue a signed token. This is where Cognito, Firebase Auth, and Auth0 live.

**Authorization (AuthZ)** — deciding access. The backend's job: check the token, look up roles and permissions in your own database, enforce business rules. Who can do what, in which context, under which conditions.

**User management** — the lifecycle. Creating accounts, updating profiles, assigning roles, deprovisioning when someone leaves. Partially your platform's responsibility, partially the enterprise buyer's identity provider — depending on how far up market you operate.

Why this matters: auth providers are built to do AuthN well. When you lean on them for all three, you create a coupling that compounds silently. The provider's identifiers become embedded in your domain logic. Your authorization model depends on data living in a black box you don't control. The user lifecycle happens through the provider's console instead of your own backend.

It works. Until you need to change any of it.

---

## The Failure Modes

### The Bad

**Using the auth provider as your user database.**

The provider issues an identifier — a `sub` claim, a Cognito user ID. It's right there in the JWT. You start using it everywhere: booking records, payment rows, activity logs, API contracts. Months later, you want to add enterprise SSO, or swap providers, or clean up your authorization model. You find the provider's identifier in 25 modules, database columns, event handlers, and mobile app payloads. What should be a narrow integration point has become the structural backbone of the system. The migration ahead is now measured in engineering-months.

**Provider IDs leaking into business logic.**

Same root cause, different surface. A booking entity has a `cognito_user_id` column. A payment record carries the provider's identifier. GPS events route by the auth provider's user key. Authentication and domain logic are now semantically coupled — not at the boundary where it's intentional, but throughout the system where it's invisible. These aren't bugs. They accumulate as normal development decisions made without a clear rule. The cleanup, when it eventually happens, is not a hotfix.

**Using auth provider groups for roles.**

Cognito groups, Auth0 app_metadata — these seem like a reasonable place to mark "this user is a driver, that one is an admin." The problem: your roles now live in a black box you don't fully control, access decisions depend on data outside your own database, and there's no authoritative source of truth your own code owns. Roles belong in your database, derived from your own domain model. The auth provider proves identity. That's where its authority ends.

### The Ugly

**Coupling every API request to the auth provider's network.**

It feels like the right way to validate a token: call the source of truth on every request. In practice, you've added a synchronous external network call to every authenticated request in your application — 50–150ms of latency, a provider rate limit that becomes your rate limit, and an availability dependency where any Cognito degradation affects every user, every endpoint, every time. The correct pattern is local JWT verification: check the signature against cached public keys, no network call. This is a local cryptographic operation. It costs nanoseconds, not milliseconds. If nobody on the team knew this was wrong, it runs silently in production until load exposes it.

**No ceiling plan.**

Every auth provider has a ceiling. AWS Cognito handles consumer-scale identity well. Multi-tenant enterprise SSO, it handles badly — no native organization model, no self-service admin portal for enterprise IT admins, per-customer configuration that requires custom code to wire up. If your roadmap includes selling to large organizations, and your auth layer was designed for something else, there is a migration in your future. Planning for it early costs almost nothing. Discovering it during an enterprise procurement conversation costs a lot more.

---

## What Your SaaS Actually Needs

Auth requirements diverge significantly by who you're selling to.

| Market | AuthN | Enterprise SSO | SCIM |
|---|---|---|---|
| B2C / consumer | Email, social login | No | No |
| B2SMB (≤ 50 employees) | Email + Google/Microsoft OIDC | Sometimes | Rarely |
| B2B mid-market | SSO optional | Yes for larger accounts | On demand |
| B2B enterprise (1000+ employees) | SSO mandatory | Yes, table stakes | Expected |
| Regulated / sovereign | SSO + audit logs + compliance | Yes, often self-hosted IdP | Required |

The jump from "SSO optional" to "SSO mandatory" surprises most operators. It is not a feature request. It is a procurement checkbox. Enterprise organizations cannot centralize credential management and offboarding without every connected SaaS supporting SSO. When you say you don't support it, you're saying you can't be on the approved vendor list.

One edge case worth noting: some enterprise buyers are small in headcount — a financial department, an operations unit, ten users total. But they sit inside a large organization with an IT policy that mandates SSO for all third-party tools. The enterprise context doesn't scale with user count. It scales with the procurement process. Five users inside a major bank still need SSO.

---

## The Protocol Primer

You don't need to implement these. You need to know what you're buying.

**SSO (Single Sign-On):** The concept — one login grants access to multiple applications. Users authenticate once against their company's identity provider; every connected tool accepts the result. For the buyer: employees use their company account, IT controls access centrally, offboarding is immediate.

**SAML 2.0:** The dominant enterprise protocol. XML-based, browser-bound, requires exchanging metadata between your app and the customer's identity provider. Heavy to configure manually, but every enterprise IT team knows it. The default expectation on enterprise procurement questionnaires.

**OIDC (OpenID Connect):** The modern protocol — JSON/JWT-based, lighter to integrate, works with APIs and mobile apps. Modern enterprise identity providers (Okta, Microsoft Entra) support both SAML and OIDC. Social login ("Sign in with Google") is also OIDC. The direction of travel for new integrations.

**SCIM:** Not auth — user lifecycle management. Your app exposes a SCIM endpoint; the customer's identity provider pushes create/update/deactivate events when their HR or IT systems change. When someone is terminated, SCIM propagates that to every connected SaaS automatically. JIT provisioning (creating a user record on first login) is the pragmatic alternative for early enterprise customers — good enough until procurement questionnaires start requiring SCIM explicitly.

---

## The Decision Matrix

| Approach | Enterprise-ready | Ops burden | Migration risk | Best when |
|---|---|---|---|---|
| Simple managed auth (Cognito, Firebase) | Partial | Low | High if extended too far | Early stage, B2C, or B2SMB |
| Extend Cognito for SSO | Partial (painful at scale) | Medium | High | Few enterprise customers, already AWS-native |
| Auth0 / Okta | Yes | Low | Medium | Existing Okta ecosystem; complex requirements |
| Auth broker (WorkOS, Stytch) | Yes | Low | Low | Selling to enterprises, team too small to own auth ops |
| Self-host (Keycloak) | Yes | Very high (0.25–1 FTE ongoing) | Low | Data sovereignty mandate, regulated environments |
| Build fully custom | Depends | Very high | Full control | Auth engineering capacity and specific requirements |

The analogy holds again: Stripe exists not because payment processing is impossible to build, but because most teams are better off delegating it. The same logic applies to auth at the enterprise tier. An auth broker at $125 per enterprise connection per month is a rounding error relative to the cost of a stalled enterprise deal because you couldn't support SAML in time.

---

## Tool Comparison

| Tool | SAML/OIDC | SCIM | Self-hosted | Pricing model | Best for |
|---|---|---|---|---|---|
| **WorkOS** | Yes | Yes | No | Per-connection ($65–$125/mo) | Series A–C SaaS, clean enterprise sales motion |
| **Stytch B2B** | Yes | Yes* | No | MAU + per-connection; 5 free | Early-stage, validating enterprise demand |
| **Auth0 (Okta)** | Yes | Yes | Enterprise plan only | MAU + plan tier; steep cliff after 5 connections | Existing Okta ecosystem or complex hybrid needs |
| **Frontegg** | Yes | Yes | No | MAU + features; free tier (5 connections) | Teams shipping a self-service tenant admin portal |
| **Clerk** | Yes | No | No | Per-connection ($15–$75/mo) | Developer/PLG products; not ready for Fortune 500 |
| **SSOReady** | Yes | Yes | Yes (Apache) | Free core; custom enterprise | Regulated environments, cost-sensitive, open-source |
| **Keycloak** | Full IdP | Yes | Yes (required) | Free OSS; Red Hat build available | Government, EU data sovereignty, air-gapped |
| **AWS Cognito** | As SP only | No native | AWS-hosted only | MAU-based ($0.015/MAU SAML) | AWS-native teams, small number of enterprise customers |

*Stytch SCIM GA status: verify before committing.

**One note on Clerk:** no SCIM support as of early 2026. When an employee is removed from Okta, your app isn't notified. That's a gap most enterprise IT security questionnaires catch.

**One note on Auth0:** the pricing cliff is real. After your fifth enterprise SSO connection on the Professional plan, the next customer requires a custom enterprise contract. Real-world quotes at this tier have been documented in the $30K+/year range for small user counts.

---

## The Judgment Call

If your entire market is B2C or SMB and enterprise is three years out: use whatever is simplest. Don't over-engineer early. Cognito, Firebase Auth, a clean JWT implementation — any of these are appropriate for this stage. The mistake at this phase is over-investing in auth infrastructure you won't need for years.

If you're selling to enterprises today — even to small teams inside large organizations — the question is not whether to support SSO. It's which layer handles the protocol complexity so your team doesn't have to. For most teams under 20 engineers, that means delegating. The cost of owning multi-tenant IdP configuration, per-customer certificate management, and SCIM endpoint maintenance is a permanent operational overhead. The auth broker cost is predictable, bounded, and offloads the security surface to a team whose entire job is auth.

If data sovereignty is a constraint — regulated industry, government buyer, EU residency requirement — the calculus shifts toward self-hosting (Keycloak) or a specialized open-source option (SSOReady). The ops burden is real, but the alternative may not be available.

---

## Make the Decision Before It's Made For You

Nobody waits until they're processing their first transaction to decide whether to use Stripe. The payment architecture is part of the product design from the start, because the cost of getting it wrong is immediately visible.

Auth doesn't break immediately. It breaks when you need to evolve — new enterprise requirement, new provider, new market. And at that point, the cost isn't the implementation. It's the untangling of every pragmatic choice made under pressure, before anyone thought it would matter.

The decisions are simple when they're made early. The tooling is mature. The options are clear.

Make the call before the enterprise procurement questionnaire makes it for you.
