---
name: Brief Approval Gate for Context-Naive Agents
description: When composing a brief for any context-naive sub-agent — especially the strategic board, the conductor when it exists, or any Agent call where framing carries interpretive weight — draft → show verbatim → wait for explicit approval → fire only then. Never fire on first draft. The brief IS the determining variable.
type: feedback
originSessionId: 828ad82a-c6fa-438d-a875-b417dae96981
---
When composing a brief that frames a situation for a sub-agent — especially context-naive agents (the strategic advisory board, the conductor when it exists, any Agent call where framing carries interpretive weight) — never fire on first draft. Always:

1. **Draft the brief.**
2. **Show it to Ahmed verbatim** in chat, clearly delimited as a draft.
3. **Wait for explicit approval** before invoking the agent(s).
4. **Fire only after approval.**

**Why:** The brief IS the determining variable. Sub-agents respond honestly to what they're given. A wrong frame produces a confident-but-wrong diagnosis. Approval cost is low; misframe cost is high (loss of trust in the entire instrument).

**Precedent — 2026-04-26 session, two rounds of convene-board on the same question:**

- **Round 1** brief said *"the customer-facing motion ... sits aside waiting to be run."* Factually wrong — warm-graph reactivation was running at 4–5 catch-ups/week.
- All six advisors converged unanimously: *"this is avoidance of the work, park all three architectural projects."*
- Ahmed corrected the frame.
- **Round 2** brief, factually accurate, same six advisors: *"the 90/10 split is sound, run the probe, your originally-named protections are naive, here are six replacement protections."*
- Same advisors, same protocol, **opposite verdict** — driven entirely by brief quality.

The brief is the leverage point. Treat it as such.

---

## Second-layer rule — editorial stripping (always applied at draft time)

Every interpretive adjective in a brief is leakage. Examples from the same session that survived round 2 even after the factual correction: *"disciplined, high-tempo, well-running, naive, quarantined, side-door."* Context-naive agents absorb the coloring as factual and it tilts the lens before they read the question.

Discipline at draft time:

- **Facts only.** Numbers, dates, named artifacts, direct quotes from Ahmed in quotation marks, observable state.
- **No characterizations.** No "running well," "stuck," "drifting," "healthy," "disciplined." Describe the data; let the agent characterize.
- **Claude's own framing, when needed, is flagged.** *"My read of this — feel free to disagree: ..."* — explicit, not embedded mid-paragraph.
- **The approval gate gives Ahmed the chance to strip residual editorial before firing.** Even after editorial-stripping discipline is applied, the gate exists to catch what the discipline missed.

---

## When to apply the gate

Apply gate when:

- Convening the strategic board (always — the lens is the value, the brief is the leverage).
- Sub-agent doing strategic synthesis (Sofia's deliverables, conductor invocations, Naomi/Hadi/Daniel/Margaret on situational framing).
- Any context-naive agent receiving multi-paragraph framing.
- After Ahmed has corrected framing and Claude is re-drafting (re-drafts inherit the original framing instinct — the gate is the correction).

Do NOT apply gate (overhead unjustified):

- Explore agent searching the codebase for a keyword.
- Bash for `git status`, `ls`, mechanical lookups.
- Self-contained tactical delegations with no interpretive framing.

**Rule of thumb:** if the agent's output will inform a decision Ahmed will rely on, the brief gates. If it's a lookup, it doesn't.
