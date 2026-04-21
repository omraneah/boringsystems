# Pattern — Local-First Enforcement Tier

Portable template for projects that need to honor `cross-stack-architecture-starter-pack/quality-security-boundaries.md` at a tier below full CI. Extracted from boringsystems' ADR-003.

## When this pattern fits

All of:
- Solo or tiny-team (≤ 2 committers), trust-based enforcement is viable.
- Pre-revenue or early-revenue — paid GitHub Actions minutes not justified.
- No production state that can corrupt (no DB migrations, or migrations are gated separately).
- Reversible blast radius (content site, internal tool, prototype).

**This pattern stops fitting** when any of those flip. When it does, promote to full CI — the pattern includes the upgrade trigger.

## Core idea

CI-as-authority (the ARD's literal requirement) is the *implementation*. The *principle* is "enforcement is systemic, not human." That principle can be honored locally: pre-commit + pre-push git hooks, tracked in-repo, installed automatically on `npm install` or via a setup script, running the same deterministic checks a CI workflow would run.

Three tiers:

1. **Pre-commit** — fast, blocking, catches type/structural/build failures before a commit lands.
2. **Pre-push** — network-gated, catches dependency vulnerabilities before code leaves the machine.
3. **Documented agent discipline** — checklists that Claude runs before structural changes, surfaced via project-level skills.

No PR-workflow gate. No runner minutes. All checks survive a fresh clone.

## Minimum implementation

### 1. Install the hook manager

For an npm-capable project, `simple-git-hooks` is the lightest option.

```json
// package.json
{
  "scripts": {
    "postinstall": "simple-git-hooks || true",
    "precommit": "<project type check> && <structural script> && <build>",
    "verify": "tsx scripts/verify-structure.ts"
  },
  "simple-git-hooks": {
    "pre-commit": "npm run precommit",
    "pre-push": "npm audit --audit-level=high"
  },
  "devDependencies": {
    "simple-git-hooks": "^2.11.1"
  }
}
```

For a non-npm workspace (git-only), use `core.hooksPath` pointing at a tracked directory:

```bash
git config core.hooksPath .claude/git-hooks
```

Install this config idempotently in `.claude/setup.sh`.

### 2. Write a structural-verification script

Replace the class of tests a SaaS would write for invariants the project treats as non-negotiable. Examples per project type:

| Project type | Invariants worth gating |
|---|---|
| i18n content site | Locale mirror (every EN file has FR), frontmatter schema, slug-alias resolution |
| API proxy / thin app | Route surface shape, required env vars present, versioning prefix present |
| Typed registry app | Registry completeness per enum member, no orphan slugs |

One deterministic TS script (`scripts/verify-structure.ts`) using `tsx`. Exit 0 / exit 1 with named failures. No test framework.

### 3. Add the non-negotiable rule

In `CLAUDE.md`:

```
- Never push with high or critical npm vulnerabilities.
  Pre-push hook runs `npm audit --audit-level=high`. Fix first.
  --no-verify forbidden.
```

### 4. Write an ADR

Copy the shape of boringsystems' `docs/adr-003-enforcement-tier.md`:

- **Context** — why full CI isn't justified today.
- **Decision** — the three tiers, concretely.
- **ARD reconciliation** — which ARD clauses are honored at what tier, which are deferred.
- **Upgrade trigger** — named conditions that flip the project to full CI. Examples: first paying customer, public repo, second committer, production state layer added.
- **Accepted advisories** — a table for documented deferrals with revisit triggers. This is how you avoid silencing real risk while not blocking on what you can't fix today.
- **Related** — cross-link to the ARDs being tiered.

### 5. Wire the `/audit-fix` skill

Copy `boringsystems/.claude/skills/audit-fix/SKILL.md` into the new project's `.claude/skills/`. Adapt the overrides example if the project has different transitive pins. The skill encodes the classification discipline (reach × exploitability × fix path) that turns audit triage from improv to routine.

## Anti-patterns this pattern avoids

- **Silent exemption.** Without the ADR, "no CI" reads as drift. With it, "no CI" is a deliberate tier with a named upgrade trigger.
- **Trust-based enforcement.** The hook is the memory. Agent discipline layered on top of automation, not substituting for it.
- **Hook bypass erosion.** `--no-verify` explicitly forbidden in CLAUDE.md, not just implicitly discouraged.
- **Dev-only checks parading as CI.** The pre-push hook runs the *same* `npm audit` threshold that a CI workflow would run; alignment prevents "works locally" drift.

## When to promote to full CI

Any of the upgrade triggers in the project's ADR fires. Typical list:

- First paid subscriber or customer.
- Repo becomes public.
- Collaborator joins.
- Production state layer (DB, queue, auth) added.

When triggered: write a superseding ADR, add `.github/workflows/pr.yml` running the same commands the hooks run, and remove the "no CI by design" language from `CLAUDE.md` and `docs/constraints.md`.

## Reference implementations

- `boringsystems/docs/adr-003-enforcement-tier.md` — canonical ADR.
- `boringsystems/.claude/skills/audit-fix/SKILL.md` — audit triage skill.
- `boringsystems/scripts/verify-structure.ts` — structural-integrity script.
- `boringsystems/package.json` — `simple-git-hooks` + `overrides` wiring.
- `.claude/git-hooks/pre-push` — workspace-level hook iterating npm-capable submodules.
