# Exeko Audit × Enakl Body of Work — Transferability Map

**Purpose.** Map what Ahmed has already built at Enakl + codified in `cross-stack-architecture-starter-pack` against the Deepika audit findings on Exeko. Identify accelerators, decelerators, and risks the auditors did not flag.

**Reference points.**
- Deepika audit PDF synthesis (P0 + 3 structural manques) — read at intake; findings extracted below.
- BPI annexe technique (Excel) — read at intake; T1–T6 work-package shape extracted below.
- Enakl operational artifacts: `Enakl/cross-stack-workspace/` + `Enakl/cross-stack-architecture/`.
- Portable playbook: `cross-stack-architecture-starter-pack/`.

---

## Stack comparison

| Dimension | Enakl (what Ahmed built) | Exeko (current state per audit) | Transfer cost |
|---|---|---|---|
| Stack | NestJS + Postgres + Flutter (rider/driver) + Terraform AWS | Next.js + Prisma + Postgres + (no mobile yet) + AWS S3 + n8n | Medium — different framework, similar shape |
| Codebase size | ~108k LOC backend + 28.5k Dart | 289k LOC TypeScript, monorepo | Exeko ~3x larger backend surface |
| API surface | 93 routes (12 versioned-only, 80 in-transition, 1 outdated) | **357 routes**, no versioning mentioned | Exeko is 4x the attack surface, no migration path |
| Domain models | Trip/Line/User/Org/Wallet/Booking — ride-sharing | Teacher/Student/Parent/School/Class/Quiz/Booking — edu marketplace | Different domain, identical architectural shape |
| Multi-tenancy | `organisationId` mandate, CLS + pool hook, multi-schema ready | B2C + B2B (schools) in same codebase, audit silent on tenant scoping | Same playbook applies, more urgent at Exeko |
| Auth | Cognito + WhatsApp OTP Lambdas + DB roles | Better Auth + Google OAuth | Provider-replaceability boundary applies as-is |
| Test ratio | Unit + integration + E2E across backend + mobile | **0.25 %** (3 test files / 1 217 source files) | Exeko = blank slate, no legacy tests to migrate |
| CI/CD | 38 GitHub Actions workflows across 6 repos | **None** (`.github/workflows/` does not exist) | Exeko = green-field, can land starter-pack pattern in week 1 |
| Observability | Pino + Sentry plan + CloudWatch + structured logging | **None** (953 `console.*` calls) | Same playbook, faster delivery (no legacy to refactor) |
| Architecture docs | 12 boundary ARDs + workspace plans + AUDIT_REPORT methodology | 4 concurrent root docs (README/CLAUDE.md/GUIDE-LLM.md/PAGES.md), no diagrams | ARDs lift directly, Boring Architecture principle applies |
| Domain modelling | Confluence-grade docs + EXPLICIT_ARCHITECTURE_GUIDELINES + TRIP_LINES_RELATIONSHIP | Prisma schema split by domain (21 files) but no shared business model | Strong Prisma-split is a head start; semantic layer missing |
| Capabilities/RBAC | `organisationId` + simple RBAC, DB-driven | 6-level precedence capabilities (user > profile > school > subscription > capabilities > global) | Exeko is **more** sophisticated here — but untested at 0.25 % coverage = silent privilege-escalation risk |
| Feature flags | None visible in Enakl artifacts | 6-level precedence flag resolver | Exeko ahead; needs tests urgently |
| Domain split deployment | Single backend, single backoffice, two mobile | B2C ↔ B2B served from single codebase with client-side detection (`exeko.ai ↔ edu.exeko.ai`) | Different shape, no Enakl precedent |
| Crown-jewel risk | Documented + IaC bootstrap | **P0: prod DB dump committed to Git since 2025-10-08** | Enakl never had this exact incident, but `iac-resource-lifecycle.md` pattern applies |

---

## Accelerator table — what Ahmed already has that lifts directly

| Asset | Source | Where it lands on Exeko |
|---|---|---|
| **Bootstrap sequence** (10-phase ordered workflow) | `cross-stack-architecture-starter-pack/BOOTSTRAP-SEQUENCE.md` | Use verbatim. Phase 0–2 (orientation, DB schema audit, auth isolation) maps directly to Exeko Month 1 diagnostic. |
| **11 ARDs (Architectural Reference Documents)** | `cross-stack-architecture-starter-pack/*-boundaries.md` | Lift `auth`, `multi-tenancy`, `module-communication`, `api`, `quality-security`, `production-data-integrity` as-is. `naming-conventions` adapts. `IAM/IaC` need AWS→Vercel-or-similar translation. |
| **AUDIT_REPORT.md methodology** | `Enakl/cross-stack-workspace/architecture/AUDIT_REPORT.md` | Reuse the structure: alignment between authoritative boundaries and workspace implementation, grade, gap list, missing-boundary suggestions. Run as Month 1 deliverable for Exeko. |
| **EXPLICIT_ARCHITECTURE_GUIDELINES** — "Boring Architecture" | `Enakl/cross-stack-workspace/architecture/EXPLICIT_ARCHITECTURE_GUIDELINES.md` | Direct copy-paste with Exeko-specific names. The "junior-to-intermediate maintainable" framing applies more strongly at Exeko (single junior dev). |
| **API cleanup discipline** | `Enakl/cross-stack-workspace/API_Cleanup/` (weekly audit, dual-support pattern, snapshot metric) | Apply to 357 endpoints. The dual-support `["1", VERSION_NEUTRAL]` migration pattern is exactly what Exeko needs to migrate without breaking the junior dev's existing clients. |
| **TECH_DEBT_ANALYSIS framework** | `Enakl/cross-stack-workspace/architecture/TECH_DEBT_ANALYSIS.md` | Classification scheme (Bomb / Blocking / Fragility / Friction / Hygiene) for ranking the Exeko issues. Replaces the audit's flat list with a triage. |
| **CIRCULAR_DEPENDENCIES_INVENTORY methodology** | `Enakl/cross-stack-workspace/architecture/CIRCULAR_DEPENDENCIES_INVENTORY.md` | Run automated + manual analysis on Exeko's 289k LOC. Quiz-domain dispersed across 6+ places suggests circular deps. |
| **Mobile tech-debt 3-day timebox rule** | `Enakl/cross-stack-workspace/mobile/MOBILE_APPS_TECH_DEBT_PRIORITIZATION.md` | Apply to all Exeko tech-debt work. 2 topics/week, max 3 days each, no scope expansion. Exactly the Month 2 sprint shape. |
| **Decision trees** (7 trees: new module, new endpoint, cross-module, migration, IaC, user mod, code review) | `cross-stack-architecture-starter-pack/DECISION-TREES/` | Use `reviewing-generated-code.md` 15-check gate for the junior dev's PRs. Use `writing-a-data-migration.md` for the P0 `git filter-repo` operation. |
| **Patterns + anti-patterns library** | `cross-stack-architecture-starter-pack/PATTERNS/` + `ANTI-PATTERNS/` | `iac-resource-lifecycle.md` informs P0 remediation. `migration-script-template.md` for any Prisma migration the junior dev runs. `provider-id-leakage.md` applies to Better Auth boundary. |
| **Handover artifact format** | `Enakl/cross-stack-workspace/handover/auth.md` + `analytics.md` | Use as deliverable shape at Month 2 gate: current state + gaps + open decisions + estimate. Makes value-holds-if-I-leave concrete. |
| **Observability project spec** | `Enakl/cross-stack-workspace/devops/03_future/OBSERVABILITY_PROJECT_SPEC.md` | Pino + Sentry + correlation IDs. The 953 `console.*` calls at Exeko = exactly the starting state Enakl had. |
| **Secrets management pattern** | `Enakl/cross-stack-workspace/devops/03_future/SECRETS_MANAGEMENT_TASKS.md` | IAM instance profile vs hardcoded AWS keys. Maps to Exeko's `*.dump` in git incident — same class of error. |
| **Quality/security enforcement tooling** | `Enakl/cross-stack-workspace/devops/` + `quality-security-boundaries.md` | Pre-commit hooks (Husky), CI as authority. Plug into Month 1 P1.a (filet sécurité). |
| **Multi-tenancy AI audit transition** | `Enakl/cross-stack-workspace/multi-tenancy/2026_02_AI_AUDIT_TRANSITION.md` | The framing "playbook adapted to team constraints, not improvisation" is the exact pitch Angelina needs to hear. Reuse the language. |

**Net read.** Ahmed has **the entire scaffolding** Exeko needs, already debugged on a 4-year live production system. The audit Deepika produced essentially describes month 1–6 of Enakl's own trajectory. **Acceleration factor estimate: 3–4×.** Where a CTO without this body of work would spend 60 days writing boundary documents from scratch, Ahmed adapts in 15.

---

## Decelerator table — what slows him down on Exeko vs Enakl

| Factor | Why it decelerates | Mitigation |
|---|---|---|
| **No mobile yet** | Half the Enakl artifacts (Flutter tech-debt, mobile CI/CD) don't apply. Less leverage from existing work. | Out of scope for foundations-fix mission. Park. |
| **Different framework** (Next.js vs NestJS) | Patterns are NestJS-flavoured. Request-lifecycle pattern needs rewrite for Next.js Route Handlers / Server Actions. | 1 week to translate patterns; portable principles unchanged. |
| **n8n external workflows** | Enakl had no n8n. 12 AI workflows + 1 dev = un-audited execution surface. Migration to in-code is a P2 chunk in the audit. | Refuse to own n8n migration. Stays out of foundations scope. |
| **B2C ↔ B2B in single codebase with client-side detection** | Enakl is single-tenant-per-org model. Exeko's `exeko.ai ↔ edu.exeko.ai` domain-split on the same codebase with client detection is a different multi-tenancy shape. | Apply multi-tenancy boundary principles, but the implementation is novel. Add 5–10 days. |
| **Signal-Protocol E2E messaging** | Sophisticated crypto stack at Exeko. Enakl has no equivalent. Maintenance burden + key-management complexity. | Out of scope. Flag for founder + dev, don't touch. |
| **6-level precedence capabilities/flags** | More sophisticated than Enakl. More edge cases, more silent failure modes, more tests required. | Treat as discovery work in Month 1; do not change without test coverage. |
| **357 endpoints to triage** | 4× Enakl's surface. The API cleanup discipline scales but takes longer per cycle. | Apply weekly-audit pattern, set realistic timeline (10–12 weeks vs Enakl's 3 months for fewer routes). |
| **Single junior dev as execution layer** | Enakl had multiple engineers. Coaching ceiling matters. If the dev can't execute architecture, scaffolding stalls. | Probe the dev directly in Week 1. If gap is wide, escalate to Angelina before continuing. |
| **No senior engineering counterpart** | Both founders are 28, no senior gravity. At Enakl, there was at least a peer-CTO discussion partner. Decisions land slower. | Anchor decisions in the ARDs as authority, not in personal credibility. |
| **BPI grant cash, not revenue** | Cash flow is BPI-tranche-shaped, not customer-shaped. Risk of delayed payment if tranches gate on R&D deliverables. | Confirm payment terms in writing before Month 1. Refuse milestone-payment tied to R&D output you don't own. |
| **Capital €2 000 + confidential accounts** | Smaller financial buffer than Enakl ever had. Less margin for "let's spend an extra month on foundations." | Be explicit on scope creep refusal. Each scope expansion costs them BPI runway. |
| **Pre-existing audit by Deepika** | The frame is already set by Louis's narrative. Ahmed walks into a pre-defined diagnosis. Less freedom to reshape the read. | Validate the audit findings empirically in Week 1. If your read differs, surface immediately. |

---

## Risks the Deepika audit did NOT flag clearly (what Ahmed would add)

| Risk | Why it matters | Severity |
|---|---|---|
| **357 endpoints = attack surface** | Single junior dev + no monitoring + no CI/CD + 357 routes = massive surface for fuzzing, scraping, rate-limit abuse, OWASP top-10. Audit calls it a "lisibilité" problem; it's a **security** problem. | **P0** |
| **No API versioning mentioned anywhere** | 357 routes evolve without contract guarantees. Any backend change can break clients silently. With no tests, regressions reach prod. The audit recommends docs (P1.c) but skips versioning entirely. | **P0** |
| **Tenant scoping unverified** | B2B (schools) + B2C (parents) in same codebase. Audit does not state "all queries are tenant-scoped." Cross-tenant data leakage (school A sees school B's data) is a single missing `WHERE schoolId` away. With minors involved, this is RGPD-grade. | **P0** |
| **Capabilities system at 6 levels of precedence, 0.25 % test ratio** | Sophisticated privilege resolver with zero behavioural coverage = silent privilege escalation. A user accidentally inheriting school-admin rights is a click away. Audit praises the system; it should flag the test gap as P0. | **P0** |
| **n8n workflows = sovereignty + data-flow black box** | 12 external AI workflows touching minor pupil data. Where do they run? What do they store? RGPD impact assessment status? BPI sovereignty narrative collides with external n8n cloud unless self-hosted. Audit lists them; doesn't audit them. | **P0 / RGPD** |
| **No dependency-hygiene audit** | 289k LOC TS = hundreds of npm dependencies. `npm audit` output not in the audit. Supply-chain risk (npm package compromise, transitive vulnerabilities) is the most common modern attack vector. Audit is silent. | **P1** |
| **No data classification / RGPD map** | Audit mentions RGPD compliance is "not in scope" but the company processes minors' data, evaluation scores, family relationships, payment data, E2E-crypto keys. No DPO, no data-flow map, no retention policy, no consent UI flow audit. Audit explicitly excludes "RGPD compliance" — that's a gap, not a scope decision, for a business processing minor data. | **P0 / legal** |
| **Git history sanitization beyond the DB dump** | The `production_backup.dump` is the headline. But: were there `.env` files committed earlier? API keys? Stripe webhook secrets? OAuth client secrets? A `git filter-repo` campaign should scan history, not just remove the one file. | **P1** |
| **Provider lock-in risk** | 6 external services (Stripe, Better Auth, Resend, AWS S3, Google OAuth, n8n) all directly invoked. No abstraction layer. If Better Auth changes pricing or shutters, Exeko has weeks not months. Enakl's `auth-boundaries.md` provider-replaceability principle is directly relevant; audit doesn't mention it. | **P1** |
| **No backup/restore validation** | They have a prod DB with the dump-leak issue. Have they ever tested restore? Have they timed it? RTO/RPO documented? Audit silent. | **P1** |
| **Single point of failure: the junior dev** | Audit names this once ("un seul point de défaillance humain") but treats it as a tech-debt note. It is a **business continuity P0**. No runbooks, no documented "what to do if the dev disappears tomorrow." For a company that just secured BPI grant on milestone delivery, this is fatal risk. | **P0 / business** |
| **No incident-response plan** | The audit identifies a security incident (DB dump) but doesn't ask: what's the runbook if this gets exploited? Who notifies CNIL? At what threshold? Under GDPR Article 33, 72-hour notification window. With minor data, immediate. | **P0 / legal** |
| **Capabilities + feature flags + domain-split + n8n + E2E crypto + AI = stacking complexity** | Each individual brick is praised in the audit. The combination, maintained by 1 junior dev, is a fragility multiplier. Sophistication is the failure mode, not the feature. | **P1** |
| **README inadequate for re-onboarding** | The audit says docs are dispersed (94 files in `docs/`). It doesn't probe: could a new senior eng productively contribute in 5 days? In 30 days? The transmissibility test the audit defines as a need is not executed in the audit itself. | **P1** |
| **No legal architecture** | Contracts with schools (DPA), parental consent UI, terms of service for minors, age-gating, COPPA-equivalent compliance for international expansion. Audit is correctly out of scope on legal — but Ahmed should refuse the engagement if no legal counsel is in place before R&D launches. | **P1 / business** |
| **The "audit didn't find what isn't there" trap** | The audit measures what exists (LOC, routes, models, tests, CI). It cannot measure what is **silently missing**: rate limiting, CSRF protection state, CSP headers, RLS at DB layer, brute-force throttling, account-takeover protection, audit logging for sensitive actions on minor data. None of these are in the audit. | **P0 — needs Ahmed's own scan in Week 1** |

---

## Exeko Month-1 diagnostic — concrete proposed scope (8 days)

Using Enakl precedent + starter-pack methodology, what Month 1 actually delivers:

| Day | Output | Source artifact reused |
|---|---|---|
| 1 | Cross-stack architecture audit (alignment, gaps, missing boundaries) — Exeko version | `AUDIT_REPORT.md` structure |
| 2 | Tech-debt classification (Bomb / Blocking / Fragility / Friction / Hygiene) for all audit findings + Ahmed's additions | `TECH_DEBT_ANALYSIS.md` framework |
| 3 | API endpoint full audit (357 routes, classification, versioning gap, attack-surface read) | `API_CLEANUP_WEEKLY_AUDIT.md` discipline |
| 4 | Multi-tenancy scoping verification (B2B/B2C cross-tenant query audit) + 6-level capabilities audit | `multi-tenancy-boundaries.md` + `tenant-scoped-repository.md` pattern |
| 5 | Git history sanitization plan (P0 + secrets scan) + IaC for crown jewels | `iac-resource-lifecycle.md` pattern + decision tree |
| 6 | Junior-dev coaching diagnostic + dependency-hygiene scan + n8n sovereignty audit | new — context-specific |
| 7 | Boundary documents for Exeko (5–6 ARDs lifted + adapted) | starter-pack lift |
| 8 | Month-2 sprint scope proposal + handover artifact format primer | `handover/auth.md` precedent |

**Deliverable:** A diagnostic report in Ahmed's standard shape — graded against boundaries, ranked by severity, with a Month-2 scope proposal that holds up if Ahmed exits.

---

## Net read for the engagement decision

- **Ahmed is positively over-equipped for the foundations-fix scope.** Acceleration factor 3–4× vs a CTO without this corpus. The hard part is not "what to do" — it's discipline holding the frame against scope creep into R&D.
- **The audit Deepika delivered is competent but conservative.** It names what exists; it under-reports what is silently missing. Ahmed's Week 1 should produce a parallel audit that surfaces the security + RGPD + business-continuity risks.
- **Two structural risks dominate.** (1) The junior dev — if execution capacity is below threshold, the scaffolding compounds rather than ships. (2) The capabilities + flags + crypto + n8n + AI stack on 0.25 % test coverage — Exeko's sophistication is its own fragility. Both demand probing in Week 1, not assumption.
- **The mission is high-leverage if the founder accepts the foundations-only reframe.** If she pushes back and insists on AI / R&D / co-direction over foundations, walk per the guardrails doctrine.

---

## Cross-references

- Doctrine → `memory/medium-term/operational-doctrine/Fractional-Engagement-Guardrails.md`
- Frame map for the call → `go-to-market/opportunities/exeko-deepika-frame.md`
- Episodic record → `memory/short-term/2026-W20/2026-05-14.md`
- Audit sources (Deepika PDF synthesis + BPI annexe Excel) — kept ephemerally in render buffer; key findings inlined above.
- Enakl architecture body → `Enakl/cross-stack-workspace/architecture/`
- Starter-pack playbook → `cross-stack-architecture-starter-pack/`
