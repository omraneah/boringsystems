---
name: arch-review
description: Review code or a PR against core architectural principles. Use when adding a new module, API endpoint, or significant structural change. Lightweight — focuses on portable invariants, not SaaS-specific patterns.
model: opus
effort: high
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
argument-hint: "[file, directory, or description of what to review]"
---

Review $ARGUMENTS against the core architectural principles that apply to any project.

## What to check

These are the invariants that apply regardless of project size or type. Do NOT enforce SaaS-specific patterns (multi-tenancy, OIDC, tenant scoping) unless the project explicitly requires them.

### 1. Module boundaries
- No direct cross-module injection (modules talk through events or explicit interfaces, not direct imports of internals)
- No circular dependencies
- Business logic does not live in controllers/handlers — it belongs in a service or domain layer

### 2. API design
- Endpoints are versioned from the start (e.g., `/v1/...`)
- Breaking changes = new version, never modify existing contracts
- Consistent error response format

### 3. Auth
- Auth provider IDs never leak beyond the auth boundary
- Roles and permissions come from the internal model (DB), not from provider tokens
- No auth logic in business logic layers

### 4. Data integrity
- Migrations are idempotent and reversible
- No destructive operations without explicit safety check
- Schema changes are backwards-compatible when possible

### 5. Code quality
- No hardcoded secrets or credentials
- No TODO/FIXME left in production paths without a tracked issue
- Functions do one thing

### 6. Naming
- Consistent naming: camelCase in application code, snake_case in DB columns
- No ambiguous abbreviations that would confuse a new contributor

## Output format

Report findings as:
- **Pass** — principle upheld
- **Warn** — minor deviation, not blocking
- **Fail** — violation that should be fixed before merge

End with a one-line verdict: PASS / PASS WITH WARNINGS / FAIL.

## Reference
Full architectural boundaries (for complex cases): `cross-stack-architecture-starter-pack/` (workspace-relative)
Use those docs when the project is explicitly multi-tenant or SaaS-grade. For most projects here, the above checklist is sufficient.
