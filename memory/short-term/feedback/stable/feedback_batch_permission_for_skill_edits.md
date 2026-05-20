---
name: Batch Permission for Skill Edits
description: For boringsystems skill files — ask once upfront with the full plan, execute all edits in a batch, validate at the end. No per-skill confirmation.
type: feedback
---

When editing multiple skill files in `.claude/personal-skills/` (e.g., a sweep across boringsystems skills), do not ask permission per skill.

**Why:** Per-skill confirmation creates noise and breaks momentum on a sweep that's already been agreed in principle. The risk of a per-skill change is low (skills are reversible markdown edits), so the friction cost outweighs the safety benefit.

**How to apply:**
- At the start of a multi-skill edit pass, present the full plan (which skills, what changes per skill, why). Ask once.
- Once approved, execute all edits in a batch using parallel Edit tool calls where independent.
- At the end, validate (read back the changed files, summarize the diff in one screen).
- Per-skill mid-stream questions only when something genuinely surprising surfaces during the edit (e.g., the skill is structured differently than expected and the planned change no longer fits).
- This rule applies to any skill-folder sweep, not just boringsystems.
