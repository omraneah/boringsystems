---
name: gtm-sync
description: Capture go-to-market signal — LinkedIn edits, new DM patterns, positioning iterations, offer refinements, inbound clustering — into the `go-to-market/` folder. Use when a conversation surfaces anything that changes how Ahmed shows up in the market or how the market is responding. Also use as a periodic reconciliation pass when inbound has been landing without being logged.
model: opus
effort: high
---

# gtm-sync

Pulls go-to-market signal out of a conversation and proposes specific updates to the `go-to-market/` folder. **Proposes** — never writes silently. Ahmed reviews and approves the diff.

## When to invoke

Automatically:

- The user describes a new DM, reach-out, referral, call outcome, or rejection.
- The user edits their LinkedIn headline or bio, or describes a change they're considering.
- The user articulates a new freelance offer, refines pricing logic, or sunsets an offer.
- The user states a new market hypothesis, or reality has invalidated an existing one.
- A conversation surfaces pricing, positioning, or market-framing insight that doesn't fit elsewhere.
- The user describes their gut feel on a market direction — freelance vs. full-time, solo vs. team, niche vs. horizontal.

Proactively:

- At the end of a session that discussed go-to-market topics but did not end in an update to `go-to-market/`.
- Before a hypothesis re-evaluation date (listed in `hypotheses.md`).

Do **not** invoke for:

- Strategic identity / inner-game content — that belongs in `llm-context-2026/`, not here.
- Site-level content decisions (persona doctrine, article voice) — that belongs in `boringsystems/docs/`.
- Tactical decisions about a single article — that belongs in the article's frontmatter or in Linear.

## What it does

1. **Read the current state** of every file under `go-to-market/`:
   - `README.md`, `linkedin.md`, `offers.md`, `hypotheses.md`, `signals.md`.
2. **Extract the signal** from the triggering conversation. Classify it into one of:
   - LinkedIn positioning edit → `linkedin.md`.
   - Offer shape / pricing / target-buyer change → `offers.md`.
   - New hypothesis or invalidation → `hypotheses.md`.
   - Inbound data point → `signals.md`.
   - Cross-cutting market observation → propose location (usually `hypotheses.md` with a new entry).
3. **Propose a specific diff.** Name the file, the section, and the exact text to add/modify. For `linkedin.md`, always preserve the prior version in the change log.
4. **Check invariants.**
   - Every hypothesis still has an invalidation trigger and a re-evaluation date.
   - Every entry in `signals.md` follows the terse one-entry format from the `## How to log` block.
   - `README.md` quick-snapshot block stays ≤8 bullets.
   - If an offer is added or removed, `hypotheses.md` H4 ("three offers in parallel") is revisited in the same update.
5. **Ask before writing.** Present the proposed diff to Ahmed. Only write after explicit approval.

## Output format

```
GTM signal detected: <one-line classification>

Proposed update → <file path>

<concrete diff — either a patch-style block, or a clearly-delimited "add this" block>

Invariant check: <pass | flag any broken invariants>

Approve?
```

## What NOT to do

- Do not infer Ahmed's positioning from silence. If the signal is ambiguous, ask a clarifying question before proposing.
- Do not batch unrelated signals into a single omnibus update. One signal → one proposed update.
- Do not edit `llm-context-2026/` from this skill, even when the signal touches strategic identity. Flag the crossover and let Ahmed decide.
- Do not touch boringsystems content from this skill. GTM and site IA are coupled but edited on different branches in different repos.
- Do not auto-delete invalidated hypotheses. Move them to the `## Retired / invalidated hypotheses` section with a one-paragraph post-mortem.
