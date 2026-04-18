---
name: cross-stack-architecture-starter-pack
description: Agent-ready architecture starter pack built on top of ARDs — includes AGENT-GUIDES, DECISION-TREES, PATTERNS, ANTI-PATTERNS, BOOTSTRAP-SEQUENCE, GAP-NOTES, CLARIFICATION-NEEDED
type: project
---

Built a complete agent-ready starter pack in `/Users/ahmedomrane/Workspace/cross-stack-architecture-starter-pack/`.

**Structure added:**
- `AGENT-GUIDES/` — 11 files (one per ARD domain): auth, multi-tenancy, tenant-user-role, iam-and-access-control, module-communication, api-versioning, naming-conventions, infrastructure-as-code, data-integrity, quality-and-security, engineering-practices
- `DECISION-TREES/` — 7 files: starting-a-new-module, adding-a-new-api-endpoint, adding-cross-module-communication, creating-or-modifying-a-user, writing-a-data-migration, adding-infrastructure-resources, reviewing-generated-code
- `PATTERNS/` — 6 files: request-lifecycle, tenant-scoped-repository, event-driven-cross-module, auth-boundary-translation, iac-resource-lifecycle, migration-script-template
- `ANTI-PATTERNS/` — 6 files: provider-id-leakage, controller-tenant-logic, cross-module-direct-injection, unversioned-api-endpoints, non-idempotent-migrations, iam-long-lived-credentials
- `BOOTSTRAP-SEQUENCE.md` — 10-phase ordered workflow
- `GAP-NOTES.md` — 6 documented gaps between ARDs and source code (including OIDC gap, security scan soft-fail, organisationId naming)
- `CLARIFICATION-NEEDED.md` — 6 ambiguities flagged for CTO (canonical tenant identifier name, tenantId in responses, etc.)
- `README.md` — updated with full structure, reading order, task-to-files index

**Why:** User is abstracting principles and doctrines from a company codebase to keep after leaving. All domain-specific names abstracted (no company name, no product names).
