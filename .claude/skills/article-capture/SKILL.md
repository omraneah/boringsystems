---
name: article-capture
description: Turn a deep conversation into a structured Linear card for a boringsystems article. Use when a discussion has covered technical trade-offs, business-model positioning, or nuanced operator-level insight worth publishing. Critically — pick the right lane (Writing / Work / Building / Archive) before drafting; this skill enforces the placement decision.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read
argument-hint: "[topic summary — optional, Claude will derive from context if omitted]"
---

Turn the current conversation into a boringsystems article card on Linear.

## When to invoke

Claude should proactively suggest this (not wait to be asked) when a conversation has:
- Gone deep on a technical topic with trade-off reasoning
- Connected infrastructure or tooling decisions to business-model positioning
- Surfaced a nuanced take that a senior operator or builder would find non-obvious
- Produced insight that would evaporate if the chat ended now

The trigger question: "Do you want me to prepare a card for a boringsystems article from this?"

---

## Step 1 — Pick the lane FIRST

**This is the single most important step. Get this wrong and the article lands in the wrong place, the wrong voice, and the wrong URL.**

There are four lanes. Each has a distinct content type. A piece belongs to exactly one. Walk the decision tree in order:

### Decision tree

1. **Is this a case study or retrospective of real past work Ahmed did for someone?** (An engagement, a migration, a transformation, a past CTO/VP/IC stint.)
   → **Work**. URL: `/{lang}/work/<slug>`. Collection: `work-{lang}/`.

2. **Is this about something Ahmed is building right now, in the open, with live commentary on the decisions being made?** (boringsystems itself, portfolio apps, Claude skills, personal tools, live stack experiments.)
   → **Building**. URL: `/{lang}/building/<slug>`. Collection: `building-{lang}/`.

3. **Is this a long-living principle, operating playbook, or doctrinal piece** — slower-changing, returnable reference material, not time-stamped?
   → **Archive**. URL: `/{lang}/archive/<slug>`. Collection: `archive-{lang}/` (under `operating-playbooks/series-{N}-{name}/` subfolder on disk; URL is still flat). Note: Ahmed writes new archive pieces rarely — most content is not Archive.

4. **Everything else** — thinking pieces, decision guides, frameworks, tactical advice, diagnosis of a specific question founders/operators/builders face.
   → **Writing**. Default lane. URL: `/{lang}/writing/<slug>`. Collection: `writing-{lang}/`. **Most new articles land here.**

### Common miscalls (watch out)

- A piece that uses stories from past engagements but is framed as "here's how I'd approach X" → **Writing**, not Work. Work is retrospective; Writing is prescriptive.
- A piece that names Ahmed's current stack or tools but uses it as evidence for a broader argument → **Writing**. Only true "I'm building this right now, here's the decision I just made" pieces go to Building.
- A piece titled "Principles of X" → usually **Writing**, not Archive. Archive is specifically the operating-playbooks series (`s1-*`, `s2-*`, `s3-*` format). New principle pieces would need a new series to go to Archive; otherwise they're thinking pieces → Writing.

### Name the lane in the card

The card must state the lane explicitly. If you can't decide between two lanes, stop and ask Ahmed — don't guess.

---

## Step 2 — Pick the voice target

Lane is *where* the piece lives. Voice target is *who* the piece is written to. Voice target is per-piece and does not appear in frontmatter — it's captured in the Linear card as a drafting brief.

Two voice targets, defined in `docs/target-audiences.md`:

- **`technical`** — CTOs, VPs of Engineering, Staff engineers, technical founders. Opener names a technical tension. Skip background. Assume vocabulary.
- **`builder`** — Entrepreneurs, intrapreneurs, solopreneurs, non-technical founders, business operators. Opener names a business stake or the decision. Define central terms once. Take a position on the common case.

A piece in **any** lane can target **either** voice. Pick one per piece — never both.

Rule of thumb:
- Writing → usually `builder` (conversion lane), sometimes `technical`.
- Work → usually `technical` (case studies read peer-to-peer), sometimes `builder` if the operational story is the point.
- Building → usually `technical` or cross-cut (peer builders + sponsors).
- Archive → cross-cut (principles serve both).

---

## Step 3 — Derive the intellectual thread

If `$ARGUMENTS` is provided, use it as the starting point.
Otherwise, scan the conversation and identify:
- The core tension or constraint that drove the discussion
- The non-obvious insight (what the reader would learn that they half-knew but couldn't articulate)
- The business-model / positioning angle if present
- The through-line that ties it together

---

## Step 4 — Draft the card

Before drafting, read `docs/design-charter.md` for tone calibration and `docs/target-audiences.md` for voice-target entry points. Do not rely on memory — the docs are the source of truth.

Structure the Linear card as follows:

```
## What this article is about
[One paragraph. The angle, not the topic. What makes this worth reading for the target reader.]

## Lane (placement)
[One of: writing, work, building, archive. State the decision-tree step that landed it here.]

Path on disk: src/content/<lane>-{en,fr}/<slug>.md(x)
URL: /{lang}/<lane>/<slug>

## Voice target (per-piece calibration)
[One of: technical, builder. From target-audiences.md. Name the entry point that matches:
  - technical: names the technical tension / architecture decision / trade-off immediately.
  - builder: names the business implication or operational consequence in paragraph 1,
    with a clear "what to do" orientation toward the end.]

## The intellectual thread to follow
[Numbered sections, each a building block of the argument. Include the technical layer
AND the business/positioning layer. Don't separate them.]

## Tone and format guidance
- boringsystems voice per design-charter.md: constraint-first, short sentences, no hedging, operator-to-operator
- [Specific notes on what to avoid — the clichés, the obvious takes for this topic]
- Target length (per charter: under 400 words = incomplete, over 5000 = unfocused)
- English first, then French — re-voiced per french-guide.md, not literally translated. Keep English technical and business terms in English in the FR edition.

## Before drafting
- Read design-charter.md, target-audiences.md, and french-guide.md
- Read existing articles in the same lane for voice continuity
  - writing: the other /writing articles, for thinking-piece register
  - work: the other /work case studies, for retrospective register
  - building: the other /building pieces (or Writing pieces when Building is empty), for active-tense register
  - archive: the existing operating-playbooks series
- Decide whether an email-gated tail fits (prompt pack, setup guide) — optional, article must stand alone either way. Tails live most naturally on Writing pieces targeting `builder`.

## Success criteria
[What the target reader should feel/understand after finishing. Be specific to the voice target's entry point.]

## Pre-publish
- Invoke /article-review before opening the PR — it loads all three governance docs and produces a pass/flag report including the FR audit.
```

---

## Step 5 — Create the card on Linear

- Team: Boringsystems
- Status: Backlog
- Title format: `Article: [Punchy title] — [Subhead that names the tension]`
- Priority: Normal
- Include the Lane line (from Step 4) in the description so the drafting session knows where the file goes.

## Step 6 — Confirm

Tell Ahmed the card was created, link it, and state the lane decision in one sentence so he can catch a miscall before drafting starts.
