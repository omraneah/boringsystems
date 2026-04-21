---
name: audit-fix
description: Triage and resolve npm audit findings for boringsystems. Invoke when `npm audit` shows vulnerabilities, when the pre-push hook fails on a high/critical finding, or proactively before a release. Classifies findings by severity × reach × exploitability, applies non-breaking fixes, proposes overrides for transitive patches, and flags what requires a major upgrade.
---

# audit-fix

A disciplined flow for resolving `npm audit` findings under ADR-003's local-first enforcement tier. Goal: return the pre-push hook to green without silencing real risk or pulling in breaking upgrades we can't ship today.

## Preconditions

- Working directory is `boringsystems/`.
- Branch is a feature branch (never `main`).
- `git status` is clean (or your in-flight changes are intentional and isolated from dep work).

## Steps

### 1. Establish baseline

```bash
npm audit --audit-level=high
```

Record: count of high + critical. That's the number the hook cares about. Everything else is context but not the blocker.

### 2. Classify each high/critical finding

For each advisory, answer three questions:

| Question | Why it matters |
|---|---|
| **Where does the vulnerable code run?** | Dev-only (dev server, build tooling) vs. runtime (production request path) vs. build-time (processes committed content). |
| **Is the vulnerable code path reachable?** | Route matchers on user-controlled paths are reachable. Build-time tooling on author-controlled content isn't. ReDoS requires attacker-controlled regex input. |
| **What's the fix path?** | `npm audit fix` (non-breaking) → override (transitive patch available) → major upgrade (needs compat verification) → advisory-level acceptance. |

Write a one-line classification per finding before touching any commands.

### 3. Apply fixes in order of reversibility

Run them lowest-risk first. Stop and verify after each.

**a. Non-breaking autofix**

```bash
npm audit fix
npm run precommit   # must pass
npm audit --audit-level=high
```

**b. Targeted npm `overrides`** (when a transitive dep has a patched version that semver-satisfies what the parent requires)

Pattern — add to `package.json`:

```json
"overrides": {
  "<vulnerable-transitive>": "^<patched-version>"
}
```

Then:

```bash
rm -rf node_modules package-lock.json
npm install
npm run precommit
npm audit --audit-level=high
```

Canonical example in this repo: `path-to-regexp` pinned to `^6.3.0` via overrides to patch the version shipped inside `@vercel/routing-utils`.

**c. Major upgrades** (when a direct dep's major version contains the fix)

- Check peer-deps with `npm view <pkg>@latest peerDependencies`. If Astro major is required, it's a larger migration — **do not bundle into this fix**. Open a separate branch, read the changelog, verify on a preview deploy.
- If peer-compatible, upgrade, rebuild, re-audit.

**d. Advisory acceptance** (last resort, when the fix is infeasible today AND the CVE is not exploitable here)

- Document in `docs/adr-003-enforcement-tier.md` under a new "Accepted advisories" section: CVE ID, reach, why it's not exploitable, revisit trigger.
- Use `npm audit --audit-level=critical` in the hook *only* if every high-severity finding is individually accepted in ADR-003. Do not downgrade the hook silently.

### 4. Verify

```bash
npm run precommit    # astro check + verify-structure + astro build
npm audit --audit-level=high
```

Both must be clean. If the hook blocks the push on high, `--audit-level=high` will exit non-zero — investigate, don't bypass.

### 5. Commit and push

Separate PR from any structural changes (see workspace memory `feedback_audit_fix_isolation.md` for why). Commit scope: dependency + lockfile + override + any ADR-003 advisory entries. Nothing else.

## Anti-patterns

- Bundling audit fixes into an architecture PR. Rollback becomes a mess.
- Using `--no-verify` on push. The rule is non-negotiable.
- Downgrading the hook threshold (`high` → `critical`) as a shortcut. Only legitimate when every remaining high is documented in ADR-003.
- Blindly running `npm audit fix --force` without reading the "breaking changes" it names. Force often downgrades fresh devDeps.

## When to escalate

If a high-severity CVE requires a major upgrade (e.g. Astro 5 → 6) that breaks the build:

1. Classify the CVE reach — is it actually exploitable in this project?
2. If no: document the acceptance in ADR-003 with revisit trigger (e.g. "when Astro 6 migration lands").
3. If yes: stop shipping feature work until the migration is done. Open a migration branch, read the upgrade guide, verify on a preview.
