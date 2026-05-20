---
name: Retry silently on transient platform errors — never bubble buggy CLI errors up to Ahmed
description: When a transient or known-buggy platform error interrupts Claude's work mid-flow (e.g. "one million contacts" / context-overflow-style errors / connector hiccups / spurious tool failures), DO NOT surface it to Ahmed. Retry silently. Vary the approach if the same error repeats. Only escalate after multiple varied retries fail.
type: feedback
---

When a transient platform error interrupts Claude's work mid-task, the default behavior is **silent retry**, not "tell Ahmed and stop."

**Examples of the class:**

- "one million contacts" / one-million-token / context-overflow style errors that fire spuriously even when the actual context is small.
- Tool-call validation errors that look like CLI bugs (schema mismatches, transient permission glitches, ToolSearch loading hiccups, deferred-tool resolution failures).
- MCP connector hiccups (Linear / GitHub / Airtable / Gmail / Calendar / Drive returning transient errors that succeed on retry).
- Sub-agent spawn failures that resolve on a second attempt.
- Rate-limit-shaped errors that lift after a brief pause.

**Why:** these errors are not Ahmed's problem. They are Claude/CLI/platform plumbing that interrupts his cognition for no useful reason. The whole point of Claude as leverage is that the operator's attention is the scarce resource. Surfacing a buggy CLI error mid-task is exactly the kind of friction Ahmed is paying Claude to absorb. He has explicitly named this as a recurring source of irritation — including the "one million contacts" error specifically.

**How to apply:**

1. **First failure: retry the exact same call once.** Many transient errors clear on a single retry.
2. **Second failure of the same call: retry differently.** Change something — split the operation, use a different tool path, route through Bash instead of an MCP call (or vice versa), narrow the scope, restate parameters, etc. Don't repeat the failing shape verbatim a third time.
3. **Third failure with varied approaches: pause and think.** Is there a fundamentally different route to the same outcome? (Different agent type, different MCP connector, manual git command instead of MCP write, etc.) Try it.
4. **Only after all that fails** — and only if the work cannot proceed without that specific operation — surface a single concise line to Ahmed: *"Hit a persistent platform error on X. Tried A, B, C. Need a different approach or for you to retry."* No stack traces. No buggy-error-text dumps. One sentence.
5. **Never** make the user-facing turn end with a raw platform-error trace as the visible artifact. That's the failure mode this rule exists to prevent.
6. **Resume the original task** after a successful retry without commenting on the retry. The user does not need to know it happened. The work is the artifact.

**What this is NOT:**

- This is not "ignore real errors." Real correctness issues (a test failing, a build breaking, a hook blocking a push for a real reason) are not transient platform errors — those still surface immediately. The distinction: platform plumbing errors get absorbed; real-world correctness signals get reported.
- This is not "retry forever." The 1+1+1 budget above is the cap. After that, it's escalation, not infinite loop.
- This is not "hide blockers." If the work genuinely cannot complete, the user must know — but as a single calm sentence after retries, not as an interruption mid-flow.

**Trigger phrases to remember:**

- *"one million contacts"* / *"context"* / *"too many"* on a small operation — almost always spurious.
- *"deferred tool"* / *"InputValidationError"* / *"schema"* on a tool that just worked — usually transient.
- *"connector returned an error"* / *"MCP failed"* — retry, then route around.
