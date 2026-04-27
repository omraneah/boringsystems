---
title: "Engineering Principles That Outlive the Stack"
description: "Frameworks turn over. Languages cycle. Cloud primitives get rebranded. The seven dimensions of engineering practice underneath are stack-orthogonal — true on bare metal, true on Kubernetes, true on whatever the agent-native runtime turns out to be in 2028."
date: 2026-04-27
order: 2
---

Frameworks turn over every two years. Languages cycle. Cloud primitives get rebranded. The stack you wrote against in 2022 is half-deprecated; the one you'll write against in 2027 hasn't shipped yet. None of that is the bottleneck.

The bottleneck is the practice layer underneath all of it — the seven invariants that govern how any team, in any language, on any stack, ships software that doesn't fall over. They were true on bare metal, they're true on Kubernetes, they will be true on whatever the agent-native runtime turns out to be in 2028. Stack-orthogonal by construction.

This piece is the practice layer, written tight. Not a values poster — each dimension is enforceable in review, and violations are defects in how work is done, not opinions to be respected. One bar applies: engineers and AI tools follow the same practice boundaries when contributing, reviewing, or generating code. The asymmetry where humans-write-careful-code and machines-generate-best-effort-code does not survive 2026. The bar is the bar.

## What this is, and what it isn't

This is not the architecture layer. The boundaries themselves — auth, multi-tenancy, IAM, module communication, infrastructure-as-code — are their own craft surface and belong in their own document. The seven dimensions below sit underneath the architectural ones: they shape *how* a team writes code regardless of *what* the code is talking to. Principle 1 below is the discipline of respecting whatever architectural boundaries exist; it is not a debate about which boundaries to draw.

---

## 1. Architecture and boundaries

Check architectural boundaries before implementation. Boundaries are constraints, not suggestions. Violations are rejected in review.

The discipline is procedural. Read the boundary documents. Compare the planned approach against every relevant boundary. Never assume compliance without checking. If a boundary is in the way, surface it and resolve it structurally — don't bypass it via workarounds, exclusions, or silencing.

The hardest version of this rule: do not build on top of major degradation. If an area carries known boundary violations, large tech debt, or instability, stop and escalate with options. Building features on top of broken foundations multiplies the eventual rewrite, and the rewrite always comes due.

## 2. Separation of concerns

Business logic lives in the backend or API. Clients consume APIs and handle presentation only.

The most common drift: validation logic that started in the API gets duplicated into the client because it was easier than waiting for the API team to add it. Six months later, the rules diverge, the client copy is stale, and the bug looks like a backend issue when the source is a client-side guess.

The backend is the single source of truth for domain rules. Clients render. That is the line.

## 3. Root cause and fixes

Identify the root cause before fixing. Avoid workarounds and silencing unless explicitly approved.

The shape of this failure: a check fails, the engineer disables the check, the failure goes away, the underlying defect ships. A retry loop wraps an exception that should never have happened, and the bug becomes invisible to monitoring. A test gets marked flaky and skipped, and now the regression has no detector.

When a short-term workaround is genuinely unavoidable, document it and escalate. Workarounds are tracked debt, not normalized state.

## 4. Planning and reviewability

Share plans early for non-trivial work. Prefer small, reviewable changes — split structurally when a unit grows complex.

The reviewer's job has to be tractable. A 4,000-line PR that touches eight modules cannot be reviewed; it can only be approved. Splitting the same work into five focused PRs keeps the review surface honest, and it keeps the rollback unit small when something turns out wrong in production.

Reviews spread knowledge. Treat them as alignment and learning, not gatekeeping. Ask for help when stuck. Estimates are forecasts, not promises — communicate uncertainty rather than treating an estimate as a contract.

## 5. Code quality

Three rules carry the load.

**Small, well-named units.** Files and modules stay reviewable. Functions stay short and focused. Avoid god objects. Use explicit types — no untyped APIs. Define named constants for literals; no magic numbers, no unexplained strings. Function and variable names reveal intent.

**KISS and YAGNI.** Simplest solution that meets the requirement. No speculative complexity, no future-proofing for requirements that haven't shown up. Everything is a trade-off; choose the option that is practical and aligned with boundaries, not the one that lets you fall in love with your own design. Every line of code and every dependency is a liability — add only when the benefit clearly outweighs the long-term cost.

**DRY.** No duplicated logic across layers or repos. Centralise in one place, treat that place as the source of truth, and resist the temptation to "just copy it once." Two copies become four; four become drift.

## 6. Documentation and traceability

Document non-obvious decisions and the rationale behind them. Commit messages explain what and why, not just what changed.

The test for whether a comment earns its place: would a future engineer reading this code be surprised by it without context? If yes, the rationale belongs near the code. If no, the comment is noise. Decision records — short, archived, linkable — carry the heavier reasoning.

Commit messages are a debugging tool. "Fix bug" is useless six months later when you're git-blaming a regression. "Switch from X to Y because we hit cycle Z" is searchable, reviewable, and saves an hour every time someone re-encounters the trade-off.

## 7. Testing

Test behaviour that matters. Leave tests better than you found them. Triage flaky or failing tests instead of ignoring them.

The discipline is composable. When touching code, improve test coverage or clarity of the area you're in — boy-scout rule, applied to tests rather than to comments. Tests are first-class production code: same naming standards, same maintainability standards, same expectation of being readable months later.

Flaky tests are worse than no tests. They train the team to ignore failures, which guarantees that the next real failure also gets ignored. Either fix the flake, isolate it with a tracked follow-up, or delete it. Skipping it permanently with no plan is the failure mode that ships outages.

---

## What this enables

These seven dimensions don't ship features. They make features shippable. A team that respects them moves slower for the first two months and dramatically faster forever after, because every decision compounds into a codebase that stays reviewable, debuggable, and trustworthy.

A team that violates them in month one ships month-one's work fast and pays interest on the violation in months four through forty. This is not a moral claim. It is the long-run distribution of where engineering time actually goes.

## Closing

Stacks are interchangeable. Practice is not. Anything you build on top of these seven invariants survives the next migration; anything you build around them gets rewritten when the framework changes its mind.

The orchestration layer that wraps a modern coding agent — skills, hooks, memory, sub-agents, the harness around the model — has its own set of invariants, downstream of these but with their own logic. Those are in the companion piece: *[Orchestration Principles That Outlive the Model](/en/writing/orchestration-principles-that-outlive-the-model)*. The agent that helps you write the code follows the same practice bar described above; the orchestration around the agent follows six additional principles that handle what the agent itself cannot.
