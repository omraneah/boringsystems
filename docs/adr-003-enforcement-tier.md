# ADR-003 — Local-First Enforcement Tier

**Status:** Accepted · 2026-04-21
**Context repo:** boringsystems

## Context

The workspace's engineering quality principle treats CI as the only authority:

> Enforcement is systemic, not human. Manual review never substitutes automated gates. Human judgment is not a quality gate.

Read literally, that boundary demands GitHub Actions (or equivalent) on every repo. boringsystems is a solo-founder, pre-revenue content site on the free GitHub plan. Paid Actions minutes on a private repo are not justified today.

The question is whether the *principle* (systemic enforcement, not human judgment) can be honored at a different tier than the *implementation* (GitHub Actions on PR). It can.

## Decision

boringsystems enforces the quality-security principle via a **local-first stack** until a documented upgrade trigger fires. No GitHub Actions. No PR-workflow gates. No reliance on human memory.

### The local enforcement stack

Three tiers, each systemic and unskippable within its scope:

1. **Pre-commit hook** (git, repo-level, runs on every `git commit`)
   - `astro check` — type and content-schema validation. Non-negotiable.
   - `scripts/verify-structure.ts` — structural invariants (EN/FR mirror, frontmatter integrity, SLUG_ALIASES resolution, LEAD_MAGNETS completeness).
   - `astro build` — compilation gate. Catches what `check` misses.
   - Managed via `simple-git-hooks`. Installed by `npm install` via `postinstall`. Survives fresh clones.

2. **Claude as a disciplined operator** (agentic, conversation-level)
   - Workspace Stop hook runs `astro check` after every turn on a feature branch. Already in place.
   - `/check-constraints` skill is required before any structural change (i18n, routing, content schema, deps, API surface).
   - The `/commit` skill must not ship a commit that the pre-commit hook would reject. Claude dry-runs the hook.

3. **Structural verification script** (`scripts/verify-structure.ts`)
   - Not a unit test harness. Not a framework. One deterministic script that asserts the invariants that define "a valid boringsystems repo."
   - Called by the pre-commit hook and available as `npm run verify`.

### What is explicitly not enforced at this tier

- **No unit tests.** `mailer.ts`, `toLocalePath`, and the API handlers are small, obvious, and change rarely. Unit coverage would test the standard library, not the domain. Flagged so future-me doesn't pretend this is an oversight.
- **No visual regression tests.** Would require Playwright or similar — violates `docs/constraints.md` "no build-time browser deps." Visual review is manual via Vercel preview URLs.
- **No SAST / SCA / secret scanning in CI.** Covered partially by GitHub's free Dependabot alerts (no Actions minutes consumed) and by `npm audit` at release time. Not gated.
- **No end-to-end tests.** The structural script covers the invariants a tiny E2E suite would cover.

## Reconciliation against engineering quality principles

The core principle — enforcement is systemic, not human; no manual overrides — is honored as follows:

| Principle | Local-tier implementation |
|---|---|
| Enforcement is systemic, not human | Pre-commit hook runs on every commit. Hook install is `postinstall`, not optional. |
| CI is the only authority — no manual overrides | Hook is the merge gate. `--no-verify` forbidden by workspace policy. |
| Local and CI must be aligned on same categories | Only one tier exists, so alignment is trivial. When CI is added later, it must run the same hook. |
| Security failures block — High/Critical block merges | Deferred — see upgrade trigger. `npm audit` run manually at release. |
| Quality gates mandatory — tests, lint, format | `astro check` + structural script. No separate linter (Astro's built-in check is sufficient at this size). No formatter (TypeScript conventions, manual). |

Gap vs. the ARD: security vulnerability gating is not automated. Accepted for now because (a) the dependency surface is 8 packages, (b) the build doesn't run untrusted code, (c) there's no user-data persistence. Re-evaluate at the upgrade trigger.

## Upgrade trigger

Any one of the following flips enforcement to GitHub Actions (or equivalent CI with paid minutes):

- **First paid subscriber** to a lead magnet or offering sold through the site.
- **Repo made public.** Open-source exposure introduces supply-chain surface that free Dependabot + `npm audit` don't cover at merge time.
- **Collaborator joins the repo.** More than one human committing means local-tier enforcement is no longer systemic — the hook install is no longer guaranteed.
- **State layer added** (Neon or equivalent). Migrations need CI-level gating — data integrity at the production level requires automated schema validation on every PR.

When any of the above occurs: open an issue referencing this ADR, add `.github/workflows/pr.yml` that runs the same commands the pre-commit hook runs, and supersede this ADR with a new one.

## Consequences

**Accepted trade-offs:**
- Hook can be bypassed with `git commit --no-verify`. Mitigated by workspace policy (Claude never uses `--no-verify`; Ahmed doesn't either).
- Fresh clone without `npm install` has no hook. Mitigated by `postinstall` wiring and by the laptop-agnostic rule in workspace `CLAUDE.md`.
- No long-term CI logs or audit trail. Accepted at this scale.

**Preserved properties:**
- Type safety is gated (the user's explicit top-priority invariant).
- Structural integrity is gated.
- Builds that fail locally cannot become commits.
- No reliance on "remembering to run X" — the hook is the memory.

## Appendix — Accepted advisories

Moderate-severity `npm audit` findings that are documented rather than fixed. The pre-push hook runs at `--audit-level=high`, so these do not block pushes. Re-evaluate when their upstream fixes land in Astro-compatible versions.

| CVE / advisory | Package chain | Reach | Accepted because | Revisit |
|---|---|---|---|---|
| GHSA-48c2-rrv3-qjmp (yaml stack overflow) | `yaml` ← `yaml-language-server` ← `volar-service-yaml` ← `@astrojs/language-server` ← `@astrojs/check` | Dev-tool only (runs during `astro check`). Never bundled. | Fix path downgrades `@astrojs/check` below our pinned version. Upstream fix pending. | When `@astrojs/check` ships a transitive with `yaml@>=2.8.3`. |
| GHSA-mr6q-rp88-fx84 (Astro unauthenticated path override via `x-astro-path`) | `@astrojs/vercel@9.0.5` | Runtime adapter. Path routing. | Fix requires `@astrojs/vercel@10`, which requires `astro@^6`. Current Astro is 5.18. Site has no path-based auth — every route is public — so header-spoofed path access yields no privilege escalation. Public pages remain public. | When Astro 6 migration branch ships. |

Additions to this table require a one-line rationale in the same row and are not a substitute for fixing — they are documented deferrals with revisit triggers.

## Appendix — IaC surface

Vercel platform config lives in `vercel.json` (framework pin + security headers). The Astro Vercel adapter emits the rest (build command, function routing, redirects from `astro.config.mjs`) at build time. `vercel.ts` with `@vercel/config` is the newer platform-recommended surface; revisit adoption when the package matures or when we need dynamic config (env-gated headers, cron declarations).

## Related

- Engineering quality principle being tiered: systemic enforcement via automation, no reliance on human judgment, CI as the only authoritative merge gate.
- Engineering practices principle §7: testing expectations partially deferred here — structural script replaces unit tests at this scale.
- Infrastructure-as-code principle: satisfied via `vercel.json` + `astro.config.mjs`, no separate IaC layer needed.
- `docs/constraints.md` — cross-linked; "no CI / no unit tests" now explicit, not implicit.
- `docs/adr-001-contact-form.md`, `docs/adr-002-home-selection.md` — companion ADRs.
