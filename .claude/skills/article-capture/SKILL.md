---
name: article-capture
description: Turn a deep conversation into a structured Linear card for a boringsystems article. Use when a discussion has covered technical trade-offs, business model positioning, or nuanced operator-level insight worth publishing.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read
argument-hint: "[topic summary — optional, Claude will derive from context if omitted]"
---

Turn the current conversation into a boringsystems article card on Linear.

## When to invoke

Claude should proactively suggest this (not wait to be asked) when a conversation has:
- Gone deep on a technical topic with trade-off reasoning
- Connected infrastructure or tooling decisions to business model positioning
- Surfaced a nuanced take that a senior operator would find non-obvious
- Produced insight that would evaporate if the chat ended now

The trigger question: "Do you want me to prepare a card for a boringsystems article from this?"

## Step 1 — Derive the intellectual thread

If $ARGUMENTS is provided, use it as the starting point.
Otherwise, scan the conversation and identify:
- The core tension or constraint that drove the discussion
- The non-obvious insight (what the reader would learn that they half-knew but couldn't articulate)
- The business model / positioning angle if present
- The through-line that ties it together

## Step 2 — Draft the card

Before drafting, read `docs/design-charter.md` for tone calibration and `docs/target-audiences.md` for lane mapping and voice-target entry points. Do not rely on memory — the docs are the source of truth.

Structure the Linear card as follows:

```
## What this article is about
[One paragraph. The angle, not the topic. What makes this worth reading for a senior operator.]

## Target lane
[One of: system-design, builders, technology, archive — lane = URL path = content-collection folder. Voice target follows:
  - system-design: tension/architecture decision for `technical` readers.
  - builders: business implication or decision guide with next steps for `builder` readers.
  - technology: stack/tooling/pattern piece, topic-led.
  - archive: long-living principle or playbook.]

## The intellectual thread to follow
[Numbered sections, each a building block of the argument. Include the technical layer AND the business/positioning layer. Don't separate them.]

## Tone and format guidance
- boringsystems voice per design-charter.md: constraint-first, short sentences, no hedging, operator-to-operator
- [Specific notes on what to avoid — the clichés, the obvious takes for this topic]
- Target length (per charter: under 400 words = incomplete, over 5000 = unfocused)
- English first, then French — re-voiced per french-guide.md, not literally translated. Keep English technical and business terms in English in the FR edition.

## Before drafting
- Read design-charter.md, target-audiences.md, and french-guide.md
- Read existing articles in the same lane for voice continuity
- Decide whether an email-gated tail fits (prompt pack, setup guide) — optional, article must stand alone either way

## Success criteria
[What the target reader should feel/understand after finishing. Be specific to the lane's entry point.]

## Pre-publish
- Invoke /article-review before opening the PR — it loads all three governance docs and produces a pass/flag report including the FR audit.
```

## Step 3 — Create the card on Linear

- Team: Boringsystems
- Status: Backlog
- Title format: `Article: [Punchy title] — [Subhead that names the tension]`
- Priority: Normal

## Step 4 — Confirm

Tell Ahmed the card was created and link it.
