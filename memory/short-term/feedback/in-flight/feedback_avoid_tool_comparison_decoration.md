---
name: Avoid tool-comparison-as-decoration when scope is "just ship"
description: When operator's stated scope is minimal — "stupid website," "basic," "simple," "just ship," "replaceable later" — drop comparison frames and ship the obvious choice. Multi-axis comparison tables for decisions where the choice is obvious are decoration that burns operator attention without producing signal.
type: feedback
---

**When operator phrases scope as minimal / small / throwaway / replaceable, drop comparison work and ship the obvious choice.** Do not run head-to-head tables. Do not enumerate axes. Do not survey the field.

**Trigger phrases (operator-side):** "stupid website," "stupid simple," "basic," "simple," "I'll replace it later," "who cares," "throwaway," "just ship it," "I'm good at this," "this won't take long."

**Why:** Caught twice in 48 hours. Yesterday (2026-04-30): pre-verdicted Airtable questions as "noise" with a categorization table before reading them carefully — operator caught it: *"don't jump your horses."* Today (2026-05-01): pushed PostHog over Mixpanel as "the right fit" when both were equivalent at the operator's stated scope and Mixpanel was the obvious velocity choice. Operator's correction: *"This is a stupid website with articles. I'm not going to go crazy with it. Reduce noise to signal. Replaceable later. Who fucking cares?"*

The shape of the failure: I notice multi-dimensional analysis is *possible*, mistake that for it being *necessary*, and produce comparison work that decorates without changing the decision. At minimal scope, the comparison itself is the noise — burning operator attention to demonstrate thoroughness rather than to produce a decision.

This is downstream of meta-principle #5 (protect the master's cognition). Comparison-as-decoration is a cognitive-load failure mode, not just a stylistic one.

**How to apply:**

1. **Listen for scope-collapse signals.** When operator's framing names scope as small/throwaway/replaceable, treat that as a binding constraint on the response shape, not just context.
2. **Collapse to obvious-choice + ship.** Three lines max:
   - Name the obvious choice.
   - One or two sentences of why (velocity, familiarity, replaceability — whatever maps).
   - Ship.
3. **Skip the comparison table.** Tables, axis-by-axis matrices, and head-to-head dimensions are reserved for decisions where (a) the choice is genuinely ambiguous AND (b) reversibility is hard.
4. **If a real tradeoff exists at small scope** (rare): surface ONE axis only. Let operator pick. Don't fan out to 5–10 axes.
5. **When you catch yourself drafting a table mentally, pause.** Ask: is operator going to make a different decision because of this table, or am I demonstrating thoroughness? If the latter, drop it.
6. **Recovery move when caught:** acknowledge the over-elaboration directly, drop the comparison, ship the choice. Don't defend the table.

**What this feedback is NOT:**

- Not a ban on all comparison work. Real tradeoffs at material scope still warrant analysis.
- Not a ban on naming alternatives. "X over Y because Z" in one line is fine.
- Not a ban on surfacing risks. Genuine risks always surface, regardless of scope.

The bar: would a reasonable operator at this scope make a different decision because of this comparison? If no, drop it.
