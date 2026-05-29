---
name: @-imports Break Silently When Source Folders Are Renamed
description: When renaming, moving, or deleting any folder that may be referenced via Claude Code's `@<path>` import syntax (in agent files, skill files, or other prompts), grep the workspace for `@<path>` references first and update them as part of the same change. The imports fail silently — the agent / skill loads with missing context and behaves as if the rule it depended on never existed.
type: feedback
---

**Before renaming, moving, or deleting a folder, grep the workspace for `@<path>` references and update them in the same change. Claude Code's `@<path>` import syntax fails silently when the target path no longer exists — the consuming agent or skill loads with missing context and the operator has no way to detect the breakage from chat alone.**

**Why:** During the `llm-context-2026/` deprecation, the deletion of the submodule would have broken three operational agents (`career-coach`, `gtm-strategist`, `market-strategist`) because each loaded `@llm-context-2026/...` files via `@imports`. The breakage was caught during the pre-deletion audit only because of an explicit grep for the path. Without the grep, the deletion would have shipped, the agents would have invoked with missing context, and the failure mode would have been "agents respond more generically over time" — silent, gradual, hard to attribute to the deletion.

**How to apply:**

1. Before renaming or deleting any folder, run: `grep -rn "@<old-folder-path>" /Users/ahmedomrane/Workspace --include="*.md"` (and any other relevant extensions).
2. Update every `@<path>` reference to the new location (or remove if the content is being decommissioned).
3. Make the import updates part of the SAME PR as the rename/deletion. Do not split — the gap between the two creates a window where the imports point at nothing.
4. After the change ships, verify by invoking each affected agent / skill and confirming context loads correctly.
5. Apply this to ANY @-import target: agent files, skill files, sub-agent prompts, anything that uses `@<path>` syntax in Claude Code.

**Companion check:** the `/check-leaks` skill (or equivalent grep-based pre-PR sweep) should include `@<deprecated-path>` patterns for any folder being phased out, to catch this class of breakage automatically rather than relying on manual discipline.

**Provenance:** 2026-04-28 session. The discovery happened during the audit before the `llm-context-2026/` submodule deletion. Three operational agents would have broken silently. Captured as a stable feedback rule because the pattern is general — any submodule deletion, any folder rename, any path migration touches this risk.
