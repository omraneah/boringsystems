---
name: Audit-fix is a separate PR from structural changes
description: Stub — canonical home is the `/audit-fix` skill in boringsystems
type: feedback
originSessionId: a6be26cc-31b9-4f62-b0be-90806834518d
---

**Stub.** Rule codified into `boringsystems/.claude/skills/audit-fix/SKILL.md` (Step 5 + Anti-patterns). When `npm audit` findings need resolving, the fix work goes in its own PR — never bundled into a structural or feature branch. Exception for the first audit cleanup landing alongside a newly-introduced pre-push hook.

See the skill for the full flow and rationale.
