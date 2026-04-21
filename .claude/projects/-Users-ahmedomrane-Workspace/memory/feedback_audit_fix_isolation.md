---
name: Audit-fix is a separate PR from structural changes
description: When resolving npm audit findings, open a dedicated PR — do not bundle into an architecture/feature branch
type: feedback
originSessionId: a6be26cc-31b9-4f62-b0be-90806834518d
---
When `npm audit` findings need resolving, the fix work (non-breaking `audit fix`, npm `overrides`, major-version upgrades, advisory acceptance entries in ADRs) goes in its own PR. Never bundle it into a structural or feature branch.

**Why:** during the enforcement-tier PR (boringsystems #21), I proposed bundling the 16 audit findings into the same PR as the ADR + versioning + hook work. Correct call was to keep them separate so a security-only rollback doesn't entangle with architecture changes. Bundling also makes reviewer triage harder — dependency churn and code restructure show up in the same diff.

**How to apply:**
- When a session surfaces audit findings, finish the in-flight structural PR first, merge it, then open a fresh branch dedicated to audit work.
- The `/audit-fix` skill in boringsystems encodes this: "Separate PR from any structural changes" is in the skill's Step 5.
- Commit scope for audit PRs: dependency + lockfile + `overrides` + any ADR advisory-acceptance entries. Nothing else.
- Exception: if a pre-push hook is being *introduced* in the same session, the first audit cleanup can land in the same PR as the hook itself (because the hook can't be added until audit is clean). After that, the rule holds.
