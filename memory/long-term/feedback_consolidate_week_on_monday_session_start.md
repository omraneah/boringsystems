---
name: Fire /consolidate-week on Monday Session Start
description: At the start of every session, check if today is Monday AND if the consolidation for this week has not yet been run. If both true, fire /consolidate-week. Skills do not self-trigger on session start; this rule is what wires the weekly cadence into Claude's startup loop without requiring a hard SessionStart hook.
type: feedback
---

**At session start, if today is Monday AND there is no consolidation file dated today in `memory/short-term/<this-week>/consolidation.md`, fire the `/consolidate-week` skill.** This is the closed-loop self-correction trigger for the tiered memory architecture.

**Why:** The weekly consolidation is the load-bearing operation of the tiered memory system. Without it, tiers freeze and become stale. The orchestration principle "the system corrects itself" depends on this being reliable, not manual. v1 ships this as a behavioural rule (faster to ship, easier to debug). v2 may promote to a hard SessionStart hook in `.claude/settings.json` if it gets missed in practice.

**How to apply:**

1. **At session start (before responding to user's first message):**
   - Get today's date and weekday.
   - If weekday ≠ Monday → skip this rule entirely. Proceed normally.

2. **If today is Monday:**
   - Calculate the current ISO week folder name: `<YYYY-Www>`.
   - Check if `memory/short-term/<this-week>/consolidation.md` exists.
   - If it exists, check the creation date in its frontmatter or first line.
   - If the file does not exist OR its date is before today → fire `/consolidate-week`.
   - If the file exists with today's date → already done; skip.

3. **Firing the skill:**
   - Inform Ahmed in one short message: "Today is Monday and last week's consolidation hasn't been run yet. Firing `/consolidate-week`."
   - Then proceed with the skill.

4. **Cost calibration:**
   - Over-firing (e.g. firing twice on the same Monday) is prevented by the date check.
   - Under-firing (e.g. weekday detection error) costs a missed week — recoverable via manual `/consolidate-week` later.

**Companion:** the `/consolidate-week` skill, which contains the actual consolidation logic. This rule only handles the trigger; the skill handles the work.
