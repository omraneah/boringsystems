---
name: No role-by-headcount framing in doctrine
description: When writing portable doctrine, strategy docs, or org-context docs, frame failure modes as structural patterns, not as missing-hire / missing-role descriptions. Role-by-headcount framing is AI-era-fragile and dates within months.
type: feedback
---

When writing doctrine, portable packs, ORG-context layers, or any document expected to survive across organizations and time horizons: name structural failure patterns, not missing hires.

Phrases like *"we didn't recruit DevOps"*, *"we need a platform engineer"*, *"the team has no head of X"* read as fragile in the AI era. A modern senior full-stack working with AI covers work that used to require a small specialist team. Documents that lean on role-by-headcount framing date themselves within months and read as operator-complaint about a specific past context rather than as portable rules.

**Why:** Surfaced 2026-05-14 during PR review of the starter-pack's `ORG-CONTEXT.md`. The first draft listed *"no DevOps hire"*, *"no platform engineering hire"*, *"junior-only team"*, *"AI-as-substitute"* as separate organizational failure modes. Ahmed stopped reading partway through — flagged the framing as misaligned with his stance and AI-era-fragile. Rewrite shifted to six universal organizational no-gos that survive multi-context scrutiny: juniors-only team, single-person retention risk + empty surfaces, over-engineering ahead of business, skipping product specs, on-the-fly as steady state, misaligned incentives.

**How to apply:**

- When writing doctrine, strategy docs, ORG-context docs, or portable packs: surface STRUCTURAL patterns, not role gaps.
- Test each failure-mode statement against the question: *"would this still be a failure in a team of one senior full-stack with AI?"* If the answer is *"no, the AI covers it"* → the failure is role-coverage-shaped, not structural. Strip or reframe.
- **Acceptable structural patterns:** incentive misalignment, knowledge concentration / single-person retention risk, decision-cycle absence, scope-vs-runway mismatch, juniors-only execution layer, prod-spec divergence, on-the-fly as steady-state operating mode.
- **Unacceptable role-coverage framing:** *"no DevOps"*, *"no SRE"*, *"no head of X"*, *"we need a specialist for Y"*, *"junior team can't because no senior in role Z"*, *"AI-assisted development as a hiring substitute"*.
- **Exception:** the operator's own retrospective on a specific past company they ran. Doctrine for a public pack is never this case.

The deeper test: every sentence in portable doctrine should survive scrutiny in *(a)* a pre-AI team, *(b)* a current AI-native team, *(c)* a hypothetical 2030 fully-agentic team. If the failure mode dissolves under any one of these, it's role-coverage-shaped, not structural.

Related: [[no-short-term-state-in-medium-term-docs]] — same family. Doctrine that has to survive time horizons cannot embed conditions that decay quickly.
