---
name: feedback_skills_canonical_path
description: New skills must be written directly to Workspace/.agents/skills/ — never to ~/.claude/skills/ which is a symlink. Resolve any ~/.claude/ path before writing to it.
type: feedback
---

New skills go directly to `Workspace/.agents/skills/<name>/SKILL.md`. Never use `~/.claude/skills/` as a write target.

**Why:** `~/.claude/skills` is a symlink into `Workspace/.agents/skills/`. Writing to the symlink instead of the canonical source obscures that the skill is version-controlled in the workspace. This happened on 2026-05-05: a new skill was written to `~/.claude/skills/log-inbound/` — it resolved correctly but the path used was wrong. Skills now live in `.agents/skills/` (canonical, cross-agent) rather than `.claude/personal-skills/` (moved 2026-05-26 as part of agent-agnostic harness refactor).

**How to apply:** Before creating any new skill file, always use the workspace-absolute path: `/Users/ahmedomrane/Workspace/.agents/skills/<name>/SKILL.md`. More broadly: before writing to any `~/.claude/` path, run `ls -la ~/.claude/<target>` to check for a symlink. If it resolves into the workspace, write to the workspace path directly. No exceptions. Skills in `.agents/skills/` bypass the feature-branch enforcement hook. There are no per-agent copies: Codex reads `.agents/skills/` natively and Claude reads it via the `~/.claude/skills` symlink.
