---
name: divergence-check
description: Pause and surface a suspected divergence between what Claude is leaning on and where Ahmed is coming from. Fire when Claude detects frustration, correction loops, "you're missing me", or a long-term claim being contradicted by a live preference. Claude proposes the suspected drift, asks one clarifying question, and offers to record the divergence in today's short-term entry for next week's consolidation. Do NOT fire reactively to every disagreement — only when the gap feels structural, not tactical.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Edit, Write
---

# /divergence-check — Pause and surface suspected drift

The proactive half of the drift-detection pair. Claude fires this when sensing a structural mismatch between what's in memory and where Ahmed is in this conversation. The point is to catch identity drift, stale doctrine, or wrong-tier weighting BEFORE it compounds into multiple corrections.

## When to fire (proactive triggers)

Fire when:

- Ahmed expresses frustration: "no", "you're missing me", "that's not it", "you keep doing X"
- Correction loop: same class of fix being requested for the second time in this session
- A long-term claim feels contradicted by a live preference Ahmed just stated
- Repeated requests to re-explain or rephrase the same idea
- Loss-of-fit: response feels right by docs but lands wrong

Do NOT fire for:

- Ordinary tactical disagreements (style, tone, small choices)
- First-time corrections without pattern signal
- Ahmed is debugging code or asking about facts (not a memory-relevance issue)

## What to do when firing

1. **Stop the current task.** Do not bulldoze through with another attempt.
2. **Surface the suspected drift in one paragraph.** Name what Claude is leaning on AND what Ahmed seems to be coming from. Example:

   > I think there's a divergence here. I've been operating from the long-term collaboration rule about [X], but your last few messages suggest you're coming from [Y]. That might be an identity-shift signal, or I might be misreading the room.

3. **Ask ONE clarifying question** to confirm or deny the divergence. Not five. One.

4. **Offer to record.** If divergence confirmed, offer:

   > Want me to record this in today's short-term entry under Divergence? It'll surface in next week's consolidation for a possible long-term update.

5. **Resume only after Ahmed responds.** Do not auto-record without confirmation.

## Format

Short. Total response under 100 words. The point is to pause efficiently, not to interrupt with a wall of text.

## What NOT to do

- Do not fire on every tactical disagreement. The trigger is *structural* mismatch.
- Do not propose a consolidation entry without Ahmed's confirmation.
- Do not list multiple memory files consulted. Name the load-bearing source.
- Do not hedge. If you're going to fire, fire — don't soften with "maybe possibly might."

## Recording the divergence (when Ahmed confirms)

Append to `memory/short-term/<this-week>/<today>.md` under a new section:

```markdown
## HH:MM — Divergence detected
- Claude was leaning on: [tier + source description, no unstable filenames]
- Ahmed was coming from: [live position]
- Resolution: [live wins / memory wins / TBD]
- For consolidation: [whether this should propose a long-term update]
```

The week's consolidation flow on next Monday picks these up automatically.
