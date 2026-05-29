# ARD Tier Map

Reconciliation between `cross-stack-architecture-starter-pack`'s ARDs and the enforcement tier each project in this workspace actually runs at. Exists to prevent silent drift — "we're following the ARDs" without verifying *how* each ARD is honored per project.

**Rule:** every active project lists the ARDs that apply, the tier it enforces them at, and the gap (if any) with a revisit trigger. Tiers are declared, not assumed.

## Tier definitions

| Tier | What it means | When to use |
|---|---|---|
| **T0 — Principle-only** | Rule written in project `CLAUDE.md`; no automation; relies on agent/author discipline. | Read-only docs, archived projects. |
| **T1 — Local-first** | Pre-commit + pre-push hooks; tracked structural-integrity script; ADR documenting the tier + upgrade trigger. | Solo, pre-revenue, no prod state. See `docs/governance/patterns/local-first-enforcement.md`. |
| **T2 — CI-gated** | Same checks as T1 + GitHub Actions / equivalent on PR. Security scans, test suites, deploy gates. | Multi-committer, public repo, first paying customer, prod state. |
| **T3 — Full SaaS enforcement** | T2 + audit logs, SLOs, system-level health gates, incident-response ties. | Multi-tenant production SaaS. |

The ARDs are written for T3. Lower tiers honor the *principle* by compatible means, not the literal implementation.

## Project matrix

### boringsystems — **T1**

Active content site, solo, pre-revenue. Astro 5 + Vercel. No DB.

| ARD | Tier | How | Gap |
|---|---|---|---|
| `engineering-practices-boundaries` | T1 | `astro check` on pre-commit + `/check-constraints` skill before structural code. | §7 testing: no unit tests, structural script replaces that class. Deliberate. |
| `quality-security-boundaries` | T1 | Pre-commit hook (type + structural + build). Pre-push hook (`npm audit --audit-level=high`). `--no-verify` forbidden. | No CI workflow, no SAST, no secret-scan. Upgrade at first paid subscriber / public repo / second committer. |
| `api-boundaries` | T1 | All routes under `/api/v1/`. Shared `json()` / `jsonError()` helpers. | None. |
| `naming-conventions-boundaries` | T1 | camelCase everywhere in app + API. kebab-case filenames. No DB yet. | None today. Add persistence naming boundary when DB arrives. |
| `infrastructure-as-code-boundaries` | T1 | `vercel.json` (framework + security headers) + `astro.config.mjs` (redirects + i18n). Vercel project settings in code, not dashboard. | `@vercel/config`/`vercel.ts` deferred — revisit when package matures. |
| `production-data-integrity-boundaries` | N/A | No production state. | Becomes relevant when Neon or equivalent lands. |
| `module-communication-boundaries` | N/A | Single-process content site, no modules. | — |
| `multi-tenancy-boundaries` | N/A | No tenancy. | — |
| `auth-boundaries` | N/A | No auth. | — |
| `iam-and-access-control-boundaries` | N/A | No IAM (Vercel + Resend managed via dashboard). | When infrastructure grows past two platform dashboards. |
| `tenant-user-role-boundaries` | N/A | — | — |

**Upgrade trigger:** first paid subscriber, public repo, collaborator, or Neon added. See `boringsystems/docs/adr-003-enforcement-tier.md`.

### personal-apps — **T0 → T1 pending**

Active. Next.js 16 + Tailwind 4. See `personal-apps/AGENTS.md` + `CLAUDE.md` for current state.

Not yet tiered explicitly. Candidate to adopt T1 using `docs/governance/patterns/local-first-enforcement.md` as the template.

### cross-stack-architecture-starter-pack — **N/A (source of truth)**

Read-only ARD repository. The doc being tiered against, not a tiered project.


### Enakl — **N/A**

Read-only archive. Past company context. Not an active project.

## Maintenance

- New project enters the workspace → add a row before first merge.
- Project crosses its upgrade trigger → open a branch that bumps the tier and supersedes the project's enforcement-tier ADR.
- Stale rows → `/session-pulse` or `/wrap-session` should surface divergence between this map and reality.
