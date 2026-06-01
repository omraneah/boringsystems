# Harness Assessment

**Draft status:** Outline — awaiting detailed audit  
**Author:** Ahmed Omrane  
**Date:** 2026-06-01

---

## Executive Summary

> **Verdict:** The opencode CLI agent is **functionally compatible** with my personal harness, but lacks native hook/session-start infrastructure. Convergence requires 10-18 hours of config + custom tooling work.

**What works out of the box:**
- Skill discovery (reads `.agents/skills/` natively)
- Bash, Read, Write, Edit, Grep, Glob tools
- MCP connectors (GitHub, Linear) — config-only, no manual auth
- Git hooks (via `core.hooksPath` — git-level, not agent-level)

**What doesn't work:**
- SessionStart hooks (memory auto-load, pull-base, typecheck surface)
- PreToolUse hooks (protected branch guards don't fire on edit/bash)
- Memory auto-load (`memory/MEMORY.md` not read automatically)
- Persona system (12 personas need format adaptation)

**Effort to converge:** ~10-18 hours, medium risk.

---

## Harness Inventory

My personal harness components:

| Component | Location | Purpose | Agent Support Required |
|---|---|---|---|
| **Skills** | `.agents/skills/` (31 files) | Reusable behavioral definitions | Native skill tool |
| **Personas** | `.agents/personas/` (12 files) | Sub-agent personality definitions | Sub-agent spawning |
| **Hooks (agent)** | `.agents/hooks/` (8 files) | SessionStart, PreToolUse, PostToolUse | Hook registration |
| **Hooks (git)** | `.agents/git-hooks/` (2 files) | Pre-commit, pre-push enforcement | Git `core.hooksPath` |
| **Memory** | `memory/` (tiered: long/medium/short) | Context persistence across sessions | Auto-load on SessionStart |
| **Permissions** | `.agents/permissions/` | Canonical tool approval policy | Config-based permissions |
| **SOPs** | `docs/agent-ops/` (auto-loaded) | Collaboration protocols | Auto-read on session start |

---

## Opencode Compatibility Matrix

| Component | Claude Code | Codex | Opencode (native) | Opencode (with config) |
|---|---|---|---|---|
| Skills | ✅ Native | ⚠️ Readable, no invocation | ✅ Native (`skill` tool) | ✅ Works |
| Personas | ✅ Via Agent tool | ❌ No sub-agent spawning | ⚠️ `@general` only | ⚠️ Needs adapter |
| SessionStart hooks | ✅ `.claude/hooks/` | ✅ `.codex/hooks.json` | ❌ None | ⚠️ Custom script |
| PreToolUse hooks | ✅ Via hooks.json | ✅ Via hooks.json | ❌ None | ❌ Git-hooks only |
| Memory auto-load | ✅ Symlink + MEMORY.md | ❌ No native memory | ❌ None | ⚠️ Custom script |
| Git hooks | ✅ `core.hooksPath` | ✅ `core.hooksPath` | ✅ `core.hooksPath` | ✅ Works |
| MCP connectors | ✅ claude.ai native | ✅ Platform connectors | ✅ Config + OAuth | ✅ Works |
| Permissions | ✅ `settings.json` | ✅ `default.rules` | ✅ `opencode.json` | ✅ Works |

---

## Build Plan (If Committing)

### Phase 1: Config-only (1-2 hours)

**`opencode.json` at workspace root:**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "skill": { "*": "allow" },
    "bash": "allow",
    "edit": "allow",
    "write": "allow",
    "read": "allow",
    "glob": "allow",
    "grep": "allow",
    "webfetch": "allow",
    "websearch": "allow"
  },
  "mcp": {
    "github": {
      "type": "remote",
      "url": "https://github.com/mcp",
      "oauth": {}
    },
    "linear": {
      "type": "remote",
      "url": "https://linear.app/mcp",
      "oauth": {}
    }
  }
}
```

### Phase 2: SessionStart Emulation (4-6 hours)

**Custom script:** `.opencode/hooks/session-start.sh`

```bash
#!/bin/bash
# Emulates Claude Code's session-start.sh

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# 1. Auto-load memory (surface summary in chat)
if [ -f "$WORKSPACE_DIR/memory/MEMORY.md" ]; then
  echo "═══ MEMORY AUTO-LOAD ═══"
  head -50 "$WORKSPACE_DIR/memory/MEMORY.md"
  echo "═══ END MEMORY ═══"
fi

# 2. Pull base branch
bash "$WORKSPACE_DIR/.agents/hooks/pull-base-branch.sh"

# 3. Surface typecheck summary from last session
REPO_NAME=$(basename "$WORKSPACE_DIR")
SUMMARY="/tmp/typecheck-${REPO_NAME}.summary"
if [ -f "$SUMMARY" ]; then
  echo "═══ TYPECHECK ISSUES (last session) ═══"
  cat "$SUMMARY"
  echo "═══ END TYPECHECK ═══"
fi
```

**Limitation:** This script must be invoked manually or via custom tool — no native SessionStart hook.

### Phase 3: Persona Adaptation (2-3 hours)

Convert 12 persona files from `.agents/personas/` to opencode skill format:

**Current format (Claude/Codex):**
```markdown
---
name: principal-engineer
description: Daniel Kovac — principal engineer...
model: opus
effort: xhigh
tools: Read, Edit, Write, Bash, Grep, Glob, WebSearch, WebFetch
---
```

**Opencode skill format:**
```markdown
---
name: principal-engineer
description: Daniel Kovac — principal engineer...
license: MIT
compatibility: opencode
metadata:
  model: opus
  effort: xhigh
  tools: Read, Edit, Write, Bash, Grep, Glob, WebSearch, WebFetch
---
```

### Phase 4: PreToolUse Hook Emulation (4-8 hours, optional)

**Option A:** Custom wrapper tool that fires hooks before edit/bash  
**Option B:** Accept git-hook-only enforcement (already works via `.agents/git-hooks/`)

**Recommendation:** Option B for MVP. Git hooks catch protected branch violations regardless of agent.

---

## Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| SessionStart not native | Medium | Custom script + manual invocation |
| PreToolUse hooks not supported | Medium | Git hooks cover branch safety |
| Persona system not native | Low | Format adaptation is mechanical |
| Memory auto-load not native | Medium | Script-based surface in chat |
| MCP connector availability | Low | GitHub/Linear connectors exist |

---

## Comparison: Claude Code vs Codex vs Opencode

| Dimension | Claude Code | Codex | Opencode |
|---|---|---|---|
| **Native harness support** | ✅ Full (skills, hooks, memory) | ✅ Full (hooks, rules) | ⚠️ Partial (skills, tools) |
| **Session lifecycle** | ✅ SessionStart, PreToolUse, Stop | ✅ SessionStart, PreToolUse, Stop | ❌ None |
| **Sub-agent spawning** | ✅ Agent tool (model/effort/tools) | ❌ None | ⚠️ `@general` only |
| **MCP connectors** | ✅ claude.ai native | ✅ Platform connectors | ✅ Config + OAuth |
| **Memory system** | ✅ Symlink + auto-load | ❌ None | ❌ None |
| **Git hooks** | ✅ `core.hooksPath` | ✅ `core.hooksPath` | ✅ `core.hooksPath` |
| **Config complexity** | Low (settings.json + hooks) | Medium (hooks.json + rules) | Medium (opencode.json + scripts) |

---

## Verdict

**For my personal use:** Converging opencode to my harness is **worth the 10-18 hour investment** if I'm committing to this as a primary agent. The gap is not capability — it's wiring.

**For team-level adoption:** The harness gap is **irrelevant**. Most engineers don't have my level of workflow sophistication. The adoption barrier is not technical — it's **governance scaffolding** (shared rules, indexed architecture, common skills).

**Recommendation:** Proceed to writing + code assessment before making build/commit recommendation.

---

## Open Questions

- [ ] What is the actual Mistral model hosting setup? (vLLM, TGI, custom?)
- [ ] Are there existing shared rules/architectural docs indexed for the team?
- [ ] What is the current adoption rate? (DAU/WAU, active teams, feedback)
- [ ] Is there a product owner for this agent platform?
- [ ] What is the budget/headcount commitment if recommendation is to build?

---

## Next Steps

1. Complete this assessment with actual testing (invoke skills, test MCP, run session-start script)
2. Draft `writing-assessment.md` — quality of reasoning, exchange, documentation
3. Draft `code-assessment.md` — code quality, architecture, security
4. Synthesize into `executive-summary/README.md`
