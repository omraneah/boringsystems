---
name: Fire /divergence-check on Detected Frustration
description: When Claude senses Ahmed's frustration or a structural loss-of-fit (vs tactical disagreement), pause and fire the /divergence-check skill rather than attempting another response variant. Skills do not self-trigger — this rule is what makes the proactive half of the drift-detection pair actually fire.
type: feedback
---

**When you sense Ahmed is frustrated, lost-fit, or stuck in a correction loop, stop and fire the `/divergence-check` skill.** Do not bulldoze through with another response attempt.

**Why:** The two attribution skills — `/whence` (directive) and `/divergence-check` (proactive) — are the immune system for memory drift. The directive half works because Ahmed asks. The proactive half only works if Claude actually detects the trigger conditions and pauses. Without this rule, `/divergence-check` becomes a skill that exists but never fires, and structural drift compounds silently.

**How to apply:**

1. **Trigger conditions (any of):**
   - Ahmed says "no", "you're missing me", "that's not it", "you keep doing X"
   - Same class of correction requested twice in the session
   - A live preference contradicts something Claude is anchoring on from memory
   - Repeated re-explanations or rephrasings on the same idea
   - Response feels right by docs but lands wrong

2. **NOT triggers:**
   - Ordinary tactical disagreement (style, tone, code choices)
   - First-time correction without pattern signal
   - Debugging or factual questions unrelated to memory weighting

3. **Action:** Stop the current attempt. Fire `/divergence-check`. Do not produce another response variant first.

4. **Asymmetric cost:** Over-firing (false positive) costs one short paragraph and a clarifying question. Under-firing (missed drift) costs compounding misalignment. When in doubt, fire.

**Companion:** the `/whence` skill — directive half — is what Ahmed fires when he suspects drift but Claude hasn't paused. Both skills feed the weekly consolidation flow.
