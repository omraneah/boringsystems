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

The vendors below split into two groups. The **first group** is purpose-built for the broker layer (some have grown into full B2B auth platforms). The **second group** is generic / cloud-native auth services that operators reach for early because they're already on AWS / GCP / Supabase — they are *not* brokers, but they get treated as if they were until the first enterprise procurement call exposes the gap. We list both because the realistic decision tree includes both.

The columns are deliberately compressed: protocols (SAML / OIDC / SCIM) are baseline for the broker group with the exceptions called out per row, so we use the space for what actually changes the call — what other layers each vendor covers, the pricing shape, and when to choose or skip it. Facts current as of May 2026.

<div class="wide-table">
<table>
  <caption>Identity brokers and B2B auth platforms</caption>
  <thead>
    <tr>
      <th>Vendor</th>
      <th>Beyond brokering — what else it covers</th>
      <th>Pricing shape</th>
      <th>Choose when</th>
      <th>Skip when</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>WorkOS</strong></td>
      <td>Full IdP (AuthKit), sessions, MFA, RBAC, orgs, audit logs, buyer admin portal, fraud (Radar), KMS (Vault)</td>
      <td>AuthKit free to 1M MAU; SSO and SCIM each at $125/connection/month (volume discounts to $65)</td>
      <td>You want a clean broker that scales per enterprise deal, with the option to adopt their full IdP later</td>
      <td>You'll have a long tail of small enterprise tenants — per-connection economics get steep</td>
    </tr>
    <tr>
      <td><strong>Stytch B2B</strong> <em>(Twilio)</em></td>
      <td>Full IdP, sessions, MFA, RBAC, B2B orgs, embeddable buyer admin portal, M2M tokens, device fingerprinting</td>
      <td>Free: 1K B2B MAU + 5 SSO/SCIM connections; usage-based above</td>
      <td>You're greenfield B2B and want one vendor for IdP + broker; multi-tenant orgs from day one</td>
      <td>You're vendor-risk-averse — Twilio acquired Stytch in Nov 2025, roadmap still settling</td>
    </tr>
    <tr>
      <td><strong>Frontegg</strong></td>
      <td>Full IdP, RBAC, orgs, hosted login box and buyer admin portal, audit logs — heavily bundled</td>
      <td>Free Starter (≤5 orgs / 7.5K MAU); SSO and advanced features paid, sales-quoted</td>
      <td>You want the entire buyer-admin UI surface prebuilt and don't want to design it</td>
      <td>You want transparent pricing or a narrow integration — bundling forces UI and data-model choices</td>
    </tr>
    <tr>
      <td><strong>Auth0 (Okta CIC)</strong></td>
      <td>Full IdP, federation, sessions, MFA, RBAC, B2B orgs, audit logs, attack protection</td>
      <td>B2B Pro from $800/mo (1K MAU); separate B2C SKU; enterprise sales-quoted</td>
      <td>You're already on Okta corporate, want every feature in one place, and budget isn't the constraint</td>
      <td>You're cost-sensitive — the B2C → B2B SKU jump is ~4× for the same MAU band; enterprise runs to six figures</td>
    </tr>
    <tr>
      <td><strong>Clerk</strong></td>
      <td>Full IdP, sessions, MFA, RBAC, B2B orgs, prebuilt React UI. <em>No native SCIM as of May 2026</em></td>
      <td>Pro tier; +$50 per SAML connection or $100/mo MFA+SAML bundle; B2B add-on above 100 orgs</td>
      <td>B2C / prosumer or consumer-grade B2B with great prebuilt UI; React-first stacks</td>
      <td>An enterprise buyer demands SCIM directory sync — Clerk doesn't ship it natively</td>
    </tr>
    <tr>
      <td><strong>SSOReady</strong></td>
      <td>SAML SSO and SCIM directory sync — and nothing else. Hosted self-serve setup, custom domain, management API. Explicitly <em>not</em> an IdP</td>
      <td>Open source; cloud free forever; paid only for enterprise SLA support</td>
      <td>You already run an IdP and want to add enterprise federation cleanly, with an exit option</td>
      <td>You also need a user pool, sessions, MFA, or RBAC — out of scope by design</td>
    </tr>
    <tr>
      <td><strong>Keycloak</strong></td>
      <td>Full IdP, federation, user mgmt, sessions, MFA, realms for multi-tenancy. <em>SCIM only via community extensions, no native endpoint</em></td>
      <td>Free / self-hosted; cost is operational (clustering, DB, upgrades, monitoring)</td>
      <td>Regulated / sovereign / self-host mandatory and you have a platform team</td>
      <td>Small team without ops capacity — admin console is dense, footprint is heavy</td>
    </tr>
  </tbody>
</table>
</div>

The next table is what people actually use *before* the broker question gets named — the auth that ships with the cloud they're already on. These are not brokers. They handle the IdP role for users you own; some of them bolt on enterprise federation, but none of them solve the multi-customer admin portal or the SCIM-as-procurement-gate problem. Listing them here is what an operator actually faces: "should I just use what's already in my cloud?" The honest answer depends on where you're going.

<div class="wide-table">
<table>
  <caption>Generic / cloud-native auth services (not brokers — listed because operators conflate them)</caption>
  <thead>
    <tr>
      <th>Service</th>
      <th>Layers covered (and the gaps that matter)</th>
      <th>Pricing shape</th>
      <th>Choose when</th>
      <th>Skip when</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Firebase Auth</strong></td>
      <td>IdP (email/password, social, phone), sessions, basic user mgmt. <em>No SAML, no OIDC, no SCIM, no buyer admin portal</em></td>
      <td>Free to 50K MAU, then $0.0025 / MAU</td>
      <td>Quickest path to "users can log in" on a B2C or mobile-first product; already on Firebase</td>
      <td>Any B2B-enterprise roadmap — there is no SAML path; you'll bolt on a broker later and regret the coupling</td>
    </tr>
    <tr>
      <td><strong>Google Cloud Identity Platform (GCIP)</strong></td>
      <td>Firebase Auth engine + SAML, OIDC, MFA, multi-tenancy, SLA. <em>No SCIM, no buyer admin portal</em></td>
      <td>50 enterprise MAU free, then $0.015 / MAU</td>
      <td>You're already on GCP and need SAML for a handful of enterprise customers</td>
      <td>Buyers expect SCIM — neither tier ships it; multi-tenant admin UX is build-it-yourself</td>
    </tr>
    <tr>
      <td><strong>Supabase Auth</strong></td>
      <td>IdP (email, magic link, social, MFA), sessions; SAML SSO on Pro+. <em>No SCIM, no first-class organizations primitive</em> — multi-tenancy is RLS + JWT claims by hand</td>
      <td>Bundled with Supabase plan ($25/mo Pro+ unlocks SAML)</td>
      <td>You're already running on Supabase Postgres and need light SAML SSO for small B2B</td>
      <td>Buyer expects orgs / teams or SCIM — you'd be building the B2B layer on top of Postgres yourself</td>
    </tr>
    <tr>
      <td><strong>AWS Cognito</strong></td>
      <td>IdP (user pools), federation (SAML, OIDC, social), MFA, hosted UI, groups (not real RBAC). <em>No SCIM in user pools, no buyer admin portal</em></td>
      <td>Cheap MAU tiers; AWS-native</td>
      <td>Already on AWS, cost-sensitive, willing to build the buyer-admin surface yourself</td>
      <td>You're moving upmarket — Cognito is workforce-shaped; multi-tenant SaaS gating on SCIM is build-it-yourself</td>
    </tr>
    <tr>
      <td><strong>Microsoft Entra External ID</strong></td>
      <td>IdP, user mgmt, sessions, MFA, conditional access, SAML/OIDC; SCIM requires Entra ID P1/P2 workforce licensing</td>
      <td>MAU-based with free tier (replaces Azure AD B2C — closed to new customers May 2025)</td>
      <td>Microsoft-heavy stack selling into Microsoft-shop enterprises</td>
      <td>You want vendor-neutral DX — config leans on the Azure portal; SCIM cadence (20–40 min sync) is rough for real-time</td>
    </tr>
  </tbody>
</table>
</div>

Two patterns to notice across both tables. **The "covers everything" vendors charge for the bundle whether or not you use it.** Auth0, Frontegg, and to a lesser degree Stytch B2B and Clerk price the full platform — the broker layer is delivered alongside the IdP, sessions, MFA, RBAC, admin portal, audit logs, and so on. If you only need federation, you pay for the rest. **The narrow vendors (SSOReady, WorkOS broker-only) keep the layer separable** — at the cost of you owning the IdP and user pool. The decision between "bundle me everything" and "give me only the broker" is not really a feature comparison. It's a question of whether you want auth to be one box you stop thinking about, or one layer you keep separable so you can swap any piece later.

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

The right answers at each layer depend on who you're selling to. Two of the seven layers, though, don't vary by market: **token verification is always local JWKS**, and **user management is always your own database**. They are settled answers regardless of the row in the table below. The rest is the calibration.

<div class="wide-table">
<table>
  <thead>
    <tr>
      <th>Layer</th>
      <th>B2C</th>
      <th>B2SMB (≤50)</th>
      <th>B2B mid-market</th>
      <th>B2B enterprise</th>
      <th>Regulated</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Identity Provider</strong></td>
      <td>Managed IdP / social</td>
      <td>Managed IdP + Google/MS OIDC</td>
      <td>Managed IdP + buyer's IdP</td>
      <td>Buyer's IdP is the authority</td>
      <td>Buyer's IdP; Keycloak self-hosted in sovereign contexts</td>
    </tr>
    <tr>
      <td><strong>Identity broker</strong></td>
      <td>—</td>
      <td>—</td>
      <td>Optional (1–2 manual)</td>
      <td>Required past a few customers</td>
      <td>Required; often self-hosted</td>
    </tr>
    <tr>
      <td><strong>Provisioning</strong></td>
      <td>—</td>
      <td>JIT is enough</td>
      <td>JIT; SCIM for larger accounts</td>
      <td>SCIM required</td>
      <td>SCIM + audit-grade logging</td>
    </tr>
    <tr>
      <td><strong>Session management</strong></td>
      <td>Basic</td>
      <td>Configurable</td>
      <td>Per-tenant configurable</td>
      <td>Per-tenant: timeout, force-logout, concurrent limits</td>
      <td>Strict; compliance-mandated</td>
    </tr>
    <tr>
      <td><strong>Authorization</strong></td>
      <td>Simple</td>
      <td>Role-based</td>
      <td>RBAC, tenant-aware</td>
      <td>Tenant-aware RBAC + ABAC</td>
      <td>Fine-grained; sometimes external policy engine</td>
    </tr>
  </tbody>
</table>
</div>

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

## Your situation → your stack

The general principles above only become useful when mapped onto where you actually are. Six common operator situations, with the call:

**You're pre-PMF, B2C or SMB, on AWS or GCP.** Stack: Cognito or Firebase Auth, JWKS verification, your own user table. Stop. Don't shop for a broker. Don't migrate to Auth0 "to be ready for enterprise" — you're not selling enterprise yet, and the cost of being ready is real now while the benefit is hypothetical. The one thing you must get right is keeping your application's user IDs separate from the provider's identifier (the user-management section above).

**You're pre-PMF on a framework-native stack (Next.js, Remix, etc.) and not yet on a managed cloud.** Stack: Auth.js / Lucia / your framework's session helper, your own DB, JWKS verification when you do bring in a managed IdP. Cheaper than a managed IdP, fewer moving parts, no vendor coupling. Add a managed IdP only when you outgrow it — usually social login at scale, recovery flows you don't want to operate, or MFA enforcement you don't want to roll yourself.

**You just signed your first enterprise customer asking for SAML.** Stack: keep your existing IdP. Add a broker that does SSO and SCIM and nothing else. **SSOReady** (open source / managed) and **WorkOS broker-only** (per-connection) are the two right answers. Don't replace your IdP at the same time as adding SSO — you'd be migrating user identity and adding enterprise federation in the same sprint, and one of those is going to break. Don't pick Auth0 or Frontegg or Stytch B2B for this case unless you have a separate reason to migrate the IdP at the same time.

**You're at three or more enterprise customers and the team is rebuilding the SAML wiring each time.** This is where a broker's per-connection cost becomes a rounding error against engineering hours. **WorkOS** or **SSOReady**. If you're greenfield (no IdP yet) and the product is B2B-shaped from day one, **Stytch B2B** becomes a real option — one vendor for IdP plus broker — but be honest about the lock-in: you can't easily separate the layers later, and post-Twilio-acquisition the roadmap is in flux.

**You're in a regulated, sovereign, or compliance-heavy context.** Buyer's IdP is the authority, often non-negotiable. Self-hosted broker (**Keycloak** or self-hosted SSOReady). SCIM with audit-grade logging is a hard requirement, not a nice-to-have. The cost story flips compared to SaaS-land: engineering time on Keycloak operations is the price of admission, and there is no shortcut around it.

**You're already locked into Auth0, Frontegg, or another full platform from an earlier decision.** Don't migrate unless there's a forcing function: a cost cliff at the next tier, a missing feature your buyer requires (SCIM if you're on Clerk, real-time provisioning if you're on Entra), or an outage profile you can't accept. The sunk-cost trap is the wrong one — but the inverse trap is also real. The migration cost is the bill you'd pay to switch, and the new vendor will cause its own surprises. Migrate when the math is clear, not when the dashboard is annoying.

The pattern across all six: **the broker decision is downstream of the question "what does my next twelve months of customers look like?"** Pre-PMF, pre-enterprise, pre-procurement: the answer is "use what's in your cloud, own your user table, keep moving." Past those gates, the broker layer becomes a buy decision and the analysis above tells you which one.

---

## Ten-minute pre-procurement checklist

When an enterprise prospect's procurement or IT team asks about your auth, walk this list before answering "yes" to any of it. Most procurement disasters are one of these seven items unanswered, not a vendor choice gone wrong:

1. **Who runs the IdP?** Theirs (Okta, Entra, Keycloak). Confirm in writing — never assume.
2. **SAML or OIDC?** Both is the safe default. "OIDC only" loses the deal six months later when their auditor asks for SAML.
3. **SCIM?** If they're above a few hundred employees, expect yes. JIT-only loses the SOC 2 Type II audit on the deprovisioning evidence.
4. **Session policy?** Configurable timeout, forced logout, concurrent session limits — they will ask, and "we don't support it" is a no.
5. **Audit logs?** Login events, role changes, admin actions — exposed in a way the buyer's IT can read directly, not as a support ticket.
6. **Where do their user IDs map to yours?** If your domain model has the IdP's identifier as the primary key for users, your honest answer is a quarter of refactor work, not a procurement reply. Get this right *before* the call.
7. **Who owns the customer's admin portal?** If the answer is "we do" and you don't have one yet, you are either buying a broker that ships one (WorkOS, Stytch B2B, Frontegg) or building the portal yourself this quarter.

Walk the list out loud, write the gaps down, take them back to engineering with a deadline. The deal won't close on a vendor demo — it closes on these seven answers being unambiguous.

---

## The decision before it's made for you

Auth decisions are cheap when made early. The layers are clear, the protocols are standardized, and the tooling is mature. Every layer in this stack has a well-understood failure mode, a well-understood fix, and a well-understood point where the wrong choice becomes expensive to reverse.

The mistake isn't picking the wrong vendor. It's not naming the layers at all — letting each one default to "also the auth provider," then discovering the boundaries when evolution pressure makes refactoring expensive.

The founding call — don't own passwords — is correct and cascades correctly through every layer. Apply it all the way down.

---

The separation-of-concerns principle underneath every call in this guide — each layer owns one responsibility, violations are defects not opinions — is formalized in *[Engineering Practice Boundaries — One Bar for Engineers and AI](/en/writing/engineering-principles-that-outlive-the-stack)*. The question of who holds technical judgment for these decisions at an early-stage company is addressed in *[Does Your Early-Stage Startup Actually Need a CTO?](/en/writing/does-your-startup-need-a-cto)*. And the organizational pattern for keeping these boundaries explicit and enforceable as the system grows — so future decisions and future engineers inherit clear constraints — is in *[Establishing Cross-Surface Architecture Governance](/en/work/architecture-governance)*.
