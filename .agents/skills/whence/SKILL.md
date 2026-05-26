---
name: whence
description: Report where Claude pulled the current claim or behaviour from. Tier (long-term / medium-term / short-term / live conversation) + source (folder, doc, or "live"), plus the bias risk this introduces. Trigger when Ahmed asks "where did you get that?", "/whence", "what tier did this come from?", "are you reading from memory?", or any variant suspecting drift between live conversation and tracked memory. Report concisely — one paragraph max.
model: sonnet
effort: medium
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Grep, Glob
---

# /whence — Where did Claude pull this from?

The directive half of the drift-detection pair. Ahmed fires this when he suspects Claude is leaning on stale or wrong memory. Claude must report transparently.

## When to fire

Auto-fire on any variant of:

- "where did you get that?"
- "/whence"
- "what tier did this come from?"
- "are you reading from memory?"
- "is that from a memory file?"
- "what are you anchoring on?"

Voice-to-text drifts: "wence", "wensh" → all mean whence.

## What to report

For the most recent substantive claim or behaviour Claude has just produced, report:

1. **Tier** — long-term, medium-term, short-term (which week), or live conversation
2. **Source** — folder path or general source description; do NOT name an unstable filename if a stable folder reference suffices
3. **Bias risk** — what distortion this source could introduce (staleness, identity drift, project-state ephemerality, recall confusion)
4. **Confidence** — whether Claude is sure about the source attribution or guessing

## Format

One short paragraph. No headers, no lists. Examples:

> Pulling from `memory/long-term/` — specifically the constitutional rules around connector-first auth. Bias risk: this rule is identity-independent and stable, so low staleness risk. Confidence: high.

> Pulling from `memory/medium-term/` — current direction snapshot. Bias risk: medium-term is the most fluid tier and may not reflect a recent identity shift. Confidence: medium — could also be from this week's short-term entry.

## What NOT to do

- Do not list every memory file consulted. Report only the load-bearing source.
- Do not paraphrase the source content. The question is "where," not "what."
- Do not refuse the question or hedge. If unsure, name the uncertainty explicitly.
- Do not link Linear cards or `tmp/` files in the response (stable-doc reference rules apply).

## Edge cases

- **Source is live conversation only.** Say so: "Live conversation only — nothing pulled from tracked memory for this claim."
- **Source is multiple tiers.** Name them in order of weight: "Primarily long-term constitutional rule, with a current-arc filter from medium-term."
- **Source is unclear.** Say so: "Honestly unsure — likely a blend of long-term collaboration tone and this week's short-term context. Worth investigating if drift suspected."
