# Harness Assessment

**Status:** Draft  
**Date:** 2026-06-01

---

## Executive Summary

**Verdict:** Opencode CLI is functionally compatible with my harness, but lacks native hook/session-start infrastructure. Convergence requires ~10-18 hours of config + custom tooling.

**What works:**
- Skill discovery (reads `.agents/skills/` natively)
- Bash, Read, Write, Edit, Grep, Glob tools
- MCP connectors (GitHub, Linear) — config-only
- Git hooks (via `core.hooksPath`)

**What doesn't work:**
- SessionStart hooks (memory auto-load, pull-base, typecheck surface)
- PreToolUse hooks (protected branch guards don't fire on edit/bash)
- Memory auto-load (`memory/MEMORY.md` not read automatically)
- Persona system (12 personas need format adaptation)

---

## My Harness Components

| Component | Location | Purpose |
|---|---|---|
| Skills | `.agents/skills/` (31 files) | Reusable behavioral definitions |
| Personas | `.agents/personas/` (12 files) | Sub-agent personality definitions |
| Hooks (agent) | `.agents/hooks/` (8 files) | SessionStart, PreToolUse, PostToolUse |
| Hooks (git) | `.agents/git-hooks/` (2 files) | Pre-commit, pre-push enforcement |
| Memory | `memory/` (tiered) | Context persistence across sessions |
| Permissions | `.agents/permissions/` | Canonical tool approval policy |
| SOPs | `docs/agent-ops/` | Collaboration protocols |

---

## Opencode Compatibility

| Component | Native Support | With Config |
|---|---|---|
| Skills | ✅ Native `skill` tool | ✅ Works |
| Personas | ⚠️ `@general` only | ⚠️ Needs adapter |
| SessionStart hooks | ❌ None | ⚠️ Custom script |
| PreToolUse hooks | ❌ None | ❌ Git-hooks only |
| Memory auto-load | ❌ None | ⚠️ Custom script |
| Git hooks | ✅ `core.hooksPath` | ✅ Works |
| MCP connectors | ✅ Config + OAuth | ✅ Works |
| Permissions | ✅ `opencode.json` | ✅ Works |

---

## Build Plan (If Committing)

### Phase 1: Config-only (1-2 hours)

Create `opencode.json` at workspace root with permissions + MCP config.

### Phase 2: SessionStart Emulation (4-6 hours)

Custom script that:
- Auto-loads memory (surfaces summary in chat)
- Runs `pull-base-branch.sh`
- Surfaces typecheck summary from last session

**Limitation:** Must be invoked manually — no native SessionStart hook.

### Phase 3: Persona Adaptation (2-3 hours)

Convert 12 persona files to opencode skill format (mechanical, low risk).

### Phase 4: PreToolUse Hook Emulation (4-8 hours, optional)

Option A: Custom wrapper tool that fires hooks before edit/bash  
Option B: Accept git-hook-only enforcement (already works)

**Recommendation:** Option B for MVP.

---

## Verdict

**For my personal use:** Converging opencode to my harness is worth the 10-18 hour investment if I'm committing to this as a primary agent.

**For team-level adoption:** The harness gap is irrelevant. Most engineers don't have my workflow sophistication. The adoption barrier is governance scaffolding (shared rules, indexed architecture, common skills).

---

## Next Steps

- [ ] Execute actual testing (invoke skills, test MCP, run session-start script)
- [ ] Compare with Claude Code / Codex baselines
- [ ] Synthesize into executive summary
